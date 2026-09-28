--// worldmap // --

local _, ns = ...
local L = ns.L

ns.RegisterModule("worldmap", L["desc_worldmap"], true)

local COORD_INTERVAL = 0.1

local cfg
local map
local originalTitle

--[[ position & scale ]]-------------------------------------------------------

-- the map frame is protected in combat, so it's only moved/scaled outside of it
local function applyPosition()
	if map:IsMaximized() then return end
	if cfg["worldmap_save_position"] then
		local pos = cfg["worldmap_saved_position"]
		map:ClearAllPoints()
		map:SetPoint(pos[1], UIParent, pos[2], pos[3], pos[4])
	end
	map:SetScale(cfg["worldmap_scale"])
end

local function requestPosition()
	ns.RunOutOfCombat(applyPosition)
end

local function onDragStart(_, button)
	if button ~= "LeftButton" or InCombatLockdown() or map:IsMaximized() then return end
	map:StartMoving()
end

local function onDragStop(_, button)
	if button ~= "LeftButton" then return end
	map:StopMovingOrSizing()
	if cfg["worldmap_save_position"] then
		local point, _, relativePoint, x, y = map:GetPoint()
		if point then
			cfg["worldmap_saved_position"] = {point, relativePoint, x, y}
		end
	end
end

--[[ coordinates ]]------------------------------------------------------------

local coordFrame = CreateFrame("Frame")
coordFrame:Hide()
coordFrame:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed < COORD_INTERVAL then return end
	self.elapsed = 0

	local container = map.ScrollContainer
	local left, top = container:GetLeft(), container:GetTop()
	local width, height = container:GetSize()
	if not left or width == 0 or height == 0 then return end

	local scale = container:GetEffectiveScale()
	local cursorX, cursorY = GetCursorPosition()
	local x = (cursorX / scale - left) / width
	local y = (top - cursorY / scale) / height
	if x >= 0 and y >= 0 and x <= 1 and y <= 1 then
		WorldMapFrameTitleText:SetFormattedText("%s: %d, %d", L["Cursor"], x * 100, y * 100)
	else
		WorldMapFrameTitleText:SetText(originalTitle)
	end
end)

local function updateCoordinates()
	local show = cfg["worldmap_coordinates"] and map:IsShown()
	if show and not coordFrame:IsShown() then
		originalTitle = WorldMapFrameTitleText:GetText()
	elseif not show and coordFrame:IsShown() and originalTitle then
		WorldMapFrameTitleText:SetText(originalTitle)
	end
	coordFrame:SetShown(show)
end

--[[ skin ]]-------------------------------------------------------------------

local function applyColors()
	WorldMapFrameTitleText:SetTextColor(ns.RGB(cfg["worldmap_title_color"]))
end

local function skin()
	local border = map.BorderFrame
	if border.NineSlice then
		border.NineSlice:Hide()
	end
	if WorldMapFramePortrait then
		WorldMapFramePortrait:SetAlpha(0)
	end
	if border.Tutorial then
		border.Tutorial:SetAlpha(0)
		border.Tutorial:EnableMouse(false)
	end

	local title = border.TitleContainer
	if title then
		title:SetPoint("TOPLEFT", map, 3, -3)
		title:SetPoint("TOPRIGHT", map, -23, -3)
		Mixin(title, BackdropTemplateMixin)
		title:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground", tile = true, tileSize = 16})
		title:SetBackdropColor(0.1, 0.1, 0.1, 0.5)

		-- drag the map by its title
		title:EnableMouse(true)
		title:HookScript("OnMouseDown", onDragStart)
		title:HookScript("OnMouseUp", onDragStop)
	end

	local frameBorder = CreateFrame("Frame", nil, map, "BackdropTemplate")
	frameBorder:SetBackdrop({edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12})
	frameBorder:SetAllPoints()
	frameBorder:SetBackdropBorderColor(0, 0, 0)
	frameBorder:SetFrameLevel(3)

	applyColors()
end

ns.setWMTitleColor = applyColors
ns.setWMCoordinates = updateCoordinates

ns.OnInit("worldmap", function()
	cfg = LolzenUIcfg.worldmap
	map = WorldMapFrame

	-- a normal window instead of a fullscreen panel, which can be closed with escape
	UIPanelWindows["WorldMapFrame"] = {area = nil, pushable = 0, xoffset = 0, yoffset = 0, whileDead = 1, minYOffset = 0, maximizePoint = "TOP"}
	tinsert(UISpecialFrames, "WorldMapFrame")

	skin()
	if not InCombatLockdown() then
		map:SetMovable(true)
		map:SetClampedToScreen(true)
	end

	hooksecurefunc(map, "SynchronizeDisplayState", requestPosition)
	map:HookScript("OnShow", updateCoordinates)
	map:HookScript("OnHide", updateCoordinates)

	local options = ns.Options.New("worldmap", function() return LolzenUIcfg.worldmap end, ns.defaults.worldmap, function()
		applyColors()
		updateCoordinates()
		requestPosition()
	end)
	options:Header(L["worldmap"])
	options:Range("worldmap_scale", L["wm_scale"], 0.5, 2, 0.05)
	options:Toggle("worldmap_save_position", L["save_worldmap_position"])
	options:Toggle("worldmap_coordinates", L["wm_coordinates"])
	options:Color("worldmap_title_color", L["wm_title_or_coordinates_color"])
	ns.SettingsPanel:AddCategory("worldmap", options)
end)
