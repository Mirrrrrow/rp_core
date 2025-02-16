return {
    ---@type fun(data: BlipData): number?
    createBlip = require(FUNCTIONS_PATH:format('createBlip')),
    ---@type fun(data: PedData): number?
    spawnPed = require(FUNCTIONS_PATH:format('spawnPed')),
}
