local halos = {}
local default = {
	r=255,
	g=255,
	b=255,
	a=255,
	size=1,
	passes=1,
	additive=1,
	ignorez=0,
	enabled = 1
}

util.AddNetworkString("e2haloadd")
local function sendHalo(ent,dat)

	net.Start("e2haloadd")
	net.WriteInt(ent:EntIndex(),16)
	net.WriteTable(dat)
	net.Broadcast()

end

util.AddNetworkString("e2haloremove")
local function removeHalo(ent)

	net.Start("e2haloremove")
	net.WriteInt(ent:EntIndex(),16)
	net.Broadcast()

end

hook.Add("EntityRemoved","e2halocleanup",function(ent)

	if halos[ent:EntIndex()] then 
		removeHalo(ent)
	end
	
end)

util.AddNetworkString("e2halofull")
local function sendFull(ply)

	local count = table.Count(halos)
	net.Start("e2halofull")
	net.WriteInt(count,16)
	for idx,dat in pairs(halos) do
		net.WriteInt(idx,16)
		net.WriteTable(dat)
	end
	net.Send(ply)

end
hook.Add("PlayerInitialSpawn","e2halosync",function(ply)
	sendFull(ply)
end)

local function addHalo(ent,dat)

	if halos[ent:EntIndex()] then 
		local htab = halos[ent:EntIndex()]
		table.Merge(htab,dat,true)
		sendHalo(ent,htab)
	else
		table.Inherit(dat,default)
		sendHalo(ent,dat)
		halos[ent:EntIndex()] = dat
	end

end
-- setters
e2function void entity:setHalo(number red, number green, number blue, number alpha, number xy, number pass, number add, number wall)

	local h = {r=red,g=green,b=blue,a=alpha,size=xy,passes=pass,additive=add,ignorez=wall}
	addHalo(this,h)

end

e2function void entity:setHalo(vector color, number alpha, number xy, number pass, number add, number wall)

	local h = {r=color[1],g=color[2],b=color[3],a=alpha,size=xy,passes=pass,additive=add,ignorez=wall}
	addHalo(this,h)

end

e2function void entity:setHaloColor(number red, number green, number blue)

	if not halos[this:EntIndex()] then return end
	addHalo(this,{r=red,g=green,b=blue})
	
end

e2function void entity:setHaloColor(vector color)

	if not halos[this:EntIndex()] then return end
	addHalo(this,{r=colors[1],g=colors[2],b=colors[3]})
	
end

e2function void entity:setHaloAlpha(number alpha)
	
	if not halos[this:EntIndex()] then return end
	addHalo(this,{a=alpha})
	
end

e2function void entity:setHaloSize(number sizeXY)
	
	if not halos[this:EntIndex()] then return end
	addHalo(this,{size=sizeXY})
	
end

e2function void entity:setHaloPasses(number passCount)
	
	if not halos[this:EntIndex()] then return end
	addHalo(this,{passes=passCount})
	
end

e2function void entity:setHaloAdd(number add)
	 
	if not halos[this:EntIndex()] then return end
	addHalo(this,{additive=add})

end

e2function void entity:setHaloZDepth(number wall)

	if not halos[this:EntIndex()] then return end
	addHalo(this,{ignorez=wall})

end

e2function void entity:setHaloEnabled(number on)
	
	if halos[this:EntIndex()] then 
		addHalo(this,{enabled=on})
	elseif on > 0 then 
		addHalo(this,{})
	end

end
-- getters
e2function vector entity:getHaloColor()
	
	if not halos[this:EntIndex()] then return end
	local h = halos[this:EntIndex()]
	return Vector(h.r,h.g,h.b)
	
end

e2function number entity:getHaloAlpha()

	if not halos[this:EntIndex()] then return end
	return halos[this:EntIndex()].a
	
end

e2function number entity:getHaloSize()
	
	if not halos[this:EntIndex()] then return end		
	return halos[this:EntIndex()].size
	
end

e2function number entity:getHaloPasses()
	
  	if not halos[this:EntIndex()] then return end		
	return halos[this:EntIndex()].passes
	
end

e2function number entity:getHaloAdd()
	
  	if not halos[this:EntIndex()] then return end		
	return halos[this:EntIndex()].additive
	
end

e2function number entity:getHaloZDepth()
	
 	if not halos[this:EntIndex()] then return end		
	return halos[this:EntIndex()].ignorez
	
end

e2function number entity:getHaloEnabled()
	
  	if not halos[this:EntIndex()] then return end		
	return halos[this:EntIndex()].enabled
	
end
