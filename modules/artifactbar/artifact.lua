--// artifactbar // --
-- Shows the Heart of Azeroth progress, only visible while such an item is active.

local _, ns = ...
local L = ns.L

ns.RegisterModule("artifactbar", L["desc_artifactbar"], true)

local function update(bar)
	local location = C_AzeriteItem and C_AzeriteItem.HasActiveAzeriteItem() and C_AzeriteItem.FindActiveAzeriteItem()
	if not location then
		if not bar.inEditMode then
			bar:Hide()
		end
		return
	end

	local xp, totalXP = C_AzeriteItem.GetAzeriteItemXPInfo(location)
	local level = C_AzeriteItem.GetPowerLevel(location)
	bar:SetMinMaxValues(0, totalXP > 0 and totalXP or 1)
	bar:SetValue(xp)
	bar.text:SetFormattedText("[Level: %d] %d / %d (%.0f%%)", level, xp, totalXP, totalXP > 0 and xp / totalXP * 100 or 0)
	bar:Show()
end

ns.OnInit("artifactbar", function()
	local cfg = LolzenUIcfg.artifactbar
	local bar, options = ns.CreateDataBar("LolzenUI_ArtifactBar", "artifactbar", cfg, ns.defaults.artifactbar, update)

	local function applyColor()
		bar:SetStatusBarColor(ns.RGB(cfg["artifactbar_color"]))
	end
	applyColor()
	options:Header(L["color"])
	options:Color("artifactbar_color", L["color"], applyColor)
	ns.RegisterDataBar(bar, L["LolzenUI: Artifact Bar"], ns.defaults.artifactbar)

	bar:RegisterEvent("PLAYER_ENTERING_WORLD")
	bar:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
	pcall(bar.RegisterEvent, bar, "AZERITE_ITEM_EXPERIENCE_CHANGED")
	pcall(bar.RegisterEvent, bar, "ARTIFACT_XP_UPDATE")
end)
