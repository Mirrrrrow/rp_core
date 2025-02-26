---@type table<string, VehicleDealerConfig>
local VEHICLE_DEALERS <const> = lib.load('data.vehicleDealer.vehicleDealer')

local function openVehicleDealer(key)
    Shared.debug('openVehicleDealer')
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
end
