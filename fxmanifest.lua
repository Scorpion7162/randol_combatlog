fx_version 'cerulean'
game 'gta5'
author 'Randolio'
description 'Resource to visualise players who have left the server'
version '2.0.0'


files {
    'locales/*.json'
}

shared_scripts {
    '@ox_lib/init.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/server/**.lua',
    'sv_dropped.lua',
    'sv_config.lua',
}

client_scripts {
    'bridge/client/**.lua',
    'cl_dropped.lua',
}

