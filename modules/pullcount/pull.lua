--// pullcount // --

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("CHAT_MSG_ADDON")

local isCounting = false
local eF = CreateFrame("Frame")
local colorInfo = {r = 1, g = 0, b = 0} --option!

local function stopUpdater()
	eF:SetScript("OnUpdate", nil)
end

local function initiateCountdown(num)
	if isCounting == true then return end
	isCounting = true
	RaidNotice_AddMessage(RaidWarningFrame, tostring(num), colorInfo, 1)
	if LolzenUIcfg.pullcount["pull_sound_"..num] then
		PlaySoundFile("Interface\\AddOns\\LolzenUI\\sounds\\"..LolzenUIcfg.pullcount["pull_sound_"..num], "master")
	end
	local pullNum = num
	local last = 0
	eF:SetScript("OnUpdate", function(self, elapsed)
		last = last + elapsed
		if last >= 1 then
			if pullNum-1 <= LolzenUIcfg.pullcount["pull_count_range"] then
				if LolzenUIcfg.pullcount["pull_sound_"..pullNum -1] then
					RaidNotice_AddMessage(RaidWarningFrame, tostring(pullNum-1), colorInfo, 1)
					if LolzenUIcfg.pullcount["pull_sound_"..pullNum-1] then
						PlaySoundFile("Interface\\AddOns\\LolzenUI\\sounds\\"..LolzenUIcfg.pullcount["pull_sound_"..pullNum-1], "master")
					end
				elseif pullNum-1 == 0 then
					RaidNotice_AddMessage(RaidWarningFrame, ">>Pull Now<<", colorInfo, 1)
					PlaySoundFile("Interface\\AddOns\\LolzenUI\\sounds\\"..LolzenUIcfg.pullcount["pull_sound_pull"], "master")
				end
			end
			pullNum = pullNum -1
			last = 0
		end
		if pullNum-1 <= 0 then
			isCounting = false
			return
		elseif pullNum == 0 then
			stopUpdater()
		end
	end)
end

f:SetScript("OnEvent", function(self, event, ...)
	local arg1 = ...
	if event == "ADDON_LOADED" and arg1 == "LolzenUI" then
		if LolzenUIcfg.modules["pullcount"] == false then return end
		-- Register BigWigs and DBM prefixes so we can get their pullcounters too
		RegisterAddonMessagePrefix("BigWigs")
		RegisterAddonMessagePrefix("D4")

		local colorInfo = {r = 1, g = 0, b = 0} --option!
		local filter = function(frame, event, message, ...)
			for i = 1, LolzenUIcfg.pullcount["pull_count_range"] do
				local msg = LolzenUIcfg.pullcount["pull_msg_count"]
				msg = string.gsub(msg, "!n", i)
				if message:match(msg) then
					RaidNotice_AddMessage(RaidWarningFrame, tostring(i), colorInfo, 1)
					PlaySoundFile("Interface\\AddOns\\LolzenUI\\sounds\\"..LolzenUIcfg.pullcount["pull_sound_"..i], "master")
				end
			end
			if message:match(LolzenUIcfg.pullcount["pull_msg_now"]) then
				RaidNotice_AddMessage(RaidWarningFrame, ">>Pull Now<<", colorInfo, 1)
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
		
		local prefix, msg, channel, sender = ...
		if prefix == "BigWigs" then
			local bwPrefix, bwMsg, extra = strsplit("^", msg)
			
			if bwPrefix == "P" and bwMsg == "Pull" then
				print("recieved pull timer from BigWigs :"..tonumber(extra))
				initiateCountdown(tonumber(extra))
			end		
		elseif prefix == "D4" then
			local dbmPrefix, time, _, _, _ = strsplit("\t", msg)
			
			if dbmPrefix == "PT" then
				print("recieved pull timer from DBM : "..tonumber(time))
				initiateCountdown(tonumber(time))
			end
		end
	end
end)

local function SendPull(num)
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		SendAddonMessage("D4", "PT\t"..num, "INSTANCE_CHAT") --DBM
		SendAddonMessage("BigWigs", "P^Pull^"..num, "INSTANCE_CHAT") --BigWigs
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		SendAddonMessage("D4", "PT\t"..num, "PARTY") --DBM
		SendAddonMessage("BigWigs", "P^Pull^"..num, "PARTY") --BigWigs
	else
		SendAddonMessage("D4", "PT\t"..num, "WHISPER", UnitName("player")) --DBM
		SendAddonMessage("BigWigs", "P^Pull^"..num, "WHISPER", UnitName("player")) --BigWigs
	end
end

SLASH_PULL1 = "/pull"
SlashCmdList["PULL"] = function(num)
	if LolzenUIcfg.modules["pullcount"] == false then return end
	if num and type(num) == "string" then
		if num == "" then
			SendPull(LolzenUIcfg.pullcount["pull_count_range"])
		else
			SendPull(num)
		end
	end
end