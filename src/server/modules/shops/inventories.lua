---@type ShopConfig
local SHOP_CONFIG <const> = lib.load('data.shops.shops')

local hooks = {
    storage = {},
    shop = {}
}



local function updateShopItems(shopType, shopId, payload, price, currency)
    local shop = SHOP_CONFIG.shops[shopId]
    local stashId = ('shop_storage_%s'):format(shopId)
    local shopInventoryId = ('owned_shop_%s'):format(shopId)

    payload.fromSlot.metadata.price = price
    payload.fromSlot.metadata.currency = nil
    exports.ox_inventory:SetMetadata(payload.toInventory, payload.toSlot, payload.fromSlot.metadata)

    local stashItems = Shared.functions.mapTable(exports.ox_inventory:GetInventoryItems(stashId), function(item)
        item.price = item.metadata.price
        item.currency = item.metadata.currency
        return item
    end)

    lib.print.info(stashItems)

    exports.ox_inventory:RegisterShop(shopInventoryId, {
        name = shop.label,
        inventory = stashItems,
    })
end

local function setupStorageHooks(shopType, shopId)
    hooks.storage[shopId] = exports.ox_inventory:registerHook('swapItems', function(payload)
        if payload.toType ~= 'stash' then
            CreateThread(function()
                Wait(250)
                updateShopItems(shopType, shopId, payload, nil)
            end)
            return true
        end

        local playerId = payload.source
        local price = lib.callback.await('shop:client:getPriceInput', playerId, shopType, shopId)
        if not price then return false end

        CreateThread(function()
            Wait(250)
            updateShopItems(shopType, shopId, payload, price, 'money')
        end)

        return true
    end, {
        inventoryFilter = {
            ('shop_storage_%s'):format(shopId)
        }
    })
end

local function registerShopInventory(shopType, shopId)
    local shop = SHOP_CONFIG.shops[shopId]
    local stashId = ('shop_storage_%s'):format(shopId)
    exports.ox_inventory:RegisterStash(stashId, shop.label .. ' Storage', 100, 100000)

    local shopInventoryId = ('owned_shop_%s'):format(shopId)

    local stashItems = Shared.functions.mapTable(exports.ox_inventory:GetInventoryItems(stashId), function(item)
        item.price = item.metadata.price or 9999
        item.currency = item.metadata.currency or 'money'
        return item
    end)

    lib.print.info(stashItems)

    exports.ox_inventory:RegisterShop(shopInventoryId, {
        name = shop.label,
        inventory = stashItems,
    })

    setupStorageHooks(shopType, shopId)
end

for key, shopTypeData in pairs(SHOP_CONFIG.types) do
    local shopId = ('default_shop_%s'):format(key)
    exports.ox_inventory:RegisterShop(shopId, {
        name = shopTypeData.label,
        inventory = shopTypeData.defaultInventory,
    })
end

for shopId, shopData in pairs(SHOP_CONFIG.shops) do
    registerShopInventory(shopData.type, shopId)
end
