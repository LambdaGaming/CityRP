local SmuggleItems = {
	{
		Name = "Number Nine Large",
		Model = "models/food/burger.mdl",
		Pos = Vector( 0, -110, 30 )
	},
	{
		Name = "Illegal Ammunition",
		Model = "models/Items/item_item_crate_dynamic.mdl",
		Pos = Vector( 0, -110, 40 )
	},
	{
		Name = "Unregistered Weapons",
		Model = "models/props/CS_militia/footlocker01_closed.mdl",
		Pos = Vector( 0, -50, 50 )
	},
	{
		Name = "C4",
		Model = "models/weapons/w_c4_planted.mdl",
		Pos = Vector( 0, -110, 40 )
	},
	{
		Name = "Stolen Sports Car",
		Model = "models/sentry/veneno_new.mdl",
		Pos = Vector( 0, -110, 40 )
	}
}

function SmuggleStart( ply )
	local e = SpawnVehicle( ply, "c5500tdm", 3 )
	local randid = math.random( #SmuggleItems )
	local item = SmuggleItems[randid]
	ply.Smuggling = true
	e.SmuggleTruck = true
	e.SmuggleOwner = ply
	e.SmuggleID = randid
	e:SetBodygroup( 1, 1 )
	local prop = ents.Create( "prop_dynamic" )
	prop:SetModel( item.Model )
	prop:SetParent( e )
	prop:SetLocalPos( item.Pos )
	prop:SetLocalAngles( angle_zero )
	prop:Spawn()
	DarkRP.notify( ply, 0, 6, "Deliver this truck to the Smuggler for a reward." )
	ply:wanted( nil, "Smuggling stolen goods." )
end

function SmuggleEnd( ply )
	ply.Smuggling = false
	DarkRP.notify( ply, 0, 10, "You have been rewarded with $6,000 and a crafting blueprint for delivering the smuggled goods." )
	GiveReward( ply, 6000 )
end

function SmuggleCheck( ply )
	if !ply:IsCivilian() then
		return false, "You need to be a civilian job to smuggle items."
	end

	local copcount = team.NumPlayers( TEAM_POLICEBOSS ) + team.NumPlayers( TEAM_OFFICER ) + team.NumPlayers( TEAM_UNDERCOVER )
	if copcount < 2 then
		return false, "There needs to be at least 2 cops on the server for smuggling to unlock."
	end

	if ply.Smuggling then
		return false, "You are already smuggling something!"
	end
	return true
end

hook.Add( "PlayerEnteredVehicle", "SmuggleConfiscate", function( ply, veh )
	if veh.SmuggleTruck then
		if ply:isCP() then
			DarkRP.notify( ply, 0, 6, "You have successfully seized this smuggle truck. You have been awarded with $500." )
			ply:addMoney( 500 )
			DarkRP.notify( veh.SmuggleOwner, 1, 6, "The police have seized your smuggle truck." )
			veh:Remove()
			return
		end
		if ply != veh.SmuggleOwner then
			veh.SmuggleOwner = ply
			DarkRP.notify( ply, 0, 6, "You have taken ownership of this smuggle truck." )
		end
	end
end )

hook.Add( "EntityRemoved", "SmuggleForceEnd", function( ent )
	if ent.SmuggleTruck and IsValid( ent.SmuggleOwner ) then
		ent.SmuggleOwner.Smuggling = false
		DarkRP.notify( ent.SmuggleOwner, 1, 6, "Your smuggling truck has been removed! You can no longer complete the job!" )
	end
end )
