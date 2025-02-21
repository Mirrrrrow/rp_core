---@type table<string, VehicleRental>
local VEHICLE_RENTALS <const> = lib.load('data.vehicleRental.vehicleRental')

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
        },
    })
end
