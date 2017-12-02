minetest.register_craftitem("throwing:arrow_dig", {
	description = "Dig Arrow",
	inventory_image = "throwing_arrow_dig.png",
})

minetest.register_node("throwing:arrow_dig_box", {
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
	tiles = {"throwing_arrow_dig.png", "throwing_arrow_dig.png", "throwing_arrow_dig_back.png", "throwing_arrow_dig_front.png", "throwing_arrow_dig_2.png", "throwing_arrow_dig.png"},
	groups = {not_in_creative_inventory=1},
})

local function addEffect(pos, node)
	minetest.sound_play("default_dug_node", {pos=pos, gain=1, max_hear_distance=2*64})
	if minetest.registered_nodes[node.name].tiles~=nil then
		texture=minetest.registered_nodes[node.name].tiles[1]
		minetest.add_particlespawner({
				amount = 16,
				time = 0.1,
				minpos = pos,
				maxpos = pos,
				minvel = {x = -5, y = -5, z = -5},
				maxvel = {x = 5, y = 5,  z = 5},
				minacc = {x = 0, y = -8, z = 0},
				maxacc = {x = 0, y = -8, z = 0},
				minexptime = 0.8,
				maxexptime = 2.0,
				minsize = 4,
				maxsize = 6,
				texture = texture,
				collisiondetection = true,
			})
	end
end

local THROWING_ARROW_ENTITY={
	physical = false,
	timer=0,
	visual = "wielditem",
	visual_size = {x=0.1, y=0.1},
	textures = {"throwing:arrow_dig_box"},
	lastpos={},
	collisionbox = {0,0,0,0,0,0},
	player = "",
	bow_damage = 0,
}


THROWING_ARROW_ENTITY.on_step = function(self, dtime)
	local newpos = self.object:getpos()
	if self.lastpos.x ~= nil then
		for _, pos in pairs(throwing_get_trajectoire(self, newpos)) do
			local node = minetest.get_node(pos)
			local objs = minetest.get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 1)
			for k, obj in pairs(objs) do
				if throwing_is_player(self.player, obj) or throwing_is_entity(obj) then
					if throwing_touch(pos, obj:getpos()) then
						if math.random() < THROWING_RECOVERY_CHANCE then
							minetest.add_item(pos, 'throwing:arrow_dig')
						else
							minetest.add_item(pos, 'default:stick')
						end
						self.object:remove()
						return
					end
				end
			end
			if node.name ~= "air"
			and not string.find(node.name, "water_")
			and not (string.find(node.name, 'grass') and not string.find(node.name, 'dirt'))
			and not (string.find(node.name, 'farming:') and not string.find(node.name, 'soil'))
			and not string.find(node.name, 'flowers:')
			and not string.find(node.name, 'fire:') then
				if node.name ~= "ignore" and minetest.get_item_group(node.name, "unbreakable") == 0
					and not minetest.is_protected(pos, self.player)
					and node.diggable ~= false then
					addEffect(pos, node)
					minetest.dig_node(pos)
					--minetest.add_item(pos, node.name)
				else
					if math.random() < THROWING_RECOVERY_CHANCE then
						minetest.add_item(pos, 'throwing:arrow_dig')
					else
						minetest.add_item(pos, 'default:stick')
					end
				end
				self.object:remove()
				return
			end
			self.lastpos={x=pos.x, y=pos.y, z=pos.z}
		end
	end
	self.lastpos={x=newpos.x, y=newpos.y, z=newpos.z}
end

minetest.register_entity("throwing:arrow_dig_entity", THROWING_ARROW_ENTITY)

minetest.register_craft({
	output = 'throwing:arrow_dig 4',
	recipe = {
		{'default:stick', 'default:stick', 'default:pick_steel'},
	}
})

minetest.register_craft({
	output = 'throwing:arrow_dig 4',
	recipe = {
		{'default:pick_steel', 'default:stick', 'default:stick'},
	}
})
