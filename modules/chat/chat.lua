--// chat // --
-- Position and size of the chat frames are handled by the Edit Mode.

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("chat", L["desc_chat"], true)

local cfg
local styledFrames = {}
local origAddMessage = {}
local urlFormat

--[[ channel stamps & flags ]]-------------------------------------------------

local STAMPS = {
	CHAT_GUILD_GET = "|Hchannel:Guild|hG| |h %s:\32",
	CHAT_RAID_GET = "|Hchannel:raid|hR| |h %s:\32",
	CHAT_PARTY_GET = "|Hchannel:Party|hP| |h %s:\32",
	CHAT_PARTY_LEADER_GET = "|Hchannel:party|hP| |h %s:\32",
	CHAT_PARTY_GUIDE_GET = "|Hchannel:party|hP| |h %s:\32",
	CHAT_RAID_WARNING_GET = "RW| %s:\32",
	CHAT_RAID_LEADER_GET = "|Hchannel:raid|hRL| |h %s:\32",
	CHAT_OFFICER_GET = "|Hchannel:o|hO| |h %s:\32",
	CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|hBG| |h %s:\32",
	CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|hBGL| |h %s:\32",
	CHAT_INSTANCE_CHAT_GET = "|Hchannel:INSTANCE_CHAT|hI| |h %s:\32",
	CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:INSTANCE_CHAT|hIL| |h %s:\32",
	CHAT_SAY_GET = "%s says:\32",
	CHAT_YELL_GET = "%s yells:\32",
	CHAT_WHISPER_GET = "W| >> %s:\32",
	CHAT_WHISPER_INFORM_GET = "W| << %s:\32",
}
local originalStamps = {}

local function applyChannelStamps()
	for key, stamp in pairs(STAMPS) do
		if originalStamps[key] == nil then
			originalStamps[key] = _G[key]
		end
		_G[key] = cfg["chat_custom_channel_stamps"] and stamp or originalStamps[key]
	end
end

local function applyFlags()
	CHAT_FLAG_AFK = cfg["chat_flag_afk"].." "
	CHAT_FLAG_DND = cfg["chat_flag_dnd"].." "
end

local STICKY = {
	chat_sticky_say = "SAY",
	chat_sticky_yell = "YELL",
	chat_sticky_party = "PARTY",
	chat_sticky_guild = "GUILD",
	chat_sticky_officer = "OFFICER",
	chat_sticky_raid = "RAID",
	chat_sticky_raidwarning = "RAID_WARNING",
	chat_sticky_whisper = "WHISPER",
	chat_sticky_channel = "CHANNEL",
}

local function applySticky()
	for key, chatType in pairs(STICKY) do
		if ChatTypeInfo[chatType] then
			ChatTypeInfo[chatType].sticky = cfg[key] and 1 or 0
		end
	end
end

--[[ message filter ]]---------------------------------------------------------

local function updateURLFormat()
	local color = cfg["chat_link_color"]
	urlFormat = ("|cff%02x%02x%02x|Haddon:LolzenUI:url:%%1|h%%1|h|r"):format(color[1] * 255, color[2] * 255, color[3] * 255)
end

local function modifyMessage(text)
	if cfg["chat_strip_say_and_yell"] then
		text = text:gsub("|Hplayer:([^%|]+)|h(.+)|h says:", "|Hplayer:%1|h%2|h:")
		text = text:gsub("|Hplayer:([^%|]+)|h(.+)|h yells:", "|Hplayer:%1|h%2|h:")
	end
	if cfg["chat_strip_brackets"] then
		text = text:gsub("|H(.-)|h%[(.-)%]|h", "|H%1|h%2|h")
	end
	if cfg["chat_shorten_channels"] then
		text = text:gsub("|h(%d+)%. .-|h", "|h%1.|h")
	end
	-- don't add a second timestamp if Blizzard's timestamps are active
	if cfg["chat_timestamp"] and GetCVar("showTimestamps") == "none" then
		text = "|cff888888"..date("%H.%M").."| |r "..text
	end
	return (text:gsub("([wWhH][wWtT][wWtT][%.pP]%S+[^%p%s])", urlFormat))
end

local function addMessage(self, text, ...)
	-- 12.0: messages can be secret, those must be passed through untouched
	if type(text) == "string" and not ns.IsSecret(text) then
		text = modifyMessage(text)
	end
	return origAddMessage[self](self, text, ...)
end

