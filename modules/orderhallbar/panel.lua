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

local function getCurrencies()
	local currency = {}
	for i=1, #currencies do
		local name, amount, icon = GetCurrencyInfo(currencies[i])
		if amount > 0 then
			if not currency[i] then
				currency[i] = OrderHallCommandBar:CreateTexture("currency"..i)
				currency[i]:SetTexture(icon)
				currency[i]:SetSize(16, 16)
				currency[i]:SetTexCoord(.04, .94, .04, .94)
		--		currency[i]:SetScript("OnEnter", function(self) 
		--			GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
		--			GameTooltip:SetText( "This text shows up when you mouse over\nthe MyFrame frame" )
		--			GameTooltip:Show()
		--		end)

				if not currency[i].text then
					currency[i].text = OrderHallCommandBar:CreateFontString(nil, "OVERLAY")
					currency[i].text:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12 ,"OUTLINE")
					currency[i].text:SetTextColor(1, 1, 1)
				end
				currency[i].text:SetText(amount)
				currency[i].text:SetPoint("LEFT", currency[i], "RIGHT", 5, 0)
				if i == 1 then
					currency[i]:SetPoint("LEFT", OrderHallCommandBar.Currency, "RIGHT", 10, 0)
				else
					currency[i]:SetPoint("LEFT", currency[i-1].text, "RIGHT", 10, 0)
				end
			end
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
	OrderHallCommandBar.Currency:SetPoint("LEFT", OrderHallCommandBar.CurrencyIcon, "RIGHT", 5, 0)
	OrderHallCommandBar.Currency:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12 ,"OUTLINE")
	OrderHallCommandBar.Currency:SetTextColor(1, 1, 1)
	OrderHallCommandBar.Currency:SetShadowOffset(0, 0)
--	OrderHallCommandBar.Currency:SetScript("OnEnter", function() return end)
		
	local ohbframe = CreateFrame("Frame")
	ohbframe:SetAllPoints(OrderHallCommandBar.ClassIcon)
	ohbframe:EnableMouse(true)
	ohbframe:SetFrameStrata("HIGH")

	ohbframe:SetScript("OnMouseDown", GarrisonLandingPage_Toggle)
		
	--ohbframe:SetScript("OnEnter", function(self) 
		--Do some stuff here within a tooltip (infos)
--	end)

	
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