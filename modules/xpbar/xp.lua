--// xpbar // --

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("xpbar", L["desc_xpbar"], true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["xpbar"] == false then return end

		-- Change the rep colors slightly
		local FACTION_BAR_COLORS_LOCAL = {
			[1] = {r = 0.8, g = 0.3, b = 0.22},
			[2] = {r = 0.8, g = 0.3, b = 0.22},
			[3] = {r = 0.75, g = 0.27, b = 0},
			[4] = {r = 0.9, g = 0.7, b = 0},
			[5] = {r = 0, g = 0.6, b = 0.1},
			[6] = {r = 0, g = 0.6, b = 0.1},
			[7] = {r = 0, g = 0.6, b = 0.1},
			[8] = {r = 0, g = 0.6, b = 0.1},
		}

		-- first let us create our bar
		local xpbar = CreateFrame("StatusBar", "bar4xpbar", UIParent)
		xpbar:SetPoint(LolzenUIcfg.xpbar["xpbar_anchor"], LolzenUIcfg.xpbar["xpbar_parent"], LolzenUIcfg.xpbar["xpbar_posx"], LolzenUIcfg.xpbar["xpbar_posy"])
		xpbar:SetHeight(LolzenUIcfg.xpbar["xpbar_height"])
		xpbar:SetWidth(LolzenUIcfg.xpbar["xpbar_width"])
		xpbar:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.xpbar["xpbar_texture"]))
		xpbar:SetAlpha(LolzenUIcfg.xpbar["xpbar_alpha"])
		xpbar:SetFrameStrata("BACKGROUND")

		-- Background for our bar
		local bg = xpbar:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(xpbar)
		bg:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.xpbar["xpbar_texture"])
		bg:SetVertexColor(0, 0, 0, LolzenUIcfg.xpbar["xpbar_bg_alpha"])

		--1px "border"
		local lines = {}
		function ns.setXPBarBorder()
			if LolzenUIcfg.xpbar["xpbar_1px_border"] == true then
				for i = 1, 4 do
					if not lines[i] then
						lines[i] = xpbar:CreateTexture(nil, "OVERLAY")
						lines[i]:SetTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
						lines[i]:SetVertexColor(0, 0, 0, 1)
					end
					if i == 1 then
						lines[i]:SetHeight(1)
						lines[i]:SetPoint("TOPLEFT", xpbar, 0, 1)
						lines[i]:SetPoint("TOPRIGHT", xpbar, 0, 1)
					elseif i == 2 then
						lines[i]:SetHeight(1)
						lines[i]:SetPoint("BOTTOMLEFT", xpbar, 0, -1)
						lines[i]:SetPoint("BOTTOMRIGHT", xpbar, 0, -1)
					elseif i == 3 then
						lines[i]:SetWidth(1)
						if LolzenUIcfg.xpbar["xpbar_1px_border_round"] == true then
							lines[i]:SetPoint("TOPLEFT", xpbar, -1, 0)
							lines[i]:SetPoint("BOTTOMLEFT", xpbar, -1, 0)
						else
							lines[i]:SetPoint("TOPLEFT", xpbar, 0, 0)
							lines[i]:SetPoint("BOTTOMLEFT", xpbar, 0, 0)
						end
					elseif i == 4 then
						lines[i]:SetWidth(1)
						if LolzenUIcfg.xpbar["xpbar_1px_border_round"] == true then
							lines[i]:SetPoint("TOPRIGHT", xpbar, 1, 0)
							lines[i]:SetPoint("BOTTOMRIGHT", xpbar, 1, 0)
						else
							lines[i]:SetPoint("TOPRIGHT", xpbar, 0, 0)
							lines[i]:SetPoint("BOTTOMRIGHT", xpbar, 0, 0)
						end
					end
					lines[i]:SetAlpha(1)
				end
			else
				for i = 1, 4 do
					if lines[i] then
						lines[i]:SetAlpha(0)
					end
				end
			end
		end
		-- call this function on login/reload
		ns.setXPBarBorder()

		-- fontstring
		local xptext = xpbar:CreateFontString(nil, "OVERLAY")
		xptext:SetPoint(LolzenUIcfg.xpbar["xpbar_text_anchor1"], xpbar, LolzenUIcfg.xpbar["xpbar_text_posx"], LolzenUIcfg.xpbar["xpbar_text_posy"])
		xptext:SetParent(UIParent)
		xptext:SetFont(LSM:Fetch("font", LolzenUIcfg.xpbar["xpbar_font"]), LolzenUIcfg.xpbar["xpbar_font_size"], LolzenUIcfg.xpbar["xpbar_font_flag"])
		xptext:SetTextColor(unpack(LolzenUIcfg.xpbar["xpbar_font_color"]))

		function ns.setXPBarTextVisible()
			if LolzenUIcfg.xpbar["xpbar_mouseover_text"] == true then
				xptext:Hide()
				xpbar:SetScript("OnEnter", function(self)
					xptext:Show()
				end)
				xpbar:SetScript("OnLeave", function(self)
					xptext:Hide()
				end)
			else
				xptext:Show()
				xpbar:SetScript("OnEnter", function(self)
					return
				end)
				xpbar:SetScript("OnLeave", function(self)
					return
				end)
			end
		end
		-- call this function on login/reload
		ns.setXPBarTextVisible()

		function xpbar:Update()
			-- Proprity #1: If in BGs show the HonorXP
			-- Priority #2: Show REP when ticked on
			-- Priority #3: Show XP
			if select(2,IsInInstance()) == "pvp" or select(2,IsInInstance()) == "arena" then
				local level = UnitHonorLevel("player")
				local current = UnitHonor("player")
				local max = UnitHonorMax("player")
				xpbar:SetMinMaxValues(0, max)
				xpbar:SetValue(current)
				xpbar:SetStatusBarColor(unpack(LolzenUIcfg.xpbar["xpbar_pvp_color"]))
				xptext:SetFormattedText("%s (%.0f%%)", "[L:"..level.."] "..current.."/"..max, current/max*100)
			elseif GetWatchedFactionInfo() ~= nil then
				-- Reputation (including Paragon)
				for i = 1, GetNumFactions() do
					local paraName, _, _, _, _, _, _, _, _, _, _, isWatched, _, factionID = GetFactionInfo(i)
					if isWatched and factionID then
						if C_Reputation.IsFactionParagon(factionID) then
							local currentValue, threshold, rewardQuestID, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
							local value = mod(currentValue, threshold)
							if paraRewardPending then
								value = value + threshold
							end
							xpbar:SetMinMaxValues(0, threshold)
							xpbar:SetValue(value)
							xpbar:SetStatusBarColor(unpack(LolzenUIcfg.xpbar["xpbar_paragon_color"]))
							xptext:SetText("("..paraName..") "..value.." / "..threshold)
						else
							local name, standing, min, max, value = GetWatchedFactionInfo()
							max, min = (max-min), (value-min)
							if LolzenUIcfg.modules["miscellaneous"] == true and LolzenUIcfg.miscellaneous["misc_alternative_faction_colors"] == true then
								local color = LolzenUIcfg.miscellaneous["misc_faction_colors"][standing]
								xpbar:SetStatusBarColor(unpack(color))
							else
								local baseColor = FACTION_BAR_COLORS_LOCAL[standing]
								local color = {}
								for key, value in pairs(baseColor) do 
									color[key] = math.min(1, value * 1.25)
								end
								xpbar:SetStatusBarColor(color.r, color.g, color.b)
							end
							
							if max == 0 then
								xpbar:SetMinMaxValues(0, 1)
								xpbar:SetValue(1)
							else
								xpbar:SetMinMaxValues(0, max)
								xpbar:SetValue(min)
							end
							xptext:SetText("("..name..") "..min.." / "..max)
						end
					end
				end
			else
				-- XP
				local xp = UnitXP("player")
				local maxxp = UnitXPMax("player")
				xpbar:SetMinMaxValues(0, maxxp)
				xpbar:SetValue(xp)
				-- colorize the statusbar
				if GetXPExhaustion() then
					xpbar:SetStatusBarColor(unpack(LolzenUIcfg.xpbar["xpbar_xp_rested_color"]))
					xptext:SetFormattedText("%.0f%% (%.0f%%)", xp/maxxp*100, GetXPExhaustion()/maxxp*100)
				else
					xpbar:SetStatusBarColor(unpack(LolzenUIcfg.xpbar["xpbar_xp_color"]))
					if maxxp ~= 0 then
						xptext:SetFormattedText("%.0f%%", xp/maxxp*100)
					end
				end
				if UnitLevel("player") == MAX_PLAYER_LEVEL then
					xptext:SetText(nil)
				end
			end
		end
		xpbar.PLAYER_ENTERING_WORLD = xpbar.Update
		xpbar.PLAYER_LEVEL_UP = xpbar.Update
		xpbar.PLAYER_XP_UPDATE = xpbar.Update
		xpbar.UPDATE_FACTION = xpbar.Update
		xpbar.HONOR_LEVEL_UPDATE = xpbar.Update
		xpbar.HONOR_XP_UPDATE = xpbar.Update
		xpbar.UPDATE_EXHAUSTION = xpbar.Update

		xpbar:RegisterEvent("PLAYER_XP_UPDATE")
		xpbar:RegisterEvent("PLAYER_LEVEL_UP")
		xpbar:RegisterEvent("UPDATE_FACTION")
		xpbar:RegisterEvent("HONOR_XP_UPDATE")
		xpbar:RegisterEvent("HONOR_LEVEL_UPDATE")
		xpbar:RegisterEvent("UPDATE_EXHAUSTION")
		xpbar:RegisterEvent("PLAYER_ENTERING_WORLD")
		xpbar:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)

		function ns.setXPBarPosition()
			xpbar:ClearAllPoints()
			xpbar:SetPoint(LolzenUIcfg.xpbar["xpbar_anchor"], LolzenUIcfg.xpbar["xpbar_parent"], LolzenUIcfg.xpbar["xpbar_posx"], LolzenUIcfg.xpbar["xpbar_posy"])
		end

		function ns.setXPBarHeight()
			xpbar:SetHeight(LolzenUIcfg.xpbar["xpbar_height"])
		end

		function ns.setXPBarWidth()
			xpbar:SetWidth(LolzenUIcfg.xpbar["xpbar_width"])
		end

		function ns.setXPBarTexture()
			xpbar:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.xpbar["xpbar_texture"]))
			bg:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.xpbar["xpbar_texture"])
		end

		function ns.setXPBarAlpha()
			xpbar:SetAlpha(LolzenUIcfg.xpbar["xpbar_alpha"])
		end

		function ns.setXPBarBackgroundAlpha()
			bg:SetVertexColor(0, 0, 0, LolzenUIcfg.xpbar["xpbar_bg_alpha"])
		end

		function ns.setXPBarRGBColor()
			xpbar:Update()
		end

		function ns.setXPBarTextPosition()
			xptext:ClearAllPoints()
			xptext:SetPoint(LolzenUIcfg.xpbar["xpbar_text_anchor1"], xpbar, LolzenUIcfg.xpbar["xpbar_text_posx"], LolzenUIcfg.xpbar["xpbar_text_posy"])
		end

		function ns.setXPBarTextColor()
			xptext:SetTextColor(unpack(LolzenUIcfg.xpbar["xpbar_font_color"]))
		end

		function ns.setXPBarFont()
			xptext:SetFont(LSM:Fetch("font", LolzenUIcfg.xpbar["xpbar_font"]), LolzenUIcfg.xpbar["xpbar_font_size"], LolzenUIcfg.xpbar["xpbar_font_flag"])
		end
	end
end)
