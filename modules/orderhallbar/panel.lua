--// orderhallbar // --

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("orderhallbar", L["desc_orderhallbar"], true)

-- thanks to elcius for this
-- http://www.wowinterface.com/forums/showpost.php?p=328355&postcount=3
local MapRects = {}
local TempVec2D = CreateVector2D(0, 0)
function getCoordinates()
	local inInstance, instanceType = IsInInstance()
	if inInstance and (instanceType == "party" or "raid") then
		return ""
	else
		local MapID = C_Map.GetBestMapForUnit("player")
		local R, P, _ = MapRects[MapID], TempVec2D
		if not R then
			R = {};
			_, R[1] = C_Map.GetWorldPosFromMapPos(MapID, CreateVector2D(0, 0))
			_, R[2] = C_Map.GetWorldPosFromMapPos(MapID, CreateVector2D(1, 1))
			R[2]:Subtract(R[1])
			MapRects[MapID] = R
		end
		P.x, P.y = UnitPosition("Player")
		P:Subtract(R[1])
		return format(" [%.1f/%.1f]", (1/R[2].y)*P.y*100, (1/R[2].x)*P.x*100)
	end
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
				currency[i].text:SetFont(LSM:Fetch("font", LolzenUIcfg.orderhallbar["ohb_currency_font"]), LolzenUIcfg.orderhallbar["ohb_currency_font_size"], LolzenUIcfg.orderhallbar["ohb_currency_font_flag"])
				currency[i].text:SetTextColor(1, 1, 1)
				currency[i].text:SetPoint("LEFT", currency[i], "RIGHT", 5, 0)
			end

			if not currency[i].frame then
				currency[i].frame = CreateFrame("Frame", nil, OrderHallCommandBar)
				currency[i].frame:SetAllPoints(currency[i])
				currency[i].frame:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(currency[i], "ANCHOR_BOTTOMRIGHT")
					if currency[i].id ~= nil then
						GameTooltip:SetCurrencyByID(currency[i].id)
						GameTooltip:Show()
					end
				end)
				currency[i].frame:SetScript("OnLeave", function(self)
					GameTooltip:Hide()
				end)
			end

			if i == 1 then
				currency[i]:SetPoint("LEFT", OrderHallCommandBar.ClassIcon, "RIGHT", 10, 0)
			else
				currency[i]:SetPoint("LEFT", currency[i-1].text, "RIGHT", 10, 0)
			end
		end
	end
	local counter = 1
	for i=1, GetCurrencyListSize() do
		local name, _, _, _, isWatched, count, icon = GetCurrencyListInfo(i)
		if isWatched then
			local link = GetCurrencyListLink(i)
			local id = tonumber(strmatch(link, "currency:(%d+)"))
			if currency[counter] then
				currency[counter]:SetTexture(icon)
				currency[counter].text:SetText(count)
				if not currency[counter].name then
					currency[counter].name = name
				end
				-- make the currency id available
				if not currency[counter].id then
					currency[counter].id = id
				end
				currency[counter]:Show()
				currency[counter].text:Show()
				counter = counter + 1
			end
		else
			for int=counter, #currency do
				if currency[int] then
					currency[int].text:SetText(nil)
					currency[int].id = nil
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
	OrderHallCommandBar.AreaName:SetFont(LSM:Fetch("font", LolzenUIcfg.orderhallbar["ohb_zone_font"]), LolzenUIcfg.orderhallbar["ohb_zone_font_size"], LolzenUIcfg.orderhallbar["ohb_zone_font_flag"])

	-- Create an AG based timer to update Area text and coordinates
	local timer = OrderHallCommandBar:CreateAnimationGroup()
	local timerAnim = timer:CreateAnimation()
	timerAnim:SetDuration(0.5)
	timer:SetScript("OnFinished", function(self, requested)
		getAreaText()
		self:Play()
	end)

	-- hide troop info
	OrderHallCommandBar.RefreshCategories = function() end
	OrderHallCommandBar.RequestCategoryInfo = function() end
				
	OrderHallCommandBar.Background:SetTexture(LSM:Fetch("background", LolzenUIcfg.orderhallbar["ohb_background"]))
	OrderHallCommandBar.Background:SetVertexColor(unpack(LolzenUIcfg.orderhallbar["ohb_background_color"]))
	OrderHallCommandBar.Background:SetAlpha(LolzenUIcfg.orderhallbar["ohb_background_alpha"])

	OrderHallCommandBar.WorldMapButton:Hide()
	OrderHallCommandBar.CurrencyIcon:Hide()
	OrderHallCommandBar.CurrencyHitTest:Hide() -- the area which popups the order resource info tooltip
	OrderHallCommandBar.Currency:Hide()

	OrderHallCommandBar:RegisterEvent("CHAT_MSG_CURRENCY")
	OrderHallCommandBar:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	OrderHallCommandBar:RegisterEvent("PLAYER_STARTED_MOVING")
	OrderHallCommandBar:RegisterEvent("PLAYER_STOPPED_MOVING")
	OrderHallCommandBar:RegisterEvent("UNIT_FLAGS")
	OrderHallCommandBar:SetScript("OnEvent", function(self, event)
		if event == "CHAT_MSG_CURRENCY" or event == "CURRENCY_DISPLAY_UPDATE" then
			getCurrencies()
		elseif event == "PLAYER_STOPPED_MOVING" then
			timer:Stop()
		elseif event == "PLAYER_STARTED_MOVING" then
			timer:Play()
		elseif event == "UNIT_FLAGS" then
			if UnitOnTaxi("player") then
				timer:Play()
			else
				timer:Stop()
			end
		end
	end)

	local ohbframe = CreateFrame("Frame")
	ohbframe:SetAllPoints(OrderHallCommandBar.ClassIcon)
	ohbframe:EnableMouse(true)
	ohbframe:SetFrameStrata("HIGH")
	ohbframe:SetScript("OnMouseDown", GarrisonLandingPage_Toggle)

	--reposition BG display
	UIWidgetTopCenterContainerFrame:SetPoint("TOP", OrderHallCommandBar, "BOTTOM", 0, -10)

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
				getAreaText()
			end
		end
	end
