---@class ShopType
---@field label string
---@field blip BlipDataRaw|false
---@field ped PedDataRaw
---@field defaultInventory ShopItem[]

---@class ShopItem
---@field name string
---@field price number
---@field metadata? table

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
        defaultInventory = {
            {
                name = 'bread',
                price = 15,
            }
        }
    },
    limited = {
        label = 'Limited Gasoline',
        blip = {
            sprite = 361,
            color = 5,
            label = 'Limited LTD',
            scale = 0.7,
        },
        ped = {
            model = `mp_m_shopkeep_01`,
            animation = {
                name = 'WORLD_HUMAN_GUARD_STAND',
            }
        },
        defaultInventory = {
            {
                name = 'water',
                price = 15,
            }
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
        defaultInventory = {
            {
                name = 'water',
                price = 15,
            }
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
        defaultInventory = {
            {
                name = 'beer',
                price = 15,
            }
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
        defaultInventory = {
            {
                name = 'water',
                price = 15,
            }
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
        defaultInventory = {
            {
                name = 'bread',
                price = 15,
            }
        }
    }
} --[[@as table<string, ShopType>]]
