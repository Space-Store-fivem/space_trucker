fx_version "cerulean"
game "gta5"
lua54 "yes"

--[[ Resource Information ]]
--
name "gs_trucker"
author "Gasman"
version "3.0.1"
description "GS Trucker Job V3 - Simulator, Dynamic, Skills, Over 1000 Truck Routes"

--[[ Manifest ]]
--
dependencies {
	"/server:5848",
	"/onesync",
}

escrow_ignore {
	"bridge/**/*.lua",
	"client/*.lua",
	"server/*.lua",
	"shared/*.lua",
	"shared/**/*.lua",
}

ui_page "web/build/index.html"

shared_scripts {
	"shared/locale.lua",
	"shared/gst_config.lua",
	"shared/class/industry.lua",
	"shared/class/industries.lua",
	"shared/industries/register_primary_industries.lua",
	"shared/industries/register_secondary_industries.lua",
	"shared/industries/register_businesses.lua",
}

client_scripts {
	"bridge/client/c_framework_qbcore.lua",
	"bridge/client/c_target_qbcore.lua",
	-- "bridge/client/c_framework_esx.lua",
	-- "bridge/client/c_target_esx.lua",
	"client/c_utils.lua",
	"client/c_points.lua",
	"client/c_main.lua",
	"client/c_skill.lua",
	"client/c_events.lua",
	"client/c_nui.lua",
	"client/c_rental.lua",
"client/c_company.lua",
'client/c_industry_management.lua',
'client/c_settings.lua',
'client/c_finance.lua',
	"client/c_tablet.lua",
	"client/c_missions.lua",
	"client/c_fleet.lua"
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"bridge/server/s_framework_qbcore.lua",
	-- "bridge/server/s_framework_esx.lua",
	"server/s_main.lua",
	"server/s_skill.lua",
	"server/s_cronjob.lua",
	"server/s_anticheat.lua",
	"server/s_company.lua",
	'server/s_industry_management.lua',
	'server/s_settings.lua',
	'server/s_finance.lua',
	'server/s_missions.lua',
	"server/s_rental.lua"
}

files {
	-- Client UI
	"web/build/index.html",
	"web/build/**/*",
	"locales/*.json"
}