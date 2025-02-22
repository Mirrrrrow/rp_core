---@type ShopConfig
local SHOP_CONFIG <const> = lib.load('data.shops.shops')

local function openShop(shopType, shopId)
    exports.ox_inventory:openInventory('shop', {
        type = ('default_shop_%s'):format(shopType),
        id = shopId
    })
end

for key, shopData in pairs(SHOP_CONFIG.shops) do
    local shopType = shopData.type
    local shopGeneralities = SHOP_CONFIG.types[shopType]

    local blip = shopGeneralities.blip
    if blip then
        Client.functions.createBlip({
            coords = shopData.coords,
            label = blip.label,
            scale = blip.scale,
            sprite = blip.sprite,
            color = blip.color,
        })
    end

    local ped = shopGeneralities.ped
    ---@diagnostic disable-next-line: inject-field
    ped.coords = shopData.coords
    Client.functions.addPedInteraction({
        key = key,
        ped = ped --[[@as PedData]],
        interactions = {
            label = 'Open shop',
            icon = 'fas fa-store',
            onSelect = function()
                openShop(shopType, key)
            end
        },
    })
end
