--// interruptannouncer // --
local _, ns = ...
local L = ns.L
ns.RegisterModule("interruptannouncer", L["desc_interruptannouncer"], true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["interruptannouncer"] == false then return end
		
		local eF = CreateFrame("Frame", "eventFrame", UIParent)
		eF:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		
		function eF:COMBAT_LOG_EVENT_UNFILTERED()
			local _, eventType, _, _, sourceName, _, _, _, destName, _, _, _, _, _, destSpellId = CombatLogGetCurrentEventInfo()
			if sourceName == UnitName("player") then
				if eventType and eventType:find("_INTERRUPT") then
					local msg = LolzenUIcfg.interruptannouncer["interruptannouncer_msg"]
					-- find a !spell token and replace it with C_Spell.GetSpellLink(destSpellId)
					msg = msg:gsub("!spell", C_Spell.GetSpellLink(destSpellId) or "")
					-- now if we find a !name token, replace it with destName
					msg = msg:gsub("!name", destName or "")
					
					if IsInGroup(Enum.PartyCategory.Instance) and LolzenUIcfg.interruptannouncer["interruptannoucer_instance"] == true then
						SendChatMessage(msg, "INSTANCE_CHAT")
					elseif IsInGroup(Enum.PartyCategory.Home) and LolzenUIcfg.interruptannouncer["interruptannoucer_party"] == true then
						SendChatMessage(msg, "PARTY")
					end
				end
			end
		end
		
		eF:SetScript("OnEvent", function(self, event, ...)  
			if self[event] then
				self[event](self, ...)
			end
		end)
	end
end)