Hooks:PreHook(CopDamage, "die", "die_remove_contour", function(self, attack_data)
	self._unit:contour():remove("highlight_character", true)
end )