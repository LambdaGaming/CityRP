AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Bank Money"
ENT.Author = "Lambda Gaming"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", "Money" )
end

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
		if self.MoneyOwner and self.MoneyOwner == ply then
			ply:addMoney( self.MoneyAmount )
			DarkRP.notify( ply, 0, 6, "You have received "..DarkRP.formatMoney( self.MoneyAmount ).." from your money bag." )
			self:Remove()
			return
		end

		local foundNpc = false
		local foundBank = false
		local goodJob = ply:isCP() or ply:Team() == TEAM_BANKER
		for k,v in ipairs( ents.FindInSphere( self:GetPos(), 200 ) ) do
			if v:GetClass() == "smuggle_sell" and !goodJob then
				foundNpc = true
			elseif v:GetClass() == "bank_vault" then
				foundBank = true
			end
		end
		if foundNpc and !goodJob then
			local money = self:GetMoney()
			ply:addMoney( money )
			DarkRP.notify( ply, 0, 6, "You have received "..DarkRP.formatMoney( money ).." for cashing in a stolen money bag." )
			self:Remove()
			if self.Legal then
				NotifyJob( TEAM_BANKER, 1, 6, "Your money bag was stolen and cashed in!" )
				MoneyTransferEnd()
			elseif self.LastBag or self.MoneyOwner then
				SpawnBlueprint( ply, 6 )
				local rand = math.random( 1, 10 )
				if rand <= 3 then
					local e = ents.Create( "printer_upgrade_output" )
					e:SetPos( ply:GetPos() + Vector( 0, 0, 35 ) )
					e:Spawn()
					e:SetOwner( ply )
				end
				DarkRP.notify( ply, 0, 6, "You have also received bonus items." )
			end
		elseif foundBank and goodJob then
			self:Remove()
			if self.Legal then
				AddVaultFunds( 2000 )
				DarkRP.notify( ply, 0, 6, "You have deposited a money bag into the bank vault." )
				MoneyTransferEnd()
				return
			end
			AddVaultFunds( 4000 )
			DarkRP.notify( ply, 0, 6, "You have returned stolen money to the bank vault." )
		else
			if goodJob then
				DarkRP.notify( ply, 1, 6, "Take this bag back to the bank vault to return the stolen money." )
			else
				DarkRP.notify( ply, 1, 6, "Take this to the smuggler to cash it in." )
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
			local money = self:GetMoney()
			local formatted = DarkRP.formatMoney( money )
			ang:RotateAroundAxis( ang:Forward(), 90 )
			cam.Start3D2D( pos + ang:Up() * 4.2, ang, 0.04 )
				draw.SimpleText( "Money Bag", "MoneyBag", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, color_black )
				draw.SimpleText( formatted, "MoneyBag", 0, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, color_black )
			cam.End3D2D()
		end
	end
end
