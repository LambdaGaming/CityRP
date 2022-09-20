AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Pizza NPC"
ENT.Category = "Zeros PizzaMaker"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	local models = {
		"models/player/group01/female_01.mdl",
		"models/player/group01/female_02.mdl",
		"models/player/group01/female_03.mdl",
		"models/player/group01/female_04.mdl",
		"models/player/group01/female_05.mdl",
		"models/player/group01/female_06.mdl",
		"models/player/group01/male_01.mdl",
		"models/player/group01/male_02.mdl",
		"models/player/group01/male_03.mdl",
		"models/player/group01/male_04.mdl",
		"models/player/group01/male_05.mdl",
		"models/player/group01/male_06.mdl",
		"models/player/group01/male_07.mdl",
		"models/player/group01/male_08.mdl",
		"models/player/group01/male_09.mdl"
	}
	self:SetModel( table.Random( models ) )
	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	end
	
	local randpizzas = {
		"Magarita Pizza",
		"Spinat Pizza",
		"Salami Pizza",
		"Olive Pizza",
		"Boneless Pizza",
		"Bacon Pizza",
		"Egg Pizza",
		"Mushroom Pizza",
		"Hawaii Pizza",
		"Cheese Pizza"
	}
	
	self:SetNWString( "SetPizza", table.Random( randpizzas ) )
end

function ENT:AcceptInput( name, caller )
	if caller.pizzacooldown and caller.pizzacooldown > CurTime() then return end
	if !caller:IsPlayer() then return end
	if caller:Team() == TEAM_COOK and IsEventActive( EVENT_FOOD_DELIVERY ) then
		for k,v in pairs( ents.FindInSphere( self:GetPos(), 50 ) ) do
			if v:GetClass() == "zpizmak_pizza" then
				if v:GetPizzaType() == self:GetNWString( "SetPizza" ) then
					v:Remove()
					caller:ChatPrint( "Thanks. Here's $1000 and a crafting blueprint." )
					caller:addMoney( 1000 )
					self:Remove()
					FoodDeliveryEnd()
					local randwep = table.Random( BLUEPRINT_CONFIG_TIER2 )
					local e = ents.Create( "crafting_blueprint" )
					e:SetPos( caller:GetPos() + Vector( 0, 0, 35 ) )
					e:SetAngles( caller:GetAngles() + Angle( 0, 180, 0 ) )
					e:Spawn()
					e:SetEntName( randwep[1] )
					e:SetRealName( randwep[2] )
					e:SetUses( 3 )
				else
					caller:ChatPrint( "Incorrect pizza type." )
				end
			end
		end
	end
	caller.pizzacooldown = CurTime() + 1
end

function ENT:Think()
	self:SetSequence("idle_all_02")
end

if CLIENT then
	function ENT:Draw()
		local pizza = "Bring me a "..self:GetNWString( "SetPizza" ).." for cash."
		self:DrawNPCText( pizza )
	end
end
