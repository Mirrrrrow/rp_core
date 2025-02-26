fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

author 'Mirow'
description 'Roleplay Core Resource with a lot of features!'
version '0.0.0'

repo 'Mirrrrrow/rp_core'
license 'GNU General Public License v3.0'

dependencies {
    'es_extended',
    'ox_target',
    'oxmysql',
    'ox_lib'
}

client_script 'src/client/main.lua'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'src/shared/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'src/server/main.lua'
}

files {
    'locales/**',
    'data/**',
    'src/client/functions/**',
    'src/client/modules/**',
    'src/shared/functions/**',
}
