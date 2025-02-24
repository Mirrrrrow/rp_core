---@class ShopConfig
---@field types table<string, ShopType>
---@field shops table<string, ShopData>

---@class ShopData
---@field label string
---@field type string
---@field coords vector4
---@field managementCoords vector3
---@field storageCoords vector3
---@field price number

return {
    types = lib.load('data.shops.shopTypes'),
    shops = {
        ['ltd_grove'] = {
            label = 'LTD Gasoline Grove Street',
            type = 'limited',
            coords = vec4(-47.3459, -1758.6971, 28.4210, 51.1130),
            managementCoords = vec3(-44.88, -1748.82, 29.22),
            storageCoords = vec3(-48.697498321533, -1754.7542724609, 29.145711898804),
            price = 10000
        }
    }
} --[[@as ShopConfig]]
