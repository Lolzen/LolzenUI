--// chattabs // --
-- this is Fane from haste (see LICENCE)

local _, ns = ...

local SELECTED = {0.14, 0.7, 0.7}
local function nop() end

local TAB_TEXTURES = {
	"Left", "Middle", "Right",
	"ActiveLeft", "ActiveMiddle", "ActiveRight",
	"HighlightLeft", "HighlightMiddle", "HighlightRight",
}

local function updateFS(tab, larger, flags, r, g, b)
	local fontString = tab:GetFontString()
	if not fontString then return end
	local font, size = GameFontNormalSmall:GetFont()
	fontString:SetFont(font, larger and size + 1 or size, flags or "")
	if r then
		fontString:SetTextColor(r, g, b)
	end
end

local function isFlashing(tab)
	local flash = _G["ChatFrame"..tab:GetID().."TabFlash"]
	return flash and flash:IsShown()
end

local function onEnter(tab)
	updateFS(tab, isFlashing(tab), "OUTLINE", unpack(SELECTED))
end

local function onLeave(tab)
	local r, g, b
	if _G["ChatFrame"..tab:GetID()] == SELECTED_CHAT_FRAME then
		r, g, b = unpack(SELECTED)
	elseif isFlashing(tab) then
		r, g, b = 1, 0, 0
	else
		r, g, b = 1, 1, 1
	end
	updateFS(tab, isFlashing(tab), nil, r, g, b)
end

local function styleTab(tab)
	if not tab then return end
	if not tab.lolzenStyled then
		tab.lolzenStyled = true
		for _, key in ipairs(TAB_TEXTURES) do
			local texture = tab[key]
			if texture then
				texture:SetTexture(nil)
			end
		end
		tab:HookScript("OnEnter", onEnter)
		tab:HookScript("OnLeave", onLeave)
		-- keep the tabs visible instead of fading them with the chat
		tab:SetAlpha(1)
		tab.SetAlpha = nop
	end

	if SELECTED_CHAT_FRAME and tab:GetID() == SELECTED_CHAT_FRAME:GetID() then
		updateFS(tab, nil, nil, unpack(SELECTED))
	else
		updateFS(tab, nil, nil, 1, 1, 1)
	end
end

ns.OnLogin("chat", function()
	for _, frameName in ipairs(CHAT_FRAMES) do
		styleTab(_G[frameName.."Tab"])
	end

	if FCFTab_UpdateColors then
		hooksecurefunc("FCFTab_UpdateColors", styleTab)
	end
	if FCF_StartAlertFlash then
		hooksecurefunc("FCF_StartAlertFlash", function(frame)
			updateFS(_G["ChatFrame"..frame:GetID().."Tab"], true, nil, 1, 0, 0)
		end)
	end
end)
