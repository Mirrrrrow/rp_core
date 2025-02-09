local shops, n = {}, 0

for key, shopData in pairs(lib.load('data.shops.shops')) do
    local blip = shopData.blip
    if blip then
        Client.createBlip(blip.sprite, blip.color, blip.coords, blip.label or shopData.label, blip.scale)
    end

    local cashier = shopData.cashier
    lib.points.new({
        shopKey = key,
        coords = cashier.coords.xyz,
        distance = 50,
        onEnter = function(self)
            if self.entity then return end

            local entity = Client.spawnPed(cashier.model, cashier.coords, cashier.animation)
            if not entity then return Shared.debug(('Could not spawn npc \'%s\'!'):format(key)) end
            --exports.ox_target:addLocalEntity(entity, mappedOptions)
        end,
        onExit = function(self)
            local entity = self.entity
            if not entity then return end

            --exports.ox_target:removeLocalEntity(entity)
            Client.deleteEntity(entity)
            self.entity = nil
        end
    })
end
