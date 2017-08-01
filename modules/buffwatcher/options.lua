--// options for buffwatcher //--

local addon, ns = ...

if not ns.modules["actionabars"] then
	tinsert(ns.modules, "buffwatcher")
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg["buffwatcher"] == true then

		local title = ns["buffwatcher"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["buffwatcher"], 16, -16)
		title:SetText("|cff5599ff"..ns["buffwatcher"].name.."|r")

		local about = ns["buffwatcher"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Displays nice icons along with the duration if up")
		
		local list = ns["buffwatcher"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		list:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		list:SetText("|cff5599ffBuffs which are being watched:|r")

		local function getInfo(id)
			local name, _, spellicon = GetSpellInfo(id)
			if spellicon ~= nil then
				return name, spellicon
			else
				return GetSpellInfo(212812), select(3, GetSpellInfo(212812))
			end
		end
		
		local icon = {}
		for i=1, #LolzenUIcfg["buffwatchlist"] do
			icon[i] = ns["buffwatcher"]:CreateTexture(nil, "OVERLAY")
			icon[i]:SetTexCoord(.04, .94, .04, .94)
			icon[i]:SetTexture(select(2, getInfo(LolzenUIcfg["buffwatchlist"][i])))
			icon[i]:SetSize(26, 26)
			if i == 1 then
				icon[i]:SetPoint("TOPLEFT", list, "BOTTOMLEFT", 0, -20)
			else
				icon[i]:SetPoint("TOPLEFT", icon[i-1], "BOTTOMLEFT", 0, -5)
			end
			if not icon[i].text then
				icon[i].text = ns["buffwatcher"]:CreateFontString(nil, "OVERLAY")
				icon[i].text:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 12 ,"OUTLINE")
				icon[i].text:SetTextColor(1, 1, 1)
				icon[i].text:SetPoint("LEFT", icon[i], "RIGHT", 10, 0)
				icon[i].text:SetText(getInfo(LolzenUIcfg["buffwatchlist"][i]).." (spellid: "..LolzenUIcfg["buffwatchlist"][i]..")")
			end
		end
		
		local add = ns["buffwatcher"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		add:SetPoint("LEFT", list, "RIGHT", 140, 0)
		add:SetText("|cffffffffadd or delete buffs to be watched (per spellid):|r")
		
		local eb = CreateFrame("EditBox", nil, ns["buffwatcher"], "InputBoxTemplate")
		eb:SetPoint("TOPLEFT", add, "BOTTOMLEFT", 5, -8)
		eb:SetSize(50, 20)
		eb:SetAutoFocus(false)
		eb:ClearFocus()
		eb:SetCursorPosition(0)
		
		local previewicon = ns["buffwatcher"]:CreateTexture(nil, "OVERLAY")
		previewicon:SetTexCoord(.04, .94, .04, .94)
		previewicon:SetTexture(select(3, GetSpellInfo(212812)))
		previewicon:SetSize(16, 16)
		previewicon:SetPoint("LEFT", eb, "RIGHT", 5, 0)

		local prevname = ns["buffwatcher"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		prevname:SetPoint("LEFT", previewicon, "RIGHT", 5, 0)
		prevname:SetText(GetSpellInfo(212812))
		
		eb:SetScript("OnTextChanged", function(self)
			previewicon:SetTexture(select(2, getInfo(eb:GetText())))
			prevname:SetText(getInfo(eb:GetText()))
		end)
		
		local b = CreateFrame("Button", "addButton", ns["buffwatcher"], "UIPanelButtonTemplate")
		b:SetSize(80 ,22) -- width, height
		b:SetText("add")
		b:SetPoint("TOPLEFT", eb, "BOTTOMLEFT", -7, -8)
		b:SetScript("OnClick", function()
			local isduplicate = false
			for k, v in pairs(LolzenUIcfg["buffwatchlist"]) do
				if v == eb:GetText() then
					isduplicate = true
				end
			end
			if isduplicate == true then
				print("duplicate id detexted!")
			else
				table.insert(LolzenUIcfg["buffwatchlist"], eb:GetText())
				print("Hit Okay reload the list")
			end
		end)
		
		local b2 = CreateFrame("Button", "delButton", ns["buffwatcher"], "UIPanelButtonTemplate")
		b2:SetSize(80 ,22) -- width, height
		b2:SetText("delete")
		b2:SetPoint("LEFT", b, "RIGHT", 10, 0)
		b2:SetScript("OnClick", function()
			for k, v in pairs(LolzenUIcfg["buffwatchlist"]) do
				if v == eb:GetText() then
					table.remove(LolzenUIcfg["buffwatchlist"], k)
				end
			end
			print("Hit Okay to reload the list")
		end)
		
		local tip = ns["buffwatcher"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		tip:SetPoint("TOPLEFT", b, "BOTTOMLEFT", 0, -8)
		tip:SetText("|cff5599ffPROTIP: |rrefer to WoWhead and search for your spell,\n the spellid is in the URL")
		
		local help = ns["buffwatcher"]:CreateTexture(nil, "OVERLAY")
		help:SetSize(293, 66)
		help:SetTexture("Interface\\AddOns\\LolzenUI\\modules\\buffwatcher\\help.tga")
		help:SetPoint("TOPLEFT", tip, "BOTTOMLEFT", 0, -8)
		
		local pos_x_text = ns["buffwatcher"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_x_text:SetPoint("TOPLEFT", help, "BOTTOMLEFT", 0, -20)
		pos_x_text:SetText("|cffffffffPosX:")
		
		local pos_x = CreateFrame("EditBox", nil, ns["buffwatcher"], "InputBoxTemplate")
		pos_x:SetPoint("LEFT", pos_x_text, "RIGHT", 10, 0)
		pos_x:SetSize(30, 50)
		pos_x:SetAutoFocus(false)
		pos_x:ClearFocus()
		pos_x:SetNumber(LolzenUIcfg["buffwatch_pos_x"])
		pos_x:SetCursorPosition(0)
		
		local pos_y_text = ns["buffwatcher"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_y_text:SetPoint("LEFT", pos_x, "RIGHT", 5, 0)
		pos_y_text:SetText("|cffffffffPosY:")
		
		local pos_y = CreateFrame("EditBox", nil, ns["buffwatcher"], "InputBoxTemplate")
		pos_y:SetPoint("LEFT", pos_y_text, "RIGHT", 10, 0)
		pos_y:SetSize(30, 50)
		pos_y:SetAutoFocus(false)
		pos_y:ClearFocus()
		pos_y:SetNumber(LolzenUIcfg["buffwatch_pos_y"])
		pos_y:SetCursorPosition(0)
		
		local pos_desc = ns["buffwatcher"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_desc:SetPoint("TOPLEFT", pos_x_text, "BOTTOMLEFT", 0, -8)
		pos_desc:SetText("|cffffffffThe startingpoint is the center of the screen (0/0)")
		
		local icon_size_text = ns["buffwatcher"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		icon_size_text:SetPoint("TOPLEFT", pos_desc, "BOTTOMLEFT", 0, -20)
		icon_size_text:SetText("|cffffffffIcon Size:")
		
		local icon_size = CreateFrame("EditBox", nil, ns["buffwatcher"], "InputBoxTemplate")
		icon_size:SetPoint("LEFT", icon_size_text, "RIGHT", 10, 0)
		icon_size:SetSize(30, 50)
		icon_size:SetAutoFocus(false)
		icon_size:SetNumeric(true)
		icon_size:ClearFocus()
		icon_size:SetNumber(LolzenUIcfg["buffwatch_icon_size"])
		icon_size:SetCursorPosition(0)
		
		local icon_spacing_text = ns["buffwatcher"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		icon_spacing_text:SetPoint("LEFT", icon_size, "RIGHT", 5, 0)
		icon_spacing_text:SetText("|cffffffffIcon Spacing:")
		
		local icon_spacing = CreateFrame("EditBox", nil, ns["buffwatcher"], "InputBoxTemplate")
		icon_spacing:SetPoint("LEFT", icon_spacing_text, "RIGHT", 10, 0)
		icon_spacing:SetSize(30, 50)
		icon_spacing:SetAutoFocus(false)
		icon_spacing:SetNumeric(true)
		icon_spacing:ClearFocus()
		icon_spacing:SetNumber(LolzenUIcfg["buffwatch_icon_spacing"])
		icon_spacing:SetCursorPosition(0)

		ns["buffwatcher"].okay = function(self)
			LolzenUIcfg["buffwatch_pos_x"] = tonumber(pos_x:GetText())
			LolzenUIcfg["buffwatch_pos_y"] = tonumber(pos_y:GetText())
			LolzenUIcfg["buffwatch_icon_size"] = tonumber(icon_size:GetText())
			LolzenUIcfg["buffwatch_icon_spacing"] = tonumber(icon_spacing:GetText())
		end
		
		ns["buffwatcher"].default = function(self)
			LolzenUIcfg["buffwatchlist"] = {
				225142, --Nefarious Pact
				225776, --Devil's Due
				225719, --Accelererando
			}
			LolzenUIcfg["buffwatch_pos_x"] = -250
			LolzenUIcfg["buffwatch_pos_y"] = -140
			LolzenUIcfg["buffwatch_icon_size"] = 52
			LolzenUIcfg["buffwatch_icon_spacing"] = 5
			ReloadUI()
		end
	end
end)