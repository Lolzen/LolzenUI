--// objectivetracker // --
-- Position and height are handled by the Edit Mode, the options are attached to its dialog.

local _, ns = ...
local L = ns.L

ns.RegisterModule("objectivetracker", L["desc_objectivetracker"], true)

local cfg
local tracker
local autoCollapsed = false
local settingScale = false

local function setCollapsed(collapsed)
	if not tracker.SetCollapsed then return end
	if tracker.IsCollapsed and tracker:IsCollapsed() == collapsed then return end
	tracker:SetCollapsed(collapsed)
end

-- collapse, but remember that it was us, so we only expand what we collapsed
local function autoCollapse()
	if tracker.IsCollapsed and tracker:IsCollapsed() then return end
	autoCollapsed = true
	setCollapsed(true)
end

local function autoExpand()
	if not autoCollapsed then return end
	autoCollapsed = false
	setCollapsed(false)
end

local function inGroupInstance()
	local _, instanceType = IsInInstance()
	return instanceType == "party" or instanceType == "raid" or instanceType == "scenario"
end

local function onEvent(_, event)
	if event == "PLAYER_REGEN_DISABLED" then
		if cfg["objectivetracker_combatcollapse"] then
			autoCollapse()
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		if cfg["objectivetracker_combatcollapse"] and not (cfg["objectivetracker_dungeoncollapse"] and inGroupInstance()) then
			autoExpand()
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		if cfg["objectivetracker_dungeoncollapse"] and inGroupInstance() then
			autoCollapse()
		elseif not InCombatLockdown() then
			autoExpand()
		end
	end
end

local function applyScale()
	if settingScale or (InCombatLockdown() and tracker:IsProtected()) then return end
	settingScale = true
	tracker:SetScale(cfg["objectivetracker_scale"])
	settingScale = false
end

ns.setOTScale = applyScale

ns.OnInit("objectivetracker", function()
	cfg = LolzenUIcfg.objectivetracker
	tracker = ObjectiveTrackerFrame

	local options = ns.Options.New("objectivetracker", function() return LolzenUIcfg.objectivetracker end, ns.defaults.objectivetracker)
	options:Header("LolzenUI")
	options:Range("objectivetracker_scale", L["scale"], 0.5, 1.5, 0.05, applyScale, function(value)
		return ("%d%%"):format(value * 100 + 0.5)
	end)
	options:Toggle("objectivetracker_combatcollapse", L["objective_autocollapse"]):SetDesc(L["objective_autocollapse_desc"])
	options:Toggle("objectivetracker_logincollapse", L["objective_auto_collapse_login"]):SetDesc(L["objective_auto_collapse_login_desc"])
	options:Toggle("objectivetracker_dungeoncollapse", L["objective_auto_collapse_dungeon"]):SetDesc(L["objective_auto_collapse_dungeon_desc"])
	if not ns.EditMode:AddSystemSettings("ObjectiveTracker", options) then
		ns.SettingsPanel:AddCategory("objectivetracker", options)
	end

	applyScale()
	-- the Edit Mode resets the scale when it applies a layout
	hooksecurefunc(tracker, "SetScale", applyScale)
end)

ns.OnLogin("objectivetracker", function()
	if cfg["objectivetracker_logincollapse"] then
		setCollapsed(true)
	end

	local events = CreateFrame("Frame")
	events:RegisterEvent("PLAYER_REGEN_DISABLED")
	events:RegisterEvent("PLAYER_REGEN_ENABLED")
	events:RegisterEvent("PLAYER_ENTERING_WORLD")
	events:SetScript("OnEvent", onEvent)
end)
