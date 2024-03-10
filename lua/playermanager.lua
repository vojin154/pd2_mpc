Hooks:PostHook(PlayerManager, "on_killshot", "on_killshot_socio_contour", function(self, killed_unit, variant, headshot, weapon_id)
	local player_unit = self:player_unit()

	if not player_unit then
		return
	end

    local dist_sq = mvector3.distance_sq(player_unit:movement():m_pos(), killed_unit:movement():m_pos())
	local close_combat_sq = tweak_data.upgrades.close_combat_distance * tweak_data.upgrades.close_combat_distance

	if dist_sq <= close_combat_sq then
		local panic_chance = self:upgrade_value("player", "killshot_close_panic_chance", 0)
		panic_chance = managers.modifiers:modify_value("PlayerManager:GetKillshotPanicChance", panic_chance)

		if panic_chance > 0 or panic_chance == -1 then
			local slotmask = managers.slot:get_mask("enemies")
			local units = World:find_units_quick("sphere", player_unit:movement():m_pos(), tweak_data.upgrades.killshot_close_panic_range, slotmask)

			for _, unit in pairs(units) do
				if alive(unit) and unit:character_damage() and not unit:character_damage():dead() then
                    unit:contour():add("highlight_character", false , 1, Color(MPC.settings.a, MPC.settings.r, MPC.settings.g, MPC.settings.b))
				end
			end
		end
	end
end)