--// orderhallbar // --

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("orderhallbar", L["desc_orderhallbar"], true)

-- Erstelle Ersatz für OrderHallCommandBar
local OrderHallCommandBar = CreateFrame("Frame", "LolzenUI_OrderHallBar", UIParent)
OrderHallCommandBar:SetSize(GetScreenWidth() * 1.41, 24)
OrderHallCommandBar:SetPoint("TOP", UIParent, "TOP", 0, 0)
OrderHallCommandBar:SetFrameStrata("LOW")
OrderHallCommandBar:SetFrameLevel(10)
OrderHallCommandBar:SetClipsChildren(true)

-- Background
OrderHallCommandBar.Background = OrderHallCommandBar:CreateTexture(nil, "BACKGROUND")
OrderHallCommandBar.Background:SetAllPoints()

-- Class Icon
OrderHallCommandBar.ClassIcon = OrderHallCommandBar:CreateTexture(nil, "ARTWORK")
OrderHallCommandBar.ClassIcon:SetSize(48, 48)
OrderHallCommandBar.ClassIcon:SetPoint("LEFT", OrderHallCommandBar, "LEFT", 10, 0)
local _, class = UnitClass("player")
OrderHallCommandBar.ClassIcon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
OrderHallCommandBar.ClassIcon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]))
OrderHallCommandBar.ClassIcon:SetAlpha(0.5)

-- Area Name
OrderHallCommandBar.AreaName = OrderHallCommandBar:CreateFontString(nil, "OVERLAY")
OrderHallCommandBar.AreaName:SetPoint("CENTER", OrderHallCommandBar, "CENTER", 0, 0)

local MapRects = {}
local TempVec2D = CreateVector2D(0, 0)
function getCoordinates()
	local inInstance, instanceType = IsInInstance()
	if inInstance and (instanceType == "party" or instanceType == "raid") then
		return ""
	else
		local MapID = C_Map.GetBestMapForUnit("player")
		if MapID then
			local position = C_Map.GetPlayerMapPosition(MapID, "player")
			if position then
				local x, y = position:GetXY()
				return format(" [%.1f/%.1f]", x*100, y*100)
			end
		end
		return ""
	end
end

local function getAreaText()
	if not OrderHallCommandBar then return end  -- ADD THIS CHECK
	
	local mapInfo = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player"))
	if not mapInfo then return end
	
	local zoneName = mapInfo.name or ""
	local subzoneName = GetSubZoneText() or ""
	
	if subzoneName == "" or subzoneName == zoneName then
		OrderHallCommandBar.AreaName:SetText(zoneName..getCoordinates())
	else
		OrderHallCommandBar.AreaName:SetText(zoneName.." ("..subzoneName..")"..getCoordinates())
	end
end

local currency = {}
local function getCurrencies()
	if not OrderHallCommandBar then return end
	for i=1, 3 do
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
	for i=1, C_CurrencyInfo.GetCurrencyListSize() do
		if C_CurrencyInfo.GetCurrencyListInfo(i).isShowInBackpack then
			local link = C_CurrencyInfo.GetCurrencyListLink(i)
			local id = tonumber(strmatch(link, "currency:(%d+)"))
			if currency[counter] then
				currency[counter]:SetTexture(C_CurrencyInfo.GetCurrencyListInfo(i).iconFileID)
				currency[counter].text:SetText(C_CurrencyInfo.GetCurrencyListInfo(i).quantity)
				if not currency[counter].name then
					currency[counter].name = C_CurrencyInfo.GetCurrencyListInfo(i).name
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
--hooksecurefunc("TokenFrame_Update", getCurrencies)


-- Hook into currency updates
local currencyUpdateFrame = CreateFrame("Frame")
currencyUpdateFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
currencyUpdateFrame:SetScript("OnEvent", function()
--	if OrderHallCommandBar then  -- ADD THIS CHECK
		getCurrencies()
--	end
end)

local function modifyOHB()
	if not OrderHallCommandBar then return end  -- ADD THIS CHECK
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

