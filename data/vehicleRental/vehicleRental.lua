---@class VehicleRental
---@field coords vector4
---@field ped PedDataRaw
---@field blip BlipDataRaw|false
---@field items table<string, VehicleRentalItem>

---@class VehicleRentalItem
---@field pricePerMinute number

return {
    airport = {
        coords = vec4(-1046.68, -2728.36, 19.17, 238.01),
        ped = {
            model = `a_m_m_prolhost_01`,
            animation = {
                dict = 'friends@frj@ig_1',
                name = 'wave_a',
                flag = 1,
            },
        },
        blip = {
            sprite = 226,
            color = 24,
            label = 'Bicycle Rental',
            scale = 0.7,
        },
        items = {
            bmx = {
                pricePerMinute = 5,
            }
        }
    }
} --[[@as table<string, VehicleRental>]]
