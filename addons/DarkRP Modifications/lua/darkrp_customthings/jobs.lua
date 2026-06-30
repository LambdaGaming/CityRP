local civimodels = {
	"models/player/group01/male_01.mdl",
	"models/player/Group01/Male_02.mdl",
	"models/player/Group01/male_03.mdl",
	"models/player/Group01/Male_04.mdl",
	"models/player/Group01/Male_05.mdl",
	"models/player/Group01/Male_06.mdl",
	"models/player/Group01/Male_07.mdl",
	"models/player/Group01/Male_08.mdl",
	"models/player/Group01/Male_09.mdl",
	"models/player/hostage/hostage_01.mdl",
	"models/player/hostage/hostage_02.mdl",
	"models/player/hostage/hostage_03.mdl",
	"models/player/hostage/hostage_04.mdl",
	"models/player/Suits/male_01_closed_tie.mdl",
	"models/player/Suits/male_01_shirt_tie.mdl",
	"models/player/Suits/male_02_closed_tie.mdl",
	"models/player/Suits/male_02_shirt_tie.mdl",
	"models/player/Suits/male_03_closed_tie.mdl",
	"models/player/Suits/male_03_shirt_tie.mdl",
	"models/player/Suits/male_04_closed_tie.mdl",
	"models/player/Suits/male_04_shirt_tie.mdl",
	"models/player/Suits/male_05_closed_tie.mdl",
	"models/player/Suits/male_05_shirt_tie.mdl",
	"models/player/Suits/male_06_closed_tie.mdl",
	"models/player/Suits/male_06_shirt_tie.mdl",
	"models/player/Suits/male_07_closed_tie.mdl",
	"models/player/Suits/male_07_shirt_tie.mdl",
	"models/player/Suits/male_08_closed_tie.mdl",
	"models/player/Suits/male_08_shirt_tie.mdl",
	"models/player/Suits/male_09_closed_tie.mdl",
	"models/player/Suits/male_09_shirt_tie.mdl",
	"models/player/Suits/robber_open.mdl",
	"models/player/Suits/robber_shirt.mdl",
	"models/player/Group01/Female_01.mdl",
	"models/player/Group01/Female_02.mdl",
	"models/player/Group01/Female_03.mdl",
	"models/player/Group01/Female_04.mdl",
	"models/player/Group01/Female_06.mdl"
}

local policemodels = {
	"models/taggart/police01/male_01.mdl",
	"models/taggart/police01/male_02.mdl",
	"models/taggart/police01/male_03.mdl",
	"models/taggart/police01/male_04.mdl",
	"models/taggart/police01/male_05.mdl",
	"models/taggart/police01/male_06.mdl",
	"models/taggart/police01/male_07.mdl",
	"models/taggart/police01/male_08.mdl",
	"models/taggart/police01/male_09.mdl",
	"models/player/police_agent/male_01_agent.mdl",
	"models/player/police_agent/male_02_agent.mdl",
	"models/player/police_agent/male_03_agent.mdl",
	"models/player/police_agent/male_04_agent.mdl",
	"models/player/police_agent/male_05_agent.mdl",
	"models/player/police_agent/male_06_agent.mdl",
	"models/player/police_agent/male_07_agent.mdl",
	"models/player/police_agent/male_08_agent.mdl",
	"models/player/police_agent/male_09_agent.mdl"
}

local function GiveGovAmmo( ply )
	local ammo = {
		["Buckshot"] = 20,
		["Pistol"] = 50,
		["SMG1"] = 50,
		["357"] = 50,
		["AR2"] = 50
	}
	for k,v in pairs( ammo ) do
		ply:GiveAmmo( v, k, true )
	end
end

TEAM_OFFICER = DarkRP.createJob( "Police Officer", {
	color = Color( 0, 0, 255, 255 ),
	model = policemodels,
	description = [[The Police Officer is the base law enforcement job. They are responsible for patrolling the streets, responding to emergencies, arresting criminals, and keeping citizens safe. They take orders from the police chief or the mayor.]],
	weapons = { "arc9_fas_g20", "weapon_metal_detector", "weapon_gauto_spikestrip", "weapon_cuff_police", "policebadge", "stungun", "arrest_stick", "unarrest_stick", "darkrp_speeder", "arc9_fas_mp5" },
	command = "officer",
	max = 6,
	salary = 75,
	admin = 0,
	vote = false,
	hasLicense = false,
	sortOrder = 2,
	candemote = false,
	category = "Government & Police",
	PlayerLoadout = function( ply )
		GiveGovAmmo( ply )
	end
} )

