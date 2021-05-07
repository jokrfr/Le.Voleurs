fx_version 'bodacious'
game 'gta5'
description 'Le.V Core (LUA)'
version '1.1.0'


client_scripts {

    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/*.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
    'crea_config.lua', 
    'creationperso_m.lua',
    'creationperso_c.lua', -- Créa de perso
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'creationperso_s.lua',
}
