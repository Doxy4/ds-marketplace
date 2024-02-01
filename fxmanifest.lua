fx_version 'cerulean'
game 'gta5'

author 'Doxy'
description 'ONLINE MARKETPLACE'
version '1.0'

escrow_ignore {
    'config.lua',
    'README.md',
    'ui/dashboard.html',
    'ui/app.js',
    'ui/style.css',
    'client/main.lua',
    'server/main.lua',
    'marketplace.sql'
}
shared_script 'config.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

client_script {
    'client/main.lua',
}

ui_page 'ui/dashboard.html'

files {
    'ui/dashboard.html',
    'ui/app.js',
    'ui/style.css',
}

lua54 'yes'