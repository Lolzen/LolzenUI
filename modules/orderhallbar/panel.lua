--// orderhallbar // --

local function getAreaText()
	if not OrderHallCommandBar then return end
	if GetRealZoneText() == GetMinimapZoneText() then
		OrderHallCommandBar.AreaName:SetText(GetZoneText())
	else
		OrderHallCommandBar.AreaName:SetText(GetZoneText().." ("..GetMinimapZoneText()..")")
	end
end

local currency = {}
local prevName
local function getCurrencies()
	if not OrderHallCommandBar then return end
		for i=1, GetCurrencyListSize() do
		local name, isHeader, isExpanded, isUnused, isWatched, count, extraCurrencyType = GetCurrencyListInfo(i)
		if isWatched then
			local link = GetCurrencyListLink(i)
			local _, _, icon = GetCurrencyInfo(link:match("|Hcurrency:(%d+)|"))
			if not currency[name] then
				currency[name] = OrderHallCommandBar:CreateTexture("currency"..name)
				currency[name]:SetTexture(icon)
				currency[name]:SetSize(LolzenUIcfg.orderhallbar["ohb_currency_icon_size"], LolzenUIcfg.orderhallbar["ohb_currency_icon_size"])
				currency[name]:SetTexCoord(.04, .94, .04, .94)

				if not currency[name].text then
					currency[name].text = OrderHallCommandBar:CreateFontString(nil, "OVERLAY")
					currency[name].text:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg.orderhallbar["ohb_currency_font"], LolzenUIcfg.orderhallbar["ohb_currency_font_size"] ,LolzenUIcfg.orderhallbar["ohb_currency_font_flag"])
					currency[name].text:SetTextColor(1, 1, 1)
					currency[name].text:SetText(count)
				end

				if not currency[name].frame then
					currency[name].frame = CreateFrame("Frame", nil, OrderHallCommandBar)
					currency[name].frame:SetAllPoints(currency[name])
					currency[name].frame:SetScript("OnEnter", function(self) 
						GameTooltip:SetOwner(currency[name], "ANCHOR_BOTTOMRIGHT")
						GameTooltip:SetCurrencyByID(link:match("|Hcurrency:(%d+)|"))
						GameTooltip:Show()
					end)
					currency[name].frame:SetScript("OnLeave", function(self)
						GameTooltip:Hide()
					end)
				end
				
				currency[name].text:SetPoint("LEFT", currency[name], "RIGHT", 5, 0)
				if prevName == nil then
					currency[name]:SetPoint("LEFT", OrderHallCommandBar.Currency, "RIGHT", 10, 0)
					prevName = name
				else
					currency[name]:SetPoint("LEFT", currency[prevName].text, "RIGHT", 10, 0)
					prevName = name
				end
			else
				currency[name].text:SetText(count)
			end
		end
	end
end

local function modifyOHB()
	if OrderHallCommandBar.modded == true then return end
	OrderHallCommandBar.AreaName:SetTextColor(unpack(LolzenUIcfg.orderhallbar["ohb_zone_color"]))

	OrderHallCommandBar.Background:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.orderhallbar["ohb_background"])
	OrderHallCommandBar.Background:SetVertexColor(unpack(LolzenUIcfg.orderhallbar["ohb_background_color"]))
	OrderHallCommandBar.Background:SetAlpha(LolzenUIcfg.orderhallbar["ohb_background_alpha"])

	OrderHallCommandBar.WorldMapButton:Hide()

	OrderHallCommandBar.CurrencyIcon:ClearAllPoints()
	OrderHallCommandBar.CurrencyIcon:SetPoint("LEFT", OrderHallCommandBar.ClassIcon, "RIGHT", 5, 0)

	OrderHallCommandBar.Currency:ClearAllPoints()
	OrderHallCommandBar.Currency:SetPoint("LEFT", OrderHallCommandBar.CurrencyIcon, "RIGHT", 0, 0)
	OrderHallCommandBar.Currency:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg.orderhallbar["ohb_currency_font"], LolzenUIcfg.orderhallbar["ohb_currency_font_size"] ,LolzenUIcfg.orderhallbar["ohb_currency_font_flag"])
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
f:RegisterEvent("ZONE_CHANGED")
f:RegisterEvent("ZONE_CHANGED_INDOORS")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("CHAT_MSG_CURRENCY")
f:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
f:RegisterEvent("CINEMATIC_STOP")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "LolzenUI" then
			if LolzenUIcfg.modules["orderhallbar"] == false then return end

			if OrderHallCommandBar and OrderHallCommandBar.modded == true then return end

			if addon == "Blizzard_OrderHallUI" then
				modifyOHB()
				getAreaText()
				getCurrencies()
			else
				if LolzenUIcfg.orderhallbar["ohb_always_show"] == true then
					LoadAddOn("Blizzard_OrderHallUI")
				end
				if OrderHallCommandBar then
					if LolzenUIcfg.orderhallbar["ohb_always_show"] == true then
						-- prevent hiding the bar, show it everywhere
						OrderHallCommandBar:SetScript("OnHide", OrderHallCommandBar.Show)
					end
					-- hide troop info
					OrderHallCommandBar.RefreshCategories = function() end
					OrderHallCommandBar.RequestCategoryInfo = function() end
					if LolzenUIcfg.orderhallbar["ohb_always_show"] == true then
						-- show the bar on login too
						if not OrderHallCommandBar:IsShown() then
							OrderHallCommandBar:Show()
						end
					end
					-- modify the look
					modifyOHB()
					getAreaText()
					getCurrencies()
				end
			end
		end
	elseif event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "ZONE_CHANGED_NEW_AREA" then
		if LolzenUIcfg.modules["orderhallbar"] == false then return end
		getAreaText()
	elseif event == "CHAT_MSG_CURRENCY" or event == "CURRENCY_DISPLAY_UPDATE" then
		if LolzenUIcfg.modules["orderhallbar"] == false then return end
		getCurrencies()
	elseif event == "CINEMATIC_STOP" or event == "PLAYER_ENTERING_WORLD" then
		if LolzenUIcfg.modules["orderhallbar"] == false then return end
		if LolzenUIcfg.orderhallbar["ohb_always_show"] == true then
			if not OrderHallCommandBar:IsShown() then
				OrderHallCommandBar:Show()
			end
		end
	end
end)