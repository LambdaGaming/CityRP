
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
end

hook.Add( "PlayerEnteredVehicle", "CarBombEnterVehicle", function( ply, veh )
    if IsValid( veh ) and veh.HasCarBomb then
        timer.Simple( 1, function()
            Explode( veh:GetPos() )
            CreateProp( veh:GetPos(), veh:GetAngles(), veh:GetModel() )
            ply:Kill()
            for k,v in pairs( veh.seat ) do
				local driver = v:GetDriver()
                if IsValid( driver ) then
					driver:Kill()
				end
            end
            veh:Remove()
        end )
    end
end )