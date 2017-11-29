if not DISABLE_WOODEN_BOW then
	throwing_register_bow ('bow_wood', 'Wooden bow', {x=1, y=1, z=0.5}, 20, 1, 25, false, {
			{'', 'default:stick', ''},
			{'farming:string', '', 'default:stick'},
			{'', 'default:stick', ''},
		})
end

if not DISABLE_LONGBOW then
	throwing_register_bow ('longbow', 'Longbow', {x=1, y=2.5, z=0.5}, 23, 2, 50, false, {
			{'farming:string', 'group:wood', ''},
			{'farming:string', '', 'group:wood'},
			{'farming:string', 'group:wood', ''},
		})
end

if not DISABLE_COMPOSITE_BOW then
	throwing_register_bow ('bow_composite', 'Composite bow', {x=1, y=1.4, z=0.5}, 25, 1.5, 100, false, {
			{'farming:string', 'group:wood', ''},
			{'farming:string', '', 'default:steel_ingot'},
			{'farming:string', 'group:wood', ''},
		})
end

if not DISABLE_STEEL_BOW then
	throwing_register_bow ('bow_steel', 'Steel bow', {x=1, y=1.4, z=0.5}, 30, 2, 200, false, {
			{'farming:string', 'default:steel_ingot', ''},
			{'farming:string', '', 'default:steel_ingot'},
			{'farming:string', 'default:steel_ingot', ''},
		})
end

if not DISABLE_COMPOUND_BOW then
	throwing_register_bow ('compound_bow', 'Compound bow', {x=1, y=1.5, z=0.5}, 35, 1, 500, false, {
			{'farming:string', 'default:steel_ingot', 'default:steel_ingot'},
			{'farming:string', '', 'default:steelblock'},
			{'farming:string', 'default:steel_ingot', 'default:steel_ingot'},
		})
end

--function throwing_register_bow (name, desc, scale, stiffness, reload_time, toughness, is_cross, craft)

if not DISABLE_CROSSBOW then
	throwing_register_bow ('crossbow', 'Crossbow', {x=1, y=1.3, z=0.5}, 45, 3.5, 150, true, {
			{'default:steel_ingot', 'farming:string', ''},
			{'group:wood', 'farming:string', 'default:steelblock'},
			{'default:steel_ingot', 'farming:string', ''},
		})
end

if not DISABLE_REPEATING_CROSSBOW then
	throwing_register_bow ('repeating_crossbow', 'Repeating crossbow', {x=1, y=1.3, z=0.5}, 25, 0.4, 100, true, {
			{'group:wood', 'farming:string', 'group:wood'},
			{'default:steel_ingot', 'farming:string', 'default:steelblock'},
			{'group:wood', 'farming:string', 'group:wood'},
		})
end

if not DISABLE_ARBALEST then
	throwing_register_bow ('arbalest', 'Arbalest', {x=1, y=1.3, z=0.5}, 60, 5, 200, true, {
			{'default:steel_ingot', 'farming:string', 'default:steel_ingot'},
			{'default:steelblock', 'farming:string', 'default:steelblock'},
			{'default:steel_ingot', 'farming:string', 'default:steel_ingot'},
		})
end

if not DISABLE_AUTOMATED_ARBALEST then
	throwing_register_bow ('arbalest_auto', 'Automated arbalest', {x=1, y=1.3, z=0.5}, 60, 2, 200, true, {
			{'default:steel_ingot', 'farming:string', 'default:steelblock'},
			{'default:steelblock', 'farming:string', 'default:steelblock'},
			{'default:steel_ingot', 'farming:string', 'default:steelblock'},
		})
end
