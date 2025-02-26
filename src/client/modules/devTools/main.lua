RegisterCommand('pvd', function(source, args, raw)
    if not cache.vehicle then
        return lib.notify({ type = 'error', description = 'You are not in a vehicle!' })
    end

    lib.print.info(lib.getVehicleProperties(cache.vehicle))
    lib.print.info(Entity(cache.vehicle).state.vehicleId)
end)

CreateThread(function()
    exports.ox_target:addGlobalObject({
        {
            label = 'Copy model',
            icon = 'fas fa-cube',
            onSelect = function(data)
                ---@diagnostic disable-next-line: param-type-mismatch
                lib.setClipboard(GetEntityModel(data.entity))
                lib.notify({ type = 'success', description = 'Model copied!' })
            end
        },
        {
            label = 'Copy coords',
            icon = 'fas fa-map-marker-alt',
            onSelect = function(data)
                local coords = GetEntityCoords(data.entity)
                lib.setClipboard(coords.x .. ', ' .. coords.y .. ', ' .. coords.z)
                lib.notify({ type = 'success', description = 'Coords copied!' })
            end
        }
    })
end)
