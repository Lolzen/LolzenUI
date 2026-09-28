--// xpbar // --
-- Priority: honor in battlegrounds/arenas > watched reputation > experience

local _, ns = ...
local L = ns.L

ns.RegisterModule("xpbar", L["desc_xpbar"], true)

-- slightly altered default reputation colors
local FACTION_BAR_COLORS_LOCAL = {
	[1] = {0.8, 0.3, 0.22},
	[2] = {0.8, 0.3, 0.22},
	[3] = {0.75, 0.27, 0},
	[4] = {0.9, 0.7, 0},
	[5] = {0, 0.6, 0.1},
	[6] = {0, 0.6, 0.1},
	[7] = {0, 0.6, 0.1},
	[8] = {0, 0.6, 0.1},
}

local cfg

local function reactionColor(reaction)
	if ns.IsModuleEnabled("miscellaneous") and LolzenUIcfg.miscellaneous["misc_alternative_faction_colors"] then
		local color = LolzenUIcfg.miscellaneous["misc_faction_colors"][reaction]
		if color then
			return color[1], color[2], color[3]
		end
	end
	local color = FACTION_BAR_COLORS_LOCAL[reaction] or FACTION_BAR_COLORS_LOCAL[4]
	return math.min(1, color[1] * 1.25), math.min(1, color[2] * 1.25), math.min(1, color[3] * 1.25)
end

local function setBar(bar, min, max, value)
	if max <= min then
		bar:SetMinMaxValues(0, 1)
		bar:SetValue(1)
	else
		bar:SetMinMaxValues(min, max)
		bar:SetValue(value)
	end
end

local function updateHonor(bar)
	local level = UnitHonorLevel("player")
	local current, max = UnitHonor("player"), UnitHonorMax("player")
	setBar(bar, 0, max, current)
	bar:SetStatusBarColor(ns.RGB(cfg["xpbar_pvp_color"]))
	bar.text:SetFormattedText("[L:%d] %d/%d (%.0f%%)", level, current, max, max > 0 and current / max * 100 or 0)
end

local function updateReputation(bar, data)
	local factionID = data.factionID

	-- paragon
	if C_Reputation.IsFactionParagon(factionID) then
		local current, threshold, _, rewardPending = C_Reputation.GetFactionParagonInfo(factionID)
		if current and threshold and threshold > 0 then
			local value = current % threshold
			if rewardPending then
				value = value + threshold
			end
			setBar(bar, 0, threshold, value)
			bar:SetStatusBarColor(ns.RGB(cfg["xpbar_paragon_color"]))
			bar.text:SetFormattedText("(%s) %d / %d", data.name, value, threshold)
			return
		end
	end

	-- renown
	if C_Reputation.IsMajorFaction and C_Reputation.IsMajorFaction(factionID) then
		local major = C_MajorFactions.GetMajorFactionData(factionID)
		if major then
			local earned, threshold = major.renownReputationEarned or 0, major.renownLevelThreshold or 0
			setBar(bar, 0, threshold, earned)
			bar:SetStatusBarColor(ns.RGB(cfg["xpbar_paragon_color"]))
			bar.text:SetFormattedText("(%s) R%d: %d / %d", data.name, major.renownLevel or 0, earned, threshold)
			return
		end
	end

	local min, max, value = data.currentReactionThreshold or 0, data.nextReactionThreshold or 0, data.currentStanding or 0

	-- friendships use their own thresholds
	local friendship = C_GossipInfo and C_GossipInfo.GetFriendshipReputation(factionID)
	if friendship and friendship.friendshipFactionID and friendship.friendshipFactionID > 0 then
		min, value = friendship.reactionThreshold or 0, friendship.standing or 0
		max = friendship.nextThreshold or value
	end

	bar:SetStatusBarColor(reactionColor(data.reaction))
	setBar(bar, min, max, value)
	if max > min then
		bar.text:SetFormattedText("(%s) %d / %d", data.name, value - min, max - min)
	else
		bar.text:SetFormattedText("(%s)", data.name)
	end
end

local function updateExperience(bar)
	local xp, maxXP = UnitXP("player"), UnitXPMax("player")
	setBar(bar, 0, maxXP, xp)
	local rested = GetXPExhaustion()
	if rested and rested > 0 then
		bar:SetStatusBarColor(ns.RGB(cfg["xpbar_xp_rested_color"]))
		bar.text:SetFormattedText("%.0f%% (%.0f%%)", maxXP > 0 and xp / maxXP * 100 or 0, maxXP > 0 and rested / maxXP * 100 or 0)
	else
		bar:SetStatusBarColor(ns.RGB(cfg["xpbar_xp_color"]))
		bar.text:SetFormattedText("%.0f%%", maxXP > 0 and xp / maxXP * 100 or 0)
	end
end

local function update(bar)
	local _, instanceType = IsInInstance()
	local watched = C_Reputation.GetWatchedFactionData()
	if instanceType == "pvp" or instanceType == "arena" then
		updateHonor(bar)
	elseif watched and watched.factionID and watched.factionID ~= 0 then
		updateReputation(bar, watched)
	elseif not IsPlayerAtEffectiveMaxLevel() and not IsXPUserDisabled() then
		updateExperience(bar)
	else
		-- nothing to track
		if not bar.inEditMode then
			bar:Hide()
		end
		return
	end
	bar:Show()
end

ns.OnInit("xpbar", function()
	cfg = LolzenUIcfg.xpbar

	-- our bar replaces the default experience/reputation bars
	ns.Kill(StatusTrackingBarManager)
	ns.Kill(MainStatusTrackingBarContainer)
	ns.Kill(SecondaryStatusTrackingBarContainer)

	local bar, options = ns.CreateDataBar("LolzenUI_XPBar", "xpbar", cfg, ns.defaults.xpbar, update)
	options:Header(L["color"])
	options:Color("xpbar_xp_color", L["xp_regular_xp_color"])
	options:Color("xpbar_xp_rested_color", L["xp_rested_xp_color"])
	options:Color("xpbar_pvp_color", L["xp_pvp_color"])
	options:Color("xpbar_paragon_color", L["xp_paragon_color"])
	ns.RegisterDataBar(bar, L["LolzenUI: XP Bar"], ns.defaults.xpbar)

	for _, event in ipairs({
		"PLAYER_ENTERING_WORLD", "PLAYER_XP_UPDATE", "PLAYER_LEVEL_UP", "UPDATE_EXHAUSTION", "UPDATE_FACTION",
		"HONOR_XP_UPDATE", "HONOR_LEVEL_UPDATE", "MAJOR_FACTION_RENOWN_LEVEL_CHANGED", "ENABLE_XP_GAIN", "DISABLE_XP_GAIN",
	}) do
		-- not every event exists in every client version
		pcall(bar.RegisterEvent, bar, event)
	end

	ns.setXPBarRGBColor = function() bar:Update() end
end)
