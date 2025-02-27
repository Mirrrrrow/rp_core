RegisterNetEvent('carKeys:client:toggleLockState', function(networkId)
    if GetInvokingResource() then return end

    local vehicle = NetworkGetEntityFromNetworkId(networkId)

    local isLocked = GetVehicleDoorLockStatus(vehicle) == 2
    local newState = isLocked and 1 or 2

    local message = isLocked and 'Vehicle unlocked!' or 'Vehicle locked!'
    SetVehicleDoorsLocked(vehicle, newState)

    lib.playAnim(cache.ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click_fp', 8.0, -8.0, 1000, 50)
    CreateThread(function()
        SetVehicleLights(vehicle, 2)
        Wait(150)
        SetVehicleLights(vehicle, 0)
        Wait(150)
        SetVehicleLights(vehicle, 2)
        Wait(150)
        SetVehicleLights(vehicle, 0)
    end)

    lib.notify({
        description = message,
        type = 'info'
    })
end)
