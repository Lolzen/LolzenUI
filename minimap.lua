--[[		  MiniWini
]]--		  by Lolzen

function GetMinimapShape() return "ROUND" end

Minimap:SetPoint("TOPRIGHT", UIParent, -15, -15)

local MiniWini = CreateFrame("Frame", "MiniWini", Minimap)

local overlay = Minimap:CreateTexture(nil,"OVERLAY")
overlay:SetTexture("Interface\\AddOns\\LolzenUI\\media\\overlay")
overlay:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -1, 1)
overlay:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 1, -1)
overlay:SetWidth(177)
overlay:SetHeight(177)
overlay:SetVertexColor(0, 0, 0)

local frames = {
	MinimapZoomIn,
	MinimapZoomOut,
	MinimapToggleButton,
	MinimapBorderTop,
	MiniMapWorldMapButton,
	MinimapBorder,
	GameTimeFrame,
}

local event = function(self)
	MinimapZoneText:SetFont(STANDARD_TEXT_FONT, 12,"OUTLINE")
	MinimapZoneText:SetDrawLayer"OVERLAY"

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
	MiniMapMailFrame:SetPoint("TOPLEFT", 5, -5)
	MiniMapMailIcon:SetTexture("Interface/Minimap/Tracking/Mailbox")
	
	QueueStatusMinimapButtonBorder:Hide()
	QueueStatusMinimapButton:SetParent(Minimap)
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:SetPoint("TOPRIGHT", -5, -5)

	MinimapNorthTag:Hide()
	MinimapNorthTag:SetAlpha(0)
	
	-- As the InGame option for hiding is gone on the beta, let's hide it manually
	TimeManagerClockButton:Hide()
	
	Minimap:SetMaskTexture"Interface\\AddOns\\LolzenUI\\media\\Mask"

	self:ClearAllPoints()
	self:SetPoint("TOPLEFT", Minimap, -5, 4)

	self:SetWidth(149)
	self:SetHeight(149)

	self:SetFrameLevel(0)
	self:SetFrameStrata"BACKGROUND"

	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetPoint("LEFT", self, 12, 0)
	MinimapZoneTextButton:SetPoint("RIGHT", self, 2, 0)
	MinimapZoneTextButton:SetPoint("BOTTOM", self, 0, 0)
	
	-- let's make our own CalendarFrame =]
	local _, _, day, _ = CalendarGetDate()

	local CalFrame = CreateFrame("Button", "CalFrame", Minimap) 
	CalFrame:SetPoint("BOTTOMLEFT", Minimap, 15, 5)
	CalFrame:SetHeight(20)
	CalFrame:SetWidth(14)
	
	local CalFont =  CalFrame:CreateFontString(nil, "OVERLAY")
	CalFont:SetPoint("CENTER", CalFrame, "CENTER")
	CalFont:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE")
	CalFont:SetTextColor(1,1,1)
	CalFont:SetText(day)

	--Now we want to click the numbers to open the calendarframe, don't we?
	CalFrame:SetScript("OnClick", function()
		if not CalendarFrame then
			LoadAddOn("Blizzard_Calendar")
			ShowUIPanel(CalendarFrame)
		else
			ShowUIPanel(CalendarFrame)
		end
	end)

	local font, size, outline = MinimapZoneText:GetFont()
	MinimapZoneText:SetFont(font, 11, outline)

	for _, frame in pairs(frames) do
		frame:Hide()
	end
	frames = nil
end

MiniWini:RegisterEvent("PLAYER_LOGIN")
MiniWini:SetScript("OnEvent", event)