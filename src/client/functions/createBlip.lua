---@class BlipDataRaw
---@field label string
---@field sprite number
---@field color number
---@field scale? number

---@class BlipData : BlipDataRaw
---@field coords vector3|vector4|{x: number, y: number, z: number, w?: number}

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
