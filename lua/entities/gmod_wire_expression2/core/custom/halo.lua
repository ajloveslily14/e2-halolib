CreateConVar("e2_halo_enable",1,{FCVAR_ARCHIVE,FCVAR_NOTIFY,FCVAR_REPLICATED})

local entmeta = FindMetaTable("Entity")

local _color = Vector(255, 255, 255)
local _alpha = 255
local _size = 2
local _passes = 2
local _additive = 1
local _walls = true
local _glowEnabled = false

function entmeta:SetHalo(r, g, b, a, size, passes, additive, throughwalls, enabled)
	size = math.Clamp(size, 1, 10)
	passes = math.Clamp(passes, 1, 10)
	self:SetNWInt("E2HaloGlowR", r)
	self:SetNWInt("E2HaloGlowG", g)
	self:SetNWInt("E2HaloGlowB", b)
	self:SetNWInt("E2HaloGlowA", a)
	self:SetNWInt("E2HaloGlowSize", size)
	self:SetNWInt("E2HaloGlowPasses", passes)
	self:SetNWInt("E2HaloGlowAdditive", additive)
	self:SetNWBool("E2HaloGlowThroughWalls", throughwalls)
	self:SetNWBool("E2HaloGlowEnabled", enabled)
end

function entmeta:RemoveHalo()
	self:SetNWBool("E2HaloGlowEnabled", false)
end

local function SetColor(ent, color)
	_color = color
end

local function SetAlpha(ent, alpha)
	_alpha = alpha
end

local function SetSize(ent, size)
	_size = size
end

local function SetPasses(ent, passes)
	_passes = passes
end

local function SetAdd(ent, add)
	_additive = add
end

local function SetWalls(ent, walls)
	_walls = walls
end

local function SetHaloEnabled(ent, glow)
	_glowEnabled = glow
end



local function GetColor(ent)
	return Vector( ent:GetNWInt("E2HaloGlowR"), ent:GetNWInt("E2HaloGlowG"), ent:GetNWInt("E2HaloGlowB"))
end

local function GetAlpha(ent)
    return ent:GetNWInt("E2HaloGlowA")
end

local function GetSize(ent)
    return ent:GetNWInt("E2HaloGlowSize")
end

local function GetPasses(ent)
    return ent:GetNWInt("E2HaloGlowPasses")
end

local function GetAdd(ent)
    return ent:GetNWInt("E2HaloGlowAdditive")
end


local function GetWalls(ent)
    return ent:GetNWBool("E2HaloGlowThroughWalls")
end


local function GetHaloEnabled(ent)
    return ent:GetNWBool("E2HaloGlowEnabled")
end





local function ApplyHalo( Entity, Data )

	if ( Data.Halo ) then
		Entity:SetHalo( Data.Halo.r, Data.Halo.g, Data.Halo.b, Data.Halo.a, Data.Size, math.Clamp(Data.Passes,1,10), Data.Additive, Data.ThroughWalls, Data.Enabled )
	else
		Entity:RemoveHalo()
	end

	if ( SERVER ) then
		duplicator.StoreEntityModifier( Entity, "glow", Data )
	end
	
end
duplicator.RegisterEntityModifier( "glow", ApplyHalo )
 
-------
e2function void entity:setHalo(number red, number green, number blue, number alpha, number xy, number pass, number add, number wall)
    if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end
		SetColor(this, Vector(red, green, blue))
		SetAlpha(this, alpha)
		SetSize(this, xy)
		SetPasses(this, pass)
		SetAdd(this, add)
		SetWalls(this, wall>0)
end

e2function void entity:setHalo(vector color, number alpha, number xy, number pass, number add, number wall)
    if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end
		SetColor(this, color)
		SetAlpha(this, alpha)
		SetSize(this, xy)
		SetPasses(this, pass)
		SetAdd(this, add)
		SetWalls(this, wall>0)
end

e2function void entity:setHaloColor(number red, number green, number blue)
   
   if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end
	
	SetColor(this, Vector(red, green, blue))
	
end

e2function void entity:setHaloColor(vector color)
   
   if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end
	
	SetColor(this, color)
	
end

e2function void entity:setHaloAlpha(number alpha)
    
    if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end		
	
	SetAlpha(this, alpha)
	
end

e2function void entity:setHaloSize(number sizeXY)
    
    if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end
	
	SetSize(this, sizeXY)	
	
end

e2function void entity:setHaloPasses(number passCount)
    
    if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end
	
	SetPasses(this, passCount)
	
end

e2function void entity:setHaloAdd(number add)
     
  if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end
	
	SetAdd(this, add)

end

e2function void entity:setHaloZDepth(number wall)
    
  if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end

	SetWalls(this, wall>0)

end


e2function void entity:setHaloEnabled(number on)
    
  if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end			
	if (on>0) then
		SetHaloEnabled(this, true)
	else
		SetHaloEnabled(this, false)
	end
	
	local r	= _color[1]
	local g	= _color[2]
	local b	= _color[3]
	
	local a	= _alpha
	local size = _size
	local passes = _passes
	local additive = _additive
	local throughwalls = _walls

	
	local glowEnabled = _glowEnabled
	
	--print(a, size, passes, additive, throughwalls, owneronly, glowEnabled)
	
	ApplyHalo( this, { Halo = Color( r, g, b, a ), Size = size, Passes = passes, Additive = additive, ThroughWalls = throughwalls, Enabled = glowEnabled } )

end


e2function vector entity:getHaloColor()
    
  if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end			
	
	return GetColor(this)
	
end

e2function number entity:getHaloAlpha()
    
  if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end			
	
	return GetAlpha(this)
	
end

e2function number entity:getHaloSize()
    
  if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end			
	
	return GetSize(this)
	
end

e2function number entity:getHaloPasses()
    
  if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end			
	
	return GetPasses(this)
	
end

e2function number entity:getHaloAdd()
    
  if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end			
	
	return GetAdd(this)
	
end

e2function number entity:getHaloZDepth()
    
  if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end			
	
	if (GetWalls(this)) then
		return 1
	else
		return 0
	end
	
end



e2function number entity:getHaloEnabled()
    
  if not IsValid(this) then return end
	
	if (CLIENT) then
		return true 
	end			
	
	if (GetHaloEnabled(this)) then
		return 1
	else
		return 0
	end
	
end























 
