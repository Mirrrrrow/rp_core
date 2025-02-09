local spawnedPeds, n = {}, 0

---Spawns a ped
---@param model string|number
---@param position vector4
---@param animation { name: string }|{ dict: string, name: string, flag: number }|nil;
---@return number?
function Client.spawnPed(model, position, animation)
    model = lib.requestModel(model)
    if not model then return end

    local entity = CreatePed(0, model, position.x, position.y, position.z, position.w, false, true)

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