-- clicking an url puts it into the editbox so it can be copied
local function onItemRef(...)
	for i = 1, select("#", ...) do
		local link = select(i, ...)
		if type(link) == "string" and link:sub(1, 18) == "addon:LolzenUI:url" then
			local url = link:sub(20)
			local editBox = ChatEdit_ChooseBoxForSend and ChatEdit_ChooseBoxForSend() or ChatFrame1EditBox
			if ChatEdit_ActivateChat then
				ChatEdit_ActivateChat(editBox)
			else
				editBox:Show()
				editBox:SetFocus()
			end
			editBox:SetText(url)
			editBox:HighlightText()
			return
		end
	end
end

-- show afk/dnd auto replies only once per person
local lastAutoReply = {}
local function autoReplyFilter(_, _, msg, sender)
	if not cfg["chat_show_afkdnd_once"] or ns.IsSecret(msg) or ns.IsSecret(sender) then return end
	if lastAutoReply[sender] == msg then
		return true
	end
	lastAutoReply[sender] = msg
end

--[[ chat frames ]]------------------------------------------------------------

local function applyFont(cf)
	ns.SetFont(cf, cfg["chat_font"], cfg["chat_font_size"], cfg["chat_font_flag"])
	if cfg["chat_font_shadow"] then
		cf:SetShadowOffset(1, -1)
	else
		cf:SetShadowOffset(0, 0)
	end
	cf:SetSpacing(cfg["chat_font_spacing"])
	cf:SetFading(not cfg["chat_disable_fading"])
end

local function applyBackground(cf)
	local show = cfg["chat_background"]
	cf.LolzenBG:SetTexture(LSM:Fetch("background", cfg["chat_background_texture"]))
	cf.LolzenBG:SetVertexColor(0, 0, 0, cfg["chat_background_alpha"])
	cf.LolzenBG:SetShown(show)

	local useOutline = cfg["chat_outline"]
	if useOutline then
		ns.Outline.Create(cf, {size = 18, padding = 5})
	end
	if cf.LolzenOutline then
		cf.LolzenOutline:SetShown(show and useOutline)
	end

	if not useOutline and not cf.LolzenBorder then
		cf.LolzenBorder = CreateFrame("Frame", nil, cf, "BackdropTemplate")
		cf.LolzenBorder:SetPoint("BOTTOMLEFT", cf, -5, -5)
		cf.LolzenBorder:SetPoint("TOPRIGHT", cf, 5, 5)
	end
	if cf.LolzenBorder then
		cf.LolzenBorder:SetBackdrop({edgeFile = LSM:Fetch("border", cfg["chat_background_border"]), edgeSize = 16})
		cf.LolzenBorder:SetBackdropBorderColor(0, 0, 0)
		cf.LolzenBorder:SetShown(show and not useOutline)
	end
end

local function hideTexture(texture)
	if texture then
		texture:SetAlpha(0)
	end
end

local function styleFrame(cf)
	if styledFrames[cf] then return end
	styledFrames[cf] = true
	local name = cf:GetName()

	-- editbox without textures, above the chat
	local eb = _G[name.."EditBox"]
	if eb then
		hideTexture(_G[name.."EditBoxLeft"])
		hideTexture(_G[name.."EditBoxMid"])
		hideTexture(_G[name.."EditBoxRight"])
		hideTexture(eb.focusLeft)
		hideTexture(eb.focusMid)
		hideTexture(eb.focusRight)
		eb:ClearAllPoints()
		eb:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", -5, 20)
		eb:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 5, 20)
		eb:SetAltArrowKeyMode(false)
	end

	for _, textureName in ipairs(CHAT_FRAME_TEXTURES or {}) do
		local texture = _G[name..textureName]
		if texture then
			texture:SetTexture(nil)
			texture:Hide()
		end
	end

	if cf.ScrollToBottomButton then
		ns.Kill(cf.ScrollToBottomButton)
	end
	if cf.ScrollBar then
		ns.Kill(cf.ScrollBar)
	end

	-- the combat log formats its own messages
	if cf ~= ChatFrame2 and not origAddMessage[cf] then
		origAddMessage[cf] = cf.AddMessage
		cf.AddMessage = addMessage
	end

	cf.LolzenBG = cf:CreateTexture(nil, "BACKGROUND")
	cf.LolzenBG:SetPoint("BOTTOMLEFT", cf, -2, -2)
	cf.LolzenBG:SetPoint("TOPRIGHT", cf, 2, 2)

	applyFont(cf)
	applyBackground(cf)
