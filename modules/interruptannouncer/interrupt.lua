--// interruptannouncer // --

local _, ns = ...
local L = ns.L

ns.RegisterModule("interruptannouncer", L["desc_interruptannouncer"], true)

local cfg
local playerGUID
local sendChatMessage = (C_ChatInfo and C_ChatInfo.SendChatMessage) or SendChatMessage

local function announce(spellID, targetName)
	if ns.IsSecret(spellID) or ns.IsSecret(targetName) then return end

	local link = spellID and C_Spell.GetSpellLink(spellID) or ""
	-- use functions as replacement, names or links may contain "%"
	local msg = cfg["interruptannouncer_msg"]
		:gsub("!spell", function() return link end)
		:gsub("!name", function() return targetName or "" end)

	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and cfg["interruptannoucer_instance"] then
		sendChatMessage(msg, "INSTANCE_CHAT")
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) and cfg["interruptannoucer_party"] then
		sendChatMessage(msg, "PARTY")
	end
end

local function onCombatLog()
	local _, eventType, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, extraSpellID = CombatLogGetCurrentEventInfo()
	if eventType == "SPELL_INTERRUPT" and sourceGUID == playerGUID then
		announce(extraSpellID, destName)
	end
end

-- 12.0+: addons don't get the combat log anymore, the spellcast event names the interrupter instead
local lastCastGUID
local function onSpellcastInterrupted(_, _, unit, castGUID, spellID, interruptedBy)
	if interruptedBy == nil or ns.IsSecret(interruptedBy) or interruptedBy ~= playerGUID then return end
	-- the same cast is reported for every unit token (target, focus, nameplateX, ...)
	if castGUID and not ns.IsSecret(castGUID) then
		if castGUID == lastCastGUID then return end
		lastCastGUID = castGUID
	end
	announce(spellID, UnitName(unit))
end

ns.OnInit("interruptannouncer", function()
	cfg = LolzenUIcfg.interruptannouncer
	playerGUID = UnitGUID("player")

	local frame = CreateFrame("Frame")
	if pcall(frame.RegisterEvent, frame, "COMBAT_LOG_EVENT_UNFILTERED") and CombatLogGetCurrentEventInfo then
		frame:SetScript("OnEvent", onCombatLog)
	else
		frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
		frame:SetScript("OnEvent", onSpellcastInterrupted)
	end

	local options = ns.Options.New("interruptannouncer", function() return LolzenUIcfg.interruptannouncer end, ns.defaults.interruptannouncer)
	options:Header(L["interruptannouncer"])
	options:Toggle("interruptannoucer_instance", L["ia_announce_intance"])
	options:Toggle("interruptannoucer_party", L["ia_announce_party"])
	options:Text("interruptannouncer_msg", L["ia_message"]):SetDesc(L["ia_message_description"])
	ns.SettingsPanel:AddCategory("interruptannouncer", options)
end)
