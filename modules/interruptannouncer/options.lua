--// options for interruptannouncer //--

local addon, ns = ...

ns.RegisterModule("interruptannouncer")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["interruptannouncer"] == true then

		local title = ns.createTitle("interruptannouncer")

		local about = ns.createDescription("interruptannouncer", "Announces interrupts")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)

		local cb1 = ns.createCheckBox("interruptannouncer", "instanceannounce", "|cff5599ffannounce interrupts in instance chat|r", LolzenUIcfg.interruptannouncer["interruptannoucer_instance"])
		cb1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)

		local cb2 = ns.createCheckBox("interruptannouncer", "partyannounce", "|cff5599ffannounce interrupts in party chat|r", LolzenUIcfg.interruptannouncer["interruptannoucer_party"])
		cb2:SetPoint("TOPLEFT", cb1, "BOTTOMLEFT", 0, 0)

		local cb3 = ns.createCheckBox("interruptannouncer", "sayannounce", "|cff5599ffannounce interrupts in say chat|r", LolzenUIcfg.interruptannouncer["interruptannoucer_say"])
		cb3:SetPoint("TOPLEFT", cb2, "BOTTOMLEFT", 0, 0)

		local msg_text = ns.createFonstring("interruptannouncer", "Message:")
		msg_text:SetPoint("TOPLEFT", cb3, "BOTTOMLEFT", 0, -13)

		local msg = ns.createInputbox("interruptannouncer", 400, 20, LolzenUIcfg.interruptannouncer["interruptannouncer_msg"])
		msg:SetPoint("LEFT", msg_text, "RIGHT", 10, 0)

		local msg_desc = ns.createFonstring("interruptannouncer", "use |cff5599ff!spell|r for the interrupted spell and |cff5599ff!name|r for the unit's name which was interrupted")
		msg_desc:SetPoint("TOPLEFT", msg_text, "BOTTOMLEFT", 0, -8)

		ns["interruptannouncer"].okay = function(self)
			if cb1:GetChecked(true) then
				LolzenUIcfg.interruptannouncer["interruptannoucer_instance"] = true
			else
				LolzenUIcfg.interruptannouncer["interruptannoucer_instance"] = false
			end
			if cb2:GetChecked(true) then
				LolzenUIcfg.interruptannouncer["interruptannoucer_party"] = true
			else
				LolzenUIcfg.interruptannouncer["interruptannoucer_party"] = false
			end
			if cb3:GetChecked(true) then
				LolzenUIcfg.interruptannouncer["interruptannoucer_say"] = true
			else
				LolzenUIcfg.interruptannouncer["interruptannoucer_say"] = false
			end
			LolzenUIcfg.interruptannouncer["interruptannouncer_msg"] = msg:GetText()
		end

		ns["interruptannouncer"].default = function(self)
			LolzenUIcfg.interruptannouncer["interruptannoucer_instance"] = true
			LolzenUIcfg.interruptannouncer["interruptannoucer_party"] = true
			LolzenUIcfg.interruptannouncer["interruptannoucer_say"] = true
			LolzenUIcfg.interruptannouncer["interruptannouncer_msg"] = "Unterbrochen: !spell von >>!name<<"
			ReloadUI()
		end
	end
end)