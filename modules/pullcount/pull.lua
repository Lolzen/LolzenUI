--// pullcount // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["pullcount"] == false then return end

		local filter = function(frame, event, message, ...)
			for i = 1, LolzenUIcfg["pull_count_range"] do
				local msg = LolzenUIcfg["pull_msg_count"]
				msg = string.gsub(msg, "!n", i)
				if message:match(msg) then
					PlaySoundFile("Interface\\AddOns\\LolzenUI\\sounds\\"..LolzenUIcfg["pull_sound_"..i], "master")
				end
			end
			if message:match(LolzenUIcfg["pull_msg_now"]) then
				PlaySoundFile("Interface\\AddOns\\LolzenUI\\sounds\\"..LolzenUIcfg["pull_sound_pull"], "master")
			end
		end

		if LolzenUIcfg["pull_filter_channel"] == true then
			ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
		end
		if LolzenUIcfg["pull_filter_guild"] == true then
			ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filter)
		end
		if LolzenUIcfg["pull_filter_party"] == true then
			ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filter)
			ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter)
		end
		if LolzenUIcfg["pull_filter_instance"] == true then
			ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE", filter)
			ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_LEADER", filter)
		end
		if LolzenUIcfg["pull_filter_say"] == true then
			ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
		end
	end
end)