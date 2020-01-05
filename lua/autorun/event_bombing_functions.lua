
if SERVER then
	function BombingRun()
		local expos = {}
		DarkRP.notifyAll( 1, 10, "Bomber incoming! Seek shelter!" )
		for k,v in pairs( player.GetAll() ) do
			v:SendLua( "surface.PlaySound( 'nazi_invasion/air_raid_siren_distant.ogg' )" )
		end
		
		if game.GetMap() == "rp_rockford_v2b" then
			expos = {
				Vector( -5078, -4838, 806 ),
				Vector( -5312, -5309, 811 ),
				Vector( -5179, -6140, 8 ),
				Vector( -4075, -6536, 8 ),
				Vector( -7979, -6107, 0 ),
				Vector( -7388, -5482, 157 ),
				Vector( 7988, 7206, 1544 ),
				Vector( 10895, 5569, 1544 ),
				Vector( -7601, -5431, 0 )
			}
		elseif game.GetMap() == "rp_chaos_city_v33x_03" then
			expos = {
				Vector( 4216, -4054, -1869 ),
				Vector( 3631, -4261, 2041 ),
				Vector( 3820, -3826, -243 ),
				Vector( 3326, -3818, -1869 ),
				Vector( 3053, -5453, -2125 ),
				Vector( -8227, -15435, -2152 ),
				Vector( -13722, -11730, -2152 ),
				Vector( -11004, -1372, -2136 ),
				Vector( -11102, 830, -2008 )
			}
		elseif game.GetMap() == "rp_evocity2_v5p" then
			expos = {
				Vector( -527, -1348, 76 ),
				Vector( -896, -2212, 76 ),
				Vector( 760, -2514, -180 ),
				Vector( 258, -2247, 558 ),
				Vector( -425, -1948, 3975 ),
				Vector( -890, -1924, 1835 ),
				Vector( 8306, 9896, -1800 ),
				Vector( 5843, 7862, -1760 ),
				Vector( 7454, 7471, -1824 )
			}
		elseif game.GetMap() == "rp_florida_v2" then
			expos = {
				Vector( 4076, -3914, 248 ),
				Vector( 6181, -2672, 490 ),
				Vector( 10665, 13806, 201 ),
				Vector( 8689, 8875, 183 ),
				Vector( 1892, 12382, 443 ),
				Vector( -8132, -1552, 136 ),
				Vector( -6465, -273, 141 ),
				Vector( -8880, -3, 142 ),
				Vector( -8328, 2163, 138 )
			}
		elseif game.GetMap() == "rp_truenorth_v1a" then
			expos = {
				Vector( -6629, 9041, 152 ),
				Vector( -4873, 8933, 186 ),
				Vector( -4706, 11971, 439 ),
				Vector( -6216, 11875, 457 ),
				Vector( 8526, -10250, 342 ),
				Vector( 8852, -8096, 356 ),
				Vector( 6494, -8107, 384 ),
				Vector( 6444, -9303, 343 ),
				Vector( 6512, -10294, 320 )
			}
		elseif game.GetMap() == "rp_newexton2_v4h" then
			expos = {
				Vector( -6405, 7617, 1088 ),
				Vector( -3434, 1121, 1584 ),
				Vector( -2406, 3220, 2240 ),
				Vector( 4567, 10537, 1666 ),
				Vector( 7017, 9880, 1885 ),
				Vector( 10625, 2190, 1240 ),
				Vector( 12567, 4021, 1024 ),
				Vector( 12549, 2894, 1024 ),
				Vector( 10831, 4002, 1020 )
			}
		end
		
		timer.Create( "BombingRun", 3, 5, function() --Spawns an explosion 5 times every 3 seconds
			local randex = table.Random( expos ) --Under the timer and not the for loop so all 5 explosions spawn in the same spot
			for i=1, 5 do --The more explosions that happen at once in one spot, the louder it is
				local e = ents.Create("env_explosion")
				e:SetPos( randex )
				e:Spawn()
				e:SetKeyValue( "iMagnitude", "2000" )
				e:Fire( "Explode", 0, 0 )
			end
		end )
	end
end

MsgC( color_orange, "[CityRP] Loaded North Korea mayor event bombing functions." )