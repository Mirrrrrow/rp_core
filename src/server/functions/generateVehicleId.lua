local function generateVehicleId()
    local id = lib.string.random('111111', 6)
    ---@diagnostic disable-next-line: cast-local-type
    id = tonumber(id)

    if MySQL.scalar.await('SELECT 1 FROM owned_vehicles WHERE vehicleId = ?', { id }) then
        return generateVehicleId()
    end

    return id
end

return generateVehicleId
