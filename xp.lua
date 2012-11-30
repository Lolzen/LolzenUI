--[[####################
		bar4xp
	   by Lolzen
####################]]--

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

-- fontsrting
local xptext = xpbar:CreateFontString(nil, "OVERLAY")
xptext:SetPoint("BOTTOM", xpbar, "TOP", 0, 2)
xptext:SetParent(UIParent)
xptext:SetFont("Interface\\AddOns\\LolzenUI\\media\\SEMPRG.TTF", 8, "THINOUTLINE")
xptext:SetTextColor(1,1,1)

-- gather our data every time we get xp
function xpbar:PLAYER_XP_UPDATE()
	local xp = UnitXP("player")
	local maxxp = UnitXPMax("player")
	xpbar:SetMinMaxValues(0, maxxp)
	xpbar:SetValue(xp)
	-- colorize the statusbar
	if GetXPExhaustion() then
		xpbar:SetStatusBarColor(0.6, 0, 0.6)
		xptext:SetFormattedText("%.0f%% (%.0f%%)", xp/maxxp*100, GetXPExhaustion()/maxxp*100)
		--indicator:SetPoint("
	else
		xpbar:SetStatusBarColor(46/255, 103/255, 208/255)
		xptext:SetFormattedText("%.0f%%", xp/maxxp*100)
		--indicator:SetPoint("
	end
	
	if UnitLevel("player") == MAX_PLAYER_LEVEL then
		xptext:SetText(nil)
	end
end
xpbar.PLAYER_LEVEL_UP = xpbar.PLAYER_XP_UPDATE


-- Reputiation data, text & coloring
function xpbar:UPDATE_FACTION()
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
		xpbar.PLAYER_XP_UPDATE()
	end
end

xpbar.PLAYER_ENTERING_WORLD = xpbar.UPDATE_FACTION

xpbar:RegisterEvent("PLAYER_XP_UPDATE")
xpbar:RegisterEvent("PLAYER_LEVEL_UP")
xpbar:RegisterEvent("UPDATE_FACTION")
xpbar:RegisterEvent("PLAYER_ENTERING_WORLD")
xpbar:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)