end

local function forEachFrame(func)
	for cf in pairs(styledFrames) do
		func(cf)
	end
end

local function styleAll()
	for _, frameName in ipairs(CHAT_FRAMES) do
		local cf = _G[frameName]
		if cf then
			styleFrame(cf)
		end
	end
end

-- compatibility with the old option callbacks
function ns.SetChatFont() forEachFrame(applyFont) end
ns.SetChatShadow = ns.SetChatFont
ns.SetChatFading = ns.SetChatFont
function ns.SetChatBackgroundVisible() forEachFrame(applyBackground) end
ns.SetChatBackgroundTexture = ns.SetChatBackgroundVisible
ns.SetChatBackgroundAlpha = ns.SetChatBackgroundVisible
ns.SetChatBackgroundBorder = ns.SetChatBackgroundVisible

local function applyBehaviour()
	applyChannelStamps()
	applyFlags()
	applySticky()
	updateURLFormat()
end

ns.OnInit("chat", function()
	cfg = LolzenUIcfg.chat
	applyBehaviour()

	-- appearance: attached to the chat frame dialog in the Edit Mode
	local look = ns.Options.New("chat_look", function() return LolzenUIcfg.chat end, ns.defaults.chat, function()
		ns.SetChatFont()
		ns.SetChatBackgroundVisible()
	end)
	look:Header(L["font"])
	look:FontGroup("chat_font", nil, "chat_font_size", "chat_font_flag")
	look:Toggle("chat_font_shadow", L["chat_font_shadow"])
	look:Range("chat_font_spacing", L["spacing"], 0, 10, 1)
	look:Toggle("chat_disable_fading", L["chat_disable_fading"])
	look:Header(L["background"])
	look:Toggle("chat_background", L["chat_background"])
	look:Media("chat_background_texture", L["texture"], "background")
	look:Range("chat_background_alpha", L["alpha"], 0, 1, 0.05)
	look:Toggle("chat_outline", L["Use outline"])
	look:Media("chat_background_border", L["border"], "border"):SetDisabled(function() return cfg["chat_outline"] end)
	if not ns.EditMode:AddSystemSettings("ChatFrame", look) then
		ns.SettingsPanel:AddCategory("chat_look", look)
	end

	-- behaviour: settings panel
	local options = ns.Options.New("chat", function() return LolzenUIcfg.chat end, ns.defaults.chat, applyBehaviour)
	options:Header(L["text"])
	options:Toggle("chat_custom_channel_stamps", L["chat_short_chatstamps"])
	options:Toggle("chat_strip_brackets", L["chat_strip_brackets"])
	options:Toggle("chat_strip_say_and_yell", L["chat_strip_say_and_yell"])
	options:Toggle("chat_shorten_channels", L["chat_short_channel_names"])
	options:Toggle("chat_timestamp", L["chat_show_timestamps"]):SetDesc(L["Only used while Blizzard's timestamps are disabled."])
	options:Toggle("chat_show_afkdnd_once", L["chat_afk_dnd_once"])
	options:Color("chat_link_color", L["chat_header_link_color"])
	options:Header(L["chat_header_flags_and_sticky_channels"])
	options:Text("chat_flag_afk", L["afk_flag"])
	options:Text("chat_flag_dnd", L["dnd_flag"])
	for key in pairs(STICKY) do
		options:Toggle(key, L[key])
	end
	ns.SettingsPanel:AddCategory("chat", options, true)

	ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", autoReplyFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", autoReplyFilter)
	EventRegistry:RegisterCallback("SetItemRef", onItemRef)
end)

ns.OnLogin("chat", function()
	styleAll()
	-- temporary whisper windows etc.
	hooksecurefunc("FCF_OpenTemporaryWindow", styleAll)

	-- shift + mousewheel jumps to the top/bottom
	if FloatingChatFrame_OnMouseScroll then
		hooksecurefunc("FloatingChatFrame_OnMouseScroll", function(self, delta)
			if IsShiftKeyDown() then
				if delta > 0 then
					self:ScrollToTop()
				else
					self:ScrollToBottom()
				end
			end
		end)
	end

	for _, button in ipairs({QuickJoinToastButton, ChatFrameMenuButton, ChatFrameChannelButton, ChatFrameToggleVoiceDeafenButton, ChatFrameToggleVoiceMuteButton}) do
		ns.Kill(button)
	end
end)
