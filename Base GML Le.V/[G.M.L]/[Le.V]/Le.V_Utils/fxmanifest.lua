fx_version 'adamant'

game 'gta5'

description 'Le.V_Core'

version '1.1.0'

client_scripts {
	'@es_extended/locale.lua',
	'locale.lua',
	'skin_locales/br.lua',
	'skin_locales/de.lua',
	'skin_locales/en.lua',
	'skin_locales/fi.lua',
	'skin_locales/fr.lua',
	'skin_locales/sv.lua',
	'skin_config.lua',
	'skin_c.lua',
	'skin_module.lua',
	'bansql/client.lua',
	'vs_c.lua',
	'status_locales/de.lua',
	'status_locales/br.lua',
	'status_locales/en.lua',
	'status_locales/fi.lua',
	'status_locales/fr.lua',
	'status_locales/sv.lua',
	'status_locales/pl.lua',
	'status_config.lua',
	'status_c.lua',
	'status_main.lua',
	'instance_c.lua',
	'ads_c.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'skin_locales/de.lua',
	'skin_locales/br.lua',
	'skin_locales/en.lua',
	'skin_locales/fi.lua',
	'skin_locales/fr.lua',
	'skin_locales/sv.lua',
	'skin_locales/pl.lua',
	'skin_config.lua',
	'skin_s.lua',
	'bansql/config.lua',
	'bansql/server/function.lua',
	'bansql/server/main.lua',
	'vs_s.lua',
	'status_locales/de.lua',
	'status_locales/br.lua',
	'status_locales/en.lua',
	'status_locales/fi.lua',
	'status_locales/fr.lua',
	'status_locales/sv.lua',
	'status_locales/pl.lua',
	'status_config.lua',
	'status_s.lua',
	'instance_s.lua',
	'addon_c.lua',
	'addon_s.lua',
	'addoninv_c.lua',
	'addoninv_s.lua',
	'license_s.lua',
	'datastore_c.lua',
	'datastore_s.lua',
	'ads_s.lua',
}

dependencies {
	'es_extended',
}