--	OrderHallCommandBar.WorldMapButton:Hide()
--	OrderHallCommandBar.CurrencyIcon:Hide()
--	OrderHallCommandBar.CurrencyHitTest:Hide()
--	OrderHallCommandBar.Currency:Hide()

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

	local covenantID = C_Covenants.GetActiveCovenantID()
	local ohbframe = CreateFrame("Frame")
	ohbframe:SetAllPoints(OrderHallCommandBar.ClassIcon)
	ohbframe:EnableMouse(true)
	ohbframe:SetFrameStrata("HIGH")
	if covenantID and covenantID ~= 0 then
		ohbframe:SetScript("OnMouseDown", function()
			if ExpansionLandingPage and ExpansionLandingPage.ToggleLandingPage then
				ExpansionLandingPage.ToggleLandingPage()
			end
		end)
	end

	--reposition BG display
	if UIWidgetTopCenterContainerFrame then  -- ADD THIS CHECK
		UIWidgetTopCenterContainerFrame:SetPoint("TOP", OrderHallCommandBar, "BOTTOM", 0, -10)
	end

	OrderHallCommandBar.modded = true

	hooksecurefunc(OrderHallCommandBar, "Hide", function(self)
		if LolzenUIcfg.orderhallbar["ohb_always_show"] == true then
			self:Show()
		end
	end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("CINEMATIC_STOP")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("COVENANT_CHOSEN")
f:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "LolzenUI" then
			if LolzenUIcfg.modules["orderhallbar"] == false then return end
--[[
			local OrderHallClassBar = CreateFrame("Frame", "OrderHallClassBar", UIParent)
			OrderHallClassBar:SetSize(UIParent:GetWidth(), 30)
			OrderHallClassBar:SetPoint("TOP", UIParent, "TOP", 0, 0)
			OrderHallClassBar:SetFrameStrata("LOW")
				
			-- Background
			OrderHallClassBar.Background = OrderHallClassBar:CreateTexture(nil, "BACKGROUND")
			OrderHallClassBar.Background:SetAllPoints()
			OrderHallClassBar.Background:SetTexture(LSM:Fetch("background", LolzenUIcfg.orderhallbar["ohb_background"]))
			OrderHallClassBar.Background:SetVertexColor(unpack(LolzenUIcfg.orderhallbar["ohb_background_color"]))
			OrderHallClassBar.Background:SetAlpha(LolzenUIcfg.orderhallbar["ohb_background_alpha"])

				
			-- Class Icon
			OrderHallClassBar.ClassIcon = OrderHallClassBar:CreateTexture(nil, "ARTWORK")
			OrderHallClassBar.ClassIcon:SetSize(24, 24)
			OrderHallClassBar.ClassIcon:SetPoint("LEFT", OrderHallClassBar, "LEFT", 10, 0)
			local _, class = UnitClass("player")
			OrderHallClassBar.ClassIcon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
			OrderHallClassBar.ClassIcon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]))
				
				-- Area Name
			OrderHallClassBar.AreaName = OrderHallClassBar:CreateFontString(nil, "OVERLAY")
			OrderHallClassBar.AreaName:SetPoint("CENTER", OrderHallClassBar, "CENTER", 0, 0)
]]
			modifyOHB()
			getCurrencies()  -- Initialize currencies after loading
		end
	elseif event == "CINEMATIC_STOP" or event == "PLAYER_ENTERING_WORLD" then
		getAreaText()
		modifyOHB()
	elseif event == "COVENANT_CHOSEN" then
		modifyOHB()
	end
end)

ns.setOHBVisibility = function()
	if LolzenUIcfg.orderhallbar["ohb_always_show"] == true then
		C_AddOns.LoadAddOn("Blizzard_OrderHallUI")
		if OrderHallCommandBar then  -- ADD THIS CHECK
			OrderHallCommandBar:Show()
			getAreaText()
			getCurrencies()
		end
	else
		if OrderHallCommandBar then  -- ADD THIS CHECK
			OrderHallCommandBar:Hide()
		end
	end
end

ns.setOHBBGTexture = function()
	if not OrderHallCommandBar then return end  -- ADD THIS CHECK
	OrderHallCommandBar.Background:SetTexture(LSM:Fetch("background", LolzenUIcfg.orderhallbar["ohb_background"]))
end

ns.setOHBBGColor = function()
	if not OrderHallCommandBar then return end  -- ADD THIS CHECK
	OrderHallCommandBar.Background:SetVertexColor(unpack(LolzenUIcfg.orderhallbar["ohb_background_color"]))
	OrderHallCommandBar.Background:SetAlpha(LolzenUIcfg.orderhallbar["ohb_background_alpha"])
end

ns.setOHBBGAlpha = function()
	if not OrderHallCommandBar then return end  -- ADD THIS CHECK
	OrderHallCommandBar.Background:SetAlpha(LolzenUIcfg.orderhallbar["ohb_background_alpha"])
end

ns.setOHBZoneFontColor = function()
	if not OrderHallCommandBar then return end  -- ADD THIS CHECK
	OrderHallCommandBar.AreaName:SetTextColor(unpack(LolzenUIcfg.orderhallbar["ohb_zone_color"]))
end

ns.setOHBZoneFont = function()
	if not OrderHallCommandBar then return end  -- ADD THIS CHECK
	OrderHallCommandBar.AreaName:SetFont(LSM:Fetch("font", LolzenUIcfg.orderhallbar["ohb_zone_font"]), LolzenUIcfg.orderhallbar["ohb_zone_font_size"], LolzenUIcfg.orderhallbar["ohb_zone_font_flag"])
end

ns.setOHBCurrencyFont = function()
	if not OrderHallCommandBar then return end  -- ADD THIS CHECK
	for i=1, #currency do
		if currency[i] and currency[i].text then
			currency[i].text:SetFont(LSM:Fetch("font", LolzenUIcfg.orderhallbar["ohb_currency_font"]), LolzenUIcfg.orderhallbar["ohb_currency_font_size"], LolzenUIcfg.orderhallbar["ohb_currency_font_flag"])
		end
	end
end

ns.setOHBCurrenyIconSize = function()
	if not OrderHallCommandBar then return end  -- ADD THIS CHECK
	for i=1, #currency do
		if currency[i] then
			currency[i]:SetSize(LolzenUIcfg.orderhallbar["ohb_currency_icon_size"], LolzenUIcfg.orderhallbar["ohb_currency_icon_size"])
		end
	end
end