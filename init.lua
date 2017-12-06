throwing_arrows = {
	{"throwing:arrow_steel", "throwing:arrow_steel_entity"},
	{"throwing:arrow_stone", "throwing:arrow_stone_entity"},
	{"throwing:arrow_obsidian", "throwing:arrow_obsidian_entity"},
	{"throwing:arrow_diamond", "throwing:arrow_diamond_entity"},
	{"throwing:arrow_mithril", "throwing:arrow_mithril_entity"},
	{"throwing:arrow_teleport", "throwing:arrow_teleport_entity"},
	{"throwing:arrow_dig", "throwing:arrow_dig_entity"},
	{"throwing:arrow_tnt", "throwing:arrow_tnt_entity"},
	{"throwing:arrow_torch", "throwing:arrow_torch_entity"},
	{"throwing:arrow_fireworks_red", "throwing:arrow_fireworks_red_entity"},
	{"throwing:arrow_fireworks_blue", "throwing:arrow_fireworks_blue_entity"},
	{"throwing:arrow_fireworks_green", "throwing:arrow_fireworks_green_entity"},
	{"throwing:arrow_rope", "throwing:arrow_rope_entity"},
	{"throwing:arrow_lightning", "throwing:arrow_lightning_entity"},
}

dofile(minetest.get_modpath("throwing").."/defaults.lua")

dofile(minetest.get_modpath("throwing").."/functions.lua")

dofile(minetest.get_modpath("throwing").."/tools.lua")

dofile(minetest.get_modpath("throwing").."/standard_arrows.lua")

if not DISABLE_TELEPORT_ARROW then
	dofile(minetest.get_modpath("throwing").."/teleport_arrow.lua")
end

if not DISABLE_DIG_ARROW then
	dofile(minetest.get_modpath("throwing").."/dig_arrow.lua")
end

if minetest.get_modpath('tnt') and not DISABLE_TNT_ARROW then
	dofile(minetest.get_modpath("throwing").."/tnt_arrow.lua")
end

if not DISABLE_TORCH_ARROW then
	dofile(minetest.get_modpath("throwing").."/torch_arrow.lua")
end

if minetest.get_modpath('tnt') then
	dofile(minetest.get_modpath("throwing").."/fireworks_arrows.lua")
end

if minetest.setting_get("log_mods") then
	minetest.log("action", "throwing loaded")
end

if minetest.get_modpath('vines') and not DISABLE_ROPE_ARROW then
	dofile(minetest.get_modpath("throwing").."/rope_arrow.lua")
end

if minetest.get_modpath('lightning') and minetest.get_modpath('lightning') and not DISABLE_LIGHTNING_ARROW then
	dofile(minetest.get_modpath("throwing").."/lightning_arrow.lua")
end
