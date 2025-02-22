Shared = {
    DEBUG = GetConvarInt('core:debug', 1) == 1,
    DEBUG_NOTIFY = GetConvarInt('core:debug_notify', 1) == 1,
    PREFIX = '^1[^5core^1]^7 ',
    functions = {}
}

SHARED_FUNCTIONS_PATH = 'src.shared.functions.%s'
SHARED_MODULES_PATH = 'src.shared.modules.%s'

Shared.functions = require 'src.shared.functions.main'

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

    if Shared.DEBUG_NOTIFY then
        local data = {
            title = 'DEBUG',
            description = ...,
            position = 'top-left',
            type = 'info',
            iconColor = 'orange'
        }

        if IsDuplicityVersion() then
            lib.notify(-1, data)
        else
            lib.notify(data)
        end
    end
end

Shared.print(('Debug is %s!'):format(Shared.DEBUG and 'enabled' or 'disabled'))

exports('debug', Shared.debug)
