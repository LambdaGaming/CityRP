if SERVER then
	--Spawn blueprint function
	function SpawnBlueprint( tier, owner, uses )
		local randwep = table.Random( tier )
		local e = ents.Create( "crafting_blueprint" )
		e:SetPos( owner:GetPos() + Vector( 0, 0, 35 ) )
		e:SetAngles( owner:GetAngles() )
		e:Spawn()
		e:SetOwner( owner )
		e:SetEntName( randwep[1] )
		e:SetRealName( randwep[2] )
		e:SetUses( uses )
	end
end

local meta = FindMetaTable( "Player" )
function meta:IsEMS()
	return self:Team() == TEAM_FIREBOSS or self:Team() == TEAM_FIRE
end
