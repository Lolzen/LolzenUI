﻿--//optionpanel//--

local addon, ns = ...
local L = ns.L

ns.panel = CreateFrame("Frame", "LolzenUIPanel")
ns.panel.name = addon
InterfaceOptions_AddCategory(ns.panel)

-- a little hack to load options upon clicking the LolzenUIPanel button without having to rely on /lolzen or /lolzenui
hooksecurefunc("InterfaceOptionsListButton_OnClick", function(self, button)
	if self.element:GetName() == "LolzenUIPanel" then
		if not IsAddOnLoaded("LolzenUI_Options") then
			LoadAddOn("LolzenUI_Options")
			InterfaceAddOnsList_Update()
		end
	end
end)

local title = ns.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("|cff5599ff"..addon.."|r")

local about = ns.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
about:SetText(L["desc_LolzenUI"])

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
slash:SetText(L["LolzenUI_slash"])

local checkboxes = ns.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
checkboxes:SetPoint("TOPLEFT", slash, "BOTTOMLEFT", 0, -12)
checkboxes:SetText(L["modules_to_load"])

-- create the buttons
local button = {}
local column = 15
function ns.createButtons()
	for i=1, #ns.modules do
		if not button[i] then
			button[i] = CreateFrame("CheckButton", "tickbox"..i, ns.panel, "UICheckButtonTemplate")
			if i == 1 then
				button[i]:SetPoint("TOPLEFT", checkboxes, "BOTTOMLEFT", 0, -8)
			elseif i == column or i == column*2 or i == column*3 then
				button[i]:SetPoint("LEFT", button[i+1-column], "RIGHT", 130, 0)
			else
				button[i]:SetPoint("TOPLEFT", button[i-1], "BOTTOMLEFT", 0, 4)
			end

			button[i].text = _G["tickbox"..i.."Text"]
			button[i].text:SetText(L[ns.modules[i].name])

			-- get status from saved vars
			if LolzenUIcfg.modules[ns.modules[i].name] == true then
				button[i]:SetChecked(true)
				button[i].text:SetTextColor(51/255, 181/255, 229/255)
			else
				button[i]:SetChecked(false)
				button[i].text:SetTextColor(1, 1, 1)
			end

			button[i]:SetScript("OnClick", function(self)
				LolzenUIcfg.modules[ns.modules[i].name] = button[i]:GetChecked()
				StaticPopup_Show("LolzenUI_reloadnotice")
			end)

			button[i]:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(button[i], "ANCHOR_BOTTOMRIGHT")
				GameTooltip:SetText(ns.modules[i].desc, 1, 1, 1, 1, true)
				GameTooltip:Show()
			end)

			button[i]:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
		else
			-- custom modules may change positioning (because we sort alphabetically)
			button[i].text = _G["tickbox"..i.."Text"]
			button[i].text:SetText(L[ns.modules[i].name])
			
			-- get status from saved vars
			if LolzenUIcfg.modules[ns.modules[i].name] == true then
				button[i]:SetChecked(true)
				button[i].text:SetTextColor(51/255, 181/255, 229/255)
			else
				button[i]:SetChecked(false)
				button[i].text:SetTextColor(1, 1, 1)
			end
		end
	end
end

local applyButton = CreateFrame("Button", "LolzenUI_ApplyButton", ns.panel, "UIPanelButtonTemplate")
applyButton:SetSize(120, 23) -- width, height
applyButton:SetText(L["apply_button"])
applyButton:SetPoint("BOTTOMRIGHT", ns.panel, "BOTTOMRIGHT", -186, -37)
applyButton:SetScript("OnClick", function()
	for i=1, #ns.modules do
		LolzenUIcfg.modules[ns.modules[i].name] = button[i]:GetChecked()
	end
	ReloadUI()
end)

ns.panel.default = function(self)
	for i=1, #ns.modules do
		LolzenUIcfg.modules[ns.modules[i].name] = true
	end
	ReloadUI()
end

ns.panel:RegisterEvent("ADDON_LOADED")
ns.panel:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		ns.createButtons()
	end
end)