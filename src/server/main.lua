Server = {
    functions = require 'src.server.functions.main'
}

FUNCTIONS_PATH = 'src.server.functions.%s'
MODULES_PATH = 'src.server.modules.%s'

CreateThread(function()
    for moduleName, moduleState in pairs(lib.load('data.modules') --[[@as table<string, boolean|'client'|'server'|'shared'>]]) do
        if moduleState and (moduleState == 'server' or moduleState == 'shared') then
            Shared.debug(('Loading module \'%s\' on server-side...'):format(moduleName))
            local success, result = pcall(require, (MODULES_PATH .. '.main'):format(moduleName))
            if not success then
                Shared.print(('Failed to load module \'%s\' on server-side!'):format(moduleName))
                Shared.debug(result)
            else
                Shared.debug(('Module \'%s\' on server-side loaded successfully!'):format(moduleName))
            end
        end
    end
end)
