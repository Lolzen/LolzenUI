--// buffs // --
-- Skins Blizzard's buff/debuff frames. Size and layout are handled by the Edit Mode,
-- the skin options are attached to the buff frame dialog in the Edit Mode.

local _, ns = ...
local L = ns.L
local LBT = LibStub("LibButtonTexture-1.0")

ns.RegisterModule("buffs", L["desc_buffs"], true)

local format, floor = string.format, math.floor

local cfg
local containers = {}

local function formatTime(seconds)
	if seconds >= 172800 then
		return format("%dd", floor(seconds / 86400 + 0.5))
	elseif seconds >= 3600 then
		return format("%d:%02d", floor(seconds / 3600), floor(seconds % 3600 / 60))
	elseif seconds >= 60 then
		return format("%d:%02d", floor(seconds / 60), floor(seconds % 60))
	elseif seconds > 4 then
		return format("%d", floor(seconds + 0.5))
	end
	return format("|cffffff00%.1f|r", seconds)
end

-- Blizzard updates the duration text itself; this only replaces it with a more detailed format
local function updateDuration(button, timeLeft)
	if not cfg["buff_duration_detailed"] then return end
	local duration = button.Duration
	if not duration or timeLeft == nil or ns.IsSecret(timeLeft) then return end
	if timeLeft > 0 then
		duration:SetText(formatTime(timeLeft))
	else
		duration:SetText("")
	end
end

local function styleBorder(button, isDebuff)
	local icon = button.Icon
	if isDebuff then
		local border = button.DebuffBorder
		if not border then return end
		border:SetTexture(LBT:Fetch("debuff", cfg["buff_debuff_texture"]))
		border:SetTexCoord(0, 1, 0, 1)
		border:ClearAllPoints()
		border:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
		border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
		return
	end

	local border = button.LolzenBorder
	if not border then
		border = button:CreateTexture(nil, "OVERLAY")
		button.LolzenBorder = border
	end
	local texture = cfg["buff_aura_texture"]
	border:SetTexture(LBT:Fetch("buff", texture))
	border:ClearAllPoints()
	if texture == "Blizzard QuickSlot2" then
		border:SetPoint("TOPLEFT", icon, "TOPLEFT", -10, 10)
		border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 10, -10)
		border:SetVertexColor(1, 1, 1, 1)
	else
		border:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
		border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
		border:SetVertexColor(0, 0, 0, 1)
	end
end

local function styleText(button)
	local duration = button.Duration
	if duration then
		ns.SetFont(duration, cfg["buff_duration_font"], cfg["buff_duration_font_size"], cfg["buff_duration_font_flag"])
		duration:SetDrawLayer("OVERLAY")
		duration:ClearAllPoints()
		duration:SetPoint(cfg["buff_duration_anchor1"], button.Icon, cfg["buff_duration_anchor2"], cfg["buff_duration_posx"], cfg["buff_duration_posy"])
	end

	local count = button.Count
	if count then
		ns.SetFont(count, cfg["buff_counter_font"], cfg["buff_counter_size"], cfg["buff_counter_font_flag"])
		count:SetDrawLayer("OVERLAY")
		count:ClearAllPoints()
		count:SetPoint(cfg["buff_counter_anchor"], button.Icon, cfg["buff_counter_posx"], cfg["buff_counter_posy"])
	end
end

local function styleButton(button, isDebuff)
	if not button.Icon then return end
	if not button.lolzenStyled then
		button.lolzenStyled = true
		button.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		if button.UpdateDuration then
			hooksecurefunc(button, "UpdateDuration", updateDuration)
		end
	end
	styleText(button)
	styleBorder(button, isDebuff)
end

local function styleContainer(container, auras)
	local isDebuff = containers[container]
	if auras then
		for i = 1, #auras do
			local aura = auras[i]
			if aura and not aura.lolzenStyled then
				styleButton(aura, isDebuff)
			end
		end
	end
end

local function forEachButton(func)
	for container, isDebuff in pairs(containers) do
		local children = {container:GetChildren()}
		for i = 1, #children do
			func(children[i], isDebuff)
		end
	end
end

local function refreshAll()
	forEachButton(styleButton)
end

local function applyVisibility()
	local collapse = BuffFrame and BuffFrame.CollapseAndExpandButton
	if collapse then
		local hide = cfg["buff_hide_collapse"]
		collapse:SetAlpha(hide and 0 or 1)
		collapse:EnableMouse(not hide)
	end
	if DebuffFrame then
		-- private auras are shown by Blizzard (important boss mechanics), only the anchors are hidden
		for _, key in ipairs({"privateAuraAnchor1", "privateAuraAnchor2"}) do
			local anchor = DebuffFrame[key]
			if anchor then
				anchor:SetAlpha(cfg["buff_hide_private_anchors"] and 0 or 1)
			end
		end
	end
end

-- kept for compatibility with old option callbacks
ns.SetBuffAuraTexture = refreshAll
ns.SetBuffDebuffTexture = refreshAll
ns.SetBuffDurationPosition = refreshAll
ns.SetBuffDurationFont = refreshAll
ns.SetBuffCounterPosition = refreshAll
ns.SetBuffCounterFont = refreshAll

ns.OnInit("buffs", function()
	cfg = LolzenUIcfg.buffs

	local options = ns.Options.New("buffs", function() return LolzenUIcfg.buffs end, ns.defaults.buffs, function()
		refreshAll()
		applyVisibility()
	end)
	options:Header(L["buff_duration_header"])
	options:Toggle("buff_duration_detailed", L["buff_detailed_duration_text"])
	options:FontGroup("buff_duration_font")
	options:Anchor("buff_duration_anchor1", L["anchor"])
	options:Anchor("buff_duration_anchor2", L["parent"])
	options:Range("buff_duration_posx", L["PosX"], -50, 50, 1)
	options:Range("buff_duration_posy", L["PosY"], -50, 50, 1)
	options:Header(L["buff_counter_header"])
	options:Font("buff_counter_font")
	options:Range("buff_counter_size", L["size"], 4, 40, 1)
	options:Flag("buff_counter_font_flag")
	options:PointGroup("buff_counter_anchor", "buff_counter_posx", "buff_counter_posy", nil, 50)
	options:Header(L["border"])
	options:ButtonTexture("buff_aura_texture", L["buff_and_tempench_texture"], "buff")
	options:ButtonTexture("buff_debuff_texture", L["debuff_texture"], "debuff")
	options:Toggle("buff_hide_collapse", L["Hide the collapse button"])
	options:Toggle("buff_hide_private_anchors", L["Hide the private aura anchors"])

	if not ns.EditMode:AddSystemSettings({"AuraFrame", "BuffFrame", "Auras"}, options) then
		ns.SettingsPanel:AddCategory("buffs", options)
	end
end)

ns.OnLogin("buffs", function()
	if BuffFrame and BuffFrame.AuraContainer then
		containers[BuffFrame.AuraContainer] = false
	end
	if DebuffFrame and DebuffFrame.AuraContainer then
		containers[DebuffFrame.AuraContainer] = true
	end
	for container in pairs(containers) do
		if container.UpdateGridLayout then
			hooksecurefunc(container, "UpdateGridLayout", styleContainer)
		end
	end
	refreshAll()
	applyVisibility()
end)
