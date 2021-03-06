minetest.register_craftitem("throwing:arrow_torch", {
	description = "Torch Arrow",
	inventory_image = "throwing_arrow_torch.png",
})

minetest.register_node("throwing:arrow_torch_box", {
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
	tiles = {"throwing_arrow_torch.png", "throwing_arrow_torch.png", "throwing_arrow_torch_back.png", "throwing_arrow_torch_front.png", "throwing_arrow_torch_2.png", "throwing_arrow_torch.png"},
	groups = {not_in_creative_inventory=1},
})

local function add_effects(pos, node)
	minetest.sound_play("default_dug_node", {pos=pos, gain=1, max_hear_distance=2*64})
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
	textures = {"throwing:arrow_torch_box"},
	lastpos={},
	collisionbox = {0,0,0,0,0,0},
	node = "",
	player = "",
}

THROWING_ARROW_ENTITY.on_step = function(self, dtime)
	local newpos = self.object:getpos()
	if self.lastpos.x~= nil then
		for _, pos in pairs(throwing_get_trajectoire(self, newpos)) do
			local node = minetest.get_node(pos)
			local objs = minetest.get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 0.5)
			for k, obj in pairs(objs) do
				local objpos = obj:getpos()
				if throwing_is_player(self.player, obj) or throwing_is_entity(obj) then
					if throwing_touch(pos, objpos) then
						local puncher = self.object
						if self.player and minetest.get_player_by_name(self.player) then
							puncher = minetest.get_player_by_name(self.player)
						end
						local speed = vector.length(self.object:getvelocity())
						local damage = ((speed + 5)^1.2)/10
						obj:punch(puncher, 1.0, {
							full_punch_interval=1.0,
							damage_groups={fleshy=damage},
						}, nil)
						local toughness = 0.9
						if math.random() < THROWING_RECOVERY_CHANCE then
							minetest.add_item(pos, 'throwing:arrow_torch')
						else
							minetest.add_item(pos, 'default:stick')
						end
						self.object:remove()
						return
					end
				end
			end


			if node.name ~= "air"
			and not (string.find(node.name, 'grass') and not string.find(node.name, 'dirt'))
			and not (string.find(node.name, 'farming:') and not string.find(node.name, 'soil'))
			and not string.find(node.name, 'flowers:')
			and not string.find(node.name, 'fire:') then
				local player = minetest.get_player_by_name(self.player)
				if not player then self.object:remove() return end
				if node.name ~= "ignore" and not string.find(node.name, "water_") and not string.find(node.name, "lava")
				 and not string.find(node.name, "torch") and minetest.get_item_group(node.name, "unbreakable") == 0
				 and not minetest.is_protected(self.lastpos, self.player) and node.diggable ~= false then
					local dir=vector.direction(self.lastpos, pos)
					local wall=minetest.dir_to_wallmounted(dir)
					if wall == 0 then
						minetest.add_node(self.lastpos, {name="default:torch_ceiling", param2 = wall})
					elseif wall == 1 then 
						minetest.add_node(self.lastpos, {name="default:torch", param2 = wall})
					else
						minetest.add_node(self.lastpos, {name="default:torch_wall", param2 = wall})
					end
					add_effects(self.lastpos, node)
				else
					if math.random() < THROWING_RECOVERY_CHANCE then
							minetest.add_item(pos, 'throwing:arrow_torch')
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

minetest.register_entity("throwing:arrow_torch_entity", THROWING_ARROW_ENTITY)

minetest.register_craft({
	output = 'throwing:arrow_torch 4',
	recipe = {
		{'group:coal', 'default:stick', 'default:stick'},
	}
})

