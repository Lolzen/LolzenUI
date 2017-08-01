--// options for interruptannouncer //--

local addon, ns = ...

if not ns.modules["actionabars"] then
	tinsert(ns.modules, "interruptannouncer")
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg["interruptannouncer"] == true then

		local title = ns["interruptannouncer"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["interruptannouncer"], 16, -16)
		title:SetText("|cff5599ff"..ns["interruptannouncer"].name.."|r")

		local about = ns["interruptannouncer"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Announces interrupts")
		
		local cb1 = CreateFrame("CheckButton", "instanceannounce", ns["interruptannouncer"], "ChatConfigCheckButtonTemplate")
		cb1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		instanceannounceText:SetText("|cff5599ffannounce interrupts in instance chat|r")

		if LolzenUIcfg["interruptannoucer_instance"] == true then
			cb1:SetChecked(true)
		else
			cb1:SetChecked(false)
		end
		
		local cb2 = CreateFrame("CheckButton", "partyannounce", ns["interruptannouncer"], "ChatConfigCheckButtonTemplate")
		cb2:SetPoint("TOPLEFT", cb1, "BOTTOMLEFT", 0, 0)
		partyannounceText:SetText("|cff5599ffannounce interrupts in party chat|r")

		if LolzenUIcfg["interruptannoucer_party"] == true then
			cb2:SetChecked(true)
		else
			cb2:SetChecked(false)
		end
		
		local cb3 = CreateFrame("CheckButton", "sayannounce", ns["interruptannouncer"], "ChatConfigCheckButtonTemplate")
		cb3:SetPoint("TOPLEFT", cb2, "BOTTOMLEFT", 0, 0)
		sayannounceText:SetText("|cff5599ffannounce interrupts in say chat|r")

		if LolzenUIcfg["interruptannoucer_say"] == true then
			cb3:SetChecked(true)
		else
			cb3:SetChecked(false)
		end

		local msg_text = ns["interruptannouncer"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		msg_text:SetPoint("TOPLEFT", cb3, "BOTTOMLEFT", 0, -8)
		msg_text:SetText("|cff5599ffMessage:|r")
		
		local msg = CreateFrame("EditBox", nil, ns["interruptannouncer"], "InputBoxTemplate")
		msg:SetPoint("LEFT", msg_text, "RIGHT", 10, 0)
		msg:SetSize(400, 20)
		msg:SetAutoFocus(false)
		msg:ClearFocus()
		msg:SetText(LolzenUIcfg["interruptannouncer_msg"])
		msg:SetCursorPosition(0)
		
		local msg_desc = ns["interruptannouncer"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		msg_desc:SetPoint("TOPLEFT", msg_text, "BOTTOMLEFT", 0, -8)
		msg_desc:SetText("use |cff5599ff!spell|r for the interrupted spell and |cff5599ff!name|r for the unit's name which was interrupted")
		
		ns["interruptannouncer"].okay = function(self)
			if cb1:GetChecked(true) then
				LolzenUIcfg["interruptannoucer_instance"] = true
			else
				LolzenUIcfg["interruptannoucer_instance"] = false
			end
			if cb2:GetChecked(true) then
				LolzenUIcfg["interruptannoucer_party"] = true
			else
				LolzenUIcfg["interruptannoucer_party"] = false
			end
			if cb3:GetChecked(true) then
				LolzenUIcfg["interruptannoucer_say"] = true
			else
				LolzenUIcfg["interruptannoucer_say"] = false
			end
			LolzenUIcfg["interruptannouncer_msg"] = msg:GetText()
		end

		ns["interruptannouncer"].default = function(self)
			LolzenUIcfg["interruptannoucer_instance"] = true
			LolzenUIcfg["interruptannoucer_party"] = true
			LolzenUIcfg["interruptannoucer_say"] = true
			LolzenUIcfg["interruptannouncer_msg"] = "Unterbrochen: !spell von >>!name<<"
			ReloadUI()
		end
	end
end)