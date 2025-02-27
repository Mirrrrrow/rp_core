RegisterServerEvent('vehicleInteractionMenu:server:toggleEngine', function(vehicleId)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    local vehicle = Server.functions.getVehicle(vehicleId)
    if not vehicle then
        return lib.notify(playerId, {
            description = 'Vehicle not found!',
            type = 'error',
        })
    end

    local pedVehicle = GetVehiclePedIsIn(GetPlayerPed(playerId), false)
    if pedVehicle ~= vehicle then
        return lib.notify(playerId, {
            description = 'You are not in the vehicle!',
            type = 'error',
        })
    end

    TriggerClientEvent('vehicleInteractionMenu:client:toggleEngine', NetworkGetEntityOwner(vehicle),
        NetworkGetNetworkIdFromEntity(vehicle))
end)
