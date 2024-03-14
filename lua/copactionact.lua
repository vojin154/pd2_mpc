Hooks:PostHook(CopActionAct, "init", "init_contour", function(self, action_desc, common_data)
    local variant = self._sanity_old_names_converter[action_desc.variant] or action_desc.variant
    if type_name(variant) == "number" then
        variant = self._machine:index_to_state_name(variant)
    end

    if string.find(tostring(variant), "suppressed_fumble_") then
        self._unit:contour():add("highlight_character", false, 1, Color(MPC.settings.r, MPC.settings.g, MPC.settings.b) * MPC.settings.a)
    end
end)


Hooks:PreHook(CopActionAct, "on_exit", "on_exit_remove_contour", function(self)
    if not alive(self._unit) or not self._unit:character_damage()._dead then
		self._unit:contour():remove("highlight_character", true)
	end
end)