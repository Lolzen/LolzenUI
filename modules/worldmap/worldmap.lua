--// worldmap // --

local _, ns = ...
local L = ns.L

ns.RegisterModule("worldmap", L["desc_worldmap"], true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["worldmap"] == false then return end

		UIPanelWindows["WorldMapFrame"] = { area = nil, pushable = 0, xoffset = 0, yoffset = 0, whileDead = 1, minYOffset = 0, maximizePoint = "TOP" }
		tinsert(UISpecialFrames, "WorldMapFrame")

		WorldMapFrame.BorderFrame.NineSlice:Hide()
		WorldMapFramePortrait:SetAlpha(0)
		WorldMapFrame.BorderFrame.Tutorial:SetAlpha(0)
		WorldMapFrame.BorderFrame.Tutorial:EnableMouse(false)

		-- Change Text Color
		WorldMapFrameTitleText:SetTextColor(unpack(LolzenUIcfg.worldmap["worldmap_title_color"]))

		-- Stretch the TitleBg out
		WorldMapFrame.BorderFrame.TitleContainer:SetPoint("TOPLEFT", WorldMapFrame, 3, -3)
		WorldMapFrame.BorderFrame.TitleContainer:SetPoint("TOPRIGHT", WorldMapFrame, -23, -3)
		--WorldMapFrame.BorderFrame.TitleContainer:SetFrameStrata("MEDIUM")

			
		Mixin(WorldMapFrame.BorderFrame.TitleContainer, BackdropTemplateMixin)
		WorldMapFrame.BorderFrame.TitleContainer:SetBackdrop({
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground", tile = true, tileSize = 16,
		})
		WorldMapFrame.BorderFrame.TitleContainer:SetBackdropColor(0.1, 0.1, 0.1, 0.5)

		-- Cutsom border
		local border = CreateFrame("Frame", nil, nil, "BackdropTemplate")
		border:SetBackdrop({
			edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12,
			insets = {left = 4, right = 4, top = 4, bottom = 4},
		})
		border:SetParent(WorldMapFrame)
		border:SetPoint("TOPLEFT", WorldMapFrame, 0, 0)
		border:SetPoint("BOTTOMRIGHT", WorldMapFrame, 0, 0)
		border:SetBackdropBorderColor(0, 0, 0)
		border:SetFrameLevel(3)

		-- make the WorldMap movable
		WorldMapFrame.BorderFrame.TitleContainer:EnableMouse(true)
		WorldMapFrame.BorderFrame.TitleContainer:SetMovable(true)
		
		WorldMapFrame.BorderFrame.TitleContainer:SetScript("OnMouseDown", function(self, button)
			if button == "LeftButton" then
				WorldMapFrame:StartMoving()
			end
		end)
		
		WorldMapFrame.BorderFrame.TitleContainer:SetScript("OnMouseUp", function(self, button)
			if button == "LeftButton" then
				WorldMapFrame:StopMovingOrSizing()
				if LolzenUIcfg.worldmap["worldmap_save_position"] == true then
					local point, _, relativePoint, x, y = WorldMapFrame:GetPoint()
					if point and relativePoint and x and y then
						LolzenUIcfg.worldmap["worldmap_saved_position"] = {point, UIParent, relativePoint, x, y}
					end
				end
			end
		end)
		

		WorldMapFrame:SetMovable(true)
		WorldMapFrame:SetUserPlaced(true)

		-- Position and Scale
		hooksecurefunc(WorldMapFrame, "SynchronizeDisplayState", function()
			if not WorldMapFrame:IsMaximized() then
				WorldMapFrame:ClearAllPoints()
				if LolzenUIcfg.worldmap["worldmap_save_position"] == true then
					local savedPos = LolzenUIcfg.worldmap["worldmap_saved_position"]
					if savedPos[1] and savedPos[3] and savedPos[4] and savedPos[5] then
						WorldMapFrame:SetPoint(savedPos[1], UIParent, savedPos[3], savedPos[4], savedPos[5])
					else
						-- Fallback zu Standardposition wenn Daten ungültig
						WorldMapFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 320/LolzenUIcfg.worldmap["worldmap_scale"])
					end
				end
				WorldMapFrame:SetScale(LolzenUIcfg.worldmap["worldmap_scale"])
			end
		end)
		WorldMapFrame:SetClampedToScreen(true)

		-- Coordinates 
		-- original code from from https://github.com/liquidbase/DuffedUIv8/blob/master/DuffedUI/modules/maps/worldmap.lua
		local f = CreateFrame("Frame")
		local timer = f:CreateAnimationGroup()
		local timerAnim = timer:CreateAnimation()
		timerAnim:SetDuration(0.01)

		local int = 0
		timer:SetScript("OnFinished", function(self, requested)
			if not WorldMapFrame:IsVisible() then return end
			int = int + 1
			if int >= 3 then
				local scale = WorldMapFrame.ScrollContainer:GetEffectiveScale()
				local width = WorldMapFrame.ScrollContainer:GetWidth()
				local height = WorldMapFrame.ScrollContainer:GetHeight()
				local centerX, centerY = WorldMapFrame.ScrollContainer:GetCenter()
				
				-- Nil-Check für centerX und centerY
				if not centerX or not centerY or width == 0 or height == 0 then
					int = 0
					self:Play()
					return
				end
				
				local cursorX, cursorY = GetCursorPosition()
				local adjustedX = (cursorX / scale - (centerX - (width/2))) / width
				local adjustedY = (centerY + (height/2) - cursorY / scale) / height
		
				if (adjustedX >= 0 and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1) then
					adjustedX = math.floor(100 * adjustedX)
					adjustedY = math.floor(100 * adjustedY)
					WorldMapFrameTitleText:SetText("Cursor Coordinates: "..adjustedX..", "..adjustedY)
				else
					WorldMapFrameTitleText:SetText("Map & Questlog")
				end
				int = 0
			end
		
			self:Play()
		end)

		WorldMapFrame:HookScript("OnShow", function(self)
			if LolzenUIcfg.worldmap["worldmap_coordinates"] == true then
				timer:Play()
			end
		end)

		WorldMapFrame:HookScript("OnHide", function(self)
			if LolzenUIcfg.worldmap["worldmap_coordinates"] == true then
				timer:Stop()
			end
		end)

		ns.setWMTitleColor = function()
			WorldMapFrameTitleText:SetTextColor(unpack(LolzenUIcfg.worldmap["worldmap_title_color"]))
		end

		local origtitle = "Map & Questlog"
		ns.setWMCoordinates = function()
			if LolzenUIcfg.worldmap["worldmap_coordinates"] == true then
				if not timer:IsPlaying() then
					timer:Play()
				end
			else
				if timer:IsPlaying() then
					timer:Stop()
					WorldMapFrameTitleText:SetText(origtitle)
				end
			end
		end
	end
end)
