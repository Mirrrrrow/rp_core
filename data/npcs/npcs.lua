---@class NPCData
---@field coords vector4
---@field ped PedDataRaw
---@field blip BlipDataRaw|false
---@field options NPCOption[]

---@class NPCOption
---@field label string
---@field icon string
---@field action NPCAction

---@class NPCAction
---@field type 'message'|'custom'
---@field data? table
---@field callback? function

return {
    welcomer = {
        coords = vec4(-1034.35, -2732.90, 19.17, 147.74),
        ped = {
            model = `mp_f_boatstaff_01`,
            animation = {
                dict = 'anim@heists@prison_heiststation@cop_reactions',
                name = 'cop_b_idle',
                flag = 1,
            },
        },
        blip = {
            sprite = 1,
            color = 0,
            label = 'Welcomer',
            scale = 0.7,
        },
        options = {
            {
                label = 'How do I get to the city?',
                icon = 'fas fa-map-marked-alt',
                action = {
                    type = 'message',
                    data = {
                        title = 'City Directions',
                        type = 'info',
                        duration = 5000,
                        message =
                        {
                            'Just walk a bit haha!',
                            'Go to the taxi phone on your right and just call one...',
                            'You can rent a bicycle at the bike station near the entrance!',
                        }
                    }
                }
            },
            {
                label = 'EXAMPLE ACTION',
                icon = 'fas fa-question',
                action = {
                    type = 'custom',
                    callback = function()
                        print('This is an example action!')
                    end
                }
            }
        }
    },
} --[[@as table<string, NPCData>]]
