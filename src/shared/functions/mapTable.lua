---@param list table
---@param cb function
---@param noIndex boolean?
---@return table
local function mapTable(list, cb, noIndex)
    local ret = {}

    for key, value in pairs(list) do
        local data = cb(value, key)
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
