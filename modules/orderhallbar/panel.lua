--// orderhallbar // --

local addon, ns = ...

local currencies = {
	1226, --Nethershards
	1273, --Seal of Broken Fate
	1501, --Writhing Essence
}

local function getAreaText()
	if OrderHallCommandBar then
		if GetRealZoneText() == GetMinimapZoneText() then
			OrderHallCommandBar.AreaName:SetText(GetZoneText())
		else
			OrderHallCommandBar.AreaName:SetText(GetZoneText().." ("..GetMinimapZoneText()..")")
		end
	end
end

local currency = {}
local function getCurrencies()
	for i=1, #currencies do
		local name, amount, icon = GetCurrencyInfo(currencies[i])
		if not currency[i] then
			currency[i] = OrderHallCommandBar:CreateTexture("currency"..i)
			currency[i]:SetTexture(icon)
			currency[i]:SetSize(18, 18)
			currency[i]:SetTexCoord(.04, .94, .04, .94)

			if not currency[i].text then
				currency[i].text = OrderHallCommandBar:CreateFontString(nil, "OVERLAY")
				currency[i].text:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12 ,"OUTLINE")
				currency[i].text:SetTextColor(1, 1, 1)
				currency[i].text:SetText(amount)
			end

			if not currency[i].frame then
				currency[i].frame = CreateFrame("Frame", nil, OrderHallCommandBar)
				currency[i].frame:SetAllPoints(currency[i])
				currency[i].frame:SetScript("OnEnter", function(self) 
					GameTooltip:SetOwner(currency[i], "ANCHOR_BOTTOMRIGHT")
					GameTooltip:SetCurrencyByID(currencies[i])
					GameTooltip:Show()
				end)
				currency[i].frame:SetScript("OnLeave", function(self)
					GameTooltip:Hide()
				end)
			end

			currency[i].text:SetPoint("LEFT", currency[i], "RIGHT", 5, 0)
			if i == 1 then
				currency[i]:SetPoint("LEFT", OrderHallCommandBar.Currency, "RIGHT", 10, 0)
			else
				currency[i]:SetPoint("LEFT", currency[i-1].text, "RIGHT", 10, 0)
			end
		else
			currency[i].text:SetText(amount)
		end
	end
end

local function modifyOHB()
	if OrderHallCommandBar.modded == true then return end
	OrderHallCommandBar.AreaName:SetTextColor(51/255, 181/255, 229/225)

	OrderHallCommandBar.Background:SetTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
	OrderHallCommandBar.Background:SetVertexColor(0, 0, 0, 0.5)

	OrderHallCommandBar.WorldMapButton:Hide()

	OrderHallCommandBar.CurrencyIcon:ClearAllPoints()
	OrderHallCommandBar.CurrencyIcon:SetPoint("LEFT", OrderHallCommandBar.ClassIcon, "RIGHT", 5, 0)

	OrderHallCommandBar.Currency:ClearAllPoints()
	OrderHallCommandBar.Currency:SetPoint("LEFT", OrderHallCommandBar.CurrencyIcon, "RIGHT", 0, 0)
	OrderHallCommandBar.Currency:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12 ,"OUTLINE")
	OrderHallCommandBar.Currency:SetTextColor(1, 1, 1)
	OrderHallCommandBar.Currency:SetShadowOffset(0, 0)

	-- as the mouseover tooltip isn't available anymore, since we overlap it with the currency info
	-- create our own and mimic the original's behaviour
	cF = CreateFrame("Frame", nil, OrderHallCommandBar)
	cF:SetAllPoints(OrderHallCommandBar.CurrencyIcon)
	cF:SetScript("OnEnter", function(self) 
		GameTooltip:SetOwner(OrderHallCommandBar.CurrencyIcon, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetCurrencyByID(1220)
		GameTooltip:Show()
	end)
	cF:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	local ohbframe = CreateFrame("Frame")
	ohbframe:SetAllPoints(OrderHallCommandBar.ClassIcon)
	ohbframe:EnableMouse(true)
	ohbframe:SetFrameStrata("HIGH")

	ohbframe:SetScript("OnMouseDown", GarrisonLandingPage_Toggle)

	OrderHallCommandBar.modded = true
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "LolzenUI" then
			if LolzenUIcfg["orderhallbar"] == false then return end
			
			if OrderHallCommandBar and OrderHallCommandBar.modded == true then return end
			
			if addon == "Blizzard_OrderHallUI" then
				if LolzenUIcfg["orderhallbar"] == false then return end
				modifyOHB()
				getAreaText()
				getCurrencies()
			else
				if LolzenUIcfg["orderhallbar"] == false then return end
				LoadAddOn("Blizzard_OrderHallUI")
				if OrderHallCommandBar then
					-- prevent hiding the bar, show it everywhere
					OrderHallCommandBar:SetScript("OnHide", OrderHallCommandBar.Show)
					-- hide troop info
					OrderHallCommandBar.RefreshCategories = function() end
					OrderHallCommandBar.RequestCategoryInfo = function() end
					-- show the bar on login too
					if not OrderHallCommandBar:IsShown() then
						OrderHallCommandBar:Show()
					end
					-- modify the look
					modifyOHB()
					getAreaText()
					getCurrencies()
				end
			end
		end
	end
end)

local f2 = CreateFrame("Frame")
f2:RegisterEvent("ZONE_CHANGED")
f2:RegisterEvent("ZONE_CHANGED_INDOORS")
f2:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f2:RegisterEvent("CHAT_MSG_CURRENCY")
f2:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
f2:SetScript("OnEvent", function(self, event, addon)
	if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "ZONE_CHANGED_NEW_AREA" then
		if LolzenUIcfg["orderhallbar"] == false then return end
		getAreaText()
	elseif event == "CHAT_MSG_CURRENCY" or event == "CURRENCY_DISPLAY_UPDATE" then
		if LolzenUIcfg["orderhallbar"] == false then return end
		getCurrencies()
	end
end)