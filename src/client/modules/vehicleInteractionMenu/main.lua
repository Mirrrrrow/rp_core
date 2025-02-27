lib.registerRadial({
    id = 'inside_vehicle_control',
    items = {
        {
            label = 'Motor an/aus',
            icon = 'fas fa-circle-exclamation',
            keepOpen = true,
            onSelect = function()
                if not cache.vehicle then return end
                if cache.seat ~= -1 then return end

                local vehicleId = Entity(cache.vehicle).state.vehicleId
                if not vehicleId then return end

                TriggerServerEvent('vehicleInteractionMenu:server:toggleEngine', vehicleId)
            end
        }
    }
})

RegisterNetEvent('vehicleInteractionMenu:client:toggleEngine', function(networkId)
    if GetInvokingResource() then return end

    local vehicle = NetworkGetEntityFromNetworkId(networkId)
    if not DoesEntityExist(vehicle) then return end

    local engineState = GetIsVehicleEngineRunning(vehicle)
    SetVehicleEngineOn(vehicle, not engineState, true, true)

    SetVehicleUndriveable(cache.vehicle, engineState)
    SetVehicleEngineOn(cache.vehicle, not engineState, true, true)

    local state = not engineState and 'started' or 'stopped'
    lib.notify({
        description = ('Engine %s!'):format(state),
        type = 'info',
    })
end)

lib.onCache('vehicle', function(value)
    if not value then return lib.removeRadialItem('inside_vehicle') end

    lib.addRadialItem({
        id = 'inside_vehicle',
        label = 'Vehicle Control',
        menu = 'inside_vehicle_control',
        icon = 'fas fa-car'
    })
end)
