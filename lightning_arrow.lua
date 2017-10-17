minetest.register_craftitem("throwing:arrow_lightning", {
	description = "Lightning Arrow",
	inventory_image = "throwing_arrow_lightning.png",
})

minetest.register_node("throwing:arrow_lightning_box", {
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
	tiles = {"throwing_arrow_lightning.png", "throwing_arrow_lightning.png", "throwing_arrow_lightning_back.png", "throwing_arrow_lightning_front.png", "throwing_arrow_lightning_2.png", "throwing_arrow_lightning.png"},
	groups = {not_in_creative_inventory=1},
})

local function addEffect(pos, node)
	if minetest.registered_nodes[node.name].tiles~=nil then
		texture = minetest.registered_nodes[node.name].tiles[1]
		minetest.add_particlespawner({
			amount = 32,
			time = 0.1,
			minpos = pos,
			maxpos = pos,
			minvel = {x = -5, y = 0, z = -5},
			maxvel = {x = 5, y = 30,  z = 5},
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

local function addSmoke(pos)
minetest.add_particle({
		pos = pos,
		velocity = vector.new(),
		acceleration = vector.new(),
		expirationtime = 0.4,
		size = 50,
		collisiondetection = false,
		vertical = false,
		texture = "tnt_boom.png",
		glow = 15,
	})
minetest.add_particlespawner({
		amount = 32,
		time = 0.5,
		minpos = pos,
		maxpos = pos,
		minvel = {x = -10, y = -10, z = -10},
		maxvel = {x = 10, y = 10, z = 10},
		minacc = {x = 0, y = 4, z = 0},
		maxacc = {x = 0, y = 4, z = 0},
		minexptime = 1,
		maxexptime = 2.5,
		minsize = 6,
		maxsize = 9,
		texture = "tnt_smoke.png",
        collisiondetection = true,
        glow=5,
    })
end

local THROWING_ARROW_ENTITY={
	physical = false,
	timer=0,
	visual = "wielditem",
	visual_size = {x=0.1, y=0.1},
	textures = {"throwing:arrow_lightning_box"},
	lastpos={},
	collisionbox = {0,0,0,0,0,0},
	player = "",
	bow_damage = 0,
}


THROWING_ARROW_ENTITY.on_step = function(self, dtime)
	local newpos = self.object:getpos()
	minetest.add_particlespawner({
			amount = 16,
			time = 0.1,
			minpos = newpos,
			maxpos = newpos,
			minvel = {x=-5+math.random(-5,5), y=-5+math.random(-5,5), z=-5+math.random(-5,5)},
			maxvel = {x=5+math.random(-5,5),  y=5+math.random(-5,5),  z=5+math.random(-5,5)},
			minacc = vector.new(),
			maxacc = {x=5+math.random(-5,5),  y=5+math.random(-5,5),  z=5+math.random(-5,5)},
			minexptime = 0.1,
			maxexptime = 0.2,
			minsize = 0.5,
			maxsize = 1,
			texture = "throwing_sparkle_blue.png",
            glow=10
		})
	if self.lastpos.x ~= nil then
		for _, pos in pairs(throwing_get_trajectoire(self, newpos)) do
			local node = minetest.get_node(pos)
			local objs = minetest.get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 1)
			for k, obj in pairs(objs) do
				if throwing_is_player(self.player, obj) or throwing_is_entity(obj) then
					if throwing_touch(pos, obj:getpos()) then
						local puncher = self.object
						if self.player and minetest.get_player_by_name(self.player) then
							puncher = minetest.get_player_by_name(self.player)
						end
						local speed = vector.length(self.object:getvelocity())
						local damage = ((speed + 10)^1.2)/10
						obj:punch(puncher, 1.0, {
							full_punch_interval=1.0,
							damage_groups={fleshy=damage},
						}, nil)
						lightning.strike(newpos)
						minetest.sound_play("tnt_explode", {pos=newpos, gain=1, max_hear_distance=2*64})
						addSmoke(newpos)
						self.object:remove()
						return
					end
				end
			end
			if node.name ~= "air" then
				lightning.strike(newpos)
				minetest.sound_play("tnt_explode", {pos=newpos, gain=1, max_hear_distance=2*64})
				addEffect(newpos, node)
				addSmoke(newpos)
				self.object:remove()
				return
			end
			self.lastpos={x=pos.x, y=pos.y, z=pos.z}
		end
	end
	self.lastpos={x=newpos.x, y=newpos.y, z=newpos.z}
end

minetest.register_entity("throwing:arrow_lightning_entity", THROWING_ARROW_ENTITY)

minetest.register_craft({
	output = 'throwing:arrow_lightning',
	recipe = {
		{'default:stick', 'default:stick', 'default:pick_steel'},
	}
})

minetest.register_craft({
	output = 'throwing:arrow_lightning',
	recipe = {
		{'default:pick_steel', 'default:stick', 'default:stick'},
	}
})
