---@type table<string, VehicleRental>
local VEHICLE_RENTALS <const> = lib.load('data.vehicleRental.vehicleRental')
local awaitingResponses = {}
local awaitingItems = {}
local currentRentals, n = {}, 1
local currentRentalsByVehicleId = {}

lib.callback.register('vehicleRental:server:rentVehicle', function(playerId, key, model, duration, method, label)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return false, 'Player not found!' end

    local vehicleRentalData = VEHICLE_RENTALS[key]
    if not vehicleRentalData then return false, 'Vehicle rental not found!' end

    local vehicleData = vehicleRentalData.items[model]
    if not vehicleData then return false, 'Vehicle not found!' end

    local price = vehicleData.pricePerMinute * duration
    if xPlayer.getAccount(method)?.money < price then return false, 'Insufficient funds!' end

    if vehicleData.contract then
        local time = { os.time(), os.time() + duration * 60 }
        local metadata = {
            rental = key,
            model = model,
            duration = duration,
            startTime = time[1],
            endTime = time[2],
            description = ('**Rental:** %s  \n**Model:** %s (%s)  \n**Duration:** %s minutes  \n**Start:** %s  \n**End:** %s')
                :format(
                    vehicleRentalData.label, label,
                    model, duration, os.date('%d.%m.%Y %H:%M:%S', time[1]),
                    os.date('%d.%m.%Y %H:%M:%S', time[2])),
        }
        if not exports.ox_inventory:CanCarryItem(playerId, 'vehicle_rental_contract', 1, metadata) then
            return false,
                'Not enough space in inventory!'
        end

        awaitingItems[playerId] = metadata
    end

    xPlayer.removeAccountMoney(method, price, ('%s: %s'):format(vehicleRentalData.label, model))
    awaitingResponses[playerId] = model

    return true, 'Rental successfull!'
end)

RegisterServerEvent('vehicleRental:server:setVehicleAsOwned', function(model, props, networkId)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return end

    local awaitingResponse = awaitingResponses[playerId]
    if not awaitingResponse then return end

    if awaitingResponse ~= model then return end

    local entityExists, vehicle = pcall(lib.waitFor, function()
        local entity = NetworkGetEntityFromNetworkId(networkId)

        if entity > 0 then return entity end
    end, '', 10000)

    if not entityExists then return print('WHYYYYYY') end

    local vehicleId = 100 + n
    Entity(vehicle).state:set('vehicleId', vehicleId, true)

    local metadata = awaitingItems[playerId]
    if metadata then
        metadata.vehId = vehicleId
        metadata.description = ('%s  \n**Vehicle ID:** %s'):format(metadata.description, vehicleId)

        exports.ox_inventory:AddItem(playerId, 'vehicle_rental_contract', 1, metadata)
        awaitingItems[playerId] = nil
    end

    currentRentals[n] = {
        model = model,
        props = props,
        networkId = networkId,
        vehicleId = vehicleId,
        playerId = playerId
    }

    currentRentalsByVehicleId[vehicleId] = n
    n += 1

    awaitingResponses[playerId] = nil
end)
