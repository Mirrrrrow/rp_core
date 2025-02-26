---@type table<string, ShopConfig>
local SHOPS <const> = lib.load('data.shops.shops')

for shopType, shopData in pairs(SHOPS) do
    local shopId = ('default_shop_%s'):format(shopType)
    exports.ox_inventory:RegisterShop(shopId, {
        name = shopData.label,
        inventory = shopData.inventory,
    })
end
