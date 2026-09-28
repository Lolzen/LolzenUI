--// slashcommands //--

local _, ns = ...
local L = ns.L

ns.RegisterModule("slashcommands", L["desc_slashcommands"], true)

local function getMouseFocus()
	if GetMouseFoci then
		return GetMouseFoci()[1]
	end
	return GetMouseFocus and GetMouseFocus()
end

ns.OnInit("slashcommands", function()
	-- reloading faster
	SLASH_LOLZENUI_RELOAD1 = "/rl"
	SlashCmdList["LOLZENUI_RELOAD"] = ReloadUI

	-- name of the frame the mouse is over
	SLASH_LOLZENUI_FRAME1 = "/frame"
	SlashCmdList["LOLZENUI_FRAME"] = function()
		local focus = getMouseFocus()
		print(focus and (focus:GetDebugName() or focus:GetName()) or NONE)
	end

	-- children of the frame the mouse is over
	SLASH_LOLZENUI_CHILD1 = "/child"
	SlashCmdList["LOLZENUI_CHILD"] = function()
		local focus = getMouseFocus()
		if not focus then return end
		for _, child in ipairs({focus:GetChildren()}) do
			print(child:GetDebugName(), "-", child:GetObjectType())
		end
	end

	-- /gm if we want to open a GM ticket
	SLASH_LOLZENUI_GM1 = "/gm"
	SlashCmdList["LOLZENUI_GM"] = ToggleHelpFrame

	-- overview in the settings panel
	local options = ns.Options.New("slashcommands", function() return LolzenUIcfg end, {})
	options:Header(L["slashcommands"])
	for _, entry in ipairs({
		{"/lolzen", L["slash_lolzen"]},
		{"/lolzen edit", L["Opens the Edit Mode"]},
		{"/rl", L["slash_rl"]},
		{"/frame", L["slash_frame"]},
		{"/child", L["slash_child"]},
		{"/gm", L["slash_gm"]},
		{"/pull [n]", L["desc_pullcount"]},
	}) do
		options:Button(entry[1], function() end).label = entry[2]
	end
	ns.SettingsPanel:AddCategory("slashcommands", options)
end)
