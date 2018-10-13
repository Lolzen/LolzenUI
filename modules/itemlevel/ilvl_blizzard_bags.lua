--// itemlevel on Blizzard's Bags and Bank// --

local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("itemlevel", "Displays item level on equippable items", true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["itemlevel"] == false then return end
		if IsAddOnLoaded("BaudBag") then return end

		local function getItemlvlBags(bagID, slotID)
			local itemLink = GetContainerItemLink(bagID, slotID)
			if itemLink and IsEquippableItem(itemLink) then
				return GetDetailedItemLevelInfo(itemLink)
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

		-- Bags & Bank (Blizzard)
		local function updateBagSlotInfoTest(frame)
			local bag = frame:GetID()
			local name = frame:GetName()
			local itemButton
			local texture, itemCount, locked, quality, readable, _, _, isFiltered, noValue, itemID
			for i=1, frame.size, 1 do
				itemButton = _G[name.."Item"..i]
				texture, itemCount, locked, quality, readable, _, _, isFiltered, noValue, itemID = GetContainerItemInfo(bag, itemButton:GetID())
				if texture then
					if not itemButton.str then
						itemButton.str = itemButton:CreateFontString(nil, "OVERLAY")
						itemButton.str:SetFont(LSM:Fetch("font", LolzenUIcfg.itemlevel["ilvl_font"]), LolzenUIcfg.itemlevel["ilvl_font_size"], LolzenUIcfg.itemlevel["ilvl_font_flag"])
						itemButton.str:SetPoint(LolzenUIcfg.itemlevel["ilvl_anchor"], itemButton, LolzenUIcfg.itemlevel["ilvl_font_posx"], LolzenUIcfg.itemlevel["ilvl_font_posy"])
						itemButton.str:SetText(getItemlvlBags(bag, itemButton:GetID()))
						if LolzenUIcfg.itemlevel["ilvl_use_itemquality_color"] == true then
							itemButton.str:SetTextColor(getColorItemQualityBags(bag, itemButton:GetID()))
						else
							itemButton.str:SetTextColor(unpack(LolzenUIcfg.itemlevel["ilvl_font_color"]))
						end
					else
						itemButton.str:SetText(getItemlvlBags(bag, itemButton:GetID()))
						if LolzenUIcfg.itemlevel["ilvl_use_itemquality_color"] == true then
							itemButton.str:SetTextColor(getColorItemQualityBags(bag, itemButton:GetID()))
						end
					end
				else
					if itemButton.str then
						itemButton.str:SetText(nil)
					end
				end
			end
		end
		hooksecurefunc("ContainerFrame_Update", updateBagSlotInfoTest)
		hooksecurefunc("BankFrameItemButton_Update", function(button)
			if not button.isBag then
				updateBagSlotInfoTest(BankFrame)
			end
		end)
	end
end)