TEAM_POLICEBOSS = DarkRP.createJob( "Police Chief", {
	color = Color( 0, 0, 255, 255 ),
	model = policemodels,
	description = [[The Police Chief is in charge of the entire police department. He gives orders to police officers and takes orders from the mayor.]],
	weapons = { "arc9_fas_ragingbull", "weapon_metal_detector", "policebadge", "stungun", "weapon_cuff_police", "weapon_gauto_spikestrip", "arrest_stick", "unarrest_stick", "darkrp_speeder", "arc9_fas_mp5" },
	command = "chief",
	max = 1,
	salary = 100,
	admin = 0,
	vote = false,
	hasLicense = false,
	sortOrder = 1,
	candemote = true,
	chief = true,
	category = "Government & Police",
	PlayerLoadout = function( ply )
		GiveGovAmmo( ply )
	end
} )

TEAM_FIRE = DarkRP.createJob( "Firefighter", {
	color = Color( 255, 0, 0, 255 ),
	model = { "models/player/portal/male_07_fireman.mdl" },
	description = [[Firefighters respond to emergency calls concerning fires and medical emergencies. They take orders from the fire chief.]],
	weapons = { "weapon_extinguisher_infinite", "weapon_medkit", "bn_defib", "narcan", "weapon_firehose", "weapon_hl2axe" },
	command = "fire",
	max = 4,
	salary = 50,
	admin = 0,
	vote = false,
	hasLicense = false,
	sortOrder = 2,
	candemote = false,
	medic = true,
	category = "Emergency Response",
} )

