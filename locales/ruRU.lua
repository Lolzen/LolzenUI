--// Russian localization //--

local addon, ns = ...
local L = ns.L

if GetLocale() == "ruRU" then
	-- Optionpanel
	L["desc_LolzenUI"] = "Modifies ir changes UI elements"
	L["LolzenUI_slash"] = "|cff5599ff/lolzen|r |cffffffffor|r |cff5599ff/lolzenui|r |cffffffffopens up this panel|r"
	L["modules_to_load"] = "|cff5599ffModules:|r to load:"
	L["apply_button"] = "Apply Settings"
	-- module names
	L["actionbars"] = "actionbars"
	L["artifactbar"] = "artifactbar"
	L["buffs"] = "buffs"
	L["buffwatcher"] = "buffwatcher"
	L["chat"] = "chat"
	L["clock"] = "clock"
	L["fonts"] = "fonts"
	L["itemlevel"] = "itemlevel"
	L["interruptannouncer"] = "interruptannouncer"
	L["minimap"] = "minimap"
	L["miscellaneous"] = "miscellaneous"
	L["nameplates"] = "nameplates"
	L["objectivetracker"] = "objectivetracker"
	L["orderhallbar"] = "orderhallbar"
	L["pullcount"] = "pullcount"
	L["slashcommands"] = "slashcommands"
	L["tooltip"] = "tooltip"
	L["unitframes"] = "unitframes"
	L["worldmap"] = "worldmap"
	L["xpbar"] = "xpbar"
	-- module descriptions
	L["desc_actionbars"] = "Skins the Actionbars and alters their positions"
	L["desc_artifactbar"] = "A bar which shows artifact power progress"
	L["desc_buffs"] = "Skins the buffs/debuffs along with a more detailed timer"
	L["desc_buffwatcher"] = "Displays nice icons along with the duration if up"
	L["desc_chat"] = "Modifies the look of the Chatwindow"
	L["desc_clock"] = "A Clock with useful information about active AddOns on mouseover"
	L["desc_fonts"] = "Changes the fonts used in WoW"
	L["desc_inspect"] = "Enables inspect per keybind & caches items for out of range viewing"
	L["desc_interruptannouncer"] = "Announces interrupts"
	L["desc_itemlevel"] = "Displays item level on equippable items"
	L["desc_minimap"] = "A clean Minimap"
	L["desc_miscellaneous"] = "Miscellaneous options"
	L["desc_nameplates"] = "Modifies the Nameplates"
	L["desc_objectivetracker"] = "Modify behaviour and position of the ObjectiveTrackerFrame"
	L["desc_orderhallbar"] = "Modify the OrderHallBar and show currencies marked as \"Show in Backpack\""
	L["desc_pullcount"] = "Built-in /pull [num] ; works with DBM/BigWigs and plays sounds (optional)"
	L["desc_slashcommands"] = "Adds convinient slashcommnads"
	L["desc_tooltip"] = "Modifies the look of the Tooltip and adds a few features"
	L["desc_unitframes"] = "Highly customizable unitframes based on oUF"
	L["desc_worldmap"] = "Modifies & Enhances the WorldMap"
	L["desc_xpbar"] = "A bar which shows pretige/honor in bgs, rep at the watched faction or alternatively experience"
	-- special cases
	L["ia_announce_message_text_interrupted"] = "Interrupted: !spell from >>!name<<"
end