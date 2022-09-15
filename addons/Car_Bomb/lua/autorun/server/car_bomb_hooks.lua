local function Explode( pos )
    local explode = ents.Create( "env_explosion" )
    explode:SetPos( pos )
    explode:Spawn()
    explode:SetKeyValue( "iMagnitude", 100 )
    explode:Fire( "Explode", 0, 0 )
end

local function CreateProp( pos, ang, model )
    local e = ents.Create( "prop_physics" )
    e:SetPos( pos )
    e:SetModel( model )
    e:SetAngles( ang )
    e:SetColor( Color( 128, 128, 128 ) )
    e:SetMaterial( "models/props_foliage/tree_deciduous_01a_trunk" )
    e:Spawn()
	return e
end

local function BlowUp( ply, veh )
	Explode( veh:GetPos() )
	veh:Remove()
	local prop = CreateProp( veh:GetPos(), veh:GetAngles(), veh:GetModel() )
	prop:GetPhysicsObject():SetVelocity( veh:GetVelocity() + Vector( 0, 0, 500 ) )
	prop:EmitSound( "ambient/explosions/explode_5.wav" )
	if ply:InVehicle() and ply:GetVehicle() == veh then ply:Kill() end
	for k,v in pairs( veh.seat ) do
		local driver = v:GetDriver()
		if IsValid( driver ) then
			driver:Kill()
		end
	end
	timer.Simple( 600, function()
		if IsValid( prop ) then
			prop:Remove()
		end
	end )
end

local BombType = {
	function( ply, veh )
		timer.Simple( 1, function()
			BlowUp( ply, veh )
        end )
	end,
	function( ply, veh )
		timer.Simple( 60, function()
			BlowUp( ply, veh )
		end )
	end,
	function( ply, veh )
		timer.Simple( 300, function()
			BlowUp( ply, veh )
		end )
	end,
	function( ply, veh )
		if timer.Exists( "CarBomb"..veh:EntIndex() ) then return end
		timer.Create( "CarBomb"..veh:EntIndex(), 0.5, 0, function()
			local mph = veh:GetVelocity():Length() * 0.056818181
			if mph >= 20 then
				BlowUp( ply, veh )
				timer.Remove( "CarBomb"..veh:EntIndex() )
			end
		end )
	end,
	function( ply, veh )
		if timer.Exists( "CarBomb"..veh:EntIndex() ) then return end
		timer.Create( "CarBomb"..veh:EntIndex(), 0.5, 0, function()
			local mph = veh:GetVelocity():Length() * 0.056818181
			if mph >= 50 then
				BlowUp( ply, veh )
				timer.Remove( "CarBomb"..veh:EntIndex() )
			end
		end )
	end
}

hook.Add( "PlayerEnteredVehicle", "CarBombEnterVehicle", function( ply, veh )
    if IsValid( veh ) and veh.HasCarBomb then
		BombType[veh.CarBombType]( ply, veh )
    end
end )
