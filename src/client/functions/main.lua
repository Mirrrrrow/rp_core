return {
    ---@type fun(data: BlipData): number?
    createBlip = require(FUNCTIONS_PATH:format('createBlip')),
    ---@type fun(data: PedData): number?
    spawnPed = require(FUNCTIONS_PATH:format('spawnPed')),
    ---@type fun(data: PedInteractionData)
    addPedInteraction = require(FUNCTIONS_PATH:format('addPedInteraction')),
    ---@type fun(model: string|number): number?
    parseVehicleData = require(FUNCTIONS_PATH:format('parseVehicleData')),
}
