if not DISABLE_WOODEN_BOW then
	throwing_register_bow ('bow_wood', 'Wooden bow', {x=1, y=1, z=0.5}, 18, 1, 50, false, {
		retrieveCraft({
					{'', 'default:stick', ''},
					{'default:stick', '', 'default:junglegrass'},
					{'', 'default:stick', ''},
					}),
		retrieveCraft({
					{'', 'default:stick', ''},
					{'default:stick', '', 'farming:string'},
					{'', 'default:stick', ''},
					}),
		retrieveCraft({
					{'', 'default:stick', ''},
					{'default:stick', '', 'group:vines'},
					{'', 'default:stick', ''},
					}, "vines"),
		retrieveCraft({
					{'', 'default:stick', ''},
					{'default:stick', '', 'moreblocks:rope'},
					{'', 'default:stick', ''},
					}, "moreblocks"),
	})
end

if not DISABLE_LONGBOW then
	throwing_register_bow ('longbow', 'Longbow', {x=1, y=2.5, z=0.5}, 21, 2, 75, false, {
		retrieveCraft({
					{'', 'group:wood', 'default:junglegrass'},
					{'group:wood', '', 'default:junglegrass'},
					{'', 'group:wood', 'default:junglegrass'},
					}),
		retrieveCraft({
					{'', 'group:wood', 'farming:string'},
					{'group:wood', '', 'farming:string'},
					{'', 'group:wood', 'farming:string'},
					}),
		retrieveCraft({
					{'', 'group:wood', 'group:vines'},
					{'group:wood', '', 'group:vines'},
					{'', 'group:wood', 'group:vines'},
					}, "vines"),
		retrieveCraft({
					{'', 'group:wood', 'moreblocks:rope'},
					{'group:wood', '', 'moreblocks:rope'},
					{'', 'group:wood', 'moreblocks:rope'},
					}, "moreblocks"),
	})
end

if not DISABLE_COMPOSITE_BOW then
	throwing_register_bow ('bow_composite', 'Composite bow', {x=1, y=1.4, z=0.5}, 25, 1.5, 150, false, {
		retrieveCraft({
					{'', 'group:wood', 'farming:string'},
					{'default:steel_ingot', '', 'farming:string'},
					{'', 'group:wood', 'farming:string'},
					}),
	})
end

if not DISABLE_STEEL_BOW then
	throwing_register_bow ('bow_steel', 'Steel bow', {x=1, y=1.4, z=0.5}, 30, 2, 300, false, {
		retrieveCraft({
					{'', 'default:steel_ingot', 'farming:string'},
					{'default:steel_ingot', '', 'farming:string'},
					{'', 'default:steel_ingot', 'farming:string'},
					}),
	})
end

if not DISABLE_COMPOUND_BOW then
	throwing_register_bow ('compound_bow', 'Compound bow', {x=1, y=1.5, z=0.5}, 35, 1, 500, false, {
		retrieveCraft({
					{'default:steel_ingot', 'default:steel_ingot', 'farming:string'},
					{'default:steelblock', '', 'group:wool'},
					{'default:steel_ingot', 'default:steel_ingot', 'farming:string'},
					}),
	})
end

if not DISABLE_CROSSBOW then
	throwing_register_bow ('crossbow', 'Crossbow', {x=1, y=1.3, z=0.5}, 45, 3, 200, true, {
		retrieveCraft({
					{'default:steel_ingot', 'farming:string', ''},
					{'default:steelblock', 'farming:string', 'group:wood'},
					{'default:steel_ingot', 'farming:string', ''},
					}),
	})
end

if not DISABLE_REPEATING_CROSSBOW then
	throwing_register_bow ('repeating_crossbow', 'Repeating crossbow', {x=1, y=1.3, z=0.5}, 25, 0.4, 100, true, {
		retrieveCraft({
					{'group:wood', 'farming:string', 'group:wood'},
					{'default:steelblock', 'farming:string', 'default:steel_ingot'},
					{'group:wood', 'farming:string', 'group:wood'},
					}),
	})
end

if not DISABLE_ARBALEST then
	throwing_register_bow ('arbalest', 'Arbalest', {x=1, y=1.3, z=0.5}, 60, 5, 500, true, {
		retrieveCraft({
					{'default:steel_ingot', 'group:wool', 'default:steel_ingot'},
					{'default:steelblock', 'group:wool', 'default:steelblock'},
					{'default:steel_ingot', 'group:wool', 'default:steel_ingot'},
					}),
	})
end

if not DISABLE_AUTOMATED_ARBALEST then
	throwing_register_bow ('arbalest_auto', 'Automated arbalest', {x=1, y=1.3, z=0.5}, 60, 2, 500, true, {
		retrieveCraft({
					{'default:steelblock', 'group:wool', 'default:steel_ingot'},
					{'default:steelblock', 'group:wool', 'default:steelblock'},
					{'default:steelblock', 'group:wool', 'default:steel_ingot'},
					}),
	})
end
