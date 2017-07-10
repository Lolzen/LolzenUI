--// xpbar // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["xpbar"] == false then return end

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
		xpbar:SetPoint("BOTTOM", UIParent, 0, 5)
		xpbar:SetHeight(4)
		xpbar:SetWidth(378)
		xpbar:SetStatusBarTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
		xpbar:SetAlpha(0.4)
		
		--Background for our bar
		local bg = xpbar:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(xpbar)
		bg:SetTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
		bg:SetVertexColor(0, 0, 0, 0.5)

		local line = xpbar:CreateTexture(nil, "OVERLAY")
		line:SetPoint("TOPLEFT", xpbar, 0, 1)
		line:SetPoint("TOPRIGHT", xpbar, 0, 1)
		line:SetHeight(1)
		line:SetTexture(0, 0, 0, 1)

		local line2 = xpbar:CreateTexture(nil, "OVERLAY")
		line2:SetPoint("BOTTOMLEFT", xpbar, 0, -1)
		line2:SetPoint("BOTTOMRIGHT", xpbar, 0, -1)
		line2:SetHeight(1)
		line2:SetTexture(0, 0, 0, 1)

		-- fontstring
		local xptext = xpbar:CreateFontString(nil, "OVERLAY")
		xptext:SetPoint("BOTTOM", xpbar, "TOP", 0, -2)
		xptext:SetParent(UIParent)
		xptext:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 10, "THINOUTLINE")
		xptext:SetTextColor(1,1,1)

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
				xpbar:SetStatusBarColor(1, 0.4, 0)
				xptext:SetFormattedText("%s (%.0f%%)", "[P:"..prestige.."L:"..level.."] "..current.."/"..max, current/max*100)
			else
				-- Reputation
				local name, standing, min, max, value = GetWatchedFactionInfo()
				max, min = (max-min), (value-min)
				local baseColor = FACTION_BAR_COLORS[standing]
				local color = {}
				if name then
					for key, value in pairs(baseColor) do 
						color[key] = math.min(1, value * 1.25)
					end
					xpbar:SetMinMaxValues(0, max)
					xpbar:SetValue(min)
					xpbar:SetStatusBarColor(color.r, color.g, color.b)
					xptext:SetText("("..name..") "..min.." / "..max)
				else
					-- XP
					local xp = UnitXP("player")
					local maxxp = UnitXPMax("player")
					xpbar:SetMinMaxValues(0, maxxp)
					xpbar:SetValue(xp)
					-- colorize the statusbar
					if GetXPExhaustion() then
						xpbar:SetStatusBarColor(0.6, 0, 0.6)
						xptext:SetFormattedText("%.0f%% (%.0f%%)", xp/maxxp*100, GetXPExhaustion()/maxxp*100)
					else
						xpbar:SetStatusBarColor(46/255, 103/255, 208/255)
						xptext:SetFormattedText("%.0f%%", xp/maxxp*100)
					end

					if UnitLevel("player") == MAX_PLAYER_LEVEL then
						xptext:SetText(nil)
					end
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
