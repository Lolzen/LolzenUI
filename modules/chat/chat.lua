--// chat // --
-- based on oChat

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" and addon == "LolzenUI" then
		if LolzenUIcfg.modules["chat"] == false then return end
		
		CHAT_GUILD_GET = '|Hchannel:Guild|hG| |h %s:\32'
		CHAT_RAID_GET = "|Hchannel:raid|hR| |h %s:\32"
		CHAT_PARTY_GET = "|Hchannel:Party|hP| |h %s:\32"
		CHAT_PARTY_LEADER_GET = '|Hchannel:party|hP| |h %s:\32'
		CHAT_PARTY_GUIDE_GET = '|Hchannel:party|hP| |h %s:\32'
		CHAT_RAID_WARNING_GET = "RW| %s:\32"
		CHAT_RAID_LEADER_GET = "|Hchannel:raid|hRL| |h %s:\32"
		CHAT_OFFICER_GET = "|Hchannel:o|hO| |h %s:\32"
		CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|hBG| |h %s:\32"
		CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|hBGL| |h %s:\32"
		CHAT_SAY_GET = "%s:\32"
		CHAT_YELL_GET = "%s:\32"
		CHAT_WHISPER_GET = "W| >> %s:\32"
		CHAT_WHISPER_INFORM_GET = "W| << %s:\32"
		CHAT_FLAG_AFK = "AFK | "
		CHAT_FLAG_DND = "DND | "
		
		local origs = {}

		local AddMessage = function(self, text, ...)
			if(type(text) == "string") then
				-- Strip yells: says: from chat
				text = text:gsub("|Hplayer:([^%|]+)|h(.+)|h says:", "|Hplayer:%1|h%2|h:")
				text = text:gsub("|Hplayer:([^%|]+)|h(.+)|h yells:", "|Hplayer:%1|h%2|h:")
				
				-- strip brackets from players, av's, item and spell links
				text = text:gsub("|H(.-)|h%[(.-)%]|h", "|H%1|h%2|h")

				-- custom timestamp
				text = string.format("|cff888888"..date("%H.%M").."| |r"..text)
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

		local buttons = {
			"ButtonFrameUpButton",
			"ButtonFrameDownButton",
			"ButtonFrameBottomButton",
		}
		
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
			
			-- hide editbox textures, chat buttons and chat textures
			for k, v in pairs(editboxTextures) do
				_G["ChatFrame"..i..v]:SetAlpha(0)
			end
			eb.focusLeft:SetAlpha(0)
			eb.focusRight:SetAlpha(0)
			eb.focusMid:SetAlpha(0)
			
			for k, button in pairs(buttons) do
				button = _G["ChatFrame"..i..button]
				button:Hide()
				button.Show = function() end
			end

			for _, n in pairs(CHAT_FRAME_TEXTURES) do
				local t = _G['ChatFrame'..i..n]
				t:Hide()
				t.Show = function() end
			end

			cf:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 12)
			cf:SetShadowOffset(1, -1)
			cf:SetSpacing(1)

			-- disable fading out
			cf:SetFading(false)

			QuickJoinToastButton:Hide()
			QuickJoinToastButton.Show = function() end

			ChatFrameMenuButton:Hide()
			ChatFrameMenuButton.Show = function() end

			-- move editbox above the chat
			eb:ClearAllPoints()
			eb:SetPoint("BOTTOMLEFT",  ChatFrame1, "TOPLEFT", -5, 20)
			eb:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 5, 20)
			eb:SetAltArrowKeyMode(false)

			if not blacklist[cf] then
				origs[cf] = cf.AddMessage
				cf.AddMessage = AddMessage
			end
			
			
			--background
			local bg = cf:CreateTexture("Background")
			bg:SetTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
			bg:SetVertexColor(0, 0, 0, 0.5)
			--bg:SetAllPoints(cf)
			bg:SetPoint("BOTTOMLEFT", cf, -2, -2)
			bg:SetPoint("TOPRIGHT", cf, 2, 2)
			
			cf.border = CreateFrame("Frame", nil, cf)
			cf.border:SetPoint("BOTTOMLEFT", cf, -5, -5)
			cf.border:SetPoint("TOPRIGHT", cf, 5, 5)
			cf.border:SetBackdrop({
				edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 16,
			})
			cf.border:SetBackdropBorderColor(0, 0, 0)		
		end

		ChatTypeInfo["SAY"].sticky = 1
		ChatTypeInfo["YELL"].sticky = 0
		ChatTypeInfo["PARTY"].sticky = 1
		ChatTypeInfo["GUILD"].sticky = 1
		ChatTypeInfo["OFFICER"].sticky = 1
		ChatTypeInfo["RAID"].sticky = 1
		ChatTypeInfo["RAID_WARNING"].sticky = 1
		--ChatTypeInfo["INSTANCE_CHAT"].sticky = 1
		ChatTypeInfo["WHISPER"].sticky = 0
		ChatTypeInfo["CHANNEL"].sticky = 1
		
		-- /who whispered me? & Show afk/dnd messages only one time
		local Who = {}
		local status = {}
		local msgEvent = function(msg, ...)
			local arg1, arg2, arg3 = ...
			if Who[arg3] == nil then
				SendWho(arg3)
				Who[arg3] = 1
			end
			if status[arg2] and status[arg2] == arg1 then
				return true
			else
				status[arg2] = arg1
			end
		end
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", msgEvent)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", msgEvent)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", msgEvent)
	elseif event == "PLAYER_ENTERING_WORLD" then
		if LolzenUIcfg.modules["chat"] == false then return end
		-- disable UI forced positioning
		FCF_ValidateChatFramePosition = function() end

		for i=1, NUM_CHAT_WINDOWS do
			local cf = _G["ChatFrame"..i]
			cf:ClearAllPoints()
			cf:SetClampedToScreen(false)
			if i == 1 then
				cf:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 8, 15)
			else
				cf:SetAllPoints(_G["ChatFrame1"])
			end
		end
	end
end)