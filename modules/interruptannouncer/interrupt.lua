--// interruptannouncer // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["interruptannouncer"] == false then return end

		local eF = CreateFrame("Frame", "eventFrame", UIParent)
		eF:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

		function eF.COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, ...)
			local _, eventType, _, _, sourceName, _, _, _, destName, _, _, _, _, _, destSpellId = ...
			if sourceName == UnitName("Player") then
				if string.find(eventType, "_INTERRUPT") then
					if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
						SendChatMessage(tostring("Unterbrochen: "..GetSpellLink(destSpellId).." von >>"..destName.."<<"), "INSTANCE_CHAT")
					elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
						SendChatMessage(tostring("Unterbrochen: "..GetSpellLink(destSpellId).." von >>"..destName.."<<"), "PARTY")
					else
						SendChatMessage(tostring("Unterbrochen: "..GetSpellLink(destSpellId).." von >>"..destName.."<<"), "SAY")
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