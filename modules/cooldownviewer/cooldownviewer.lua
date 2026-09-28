--// cooldownviewer // --
-- Skins Blizzard's Cooldown Manager (essential/utility cooldowns and tracked buffs).
-- Layout and positions are handled by the Edit Mode.

local _, ns = ...
local L = ns.L

ns.RegisterModule("cooldownviewer", L["desc_cooldownviewer"], true)

local ICON_VIEWERS = {"EssentialCooldownViewer", "UtilityCooldownViewer", "BuffIconCooldownViewer"}

local cfg
local hookedViewers = {}

local function getIconTexture(item)
	local icon = item.Icon
	if not icon then return end
	if icon.IsObjectType and icon:IsObjectType("Texture") then
		return icon
	end
	return icon.Icon
end

local function getCountText(item)
	if item.ChargeCount and item.ChargeCount.Current then
		return item.ChargeCount.Current
	end
	if item.Applications and item.Applications.Applications then
		return item.Applications.Applications
	end
end

local function getCooldownText(cooldown)
	if not cooldown then return end
	if cooldown.GetCountdownFontString then
		return cooldown:GetCountdownFontString()
	end
	for _, region in ipairs({cooldown:GetRegions()}) do
		if region:IsObjectType("FontString") then
			return region
		end
	end
end

local function styleItem(item)
	local icon = getIconTexture(item)
	if not icon then return end

	if not item.lolzenStyled then
		item.lolzenStyled = true
		-- square icons: remove Blizzard's rounded mask
		for _, region in ipairs({item:GetRegions()}) do
			if region:IsObjectType("MaskTexture") then
				icon:RemoveMaskTexture(region)
			end
		end
		item.lolzenCooldownText = getCooldownText(item.Cooldown)
	end

	if cfg["cdv_crop_icons"] then
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	else
		icon:SetTexCoord(0, 1, 0, 1)
	end

	if cfg["cdv_outline"] then
		ns.Outline.Create(item, {size = 10, padding = 2, level = 2})
	end
	if item.LolzenOutline then
		item.LolzenOutline:SetShown(cfg["cdv_outline"])
	end

	local cooldownText = item.lolzenCooldownText
	if cooldownText then
		ns.SetFont(cooldownText, cfg["cdv_font"], cfg["cdv_font_size"], cfg["cdv_font_flag"])
	end
	local count = getCountText(item)
	if count then
		ns.SetFont(count, cfg["cdv_font"], cfg["cdv_count_size"], cfg["cdv_font_flag"])
	end
end

local function styleViewer(viewer)
	local items = viewer.GetItemFrames and viewer:GetItemFrames()
	if items then
		for _, item in ipairs(items) do
			styleItem(item)
		end
	else
		for _, child in ipairs({viewer:GetChildren()}) do
			if child.Cooldown then
				styleItem(child)
			end
		end
	end
end

local function hookViewers()
	for _, name in ipairs(ICON_VIEWERS) do
		local viewer = _G[name]
		if viewer and not hookedViewers[viewer] then
			hookedViewers[viewer] = true
			if viewer.RefreshLayout then
				hooksecurefunc(viewer, "RefreshLayout", styleViewer)
			end
			if viewer.OnAcquireItemFrame then
				hooksecurefunc(viewer, "OnAcquireItemFrame", function(_, item)
					styleItem(item)
				end)
			end
			styleViewer(viewer)
		end
	end
end

local function refreshAll()
	for viewer in pairs(hookedViewers) do
		styleViewer(viewer)
	end
end

ns.OnInit("cooldownviewer", function()
	cfg = LolzenUIcfg.cooldownviewer

	local options = ns.Options.New("cooldownviewer", function() return LolzenUIcfg.cooldownviewer end, ns.defaults.cooldownviewer, refreshAll)
	options:Header("LolzenUI")
	options:Toggle("cdv_crop_icons", L["Crop icons"])
	options:Toggle("cdv_outline", L["Use outline"])
	options:Font("cdv_font")
	options:Range("cdv_font_size", L["Cooldown text size"], 6, 32, 1)
	options:Range("cdv_count_size", L["Counter text size"], 6, 32, 1)
	options:Flag("cdv_font_flag")

	if not ns.EditMode:AddSystemSettings("CooldownViewer", options) then
		ns.SettingsPanel:AddCategory("cooldownviewer", options)
	end

	if C_AddOns.IsAddOnLoaded("Blizzard_CooldownViewer") then
		hookViewers()
	else
		local loader = CreateFrame("Frame")
		loader:RegisterEvent("ADDON_LOADED")
		loader:SetScript("OnEvent", function(self, _, addon)
			if addon == "Blizzard_CooldownViewer" then
				self:UnregisterAllEvents()
				hookViewers()
			end
		end)
	end
end)

ns.OnLogin("cooldownviewer", hookViewers)
