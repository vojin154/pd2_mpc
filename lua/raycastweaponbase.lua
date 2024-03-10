Hooks:PostHook(RaycastWeaponBase, "_build_suppression", "_build_suppression_muscle_contour", function(self, enemies_in_cone, suppr_mul)
    if self:gadget_overrides_weapon_functions() then
		local r = self:gadget_function_override("_build_suppression", self, enemies_in_cone, suppr_mul)

		if r ~= nil then
			return
		end
	end

	if enemies_in_cone then
		for u_key, enemy_data in pairs(enemies_in_cone) do
			if not enemy_data.unit:movement():cool() then
                enemy_data.unit:contour():add("highlight_character", false, 1, Color(MPC.settings.a, MPC.settings.r, MPC.settings.g, MPC.settings.b))
			end
		end
	end
end)