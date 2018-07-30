--// minimap // --

local _, ns = ...

ns.RegisterModule("minimap", true)

local frames = {
	MinimapZoomIn,
	MinimapZoomOut,
	MinimapToggleButton,
	MinimapBorderTop,
	MiniMapWorldMapButton,
	MinimapBorder,
	GameTimeFrame,
}

local function modifyMinimap()
	Minimap:SetPoint("TOPRIGHT", OrderHallClassBar, -15, -40)

	if LolzenUIcfg.minimap["minimap_square"] == true then
		local overlay = Minimap:CreateTexture(nil,"OVERLAY")
		overlay:SetTexture("Interface\\AddOns\\LolzenUI\\media\\overlay")
		overlay:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -1, 1)
		overlay:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 1, -1)
		overlay:SetWidth(177)
		overlay:SetHeight(177)
		overlay:SetVertexColor(0, 0, 0)

		Minimap:SetMaskTexture("Interface\\AddOns\\LolzenUI\\media\\Mask")
	else
		Minimap:SetMaskTexture("Textures\\MinimapMask")
		local circle = Minimap:CreateTexture(nil,"OVERLAY")
		circle:SetAllPoints(Minimap)
		circle:SetTexture("Interface\\Minimap\\UI-QuestBlob-MinimapRing")
		circle:SetVertexColor(0, 0, 0)
	end

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
	if LolzenUIcfg.minimap["minimap_square"] == true then
		MiniMapTracking:SetPoint("BOTTOMRIGHT", -5, 0)
	else
		MiniMapTracking:SetPoint("BOTTOMRIGHT", -5, 0)
	end

	MiniMapMailBorder:Hide()
	MiniMapMailFrame:SetParent(Minimap)
	MiniMapMailFrame:ClearAllPoints()
	if LolzenUIcfg.minimap["minimap_square"] == true then
		MiniMapMailFrame:SetPoint("TOPLEFT", 5, -5)
	else
		MiniMapMailFrame:SetPoint("TOP", 0, -5)
	end
	MiniMapMailIcon:SetTexture("Interface/Minimap/Tracking/Mailbox")

	QueueStatusMinimapButtonBorder:Hide()
	QueueStatusMinimapButton:SetParent(Minimap)
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:SetPoint("TOPRIGHT", -5, -5)
	if LolzenUIcfg.minimap["minimap_square"] == false then
		QueueStatusMinimapButton:SetFrameStrata("HIGH")
	end

	-- let's make our own CalendarFrame =]
	local date = C_Calendar.GetDate()

	local CalFrame = CreateFrame("Button", "CalFrame", Minimap)
	if LolzenUIcfg.minimap["minimap_square"] == true then
		CalFrame:SetPoint("BOTTOMLEFT", Minimap, 15, 5)
	else
		CalFrame:SetPoint("BOTTOM", Minimap, 0, 5)
	end
	CalFrame:SetHeight(20)
	CalFrame:SetWidth(14)

	local CalFont =  CalFrame:CreateFontString(nil, "OVERLAY")
	CalFont:SetPoint("CENTER", CalFrame, "CENTER")
	CalFont:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE")
	CalFont:SetTextColor(1,1,1)
	CalFont:SetText(date.monthDay)

	--Now we want to click the numbers to open the calendarframe, don't we?
	CalFrame:SetScript("OnClick", function()
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
	if LolzenUIcfg.modules["minimap"] == false then Minimap:SetMaskTexture("Textures\\MinimapMask"); return end

	modifyMinimap()
end)