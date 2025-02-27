---@param points vector4[]|vector3[]
---@param clearForVehicles? boolean
local function reducePoints(points, clearForVehicles)
    local nearestPoint, minDistance = nil, math.huge
    for _, coords in ipairs(points) do
        local distance = #(cache.coords - coords.xyz)

        if distance < minDistance and (clearForVehicles and ESX.Game.IsSpawnPointClear(coords.xyz, 5.0)) then
            nearestPoint, minDistance = coords, distance
        end
    end

    return nearestPoint
end

return reducePoints
