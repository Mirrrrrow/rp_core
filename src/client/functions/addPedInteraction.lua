---@param data PedInteractionData
local function addPedInteraction(data)
    local ped = data.ped
    lib.points.new({
        coords = ped.coords.xyz,
        distance = 50,
        onEnter = function(self)
            if self.entity then return end

            local entity = Client.functions.spawnPed({
                coords = ped.coords,
                model = ped.model,
                animation = ped.animation,
            })

            if not entity then return Shared.debug(('Could not spawn npc \'%s\'!'):format(data.key or 'PedInteraction')) end
            exports.ox_target:addLocalEntity(entity, data.interactions)
        end,
        onExit = function(self)
            local entity = self.entity
            if not entity then return end

            exports.ox_target:removeLocalEntity(entity)
            Client.deleteEntity(entity)
            self.entity = nil
        end
    })
end

return addPedInteraction
