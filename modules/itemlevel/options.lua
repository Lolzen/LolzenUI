--// options for itemlevel //--

local addon, ns = ...

ns.RegisterModule("itemlevel")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["itemlevel"] == true then

		local title = ns["itemlevel"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["itemlevel"], 16, -16)
		title:SetText("|cff5599ff"..ns["itemlevel"].name.."|r")

		local about = ns["itemlevel"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Displays item level on items")

		local cb1 = CreateFrame("CheckButton", "Character", ns["itemlevel"], "ChatConfigCheckButtonTemplate")
		cb1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		CharacterText:SetText("|cff5599ffShow Itemlevel on Character frame|r")

		if LolzenUIcfg.itemlevel["ilvl_characterframe"] == true then
			cb1:SetChecked(true)
		else
			cb1:SetChecked(false)
		end

		local cb2 = CreateFrame("CheckButton", "Inspect", ns["itemlevel"], "ChatConfigCheckButtonTemplate")
		cb2:SetPoint("TOPLEFT", cb1, "BOTTOMLEFT", 0, 0)
		InspectText:SetText("|cff5599ffShow Itemlevel on Inspect frame|r")

		if LolzenUIcfg.itemlevel["ilvl_inspectframe"] == true then
			cb2:SetChecked(true)
		else
			cb2:SetChecked(false)
		end

		ns["itemlevel"].okay = function(self)
			if cb1:GetChecked(true) then
				LolzenUIcfg.itemlevel["ilvl_characterframe"] = true
			else
				LolzenUIcfg.itemlevel["ilvl_characterframe"] = false
			end
			if cb2:GetChecked(true) then
				LolzenUIcfg.itemlevel["ilvl_inspectframe"] = true
			else
				LolzenUIcfg.itemlevel["ilvl_inspectframe"] = false
			end
		end

		ns["itemlevel"].default = function(self)
			LolzenUIcfg.itemlevel["ilvl_characterframe"] = true
			LolzenUIcfg.itemlevel["ilvl_inspectframe"] = true
			ReloadUI()
		end
	end
end)