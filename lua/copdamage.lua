--JUST TO BE SURE IT GETS PROPERLY REMOVED

local function remove(self)
	if not alive(self._unit) or self._dead then
		self._unit:contour():remove("highlight_character", true)
	end
end

Hooks:PreHook(CopDamage, "clbk_suppression_decay", "clbk_suppression_decay_remove_contour", function(self)
	remove(self)
end)

Hooks:PreHook(CopDamage, "die", "die_remove_contour", function(self, attack_data)
	remove(self)
end )