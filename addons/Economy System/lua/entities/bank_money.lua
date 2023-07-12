AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Bank Money"
ENT.Author = "Lambda Gaming"

function ENT:Initialize()
	self:SetModel( "models/props_c17/BriefCase001a.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end
 
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

if SERVER then
	function ENT:Use( ply )
		local foundnpc = false
		local foundbank = false
		local goodjob = ply:isCP() or ply:Team() == TEAM_BANKER
		for k,v in pairs( ents.FindInSphere( self:GetPos(), 200 ) ) do
			if v:GetClass() == "banker_npc" then
				foundnpc = true
			elseif v:GetClass() == "bank_vault" then
				foundbank = true
			end
		end
		if foundnpc and !goodjob then
			ply:addMoney( 4000 )
			DarkRP.notify( ply, 0, 6, "You have received $4,000 for cashing in a stolen money bag." )
			self:Remove()
			if self.LastBag then
				SpawnBlueprint( ply, 6 )
				local rand = math.random( 1, 10 )
				if rand <= 3 then
					local e = ents.Create( "printer_upgrade_output" )
					e:SetPos( ply:GetPos() + Vector( 0, 0, 35 ) )
					e:Spawn()
					e:SetOwner( ply )
				end
				DarkRP.notify( ply, 0, 6, "You have also received extra items for cashing in the final bag." )
			end
		elseif foundbank and goodjob then
			AddVaultFunds( 4000 )
			DarkRP.notify( ply, 0, 6, "You have returned stolen money to the bank vault." )
			self:Remove()
		else
			if goodjob then
				DarkRP.notify( ply, 1, 6, "Take this bag back to the bank vault to return the stolen money." )
			else
				DarkRP.notify( ply, 1, 6, "Take this to the banker NPC to cash it in." )
			end
		end
	end
end

if CLIENT then
	surface.CreateFont( "MoneyBag", {
		font = "DermaLarge",
		size = 60
	} )

	function ENT:Draw()
		self:DrawModel()
		local ply = LocalPlayer()
		if ply:GetPos():DistToSqr( self:GetPos() ) < 250000 then
			local pos = self:GetPos()
			local ang = self:GetAngles()
			ang:RotateAroundAxis( ang:Forward(), 90 )
			cam.Start3D2D( pos + ang:Up() * 4.2, ang, 0.04 )
				draw.SimpleText( "Bank Money", "MoneyBag", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, color_black )
				draw.SimpleText( "$4,000", "MoneyBag", 0, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, color_black )
			cam.End3D2D()
		end
	end
end
