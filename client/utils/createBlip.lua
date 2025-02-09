---Creates a blp on the map
---@param sprite number;
---@param color number;
---@param position vector3;
---@param name string;
---@param scale? number;
function Client.createBlip(sprite, color, position, name, scale)
    local createdBlip = AddBlipForCoord(position.x, position.y, position.z)

    SetBlipSprite(createdBlip, sprite)
    SetBlipScale(createdBlip, scale or 1.0)
    SetBlipColour(createdBlip, color)
    SetBlipAsShortRange(createdBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(name)
    EndTextCommandSetBlipName(createdBlip)

    return createdBlip
end
