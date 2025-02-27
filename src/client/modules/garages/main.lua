local GARAGES <const> = lib.load('data.garages.garages')

local function openGarageMenu(key)
    local garage = GARAGES[key]
    local vehicles = lib.callback.await('garage:server:getVehicles', false, key)

    local options, n = {
        {
            title = 'Close',
            icon = 'fas fa-xmark',
            onSelect = function()
                lib.hideContext()
            end
        },
        {
            title = '',
            disabled = true
        }
    }, 3

    for _, vehicle in ipairs(vehicles) do
        local vehicleId = vehicle.vehicleId
        local props = vehicle.props
        options[n] = {
            title = ('%s - %s'):format(Client.functions.parseVehicleData(props.model).displayLabel, vehicle
                .plate),
            description = ('ID: **%s**.'):format(vehicleId),
            icon = 'car',
            onSelect = function()
                local spawnpoint = Client.functions.reducePoints(garage.spawnpoints, true)
                if not spawnpoint then
                    return lib.notify({
                        title = garage.blip.label,
                        description = 'No spawnpoints available.',
                        type = 'error'
                    })
                end

                local success, result = lib.callback.await('garage:server:parkOut', false, key, vehicleId)
                lib.notify({
                    title = garage.blip.label,
                    description = result,
                    type = success and 'success' or 'error'
                })

                if not success then return end
                ESX.Game.SpawnVehicle(props.model, spawnpoint.xyz, spawnpoint.w, function(spawnedVehicle)
                    if vehicle.props then
                        lib.setVehicleProperties(spawnedVehicle, vehicle.props)
                    end

                    Wait(0) -- Could delete this?
                    local networkId = NetworkGetNetworkIdFromEntity(spawnedVehicle)
                    TriggerServerEvent('garages:server:setVehicleAsSpawned', networkId)
                end)
            end
        }

        n += 1
    end

    local menuId = ('garage_%s'):format(key)
    lib.registerContext({
        id = menuId,
        title = garage.blip.label,
        options = options
    })

    lib.showContext(menuId)
end

for key, data in pairs(GARAGES) do
    local coords = data.coords

    local blip = data.blip
    if blip then
        Client.functions.createBlip({
            coords = coords,
            label = blip.label,
            sprite = blip.sprite,
            color = blip.color,
            scale = blip.scale
        })
    end

    local ped = data.ped
    ped.coords = coords
    Client.functions.addPedInteraction({
        ped = ped,
        interactions = {
            {
                label = 'Open Garage',
                icon = 'fas fa-car',
                onSelect = function()
                    openGarageMenu(key)
                end
            }
        }
    })

    local polyZone = data.polyZone
    lib.zones.poly({
        thickness = polyZone.thickness,
        points = polyZone.points,
        onEnter = function()
            lib.addRadialItem({
                id = 'garage_menu',
                icon = 'warehouse',
                label = 'Park vehicle',
                onSelect = function()
                    if not cache.vehicle then
                        return lib.notify({
                            title = data.blip.label,
                            description = 'You need to be in a vehicle to park it.',
                            type = 'error'
                        })
                    end

                    local success, result = lib.callback.await('garage:server:parkIn', false, key)
                    lib.notify({
                        title = data.blip.label,
                        description = result,
                        type = success and 'success' or 'error'
                    })

                    if not success then return end
                    ESX.Game.DeleteVehicle(cache.vehicle)
                end
            })
        end,
        onExit = function()
            lib.removeRadialItem('garage_menu')
        end
    })
end
