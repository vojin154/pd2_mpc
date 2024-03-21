local id = "mpc_highlight_character"

Hooks:PostHook(CopActionAct, "init", "init_contour", function(self, action_desc, common_data)
    local unit = self._unit
    local contour = (alive(unit) and unit:contour()) or nil
    if (not contour) or (not contour.indexed_types) or (not contour._types) then
        return
    end

    local variant = self._sanity_old_names_converter[action_desc.variant] or action_desc.variant
    if type_name(variant) == "number" then
        variant = self._machine:index_to_state_name(variant)
    end

    local types = contour._types
    --I am a lazy fuck, so anything to avoid hooking other files
    if not types[id] then
        local indexed_types = contour.indexed_types

        types[id] = { --Copy pasted from highlight_character
            priority = 9000, --Why? Because I can.. Also, IT'S OVER 9,000!!!
            material_swap_required = true,
            color = tweak_data.contour.interactable.standard_color
        }

        table.insert(indexed_types, types[id])
    end

    if string.find(tostring(variant), "suppressed_fumble_") then
        contour:add(id, false, 1, Color(MPC.settings.r, MPC.settings.g, MPC.settings.b) * MPC.settings.a)
    end
end)

Hooks:PreHook(CopActionAct, "on_exit", "on_exit_remove_contour", function(self)
    local unit = self._unit
    local contour = (alive(unit) and unit:contour()) or nil
    if contour and unit:contour():has_id(id) then
		unit:contour():remove(id, false)
	end
end)