Client = {
    functions = {}
}

FUNCTIONS_PATH = 'src.client.functions.%s'
MODULES_PATH = 'src.client.modules.%s'

Client.functions = require 'src.client.functions.main'

CreateThread(function()
    for moduleName, moduleState in pairs(lib.load('data.modules') --[[@as table<string, boolean|'client'|'server'|'shared'>]]) do
        if moduleState and (moduleState == 'client' or moduleState == 'shared') then
            Shared.debug(('Loading module \'%s\' on client-side...'):format(moduleName))
            local success, result = pcall(require, (MODULES_PATH .. '.main'):format(moduleName))
            if not success then
                Shared.print(('Failed to load module \'%s\' on client-side!'):format(moduleName))
                Shared.debug(result)
            else
                Shared.debug(('Module \'%s\' on client-side loaded successfully!'):format(moduleName))
            end
        end
    end
end)
