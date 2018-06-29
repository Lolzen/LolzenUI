--// itemlevel // --

local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("itemlevel", true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["itemlevel"] == false then return end

		local eF = CreateFrame("Frame")
		eF:RegisterEvent("INSPECT_READY")
		eF:RegisterEvent("UNIT_INVENTORY_CHANGED")
		eF:RegisterEvent("BAG_UPDATE_DELAYED")
		--eF:RegisterEvent("BANKFRAME_OPENED")
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

		local function getItemlvlBags(bagID, slotID)
			local itemLink = GetContainerItemLink(bagID, slotID)
			if itemLink and IsEquippableItem(itemLink) then
				return GetDetailedItemLevelInfo(itemLink)
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

		local function getColorItemQualityBags(bagID, slotID)
			local itemLink = GetContainerItemLink(bagID, slotID)
			if itemLink then
				local quality = select(3, GetItemInfo(itemLink))
				if quality then
					local r, g, b = GetItemQualityColor(quality)
					return r, g, b
				end
			end
		end

		-- PaperDollFrame
		local function updateCharacterSlotInfo()
			for i=1, #slots do
				-- Create fontstrings for each slot we want
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

		-- InspectFrame
		local function updateInspectSlotInfo()
			for i=1, #slots do
				-- Create fontstrings for each slot we want
				local s = _G["Inspect"..slots[i].."Slot"]
				if s then 
					if not s.str then
						s.str = s:CreateFontString(nil, "OVERLAY")
						s.str:SetFont(LSM:Fetch("font", LolzenUIcfg.itemlevel["ilvl_font"]), LolzenUIcfg.itemlevel["ilvl_font_size"], LolzenUIcfg.itemlevel["ilvl_font_flag"])
						s.str:SetPoint(LolzenUIcfg.itemlevel["ilvl_anchor"], s, LolzenUIcfg.itemlevel["ilvl_font_posx"], LolzenUIcfg.itemlevel["ilvl_font_posy"])
						s.str:SetText(getItemlvl(InspectFrame.unit, slots[i]))
						if LolzenUIcfg.itemlevel["ilvl_use_itemquality_color"] == true then
							s.str:SetTextColor(getColorItemQuality(InspectFrame.unit, slots[i]))
						else
							s.str:SetTextColor(unpack(LolzenUIcfg.itemlevel["ilvl_font_color"]))
						end
					else
						s.str:SetText(getItemlvl(InspectFrame.unit, slots[i]))
						if LolzenUIcfg.itemlevel["ilvl_use_itemquality_color"] == true then
							s.str:SetTextColor(getColorItemQuality(InspectFrame.unit, slots[i]))
						end
					end
				end
			end
		end

		-- Bags
		-- we need reverseNum and tempNum so we can assign the itemLevel to the correct slot
		-- for some reason this would have been reversed in order otherwise, despite the slot from the corresponding bag having the correct slotID
		local reverseNum = {}
		local tempNum
		local function updateBagSlotInfo()
			-- Cycle through all equipped bags
			for bag = 0, NUM_BAG_SLOTS do
				-- and get their slots
				tempNum = GetContainerNumSlots(bag)
				for slot = 1, GetContainerNumSlots(bag) do
					reverseNum[slot] = tempNum
					tempNum = tempNum -1
					-- Create fontstrings for each slot we want
					local s
					if IsAddOnLoaded("BaudBag") then
						s = _G["BaudBagSubBag"..bag.."Item"..slot]
					else
						s = _G["ContainerFrame"..(bag+1).."Item"..reverseNum[slot]]
					end
					if s then
						if not s.str then
							s.str = s:CreateFontString(nil, "OVERLAY")
							s.str:SetFont(LSM:Fetch("font", LolzenUIcfg.itemlevel["ilvl_font"]), LolzenUIcfg.itemlevel["ilvl_font_size"], LolzenUIcfg.itemlevel["ilvl_font_flag"])
							s.str:SetPoint(LolzenUIcfg.itemlevel["ilvl_anchor"], s, LolzenUIcfg.itemlevel["ilvl_font_posx"], LolzenUIcfg.itemlevel["ilvl_font_posy"])
							s.str:SetText(getItemlvlBags(bag, slot))
							if LolzenUIcfg.itemlevel["ilvl_use_itemquality_color"] == true then
								s.str:SetTextColor(getColorItemQualityBags(bag, slot))
							else
								s.str:SetTextColor(unpack(LolzenUIcfg.itemlevel["ilvl_font_color"]))
							end
						else
							s.str:SetText(getItemlvlBags(bag, slot))
							if LolzenUIcfg.itemlevel["ilvl_use_itemquality_color"] == true then
								s.str:SetTextColor(getColorItemQualityBags(bag, slot))
							end
						end
					end
				end
			end
		end


		function eF.UNIT_INVENTORY_CHANGED()
			if LolzenUIcfg.itemlevel["ilvl_characterframe"] == true then
				updateCharacterSlotInfo()
			end
		end

		function eF.INSPECT_READY()
			if LolzenUIcfg.itemlevel["ilvl_inspectframe"] == true then
				updateInspectSlotInfo()
			end
		end

		function eF.BAG_UPDATE_DELAYED()
			if LolzenUIcfg.itemlevel["ilvl_bags"] == true then
				updateBagSlotInfo()
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