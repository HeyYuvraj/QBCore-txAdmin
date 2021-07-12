fx_version 'cerulean'
game 'gta5'

description 'QB-BossMenu'
version '1.0.0'

shared_script '@qb-core/import.lua'
client_script 'client/client.lua'
server_script 'server/server.lua'
ui_page 'html/index.html'

files {
    'html/*',
    'html/assets/*',
}

server_export "GetAccount"