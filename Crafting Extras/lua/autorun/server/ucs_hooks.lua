hook.Add( "UCS_CanCraft", "UCS_CanCraftModifiers", function( ent, ply, recipe )
	if recipe.Blueprint then
		local found = false
		for k,v in ipairs( ents.FindInSphere( ent:GetPos(), 120 ) ) do
			if v:GetClass() == "crafting_blueprint" and v:GetEntName() == recipe.Blueprint then
				if v:GetUses() == 1 then
					v:Remove()
				else
					v:SetUses( v:GetUses() - 1 )
				end
				found = true
				break
			end
		end
		if !found then
			net.Start( "CraftMessage" )
			net.WriteString( "Required blueprint not detected!" )
			net.WriteString( "buttons/button2.wav" )
			net.Send( ply )
			return false
		end
	end
end )

hook.Add( "UCS_OnCrafted", "UCS_CraftModifiers", function( ent, ply, recipe )
	--Gun dealer discount
	if ply:Team() == TEAM_GUN then
		local discount = false
		for k,v in pairs( recipe.Materials ) do
			local amount = v
			if k == "ucs_iron" and amount >= 4 then
				amount = math.Round( amount * 0.5 )
				ent:AddItem( "ucs_iron", amount )
				discount = true
			elseif k == "ucs_steel" and amount >= 2 then
				amount = math.Round( amount * 0.5 )
				ent:AddItem( "ucs_steel", amount )
				discount = true
			end
		end
		if discount then
			ply:SendLua( [[chat.AddText( Color( 100, 100, 255 ), "[Crafting Table]: ", color_white, "Gun dealer discount applied." )]] )
		end
	end
end )
