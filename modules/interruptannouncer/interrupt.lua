--// interruptannouncer // --

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["interruptannouncer"] == false then return end

		local eF = CreateFrame("Frame", "eventFrame", UIParent)
		eF:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

		function eF.COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, ...)
			local _, eventType, _, _, sourceName, _, _, _, destName, _, _, _, _, _, destSpellId = ...
			if sourceName == UnitName("Player") then
				if string.find(eventType, "_INTERRUPT") then
					local msg = LolzenUIcfg.interruptannouncer["interruptannouncer_msg"]
					-- find a !spell token and replace it with GetSpellLink(destSpellId)
					msg = string.gsub(msg, "!spell", GetSpellLink(destSpellId))
					--now if we find a !name token, replace it with destName
					msg = string.gsub(msg, "!name", destName)
					if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and LolzenUIcfg.interruptannouncer["interruptannoucer_instance"] == true then
						SendChatMessage(tostring(msg), "INSTANCE_CHAT")
					elseif IsInGroup(LE_PARTY_CATEGORY_HOME) and LolzenUIcfg.interruptannouncer["interruptannoucer_party"] == true then
						SendChatMessage(tostring(msg), "PARTY")
					else
						if LolzenUIcfg.interruptannouncer["interruptannoucer_say"] == true then
							SendChatMessage(tostring(msg), "SAY")
						end
					end
				end
			end
		end

		eF:SetScript("OnEvent", function(self, event, ...)  
			if(self[event]) then
				self[event](self, event, ...)
			else
				print("Interruptannouncer debug: "..event)
			end 
		end)
	end
end)