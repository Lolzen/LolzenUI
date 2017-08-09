--// xpbar // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["xpbar"] == false then return end

		-- Change the rep colors slightly
		FACTION_BAR_COLORS = {
			[1] = {r = 1, g = 0.2, b = 0.15},	-- Hated
			[2] = {r = 0.8, g = 0.3, b = 0.22},	-- Hostile		}
			[3] = {r = 0.75, g = 0.27, b = 0},	-- Unfriendly	} same as default
			[4] = {r = 0.9, g = 0.7, b = 0},	-- Neutral		}
			[5] = {r = 0, g = 0.6, b = 0.1},	-- Friendly		}
			[6] = {r = 0, g = 0.6, b = 0.33},	-- Honored
			[7] = {r = 0, g = 0.7, b = 0.5},	-- Revered
			[8] = {r = 0, g = 0.7, b = 0.7},	-- Exalted
		}

		-- first let us create our bar
		local xpbar = CreateFrame("StatusBar", "bar4xpbar", UIParent)
		xpbar:SetPoint(LolzenUIcfg.xpbar["xpbar_anchor"], LolzenUIcfg.xpbar["xpbar_parent"], LolzenUIcfg.xpbar["xpbar_posx"], LolzenUIcfg.xpbar["xpbar_posy"])
		xpbar:SetHeight(LolzenUIcfg.xpbar["xpbar_height"])
		xpbar:SetWidth(LolzenUIcfg.xpbar["xpbar_width"])
		xpbar:SetStatusBarTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.xpbar["xpbar_texture"])
		xpbar:SetAlpha(LolzenUIcfg.xpbar["xpbar_alpha"])
		xpbar:SetFrameStrata("BACKGROUND")

		-- Background for our bar
		local bg = xpbar:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(xpbar)
		bg:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.xpbar["xpbar_texture"])
		bg:SetVertexColor(0, 0, 0, LolzenUIcfg.xpbar["xpbar_bg_alpha"])

		--1px "border"
		if LolzenUIcfg.xpbar["xpbar_1px_border"] == true then
			local lines = {}
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
			end
		end

		-- fontstring
		local xptext = xpbar:CreateFontString(nil, "OVERLAY")
		xptext:SetPoint(LolzenUIcfg.xpbar["xpbar_text_anchor1"], xpbar, LolzenUIcfg.xpbar["xpbar_text_anchor2"], LolzenUIcfg.xpbar["xpbar_text_posx"], LolzenUIcfg.xpbar["xpbar_text_posy"])
		xptext:SetParent(UIParent)
		xptext:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg.xpbar["xpbar_font"], LolzenUIcfg.xpbar["xpbar_font_size"], LolzenUIcfg.xpbar["xpbar_font_flag"])
		xptext:SetTextColor(unpack(LolzenUIcfg.xpbar["xpbar_font_color"]))

		function xpbar:Update()
			-- Proprity #1: If in BGs show the HonorXP
			-- Priority #2: Show REP when ticked on
			-- Priority #3: Show XP
			if select(2,IsInInstance()) == "pvp" or select(2,IsInInstance()) == "arena" then
				local prestige = UnitPrestige("player")
				local level = UnitHonorLevel("player")
				local current = UnitHonor("player")
				local max = UnitHonorMax("player")
				xpbar:SetMinMaxValues(0, max)
				xpbar:SetValue(current)
				xpbar:SetStatusBarColor(unpack(LolzenUIcfg.xpbar["xpbar_pvp_color"]))
				xptext:SetFormattedText("%s (%.0f%%)", "[P:"..prestige.."L:"..level.."] "..current.."/"..max, current/max*100)
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
							local baseColor = FACTION_BAR_COLORS[standing]
							local color = {}
							for key, value in pairs(baseColor) do 
								color[key] = math.min(1, value * 1.25)
							end
							xpbar:SetMinMaxValues(0, max)
							xpbar:SetValue(min)
							xpbar:SetStatusBarColor(color.r, color.g, color.b)
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
					xpbar:SetStatusBarColor(unpack(LolzenUIcfg.xpbar["xpbar_xp_color"]))
					xptext:SetFormattedText("%.0f%% (%.0f%%)", xp/maxxp*100, GetXPExhaustion()/maxxp*100)
				else
					xpbar:SetStatusBarColor(unpack(LolzenUIcfg.xpbar["xpbar_xp_rested_color"]))
					xptext:SetFormattedText("%.0f%%", xp/maxxp*100)
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
		xpbar.HONOR_PRESTIGE_UPDATE = xpbar.Update
		xpbar.UPDATE_EXHAUSTION = xpbar.Update

		xpbar:RegisterEvent("PLAYER_XP_UPDATE")
		xpbar:RegisterEvent("PLAYER_LEVEL_UP")
		xpbar:RegisterEvent("UPDATE_FACTION")
		xpbar:RegisterEvent("HONOR_XP_UPDATE")
		xpbar:RegisterEvent("HONOR_LEVEL_UPDATE")
		xpbar:RegisterEvent("HONOR_PRESTIGE_UPDATE")
		xpbar:RegisterEvent("UPDATE_EXHAUSTION")
		xpbar:RegisterEvent("PLAYER_ENTERING_WORLD")
		xpbar:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
	end
end)
