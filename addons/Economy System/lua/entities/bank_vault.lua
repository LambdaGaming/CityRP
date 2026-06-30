AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Bank Vault"
ENT.Author = "Lambda Gaming"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Superadmin Only"

function ENT:Initialize()
	self:SetModel( "models/props/cs_assault/MoneyPallet03A.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self.Cooldown = CurTime() + 1200
		self.Alarm = CreateSound( self, "ambient/alarms/alarm1.wav" )
		self.NextBag = 0
		self.BagsLeft = 0
	end
	self:PhysWake()
end

if SERVER then
	function ENT:Use( ply )
		if !ply:IsCivilian() then
			DarkRP.notify( ply, 1, 6, "You can't rob the bank as your current job!" )
			return
		elseif self.Robber then
			DarkRP.notify( ply, 1, 6, "Someone is already robbing the bank!" )
			return
		elseif ply:isArrested() or ply:IsHandcuffed() then
			DarkRP.notify( ply, 1, 6, "You can't start a robbery while arrested!" )
			return
		elseif self.Cooldown > CurTime() then
			DarkRP.notify( ply, 1, 6, "Please wait for the cooldown to end before robbing the bank." )
			return
		elseif GetVaultAmount() < 4000 then
			DarkRP.notify( ply, 1, 6, "The bank is currently too empty to rob." )
			return
		end
	
		local numcops = 0
		for k,v in ipairs( player.GetAll() ) do
			if v:isCPNoMayor() and v:Team() != TEAM_UNDERCOVER then
				numcops = numcops + 1
			end
		end
		if numcops < 2 and ( numcops < 1 and team.NumPlayers( TEAM_BANKER ) < 1 ) then
			DarkRP.notify( ply, 1, 6, "There needs to be at least 2 cops or 1 cop and 1 banker on the server for a robbery to begin." )
			return
		end
		
		self.Robber = ply
		ply:wanted( nil, "Robbing the bank", 600 )
		DarkRP.notify( ply, 0, 10, "You have started a robbery. Do not leave the area until all bags have spawned." )
		NotifyCops( 0, 10, ply:Nick().." is robbing the bank!" )
		self.Alarm:Play()

		--Adjust amount of bags that spawn based on how much money is in the vault
		local amount = 5
		for i=5,1,-1 do
			if i * 4000 < GetVaultAmount() then
				amount = amount - 1
			end
		end
		self.BagsLeft = amount - 1

		hook.Add( "Think", "BankRobberyThink", function()
			if self.NextBag <= CurTime() then
				local e = ents.Create( "money_bag" )
				e:SetPos( self:GetPos() + Vector( 0, 0, 50 ) )
				e:SetMoney( 4000 )
				e:Spawn()
				e:SetOwner( ply )
				AddVaultFunds( -4000 )
				if self.BagsLeft == 0 then
					e.LastBag = true
					DarkRP.notify( ply, 0, 6, "All bags have spawned! You can now make your escape!" )
					self:EndRobbery()
				end

				local cooldown = 120
				if EcoPerkActive( "Cut Bank Security Budget" ) then
					cooldown = 60
				elseif EcoPerkActive( "Increase Bank Security Budget" ) then
					cooldown = 180
				end
				self.NextBag = CurTime() + cooldown
				self.BagsLeft = self.BagsLeft - 1
			else
				if IsValid( self.Robber ) then
					if self.Robber:GetPos():DistToSqr( self:GetPos() ) > 250000 then
						DarkRP.notify( self.Robber, 1, 10, "The bank robbery has ended early because you left the area." )
						self:EndRobbery()
					elseif !self.Robber:IsCivilian() then
						DarkRP.notify( self.Robber, 1, 10, "The bank robbery has ended early because you changed teams." )
						self:EndRobbery()
					end
				else
					self:EndRobbery()
				end
			end
		end )
	end

	function ENT:EndRobbery()
		hook.Remove( "Think", "BankRobberyThink" )
		NotifyCops( 0, 10, "The bank robbery has ended. Secure the vault and make sure all money is accounted for!" )
		self.Cooldown = CurTime() + 3600
		self.Alarm:Stop()
		self.Robber = nil
		self.NextBag = 0
	end
end

if CLIENT then
	surface.CreateFont( "BankFont", { font = 'Roboto', size = 100 } )
	function ENT:Draw()
		self:DrawModel()
		local ply = LocalPlayer()
		if ply:GetPos():DistToSqr( self:GetPos() ) <= 250000 then
			local pos = self:GetPos()
			local ang = ( ply:EyePos() - pos ):Angle()
			ang.p = 0
			ang:RotateAroundAxis( ang:Forward(), 90 )
			ang:RotateAroundAxis( ang:Right(), self:GetForward().y - 90 )
			cam.Start3D2D( pos, ang, 0.15 ) 
				draw.SimpleText( DarkRP.formatMoney( GetVaultAmount() ), 'BankFont', 0, -485, Color( 20, 150, 20, 255 ), 1, 1 )
				draw.SimpleText( "Bank Vault", "BankFont", 0, -565, color_white, 1, 1 )
			cam.End3D2D()
		end
	end
end
