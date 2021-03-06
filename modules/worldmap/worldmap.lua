﻿--// worldmap // --

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

		-- reposition the minMax button
		WorldMapFrame.BorderFrame.MaximizeMinimizeFrame.MaximizeButton:SetPoint("TOPRIGHT", WorldMapFrame.BorderFrame, "TOPRIGHT", -50, 5)
		WorldMapFrame.BorderFrame.MaximizeMinimizeFrame.MaximizeButton:SetPoint("TOPRIGHT", WorldMapFrame.BorderFrame, "TOPRIGHT", -18, 5)

		-- reposition the close button
		WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapFrame.BorderFrame, "TOPRIGHT", -30, 5)
		WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapFrame.BorderFrame, "TOPRIGHT", 4, 5)

		-- Stretch the TitleBg out
		WorldMapFrame.BorderFrame.TitleBg:SetPoint("TOPLEFT", WorldMapFrame, 3, -3)
		WorldMapFrame.BorderFrame.TitleBg:SetPoint("TOPRIGHT", WorldMapFrame, -3, -3)

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
		local frames = {
			WorldMapFrame,
			WorldMapFrame.ScollContainer,
		}

		for _, frame in pairs(frames) do
			frame:EnableMouse(true)
			frame:SetMovable(true)
			frame:SetUserPlaced(true)

			-- Script for moving the frame
			local registerClicks = function(self, button)
				frame:ClearAllPoints()
				frame:StartMoving()
			end
			frame:SetScript("OnMouseDown", registerClicks)

			frame:SetScript("OnMouseUp", function()
				frame:StopMovingOrSizing()
				if LolzenUIcfg.worldmap["worldmap_save_position"] == true then
					local anchor1, _, anchor2, x, y = WorldMapFrame:GetPoint()
					LolzenUIcfg.worldmap["worldmap_saved_position"] = {anchor1, UIParent, anchor2, x, y}
				end
			end)
		end

		-- Position and Scale
		hooksecurefunc(WorldMapFrame, "SynchronizeDisplayState", function()
			if not WorldMapFrame:IsMaximized() then
				WorldMapFrame:ClearAllPoints()
				if LolzenUIcfg.worldmap["worldmap_save_position"] == true then
					local anchor1, _, anchor2, x, y = unpack(LolzenUIcfg.worldmap["worldmap_saved_position"])
					WorldMapFrame:SetPoint(anchor1, UIParent, anchor2, x, y)
				else
					WorldMapFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 320/LolzenUIcfg.worldmap["worldmap_scale"])
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
			if not WorldMapFrame:IsVisible() then end
			int = int + 1
			if int >= 3 then
				local x, y = 0, 0

				x = math.floor(100 * x)
				y = math.floor(100 * y)

				local scale = WorldMapFrame.ScrollContainer:GetEffectiveScale()
				local width = WorldMapFrame.ScrollContainer:GetWidth()
				local height = WorldMapFrame.ScrollContainer:GetHeight()
				local centerX, centerY = WorldMapFrame.ScrollContainer:GetCenter()
				local x, y = GetCursorPosition()
				local adjustedX = (x / scale - (centerX - (width/2))) / width
				local adjustedY = (centerY + (height/2) - y / scale) / height

				if (adjustedX >= 0  and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1) then
					adjustedX = math.floor(100 * adjustedX)
					adjustedY = math.floor(100 * adjustedY)
					WorldMapFrameTitleText:SetText("Cursor Coordinates: "..adjustedX..", "..adjustedY)
				else
					WorldMapFrameTitleText:SetText(" ")
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

		local origtitle = WorldMapFrameTitleText:GetText()
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
