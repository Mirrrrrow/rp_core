---@class VehicleData
---@field make string
---@field name string
---@field displayLabel string

---@param model number|string
---@return VehicleData
local function parseVehicleData(model)
    local hash = lib.requestModel(model, 5000)
    local make = GetMakeNameFromVehicleModel(hash)

    if make == '' then
        local make2 = GetMakeNameFromVehicleModel(model:gsub(':W', ''))

        if make2 ~= 'CARNOTFOUND' and make2 ~= '' then make = make2 end
    end

    local data = {
        make = make ~= '' and GetLabelText(make) or '',
        name = GetLabelText(GetDisplayNameFromVehicleModel(hash)),
    }

    data.displayLabel = data.make ~= '' and (data.make .. ' ' .. data.name) or data.name

    return data
end

return parseVehicleData
