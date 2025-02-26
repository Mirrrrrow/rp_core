---@class ShopConfig
---@field label string
---@field blip BlipDataRaw
---@field ped PedDataRaw
---@field inventory table[]
---@field locations vector4[]

return {
    twentyfourseven = {
        label = 'Twenty Four Seven',
        blip = {
            label = '24/7 Supermarket',
            sprite = 52,
            color = 2,
            scale = 0.7,
        },
        ped = {
            model = `mp_m_shopkeep_01`,
            animation = {
                name = 'WORLD_HUMAN_GUARD_STAND',
            }
        },
        inventory = {
            { name = 'bread', price = 15 }
        },
        locations = {
            -- vec4(1, 2, 3, 4),    types = lib.load('data.shops.shopTypes'),
            -- vec4(1, 2, 3, 4)
        }
    },
    limited_ltd = {
        label = 'Limited LTD Gasoline',
        blip = {
            sprite = 361,
            color = 5,
            label = 'Limited LTD Gasoline',
            scale = 0.7,
        },
        ped = {
            model = `mp_m_shopkeep_01`,
            animation = {
                name = 'WORLD_HUMAN_GUARD_STAND',
            }
        },
        inventory = {
            { name = 'bread', price = 15 }
        },
        locations = {
            vec4(-47.3459, -1758.6971, 28.4210, 51.1130),
        }
    },
    ammunation = {
        label = 'Ammunation',
        blip = {
            sprite = 110,
            color = 1,
            label = 'Ammunation',
            scale = 0.7,
        },
        ped = {
            model = `mp_m_shopkeep_01`,
            animation = {
                name = 'WORLD_HUMAN_GUARD_STAND',
            }
        },
        inventory = {
            { name = 'bread', price = 15 }
        },
        locations = {
            -- vec4(1, 2, 3, 4),
            -- vec4(1, 2, 3, 4)
        }
    },
    liquor = {
        label = 'Liquor Store',
        blip = {
            sprite = 93,
            color = 5,
            label = 'Liquor Store',
            scale = 0.7,
        },
        ped = {
            model = `mp_m_shopkeep_01`,
            animation = {
                name = 'WORLD_HUMAN_GUARD_STAND',
            }
        },
        inventory = {
            { name = 'bread', price = 15 }
        },
        locations = {
            -- vec4(1, 2, 3, 4),
            -- vec4(1, 2, 3, 4)
        }
    },
    youtool = {
        label = 'YouTool',
        blip = {
            sprite = 566,
            color = 44,
            label = 'YouTool',
            scale = 0.7,
        },
        ped = {
            model = `mp_m_shopkeep_01`,
            animation = {
                name = 'WORLD_HUMAN_GUARD_STAND',
            }
        },
        inventory = {
            { name = 'bread', price = 15 }
        },
        locations = {
            -- vec4(1, 2, 3, 4),
            -- vec4(1, 2, 3, 4)
        }
    },
    digitalden = {
        label = 'Digital Den',
        blip = {
            sprite = 566,
            color = 3,
            label = 'Hardware Store',
            scale = 0.7,
        },
        ped = {
            model = `mp_m_shopkeep_01`,
            animation = {
                name = 'WORLD_HUMAN_GUARD_STAND',
            }
        },
        inventory = {
            { name = 'bread', price = 15 }
        },
        locations = {
            -- vec4(1, 2, 3, 4),
            -- vec4(1, 2, 3, 4)
        }
    }
} --[[@as table<string, ShopConfig>]]
