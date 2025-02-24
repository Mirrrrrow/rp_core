---@type ShopConfig
local SHOP_CONFIG <const> = lib.load('data.shops.shops')

local function openShopMangementMenu(shop, shopType, shopId)

end

local function openShopBuyAlert(shop, shopType, shopId)
    local retval = lib.alertDialog({
        header = shop.label,
        content = 'Do you want to buy this shop for **$' .. ESX.Math.GroupDigits(shop.price) .. '**?',
        centered = true,
    })

    if retval ~= 'confirm' then return end

    local method = Client.functions.selectPaymentMethod({
        price = shop.price,
        label = ('Shop: %s'):format(shop.label),
    })
    if not method then return false end

    local success, result = lib.callback.await('shop:server:buyShop', false, shopType, shopId, method)
    lib.notify({
        title = shop.label,
        description = result,
        type = success and 'success' or 'error',
    })
end

local function openShopManagement(shopType, shopId)
    local shop = SHOP_CONFIG.shops[shopId]
    if Client.functions.hasCooldown('open_shop_management', 3000) then
        return lib.notify({
            title = shop.label,
            description = 'Please wait a moment before opening the shop management again.',
            type = 'error',
        })
    end

    local isShopOwned, isPlayerOwner = lib.callback.await('shop:server:getShopOwnership', false, shopType, shopId)
    if isShopOwned and not isPlayerOwner then
        return lib.notify({
            title = shop.label,
            description = 'You are not the owner of this shop.',
            type = 'error',
        })
    end

    if not isShopOwned then
        return openShopBuyAlert(shop, shopType, shopId)
    end

    openShopMangementMenu(shop, shopType, shopId)
end

return {
    openShopManagement = openShopManagement,
}
