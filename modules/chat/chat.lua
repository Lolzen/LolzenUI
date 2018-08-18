--// chat // --

local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("chat", "Modifies Chat look & feel", true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" and addon == "LolzenUI" then
		if LolzenUIcfg.modules["chat"] == false then return end
		
		if LolzenUIcfg.chat["chat_custom_channel_stamps"] == true then
			CHAT_GUILD_GET = "|Hchannel:Guild|hG| |h %s:\32"
			CHAT_RAID_GET = "|Hchannel:raid|hR| |h %s:\32"
			CHAT_PARTY_GET = "|Hchannel:Party|hP| |h %s:\32"
			CHAT_PARTY_LEADER_GET = "|Hchannel:party|hP| |h %s:\32"
			CHAT_PARTY_GUIDE_GET = "|Hchannel:party|hP| |h %s:\32"
			CHAT_RAID_WARNING_GET = "RW| %s:\32"
			CHAT_RAID_LEADER_GET = "|Hchannel:raid|hRL| |h %s:\32"
			CHAT_OFFICER_GET = "|Hchannel:o|hO| |h %s:\32"
			CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|hBG| |h %s:\32"
			CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|hBGL| |h %s:\32"
			CHAT_SAY_GET = "%s:\32"
			CHAT_YELL_GET = "%s:\32"
			CHAT_WHISPER_GET = "W| >> %s:\32"
			CHAT_WHISPER_INFORM_GET = "W| << %s:\32"
		end
		CHAT_FLAG_AFK = LolzenUIcfg.chat["chat_flag_afk"].." "
		CHAT_FLAG_DND = LolzenUIcfg.chat["chat_flag_dnd"].." "

		local origs = {}

		local AddMessage = function(self, text, ...)
			if(type(text) == "string") then
				-- Strip yells: says: from chat
				if LolzenUIcfg.chat["chat_strip_say_and_yell"] == true then
					text = text:gsub("|Hplayer:([^%|]+)|h(.+)|h says:", "|Hplayer:%1|h%2|h:")
					text = text:gsub("|Hplayer:([^%|]+)|h(.+)|h yells:", "|Hplayer:%1|h%2|h:")
				end
				
				-- strip brackets from players, av's, item and spell links
				if LolzenUIcfg.chat["chat_strip_brackets"] == true then
					text = text:gsub("|H(.-)|h%[(.-)%]|h", "|H%1|h%2|h")
				end

				-- shorten channel names (implement option)
				text = text:gsub('|h(%d+)%. .-|h', '|h%1.|h')

				-- custom timestamp
				if LolzenUIcfg.chat["chat_timestamp"] == true then
					text = string.format("|cff888888"..date("%H.%M").."| |r %s", text)
				end
			end

			return origs[self](self, text, ...)
		end

		FloatingChatFrame_OnMouseScroll = function(self, dir)
			if dir > 0 then
				if IsShiftKeyDown() then
					self:ScrollToTop()
				else
					self:ScrollUp()
				end
			elseif dir < 0 then
				if IsShiftKeyDown() then
					self:ScrollToBottom()
				else
					self:ScrollDown()
				end
			end
		end

		local editboxTextures = {
			"EditBoxRight",
			"EditBoxLeft",
			"EditBoxMid"
		}

		local blacklist = {
			[ChatFrame2] = true,
		--	[ChatFrame4] = true,
		}

		for i=1, NUM_CHAT_WINDOWS do
			local cf = _G["ChatFrame"..i]
			local eb = _G["ChatFrame"..i.."EditBox"]
			local s2bb = cf["ScrollToBottomButton"]
			local sb = cf["ScrollBar"]
			local tt =_G["ChatFrame"..i.."ThumbTexture"]
			
			-- hide editbox textures and chat textures
			for k, v in pairs(editboxTextures) do
				_G["ChatFrame"..i..v]:SetAlpha(0)
			end
			eb.focusLeft:SetAlpha(0)
			eb.focusRight:SetAlpha(0)
			eb.focusMid:SetAlpha(0)

			for _, n in pairs(CHAT_FRAME_TEXTURES) do
				local t = _G['ChatFrame'..i..n]
				t:Hide()
				t.Show = function() end
			end

			cf:SetFont(LSM:Fetch("font", LolzenUIcfg.chat["chat_font"]), LolzenUIcfg.chat["chat_font_size"], LolzenUIcfg.chat["chat_font_flag"])
			if LolzenUIcfg.chat["chat_font_shadow"] == true then
				cf:SetShadowOffset(1, -1)
			end
			cf:SetSpacing(LolzenUIcfg.chat["chat_font_spacing"])

			-- disable fading out
			if LolzenUIcfg.chat["chat_disable_fading"] == true then
				cf:SetFading(false)
			end

			-- hide quickjointoasts and chat buttons
			-- TODO: do something to access 
			-- ChatFrameChannelButton, ChatFrameToggleVoiceDeafenButton and ChatFrameToggleVoiceMuteButton
			-- maybe unhide scrollbar and reshape/reskin
			QuickJoinToastButton:Hide()
			QuickJoinToastButton.Show = function() end

			ChatFrameMenuButton:Hide()
			ChatFrameMenuButton.Show = function() end

			ChatFrameChannelButton:Hide()
			ChatFrameChannelButton.Show = function() end

			ChatFrameToggleVoiceDeafenButton:Hide()
			ChatFrameToggleVoiceDeafenButton.Show = function() end

			ChatFrameToggleVoiceMuteButton:Hide()
			ChatFrameToggleVoiceMuteButton.Show = function() end

			tt:Hide()
			tt.Show = function() end

			s2bb:Hide()
			s2bb.Show = function() end

			sb:Hide()
			sb.Show = function() end

			-- move editbox above the chat
			eb:ClearAllPoints()
			eb:SetPoint("BOTTOMLEFT",  ChatFrame1, "TOPLEFT", -5, 20)
			eb:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 5, 20)
			eb:SetAltArrowKeyMode(false)

			if not blacklist[cf] then
				origs[cf] = cf.AddMessage
				cf.AddMessage = AddMessage
			end

			-- background
			if LolzenUIcfg.chat["chat_background"] == true then
				local bg = cf:CreateTexture("Background")
				bg:SetTexture(LSM:Fetch("background", LolzenUIcfg.chat["chat_background_texture"]))
				bg:SetVertexColor(0, 0, 0, LolzenUIcfg.chat["chat_background_alpha"])
				bg:SetPoint("BOTTOMLEFT", cf, -2, -2)
				bg:SetPoint("TOPRIGHT", cf, 2, 2)

				cf.border = CreateFrame("Frame", nil, cf)
				cf.border:SetPoint("BOTTOMLEFT", cf, -5, -5)
				cf.border:SetPoint("TOPRIGHT", cf, 5, 5)
				cf.border:SetBackdrop({
					edgeFile = LSM:Fetch("border", LolzenUIcfg.chat["chat_background_border"]), edgeSize = 16,
				})
				cf.border:SetBackdropBorderColor(0, 0, 0)
			end
		end

		ChatTypeInfo["SAY"].sticky = LolzenUIcfg.chat["chat_sticky_say"]
		ChatTypeInfo["YELL"].sticky = LolzenUIcfg.chat["chat_sticky_yell"]
		ChatTypeInfo["PARTY"].sticky = LolzenUIcfg.chat["chat_sticky_party"]
		ChatTypeInfo["GUILD"].sticky = LolzenUIcfg.chat["chat_sticky_guild"]
		ChatTypeInfo["OFFICER"].sticky = LolzenUIcfg.chat["chat_sticky_officer"]
		ChatTypeInfo["RAID"].sticky = LolzenUIcfg.chat["chat_sticky_raid"]
		ChatTypeInfo["RAID_WARNING"].sticky = LolzenUIcfg.chat["chat_sticky_raidwarning"]
		--ChatTypeInfo["INSTANCE_CHAT"].sticky = 1
		ChatTypeInfo["WHISPER"].sticky = LolzenUIcfg.chat["chat_sticky_whisper"]
		ChatTypeInfo["CHANNEL"].sticky = LolzenUIcfg.chat["chat_sticky_channel"]

		-- /who whispered me?
		local Who = {}
		local WhoEvent = function(msg, ...)
			local arg1, arg2, arg3 = ...
			if Who[arg3] == nil then
				SendWho(arg3)
				Who[arg3] = 1
			end
		end
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", WhoEvent)
		
		-- Show afk/dnd messages only one time (DontBugMe-like)
		local data = {}
		local chatEvent = function(msg, ...)
			local arg1, arg2 = ...
			if data[arg2] and data[arg2] == arg1 then
				return true
			else
				data[arg2] = arg1
			end
		end
		ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", chatEvent)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", chatEvent)
	elseif event == "PLAYER_ENTERING_WORLD" then
		if LolzenUIcfg.modules["chat"] == false then return end
		-- disable UI forced positioning
		FCF_ValidateChatFramePosition = function() end

		for i=1, NUM_CHAT_WINDOWS do
			local cf = _G["ChatFrame"..i]
			
			cf:SetClampedToScreen(false)
			if cf.isDocked then
				cf:ClearAllPoints()
				if i == 1 then
					cf:SetPoint(LolzenUIcfg.chat["chat_anchor1"], UIParent, LolzenUIcfg.chat["chat_anchor2"], LolzenUIcfg.chat["chat_posx"], LolzenUIcfg.chat["chat_posy"])
				else
					cf:SetAllPoints(_G["ChatFrame1"])
				end
			else
				if i == 1 then
					cf:ClearAllPoints()
					cf:SetPoint(LolzenUIcfg.chat["chat_anchor1"], UIParent, LolzenUIcfg.chat["chat_anchor2"], LolzenUIcfg.chat["chat_posx"], LolzenUIcfg.chat["chat_posy"])
				end
			end
		end
	end
end)