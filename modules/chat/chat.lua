--// chat // --

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("chat", L["desc_chat"], true)

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

		local function RGBPercToHex(text, r, g, b)
			return string.format("|cff%02x%02x%02x%s|r", r*255, g*255, b*255, text)
		end

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

				-- shorten channel names
				if LolzenUIcfg.chat["chat_shorten_channels"] == true then
					text = text:gsub('|h(%d+)%. .-|h', '|h%1.|h')
				end

				-- custom timestamp
				if LolzenUIcfg.chat["chat_timestamp"] == true then
					text = string.format("|cff888888"..date("%H.%M").."| |r %s", text)
				end

				-- url
				text = text:gsub("([wWhH][wWtT][wWtT][%.pP]%S+[^%p%s])", string.format("|cff%02x%02x%02x%s|r", LolzenUIcfg.chat["chat_link_color"][1]*255, LolzenUIcfg.chat["chat_link_color"][2]*255, LolzenUIcfg.chat["chat_link_color"][3]*255, "|Hurl:%1|h%1|h"))
			end

			return origs[self](self, text, ...)
		end

		local oSetItemRef = SetItemRef
		local function LolzenSetItemRef(link, ...)
			if strsub(link, 1, 3) == "url" then
				local url = strsub(link, 5)
				local eb = LAST_ACTIVE_CHAT_EDIT_BOX or ChatFrame1EditBox
				if not eb then return end
				eb:SetText(url)
				eb:SetFocus()
				eb:HighlightText()
				if not eb:IsShown() then
					eb:Show()
				end
			else
				return oSetItemRef(link, ...)
			end
		end
		SetItemRef = LolzenSetItemRef

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
			"EditBoxMid",
		--	"Background"
		}

		local blacklist = {
			[ChatFrame2] = true,
		--	[ChatFrame4] = true,
		}

		for i=1, NUM_CHAT_WINDOWS do
			local cf = _G["ChatFrame"..i]
			local eb = _G["ChatFrame"..i.."EditBox"]
		--	local s2bb = cf["ScrollToBottomButton"]
		--	local sb = cf["ScrollBar"]
	--		local tt =_G["ChatFrame"..i.."ThumbTexture"]
			local up = _G["ChatFrame"..i.."ButtonFrameUpButton"]
			local down = _G["ChatFrame"..i.."ButtonFrameDownButton"]
			local bottom = _G["ChatFrame"..i.."ButtonFrameBottomButton"]
			
			-- hide editbox textures and chat textures
			for k, v in pairs(editboxTextures) do
				_G["ChatFrame"..i..v]:SetAlpha(0)
			end
		--	eb.focusLeft:SetAlpha(0)
		--	eb.focusRight:SetAlpha(0)
		--	eb.focusMid:SetAlpha(0)
	--	cf.Background:Hide()

		--	for _, n in pairs(CHAT_FRAME_TEXTURES) do
		--		local t = _G['ChatFrame'..i..n]
		--		t:Hide()
		--		t.Show = function() end
		--	end

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
	--		QuickJoinToastButton:Hide()
	--		QuickJoinToastButton.Show = function() end

			ChatFrameMenuButton:Hide()
			ChatFrameMenuButton.Show = function() end

			ChatFrameChannelButton:Hide()
			ChatFrameChannelButton.Show = function() end

	--		ChatFrameToggleVoiceDeafenButton:Hide()
	--		ChatFrameToggleVoiceDeafenButton.Show = function() end

	--		ChatFrameToggleVoiceMuteButton:Hide()
	--		ChatFrameToggleVoiceMuteButton.Show = function() end

		--	tt:Hide()
		--	tt.Show = function() end

		--	s2bb:Hide()
		--	s2bb.Show = function() end

		--	sb:Hide()
		--	sb.Show = function() end

			up:Hide()
			up.Show = function() end

			down:Hide()
			down.Show = function() end

			bottom:Hide()
			bottom.Show = function() end

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

		if LolzenUIcfg.chat["chat_sticky_say"] == true then
			ChatTypeInfo["SAY"].sticky = 1
		else
			ChatTypeInfo["SAY"].sticky = 0
		end
		if LolzenUIcfg.chat["chat_sticky_yell"] == true then
			ChatTypeInfo["YELL"].sticky = 1
		else
			ChatTypeInfo["YELL"].sticky = 0
		end
		if LolzenUIcfg.chat["chat_sticky_party"] == true then
			ChatTypeInfo["PARTY"].sticky = 1
		else
			ChatTypeInfo["PARTY"].sticky = 0
		end
		if LolzenUIcfg.chat["chat_sticky_guild"] == true then
			ChatTypeInfo["GUILD"].sticky = 1
		else
			ChatTypeInfo["GUILD"].sticky = 0
		end
		if LolzenUIcfg.chat["chat_sticky_officer"] == true then
			ChatTypeInfo["OFFICER"].sticky = 1
		else
			ChatTypeInfo["OFFICER"].sticky = 0
		end
		if LolzenUIcfg.chat["chat_sticky_raid"] == true then
			ChatTypeInfo["RAID"].sticky = 1
		else
			ChatTypeInfo["RAID"].sticky = 0
		end
		if LolzenUIcfg.chat["chat_sticky_raidwarning"] == true then
			ChatTypeInfo["RAID_WARNING"].sticky = 1
		else
			ChatTypeInfo["RAID_WARNING"].sticky = 0
		end
		if LolzenUIcfg.chat["chat_sticky_whisper"] == true then
			ChatTypeInfo["WHISPER"].sticky = 1
		else
			ChatTypeInfo["WHISPER"].sticky = 0
		end
		if LolzenUIcfg.chat["chat_sticky_channel"] == true then
			ChatTypeInfo["CHANNEL"].sticky = 1
		else
			ChatTypeInfo["CHANNEL"].sticky = 0
		end

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
		
		-- Disable LolzenUI chatstamps if blizzard chatstamps are activated
		--	if GetCVar("showTimestamps") ~= "none" then
		--		LolzenUIcfg.chat["chat_timestamp"] = false
		--	end
	
	--	hooksecurefunc("InterfaceOptionsSocialPanelTimestamps_OnClick", function(self)
	--		if GetCVar("showTimestamps") ~= "none" then
				LolzenUIcfg.chat["chat_timestamp"] = true
	--		end
	--	end)
	elseif event == "PLAYER_ENTERING_WORLD" then
		if LolzenUIcfg.modules["chat"] == false then return end
		-- disable UI forced positioning
		FCF_ValidateChatFramePosition = function() end

		for i=1, NUM_CHAT_WINDOWS do
			local cf = _G["ChatFrame"..i]
			
			cf:SetClampedToScreen(false)
			if cf.isDocked then
				if i == 1 then
					cf:SetMovable(true)
					cf:SetUserPlaced(true)
					cf:ClearAllPoints()
					cf:SetPoint(LolzenUIcfg.chat["chat_anchor1"], UIParent, LolzenUIcfg.chat["chat_anchor2"], LolzenUIcfg.chat["chat_posx"], LolzenUIcfg.chat["chat_posy"])
				end
			else
				if i == 1 then
					cf:SetMovable(true)
					cf:SetUserPlaced(true)
					cf:ClearAllPoints()
					cf:SetPoint(LolzenUIcfg.chat["chat_anchor1"], UIParent, LolzenUIcfg.chat["chat_anchor2"], LolzenUIcfg.chat["chat_posx"], LolzenUIcfg.chat["chat_posy"])
				end
			end
		end
	end
end)