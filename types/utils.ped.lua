---@alias PedAnimation { name: string }|{ dict: string, name: string, flag: number? }|nil;

---@class PedDataRaw
---@field model string|number
---@field animation? PedAnimation

---@class PedData : PedDataRaw
---@field coords vector4|{x: number, y: number, z: number, w: number}
