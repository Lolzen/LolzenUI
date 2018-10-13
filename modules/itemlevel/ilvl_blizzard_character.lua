--// itemlevel on CharacterFrame (shortcut c)// --

local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("itemlevel", "Displays item level on equippable items", true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["itemlevel"] == false then return end

		local eF = CreateFrame("Frame")
		eF:RegisterEvent("UNIT_INVENTORY_CHANGED")
		eF:RegisterEvent("PLAYER_LOGIN")

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

		local function getItemlvl(unit, slot)
			if unit and UnitExists(unit) then
				local itemLink = GetInventoryItemLink(unit, GetInventorySlotInfo(("%sSlot"):format(slot)))
				if itemLink then
					return GetDetailedItemLevelInfo(itemLink)
				end
			end
		end

		local function getColorItemQuality(unit, slot)
			if unit and UnitExists(unit) then
				local itemLink = GetInventoryItemLink(unit, GetInventorySlotInfo(("%sSlot"):format(slot)))
				if itemLink then
					local quality = select(3, GetItemInfo(itemLink))
					if quality then
						local r, g, b = GetItemQualityColor(quality)
						return r, g, b
					end
				end
			end
		end

		-- PaperDollFrame
		local function updateCharacterSlotInfo()
			for i=1, #slots do
				local s = _G["Character"..slots[i].."Slot"]
				if not s.str then
					s.str = s:CreateFontString(nil, "OVERLAY")
					s.str:SetFont(LSM:Fetch("font", LolzenUIcfg.itemlevel["ilvl_font"]), LolzenUIcfg.itemlevel["ilvl_font_size"], LolzenUIcfg.itemlevel["ilvl_font_flag"])
					s.str:SetPoint(LolzenUIcfg.itemlevel["ilvl_anchor"], s, LolzenUIcfg.itemlevel["ilvl_font_posx"], LolzenUIcfg.itemlevel["ilvl_font_posy"])
					s.str:SetText(getItemlvl("player", slots[i]))
					if LolzenUIcfg.itemlevel["ilvl_use_itemquality_color"] == true then
						s.str:SetTextColor(getColorItemQuality("player", slots[i]))
					else
						s.str:SetTextColor(unpack(LolzenUIcfg.itemlevel["ilvl_font_color"]))
					end
				else
					s.str:SetText(getItemlvl("player", slots[i]))
					if LolzenUIcfg.itemlevel["ilvl_use_itemquality_color"] == true then
						s.str:SetTextColor(getColorItemQuality("player", slots[i]))
					end
				end
			end
		end

		function eF.UNIT_INVENTORY_CHANGED()
			if LolzenUIcfg.itemlevel["ilvl_characterframe"] == true then
				updateCharacterSlotInfo()
			end
		end

		function eF.PLAYER_LOGIN()
			eF:UNIT_INVENTORY_CHANGED()
		end

		eF:SetScript("OnEvent", function(self, event, ...)  
			if(self[event]) then
				self[event](self, event, ...)
			else
				print("LolzenUI - ilvl debug: "..event)
			end 
		end)
	end
end)