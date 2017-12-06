function throwing_register_arrow_standard (kind, desc, eq, craft)
	minetest.register_craftitem("throwing:arrow_" .. kind, {
		description = desc .. " Arrow",
		inventory_image = "throwing_arrow_" .. kind .. ".png",
	})

	minetest.register_node("throwing:arrow_" .. kind .. "_box", {
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				-- Shaft
				{-6.5/17, -1.5/17, -1.5/17, 6.5/17, 1.5/17, 1.5/17},
				--Spitze
				{-4.5/17, 2.5/17, 2.5/17, -3.5/17, -2.5/17, -2.5/17},
				{-8.5/17, 0.5/17, 0.5/17, -6.5/17, -0.5/17, -0.5/17},
				--Federn
				{6.5/17, 1.5/17, 1.5/17, 7.5/17, 2.5/17, 2.5/17},
				{7.5/17, -2.5/17, 2.5/17, 6.5/17, -1.5/17, 1.5/17},
				{7.5/17, 2.5/17, -2.5/17, 6.5/17, 1.5/17, -1.5/17},
				{6.5/17, -1.5/17, -1.5/17, 7.5/17, -2.5/17, -2.5/17},

				{7.5/17, 2.5/17, 2.5/17, 8.5/17, 3.5/17, 3.5/17},
				{8.5/17, -3.5/17, 3.5/17, 7.5/17, -2.5/17, 2.5/17},
				{8.5/17, 3.5/17, -3.5/17, 7.5/17, 2.5/17, -2.5/17},
				{7.5/17, -2.5/17, -2.5/17, 8.5/17, -3.5/17, -3.5/17},
			}
		},
		tiles = {"throwing_arrow_" .. kind .. ".png", "throwing_arrow_" .. kind .. ".png", "throwing_arrow_" .. kind .. "_back.png", "throwing_arrow_" .. kind .. "_front.png",
		"throwing_arrow_" .. kind .. "_2.png", "throwing_arrow_" .. kind .. ".png"},
		groups = {not_in_creative_inventory=1},
	})

local function add_effects(pos, node)
	minetest.sound_play("default_dug_metal", {pos=pos, gain=1, max_hear_distance=2*64})
	if minetest.registered_nodes[node.name].tiles~=nil then
		texture = minetest.registered_nodes[node.name].tiles[1]
		minetest.add_particlespawner({
			amount = 8,
			time = 0.1,
			minpos = pos,
			maxpos = pos,
			minvel = {x = -2, y = -2, z = -2},
			maxvel = {x = 2, y = 2,  z = 2},
			minacc = {x = 0, y = -8, z = 0},
			maxacc = {x = 0, y = -8, z = 0},
			minexptime = 0.8,
			maxexptime = 2.0,
			minsize = 1,
			maxsize = 3,
			texture = texture,
			collisiondetection = true,
			})
	end
end
	local THROWING_ARROW_ENTITY={
		physical = false,
		visual = "wielditem",
		visual_size = {x=0.1, y=0.1},
		textures = {"throwing:arrow_" .. kind .. "_box"},
		lastpos={},
		collisionbox = {0,0,0,0,0,0},
		player = "",
	}

	THROWING_ARROW_ENTITY.on_step = function(self, dtime)
		local newpos = self.object:getpos()
		if self.lastpos.x ~= nil then
			for _, pos in pairs(throwing_get_trajectoire(self, newpos)) do
				local node = minetest.get_node(pos)
				local objs = minetest.get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2)
				for k, obj in pairs(objs) do
					local objpos = obj:getpos()
					if throwing_is_player(self.player, obj) or throwing_is_entity(obj) then
						if throwing_touch(pos, objpos) then
							local puncher = self.object
							if self.player and minetest.get_player_by_name(self.player) then
								puncher = minetest.get_player_by_name(self.player)
							end
							local speed = vector.length(self.object:getvelocity())
							local damage = ((speed + eq)^1.2)/10
							obj:punch(puncher, 1.0, {
								full_punch_interval=1.0,
								damage_groups={fleshy=damage},
							}, nil)
							minetest.sound_play("default_dug_metal", {pos=objpos, gain=1, max_hear_distance=2*64})
							if math.random() < THROWING_RECOVERY_CHANCE then
								minetest.add_item(self.lastpos, 'throwing:arrow_' .. kind)
							else
								minetest.add_item(self.lastpos, 'default:stick')
							end
							self.object:remove()
							return
						end
					end
				end
				if node.name ~= "air"
				and not string.find(node.name, 'water_')
				and not (string.find(node.name, 'grass') and not string.find(node.name, 'dirt'))
				and not (string.find(node.name, 'farming:') and not string.find(node.name, 'soil'))
				and not string.find(node.name, 'flowers:')
				and not string.find(node.name, 'fire:') then
					add_effects(self.lastpos, node)
					if math.random() < THROWING_RECOVERY_CHANCE then
						minetest.add_item(self.lastpos, 'throwing:arrow_' .. kind)
					else
						minetest.add_item(self.lastpos, 'default:stick')
					end
					self.object:remove()
					return
				end
				self.lastpos={x=pos.x, y=pos.y, z=pos.z}
			end
		end
		self.lastpos={x=newpos.x, y=newpos.y, z=newpos.z}
	end

	minetest.register_entity("throwing:arrow_" .. kind .. "_entity", THROWING_ARROW_ENTITY)

	minetest.register_craft({
		output = 'throwing:arrow_' .. kind .. ' 4',
		recipe = {
			{'default:stick', 'default:stick', craft},
		}
	})
end

if not DISABLE_STONE_ARROW then
	throwing_register_arrow_standard ('stone', 'Stone', 5, 'group:stone')
end

if not DISABLE_STEEL_ARROW then
	throwing_register_arrow_standard ('steel', 'Steel', 12, 'default:steel_ingot')
end

if not DISABLE_OBSIDIAN_ARROW then
	throwing_register_arrow_standard ('obsidian', 'Obsidian', 18, 'default:obsidian')
end

if not DISABLE_DIAMOND_ARROW then
	throwing_register_arrow_standard ('diamond', 'Diamond', 25, 'default:diamond')
end

if minetest.get_modpath('moreores') and not DISABLE_MITHRIL_ARROW then
	throwing_register_arrow_standard ('mithril', 'Mithril', 30, 'moreores:mithril_ingot')
end
