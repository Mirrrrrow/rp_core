--[[
    Manage each module. This file is used to define the modules that are available in the game.
    The key is the module name and the value is the module type.
    The module type can be 'client', 'server' or 'shared'.
    The module type defines where the module is loaded.
    If its false, the module is not loaded.
    Use this wisely, as it can break the game if you disable a module that is required.
]]

return {
    devTools = 'client',
    npcs = 'client',
    vehicleRental = 'shared',
    shops = 'shared',
    vehicleDealer = 'shared',
    garages = 'shared'
}
