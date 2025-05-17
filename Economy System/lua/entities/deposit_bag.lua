AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Bag"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Deposit Box"

function ENT:Initialize()
    self:SetModel( "models/tobadforyou/duffel_bag.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end
	self:PhysWake()
end

if SERVER then
	function ENT:Use( ply )
		if self.MoneyOwner == ply then
			ply:addMoney( self.MoneyAmount )
			DarkRP.notify( ply, 0, 6, "You have received "..DarkRP.formatMoney( self.MoneyAmount ).." from your money bag." )
			self:Remove()
			return
		end

		local foundbanker = false
		for k,v in ipairs( ents.FindInSphere( self:GetPos(), 200 ) ) do
			if v:GetClass() == "smuggle_sell" then
				foundbanker = true
				break
			end
		end
		if foundbanker then
			ply:addMoney( self.MoneyAmount )
			DarkRP.notify( ply, 0, 6, "You have received "..DarkRP.formatMoney( self.MoneyAmount ).." from a stolen money bag." )
			local rand = math.random( 1, 10 )
			if rand <= 3 then
				local e = ents.Create( "printer_upgrade_output" )
				e:SetPos( ply:GetPos() + Vector( 0, 0, 35 ) )
				e:Spawn()
				ply:ChatPrint( "As a special bonus you got a platinum money printer!" )
				e:SetOwner( ply )
			end
			SpawnBlueprint( ply, 6 )
			DarkRP.notify( ply, 0, 6, "You have also been rewarded with a crafting blueprint." )
			self:Remove()
			return
		end
		DarkRP.notify( ply, 1, 6, "This money bag belongs to "..self.MoneyOwner:Nick()..". If you are stealing it, take it to the smuggler." )
	end
end
