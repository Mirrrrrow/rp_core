---@param data BlipData
local function createBlip(data)
    local coords = data.coords
    local createdBlip = AddBlipForCoord(coords.x, coords.y, coords.z)

    SetBlipSprite(createdBlip, data.sprite)
    SetBlipScale(createdBlip, data.scale or 1.0)
    SetBlipColour(createdBlip, data.color)
    SetBlipAsShortRange(createdBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(data.label)
    EndTextCommandSetBlipName(createdBlip)

    return createdBlip
end

return createBlip
