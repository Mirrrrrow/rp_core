---@type ShopConfig
local SHOP_CONFIG <const> = lib.load('data.shops.shops')

for key, shopTypeData in pairs(SHOP_CONFIG.types) do
    local shopId = ('default_shop_%s'):format(key)
    exports.ox_inventory:RegisterShop(shopId, {
        name = shopTypeData.label,
        inventory = shopTypeData.defaultInventory,
    })
end
