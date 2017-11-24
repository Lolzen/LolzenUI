--//optionpanel//--

local addon, ns = ...

ns.panel = CreateFrame("Frame", "LolzenUIPanel")
ns.panel.name = addon
InterfaceOptions_AddCategory(ns.panel)

local title = ns.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("|cff5599ff"..addon.."|r")

local about = ns.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
about:SetText("Modify or add some UI Elements")

local version = ns.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
version:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 5, -20)
version:SetText("|cff5599ffVersion:|r "..GetAddOnMetadata("LolzenUI", "Version"))

local author = ns.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
author:SetPoint("TOPLEFT", version, "BOTTOMLEFT", 0, -8)
author:SetText("|cff5599ffAuthor:|r Lolzen")

local github = ns.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
github:SetPoint("TOPLEFT", author, "BOTTOMLEFT", 0, -8)
github:SetText("|cff5599ffGithub:|r https://github.com/Lolzen/LolzenUI")

local slash = ns.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
slash:SetPoint("TOPLEFT", github, "BOTTOMLEFT", 0, -8)
slash:SetText("|cff5599ff/lolzen|r |cffffffffor|r |cff5599ff/lolzenui|r |cffffffffopens up this panel|r")

local checkboxes = ns.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
checkboxes:SetPoint("TOPLEFT", slash, "BOTTOMLEFT", 0, -12)
checkboxes:SetText("|cff5599ffModules:|r to load:")

-- create the buttons
local button = {}
local column = 15
local function createButtons()
	for i=1, #ns.modules do
		button[i] = CreateFrame("CheckButton", "tickbox"..i, ns.panel, "UICheckButtonTemplate")
		if i == 1 then
			button[i]:SetPoint("TOPLEFT", checkboxes, "BOTTOMLEFT", 0, -8)
		elseif i == column or i == column*2 or i == column*3 then
			button[i]:SetPoint("LEFT", button[i+1-column], "RIGHT", 130, 0)
		else
			button[i]:SetPoint("TOPLEFT", button[i-1], "BOTTOMLEFT", 0, 4)
		end

		button[i].text = _G["tickbox"..i.."Text"]
		button[i].text:SetText(ns.modules[i])
		
		-- get status from saved vars
		if LolzenUIcfg.modules[ns.modules[i]] == true then
			button[i]:SetChecked(true)
			button[i].text:SetTextColor(51/255, 181/255, 229/225)
		else
			button[i]:SetChecked(false)
			button[i].text:SetTextColor(1, 1, 1)
		end
	end
end

ns.panel.okay = function(self)
	for i=1, #ns.modules do
		if button[i]:GetChecked() then
			LolzenUIcfg.modules[ns.modules[i]] = true
		else
			LolzenUIcfg.modules[ns.modules[i]] = false
		end
	end
	ReloadUI()
end

ns.panel.default = function(self)
	--for i=1, #ns.modules do
	--	LolzenUIcfg.modules[ns.modules[i]] = true
	--end
--	ReloadUI()
end

ns.panel:RegisterEvent("ADDON_LOADED")
ns.panel:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		createButtons()
	end
end)