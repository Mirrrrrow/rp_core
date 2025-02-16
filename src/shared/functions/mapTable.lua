---@param list table
---@param func function
---@param noIndex boolean?
---@return table
local function mapTable(list, func, noIndex)
    local ret = {}

    for key, value in pairs(list) do
        local data = func(value, key)
        if data ~= nil then
            if noIndex then
                table.insert(ret, data)
            else
                ret[key] = data
            end
        end
    end

    return ret
end

return mapTable
