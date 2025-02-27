---@type table<string, VehicleDealerConfig>
local VEHICLE_DEALERS <const> = lib.load('data.vehicleDealer.vehicleDealer')

local awaitingResponses = {}
local awaitingItems = {}

lib.callback.register('vehicleDealer:server:buyVehicle',
    function(playerId, key, model, method, vehicleDealerLabel, vehicleLabel)
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if not xPlayer then return false, 'Player not found!' end

        local vehicleDealer = VEHICLE_DEALERS[key]
        if not vehicleDealer then return false, 'Vehicle dealer not found!' end

        local vehicleData = vehicleDealer.vehicles[model]
        if not vehicleData then return false, 'Vehicle not found!' end

        if xPlayer.getAccount(method)?.money < vehicleData.price then return false, 'Insufficient funds!' end

        local buyDate = os.time()
        local metadata = {
            vehicleDealer = key,
            model = model,
            buyDate = buyDate,
            description = ('**Vehicle Dealer:** %s  \n**Vehicle:** %s  \n**Buydate:** %s')
                :format(vehicleDealerLabel, vehicleLabel, os.date('%d.%m.%Y %H:%M:%S', buyDate)),
        }
        if not exports.ox_inventory:CanCarryItem(playerId, 'vehicle_dealer_contract', 1, metadata) then
            return false, 'Not enough space in inventory!'
        end

        awaitingItems[playerId] = metadata

        xPlayer.removeAccountMoney(method, vehicleData.price, ('%s: %s'):format(vehicleDealerLabel, vehicleLabel))
        awaitingResponses[playerId] = model

        return true, 'Purchase successful!'
    end)

RegisterServerEvent('vehicleDealer:server:setVehicleAsOwned', function(key, model, localProps, networkId)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return end

    local awaitingResponse = awaitingResponses[playerId]
    if not awaitingResponse then return end

    if awaitingResponse ~= model then return end

    local entityExists, vehicle = pcall(lib.waitFor, function()
        local entity = NetworkGetEntityFromNetworkId(networkId)

        if entity > 0 then return entity end
    end, '', 10000)

    if not entityExists then return print('WHYYYYYY') end

    local vehicleId = Server.functions.generateVehicleId()
    Entity(vehicle).state:set('vehicleId', vehicleId, true)

    local metadata = awaitingItems[playerId]
    if metadata then
        metadata.vehId = vehicleId
        metadata.description = ('%s  \n**Vehicle ID:** %s'):format(metadata.description, vehicleId)

        exports.ox_inventory:AddItem(playerId, 'vehicle_dealer_contract', 1, metadata)
        awaitingItems[playerId] = nil
    end

    local props = VEHICLE_DEALERS[key].vehicles[model].modifications or localProps

    props.plate = '000000'
    MySQL.insert.await('INSERT INTO owned_vehicles (vehicleId, owner, plate, vehicle, type) VALUES (?, ?, ?, ?, ?)', {
        vehicleId, xPlayer.getIdentifier(), props.plate, json.encode(props), GetVehicleType(vehicle)
    })

    awaitingResponses[playerId] = nil
end)
