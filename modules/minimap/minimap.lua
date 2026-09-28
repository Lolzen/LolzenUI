--// minimap // --
-- Position and size of the minimap are handled by the Edit Mode,
-- the options are attached to the minimap dialog in the Edit Mode.

local _, ns = ...
local L = ns.L

ns.RegisterModule("minimap", L["desc_minimap"], true)

local MASK_SQUARE = "Interface\\AddOns\\LolzenUI\\media\\Mask"
local MASK_ROUND = 186178 -- Interface\Masks\CircleMaskScalable

local cfg
local calendar

--[[ shape ]]------------------------------------------------------------------

local function applyShape()
	local square = cfg["minimap_square"]
	Minimap:SetMaskTexture(square and MASK_SQUARE or MASK_ROUND)

	if not Minimap.LolzenOverlay then
		Minimap.LolzenOverlay = Minimap:CreateTexture(nil, "OVERLAY")
		Minimap.LolzenOverlay:SetVertexColor(0, 0, 0)
	end
	local overlay = Minimap.LolzenOverlay
	overlay:ClearAllPoints()

	local useOutline = square and cfg["minimap_outline"]
	if useOutline then
		ns.Outline.Create(Minimap, {size = 22, padding = 3})
	end
	if Minimap.LolzenOutline then
		Minimap.LolzenOutline:SetShown(useOutline)
	end

	if square then
		overlay:SetTexture("Interface\\AddOns\\LolzenUI\\media\\overlay")
		overlay:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -1, 1)
		overlay:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 1, -1)
		overlay:SetShown(not useOutline)
	else
		overlay:SetTexture("Interface\\Minimap\\UI-QuestBlob-MinimapRing")
		overlay:SetAllPoints(Minimap)
		overlay:Show()
	end

	if MinimapCompassTexture then
		MinimapCompassTexture:SetAlpha(square and 0 or 1)
	end
	if calendar then
		calendar:ClearAllPoints()
		if square then
			calendar:SetPoint("BOTTOMLEFT", Minimap, 15, 5)
		else
			calendar:SetPoint("BOTTOM", Minimap, 0, 5)
		end
	end
end

-- used by LibDBIcon and other addons to place their minimap buttons
function GetMinimapShape()
	return (cfg and cfg["minimap_square"]) and "SQUARE" or "ROUND"
end

local function applyButtons()
	local hideZoom = cfg["minimap_hide_zoom"]
	for _, button in ipairs({Minimap.ZoomIn, Minimap.ZoomOut}) do
		button:SetAlpha(hideZoom and 0 or 1)
		button:EnableMouse(not hideZoom)
	end

	local hideClock = cfg["minimap_hide_clock"]
	for _, frame in ipairs({TimeManagerClockButton, GameTimeFrame}) do
		if frame then
			frame:SetAlpha(hideClock and 0 or 1)
			frame:EnableMouse(not hideClock)
		end
	end
end

--[[ calendar ]]---------------------------------------------------------------

-- the day of the month; clicking it opens the calendar
local function createCalendar()
	calendar = CreateFrame("Button", "LolzenUI_MinimapCalendar", Minimap)
	calendar:SetSize(14, 20)

	local text = calendar:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER")
	text:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")
	text:SetTextColor(1, 1, 1)

	local function update()
		text:SetText(tonumber(date("%d")))
		-- update again right after midnight
		local now = date("*t")
		local secondsLeft = 86400 - (now.hour * 3600 + now.min * 60 + now.sec)
		C_Timer.After(secondsLeft + 1, update)
	end
	update()

	calendar:SetScript("OnEnter", function() text:SetTextColor(1, 0.7, 0) end)
	calendar:SetScript("OnLeave", function() text:SetTextColor(1, 1, 1) end)
	calendar:SetScript("OnClick", function()
		if not CalendarFrame then
			C_AddOns.LoadAddOn("Blizzard_Calendar")
		end
		if CalendarFrame then
			ToggleFrame(CalendarFrame)
		end
	end)
end

--[[ setup ]]------------------------------------------------------------------

local function setup()
	if not Minimap:GetScript("OnMouseWheel") then
		Minimap:EnableMouseWheel(true)
		Minimap:SetScript("OnMouseWheel", function(self, delta)
			local zoom = self:GetZoom()
			if delta > 0 and zoom < self:GetZoomLevels() - 1 then
				self:SetZoom(zoom + 1)
			elseif delta < 0 and zoom > 0 then
				self:SetZoom(zoom - 1)
			end
		end)
	end

	if MinimapCluster.BorderTop then
		MinimapCluster.BorderTop:Hide()
	end
	if MinimapZoneText then
		MinimapZoneText:Hide()
	end
	if MiniMapMailIcon then
		MiniMapMailIcon:SetTexture("Interface\\Minimap\\Tracking\\Mailbox")
	end

	local tracking = MinimapCluster.Tracking
	if tracking then
		if tracking.Background then
			tracking.Background:Hide()
		end
		if tracking.Button then
			tracking.Button:SetScale(1.15)
			tracking.Button:ClearAllPoints()
			tracking.Button:SetPoint("TOPLEFT", Minimap, 7, -7)
		end
	end

	if AddonCompartmentFrame then
		AddonCompartmentFrame:ClearAllPoints()
		AddonCompartmentFrame:SetPoint("TOPRIGHT", Minimap, -7, -7)
	end

	-- the landing page is opened through the class icon of the info bar
	ns.Hide(ExpansionLandingPageMinimapButton)

	-- queue status in the bottom right corner of the minimap
	if QueueStatusButton then
		QueueStatusButton:SetScale(0.75)
		local moving
		local function moveQueueStatus()
			if moving then return end
			moving = true
			QueueStatusButton:ClearAllPoints()
			QueueStatusButton:SetPoint("BOTTOMRIGHT", Minimap, -7, 7)
			moving = false
		end
		moveQueueStatus()
		hooksecurefunc(QueueStatusButton, "SetPoint", moveQueueStatus)
	end

	createCalendar()
	applyButtons()
	applyShape()
end

ns.setMiniMapShape = function()
	applyShape()
	applyButtons()
end

ns.OnInit("minimap", function()
	cfg = LolzenUIcfg.minimap

	local options = ns.Options.New("minimap", function() return LolzenUIcfg.minimap end, ns.defaults.minimap, ns.setMiniMapShape)
	options:Header("LolzenUI")
	options:Toggle("minimap_square", L["mm_square"])
	options:Toggle("minimap_outline", L["Use outline"]):SetDisabled(function() return not cfg["minimap_square"] end)
	options:Toggle("minimap_hide_zoom", L["Hide the zoom buttons"])
	options:Toggle("minimap_hide_clock", L["Hide the clock"])
	if not ns.EditMode:AddSystemSettings("Minimap", options) then
		ns.SettingsPanel:AddCategory("minimap", options)
	end

	-- Blizzard may reset the mask when the layout changes
	ns.EditMode:RegisterCallback("layout", function()
		if calendar then
			applyShape()
		end
	end)
	ns.EditMode:RegisterCallback("exit", applyShape)
end)

ns.OnLogin("minimap", setup)
