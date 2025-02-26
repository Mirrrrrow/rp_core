---@type table<string, VehicleRentalConfig>
local VEHICLE_RENTALS <const> = lib.load('data.vehicleRental.vehicleRental')
local cachedMenus = {}

---@param data VehicleRentalConfig
---@return vector4?
local function getSpawnpoint(data)
    local nearestPoint, minDistance = nil, math.huge
    for _, coords in ipairs(data.spawnpoints) do
        local distance = #(cache.coords - coords.xyz)

        if distance < minDistance and ESX.Game.IsSpawnPointClear(coords.xyz, 5.0) then
            nearestPoint, minDistance = coords, distance
        end
    end

    return nearestPoint
end

---@param key string
---@param data VehicleRentalConfig
---@param model string
---@param label string
---@param vehicleData VehicleRentalItemConfig
local function openVehicleRentalInput(key, data, model, vehicleData, label)
    local retval = lib.inputDialog(data.label, {
        {
            label = 'Duration (minutes)',
            type = 'number',
            required = true,
            min = 1,
            max = 600,
            default = 30
        },
        {
            label = 'I understand that I will be charged if I do not return the vehicle in time or if its broken.',
            type = 'checkbox',
            required = true,
        }
    })

    if not retval then return end
    local duration, confirmation = retval[1], retval[2]

    if not confirmation then return end
    duration = tonumber(duration) --[[@as number]]

    local price = vehicleData.pricePerMinute * duration

    local method = Client.functions.selectPaymentMethod({
        price = price,
        label = ('%s: %s'):format(data.label, label),
    })
    if not method then return false end

    local confirmationMessage = ('You will be charged **$%s** for renting a **%s** for **%s minutes**.'):format(price,
        Client.functions.parseVehicleData(model).displayLabel, duration)

    lib.notify({
        title = data.label,
        description = confirmationMessage,
        icon = vehicleData.icon,
        type = 'info'
    })

    local spawnpoint = getSpawnpoint(data)
    if not spawnpoint then
        return lib.notify({
            title = data.label,
            description = 'No available spawnpoints.',
            icon = vehicleData.icon,
            type = 'error'
        })
    end

    local success, result = lib.callback.await('vehicleRental:server:rentVehicle', false, key, model, duration, method,
        label)
    lib.notify({
        title = data.label,
        description = result,
        icon = vehicleData.icon,
        type = success and 'success' or 'error'
    })

    if not success then return end
    ESX.Game.SpawnVehicle(model, spawnpoint.xyz, spawnpoint.w, function(vehicle)
        if vehicleData.modifications then
            lib.setVehicleProperties(vehicle, vehicleData.modifications)
        end
        Wait(0) -- Could delete this?
        local props = lib.getVehicleProperties(vehicle)
        local networkId = NetworkGetNetworkIdFromEntity(vehicle)
        TriggerServerEvent('vehicleRental:server:setVehicleAsOwned', model, props, networkId)
    end)
end


---@param key string
---@param data VehicleRentalConfig
local function openVehicleRental(key, data)
    local cachedMenu = cachedMenus[key]
    if cachedMenu then
        return lib.showContext(cachedMenu)
    end

    local options, n = {
        {
            title = 'Close',
            icon = 'fas fa-xmark',
        },
        {
            title = '',
            disabled = true
        }
    }, 3

    for model, vehicleData in pairs(data.items) do
        local label = Client.functions.parseVehicleData(model).displayLabel
        options[n] = {
            title = label,
            description = ('Price per minute: **$%s/min**.'):format(vehicleData.pricePerMinute),
            icon = vehicleData.icon,
            onSelect = function()
                openVehicleRentalInput(key, data, model, vehicleData, label)
            end
        }

        n += 1
    end

    local menuId = ('vehicleRental:main:%s'):format(key)
    lib.registerContext({
        id = menuId,
        title = data.label,
        options = options
    })

    cachedMenus[key] = menuId
    lib.showContext(menuId)
end

for key, vehicleRentalData in pairs(VEHICLE_RENTALS) do
    local blip = vehicleRentalData.blip
    if blip then
        Client.functions.createBlip({
            coords = vehicleRentalData.coords,
            label = blip.label,
            scale = blip.scale,
            sprite = blip.sprite,
            color = blip.color,
        })
    end

    local ped = vehicleRentalData.ped
    ---@diagnostic disable-next-line: inject-field
    ped.coords = vehicleRentalData.coords
    Client.functions.addPedInteraction({
        key = key,
        ped = ped --[[@as PedData]],
        interactions = {
            label = 'Rent a vehicle',
            icon = 'fas fa-bicycle',
            onSelect = function()
                openVehicleRental(key, vehicleRentalData)
            end
        },
    })
end
