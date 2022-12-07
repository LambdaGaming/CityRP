AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:SpawnFunction( ply, tr, name )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 2
	local ent = ents.Create( name )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent:ApplyType( 1 )
	return ent
end

function ENT:ApplyType( type ) --This needs to be called externally sometime after the NPC is spawned for the items to show up
	self:SetNPCType( type )
	self:SetModel( ItemNPCType[type].Model )
end

function ENT:Initialize()
    self:SetModel( "models/breen.mdl" )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_BBOX )
	self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	self:SetUseType( SIMPLE_USE )
	
    local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

util.AddNetworkString( "ItemNPCMenu" )
function ENT:AcceptInput( input, activator )
	local allowed = ItemNPCType[self:GetNPCType()].Allowed
	if !activator:IsPlayer() then return end
	if self:GetNPCType() == 0 then
		DarkRP.notify( activator, 1, 6, "ERROR: NPC isn't fully initialized." )
		return
	end
	if allowed and !table.IsEmpty( allowed ) and !allowed[activator:Team()] then
		DarkRP.notify( activator, 1, 6, "You cannot use this NPC as your current job." )
		return
	end
	if activator.IsSwat and self:GetNPCType() != 4 then
		DarkRP.notify( activator, 1, 6, "You cannot use this NPC while on duty as SWAT." )
		return
	end
	net.Start( "ItemNPCMenu" )
	net.WriteEntity( self )
	net.Send( activator )
end

local animnpcs = {
	[3] = true,
	[4] = true,
	[5] = true
}

function ENT:Think()
	local type = self:GetNPCType()
	if animnpcs[type] then
		self:SetSequence( "pose_standing_02" )
	end
end

util.AddNetworkString( "CreateItem" )
net.Receive( "CreateItem", function( len, ply )
	local self = net.ReadEntity()
	local ent = net.ReadString()
	local SpawnCheck = ItemNPC[ent].SpawnCheck
	local SpawnItem = ItemNPC[ent].SpawnFunction
	local money = ply:getDarkRPVar( "money" )
	local name = ItemNPC[ent].Name
	local price = ItemNPC[ent].Price
	local primary = ItemNPC[ent].PrimaryJobs
	local event = ItemNPC[ent].EventID
	local salestax = price * ( GetGlobalInt( "MAYOR_SalesTax" ) * 0.01 )
	local discount = ItemNPC[ent].Discount
	local discountamt
	if discountamt then
		discountamt = discount[ply:Team()]
		price = price * discountamt
	end
	if price > 0 and self:GetNPCType() != 2 and self:GetNPCType() != 8 then
		price = price + salestax
		SetGlobalBool( "MAYOR_Money", GetGlobalBool( "MAYOR_Money" ) + salestax )
	end
	if primary and !table.HasValue( primary, ply:Team() ) then
		DarkRP.notify( ply, 1, 6, "You are not qualified for this job!" )
		return
	end
	if event then
		if ActiveEvents[event] then
			DarkRP.notify( ply, 1, 6, "There is already an ongoing job that you can partake in." )
			return
		end
		ActiveEvents[event] = true
	end
	if money >= price then
		if SpawnCheck and SpawnCheck( ply, self ) == false then return end
		if SpawnItem then
			SpawnItem( ply, self )
			if !event then
				if discountamt then
					DarkRP.notify( ply, 0, 6, "You have purchased a "..name.." with a "..( discountamt * 100 ).."% discount." )
				else
					DarkRP.notify( ply, 0, 6, "You have purchased a "..name.."." )
				end
			end
		else
			DarkRP.notify( ply, 1, 6, "ERROR: SpawnFunction for this item not detected!" )
			return
		end
		ply:addMoney( -price )
	else
		DarkRP.notify( ply, 1, 6, "You don't have enough money to purchase this item!" )
	end
end )
