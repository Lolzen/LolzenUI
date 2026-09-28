--// pullcount // --
-- Plays sounds for Blizzard's countdown (/pull, DBM, BigWigs all use it nowadays)
-- and for pull messages in the chat.

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("pullcount", L["desc_pullcount"], true)

local cfg
local ticker
local remaining = 0

local FILTER_EVENTS = {
	pull_filter_guild = {"CHAT_MSG_GUILD"},
	pull_filter_party = {"CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER"},
	pull_filter_instance = {"CHAT_MSG_INSTANCE_CHAT", "CHAT_MSG_INSTANCE_CHAT_LEADER"},
	pull_filter_say = {"CHAT_MSG_SAY"},
	pull_filter_channel = {"CHAT_MSG_CHANNEL"},
}

local function playSound(key)
	local sound = cfg[key]
	if sound then
		PlaySoundFile(LSM:Fetch("sound", sound), "Master")
	end
end

local function playNumber(num)
	if num == 0 then
		playSound("pull_sound_pull")
	elseif num <= cfg["pull_count_range"] then
		playSound("pull_sound_"..num)
	end
end

local function stopCountdown()
	if ticker then
		ticker:Cancel()
		ticker = nil
	end
end

local function tick()
	remaining = remaining - 1
	playNumber(remaining)
	if remaining <= 0 then
		stopCountdown()
	end
end

local function startCountdown(seconds)
	stopCountdown()
	remaining = math.floor(seconds + 0.5)
	playNumber(remaining)
	if remaining > 0 then
		ticker = C_Timer.NewTicker(1, tick, remaining)
	end
end

local DENIED = "|TInterface\\RaidFrame\\ReadyCheck-NotReady:20:20:0:0|t"
local function abortCountdown()
	if not ticker then return end
	stopCountdown()
	playSound("pull_sound_abort")
	RaidNotice_AddMessage(RaidBossEmoteFrame, DENIED.."  |cffff0000"..L["PULL ABORTED"].."|r  "..DENIED, ChatTypeInfo["RAID_BOSS_EMOTE"])
end

-- pull messages of people without DBM/BigWigs
local function chatFilter(_, _, message)
	if ticker or ns.IsSecret(message) or type(message) ~= "string" then return end
	local countMsg = cfg["pull_msg_count"]
	for i = 1, cfg["pull_count_range"] do
		if message:find((countMsg:gsub("!n", i)), 1, true) then
			playSound("pull_sound_"..i)
			return
		end
	end
	if message:find(cfg["pull_msg_now"], 1, true) then
		playSound("pull_sound_pull")
	end
end

local function applyFilters()
	for key, events in pairs(FILTER_EVENTS) do
		for _, event in ipairs(events) do
			if cfg[key] then
				ChatFrame_AddMessageEventFilter(event, chatFilter)
			else
				ChatFrame_RemoveMessageEventFilter(event, chatFilter)
			end
		end
	end
end

-- compatibility with the old option callbacks
ns.setPCMsgFilterGuild = applyFilters
ns.setPCMsgFilterParty = applyFilters
ns.setPCMsgFilterInstance = applyFilters
ns.setPCMsgFilterSay = applyFilters
ns.setPCMsgFilterCustom = applyFilters

local function onEvent(_, event, ...)
	if event == "START_PLAYER_COUNTDOWN" then
		local _, timeRemaining = ...
		startCountdown(timeRemaining)
	elseif event == "CANCEL_PLAYER_COUNTDOWN" then
		abortCountdown()
	elseif event == "ADDON_LOADED" and ... == "Blizzard_ChallengesUI" then
		-- keep the countdown numbers above the keystone frame
		ChallengesKeystoneFrame:SetFrameStrata("LOW")
	end
end

ns.OnInit("pullcount", function()
	cfg = LolzenUIcfg.pullcount
	applyFilters()

	local events = CreateFrame("Frame")
	pcall(events.RegisterEvent, events, "START_PLAYER_COUNTDOWN")
	pcall(events.RegisterEvent, events, "CANCEL_PLAYER_COUNTDOWN")
	events:RegisterEvent("ADDON_LOADED")
	events:SetScript("OnEvent", onEvent)

	local options = ns.Options.New("pullcount", function() return LolzenUIcfg.pullcount end, ns.defaults.pullcount, applyFilters)
	options:Header(L["count_play_sound_from"])
	options:Toggle("pull_filter_guild", L["count_guild"])
	options:Toggle("pull_filter_party", L["count_party"])
	options:Toggle("pull_filter_instance", L["count_instance"])
	options:Toggle("pull_filter_say", L["count_say"])
	options:Toggle("pull_filter_channel", L["count_custom_channels"])
	options:Header(L["count_custom_message_to_react_header"])
	options:Text("pull_msg_count", L["count_countdown_message"]):SetDesc(L["count_!n_represents"])
	options:Text("pull_msg_now", L["count_file_pull"])
	options:Header(L["count_range_header"])
	options:Range("pull_count_range", L["count_range"], 1, 10, 1)
	for i = 1, 10 do
		options:Media("pull_sound_"..i, L["count_file"].." "..i, "sound")
	end
	options:Media("pull_sound_pull", L["count_file_pull"], "sound")
	options:Media("pull_sound_abort", L["count_file_abort"], "sound")
	ns.SettingsPanel:AddCategory("pullcount", options)
end)

ns.OnLogin("pullcount", function()
	-- DBM and BigWigs bring their own /pull
	if SlashCmdList["PULL"] or C_AddOns.IsAddOnLoaded("DBM-Core") or C_AddOns.IsAddOnLoaded("BigWigs") then return end
	SLASH_LOLZENUI_PULL1 = "/pull"
	SlashCmdList["LOLZENUI_PULL"] = function(msg)
		local seconds = tonumber(msg) or cfg["pull_count_range"]
		C_PartyInfo.DoCountdown(seconds)
	end
end)
