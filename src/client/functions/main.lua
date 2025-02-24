return {
    ---@type fun(data: BlipData): number?
    createBlip = require(FUNCTIONS_PATH:format('createBlip')),
    ---@type fun(data: PedData): number?
    spawnPed = require(FUNCTIONS_PATH:format('spawnPed')),
    ---@type fun(data: PedInteractionData)
    addPedInteraction = require(FUNCTIONS_PATH:format('addPedInteraction')),
    ---@type fun(model: string|number): VehicleData
    parseVehicleData = require(FUNCTIONS_PATH:format('parseVehicleData')),
    ---@type fun(data: PaymentMethodData): string|false
    selectPaymentMethod = require(FUNCTIONS_PATH:format('selectPaymentMethod')),
    ---@type fun(key: string, duration: number): boolean
    hasCooldown = require(FUNCTIONS_PATH:format('hasCooldown')),
}
