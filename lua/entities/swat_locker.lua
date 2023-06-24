AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "SWAT Locker"
ENT.Author = "Lambda Gaming"
ENT.Category = "Superadmin Only"
ENT.Spawnable = true

if SERVER then
	local swatmodels = {
		"models/player/urban.mdl",
		"models/player/riot.mdl",
		"models/player/gasmask.mdl",
		"models/player/swat.mdl"
	}

	local chiefweps = {
		"weapon_bomb_checker",
		"arc9_fas_m4a1",
		"arc9_fas_p226",
		"weapon_confiscate",
		"door_ram",
		"weapon_checker",
		"weapon_leash_police",
		"policebadge",
		"stungun",
		"ershield_swat"
	}

	local normalweps = {
		"weapon_bomb_checker",
		"arc9_fas_m4a1",
		"arc9_fas_p226",
		"weapon_confiscate",
		"door_ram",
		"weapon_checker",
		"weapon_leash_police",
		"policebadge",
		"stungun",
		"arc9_fas_m84",
		"arc9_fas_m18"
	}

	local allowed = {
		[TEAM_POLICEBOSS] = true,
		[TEAM_OFFICER] = true,
		[TEAM_UNDERCOVER] = true
	}

	function ENT:Initialize()
		self:SetModel( "models/props_c17/Lockers001a.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetMaterial( "phoenix_storms/iron_rails" )
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion( false )
			phys:Wake()
		end
		
		self.ActiveSwat = {}
	end

	function ENT:Use( ply )
		local id = ply:SteamID64()
		if !allowed[ply:Team()] then
			if ply.IsSwat then
				ply.IsSwat = false
				self.ActiveSwat[id] = nil
				DarkRP.notify( ply, 1, 6, "You changed to SWAT but then changed jobs. Your stored items have been lost." )
				return
			end
			DarkRP.notify( ply, 1, 6, "Only police officers can use this locker." )
			return
		end

		self:EmitSound( "doors/door_metal_thin_open1.wav" )
		if ply.IsSwat then
			ply:StripWeapons()
			for k,v in pairs( self.ActiveSwat[id].Weapons ) do
				ply:Give( v )
			end
			ply:SetModel( self.ActiveSwat[id].PM )
			ply:SetArmor( self.ActiveSwat[id].Armor )
			ply:SetWalkSpeed( self.ActiveSwat[id].Speed[1] )
			ply:SetRunSpeed( self.ActiveSwat[id].Speed[2] )
			self.ActiveSwat[id] = nil
			ply.IsSwat = false
			DarkRP.notify( ply, 0, 6, "You have switched back to normal duty." )
		else
			self.ActiveSwat[id] = {
				Weapons = {},
				PM = ply:GetModel(),
				Armor = ply:Armor(),
				Speed = { ply:GetWalkSpeed(), ply:GetRunSpeed() }
			}
			for k,v in pairs( ply:GetWeapons() ) do
				table.insert( self.ActiveSwat[id].Weapons, v:GetClass() )
			end
			ply:StripWeapons()
			if ply:Team() == TEAM_POLICEBOSS then
				for k,v in pairs( chiefweps ) do
					ply:Give( v )
				end
			else
				for k,v in pairs( normalweps ) do
					ply:Give( v )
				end
			end
			for k,v in pairs( GAMEMODE.Config.DefaultWeapons ) do
				ply:Give( v )
			end
			ply:SetModel( table.Random( swatmodels ) )
			ply:SetArmor( 100 )
			ply:SetWalkSpeed( 150 )
			ply:SetRunSpeed( 180 )
			ply.IsSwat = true
			DarkRP.notify( ply, 0, 6, "You have switched to SWAT duty." )
		end
	end
end

if CLIENT then
	local offset = Vector( 0, 0, 50 )
	function ENT:Draw()
		self:DrawNPCText( "SWAT Locker", offset )
	end
end
