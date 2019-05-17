﻿--// Korean localization //--

local addon, ns = ...
local L = ns.L

if GetLocale() == "koKR" then
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
	-- tutorial
	L["step1"] =  "Welcome to LolzenUI!\nThis is the Tutorial, which will guide you to the most crucial things."
	L["step2"] = "You may notice the missing Minimap Icon for missions.\nThey can be accessed by clicking the topleft ClassIcon on the OrderHallClassBar (On the very top left)"
	L["step3"] = "Next to the ClassIcon is an area which tracks currencies.\nPress \"C\" -> Currency -> Select a currency of interest -> Tick \"Show on Backpack\""
	L["step4"] = "In the Topcenter, the Zonename along with Coordinates will be shown"
	L["step5"] = "On the Topright you can see a clock.\nMouseover to see a list of Addons with current memory usage.\nHINT: the most \"hungry\" Addon will ALWAYS be red, no matter how tiny the footprint actually is!"
	L["step6"] = "On the Minimap you do have an indicator of which day it is.\nClick on it to open the CalendarFrame."
	L["step7"] = "This bar indicates your Artifact Level.\nHover over it to show the text."
	L["step8"] = "This bar indicates your Experience/Reputation/Honor.\nIt will prioritize honor in BGs, and reputation if a faction is watched\nTo watch a faction press \"C\" -> Reputation -> Select a faction -> Tick \"Show as Experience Bar\"\nHover over it to show the text."
	L["step9"] = "Whetever you have DBM or BigWigs installed, /pull is built-in along with a visual timer."
	L["step10"] = "For a vast amount of options open up the Optionpanel with /lolzen or /lolzenui\n\nClick next to open up the Optionpanel. (Requires LolzenUI_Options)"
	L["step11"] = "Click \"Skip\" to end the tuorial\n\nThis tutorial will not show again."
	L["step2_help"] = "Click the Class Icon"
	L["step3_help"] = "In this area currencies will be shown"
	L["step4_help"] = "Zone [X/Y]"
	L["step5_help"] = "Mouseover to see some stats"
	L["step6_help"] = "Click on the number to open the Calendar"
	L["step7_help"] = "Mouseover this bar to show the text"
	L["step8_help"] = "Mouseover this bar to show the text"
	L["step11_help"] = "LolzenUI is marked - press \"+\""
	L["next_button_text"] = "Next"
	L["previous_button_text"] = "Previous"
	L["skip_button_text"] = "Skip"
end