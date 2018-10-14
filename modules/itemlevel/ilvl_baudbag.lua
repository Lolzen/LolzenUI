--// itemlevel (Baudbag) // --

local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["itemlevel"] == false then return end
		if not IsAddOnLoaded("BaudBag") then return end

		local eF = CreateFrame("Frame")
		eF:RegisterEvent("BAG_UPDATE_DELAYED")
		eF:RegisterEvent("BANKFRAME_OPENED")

		local function getItemlvlBags(bagID, slotID)
			local itemLink = GetContainerItemLink(bagID, slotID)
			local item = Item:CreateFromBagAndSlot(bagID, slotID)
			if item and IsEquippableItem(itemLink) then
				return item:GetCurrentItemLevel()
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

		-- Bags
		local function updateBagSlotInfo()
			for bag = -1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
				for slot = 1, GetContainerNumSlots(bag) do
					local s = _G["BaudBagSubBag"..bag.."Item"..slot]
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

		function eF.BAG_UPDATE_DELAYED()
			if LolzenUIcfg.itemlevel["ilvl_bags"] == true then
				updateBagSlotInfo()
			end
		end

		function eF.BANKFRAME_OPENED()
			if LolzenUIcfg.itemlevel["ilvl_bags"] == true then
				updateBagSlotInfo()
			end
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