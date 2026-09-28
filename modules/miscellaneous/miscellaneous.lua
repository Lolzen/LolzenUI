--// miscellaneous // --

local _, ns = ...
local L = ns.L

ns.RegisterModule("miscellaneous", L["desc_miscellaneous"], true)

local cfg

--[[ reputation colors ]]------------------------------------------------------

-- localized standing name -> standing id (male and female variants)
local standingByName = {}
for i = 1, 8 do
	for _, suffix in ipairs({"", "_FEMALE"}) do
		local name = _G["FACTION_STANDING_LABEL"..i..suffix]
		if name then
			standingByName[name] = i
		end
	end
end

local function colorReputationBar(bar)
	if not cfg["misc_alternative_faction_colors"] then return end
	local standing = standingByName[bar.reputationStandingText]
	local color = standing and cfg["misc_faction_colors"][standing]
	if color then
		bar:SetStatusBarColor(color[1], color[2], color[3])
	end
end

--[[ micro menu & bags bar ]]---------------------------------------------------

local MICRO_BUTTONS = {
	"CharacterMicroButton", "ProfessionMicroButton", "PlayerSpellsMicroButton", "SpellbookMicroButton",
	"TalentMicroButton", "AchievementMicroButton", "QuestLogMicroButton", "HousingMicroButton",
	"GuildMicroButton", "LFDMicroButton", "PVPMicroButton", "CollectionsMicroButton",
	"EJMicroButton", "StoreMicroButton", "MainMenuMicroButton", "HelpMicroButton",
}

local function setShown(frame, shown)
	if not frame then return end
	frame:SetAlpha(shown and 1 or 0)
	frame:EnableMouse(shown)
end

local function applyMicroMenu()
	local show = not cfg["misc_hide_microbuttons"]
	-- alpha/mouse instead of hiding, Blizzard re-shows the buttons on every layout update
	for _, name in ipairs(MICRO_BUTTONS) do
		setShown(_G[name], show)
	end
end

local BAG_BUTTONS = {
	"MainMenuBarBackpackButton", "CharacterBag0Slot", "CharacterBag1Slot",
	"CharacterBag2Slot", "CharacterBag3Slot", "CharacterReagentBag0Slot", "BagBarExpandToggle",
}

local function applyBagsBar()
	local show = not cfg["misc_hide_bagbar"]
	setShown(BagsBar, show)
	for _, name in ipairs(BAG_BUTTONS) do
		setShown(_G[name], show)
	end
end

--[[ easy delete ]]------------------------------------------------------------

-- fills in the confirmation word when deleting good items, so it doesn't have to be typed
local function onPopupShow(which)
	if which ~= "DELETE_GOOD_ITEM" and which ~= "DELETE_GOOD_QUEST_ITEM" then return end
	if not cfg["misc_easy_delete"] then return end
	local popup = StaticPopup_FindVisible and StaticPopup_FindVisible(which)
	if not popup then return end
	local editBox = (popup.GetEditBox and popup:GetEditBox()) or popup.editBox or popup.EditBox
	if editBox then
		editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
	end
end

--[[ init ]]-------------------------------------------------------------------

local function applyAll()
	applyMicroMenu()
	applyBagsBar()
	if ReputationFrame and ReputationFrame:IsShown() and ReputationFrame.Update then
		ReputationFrame:Update()
	end
end

ns.updateMicroButtonVisibility = applyAll
ns.updateCustomRepColors = applyAll

ns.OnInit("miscellaneous", function()
	cfg = LolzenUIcfg.miscellaneous

	local options = ns.Options.New("miscellaneous", function() return LolzenUIcfg.miscellaneous end, ns.defaults.miscellaneous, applyAll)
	options:Header(L["misc_microbuttons"])
	options:Toggle("misc_hide_microbuttons", L["misc_hide_microbuttons"])
	options:Toggle("misc_hide_bagbar", L["Hide the bags bar"])
	options:Toggle("misc_easy_delete", L["Easy delete"]):SetDesc(L["Fills in the confirmation text when deleting items."])
	options:Header(L["misc_rep_colors_header"])
	options:Toggle("misc_alternative_faction_colors", L["misc_use_alternative_rep_colors"])
	local names = {"misc_hated", "misc_hostile", "misc_unfriendly", "misc_neutral", "misc_friendly", "misc_honored", "misc_revered", "misc_exalted"}
	for i, name in ipairs(names) do
		local colors = cfg["misc_faction_colors"]
		local opt = options:Add({kind = "color", name = L[name], key = i})
		-- the colors live in a sub table
		opt.Get = function() return colors[i] end
		opt.Set = function(_, value)
			colors[i] = value
			applyAll()
		end
	end
	ns.SettingsPanel:AddCategory("miscellaneous", options)
end)

ns.OnLogin("miscellaneous", function()
	if ReputationBarMixin and ReputationBarMixin.UpdateBarColor then
		hooksecurefunc(ReputationBarMixin, "UpdateBarColor", colorReputationBar)
	end
	hooksecurefunc("StaticPopup_Show", onPopupShow)

	applyAll()
	-- the micro menu is rebuilt on several occasions (vehicles, pet battles, layout changes)
	if MicroMenu and MicroMenu.Layout then
		hooksecurefunc(MicroMenu, "Layout", applyMicroMenu)
	end
	if BagsBar and BagsBar.Layout then
		hooksecurefunc(BagsBar, "Layout", applyBagsBar)
	end
end)
