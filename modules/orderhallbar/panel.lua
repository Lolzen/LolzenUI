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
	--OrderHallCommandBar.AreaName:SetText(GetZoneText())
	if GetRealZoneText() == GetMinimapZoneText() then
		OrderHallCommandBar.AreaName:SetText(GetZoneText()..getCoordinates())
	else
		OrderHallCommandBar.AreaName:SetText(GetZoneText().." ("..GetMinimapZoneText()..")"..getCoordinates())
	end
end

local function createOrderHallBar()
	local OrderHallCommandBar = CreateFrame("Frame", nil, UIParent)
	OrderHallCommandBar:SetPoint("TOP", 0, 0)
	OrderHallCommandBar:SetWidth(GetScreenWidth())
	OrderHallCommandBar:SetHeight(25)

--	print("test")
	--local bg = OrderHallCommandBar:CreateTexture(nil, "BACKGROUND")
--	bg:SetAllPoints(OrderHallCommandBar)
--	bg:SetTexture(LSM:Fetch("background", LolzenUIcfg.orderhallbar["ohb_background"]))
--	bg:SetVertexColor(unpack(LolzenUIcfg.orderhallbar["ohb_background_color"]))
--	bg:SetAlpha(LolzenUIcfg.orderhallbar["ohb_background_alpha"])
--	bg:SetAllPoints(OrderHallCommandBar)

	OrderHallCommandBar.Background = OrderHallCommandBar:CreateTexture(nil, "BACKGROUND")
	OrderHallCommandBar.Background:SetAllPoints(OrderHallCommandBar)
--	OrderHallCommandBar.Background:SetTexture(LSM:Fetch("background", LolzenUIcfg.orderhallbar["ohb_background"]))
	OrderHallCommandBar.Background:SetTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
	OrderHallCommandBar.Background:SetVertexColor(0, 0, 0)
	OrderHallCommandBar.Background:SetAlpha(0.5)
	
	local _, class = UnitClass("player")
	OrderHallCommandBar.ClassIcon = OrderHallCommandBar:CreateTexture(nil, "OVERLAY")
	OrderHallCommandBar.ClassIcon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
	local x1, x2, y1, y2 = unpack(CLASS_ICON_TCOORDS[strupper(class)])
	local height = y2 - y1
	y1 = y1 + 0.25 * height
	y2 = y2 - 0.25 * height
	OrderHallCommandBar.ClassIcon:SetTexCoord(x1, x2, y1, y2)
	OrderHallCommandBar.ClassIcon:SetPoint("LEFT", OrderHallCommandBar, 0, 0)
	OrderHallCommandBar.ClassIcon:SetSize(46, 23)
	OrderHallCommandBar.ClassIcon:SetBlendMode("ADD")
	OrderHallCommandBar.ClassIcon:SetAlpha(0.55)

	
	OrderHallCommandBar.AreaName = OrderHallCommandBar:CreateFontString(nil, "OVERLAY")
	OrderHallCommandBar.AreaName:SetTextColor(51/255, 181/255, 229/255)
	OrderHallCommandBar.AreaName:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12, "THINOUTLINE")
--	OrderHallCommandBar.AreaName:SetTextColor(unpack(LolzenUIcfg.orderhallbar["ohb_zone_color"]))
--	OrderHallCommandBar.AreaName:SetFont(LSM:Fetch("font", LolzenUIcfg.orderhallbar["ohb_zone_font"]), LolzenUIcfg.orderhallbar["ohb_zone_font_size"], LolzenUIcfg.orderhallbar["ohb_zone_font_flag"])
	OrderHallCommandBar.AreaName:SetPoint("CENTER", OrderHallCommandBar, 0, 0)
	if GetRealZoneText() == GetMinimapZoneText() then
		OrderHallCommandBar.AreaName:SetText(GetZoneText()..getCoordinates())
	else
		OrderHallCommandBar.AreaName:SetText(GetZoneText().." ("..GetMinimapZoneText()..")"..getCoordinates())
	end
	
	-- frame creation code here
OrderHallCommandBar.elapsed = 0.125 -- run the update code 8 times per second
OrderHallCommandBar:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = self.elapsed - elapsed
	if self.elapsed > 0 then return end
	self.elapsed = 0.125
	if GetRealZoneText() == GetMinimapZoneText() then
		OrderHallCommandBar.AreaName:SetText(GetZoneText()..getCoordinates())
	else
		OrderHallCommandBar.AreaName:SetText(GetZoneText().." ("..GetMinimapZoneText()..")"..getCoordinates())
	end
	-- rest of the code here
end)	
end
--createOrderHallBar()
--[[
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
]]
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
--f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "LolzenUI" then
			if LolzenUIcfg.modules["orderhallbar"] == false then return end

			createOrderHallBar()
		end
	end
end)