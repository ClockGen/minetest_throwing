minetest.register_craftitem("throwing:arrow_tnt", {
	description = "TNT arrow",
	inventory_image = "throwing_arrow_tnt.png",
})

minetest.register_node("throwing:arrow_tnt_box", {
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
	tiles = {"throwing_arrow_tnt.png", "throwing_arrow_tnt.png", "throwing_arrow_tnt_back.png", "throwing_arrow_tnt_front.png", "throwing_arrow_tnt_2.png", "throwing_arrow_tnt.png"},
	groups = {not_in_creative_inventory=1},
})

local THROWING_ARROW_ENTITY={
	physical = false,
	timer=0,
	visual = "wielditem",
	visual_size = {x=0.1, y=0.1},
	textures = {"throwing:arrow_tnt_box"},
	lastpos={},
    player = "",
	collisionbox = {0,0,0,0,0,0},
}

local function add_effects(pos, radius)
	minetest.add_particle({
		pos = pos,
		velocity = vector.new(),
		acceleration = vector.new(),
		expirationtime = 0.4,
		size = radius * 5,
		collisiondetection = false,
		vertical = false,
		texture = "tnt_boom.png",
		glow = 15,
	})
	minetest.add_particlespawner({
		amount = 64,
		time = 0.5,
		minpos = pos,
		maxpos = pos,
		minvel = {x = -10, y = -10, z = -10},
		maxvel = {x = 10, y = 10, z = 10},
		minacc = {x = 0, y = 4, z = 0},
		maxacc = {x = 0, y = 4, z = 0},
		minexptime = 1,
		maxexptime = 2.5,
		minsize = radius * 0.7,
		maxsize = radius * 1.5,
		texture = "tnt_smoke.png",
        collisiondetection = true,
        glow=5,
    })
end

local function effectsTexture(pos, node)
	if minetest.registered_nodes[node.name].tiles~=nil then
		texture = minetest.registered_nodes[node.name].tiles[1]
		minetest.add_particlespawner({
			amount = 64,
			time = 0.1,
			minpos = pos,
			maxpos = pos,
			minvel = {x = -15, y = -15, z = -15},
			maxvel = {x = 15, y = 15,  z = 15},
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

local function boom(pos)
	minetest.sound_play("tnt_explode", {pos=pos, gain=1, max_hear_distance=2*64})
	if minetest.get_node(pos).name == 'air' or minetest.get_node(pos).name == 'throwing:firework_trail' then
		minetest.add_node(pos, {name="throwing:firework_boom"})
		minetest.get_node_timer(pos):start(0.2)
	end
	add_effects(pos, 10)
end

-- Back to the arrow
local function damageInRadius(damage, puncher, pos, radius)
    local targs = minetest.get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, radius)
    for k, targ in pairs(targs) do
		local dist=math.sqrt(((targ:getpos().x-pos.x)^2)+((targ:getpos().y-pos.y)^2)+((targ:getpos().z-pos.z)^2))
		local newDamage=damage/math.max(dist, 1)
		minetest.log("action", "Target:" .. dist .. ". Damage:" .. newDamage .. ".")
		targ:set_velocity({x=0, y=500, z=0})
        targ:punch(puncher, 1.0, {
        full_punch_interval=1.0,
        damage_groups={fleshy=newDamage},
        }, nil)
    end
end
THROWING_ARROW_ENTITY.on_step = function(self, dtime)
	self.timer=self.timer+dtime
	local newpos = self.object:getpos()
	if self.timer < 0.15 then
		minetest.sound_play("tnt_ignite", {pos=newpos, gain=1, max_hear_distance=2*64})
	end
	minetest.add_particlespawner({
		amount = 32,
		time = 0.2,
		minpos = newpos,
		maxpos = newpos,
		minvel = {x=-5, y=-5, z=-5},
		maxvel = {x=5,  y=5,  z=5},
		minacc = vector.new(),
		maxacc = vector.new(),
		minexptime = 0.3,
		maxexptime = 0.5,
		minsize = 0.5,
		maxsize = 1,
		texture = "throwing_sparkle.png",
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
                        damageInRadius(30, puncher, pos, 8)
                        effectsTexture(pos, node)
                        boom(pos)
                        self.object:remove()
						return
					end
				end
			end
            
			if self.timer > 2 or node.name ~= "air" then
                local puncher = self.object
                if self.player and minetest.get_player_by_name(self.player) then
                    puncher = minetest.get_player_by_name(self.player)
                end
                damageInRadius(30, puncher, pos, 8)
                effectsTexture(pos, node)
                boom(pos)
				self.object:remove()
				return
			end
			self.lastpos={x=pos.x, y=pos.y, z=pos.z}
		end
	end
	self.lastpos={x=newpos.x, y=newpos.y, z=newpos.z}
end


minetest.register_entity("throwing:arrow_tnt_entity", THROWING_ARROW_ENTITY)

minetest.register_craft({
	output = 'throwing:arrow_tnt',
	recipe = {
		{'default:stick', 'tnt:tnt', 'default:bronze_ingot'},
	}
})

minetest.register_craft({
	output = 'throwing:arrow_tnt',
	recipe = {
		{'default:bronze_ingot', 'tnt:tnt', 'default:stick'},
	}
})
