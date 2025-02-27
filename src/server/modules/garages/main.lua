local GARAGES <const> = lib.load('data.garages.garages')

local awaitingResponses = {}

local function getVehicleParkState(vehicleId)
    local data = MySQL.single.await('SELECT stored, parking FROM owned_vehicles WHERE vehicleId = ?', { vehicleId })
    if not data then return false, false end

    return data.stored, data.parking
end

local function setVehicleStored(vehicleId, state, garage)
    MySQL.update.await('UPDATE owned_vehicles SET stored = ?, parking = ? WHERE vehicleId = ?',
        { state, garage, vehicleId })
end

lib.callback.register('garage:server:parkIn', function(playerId, garageKey)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return false, 'Player not found' end

    local vehicle = GetVehiclePedIsIn(GetPlayerPed(playerId), false)
    if not vehicle then return false, 'You need to be in a vehicle to park it.' end

    local vehicleId = Entity(vehicle).state.vehicleId
    if not vehicleId then return false, 'Vehicle not found' end

    local garage = GARAGES[garageKey]
    if not garage then return false, 'Garage not found' end

    if not Shared.functions.includes(garage.allowedTypes, GetVehicleType(vehicle)) then
        return false, 'This vehicle type is not allowed in this garage.'
    end

    local distance = #(xPlayer.getCoords(true) - garage.coords.xyz)
    if distance >= 100 then return false, 'You are too far from the garage.' end

    local stored = getVehicleParkState(vehicleId)
    if stored ~= PARK_STATES.NONE then return false, 'Vehicle is already parked.' end

    setVehicleStored(vehicleId, PARK_STATES.GARAGE, garageKey)

    return true, 'Vehicle parked successfully.'
end)

lib.callback.register('garage:server:parkOut', function(playerId, garageKey, vehicleId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return false, 'Player not found' end

    local garage = GARAGES[garageKey]
    if not garage then return false, 'Garage not found' end

    local distance = #(xPlayer.getCoords(true) - garage.coords.xyz)
    if distance >= 100 then return false, 'You are too far from the garage.' end

    local vehicle = MySQL.single.await('SELECT * FROM owned_vehicles WHERE vehicleId = ?', { vehicleId })
    if not vehicle then return false, 'Vehicle not found' end

    if vehicle.stored ~= PARK_STATES.GARAGE or vehicle.parking ~= garageKey then
        return false, 'Vehicle is not parked in this garage.'
    end

    setVehicleStored(vehicleId, PARK_STATES.NONE)

    awaitingResponses[playerId] = vehicleId

    return true, 'Vehicle retrieved successfully.'
end)

lib.callback.register('garage:server:getVehicles', function(playerId, garageKey)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return false, 'Player not found' end

    local garage = GARAGES[garageKey]
    if not garage then return false, 'Garage not found' end

    local distance = #(xPlayer.getCoords(true) - garage.coords.xyz)
    if distance >= 100 then return false, 'You are too far from the garage.' end

    local vehicles = MySQL.query.await(
        'SELECT vehicleId, plate, vehicle FROM owned_vehicles WHERE stored = ? AND parking = ?', {
            PARK_STATES.GARAGE, garageKey
        })

    return Shared.functions.mapTable(vehicles, function(vehicle)
        return {
            vehicleId = vehicle.vehicleId,
            props = json.decode(vehicle.vehicle),
            plate = vehicle.plate,
        }
    end)
end)

RegisterServerEvent('garages:server:setVehicleAsSpawned', function(networkId)
    local playerId = source
    local vehicleId = awaitingResponses[playerId]
    if not vehicleId then return end

    local entityExists, vehicle = pcall(lib.waitFor, function()
        local entity = NetworkGetEntityFromNetworkId(networkId)

        if entity > 0 then return entity end
    end, '', 10000)

    if not entityExists then return print('WHYYYYYY') end

    Entity(vehicle).state.vehicleId = vehicleId
    awaitingResponses[playerId] = nil
end)
