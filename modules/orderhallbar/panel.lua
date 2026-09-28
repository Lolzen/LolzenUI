--// orderhallbar // --
-- An info bar: class icon (opens the expansion landing page), backpack currencies,
-- zone name and coordinates.

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("orderhallbar", L["desc_orderhallbar"], true)

local MAX_CURRENCIES = 3
local COORD_INTERVAL = 0.5

local cfg
local bar
local currencies = {}

--[[ zone & coordinates ]]-----------------------------------------------------

local function getCoordinates()
	local _, instanceType = IsInInstance()
	if instanceType == "party" or instanceType == "raid" then return "" end
	local mapID = C_Map.GetBestMapForUnit("player")
	local position = mapID and C_Map.GetPlayerMapPosition(mapID, "player")
	if not position then return "" end
	local x, y = position:GetXY()
	return (" [%.1f/%.1f]"):format(x * 100, y * 100)
end

local function updateArea()
	local zone = GetZoneText() or ""
	local subzone = GetSubZoneText() or ""
	if subzone == "" or subzone == zone then
		bar.AreaName:SetText(zone..getCoordinates())
	else
		bar.AreaName:SetText(("%s (%s)%s"):format(zone, subzone, getCoordinates()))
	end
end

local function onUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= COORD_INTERVAL then
		self.elapsed = 0
		updateArea()
	end
end

-- coordinates only change while moving, so only poll then
local function setMoving(moving)
	bar:SetScript("OnUpdate", moving and onUpdate or nil)
	updateArea()
end

--[[ currencies ]]-------------------------------------------------------------

local function currencyOnEnter(self)
	if not self.currencyID then return end
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:SetCurrencyByID(self.currencyID)
	GameTooltip:Show()
end

local function getCurrencyButton(index)
	local button = currencies[index]
	if button then return button end

	button = CreateFrame("Frame", nil, bar)
	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetAllPoints()
	button.icon:SetTexCoord(.04, .94, .04, .94)
	button.text = button:CreateFontString(nil, "OVERLAY")
	button.text:SetPoint("LEFT", button, "RIGHT", 5, 0)
	button.text:SetTextColor(1, 1, 1)
	button:SetScript("OnEnter", currencyOnEnter)
	button:SetScript("OnLeave", GameTooltip_Hide)
	if index == 1 then
		button:SetPoint("LEFT", bar.ClassIcon, "RIGHT", 10, 0)
	else
		button:SetPoint("LEFT", currencies[index - 1].text, "RIGHT", 10, 0)
	end
	currencies[index] = button
	return button
end

local function styleCurrency(button)
	local size = cfg["ohb_currency_icon_size"]
	button:SetSize(size, size)
	ns.SetFont(button.text, cfg["ohb_currency_font"], cfg["ohb_currency_font_size"], cfg["ohb_currency_font_flag"])
end

local function updateCurrencies()
	for i = 1, MAX_CURRENCIES do
		local info = C_CurrencyInfo.GetBackpackCurrencyInfo(i)
		if info then
			local button = getCurrencyButton(i)
			styleCurrency(button)
			button.currencyID = info.currencyTypesID
			button.icon:SetTexture(info.iconFileID)
			button.text:SetText(BreakUpLargeNumbers(info.quantity))
			button:Show()
		elseif currencies[i] then
			currencies[i].currencyID = nil
			currencies[i]:Hide()
		end
	end
end

--[[ bar ]]--------------------------------------------------------------------

local function toggleLandingPage()
	local button = ExpansionLandingPageMinimapButton
	if button and button.ToggleLandingPage then
		button:ToggleLandingPage()
	elseif ToggleExpansionLandingPage then
		ToggleExpansionLandingPage()
	end
end

local function applyStyle()
	bar:SetSize(UIParent:GetWidth(), cfg["ohb_height"])
	bar.Background:SetTexture(LSM:Fetch("background", cfg["ohb_background"]))
	bar.Background:SetVertexColor(ns.RGB(cfg["ohb_background_color"]))
	bar.Background:SetAlpha(cfg["ohb_background_alpha"])
	ns.SetFont(bar.AreaName, cfg["ohb_zone_font"], cfg["ohb_zone_font_size"], cfg["ohb_zone_font_flag"])
	bar.AreaName:SetTextColor(ns.RGB(cfg["ohb_zone_color"]))
	for _, button in ipairs(currencies) do
		styleCurrency(button)
	end
	bar:SetShown(cfg["ohb_always_show"] or ns.EditMode:IsActive())
end

