Hooks:PostHook(CopMovement, "on_suppressed", "on_suppressed_contour", function(self, state)
    if state and not self._unit:character_damage()._dead then
        self._unit:contour():add("highlight_character", false, 1, Color(MPC.settings.r, MPC.settings.g, MPC.settings.b) * MPC.settings.a)
    else
        self._unit:contour():remove("highlight_character", true)
    end
end)