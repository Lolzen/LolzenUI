﻿--// German localization //--

local addon, ns = ...
local L = ns.L

if GetLocale() == "deDE" then
	-- Optionpanel
	L["desc_LolzenUI"] = "Modifiziert oder ändert UI Elemente"
	L["LolzenUI_slash"] = "|cff5599ff/lolzen|r |cffffffffoder|r |cff5599ff/lolzenui|r |cfffffffföffnet dieses Optionsfenster|r"
	L["modules_to_load"] = "|cff5599ffModule:|r die geladen werden:"
	L["apply_button"] = "Anwenden"
	-- module names
	L["actionbars"] = "aktionsleisten"
	L["artifactbar"] = "artefaktleiste"
	L["buffs"] = "buffs"
	L["buffwatcher"] = "buffbeobachter"
	L["chat"] = "chat"
	L["clock"] = "uhr"
	L["fonts"] = "schrifarten"
	L["itemlevel"] = "itemlevel"
	L["interruptannouncer"] = "unterbrechungsansagen"
	L["minimap"] = "minimap"
	L["miscellaneous"] = "verschiedenes"
	L["nameplates"] = "namensplaketten"
	L["objectivetracker"] = "objektive"
	L["orderhallbar"] = "ordenshallenleiste"
	L["pullcount"] = "pullzähler"
	L["slashcommands"] = "chatbefehle"
	L["tooltip"] = "tooltip"
	L["unitframes"] = "einheitenfenster"
	L["worldmap"] = "weltkarte"
	L["xpbar"] = "xpleiste"
	-- module descriptions
	L["desc_actionbars"] = "Skins für die Aktionsleisten und positionen anpassen"
	L["desc_artifactbar"] = "Eine Leiste die den Artefaktmacht fortschritt anzeigt"
	L["desc_buffs"] = "Skins für buffs/debuffs mit einen genauerem timer"
	L["desc_buffwatcher"] = "Zeigt ein Symbol und Zeitanzeige (verbleibend) an wenn der spezifizierte Buff/Debuff aktiv ist"
	L["desc_chat"] = "Modifiziert das aussehen des Chatfensters"
	L["desc_clock"] = "Eine Uhr mit nützlichen informationen zu den aktiven AddOns bei mouseover"
	L["desc_fonts"] = "Ändert die Schriftarten in WoW"
	L["desc_inspect"] = "Ermöglicht betrachten über Keybind & zwischenspeichert items um aus der ferne weiterzubetrachten"
	L["desc_interruptannouncer"] = "Sagt Unterbrechungen an"
	L["desc_itemlevel"] = "Zeigt den Itemlevel von ausrüstbaren Gegenständen an"
	L["desc_minimap"] = "Eine saubere Minimap"
	L["desc_miscellaneous"] = "Verschiedene optionen"
	L["desc_nameplates"] = "Modifiziert die Namensplaketten"
	L["desc_objectivetracker"] = "Modifiziert das verhalten und Position der Objektivliste"
	L["desc_orderhallbar"] = "Modifiziert die Ordenshallenleiste und zeigt Abzeichen an die als \"Am Rucksack anzeigen\" markiert sind"
	L["desc_pullcount"] = "Eingebauter /pull [nummer] timer; synchronisiert mit DBM/BigWigs und spielt Töne ab (optional)"
	L["desc_slashcommands"] = "Fügt nützliche chatbefehle hinzu"
	L["desc_tooltip"] = "Modifiziert das Aussehen des Tooltips und fügt ein paar funktionen hinzu"
	L["desc_unitframes"] = "Sehr anpassbare Einheitenfenster basierend auf oUF"
	L["desc_worldmap"] = "Modifiziert und erweitert die Welkarte"
	L["desc_xpbar"] = "Eine Leiste die Ehre in Schlachtfeldern, Ruf bei der ausgewählten Fraktion oder alternativ EXP anzeigt"
	-- special cases
	L["ia_announce_message_text_interrupted"] = "Unterbrochen: !spell von >>!name<<"
	-- tutorial
	L["step1"] =  "Wilkommen bei LolzenUI!\nDies ist das Tutorial das dir die wichtigsten Dinge erklären wird."
	L["step2"] = "Vielleicht hast du bemerkt das das Minimap Icon für die Missionen fehlt.\nSie können über das Klassenicon auf der OrdenshallenBar erricht werden (Ganz links, oben)"
	L["step3"] = "Neben dem Klassenicon ist ein Bereich für währungen.\nDrücke \"C\" -> Währung -> Wähle eine Währung des Interesses aus -> Setze den Haken bei \"Zeige im Rucksack an\""
	L["step4"] = "Im der oberen Mitte wird der Zonenname mit Koordinaten angezeigt."
	L["step5"] = "Rechts oben sieht man die Uhr.\nFahr mit der Maus darüber um eine Liste deiner Addons und eigige andere Informationen zu sehen.\nTIP: Das Addon das am meisten \"hungrig\" ist wir IMMER rot sein, egal wie wenig es eigentlich verbraucht!"
	L["step6"] = "Auf der Minimap ist eine Zahl die den heutigen Tag anzeigt.\nKlicke darauf um den Kalender zu öffnen."
	L["step7"] = "Diese Leiste zeigt deinen Artefakt Level\nFahre mit der Msus darüber um den text anzuzeigen."
	L["step8"] = "Diese Leiste zeigt deine Erfahrung/Ruf/Ehre.\nSie prioritisiert Ehre in Schlachtfeldern oder Ruf wenn eine fraktion überwacht wird\nUm eine Fraktion zu überwachen drücke \"C\" -> Ruf -> Wähle eine Fraktion -> Setze den Haken bei \"Zeige als Erfahrungsleiste\"\nFahre mit der Msus darüber um den text anzuzeigen."
	L["step9"] = "Ob du DBM oder BigWigs installiert hast oder nicht, /pull ist eingebaut samt visuellem Zähler."
	L["step10"] = "Für eine Facettenreiche auswahl an Optionen, öffne das Optionsfenster mit /lolzen oder /lolzenui\nKlicke \"Weiter\" um das Optionsfenster zu öffnen. (Benötigt LolzenUI_Options)"
	L["step11"] = "Klicke \"Überspringen\" um das Tutorial zu beenden\n\nDu wirst dieses Tutorial nicht wieder sehen."
	L["step2_help"] = "Klicke das Klassenicon"
	L["step3_help"] = "Hier werden währungen angezeigt"
	L["step4_help"] = "Zone [X/Y]"
	L["step5_help"] = "Fahre mit der Maus darüber"
	L["step6_help"] = "Klicke auf die Nummer für den Kalender"
	L["step7_help"] = "Fahre mit der Maus darüber"
	L["step8_help"] = "Fahre mit der Maus darüber"
	L["step11_help"] = "LolzenUI ist markiert - drücke \"+\""
	L["next_button_text"] = "Weiter"
	L["previous_button_text"] = "Zurück"
	L["skip_button_text"] = "Überspringen"
end