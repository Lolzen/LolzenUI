-- Moving the ObjectiveTrackerFrame and hide it in combat
local eF = CreateFrame("Frame", "eventFrame", UIParent)
eF:RegisterEvent("PLAYER_ENTERING_WORLD")
eF:RegisterEvent("PLAYER_REGEN_DISABLED")
eF:RegisterEvent("PLAYER_REGEN_ENABLED")

function eF.PLAYER_ENTERING_WORLD()
	local of = ObjectiveTrackerFrame
	of:ClearAllPoints()
	of.ClearAllPoints = function() end
	of:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 30, -30)
	of.SetPoint = function() end
	of:SetHeight(650)
end

function eF.PLAYER_REGEN_DISABLED()
	local of = ObjectiveTrackerFrame
	of:Hide()
end

function eF.PLAYER_REGEN_ENABLED()
	local of = ObjectiveTrackerFrame
	of:Show()
end

eF:SetScript("OnEvent", function(self, event, ...)  
	if(self[event]) then
		self[event](self, event, ...)
	else
		print("LolzenUI - stateframe debug: "..event)
	end 
end)