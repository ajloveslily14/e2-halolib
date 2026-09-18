E2Helper.Descriptions["setHalo"] = [[
	Sets/updates a halo around an object:
	Usage:
	(red, green, blue, alpha, size, passes, additive, throughwall)
]]
E2Helper.Descriptions["setHaloSize"] ="Sets the size of the halo "
E2Helper.Descriptions["setHaloAdd"] ="Sets if the halo will be additive"
E2Helper.Descriptions["setHaloColor"] ="Sets the Color of the halo  "
E2Helper.Descriptions["setHaloAlpha"] ="Sets the transparency of the halo "
E2Helper.Descriptions["setHaloPasses"] ="Sets the pass count for the halo (higher numbers give a thicker look but cause more lag) "
E2Helper.Descriptions["setHaloZDepth"] ="Sets if the halo should be rendered through walls"
E2Helper.Descriptions["setHaloEnabled"] ="Turns the halo on or off"


E2Helper.Descriptions["getHaloSize"] ="Gets the size of the halo "
E2Helper.Descriptions["getHaloAdd"] ="Gets if the halo will be additive"
E2Helper.Descriptions["getHaloColor"] ="Gets the Color of the halo  "
E2Helper.Descriptions["getHaloAlpha"] ="Gets the transparency of the halo "
E2Helper.Descriptions["getHaloPasses"] ="Gets the pass count for the halo (higher numbers give a thicker look but cause more lag) "
E2Helper.Descriptions["getHaloZDepth"] ="Gets if the halo should be rendered through walls"
E2Helper.Descriptions["getHaloEnabled"] ="Is the halo on?"


local halos = {}

local function haloAdd()

	local idx = net.ReadInt(16)
	local hdat = net.ReadTable()
	halos[idx] = hdat

end
net.Receive("e2haloadd",haloAdd)

local function haloDel()

	local idx = net.ReadInt(16)
	halos[idx] = nil

end
net.Receive("e2haloremove",haloDel)

local function fullUpdate()

	local count = net.ReadInt(16)
	for i = 1,count do
		local idx = net.ReadInt(16)
		local dat = net.ReadTable()
		halos[idx] = dat
	end

end
net.Receive("e2halofull",fullUpdate)


local function doHalos()

	for idx,dat in pairs(halos) do
		local ent = Entity(idx)
		if not IsValid(ent) then continue end
		if dat.enabled ~= 1 then continue end
		local c = Color(dat.r,dat.g,dat.b,dat.a)
		halo.Add({ent},c,dat.size,dat.size,dat.passes,dat.additive == 1,dat.ignorez > 0)
	end

end
hook.Add("PreDrawHalos","e2halos",doHalos)