end)

ns.setOHBVisibility = function()
	if LolzenUIcfg.orderhallbar["ohb_always_show"] == true then
		LoadAddOn("Blizzard_OrderHallUI")
		OrderHallCommandBar:Show()
		getAreaText()
		getCurrencies()
	else
		OrderHallCommandBar:Hide()
	end
end

ns.setOHBBGTexture = function()
	OrderHallCommandBar.Background:SetTexture(LSM:Fetch("background", LolzenUIcfg.orderhallbar["ohb_background"]))
end

ns.setOHBBGColor = function()
	OrderHallCommandBar.Background:SetVertexColor(unpack(LolzenUIcfg.orderhallbar["ohb_background_color"]))
	OrderHallCommandBar.Background:SetAlpha(LolzenUIcfg.orderhallbar["ohb_background_alpha"])
end

ns.setOHBBGAlpha = function()
	OrderHallCommandBar.Background:SetAlpha(LolzenUIcfg.orderhallbar["ohb_background_alpha"])
end

ns.setOHBZoneFontColor = function()
	OrderHallCommandBar.AreaName:SetTextColor(unpack(LolzenUIcfg.orderhallbar["ohb_zone_color"]))
end

ns.setOHBZoneFont = function()
	OrderHallCommandBar.AreaName:SetFont(LSM:Fetch("font", LolzenUIcfg.orderhallbar["ohb_zone_font"]), LolzenUIcfg.orderhallbar["ohb_zone_font_size"], LolzenUIcfg.orderhallbar["ohb_zone_font_flag"])
end

ns.setOHBCurrencyFont = function()
	for i=1, #currency do
		currency[i].text:SetFont(LSM:Fetch("font", LolzenUIcfg.orderhallbar["ohb_currency_font"]), LolzenUIcfg.orderhallbar["ohb_currency_font_size"], LolzenUIcfg.orderhallbar["ohb_currency_font_flag"])
	end
end

ns.setOHBCurrenyIconSize = function()
	for i=1, #currency do
		currency[i]:SetSize(LolzenUIcfg.orderhallbar["ohb_currency_icon_size"], LolzenUIcfg.orderhallbar["ohb_currency_icon_size"])
	end
end