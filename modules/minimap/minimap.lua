--// minimap // --

local _, ns = ...
local L = ns.L

ns.RegisterModule("minimap", L["desc_minimap"], true)

local frames = {
	MinimapZoomIn,
	MinimapZoomOut,
	MinimapToggleButton,
	MinimapBorderTop,
	MiniMapWorldMapButton,
	MinimapBorder,
	GameTimeFrame,
}

local function setMiniMapShape()
	if LolzenUIcfg.minimap["minimap_square"] == true then
		if not Minimap.overlay then
			Minimap.overlay = Minimap:CreateTexture(nil, "OVERLAY")
			Minimap.overlay:SetVertexColor(0, 0, 0)
		end
		Minimap.overlay:SetTexture("Interface\\AddOns\\LolzenUI\\media\\overlay")
		Minimap.overlay:ClearAllPoints()
		Minimap.overlay:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -1, 1)
		Minimap.overlay:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 1, -1)
		Minimap.overlay:SetWidth(177)
		Minimap.overlay:SetHeight(177)

		Minimap:SetMaskTexture("Interface\\AddOns\\LolzenUI\\media\\Mask")

		MiniMapMailFrame:ClearAllPoints()
		MiniMapMailFrame:SetPoint("TOPLEFT", 5, -5)
		Minimap.CalFrame:ClearAllPoints()
		Minimap.CalFrame:SetPoint("BOTTOMLEFT", Minimap, 15, 5)
	else
		if not Minimap.overlay then
			Minimap.overlay = Minimap:CreateTexture(nil, "OVERLAY")
			Minimap.overlay:SetVertexColor(0, 0, 0)
		end
		Minimap.overlay:SetTexture("Interface\\Minimap\\UI-QuestBlob-MinimapRing")
		Minimap.overlay:ClearAllPoints()
		Minimap.overlay:SetAllPoints(Minimap)

		Minimap:SetMaskTexture(186178) -- Credits to Simpy, see https://git.tukui.org/elvui/elvui/-/commit/b0190888fc105225df7e29a46c12f19825977827

		MiniMapMailFrame:ClearAllPoints()
		MiniMapMailFrame:SetPoint("TOP", 0, -5)
		Minimap.CalFrame:ClearAllPoints()
		Minimap.CalFrame:SetPoint("BOTTOM", Minimap, 0, 5)
	end
end

local function setMiniMapPosition()
	Minimap:ClearAllPoints()
	Minimap:SetPoint(LolzenUIcfg.minimap["minimap_anchor"], OrderHallClassBar, LolzenUIcfg.minimap["minimap_posx"], LolzenUIcfg.minimap["minimap_posy"])
end

local function modifyMinimap()
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", function(self, z)
		local c = Minimap:GetZoom()
		if(z > 0 and c < 5) then
			Minimap:SetZoom(c + 1)
		elseif(z < 0 and c > 0) then
			Minimap:SetZoom(c - 1)
		end
	end)

	MiniMapTrackingButtonBorder:Hide()
	MiniMapTrackingBackground:Hide()
	MiniMapTracking:SetParent(Minimap)
	MiniMapTracking:ClearAllPoints()
	MiniMapTrackingIcon:SetTexCoord(0.065,0.935,0.065,0.935)
	MiniMapTracking:SetPoint("BOTTOMRIGHT", -5, 0)

	MiniMapMailBorder:Hide()
	MiniMapMailFrame:SetParent(Minimap)
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailIcon:SetTexture("Interface/Minimap/Tracking/Mailbox")

	QueueStatusMinimapButtonBorder:Hide()
	QueueStatusMinimapButton:SetParent(Minimap)
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:SetPoint("TOPRIGHT", -5, -5)
--	if LolzenUIcfg.minimap["minimap_square"] == false then
		QueueStatusMinimapButton:SetFrameStrata("HIGH")
--	end

	-- let's make our own CalendarFrame =]
	-- C_DateAndTime.GetCurrentCalendarTime() is unreliable on login and returns nil untin a /reload
	-- keep it here in case this changes tho
	--local date = C_Calendar.GetDate()
	local day = date("%d")
	if tonumber(day) < 10 then
		day = day:gsub("0","")
	end

	Minimap.CalFrame = CreateFrame("Button", "CalFrame", Minimap)
	Minimap.CalFrame:SetHeight(20)
	Minimap.CalFrame:SetWidth(14)

	local CalFont =  Minimap.CalFrame:CreateFontString(nil, "OVERLAY")
	CalFont:SetPoint("CENTER", Minimap.CalFrame, "CENTER")
	CalFont:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE")
	CalFont:SetTextColor(1,1,1)
	--CalFont:SetText(date.monthDay)
	CalFont:SetText(day)

	--Now we want to click the numbers to open the calendarframe, don't we?
	Minimap.CalFrame:SetScript("OnClick", function()
		if not CalendarFrame then
			LoadAddOn("Blizzard_Calendar")
			ShowUIPanel(CalendarFrame)
		else
			ShowUIPanel(CalendarFrame)
		end
	end)

	-- Clean up
	MinimapZoneText:Hide()

	MinimapNorthTag:Hide()
	MinimapNorthTag:SetAlpha(0)

	TimeManagerClockButton:Hide()

	GarrisonLandingPageMinimapButton:HookScript("OnShow", function() GarrisonLandingPageMinimapButton:Hide() end)
	GarrisonLandingPageMinimapButton.IsShown = function() return true end

	for _, frame in pairs(frames) do
		frame:Hide()
	end
	frames = nil
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, addon)
	if LolzenUIcfg.modules["minimap"] == false then Minimap:SetMaskTexture(186178); return end

	setMiniMapPosition()
	modifyMinimap()
	setMiniMapShape()

	ns.setMiniMapShape = function()
		setMiniMapShape()
	end

	ns.setMiniMapPosition = function()
		setMiniMapPosition()
	end
end)