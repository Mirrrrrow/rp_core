---@type table<string, NPCData>
local NPCS <const> = lib.load('data.npcs.npcs')

for key, npcData in pairs(NPCS) do
    local mappedOptions = Shared.functions.mapTable(npcData.options, function(option)
        local onSelect

        local action = option.action
        local data = action.data
        if action.type == 'message' then
            onSelect = function()
                local function getMessage()
                    if type(data.message) == 'string' then
                        return data.message
                    end

                    math.randomseed()
                    return data.message[math.random(1, #data.message)]
                end

                lib.notify({
                    title = data.title,
                    description = getMessage(),
                    type = data.type or 'info',
                    duration = data.duration or 5000
                })
            end
        elseif action.type == 'custom' then
            onSelect = function()
                action.callback()
            end
        end

        return {
            label = option.label,
            icon = option.icon,
            onSelect = onSelect,
        }
    end)


    local blip = npcData.blip
    if blip then
        Client.functions.createBlip({
            coords = npcData.coords,
            label = blip.label,
            scale = blip.scale,
            sprite = blip.sprite,
            color = blip.color,
        })
    end

    local ped = npcData.ped
    lib.points.new({
        coords = npcData.coords.xyz,
        distance = 50,
        onEnter = function(self)
            if self.entity then return end

            local entity = Client.functions.spawnPed({
                coords = npcData.coords,
                model = ped.model,
                animation = ped.animation,
            })

            if not entity then return Shared.debug(('Could not spawn npc \'%s\'!'):format(key)) end
            exports.ox_target:addLocalEntity(entity, mappedOptions)
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
