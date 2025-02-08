Shared = {
    DEBUG = GetConvarInt('core:debug', 1) == 1,
    PREFIX = '^1[^5core^1]^7 '
}

lib.locale()

---Outputs something to trace listeners.
---@param ... any
function Shared.print(...)
    local args = { ... }
    local str = ''
    for i = 1, #args do
        str = str .. tostring(args[i]) .. ' '
    end
    str = str:sub(1, -2)
    Citizen.Trace(Shared.PREFIX .. str .. '\n')
end

---Outputs something to trace listeners, if debug is active.
---`DEBUG`
---@param ... any
function Shared.debug(...)
    if not Shared.DEBUG then return end
    Shared.print(...)
end

Shared.print(('Debug is %s!'):format(Shared.DEBUG and 'enabled' or 'disabled'))

require 'shared.utils.tables'

CreateThread(function()
    for moduleName, moduleState in pairs(lib.load('data.modules')) do
        if moduleState then
            Shared.debug(('Loading module \'%s\' on %s-side...'):format(moduleName, lib.context))
            local success, result = pcall(require, ('%s.modules.%s.main'):format(lib.context, moduleName))
            if not success then
                Shared.print(('Failed to load module \'%s\' on %s-side!'):format(moduleName, lib.context))
            else
                Shared.debug(('Module \'%s\' on %s-side loaded successfully!'):format(moduleName, lib.context))
            end
        end
    end
end)
