return {
    ---@type fun(list: table, cb: function, noIndex: boolean?): table
    mapTable = require(SHARED_FUNCTIONS_PATH:format('mapTable')),
    ---@type fun(t: table, v: any): boolean
    includes = require(SHARED_FUNCTIONS_PATH:format('includes'))
}
