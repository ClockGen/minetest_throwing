local function throwing_register_fireworks(color, color2, desc)
	minetest.register_craftitem("throwing:arrow_fireworks_" .. color, {
		description = desc .. " Fireworks Arrow",
		inventory_image = "throwing_arrow_fireworks_" .. color .. ".png",
	})

	minetest.register_node("throwing:arrow_fireworks_" .. color .. "_box", {
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
		tiles = {"throwing_arrow_fireworks_" .. color .. ".png", "throwing_arrow_fireworks_" .. color .. ".png", "throwing_arrow_fireworks_" .. color .. "_back.png", "throwing_arrow_fireworks_" .. color .. "_front.png", "throwing_arrow_fireworks_" .. color .. "_2.png", "throwing_arrow_fireworks_" .. color .. ".png"},
		groups = {not_in_creative_inventory=1},
	})

	local THROWING_ARROW_ENTITY={
		physical = false,
		timer=0,
		visual = "wielditem",
		visual_size = {x=0.1, y=0.1},
		textures = {"throwing:arrow_fireworks_" .. color .. "_box"},
		lastpos={},
		collisionbox = {0,0,0,0,0,0},
		player = "",
	}

	local radius = 0.5

	local function add_effects(pos, radius)
		minetest.add_particlespawner({
			amount = 256,
			time = 0.1,
			minpos = vector.subtract(pos, radius / 2),
			maxpos = vector.add(pos, radius / 2),
			minvel = {x=-15, y=-15, z=-15},
			maxvel = {x=15,  y=15,  z=15},
			minacc = {x=0, y=-8, z=0},
			--~ maxacc = {x=-20, y=-50, z=-50},
			minexptime = 2.5,
			maxexptime = 3,
			minsize = 3,
			maxsize = 6,
			texture = "throwing_sparkle_" .. color .. ".png",
            glow=15,
            collisiondetection = true,
		})
        minetest.add_particlespawner({
			amount = 256,
			time = 0.1,
			minpos = vector.subtract(pos, radius / 2),
			maxpos = vector.add(pos, radius / 2),
			minvel = {x=-15, y=-15, z=-15},
			maxvel = {x=15,  y=15,  z=15},
			minacc = {x=0, y=-8, z=0},
			--~ maxacc = {x=-20, y=-50, z=-50},
			minexptime = 2.5,
			maxexptime = 3,
			minsize = 3,
			maxsize = 6,
			texture = "throwing_sparkle_" .. color2 .. ".png",
            glow=15,
            collisiondetection = true,
		})
	end


	local function boom(pos)
		minetest.sound_play("throwing_firework_boom", {pos=pos, gain=1, max_hear_distance=2*64})
		add_effects(pos, radius)
	end

	-- Back to the arrow

	THROWING_ARROW_ENTITY.on_step = function(self, dtime)
		self.timer=self.timer+dtime
		local newpos = self.object:getpos()
		if self.timer < 0.15 then
			minetest.sound_play("throwing_firework_launch", {pos=newpos, gain=1, max_hear_distance=2*64})
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
				local objs = minetest.get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2)
				for k, obj in pairs(objs) do
					if throwing_is_player(self.player, obj) or throwing_is_entity(obj) then
						local speed = vector.length(self.object:getvelocity())
						local damage = ((speed + 15)^1.2)/10
						local puncher = self.object
						if self.player and minetest.get_player_by_name(self.player) then
							puncher = minetest.get_player_by_name(self.player)
						end
						obj:punch(puncher, 1.0, {
							full_punch_interval=1.0,
							damage_groups={fleshy=damage},
						}, nil)
						boom(pos)
						self.object:remove()
						return
					end
				end
			end
			local node = minetest.get_node(newpos)
			if self.timer > 2 or node.name ~= "air" then
				boom(self.lastpos)
				self.object:remove()
				return
			end
		end
		self.lastpos={x=newpos.x, y=newpos.y, z=newpos.z}
	end


	minetest.register_entity("throwing:arrow_fireworks_" .. color .. "_entity", THROWING_ARROW_ENTITY)

	minetest.register_craft({
		output = 'throwing:arrow_fireworks_' .. color,
		recipe = {
			{'dye:' .. color, 'group:coal', 'default:stick'},
		}
	})

end

--~ Arrows

if not DISABLE_FIREWORKS_BLUE_ARROW then
	throwing_register_fireworks('blue', 'magenta', 'Blue')
end

if not DISABLE_FIREWORKS_RED_ARROW then
	throwing_register_fireworks('red', 'orange', 'Red')
end

if not DISABLE_FIREWORKS_GREEN_ARROW then
	throwing_register_fireworks('green', 'cyan', 'Green')
end

