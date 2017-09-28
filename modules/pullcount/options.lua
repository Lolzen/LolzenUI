--// options for pullcount //--

local addon, ns = ...

ns.RegisterModule("pullcount")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["pullcount"] == true then

		local title = ns["pullcount"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["pullcount"], 16, -16)
		title:SetText("|cff5599ff"..ns["pullcount"].name.."|r")

		local about = ns["pullcount"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Plays sounds on a specific chat message or BigWigs/DBM(pull counter)")

		local pull_message_count_text = ns["pullcount"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pull_message_count_text:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		pull_message_count_text:SetText("|cff5599ffCountdown message:|r")

		local pull_message_countdown = CreateFrame("EditBox", nil, ns["pullcount"], "InputBoxTemplate")
		pull_message_countdown:SetPoint("LEFT", pull_message_count_text, "RIGHT", 10, 0)
		pull_message_countdown:SetSize(100, 20)
		pull_message_countdown:SetAutoFocus(false)
		pull_message_countdown:ClearFocus()
		pull_message_countdown:SetText(LolzenUIcfg.pullcount["pull_msg_count"])
		pull_message_countdown:SetCursorPosition(0)

		local count_notice = ns["pullcount"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		count_notice:SetPoint("TOPLEFT", pull_message_count_text, "BOTTOMLEFT", 0, -8)
		count_notice:SetText("|cff5599ff!n|r represents a number from 1-10")

		local pull_message_text = ns["pullcount"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pull_message_text:SetPoint("TOPLEFT", count_notice, "BOTTOMLEFT", 0, -8)
		pull_message_text:SetText("|cff5599ffPull now message:|r")

		local pull_message = CreateFrame("EditBox", nil, ns["pullcount"], "InputBoxTemplate")
		pull_message:SetPoint("LEFT", pull_message_text, "RIGHT", 10, 0)
		pull_message:SetSize(100, 20)
		pull_message:SetAutoFocus(false)
		pull_message:ClearFocus()
		pull_message:SetText(LolzenUIcfg.pullcount["pull_msg_now"])
		pull_message:SetCursorPosition(0)

		local pull_count_range_text = ns["pullcount"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pull_count_range_text:SetPoint("TOPLEFT", pull_message_text, "BOTTOMLEFT", 0, -10)
		pull_count_range_text:SetText("|cff5599ffPull count range (1-10):|r")

		local pull_count_range = CreateFrame("EditBox", nil, ns["pullcount"], "InputBoxTemplate")
		pull_count_range:SetPoint("LEFT", pull_count_range_text, "RIGHT", 10, 0)
		pull_count_range:SetSize(100, 20)
		pull_count_range:SetAutoFocus(false)
		pull_count_range:ClearFocus()
		pull_count_range:SetNumber(LolzenUIcfg.pullcount["pull_count_range"])
		pull_count_range:SetCursorPosition(0)

		local pull_sound_count = {}
		for i=1, 10 do
			pull_sound_count[i] = ns["pullcount"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
			if i == 1 then
				pull_sound_count[i]:SetPoint("TOPLEFT", pull_count_range_text, "BOTTOMLEFT", 0, -20)
			else
				pull_sound_count[i]:SetPoint("TOPLEFT", pull_sound_count[i-1], "BOTTOMLEFT", 0, -10)
			end
			pull_sound_count[i]:SetText("|cff5599ffSoundfile for count "..i..":|r Interface\\AddOns\\LolzenUI\\sounds\\")

			pull_sound_count[i].eb = CreateFrame("EditBox", nil, ns["pullcount"], "InputBoxTemplate")
			pull_sound_count[i].eb:SetPoint("LEFT", pull_sound_count[i], "RIGHT", 10, 0)
			pull_sound_count[i].eb:SetSize(100, 20)
			pull_sound_count[i].eb:SetAutoFocus(false)
			pull_sound_count[i].eb:ClearFocus()
			pull_sound_count[i].eb:SetText(LolzenUIcfg.pullcount["pull_sound_"..i])
			pull_sound_count[i].eb:SetCursorPosition(0)
		end

		local pull_now_text = ns["pullcount"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pull_now_text:SetPoint("TOPLEFT", pull_sound_count[10], "BOTTOMLEFT", 0, -8)
		pull_now_text:SetText("|cff5599ffSoundfile for pull now:|r Interface\\AddOns\\LolzenUI\\sounds\\")

		local pull_now = CreateFrame("EditBox", nil, ns["pullcount"], "InputBoxTemplate")
		pull_now:SetPoint("LEFT", pull_now_text, "RIGHT", 10, 0)
		pull_now:SetSize(100, 20)
		pull_now:SetAutoFocus(false)
		pull_now:ClearFocus()
		pull_now:SetText(LolzenUIcfg.pullcount["pull_sound_pull"])
		pull_now:SetCursorPosition(0)

		local cb1 = CreateFrame("CheckButton", "filter_guild", ns["pullcount"], "ChatConfigCheckButtonTemplate")
		cb1:SetPoint("TOPLEFT", pull_now_text, "BOTTOMLEFT", 0, -20)
		filter_guildText:SetText("|cff5599ffplay sounds on countdowns from guild chat|r")

		if LolzenUIcfg.pullcount["pull_filter_guild"] == true then
			cb1:SetChecked(true)
		else
			cb1:SetChecked(false)
		end

		local cb2 = CreateFrame("CheckButton", "filter_party", ns["pullcount"], "ChatConfigCheckButtonTemplate")
		cb2:SetPoint("TOPLEFT", cb1, "BOTTOMLEFT", 0, 0)
		filter_partyText:SetText("|cff5599ffplay sounds on countdowns from party chat|r")

		if LolzenUIcfg.pullcount["pull_filter_party"] == true then
			cb2:SetChecked(true)
		else
			cb2:SetChecked(false)
		end

		local cb3 = CreateFrame("CheckButton", "filter_instance", ns["pullcount"], "ChatConfigCheckButtonTemplate")
		cb3:SetPoint("TOPLEFT", cb2, "BOTTOMLEFT", 0, 0)
		filter_instanceText:SetText("|cff5599ffplay sounds on countdowns from instance chat|r")

		if LolzenUIcfg.pullcount["pull_filter_instance"] == true then
			cb3:SetChecked(true)
		else
			cb3:SetChecked(false)
		end

		local cb4 = CreateFrame("CheckButton", "filter_say", ns["pullcount"], "ChatConfigCheckButtonTemplate")
		cb4:SetPoint("TOPLEFT", cb3, "BOTTOMLEFT", 0, 0)
		filter_sayText:SetText("|cff5599ffplay sounds on countdowns from say chat|r")

		if LolzenUIcfg.pullcount["pull_filter_say"] == true then
			cb4:SetChecked(true)
		else
			cb4:SetChecked(false)
		end

		local cb5 = CreateFrame("CheckButton", "filter_channel", ns["pullcount"], "ChatConfigCheckButtonTemplate")
		cb5:SetPoint("TOPLEFT", cb4, "BOTTOMLEFT", 0, 0)
		filter_channelText:SetText("|cff5599ffplay sounds on countdowns from custom channels|r")

		if LolzenUIcfg.pullcount["pull_filter_channel"] == true then
			cb5:SetChecked(true)
		else
			cb5:SetChecked(false)
		end

		ns["pullcount"].okay = function(self)
			LolzenUIcfg.pullcount["pull_count_range"] = tonumber(pull_count_range:GetText())
			LolzenUIcfg.pullcount["pull_msg_count"] = pull_message_countdown:GetText()
			LolzenUIcfg.pullcount["pull_msg_now"] = pull_message:GetText()
			LolzenUIcfg.pullcount["pull_sound_1"] = pull_sound_count[1].eb:GetText()
			LolzenUIcfg.pullcount["pull_sound_2"] = pull_sound_count[2].eb:GetText()
			LolzenUIcfg.pullcount["pull_sound_3"] = pull_sound_count[3].eb:GetText()
			LolzenUIcfg.pullcount["pull_sound_4"] = pull_sound_count[4].eb:GetText()
			LolzenUIcfg.pullcount["pull_sound_5"] = pull_sound_count[5].eb:GetText()
			LolzenUIcfg.pullcount["pull_sound_6"] = pull_sound_count[6].eb:GetText()
			LolzenUIcfg.pullcount["pull_sound_7"] = pull_sound_count[7].eb:GetText()
			LolzenUIcfg.pullcount["pull_sound_8"] = pull_sound_count[8].eb:GetText()
			LolzenUIcfg.pullcount["pull_sound_9"] = pull_sound_count[9].eb:GetText()
			LolzenUIcfg.pullcount["pull_sound_10"] = pull_sound_count[10].eb:GetText()
			LolzenUIcfg.pullcount["pull_sound_pull"] = pull_now:GetText()
			if cb1:GetChecked(true) then
				LolzenUIcfg.pullcount["pull_filter_guild"] = true
			else
				LolzenUIcfg.pullcount["pull_filter_guild"] = false
			end
			if cb2:GetChecked(true) then
				LolzenUIcfg.pullcount["pull_filter_party"] = true
			else
				LolzenUIcfg.pullcount["pull_filter_party"] = false
			end
			if cb3:GetChecked(true) then
				LolzenUIcfg.pullcount["pull_filter_instance"] = true
			else
				LolzenUIcfg.pullcount["pull_filter_instance"] = false
			end
			if cb4:GetChecked(true) then
				LolzenUIcfg.pullcount["pull_filter_say"] = true
			else
				LolzenUIcfg.pullcount["pull_filter_say"] = false
			end
			if cb5:GetChecked(true) then
				LolzenUIcfg.pullcount["pull_filter_channel"] = true
			else
				LolzenUIcfg.pullcount["pull_filter_channel"] = false
			end
		end

		ns["pullcount"].default = function(self)
			LolzenUIcfg.pullcount["pull_count_range"] = 3
			LolzenUIcfg.pullcount["pull_msg_count"] = "Pull in !n"
			LolzenUIcfg.pullcount["pull_msg_now"] = ">> Pull Now <<"
			LolzenUIcfg.pullcount["pull_sound_1"] = "one.mp3"
			LolzenUIcfg.pullcount["pull_sound_2"] = "two.mp3"
			LolzenUIcfg.pullcount["pull_sound_3"] = "three.mp3"
			LolzenUIcfg.pullcount["pull_sound_4"] = "four.mp3"
			LolzenUIcfg.pullcount["pull_sound_5"] = "five.mp3"
			LolzenUIcfg.pullcount["pull_sound_6"] = "six.mp3"
			LolzenUIcfg.pullcount["pull_sound_7"] = "seven.mp3"
			LolzenUIcfg.pullcount["pull_sound_8"] = "eight.mp3"
			LolzenUIcfg.pullcount["pull_sound_9"] = "nine.mp3"
			LolzenUIcfg.pullcount["pull_sound_10"] = "ten.mp3"
			LolzenUIcfg.pullcount["pull_sound_pull"] = "Play.mp3"
			LolzenUIcfg.pullcount["pull_filter_guild"] = true
			LolzenUIcfg.pullcount["pull_filter_party"] = true
			LolzenUIcfg.pullcount["pull_filter_instance"] = true
			LolzenUIcfg.pullcount["pull_filter_say"] = false
			LolzenUIcfg.pullcount["pull_filter_channel"] = true
			ReloadUI()
		end
	end
end)