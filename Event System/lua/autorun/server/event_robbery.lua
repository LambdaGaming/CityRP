local map = game.GetMap()

RobberyEventStats = {
	RobberCount = 0
}

function Robbery()
	local models = {
		"models/humans/group03/male_01.mdl",
		"models/humans/group03/male_02.mdl",
		"models/humans/group03/male_03.mdl",
		"models/humans/group03/male_04.mdl",
		"models/humans/group03/male_05.mdl",
		"models/humans/group03/male_06.mdl",
		"models/humans/group03/male_07.mdl",
		"models/humans/group03/male_08.mdl",
		"models/humans/group03/male_09.mdl"
	}
	local weps = {}
	local origin = EventPos[map].Robbery
	for i=1, math.random( 3, 6 ) do
		local shooter = ents.Create( "npc_citizen" )
		shooter:SetPos( Vector( origin.x, origin.y + ( i * 30 ), origin.z ) )
		shooter:SetKeyValue( "spawnflags", bit.bor( SF_NPC_NO_WEAPON_DROP, SF_NPC_FADE_CORPSE, SF_NPC_LONG_RANGE ) )
		shooter:Spawn()
		shooter:Activate()
		shooter:SetModel( table.Random( models ) )
		shooter:SetHealth( 100 )
		for k,v in ipairs( player.GetAll() ) do
			shooter:AddEntityRelationship( v, D_HT, 99 )
		end
		GiveNpcRandomWeapon( shooter )
		shooter.IsRobber = true
		RobberyEventStats.RobberCount = RobberyEventStats.RobberCount + 1
	end
	NotifyCops( 0, 10, RobberyEventStats.RobberCount.." armed men are attempting to rob the bank!" )
end

function RobberyEnd()
	NotifyCops( 0, 10, "The bank robbers have been killed!" )
	RobberyEventStats.RobberCount = 0
	ActiveEvents[EVENT_ROBBERY] = false
end
