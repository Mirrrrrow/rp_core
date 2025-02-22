---@class ShopConfig
---@field types table<string, ShopType>
---@field shops table<string, ShopData>

---@class ShopData
---@field label string
---@field type string
---@field coords vector4
---@field price number

return {
    types = lib.load('data.shops.shopTypes'),
    shops = {
        ['ltd_grove'] = {
            label = 'LTD Gasoline Grove Street',
            type = 'limited',
            coords = vec4(-47.3459, -1758.6971, 28.4210, 51.1130),
            price = 10000
        }
    }
} --[[@as ShopConfig]]
