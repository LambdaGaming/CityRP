AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Smuggler"
ENT.Category = "Drugs"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	self:SetModel( "models/humans/group03/male_01.mdl" )
	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_BBOX )
		self:SetUseType( SIMPLE_USE )
		self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	end
	self:PhysWake()
	self.DrugCooldowns = {}
end

function ENT:Use( ply )
	local pos = self:GetPos()
	local numply = 0
	for k,v in ipairs( ents.FindInSphere( pos, 500 ) ) do
		if v:IsPlayer() then
			numply = numply + 1
		end
	end
	if numply > 1 then
		ply:ChatPrint( "There's too many people around here! Come back later." )
		return
	end
	for k,v in ipairs( ents.FindInSphere( pos, 500 ) ) do
		if v:GetClass() == "drug_box" then
			local id = ply:SteamID64()
			if table.IsEmpty( v.Drugs ) then
				DarkRP.notify( ply, 1, 6, "You brought an empty box? Nice try." )
				return
			end
			if self.DrugCooldowns[id] and self.DrugCooldowns[id] > CurTime() then
				DarkRP.notify( ply, 1, 6, "Please wait "..string.ToMinutesSeconds( self.DrugCooldowns[id] - CurTime() ).." before selling more drugs." )
				return
			end
			local payout = 0
			for a,b in pairs( v.Drugs ) do
				if b.Class == "drug_weed" then
					if b.Stat == 2 then
						--Spicy weed
						payout = payout + 1000
					else
						payout = payout + 200
					end
				elseif b.Class == "drug_cocaine" then
					--Chance of being wanted
					local rand = math.random( 1, 100 )
					if rand > b.Stat then
						ply:wanted( "Selling drugs" )
						ply:ChatPrint( "The smuggler has refused your offer and called the cops because of your poor quality drugs." )
						return
					end
					--Payout based on purity
					payout = payout + ( b.Stat * 50 )
				else
					--Payout based on quality
					if b.Stat <= 1500 then
						ply:wanted( "Selling drugs" )
						ply:ChatPrint( "The smuggler has refused your offer and called the cops because of your poor quality drugs." )
						return
					end
					payout = payout + b.Stat
				end
			end
			if ply:isCP() then
				self.DrugCooldowns[id] = CurTime() + 600
			end
			ply:addMoney( payout )
			DarkRP.notify( ply, 0, 6, "You have sold a box of drugs for "..DarkRP.formatMoney( payout ).."." )
			v:Remove()
			return
		elseif v:GetClass() == "custom_shipment" and v.Ready and v:GetOwner() != ply then
			local amt = math.Round( v:GetAmount() * 0.5 )
			for i=1,amt do
				local class = ShipmentWepList[v:GetGunType()][1]
				local e = ents.Create( "spawned_weapon" )
				e:SetWeaponClass( class )
				e:SetModel( weapons.GetStored( class ).WorldModel )
				e:SetPos( self:GetPos() + ( self:GetForward() * 10 ) + Vector( 0, 0, i * 20 ) )
				e.nodupe = true
				e:Spawn()
			end
			v:Remove()
			DarkRP.notify( ply, 0, 6, "Successfully smuggled a weapon shipment." )
			return
		end
	end
	DarkRP.notify( ply, 1, 6, "No item detected. Try moving it closer." )
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		self:DrawOverheadText( "Smuggler" )
	end
end
