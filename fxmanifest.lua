fx_version 'cerulean'
game 'gta5'
author 'f4st3r'
description 'FastScripts - FFA Script for roleplay and pvp servers'
version '1.0.0'
lua54 'yes'

client_scripts {"client/*.lua", "shared/client/*.lua"}
server_scripts {"server/*.lua", "@oxmysql/lib/MySQL.lua", "shared/server/*.lua"}
shared_scripts {"shared/*.lua"}

files {
    "html/*.html",
    "html/css/*.css",
    "html/js/*.js",
    "html/img/*.png",
    "html/img/*.jpg",
    "html/fonts/*.ttf"
}

ui_page {"html/index.html"}