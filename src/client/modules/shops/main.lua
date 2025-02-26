---@type table<string, ShopConfig>
local SHOPS <const> = lib.load('data.shops.shops')

local function openShop(shopType)
    if Client.functions.hasCooldown('open_shop', 1000) then
        return lib.notify({
            description = 'Please wait a moment before opening the shop again.',
            type = 'error',
        })
    end

    exports.ox_inventory:openInventory('shop', {
        type = ('default_shop_%s'):format(shopType),
    })
end

for shopType, shopData in pairs(SHOPS) do
    local blip = shopData.blip
    local ped = shopData.ped

    for _, coords in pairs(shopData.locations) do
        if blip then
            Client.functions.createBlip({
                coords = coords,
                label = blip.label,
                scale = blip.scale,
                sprite = blip.sprite,
                color = blip.color,
            })
        end

        ---@diagnostic disable-next-line: inject-field
        ped.coords = coords
        Client.functions.addPedInteraction({
            ped = ped --[[@as PedData]],
            interactions = {
                label = 'Open shop',
                icon = 'fas fa-store',
                onSelect = function()
                    openShop(shopType)
                end
            },
        })
    end
end
