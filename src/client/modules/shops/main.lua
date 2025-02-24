---@type ShopConfig
local SHOP_CONFIG <const> = lib.load('data.shops.shops')

---@module "src.client.modules.shops.management"
local shopManagement = require(MODULES_PATH:format('shops.management'))

local function openShop(shopType, shopId)
    local shop = SHOP_CONFIG.shops[shopId]
    if Client.functions.hasCooldown('open_shop', 3000) then
        return lib.notify({
            title = shop.label,
            description = 'Please wait a moment before opening the shop again.',
            type = 'error',
        })
    end

    local isShopOwned = lib.callback.await('shop:server:getShopOwnership', false, shopType, shopId)
    if not isShopOwned then
        return exports.ox_inventory:openInventory('shop', {
            type = ('default_shop_%s'):format(shopType),
            id = shopId
        })
    end

    exports.ox_inventory:openInventory('shop', {
        type = ('owned_shop_%s'):format(shopId),
        id = shopId
    })
end

local function openShopStorage(shopType, shopId)
    local shop = SHOP_CONFIG.shops[shopId]
    if Client.functions.hasCooldown('open_shop_storage', 3000) then
        return lib.notify({
            title = shop.label,
            description = 'Please wait a moment before opening the shop again.',
            type = 'error',
        })
    end

    local isShopOwned, isPlayerOwner = lib.callback.await('shop:server:getShopOwnership', false, shopType, shopId)
    if not isShopOwned or not isPlayerOwner then
        return lib.notify({
            title = shop.label,
            description = 'You do not own this shop.',
            type = 'error',
        })
    end

    local stashId = ('shop_storage_%s'):format(shopId)
    exports.ox_inventory:openInventory('stash', stashId)
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

    exports.ox_target:addSphereZone({
        coords = shopData.managementCoords,
        radius = 0.5,
        options = {
            label = 'Open shop management',
            icon = 'fas fa-store',
            onSelect = function()
                shopManagement.openShopManagement(shopType, key)
            end
        }
    })

    exports.ox_target:addSphereZone({
        coords = shopData.storageCoords,
        radius = 1.0,
        options = {
            label = 'Open shop storage',
            icon = 'fas fa-store',
            onSelect = function()
                openShopStorage(shopType, key)
            end
        }
    })
end

lib.callback.register('shop:client:getPriceInput', function(shopType, shopId)
    local shop = SHOP_CONFIG.shops[shopId]
    return lib.inputDialog(shop.label, {
        {
            label = 'Price',
            description = 'How much should the item cost?',
            type = 'number',
            value = 15,
            min = 1,
        }
    })?[1]
end)
