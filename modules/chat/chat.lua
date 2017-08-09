--// chat // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["chat"] == false then return end

		local type = type
		local tonumber = tonumber
		local string_split = string.split

		local _AddMessage = ChatFrame1.AddMessage
		local _SetItemRef = SetItemRef

		--"ButtonFrameMinimizeButton"
		local buttons = {"ButtonFrameUpButton", "ButtonFrameDownButton", "ButtonFrameBottomButton"}
		local dummy = function() end
		--local ts = "|cff737372|HoChat|h%s|h|r %s"
		local ts = "|cff737372|HoChat|h%s|h|||r %s"

		local origs = {}

		local blacklist = {
			[ChatFrame2] = true,
		--	[ChatFrame4] = true,
		}

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

		-- 1: index, 2: channelname, 3: twatt
		-- Examples are based on this: [1. Channel] Otravi: Hi
		--local str = "[%2$.3s] %s" -- gives: [Cha] Otravi: Hi
		--local str = "[%d. %2$.3s] %s" -- gives: [1. Cha] Otravi: Hi
		local str = "%d|h %3$s" -- gives: 1 Otravi: Hi
		local channel = function(...)
			return str:format(...)
		end

		--     BetterDate(format, time) 
		local AddMessage = function(self, text, ...)
			if(type(text) == "string") then
				text = text:gsub('|Hchannel:(%d+)|h%[?(.-)%]?|h.+(|Hplayer.+)', channel)

				text = ts:format(date"%H.%M", text)
			end

			return origs[self](self, text, ...)
		end

		local scroll = function(self, dir)
			if(dir > 0) then
				if(IsShiftKeyDown()) then
					self:ScrollToTop()
				else
					self:ScrollUp()
				end
			elseif(dir < 0) then
				if(IsShiftKeyDown()) then
					self:ScrollToBottom()
				else
					self:ScrollDown()
				end
			end
		end

		for i=1, NUM_CHAT_WINDOWS do
			local cf = _G["ChatFrame"..i]
			local eb = _G["ChatFrame"..i.."EditBox"]
			local ebr = _G["ChatFrame"..i.."EditBoxRight"]
			local ebl = _G["ChatFrame"..i.."EditBoxLeft"]
			local ebm = _G["ChatFrame"..i.."EditBoxMid"]

			cf:SetFont("Fonts\\ARIALN.ttf", 12, "THINOUTLINE")
			cf:SetShadowOffset(0, 0)

			cf:EnableMouseWheel(true)

			cf:SetFading(false)
			cf:SetScript("OnMouseWheel", scroll)

			for k, button in pairs(buttons) do
				button = _G["ChatFrame"..i..button]
				button:Hide()
				button.Show = dummy
			end

			for _, n in pairs(CHAT_FRAME_TEXTURES) do
				local t = _G['ChatFrame'..i..n]
				t:Hide()
				t.Show = dummy
			end

			QuickJoinToastButton:Hide()
			QuickJoinToastButton.Show = dummy

			ChatFrameMenuButton:Hide()
			ChatFrameMenuButton.Show = dummy

			eb:ClearAllPoints()
			eb:SetPoint("BOTTOMLEFT",  ChatFrame1, "TOPLEFT", -5, 20)
			eb:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 5, 20)
			eb:SetAltArrowKeyMode(false)
			--hide the editbox background
			ebl:SetAlpha(0)
			ebm:SetAlpha(0)
			ebr:SetAlpha(0)
			eb.focusLeft:SetAlpha(0)
			eb.focusRight:SetAlpha(0)
			eb.focusMid:SetAlpha(0)

			local a, b, c = select(6, eb:GetRegions())
			a:Hide(); b:Hide(); c:Hide()

			if(not blacklist[cf]) then
				origs[cf] = cf.AddMessage
				cf.AddMessage = AddMessage
			end
		end

		buttons = nil

		ChatTypeInfo['SAY'].sticky = 1
		ChatTypeInfo['YELL'].sticky = 0
		ChatTypeInfo['PARTY'].sticky = 1
		ChatTypeInfo['GUILD'].sticky = 1
		ChatTypeInfo['OFFICER'].sticky = 1
		ChatTypeInfo['RAID'].sticky = 1
		ChatTypeInfo['RAID_WARNING'].sticky = 1
		--ChatTypeInfo['INSTANCE_CHAT'].sticky = 1
		ChatTypeInfo['WHISPER'].sticky = 0
		ChatTypeInfo['CHANNEL'].sticky = 1

		-- Modified version of MouseIsOver from UIParent.lua
		local MouseIsOver = function(frame)
			local s = frame:GetParent():GetEffectiveScale()
			local x, y = GetCursorPosition()
			x = x / s
			y = y / s

			local left = frame:GetLeft()
			local right = frame:GetRight()
			local top = frame:GetTop()
			local bottom = frame:GetBottom()

			-- Hack to fix a symptom not the real issue
			if(not left) then
				return
			end

			if((x > left and x < right) and (y > bottom and y < top)) then
				return 1
			else
				return
			end
		end

		local borderManipulation = function(...)
			for l = 1, select("#", ...) do
				local obj = select(l, ...)
				if(obj:GetObjectType() == "FontString" and MouseIsOver(obj)) then
					return obj:GetText()
				end
			end
		end

		SetItemRef = function(link, text, button, ...)
			if(link:sub(1, 5) ~= "oChat") then return _SetItemRef(link, text, button, ...) end

			local text = borderManipulation(SELECTED_CHAT_FRAME:GetRegions())
			if(text) then
				local link = GetFixedLink(text)

				for i=1, NUM_CHAT_WINDOWS do
					local eb = _G["ChatFrame"..i.."EditBox"]

					eb:Insert(link)
					eb:Show()
					eb:HighlightText()
					eb:SetFocus()
				end
			end
		end

		local dummy = function() return end

		-- disable UI forced positioning
		FCF_ValidateChatFramePosition = function() end

		local f = CreateFrame("Frame")
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", function(self)
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
		end)

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
			if(data[arg2] and data[arg2] == arg1)then
				return true
			else
				data[arg2] = arg1
			end
		end

		ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", chatEvent)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", chatEvent)
	end
end)