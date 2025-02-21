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
    ---@diagnostic disable-next-line: inject-field
    ped.coords = npcData.coords
    Client.functions.addPedInteraction({
        key = key,
        ped = ped --[[@as PedData]],
        interactions = mappedOptions,
    })
end
