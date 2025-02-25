---@type ShopConfig
local SHOP_CONFIG <const> = lib.load('data.shops.shops')

---@module "src.client.modules.shops.management"
local shopManagement = require(MODULES_PATH:format('shops.management'))

local function openShop(shopType, shopId)
    local shop = SHOP_CONFIG.shops[shopId]
    if Client.functions.hasCooldown('open_shop', 1500) then
        return lib.notify({
            title = shop.label,
            description = 'Please wait a moment before opening the shop again.',
            type = 'error',
        })
    end

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
end
