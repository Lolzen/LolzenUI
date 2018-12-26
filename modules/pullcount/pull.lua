--// pullcount // --

local _, ns = ...
local L = ns.L

ns.RegisterModule("pullcount", L["desc_pullcount"] , true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("CHAT_MSG_ADDON")

local timer = f:CreateAnimationGroup()

local timerAnim = timer:CreateAnimation()
timerAnim:SetDuration(1)

local isCounting = false
local pullNum = 0
timer:SetScript("OnFinished", function(self, requested)
	if pullNum-1 <= LolzenUIcfg.pullcount["pull_count_range"] then
		if LolzenUIcfg.pullcount["pull_sound_"..pullNum -1] then
			if LolzenUIcfg.pullcount["pull_sound_"..pullNum-1] then
				PlaySoundFile("Interface\\AddOns\\LolzenUI\\sounds\\"..LolzenUIcfg.pullcount["pull_sound_"..pullNum-1], "master")
			end
		elseif pullNum-1 == 0 then
			PlaySoundFile("Interface\\AddOns\\LolzenUI\\sounds\\"..LolzenUIcfg.pullcount["pull_sound_pull"], "master")
			isCounting = false
		end
	end
	if pullNum -1 ~= 0 then
		self:Play()
	end
	pullNum = pullNum -1
end)

local function initiateCountdown(num)
	if isCounting == true then return end
	isCounting = true
	if LolzenUIcfg.pullcount["pull_sound_"..num] then
		PlaySoundFile("Interface\\AddOns\\LolzenUI\\sounds\\"..LolzenUIcfg.pullcount["pull_sound_"..num], "master")
	end
	pullNum = num
	timer:Play()
	TimerTracker_OnEvent(TimerTracker, "START_TIMER", 2, num, num)
end

f:SetScript("OnEvent", function(self, event, ...)
	local arg1 = ...
	if event == "ADDON_LOADED" and arg1 == "LolzenUI" then
		if LolzenUIcfg.modules["pullcount"] == false then return end
		-- Register BigWigs and DBM prefixes so we can get their pullcounters too
		-- but only if we don't run them already
		if not IsAddOnLoaded("BigWigs") then
			C_ChatInfo.RegisterAddonMessagePrefix("BigWigs")
		end
		if not IsAddOnLoaded("DBM-Core") then
			C_ChatInfo.RegisterAddonMessagePrefix("D4")
		end

		local filter = function(frame, event, message, ...)
			if isCounting == true then return end
			for i = 1, LolzenUIcfg.pullcount["pull_count_range"] do
				local msg = LolzenUIcfg.pullcount["pull_msg_count"]
				msg = string.gsub(msg, "!n", i)
				if message:match(msg) then
					PlaySoundFile("Interface\\AddOns\\LolzenUI\\sounds\\"..LolzenUIcfg.pullcount["pull_sound_"..i], "master")
				end
			end
			if message:match(LolzenUIcfg.pullcount["pull_msg_now"]) then
				PlaySoundFile("Interface\\AddOns\\LolzenUI\\sounds\\"..LolzenUIcfg.pullcount["pull_sound_pull"], "master")
			end
		end

		if LolzenUIcfg.pullcount["pull_filter_channel"] == true then
			ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
		end
		if LolzenUIcfg.pullcount["pull_filter_guild"] == true then
			ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filter)
		end
		if LolzenUIcfg.pullcount["pull_filter_party"] == true then
			ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filter)
			ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter)
		end
		if LolzenUIcfg.pullcount["pull_filter_instance"] == true then
			ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE", filter)
			ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_LEADER", filter)
		end
		if LolzenUIcfg.pullcount["pull_filter_say"] == true then
			ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
		end
	elseif event == "CHAT_MSG_ADDON" then
		if LolzenUIcfg.modules["pullcount"] == false then return end
		if IsAddOnLoaded("DBM-Core") or IsAddOnLoaded("BigWigs") then return end
		
		local prefix, msg, channel, sender = ...
		if prefix == "BigWigs" then
			local bwPrefix, bwMsg, extra = strsplit("^", msg)
			
			if bwPrefix == "P" and bwMsg == "Pull" then
				--print("recieved pull timer from BigWigs :"..tonumber(extra))
				initiateCountdown(tonumber(extra))
			end		
		elseif prefix == "D4" then
			local dbmPrefix, time, _, _, _ = strsplit("\t", msg)
			
			if dbmPrefix == "PT" then
				--print("recieved pull timer from DBM : "..tonumber(time))
				initiateCountdown(tonumber(time))
			end
		end
	end
end)

local function SendPull(num)
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		C_ChatInfo.SendAddonMessage("D4", "PT\t"..num, "INSTANCE_CHAT") --DBM
		C_ChatInfo.SendAddonMessage("BigWigs", "P^Pull^"..num, "INSTANCE_CHAT") --BigWigs
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		C_ChatInfo.SendAddonMessage("D4", "PT\t"..num, "PARTY") --DBM
		C_ChatInfo.SendAddonMessage("BigWigs", "P^Pull^"..num, "PARTY") --BigWigs
	else
		C_ChatInfo.SendAddonMessage("D4", "PT\t"..num, "WHISPER", UnitName("player")) --DBM
		C_ChatInfo.SendAddonMessage("BigWigs", "P^Pull^"..num, "WHISPER", UnitName("player")) --BigWigs
	end
end

-- Disable the /pull command if either DBM or BigWigs are running, else use our /pull slashcommand
if IsAddOnLoaded("DBM-Core") or IsAddOnLoaded("BigWigs") then
	--do nothing
else
	SLASH_PULL1 = "/pull"
	SlashCmdList["PULL"] = function(num)
		if LolzenUIcfg.modules["pullcount"] == false then return end
		
		if num and type(num) == "string" then
			--print(num)
			if num == "" then
				SendPull(LolzenUIcfg.pullcount["pull_count_range"])
			else
				SendPull(num)
			end
		end
	end
end