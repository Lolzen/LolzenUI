--// options for buffwatcher //--

local addon, ns = ...

ns.RegisterModule("buffwatcher")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["buffwatcher"] == true then

		local title = ns.createTitle("buffwatcher")

		local about = ns.createDescription("buffwatcher", "Displays nice icons along with the duration if up")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)

		local header1 = ns.createHeader("buffwatcher", "Buffs which are being watched:")
		header1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)

		local function getInfo(id)
			local name, _, spellicon = GetSpellInfo(id)
			if spellicon ~= nil then
				return name, spellicon
			else
				return GetSpellInfo(212812), select(3, GetSpellInfo(212812))
			end
		end

		local icon = {}
		for i=1, #LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")] do
			icon[i] = ns["buffwatcher"]:CreateTexture(nil, "OVERLAY")
			icon[i]:SetTexCoord(.04, .94, .04, .94)
			icon[i]:SetTexture(select(2, getInfo(LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")][i])))
			icon[i]:SetSize(26, 26)
			if i == 1 then
				icon[i]:SetPoint("TOPLEFT", header1, "BOTTOMLEFT", 0, -20)
			else
				icon[i]:SetPoint("TOPLEFT", icon[i-1], "BOTTOMLEFT", 0, -5)
			end
			if not icon[i].text then
				icon[i].text = ns["buffwatcher"]:CreateFontString(nil, "OVERLAY")
				icon[i].text:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 12 ,"OUTLINE")
				icon[i].text:SetTextColor(1, 1, 1)
				icon[i].text:SetPoint("LEFT", icon[i], "RIGHT", 10, 0)
				icon[i].text:SetText(getInfo(LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")][i]).." (spellid: "..LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")][i]..")")
			end
		end

		local add = ns.createFonstring("buffwatcher", "add or delete buffs to be watched (per spellid):")
		add:SetPoint("LEFT", header1, "RIGHT", 100, 0)

		local eb = ns.createInputbox("buffwatcher", 50, 20, nil)
		eb:SetPoint("TOPLEFT", add, "BOTTOMLEFT", 5, -8)

		local previewicon = ns["buffwatcher"]:CreateTexture(nil, "OVERLAY")
		previewicon:SetTexCoord(.04, .94, .04, .94)
		previewicon:SetTexture(select(3, GetSpellInfo(212812)))
		previewicon:SetSize(16, 16)
		previewicon:SetPoint("LEFT", eb, "RIGHT", 5, 0)

		local prevname = ns.createFonstring("buffwatcher", GetSpellInfo(212812))
		prevname:SetPoint("LEFT", previewicon, "RIGHT", 5, 0)

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
			for k, v in pairs(LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")]) do
				if v == eb:GetText() then
					isduplicate = true
				end
			end
			if isduplicate == true then
				print("duplicate id detected!")
			else
				table.insert(LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")], eb:GetText())
				print("Hit Okay reload the list")
			end
		end)

		local b2 = CreateFrame("Button", "delButton", ns["buffwatcher"], "UIPanelButtonTemplate")
		b2:SetSize(80 ,22) -- width, height
		b2:SetText("delete")
		b2:SetPoint("LEFT", b, "RIGHT", 10, 0)
		b2:SetScript("OnClick", function()
			for k, v in pairs(LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")]) do
				if v == eb:GetText() then
					table.remove(LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")], k)
				end
			end
			print("Hit Okay to reload the list")
		end)

		local tip = ns.createFonstring("buffwatcher", "|cff5599ffPROTIP: |rrefer to WoWhead and search for your spell,\n the spellid is in the URL")
		tip:SetPoint("TOPLEFT", b, "BOTTOMLEFT", 0, -8)

		local help = ns["buffwatcher"]:CreateTexture(nil, "OVERLAY")
		help:SetSize(293, 66)
		help:SetTexture("Interface\\AddOns\\LolzenUI\\modules\\buffwatcher\\help.tga")
		help:SetPoint("TOPLEFT", tip, "BOTTOMLEFT", 0, -8)

		local pos_x_text = ns.createFonstring("buffwatcher", "PosX:")
		pos_x_text:SetPoint("TOPLEFT", help, "BOTTOMLEFT", 0, -20)

		local pos_x = ns.createInputbox("buffwatcher", 30, 20, LolzenUIcfg.buffwatcher["buffwatch_pos_x"])
		pos_x:SetPoint("LEFT", pos_x_text, "RIGHT", 10, 0)

		local pos_y_text = ns.createFonstring("buffwatcher", "PosY:")
		pos_y_text:SetPoint("LEFT", pos_x, "RIGHT", 5, 0)

		local pos_y = ns.createInputbox("buffwatcher", 30, 20, LolzenUIcfg.buffwatcher["buffwatch_pos_y"])
		pos_y:SetPoint("LEFT", pos_y_text, "RIGHT", 10, 0)

		local pos_desc = ns.createFonstring("buffwatcher", "The startingpoint is the center of the screen (0/0)")
		pos_desc:SetPoint("TOPLEFT", pos_x_text, "BOTTOMLEFT", 0, -8)

		local icon_size_text = ns.createFonstring("buffwatcher", "Icon Size:")
		icon_size_text:SetPoint("TOPLEFT", pos_desc, "BOTTOMLEFT", 0, -15)

		local icon_size = ns.createInputbox("buffwatcher", 30, 20, LolzenUIcfg.buffwatcher["buffwatch_icon_size"])
		icon_size:SetPoint("LEFT", icon_size_text, "RIGHT", 10, 0)

		local icon_spacing_text = ns.createFonstring("buffwatcher", "Icon Spacing:")
		icon_spacing_text:SetPoint("LEFT", icon_size, "RIGHT", 5, 0)

		local icon_spacing = ns.createInputbox("buffwatcher", 30, 20, LolzenUIcfg.buffwatcher["buffwatch_icon_spacing"])
		icon_spacing:SetPoint("LEFT", icon_spacing_text, "RIGHT", 10, 0)

		ns["buffwatcher"].okay = function(self)
			LolzenUIcfg.buffwatcher["buffwatch_pos_x"] = tonumber(pos_x:GetText())
			LolzenUIcfg.buffwatcher["buffwatch_pos_y"] = tonumber(pos_y:GetText())
			LolzenUIcfg.buffwatcher["buffwatch_icon_size"] = tonumber(icon_size:GetText())
			LolzenUIcfg.buffwatcher["buffwatch_icon_spacing"] = tonumber(icon_spacing:GetText())
		end

		ns["buffwatcher"].default = function(self)
			LolzenUIcfg.buffwatcher["buffwatchlist"] = {}
			LolzenUIcfg.buffwatcher["buffwatch_pos_x"] = -250
			LolzenUIcfg.buffwatcher["buffwatch_pos_y"] = -140
			LolzenUIcfg.buffwatcher["buffwatch_icon_size"] = 52
			LolzenUIcfg.buffwatcher["buffwatch_icon_spacing"] = 5
			ReloadUI()
		end
	end
end)