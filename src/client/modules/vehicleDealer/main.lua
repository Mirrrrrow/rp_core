---@type table<string, VehicleDealerConfig>
local VEHICLE_DEALERS <const> = lib.load('data.vehicleDealer.vehicleDealer')

local cachedVehicleData = {}
local spawnedVehicles = {}

local function openVehicleDealer(key)
    Shared.debug('openVehicleDealer')
end

local function spawnVehicles(key)
    cachedVehicleData[key] = {}
    spawnedVehicles[key]   = {}

    for name, data in pairs(VEHICLE_DEALERS[key]?.vehicles or {}) do
        local coords = data.coords
        ESX.Game.SpawnLocalVehicle(name, coords.xyz, coords.w, function(spawnedVehicle)
            SetVehicleIsConsideredByPlayer(spawnedVehicle, false)
            SetVehicleDoorsLocked(spawnedVehicle, 2)
            SetVehicleDoorsLockedForAllPlayers(spawnedVehicle, true)
            SetEntityInvincible(spawnedVehicle, true)
            SetVehicleUndriveable(spawnedVehicle, true)
            FreezeEntityPosition(spawnedVehicle, true)
            SetVehicleHasUnbreakableLights(spawnedVehicle, true)
            SetDisableVehicleWindowCollisions(spawnedVehicle, true)

            lib.setVehicleProperties(spawnedVehicle, data.modifications)

            exports.ox_target:addLocalEntity(spawnedVehicle, {
                label = 'Get vehicle information',
                icon = 'fas fa-file-contract',
                onSelect = function()
                    local vehicleData = cachedVehicleData[key][name]
                    if not vehicleData then return end

                    lib.notify({
                        title = VEHICLE_DEALERS[key].blip.label,
                        description = ('**Vehicle:** %s  \n**Type:** %s  \n**Seats:** %s  \n**Price:** $%s'):format(
                            vehicleData.label,
                            vehicleData.type,
                            vehicleData.seats,
                            vehicleData.price
                        ),
                    })
                end
            })

            spawnedVehicles[key][name] = spawnedVehicle
            cachedVehicleData[key][name] = {
                label = Client.functions.parseVehicleData(name).displayLabel,
                type = GetVehicleType(spawnedVehicle),
                seats = GetVehicleModelNumberOfSeats(name),
                price = data.price,
            }
        end)
    end
end

local function deleteVehicles(key)
    for _, vehicle in pairs(spawnedVehicles[key] or {}) do
        exports.ox_target:removeLocalEntity(vehicle)
        if DoesEntityExist(vehicle) then
            SetEntityAsMissionEntity(vehicle, false, true)
            DeleteEntity(vehicle)
        end
    end

    spawnedVehicles[key] = {}
    cachedVehicleData[key] = {}
end

for key, dealer in pairs(VEHICLE_DEALERS) do
    local blip, ped = dealer.blip, dealer.ped
    local coords = dealer.coords

    if blip then
        Client.functions.createBlip({
            coords = coords,
            label = blip.label,
            scale = blip.scale,
            sprite = blip.sprite,
            color = blip.color,
        })
    end

    ---@diagnostic disable-next-line: inject-field
    ped.coords = coords
    Client.functions.addPedInteraction({
        ped = ped --[[@as PedData]],
        interactions = {
            label = 'Open vehicle dealer',
            icon = 'fas fa-car',
            onSelect = function()
                openVehicleDealer(key)
            end
        },
    })

    lib.points.new({
        coords = coords,
        distance = dealer.radius,
        onEnter = function()
            spawnVehicles(key)
        end,
        onExit = function()
            deleteVehicles(key)
        end
    })
end

AddEventHandler('onResourceStop', function(resource)
    if resource == cache.resource then
        for key, _ in pairs(spawnedVehicles) do
            deleteVehicles(key)
        end
    end
end)
