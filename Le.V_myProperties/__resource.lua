resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'


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

}

client_scripts {
	'@NativeUI/NativeUI.lua',
	'propriete_config.lua',
	'propriete_c.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'propriete_config.lua',
	'propriete_s.lua',
}