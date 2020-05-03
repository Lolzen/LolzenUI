--// itemlevel (LiteBag) // --

local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["itemlevel"] == false then return end
		if not IsAddOnLoaded("LiteBag") then return end

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

		local function getCorruptedItem(bagID, slotID)
			local itemLink = GetContainerItemLink(bagID, slotID)
			local item = Item:CreateFromBagAndSlot(bagID, slotID)
			if itemLink then
				if item and IsEquippableItem(itemLink) and IsCorruptedItem(itemLink) then
					return "Interface\\CorruptedItems\\CorruptedInventoryIcon"
				end
			end
		end

		-- Bags & Bank (LiteBags)
		local function updateBagSlotInfo(button)
			if not button then return end
			local bag = button:GetParent():GetID()
			if not button.str then
				button.str = button:CreateFontString(nil, "OVERLAY")
				button.str:SetFont(LSM:Fetch("font", LolzenUIcfg.itemlevel["ilvl_font"]), LolzenUIcfg.itemlevel["ilvl_font_size"], LolzenUIcfg.itemlevel["ilvl_font_flag"])
				button.str:SetPoint(LolzenUIcfg.itemlevel["ilvl_anchor"], button, LolzenUIcfg.itemlevel["ilvl_font_posx"], LolzenUIcfg.itemlevel["ilvl_font_posy"])
				if LolzenUIcfg.itemlevel["ilvl_bags"] == true then
					button.str:SetText(getItemlvlBags(bag, button:GetID()))
				else
					button.str:SetText("")
				end
				if LolzenUIcfg.itemlevel["ilvl_use_itemquality_color"] == true then
					button.str:SetTextColor(getColorItemQualityBags(bag, button:GetID()))
				else
					button.str:SetTextColor(unpack(LolzenUIcfg.itemlevel["ilvl_font_color"]))
				end
			else
				button.str:SetFont(LSM:Fetch("font", LolzenUIcfg.itemlevel["ilvl_font"]), LolzenUIcfg.itemlevel["ilvl_font_size"], LolzenUIcfg.itemlevel["ilvl_font_flag"])
				button.str:ClearAllPoints()
				button.str:SetPoint(LolzenUIcfg.itemlevel["ilvl_anchor"], button, LolzenUIcfg.itemlevel["ilvl_font_posx"], LolzenUIcfg.itemlevel["ilvl_font_posy"])
				if LolzenUIcfg.itemlevel["ilvl_bags"] == true then
					button.str:SetText(getItemlvlBags(bag, button:GetID()))
				else
					button.str:SetText("")
				end
				if LolzenUIcfg.itemlevel["ilvl_use_itemquality_color"] == true then
					button.str:SetTextColor(getColorItemQualityBags(bag, button:GetID()))
				else
					button.str:SetTextColor(unpack(LolzenUIcfg.itemlevel["ilvl_font_color"]))
				end
			end
			if not button.corruptedTexture then
				button.corruptedTexture = button:CreateTexture(nil, "OVERLAY")
				button.corruptedTexture:SetPoint("TOPLEFT", button)
				button.corruptedTexture:SetScale(0.5)
				button.corruptedTexture:SetTexture(getCorruptedItem(bag, button:GetID()))
			else
				button.corruptedTexture:SetTexture(getCorruptedItem(bag, button:GetID()))
			end
		end

		hooksecurefunc("LiteBagItemButton_Update", updateBagSlotInfo)

		ns.UpdateItemlevelLitebag = function()
			-- current max: 28 base + 7x 32 = 252
			-- be generous about it anyways and use 400
			for i=1, 400 do
				updateBagSlotInfo(_G["LiteBagInventoryPanelItemButton"..i])
				updateBagSlotInfo(_G["LiteBagBankPanelItemButton"..i])
			end
		end
	end
end)