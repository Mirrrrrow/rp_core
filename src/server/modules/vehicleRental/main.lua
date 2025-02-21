---@type table<string, VehicleRental>
local VEHICLE_RENTALS <const> = lib.load('data.vehicleRental.vehicleRental')
local awaitingResponses = {}
local currentRentals, n = {}, 1
local currentRentalsByVehicleId = {}

lib.callback.register('vehicleRental:server:rentVehicle', function(playerId, key, model, duration, method)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return false, 'Player not found!' end

    local vehicleRentalData = VEHICLE_RENTALS[key]
    if not vehicleRentalData then return false, 'Vehicle rental not found!' end

    local vehicleData = vehicleRentalData.items[model]
    if not vehicleData then return false, 'Vehicle not found!' end

    local price = vehicleData.pricePerMinute * duration
    if xPlayer.getAccount(method)?.money < price then return false, 'Insufficient funds!' end

    Shared.debug('TODO: CHECK INVENTORY FOR SPACE!!!')

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

    currentRentals[n] = {
        model = model,
        props = props,
        networkId = networkId,
        vehicleId = vehicleId,
        playerId = playerId
    }

    currentRentalsByVehicleId[vehicleId] = n
    n += 1

    Shared.debug('TODO: GIVE VEHICLE RENTAL CONTRACT TO PLAYER!!!')

    awaitingResponses[playerId] = nil
end)