local function createBar()
	bar = CreateFrame("Frame", "LolzenUI_InfoBar", UIParent)
	bar:SetFrameStrata("LOW")
	bar:SetFrameLevel(10)

	bar.Background = bar:CreateTexture(nil, "BACKGROUND")
	bar.Background:SetAllPoints()

	local _, class = UnitClass("player")
	bar.ClassIcon = bar:CreateTexture(nil, "ARTWORK")
	bar.ClassIcon:SetSize(48, 48)
	bar.ClassIcon:SetPoint("LEFT", bar, "LEFT", 10, 0)
	bar.ClassIcon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
	bar.ClassIcon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]))
	bar.ClassIcon:SetAlpha(0.5)

	local iconButton = CreateFrame("Button", nil, bar)
	iconButton:SetAllPoints(bar.ClassIcon)
	iconButton:SetScript("OnClick", toggleLandingPage)

	bar.AreaName = bar:CreateFontString(nil, "OVERLAY")
	bar.AreaName:SetPoint("CENTER")

	applyStyle()
end

ns.setOHBVisibility = applyStyle
ns.setOHBBGTexture = applyStyle
ns.setOHBBGColor = applyStyle
ns.setOHBZoneFont = applyStyle
ns.setOHBCurrencyFont = applyStyle

ns.OnInit("orderhallbar", function()
	cfg = LolzenUIcfg.orderhallbar
	createBar()

	local options = ns.Options.New("orderhallbar", function() return LolzenUIcfg.orderhallbar end, ns.defaults.orderhallbar, applyStyle)
	options:Header(L["background"])
	options:Toggle("ohb_always_show", L["ohb_always_show"])
	options:Range("ohb_height", L["height"], 10, 60, 1)
	options:Media("ohb_background", L["texture"], "background")
	options:Color("ohb_background_color", L["color"])
	options:Range("ohb_background_alpha", L["alpha"], 0, 1, 0.05)
	options:Header(L["ohb_zonetext_header"])
	options:FontGroup("ohb_zone_font")
	options:Color("ohb_zone_color", L["color"])
	options:Header(L["ohb_currency_header"])
	options:Range("ohb_currency_icon_size", L["ohb_icon_size"], 8, 48, 1)
	options:FontGroup("ohb_currency_font")

	ns.EditMode:AddFrame(bar, {
		name = L["LolzenUI: Info Bar"],
		pos = {
			db = function() return LolzenUIcfg.orderhallbar end,
			point = "ohb_anchor",
			x = "ohb_posx",
			y = "ohb_posy",
		},
		defaults = ns.defaults.orderhallbar,
		options = options,
	})
	ns.EditMode:RegisterCallback("enter", applyStyle)
	ns.EditMode:RegisterCallback("exit", applyStyle)

	local events = CreateFrame("Frame")
	for _, event in ipairs({
		"PLAYER_ENTERING_WORLD", "ZONE_CHANGED", "ZONE_CHANGED_INDOORS", "ZONE_CHANGED_NEW_AREA",
		"PLAYER_STARTED_MOVING", "PLAYER_STOPPED_MOVING", "PLAYER_CONTROL_LOST", "PLAYER_CONTROL_GAINED",
		"CURRENCY_DISPLAY_UPDATE", "UI_SCALE_CHANGED", "DISPLAY_SIZE_CHANGED",
	}) do
		events:RegisterEvent(event)
	end
	events:SetScript("OnEvent", function(_, event)
		if event == "PLAYER_STARTED_MOVING" then
			setMoving(true)
		elseif event == "PLAYER_CONTROL_LOST" then
			-- taxis
			setMoving(UnitOnTaxi("player"))
		elseif event == "PLAYER_STOPPED_MOVING" or event == "PLAYER_CONTROL_GAINED" then
			setMoving(false)
		elseif event == "CURRENCY_DISPLAY_UPDATE" then
			updateCurrencies()
		elseif event == "UI_SCALE_CHANGED" or event == "DISPLAY_SIZE_CHANGED" then
			applyStyle()
		else
			updateArea()
			if event == "PLAYER_ENTERING_WORLD" then
				updateCurrencies()
			end
		end
	end)
end)

ns.OnLogin("orderhallbar", function()
	-- the default top widgets (e.g. battleground scores) go below the bar
	if UIWidgetTopCenterContainerFrame and cfg["ohb_anchor"] == "TOP" then
		UIWidgetTopCenterContainerFrame:SetPoint("TOP", bar, "BOTTOM", 0, -10)
	end
end)
