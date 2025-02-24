---@type ShopConfig
local SHOP_CONFIG <const> = lib.load('data.shops.shops')

lib.callback.register('shop:server:buyShop', function(source, shopType, shopId, method)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return false, false end

    local shopData = Server.cache.shopCache[shopId]
    if not shopData then return false, 'Shop not found!' end

    if shopData.owner ~= 'none' then return false, 'Shop is already owned!' end

    local shop = SHOP_CONFIG.shops[shopId]
    if xPlayer.getAccount(method)?.money < shop.price then return false, 'Insufficient funds!' end

    xPlayer.removeAccountMoney(method, shop.price)

    shopData.owner = xPlayer.getIdentifier()
    Server.cache.shopCache[shopId] = shopData

    return true, 'Shop bought successfully!'
end)