TEAM_DETECTIVE = DarkRP.createJob( "Detective", {
	color = Color( 20, 150, 20, 255 ),
	model = { "models/sirgibs/ragdolls/detective_magnusson_player.mdl" },
	description = [[Detectives have two ways to do their job. One way is to work with Law Enforcement to solve crimes and bring people to justice. The other way is to be hired as a private investigator to look into civil matters that the police won't deal with.]],
	weapons = { "arc9_fas_ragingbull", "weapon_metal_detector", "weapon_cuff_shackles", "lockpick" },
	command = "detective",
	max = 2,
	salary = 25,
	admin = 0,
	vote = false,
	hasLicense = false,
	candemote = false,
	category = "Citizens",
} )

local hack = true
TEAM_UNDERCOVER = DarkRP.createJob( "Undercover Officer", {
	color = Color( 20, 150, 20, 255 ),
	model = civimodels,
	description = [[Undercover officers are tasked with collecting data on criminals by blending in with them. Collecting enough data and evidence could eventually lead to a raid and/or arrest.]],
	weapons = { "arc9_fas_p226", "weapon_metal_detector", "policebadge", "stungun", "weapon_cuff_police", "arrest_stick", "unarrest_stick", "weapon_agent" },
	command = "agent",
	max = 4,
	salary = 75,
	admin = 0,
	vote = false,
	sortOrder = 5,
	hasLicense = false,
	category = "Government & Police",
	PlayerChangeTeam = function( ply, old, new )
		if hack then
			hack = false
			ply:changeTeam( TEAM_UNDERCOVER, false, true )
			timer.Simple( 0.5, function()
				hack = true
				ply:updateJob( "Citizen" )
				DarkRP.notify( ply, 0, 6, "You have silently changed your job to Undercover Officer." )
			end )
			return false
		end
	end
} )

TEAM_FIREBOSS = DarkRP.createJob( "Fire Chief", {
	color = Color( 255, 0, 0, 255 ),
	model = {
		"models/player/portal/male_07_fireman.mdl",
		"models/player/kleiner.mdl"
	},
	description = [[The Fire Chief is in charge of all other firefighters. They decide strategies such as the safest way to extinguish a fire.]],
	weapons = { "weapon_extinguisher_infinite", "weapon_medkit", "bn_defib", "narcan", "weapon_firehose", "weapon_hl2axe" },
	command = "firechief",
	max = 1,
	salary = 80,
	admin = 0,
	vote = false,
	hasLicense = false,
	sortOrder = 1,
	medic = true,
	category = "Emergency Response",
} )

TEAM_BANKER = DarkRP.createJob( "Banker", {
    color = Color( 20, 150, 20, 255 ),
    model = civimodels,
    description = [[Bankers hand out loans and store money in deposit boxes to collect interest from other players. They are also the first line of defense for protecting the city bank vault.]],
    weapons = {},
    command = "banker",
    max = 1,
    salary = 25,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
} )

TEAM_CAMERA = DarkRP.createJob( "News Reporter", {
    color = Color( 20, 150, 20, 255 ),
    model = civimodels,
    description = [[The news reporter goes around the city broadcasting any events that go down. These events can be anything the reporter can find, such as a simple opportunity to interview the mayor, or something major such as a shootout.]],
    weapons = { "news_camera" },
    command = "cameraman",
    max = 1,
    salary = 25,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
} )

TEAM_TOWER = DarkRP.createJob( "Mechanic", {
    color = Color( 20, 150, 20, 255 ),
    model = civimodels,
    description = [[Mechanics have the ability to tow and repair vehicles that are broken down, crashed, or illegally parked. They can also rent out cars to other players and sell cars via the car dealer NPC.]],
    weapons = { "msystem_wep_controller", "tow_attach", "weapon_gauto_repair", "weapon_gauto_vehicle_management", "weapon_gauto_fuel", "weapon_hl2pickaxe" },
    command = "tower",
    max = 1,
    salary = 25,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
} )

TEAM_BUS = DarkRP.createJob( "Bus Driver", {
    color = Color( 20, 150, 20, 255 ),
    model = civimodels,
    description = [[The bus driver's duty is just as the name suggests: to drive buses and transport people to their destination. To spawn your bus, go to the car dealer where you would spawn a normal car.]],
    weapons = {},
    command = "bus",
    max = 1,
    salary = 25,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
} )

TEAM_HITMAN = DarkRP.createJob( "Hitman", {
    color = Color( 20, 150, 20, 255 ),
    model = civimodels,
    description = [[Hitmen earn money by taking hits from other players. To request a hit, walk up to a hitman and press your use key. You can then enter the player you want dead and the price you are paying. If the hitman has a hit that he is currently on the job for, other hits cannot be placed. You can also earn extra money as a hitman by acting as a bounty hunter for government officials and getting paid to capture wanted players. Please note that as a hitman, you must supply your own weapons.]],
    weapons = {},
    command = "hitman",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"
} )

TEAM_MAYOR = DarkRP.createJob( "Mayor", {
    color = Color( 150, 20, 20, 255 ),
    model = { "models/player/breen.mdl" },
    description = [[The Mayor is in charge of the whole city. He gets to decide on economic and legal issues, as well as pretty much anything else related to the city and its citizens.]],
    weapons = {},
    command = "mayorcityrp",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    mayor = true,
    category = "Government & Police",
} )

TEAM_CITIZEN = DarkRP.createJob( "Citizen", {
    color = Color( 20, 150, 20, 255 ),
    model = civimodels,
    description = [[The Citizen is the base job and has no salary, intended for people who don't want to hold a job or want to do freelance/contract work.]],
    weapons = {},
    command = "citizen",
    max = 0,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens",
} )

TEAM_COOK = DarkRP.createJob( "Cook", {
	color = Color( 238, 99, 99, 255 ),
	model = civimodels,
	description = [[The cook's responsibility to feed everyone in the city. You can spawn food from the F4 menu, cook pizza with your oven, cook caught fish on your stove, or sell freshly grown farm food.]],
	weapons = {},
	command = "cook",
	max = 2,
	salary = 25,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = "Citizens",
	cook = true
} )

TEAM_GUN = DarkRP.createJob( "Gun Dealer", {
	color = Color( 20, 150, 20, 255 ),
	model = civimodels,
	description = [[Gun dealers provide citizens with a faster (but more expensive) alternative to crafting higher-tier weapons through shipments.]],
	weapons = {},
	command = "gundealer",
	max = 2,
	salary = 25,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = "Citizens"
} )

GAMEMODE.DefaultTeam = TEAM_CITIZEN
GAMEMODE.CivilProtection = {
	[TEAM_MAYOR] = true,
	[TEAM_UNDERCOVER] = true,
	[TEAM_OFFICER] = true,
	[TEAM_POLICEBOSS] = true
}
