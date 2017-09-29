--// itemlevel // --

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("INSPECT_READY")
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["itemlevel"] == false then return end

		local slots = {
			"Head", 
			"Neck", 
			"Shoulder", 
			"Back", 
			"Chest", 
			"Shirt", 
			"Tabard", 
			"Wrist", 
			"Hands",
			"Waist", 
			"Legs", 
			"Feet", 
			"Finger0", 
			"Finger1", 
			"Trinket0", 
			"Trinket1", 
			"MainHand", 
			"SecondaryHand",
		}

		local function showItemlvl(unit, slot)
			if unit and UnitExists(unit) then
				local itemLink = GetInventoryItemLink(unit, GetInventorySlotInfo(("%sSlot"):format(slot)))
				if itemLink then
					return select(4, GetItemInfo(itemLink))
				end
			end
		end

		-- PaperDollFrame
		function f.updateCharacterSlotInfo()
			for i=1, #slots do
				-- Create fontstrings for each slot we want
				local s = _G["Character"..slots[i].."Slot"]
				if not s.str then
					s.str = s:CreateFontString(nil, "OVERLAY")
					s.str:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg.itemlevel["ilvl_font"], LolzenUIcfg.itemlevel["ilvl_font_size"], LolzenUIcfg.itemlevel["ilvl_font_flag"])
					s.str:SetPoint(LolzenUIcfg.itemlevel["ilvl_anchor"], s, LolzenUIcfg.itemlevel["ilvl_font_posx"], LolzenUIcfg.itemlevel["ilvl_font_posy"])
				end
				s.str:SetText(showItemlvl("player", slots[i]))
				s.str:SetTextColor(unpack(LolzenUIcfg.itemlevel["ilvl_font_color"]))
			end
		end

		--InspectFrame
		function f.updateInspectSlotInfo()
			for i=1, #slots do
				-- Create fontstrings for each slot we want
				local s = _G["Inspect"..slots[i].."Slot"]
				if s then 
					if not s.str then
						s.str = s:CreateFontString(nil, "OVERLAY")
						s.str:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg.itemlevel["ilvl_font"], LolzenUIcfg.itemlevel["ilvl_font_size"], LolzenUIcfg.itemlevel["ilvl_font_flag"])
						s.str:SetPoint(LolzenUIcfg.itemlevel["ilvl_anchor"], s, LolzenUIcfg.itemlevel["ilvl_font_posx"], LolzenUIcfg.itemlevel["ilvl_font_posy"])
					else
						s.str:SetText(showItemlvl(InspectFrame.unit, slots[i]))
						s.str:SetTextColor(unpack(LolzenUIcfg.itemlevel["ilvl_font_color"]))
					end
				end
			end
		end

		-- Get the character info ready on load
		if LolzenUIcfg.itemlevel["ilvl_characterframe"] == true then
			f:updateCharacterSlotInfo()
		end
	end

	if event == "UNIT_INVENTORY_CHANGED" then
		if LolzenUIcfg.modules["itemlevel"] == false then return end

		if LolzenUIcfg.itemlevel["ilvl_characterframe"] == true then
			f:updateCharacterSlotInfo()
		end
	elseif event == "INSPECT_READY" then
		if LolzenUIcfg.modules["itemlevel"] == false then return end

		if LolzenUIcfg.itemlevel["ilvl_inspectframe"] == true then
			f:updateInspectSlotInfo()
		end
	end

	if addon == "Blizzard_InspectUI" then
		if LolzenUIcfg.modules["itemlevel"] == false then return end

		if LolzenUIcfg.itemlevel["ilvl_inspectframe"] == true then
			InspectFrame:HookScript("OnShow", f.updateInspectSlotInfo)
		end
	end
end)