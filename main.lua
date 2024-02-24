if not MPC then
    _G.MPC = _G.MPC or {}
    MPC._path = ModPath
    MPC._data_path = SavePath .. "MPC.txt"
    MPC.settings = {
		r = 1,
		g = 0.2,
		b = 0.6,
		a = 1
    }

	function MPC:Load()
		local file = io.open(self._data_path, "r")
		if file then
			self.settings = json.decode(file:read("*all"))
			file:close()
		end
	end

	function MPC:Save()
		local file = io.open(self._data_path, "w+")
		if file then
			file:write(json.encode(self.settings))
			file:close()
		end
	end

	Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_mpc", function(loc)
        loc:add_localized_strings({
            ["mpc_menu"] = "Mark Panicked Cops",
            ["mpc_menu_desc"] = "Change the colour of the outline for cops, that are panicked"
        })
	end)
end

MPC:Load()

function MPC:CreatePanel()
	if self._panel or not managers.menu_component then
		return
	end
	self._panel = managers.menu_component._ws:panel():panel()
end

function MPC:CreateBitmap()
    local size = 80
    self.bitmap = self._panel:bitmap({
        layer = tweak_data.gui.MENU_LAYER + 1,
        h = size,
        w = size,
        color = Color(self.settings.r, self.settings.g, self.settings.b),
		alpha = self.settings.a,
    })
    self.bitmap:set_x(self._panel:right() * 0.8)
    self.bitmap:set_y(self._panel:center_y() * 0.6)
end

function MPC:DestroyPanel()
    if not alive(self._panel) then
        return
    end
    self._panel:clear()
    self._panel:parent():remove(self._panel)
    self._panel = nil
end

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenusMPC", function(menu_manager, nodes)
    MPC:Load()

    local main_menu_id = "MPC"

    MenuHelper:NewMenu(main_menu_id)
    
    MenuCallbackHandler.callback_mpc_colour_r = function(self, item)
        MPC.settings.r = item:value()
        if alive(MPC.bitmap) then
            MPC.bitmap:set_color(Color(MPC.settings.r, MPC.settings.g, MPC.settings.b))
        end
        MPC:Save()
    end

    MenuCallbackHandler.callback_mpc_colour_g = function(self, item)
        MPC.settings.g = item:value()
        if alive(MPC.bitmap) then
            MPC.bitmap:set_color(Color(MPC.settings.r, MPC.settings.g, MPC.settings.b))
        end
        MPC:Save()
    end

    MenuCallbackHandler.callback_mpc_colour_b = function(self, item)
        MPC.settings.b = item:value()
        if alive(MPC.bitmap) then
            MPC.bitmap:set_color(Color(MPC.settings.r, MPC.settings.g, MPC.settings.b))
        end
        MPC:Save()
    end

    MenuCallbackHandler.callback_mpc_a = function(self, item)
        MPC.settings.a = item:value()
        if alive(MPC.bitmap) then
            MPC.bitmap:set_alpha(MPC.settings.a)
        end
        MPC:Save()
    end

    MenuHelper:AddSlider({
        id = "mpc_r",
        title = "R",
        callback = "callback_mpc_colour_r",
        value = MPC.settings.r,
        min = 0,
        max = 1,
        step = 0.1,
        show_value = true,
        menu_id = main_menu_id,
        priority = 7,
        localized = false
    })

    MenuHelper:AddDivider({
        id = "mpc_r_divider",
        size = 0.5,
        menu_id = main_menu_id,
        priority = 6
    })

    MenuHelper:AddSlider({
        id = "mpc_g",
        title = "G",
        callback = "callback_mpc_colour_g",
        value = MPC.settings.g,
        min = 0,
        max = 1,
        step = 0.1,
        show_value = true,
        menu_id = main_menu_id,
        priority = 5,
        localized = false
    })

    MenuHelper:AddDivider({
        id = "mpc_g_divider",
        size = 0.5,
        menu_id = main_menu_id,
        priority = 4
    })

    MenuHelper:AddSlider({
        id = "mpc_b",
        title = "B",
        callback = "callback_mpc_colour_b",
        value = MPC.settings.b,
        min = 0,
        max = 1,
        step = 0.1,
        show_value = true,
        menu_id = main_menu_id,
        priority = 3,
        localized = false
    })

    MenuHelper:AddDivider({
        id = "mpc_b_divider",
        size = 16,
        menu_id = main_menu_id,
        priority = 2
    })

    MenuHelper:AddSlider({
        id = "mpc_a",
        title = "A",
        callback = "callback_mpc_a",
        value = MPC.settings.a,
        min = 0.1,
        max = 1,
        step = 0.1,
        show_value = true,
        menu_id = main_menu_id,
        priority = 1,
        localized = false
    })

    MenuCallbackHandler.MPCFocus = function(node, focus)
		if focus then
		    MPC:CreatePanel()
            MPC:CreateBitmap()
        else
            MPC:DestroyPanel()
		end
	end

    nodes[main_menu_id] = MenuHelper:BuildMenu(main_menu_id, { area_bg = "none", focus_changed_callback = "MPCFocus" })
    MenuHelper:AddMenuItem(nodes["blt_options"], main_menu_id, "mpc_menu", "mpc_menu_desc")
end)

local required = {}
if RequiredScript and not required[RequiredScript] then
	local fname = MPC._path .. RequiredScript:gsub(".+/(.+)", "lua/%1.lua")
	if io.file_is_readable(fname) then
		dofile(fname)
	end

	required[RequiredScript] = true
end