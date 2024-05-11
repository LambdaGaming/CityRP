
local DeerSpawns = {}

DeerSpawns["rp_rockford_v2b"] = {
	Vector( 3594, -13804, 345 ),
	Vector( 7681, -3249, 1362 ),
	Vector( 13386, -819, 1536 ),
	Vector( 8067, 12643, 1536 ),
	Vector( -14, 14948, 545 ),
	Vector( -3037, 9814, 507 )
}

DeerSpawns["rp_chaos_city_v33x_03"] = {
	Vector( 1790, -6791, -1864 ),
	Vector( -9350, -14709, -2147 ),
	Vector( -11299, -14702, -2141 ),
	Vector( -13267, -11058, -2151 ),
	Vector( -9713, 1906, -2115 ),
	Vector( 2898, 9659, -1876 )
}

DeerSpawns["rp_evocity2_v5p"] = {
	Vector( 5026, 8247, 65 ),
	Vector( 247, 11283, -191 ),
	Vector( -7485, 7955, 198 ),
	Vector( -7089, -8051, 102 ),
	Vector( 1442, -8928, -2884 ),
	Vector( 6325, 1645, -1804 )
}

DeerSpawns["rp_florida_v2"] = {
	Vector( 2149, 5565, 131 ),
	Vector( 411, 11951, 142 ),
	Vector( 10020, 12054, 132 ),
	Vector( -4077, 1465, 135 ),
	Vector( -4019, -9616, 134 ),
	Vector( 10632, -2628, 135 )
}

DeerSpawns["rp_truenorth_v1a"] = {
	Vector( 9436, 361, 0 ),
	Vector( -5965, 1769, 24 ),
	Vector( 348, 1265, 6 ),
	Vector( -3017, 2758, 3339 ),
	Vector( 2170, 3219, 4853 ),
	Vector( 5852, -10084, 5375 )
}

DeerSpawns["rp_newexton2_v4h"] = {
	Vector( 15333, -13762, 542 ),
	Vector( 13056, -1104, 96 ),
	Vector( 13353, 7594, 48 ),
	Vector( 8321, 4181, 1016 ),
	Vector( 5119, -3003, 112 ),
	Vector( 1215, 9830, 1540 )
}

hook.Add( "InitPostEntity", "DeerSpawnTimer", function()
	timer.Create( "DeerSpawn", 300, 0, function()
		local deer = #ents.FindByClass( "npc_deer" )
		if deer >= 1 then return end
		local e = ents.Create( "npc_deer" )
		e:SetPos( table.Random( DeerSpawns[tostring( game.GetMap() )] ) )
		e:Spawn()
	end )
end )

local function BloodEffect( ent )
	local effectdata = EffectData()
	effectdata:SetOrigin( ent:GetPos() )
	util.Effect( "BloodImpact", effectdata )
end

util.AddNetworkString( "DeerMenu" )
hook.Add( "KeyPress", "DeerUse", function( ply, key )
	if key != IN_USE then return end
	local ent = ply:GetEyeTrace().Entity
	if ply:GetPos():DistToSqr( ent:GetPos() ) > 1000 then return end
	if !IsValid( ent ) then return end
	if ent:GetClass() != "prop_ragdoll" or ent:GetModel() != "models/deer/deer_animated.mdl" then return end
	if ply.deermenucooldown and ply.deermenucooldown > CurTime() then return end
	ply.deermenucooldown = CurTime() + 0.5
	if ent:GetNWBool( "IsValidDeerCorpse" ) then
		net.Start( "DeerMenu" )
		net.WriteEntity( ent )
		net.Send( ply )
	end
end )

util.AddNetworkString( "DeerCut" )
net.Receive( "DeerCut", function( len, ply )
	local ent = net.ReadEntity()
	if !IsValid( ent ) then return end
	for i=1, 4 do
		local e = ents.Create( "deer_meat_raw" )
		e:SetPos( ent:GetPos() + Vector( 0, 0, i * 6 ) )
		e:Spawn()
	end
	BloodEffect( ent )
	ent:EmitSound( "physics/flesh/flesh_squishy_impact_hard"..math.random( 1, 4 )..".wav" )
	ent:Remove()
	ply:ChatPrint( "You have successfully harvested raw meat from the deer." )
end )

util.AddNetworkString( "DeerHead" )
net.Receive( "DeerHead", function( len, ply )
	local ent = net.ReadEntity()
	if !IsValid( ent ) then return end
	local e = ents.Create( "prop_physics" )
	e:SetPos( ent:GetPos() )
	e:SetModel( "models/props_interiors/mounteddeerhead01.mdl" )
	e:Spawn()
	BloodEffect( ent )
	ent:EmitSound( "physics/flesh/flesh_squishy_impact_hard"..math.random( 1, 4 )..".wav" )
	ent:Remove()
	ply:ChatPrint( "You have successfully harvested the head of the deer." )
end )