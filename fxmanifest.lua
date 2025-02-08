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
    'oxmysql',
    'ox_lib'
}

client_script 'client/init.lua'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'shared/init.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/init.lua'
}

files {
    'locales/**',
    'data/**',
    'client/utils/**',
    'client/modules/**',
    'shared/utils/**',
}
