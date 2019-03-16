AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:SpawnFunction( ply, tr )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( "fish_stove" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/props_c17/furnitureStove001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetTrigger( true )
	self:SetMaterial( "phoenix_storms/gear" )
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(caller, activator)
	if caller:Team() != TEAM_COOK then DarkRP.notify( caller, 1, 5, "Only cooks can use this stove." ) return end

	if IsValid(fishpot) then DarkRP.notify( caller, 1, 5, "Wait until the current fish are done cooking before putting more on." ) return end
	
	if caller.CookFish < 0 then DarkRP.notify( caller, 1, 8, "Something went horribly wrong and you somehow ended up with negative fish. Please tell OP so he can fix this." ) return end
	
	if caller.CookFish == 0 then DarkRP.notify( caller, 1, 5, "You don't have any fish to cook!" ) return end
	
	if caller.CookFish >= 1 then
		DarkRP.notify( caller, 0, 5, "Your fish have been added to the stove." )
		local fishpot = ents.Create("prop_dynamic")
		fishpot:SetPos( self:GetPos() + Vector( 7, 7, 23 ) )
		fishpot:SetAngles( Angle( 0, 45, 0 ) )
		fishpot:SetModel( "models/props_interiors/pot02a.mdl" )
		fishpot:SetParent( self )
		fishpot:Spawn()
		self:EmitSound("ambient/fire/mtov_flame2.wav")
		timer.Create( "sizzleloop", 3, 0, function() self:EmitSound("ambient/levels/canals/toxic_slime_sizzle"..math.random(1,4)..".wav") end )
		timer.Simple( 60, function()
			if IsValid(self) then
				local cooked = tonumber( caller.CookFish )
				for i = 1, cooked do
					local fish = ents.Create( "cooked_fish" )
					fish:SetPos( self:GetPos() + Vector( 50, 0, 0 ) )
					fish:SetModel("models/props/CS_militia/fishriver01.mdl")
					fish:Spawn()
				end
				self:EmitSound("plats/elevbell1.wav")
				DarkRP.notify( caller, 0, 5, "Your fish are done cooking!" )
				fishpot:Remove()
				timer.Remove("sizzleloop")
				caller.CookFish = caller.CookFish - cooked
			end
		end)
	end
end

function ENT:StartTouch( ent )
	if self.meatcooking then return end
	if ent:GetClass() == "deer_meat_raw" then
		ent:Remove()
		local deerpot = ents.Create("prop_dynamic")
		deerpot:SetPos( self:GetPos() + Vector( -7, 7, 23 ) )
		deerpot:SetAngles( Angle( 0, 45, 0 ) )
		deerpot:SetModel( "models/props_interiors/pot02a.mdl" )
		deerpot:SetParent( self )
		deerpot:Spawn()
		self:EmitSound("ambient/fire/mtov_flame2.wav")
		self.meatcooking = true
		timer.Create( "sizzleloopmeat", 3, 0, function() self:EmitSound("ambient/levels/canals/toxic_slime_sizzle"..math.random(1,4)..".wav") end )
		timer.Simple( 60, function()
			if IsValid(self) then
				local meat = ents.Create( "deer_meat_cooked" )
				meat:SetPos( self:GetPos() + Vector( 50, 0, 0 ) )
				meat:Spawn()
				self:EmitSound("plats/elevbell1.wav")
				deerpot:Remove()
				timer.Remove("sizzleloopmeat")
				self.meatcooking = false
			end
		end )
	end
end

function ENT:OnRemove()
	if IsValid(fishpot) then fishpot:Remove() end
	if IsValid(deerpot) then deerpot:Remove() end
	if timer.Exists("sizzleloop") then timer.Remove("sizzleloop") end
	if timer.Exists("sizzleloopmeat") then timer.Remove("sizzleloopmeat") end
end