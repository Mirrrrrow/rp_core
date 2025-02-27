local function getVehicle(vehicleId)
    ---@diagnostic disable-next-line: param-type-mismatch
    for _, vehicle in pairs(GetAllVehicles()) do
        if (Entity(vehicle).state.vehicleId or 0) == vehicleId then
            return vehicle, NetworkGetNetworkIdFromEntity(vehicle)
        end
    end
end

return getVehicle
