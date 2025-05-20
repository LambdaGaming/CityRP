if CLIENT then
	local tab = {
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0,
		["$pp_colour_colour"] = 1,
		["$pp_colour_inv"] = 1,
		["$pp_colour_contrast"] = 1,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0,
	}

	net.Receive( "DrugEffects", function()
		local disable = net.ReadBool()
		if disable then
			hook.Remove( "RenderScreenspaceEffects", "DrugEffects" )
		else
			hook.Add( "RenderScreenspaceEffects", "DrugEffects", function()
				local ply = LocalPlayer()
				local od = ply:GetNWInt( "Overdose" )
				local intensity = ( od * 0.1 ) + 0.2
				DrawMotionBlur( 0.4, intensity, 0.01 )
				if od >= 5 then
					DrawColorModify( tab )
				end
			end )
		end
	end )
end

if SERVER then
	local meta = FindMetaTable( "Player" )
	function meta:AddOD( amount )
		local od = self:GetNWInt( "Overdose", 0 ) + amount
		self:SetNWInt( "Overdose", od )
		if od > 8 then
			self:Kill()
		elseif od >= 5 then
			timer.Create( "ODGroan"..self:EntIndex(), 10, 0, function()
				if IsValid( self ) then
					self:EmitSound( "vo/npc/male01/moan0"..math.random( 1, 5 )..".wav" )
				end
			end )
		end
	end

	function meta:ResetOD()
		self:SetRunSpeed( 245 )
		self:SetWalkSpeed( 165 )
		self:SetGravity( 1 )
		self:SetNWInt( "Overdose", 0 )
		timer.Remove( "ODGroan"..self:EntIndex() )
	end

	util.AddNetworkString( "DrugEffects" )
	function meta:DrugEffect( disable )
		net.Start( "DrugEffects" )
		net.WriteBool( disable or false )
		net.Send( self )
	end

	hook.Add( "PlayerDeath", "ResetOD", function( ply )
		ply:ResetOD()
	end )
end

hook.Add( "SetupMove", "ODSpeed", function( ply, mv )
	local od = ply:GetNWInt( "Overdose" )
	if od >= 5 and od <= 8 then
		mv:SetMaxClientSpeed( 100 )
	end
end )
