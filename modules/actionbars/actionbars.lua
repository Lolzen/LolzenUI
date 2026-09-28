--// actionbars //--
-- Skins the action buttons. Positions and layout of the bars are handled by Blizzard's Edit Mode,
-- the skin options are attached to the action bar dialog in the Edit Mode.

local _, ns = ...
local L = ns.L
local LBT = LibStub("LibButtonTexture-1.0")

ns.RegisterModule("actionbars", L["desc_actionbars"], true)

local BUTTON_PREFIXES = {
	"ActionButton",
	"MultiBarBottomLeftButton",
	"MultiBarBottomRightButton",
	"MultiBarLeftButton",
	"MultiBarRightButton",
	"MultiBar5Button",
	"MultiBar6Button",
	"MultiBar7Button",
	"PetActionButton",
	"StanceButton",
	"OverrideActionBarButton",
	"ExtraActionButton",
}

local cfg
local buttons = {}

local function applyTextures(button)
	local normal = cfg["actionbar_normal_texture"]
	button:SetNormalTexture(LBT:Fetch("border", normal))
	button:SetCheckedTexture(LBT:Fetch("checked", cfg["actionbar_checked_texture"]))
	button:SetHighlightTexture(LBT:Fetch("hover", cfg["actionbar_hover_texture"]))
	button:SetPushedTexture(LBT:Fetch("pushed", cfg["actionbar_pushed_texture"]))

	local flash = button.Flash
	if flash then
		flash:SetTexture(LBT:Fetch("flashing", cfg["actionbar_flash_texture"]))
	end

	local normalTexture = button:GetNormalTexture()
	if normalTexture then
		normalTexture:ClearAllPoints()
		if normal == "Blizzard QuickSlot2" and button.icon then
			normalTexture:SetPoint("TOPLEFT", button.icon, "TOPLEFT", -14, 14)
			normalTexture:SetPoint("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT", 15, -15)
		else
			normalTexture:SetAllPoints(button)
		end
	end

	local pushed = button:GetPushedTexture()
	if pushed then
		pushed:SetAllPoints(button)
	end
end

local function applyKeybind(button)
	local hotkey = button.HotKey
	if hotkey then
		hotkey:SetAlpha(cfg["actionbar_show_keybinds"] and 1 or 0)
	end
end

local function styleButton(button)
	local icon = button.icon or button.Icon
	if icon then
		-- square icons instead of the rounded mask
		if button.IconMask then
			icon:RemoveMaskTexture(button.IconMask)
		end
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
		icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	end

	local cooldown = button.cooldown or button.Cooldown
	if cooldown then
		cooldown:ClearAllPoints()
		cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
		cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	end

	if button.Name then
		button.Name:SetAlpha(0)
	end
	if button.FloatingBG then
		button.FloatingBG:Hide()
	end
	if button.AutoCastable then
		button.AutoCastable:SetAlpha(0)
	end

	applyTextures(button)
	applyKeybind(button)
end

local function restyle(button)
	-- Blizzard resets the button art on layout changes (e.g. in the Edit Mode)
	applyTextures(button)
end

local function forEachButton(func)
	for i = 1, #buttons do
		func(buttons[i])
	end
end

local function collectButtons()
	for _, prefix in ipairs(BUTTON_PREFIXES) do
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local button = _G[prefix..i]
			if button and not button.lolzenStyled then
				button.lolzenStyled = true
				buttons[#buttons + 1] = button
				styleButton(button)
				if button.UpdateButtonArt then
					hooksecurefunc(button, "UpdateButtonArt", restyle)
				end
			end
		end
	end
end

--[[ fade out of combat ]]------------------------------------------------------

local FADE_BARS = {
	"MainMenuBar", "MainActionBar", "MultiBarBottomLeft", "MultiBarBottomRight",
	"MultiBarRight", "MultiBarLeft", "MultiBar5", "MultiBar6", "MultiBar7",
}
local fadeBars = {}
local fadeFrame

local function updateFade()
	local faded = cfg["actionbar_fade_ooc"] and not InCombatLockdown() and not ns.EditMode:IsActive()
	local alpha = cfg["actionbar_fade_alpha"]
	for bar in pairs(fadeBars) do
		bar:SetAlpha((faded and not bar:IsMouseOver()) and alpha or 1)
	end
end

local function onEnterBar(self)
	local bar = fadeBars[self] and self or self:GetParent()
	if fadeBars[bar] then
		bar:SetAlpha(1)
	end
end

local function onLeaveBar()
	-- the mouse may have moved to another button of the same bar
	C_Timer.After(0.1, updateFade)
end

local function setupFade()
	if fadeFrame then
		return updateFade()
	end
	fadeFrame = CreateFrame("Frame")
	fadeFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	fadeFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	fadeFrame:SetScript("OnEvent", updateFade)
	ns.EditMode:RegisterCallback("enter", updateFade)
	ns.EditMode:RegisterCallback("exit", updateFade)

	for _, name in ipairs(FADE_BARS) do
		local bar = _G[name]
		if bar and not fadeBars[bar] then
			fadeBars[bar] = true
			bar:HookScript("OnEnter", onEnterBar)
			bar:HookScript("OnLeave", onLeaveBar)
		end
	end
	for i = 1, #buttons do
		local button = buttons[i]
		if fadeBars[button:GetParent()] then
			button:HookScript("OnEnter", onEnterBar)
			button:HookScript("OnLeave", onLeaveBar)
		end
	end
	updateFade()
end

function ns.SetActionBarFade()
	if cfg["actionbar_fade_ooc"] or fadeFrame then
		setupFade()
	end
end

function ns.SetActionBarTheme()
	forEachButton(applyTextures)
end

function ns.SetActionBarKeyBindToggle()
	forEachButton(applyKeybind)
end

ns.OnInit("actionbars", function()
	cfg = LolzenUIcfg.actionbar

	local options = ns.Options.New("actionbar", function() return LolzenUIcfg.actionbar end, ns.defaults.actionbar)
	options:Header("LolzenUI")
	options:Toggle("actionbar_show_keybinds", L["ab_keybinds"], ns.SetActionBarKeyBindToggle)
	options:ButtonTexture("actionbar_normal_texture", L["ab_normaltexture"], "border", ns.SetActionBarTheme)
	options:ButtonTexture("actionbar_flash_texture", L["ab_flashtexture"], "flashing", ns.SetActionBarTheme)
	options:ButtonTexture("actionbar_checked_texture", L["ab_checkedtexture"], "checked", ns.SetActionBarTheme)
	options:ButtonTexture("actionbar_hover_texture", L["ab_hovertexture"], "hover", ns.SetActionBarTheme)
	options:ButtonTexture("actionbar_pushed_texture", L["ab_pushedtexture"], "pushed", ns.SetActionBarTheme)
	options:Header(L["Fading"])
	options:Toggle("actionbar_fade_ooc", L["Fade out of combat"], ns.SetActionBarFade):SetDesc(L["The bars fade out of combat and show up on mouseover."])
	options:Range("actionbar_fade_alpha", L["alpha"], 0, 1, 0.05, ns.SetActionBarFade)

	if not ns.EditMode:AddSystemSettings("ActionBar", options) then
		ns.SettingsPanel:AddCategory("actionbars", options)
	end
end)

ns.OnLogin("actionbars", function()
	collectButtons()
	ns.SetActionBarFade()
end)
