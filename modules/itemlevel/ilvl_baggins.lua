--// itemlevel (Baggins) // --

local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["itemlevel"] == false then return end
		if not IsAddOnLoaded("Baggins") then return end

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

		-- Bags & Bank (Baggins)
		local function updateBagSlotInfo(_, _, button)
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
		end

		hooksecurefunc(Baggins, "UpdateItemButton", updateBagSlotInfo)

		ns.UpdateItemlevelBaggins = function()
			Baggins:UpdateBags()
		end
	end
end)