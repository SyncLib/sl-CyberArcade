fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Free, open source arcade hackers den'
author 'Macky'
version '1.0'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/*.lua',
}

server_script 'server/*.lua'

shared_script 'config.lua'