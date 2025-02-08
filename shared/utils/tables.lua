---Maps a table to a new table using a function.
---@param tbl table
---@param fn function
---@param numberIndexes? boolean
---@return table
function Shared.mapTable(tbl, fn, numberIndexes)
    local mappedTable = {}

    for key, value in pairs(tbl) do
        mappedTable[numberIndexes and #mappedTable + 1 or key] = fn(key, value)
    end

    return mappedTable
end
