---@type ShopConfig
local SHOP_CONFIG <const> = lib.load('data.shops.shops')

require(MODULES_PATH:format('shops.management'))

local _shopCache = {}
Server.cache.shopCache = setmetatable({}, {
    __index = function(self, key)
        if _shopCache[key] then return _shopCache[key] end

        local result = MySQL.single.await('SELECT * FROM rp_core_shops WHERE shop = ?', { key })
        if not result then
            MySQL.insert.await('INSERT INTO rp_core_shops (shop, owner) VALUES (?, ?)', { key, 'none' })
            return self[key]
        end

        _shopCache[key] = result
        return result
    end,
    __newindex = function(self, key, value)
        _shopCache[key] = value
    end,
    __call = function()
        for key, shopData in pairs(_shopCache) do
            MySQL.update.await('UPDATE rp_core_shops SET owner = ? WHERE shop = ?', { shopData.owner, key })
        end
    end
})

lib.callback.register('shop:server:getShopOwnership', function(source, shopType, shopId)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return false, false end

    local shopData = Server.cache.shopCache[shopId]
    if not shopData then return false, false end

    return shopData.owner ~= 'none', shopData.owner == xPlayer.getIdentifier()
end)


for key, shopTypeData in pairs(SHOP_CONFIG.types) do
    local shopId = ('default_shop_%s'):format(key)
    exports.ox_inventory:RegisterShop(shopId, {
        name = shopTypeData.label,
        inventory = shopTypeData.defaultInventory,
    })
end
