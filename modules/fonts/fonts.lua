--// fonts // --
-- Replaces the fonts used by the game world (damage text, unit names, nameplates) and the standard font.
-- They have to be set before Blizzard creates its font strings, so changes require a reload.

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("fonts", L["desc_fonts"], true)

local FONTS = {"DAMAGE_TEXT_FONT", "UNIT_NAME_FONT", "NAMEPLATE_FONT", "STANDARD_TEXT_FONT"}

ns.OnInit("fonts", function()
	local cfg = LolzenUIcfg.fonts
	for _, global in ipairs(FONTS) do
		_G[global] = LSM:Fetch("font", cfg["fonts_"..global])
	end

	local options = ns.Options.New("fonts", function() return LolzenUIcfg.fonts end, ns.defaults.fonts, ns.AskReload)
	options:Header(L["font"])
	for _, global in ipairs(FONTS) do
		options:Font("fonts_"..global, L[global])
	end
	ns.SettingsPanel:AddCategory("fonts", options)
end)
