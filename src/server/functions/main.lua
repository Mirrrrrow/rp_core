return {
    ---@type fun(): number
    generateVehicleId = require(FUNCTIONS_PATH:format('generateVehicleId')),
    ---@type fun(vehicleId: number)
    getVehicle = require(FUNCTIONS_PATH:format('getVehicle')),
}
