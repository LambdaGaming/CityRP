
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Ore Smelter"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Mining System"

function ENT:SpawnFunction( ply, tr, name )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 2
	local ent = ents.Create( name )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
    self:SetModel( "models/props/cs_militia/furnace01.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetTrigger( true )
		self:SetHealth( 50 )
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end
	self:SetNWBool( "Smelting", false )
end

function ENT:Use( caller, activator )
	if SERVER then
		DarkRP.notify( caller, 0, 6, "Touch ores mined from rocks with the furnace to smelt them." )
	end
end

local ores = {
	["Ruby"] = {
		Time = 150,
		NewEnt = "ruby"
	},
	["Gold"] = {
		Time = 120,
		NewEnt = "goldbar"
	},
	["Diamond"] = {
		Time = 300,
		NewEnt = "diamond"
	},
	["Iron"] = {
		Time = 90,
		NewEnt = "ironbar"
	}
}

function ENT:StartTouch( ent )
	if ent:GetClass() == "mgs_ore" and !self:GetNWBool( "Smelting" ) then
		local oretype = ent:GetNWString( "type" )
		for k,v in pairs( ores ) do
			if k == oretype then
				local snd = CreateSound( self, "ambient/gas/steam_loop1.wav" )
				snd:Play()
				timer.Simple( v.Time, function()
					if IsValid( self ) then
						local e = ents.Create( v.NewEnt )
						e:SetPos( self:GetPos() + self:GetForward() * 30 )
						e:Spawn()
						snd:Stop()
						self:SetNWBool( "Smelting", false )
						self:EmitSound( "ambient/fire/mtov_flame2.wav" )
					end
				end )
				break
			end
		end
		ent:Remove()
		self:SetNWBool( "Smelting", true )
	end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end

	function ENT:Think()
		local ply = LocalPlayer()
		if self:GetNWBool( "Smelting" ) then
			local pos = self:GetPos()
			local plypos = ply:GetPos()
			if plypos:DistToSqr( pos ) < 1000000 then
				local smoke = ParticleEmitter( pos ):Add( "particle/smokesprites_000"..math.random( 1, 9 ), pos + self:GetRight() * -10 + self:GetUp() * 115 + self:GetForward() * -5 )
				smoke:SetVelocity( Vector( 0, 0, 50 ) )
				smoke:SetDieTime( math.Rand( 0.6, 1 ) )
				smoke:SetStartSize( math.random( 0, 5 ) )
				smoke:SetEndSize( math.random( 33, 40 ) )
				smoke:SetColor( 255, 255, 255 )
			end
		end
	end
end
