﻿--// orderhallbar // --

local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("orderhallbar")

local function getCoordinates()
	local x, y = GetPlayerMapPosition("player")
	return format(" [%.1f/%.1f]",x*100,y*100)
end

local function getAreaText()
	if GetRealZoneText() == GetMinimapZoneText() then
		OrderHallCommandBar.AreaName:SetText(GetZoneText()..getCoordinates())
	else
		OrderHallCommandBar.AreaName:SetText(GetZoneText().." ("..GetMinimapZoneText()..")"..getCoordinates())
	end
end

local currency = {}
local function getCurrencies()
	if not OrderHallCommandBar then return end
	for i=1, MAX_WATCHED_TOKENS do
		if not currency[i] then
			currency[i] = OrderHallCommandBar:CreateTexture("currencyTexture"..i)
			currency[i]:SetSize(LolzenUIcfg.orderhallbar["ohb_currency_icon_size"], LolzenUIcfg.orderhallbar["ohb_currency_icon_size"])
			currency[i]:SetTexCoord(.04, .94, .04, .94)

			if not currency[i].text then
				currency[i].text = OrderHallCommandBar:CreateFontString(nil, "OVERLAY")
				currency[i].text:SetFont(LSM:Fetch("font", LolzenUIcfg.orderhallbar["ohb_currency_font"]), LolzenUIcfg.orderhallbar["ohb_currency_font_size"] ,LolzenUIcfg.orderhallbar["ohb_currency_font_flag"])
				currency[i].text:SetTextColor(1, 1, 1)
				currency[i].text:SetPoint("LEFT", currency[i], "RIGHT", 5, 0)
			end

			if not currency[i].frame then
				currency[i].frame = CreateFrame("Frame", nil, OrderHallCommandBar)
				currency[i].frame:SetAllPoints(currency[i])
				currency[i].frame:SetScript("OnEnter", function(self) 
					GameTooltip:SetOwner(currency[i], "ANCHOR_BOTTOMRIGHT")
					if currency[i].tooltipinfo ~= nil then
						GameTooltip:SetCurrencyByID(currency[i].tooltipinfo)
						GameTooltip:Show()
					end
				end)
				currency[i].frame:SetScript("OnLeave", function(self)
					GameTooltip:Hide()
				end)
			end

			if i == 1 then
				currency[i]:SetPoint("LEFT", OrderHallCommandBar.Currency, "RIGHT", 10, 0)
			else
				currency[i]:SetPoint("LEFT", currency[i-1].text, "RIGHT", 10, 0)
			end
		end
	end
	local counter = 1
	for i=1, GetCurrencyListSize() do
		local name, _, _, _, isWatched, count = GetCurrencyListInfo(i)
		if isWatched then
			local link = GetCurrencyListLink(i)
			local _, _, icon = GetCurrencyInfo(link:match("|Hcurrency:(%d+)|"))
			if currency[counter] then
				currency[counter]:SetTexture(icon)
				currency[counter].text:SetText(count)
				if not currency[counter].name then
					currency[counter].name = name
				end
				-- make the link available
				if not currency[counter].tooltipinfo then
					currency[counter].tooltipinfo = link:match("|Hcurrency:(%d+)|")
				end
				currency[counter]:Show()
				currency[counter].text:Show()
				counter = counter + 1
			end
		else
			for int=counter, #currency do
				if currency[int] then
					currency[int].text:SetText(nil)
					currency[int].tooltipinfo = nil
					currency[int]:Hide()
				end
			end
		end
	end
end
hooksecurefunc("TokenFrame_Update", getCurrencies)

local function modifyOHB()
	if OrderHallCommandBar.modded == true then return end
	OrderHallCommandBar.AreaName:SetTextColor(unpack(LolzenUIcfg.orderhallbar["ohb_zone_color"]))

	-- Create an AG based timer to update Area text and coordinates
	local timer = OrderHallCommandBar:CreateAnimationGroup()
	local timerAnim = timer:CreateAnimation()
	timerAnim:SetDuration(0.5)
	timer:SetScript("OnFinished", function(self, requested)
		getAreaText()
		self:Play()
	end)
	timer:Play()

	-- hide troop info
	OrderHallCommandBar.RefreshCategories = function() end
	OrderHallCommandBar.RequestCategoryInfo = function() end
				
	OrderHallCommandBar.Background:SetTexture(LSM:Fetch("background", LolzenUIcfg.orderhallbar["ohb_background"]))
	OrderHallCommandBar.Background:SetVertexColor(unpack(LolzenUIcfg.orderhallbar["ohb_background_color"]))
	OrderHallCommandBar.Background:SetAlpha(LolzenUIcfg.orderhallbar["ohb_background_alpha"])

	OrderHallCommandBar.WorldMapButton:Hide()

	OrderHallCommandBar.CurrencyIcon:ClearAllPoints()
	OrderHallCommandBar.CurrencyIcon:SetPoint("LEFT", OrderHallCommandBar.ClassIcon, "RIGHT", 5, 0)

	OrderHallCommandBar.Currency:ClearAllPoints()
	OrderHallCommandBar.Currency:SetPoint("LEFT", OrderHallCommandBar.CurrencyIcon, "RIGHT", 0, 0)
	OrderHallCommandBar.Currency:SetFont(LSM:Fetch("font", LolzenUIcfg.orderhallbar["ohb_currency_font"]), LolzenUIcfg.orderhallbar["ohb_currency_font_size"], LolzenUIcfg.orderhallbar["ohb_currency_font_flag"])
	OrderHallCommandBar.Currency:SetTextColor(1, 1, 1)
	OrderHallCommandBar.Currency:SetShadowOffset(0, 0)

	-- as the mouseover tooltip isn't available anymore, since we overlap it with the currency info
	-- create our own and mimic the original's behaviour
	local cF = CreateFrame("Frame", nil, OrderHallCommandBar)
	cF:SetAllPoints(OrderHallCommandBar.CurrencyIcon)
	cF:SetScript("OnEnter", function(self) 
		GameTooltip:SetOwner(OrderHallCommandBar.CurrencyIcon, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetCurrencyByID(1220)
		GameTooltip:Show()
	end)
	cF:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	OrderHallCommandBar:RegisterEvent("CHAT_MSG_CURRENCY")
	OrderHallCommandBar:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	OrderHallCommandBar:SetScript("OnEvent", function(self, event)
		if event == "CHAT_MSG_CURRENCY" or event == "CURRENCY_DISPLAY_UPDATE" then
			getCurrencies()
		end
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
f:RegisterEvent("CINEMATIC_STOP")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "LolzenUI" then
			if LolzenUIcfg.modules["orderhallbar"] == false then return end

			if LolzenUIcfg.orderhallbar["ohb_always_show"] == true then
				LoadAddOn("Blizzard_OrderHallUI")
			end
		elseif addon == "Blizzard_OrderHallUI" then
			if LolzenUIcfg.modules["orderhallbar"] == false then return end

			if OrderHallCommandBar then
				modifyOHB()
			end
		end
	elseif event == "CINEMATIC_STOP" or event == "PLAYER_ENTERING_WORLD" then
		if LolzenUIcfg.modules["orderhallbar"] == false then return end
		if LolzenUIcfg.orderhallbar["ohb_always_show"] == true then
			if not OrderHallCommandBar:IsShown() then
				OrderHallCommandBar:Show()
			end
		end
	end
end)