--// pullcount // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["pullcount"] == false then return end

		local filter = function(frame, event, message, ...)
			if message:match("Pull in 3") then
				PlaySoundFile("Interface\\AddOns\\LolzenUI\\media\\three.mp3", "master")
			elseif message:match("Pull in 2") then
				PlaySoundFile("Interface\\AddOns\\LolzenUI\\media\\two.mp3", "master")
			elseif message:match("Pull in 1") then
				PlaySoundFile("Interface\\AddOns\\LolzenUI\\media\\one.mp3", "master")
			elseif message:match(">> Pull Now <<") then
				PlaySoundFile("Interface\\AddOns\\LolzenUI\\media\\Play.mp3", "master")
			end
		end

		ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE", filter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_LEADER", filter)
	end
end)