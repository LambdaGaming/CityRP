AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Vending Machine"
ENT.Author = "OPGman"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Superadmin Only"

if CLIENT then return end

function ENT:Initialize()
	self:SetModel( "models/props_interiors/VendingMachineSoda01a.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()
	self.Used = false
end

function ENT:Use( ply )
	if self.Used then return end
	if !ply:canAfford( 30 ) then
		DarkRP.notify( ply, 1, 6, "You don't have enough money to use the vending machine!" )
		return
	end
	ply:addMoney( -30 )
	self.Used = true
	self:EmitSound( "ambient/levels/labs/coinslot1.wav" )
	timer.Simple( 1.5, function()
		if !IsValid( self ) then return end
		local pos, ang = LocalToWorld( Vector( 20, -5, -30 ), Angle( -90, -90, 0 ), self:GetPos(), self:GetAngles() )
		local e = ents.Create( "vending_soda" )
		e:SetPos( pos )
		e:SetAngles( ang )
		e:SetModel( model )
		e:Spawn()
		self.Used = false
	end )
end
