Hooks:PostHook(CopMovement, "action_request" ,"action_request_remove_contour" ,function(self, action_desc)
	self._unit:contour():remove("highlight_character", true)
end)