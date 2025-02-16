local spawnedPeds, n = {}, 0

---@class PedDataRaw
---@field model string|number
---@field animation? PedAnimation

---@class PedData : PedDataRaw
---@field coords vector4|{x: number, y: number, z: number, w: number}

---@param data PedData
---@return number?
local function spawnPed(data)
    local model = lib.requestModel(data.model)
    if not model then return end

    local coords = data.coords
    local entity = CreatePed(0, model, coords.x, coords.y, coords.z, coords.w, false, true)

    local animation = data.animation
    if animation and animation.dict then
        lib.requestAnimDict(animation.dict)
        TaskPlayAnim(entity, animation.dict, animation.name, 8.0, 0.0, -1, animation.flag, 0, false, false, false)
    elseif animation and animation.name then
        TaskStartScenarioInPlace(entity, animation.name, 0, true)
    end

    SetModelAsNoLongerNeeded(model)
    FreezeEntityPosition(entity, true)
    SetEntityInvincible(entity, true)
    SetBlockingOfNonTemporaryEvents(entity, true)

    n += 1
    spawnedPeds[n] = entity

    return entity
end

AddEventHandler('onResourceStop', function(resource)
    if resource == cache.resource then
        for i = 1, n do
            local entity = spawnedPeds[i]
            if DoesEntityExist(entity) then
                SetEntityAsMissionEntity(entity, false, true)
                DeleteEntity(entity)
            end
        end
    end
end)

return spawnPed
