--[[ FX Information ]]--
fx_version   'cerulean'
use_experimental_fxv2_oal 'yes'
lua54        'yes'
games        { 'gta5' }

--[[ Resource Information ]]--
name         'PooC'
author       'zeixna'
version      '0.0.1'
license      'LGPL-3.0-or-later'
repository   'https://github.com/Poo-Core/PooC'
description  'A shitty framework that will use state bags and OOP design'

--[[ Manifest ]]--
dependencies {
	'/server:5848',
    '/onesync',
}

--ui_page 'web/build/index.html'

--[[files {
    'init.lua',
    'modules/**/client.lua',
    'modules/**/shared.lua',
    --'web/build/index.html',
    --'web/build/**/*',
	'locales/*.json',
}]]

shared_scripts {
    'Core/config.lua',
    'Core/class.lua', -- Whole project is based on this file.
    'init.lua',
    'Core/Classes/DataStructures/sh*.lua',
    'Core/classes/sh*.lua',
    'Core/Classes/Enums/sh*.lua',
    'Core/functions/sh*.lua',

    'modules/**/shared/*.lua'
}

client_scripts {
    'Core/classes/cl*.lua',
    'Core/Classes/Enums/cl*.lua',
    'Core/Classes/Managers/cl*.lua',
    'Core/Classes/Managers/sh*.lua',
    'Core/functions/cl*.lua',
    'Core/ui/clUI.lua',
    'Core/client/main.lua',

    'modules/**/client/*.lua'
}

server_scripts {
    'Core/svConfig.lua',
    '@oxmysql/lib/MySQL.lua',
    'Core/classes/svMySQL.lua',
    'Core/classes/sv*.lua',
    'Core/Classes/Managers/sh*.lua',
    'Core/Classes/Managers/sv*.lua',
    'Core/functions/sv*.lua',

    'Core/server/main.lua',

    'modules/**/server/*.lua'
}