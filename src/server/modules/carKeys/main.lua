local function giveCarKeys(playerId, vehicleId, vehicleModel, vehicleLabel)
    local metadata = {
        vehicleId = vehicleId,
        vehicleModel = vehicleModel,
        vehicleLabel = vehicleLabel,
        description = ('**Vehicle:** %s  \n**Vehicle ID:** %s'):format(vehicleLabel, vehicleId)
    }

    if not exports.ox_inventory:CanCarryItem(playerId, 'car_keys', 1, metadata) then return false end

    exports.ox_inventory:AddItem(playerId, 'car_keys', 1, metadata)
    return true
end

exports('giveCarKeys', giveCarKeys)

ESX.RegisterUsableItem('car_keys', function(playerId, _, item)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return end

    local vehicleId = item.metadata.vehicleId
    local vehicle = Server.functions.getVehicle(vehicleId)
    if not vehicle then
        return lib.notify(playerId, {
            description = 'Vehicle not found!',
            type = 'error',
        })
    end

    local distance = #(xPlayer.getCoords(true) - GetEntityCoords(vehicle))
    if distance > 10 then
        return lib.notify(playerId, {
            description = 'You are too far away from the vehicle!',
            type = 'error',
        })
    end

    TriggerClientEvent('carKeys:client:toggleLockState', NetworkGetEntityOwner(vehicle),
        NetworkGetNetworkIdFromEntity(vehicle))
end)
