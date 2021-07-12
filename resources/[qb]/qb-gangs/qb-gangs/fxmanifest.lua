fx_version 'cerulean'
game 'gta5'

version '2.4'

author 'Mojito-Fivem'

client_scripts {
	'client/main.lua',
	'client/gui.lua',
	'client/creation.lua'
}

server_scripts {
	'server/config.lua/',
	'server/main.lua',
	'server/version.lua'
}

files {
	'*.json',

	'html/img/*.png',
	'html/sounds/*.wav',
	
	'html/index.html',
	'html/js/*.js',
	'html/css/*.css'
} 

ui_page 'html/index.html'
