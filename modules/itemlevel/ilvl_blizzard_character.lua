--// itemlevel on the character frame and the inspect frame // --

local _, ns = ...

local IL

-- shirt and tabard are left out on purpose
local SLOTS = {
	"Head", "Neck", "Shoulder", "Back", "Chest", "Wrist",
	"Hands", "Waist", "Legs", "Feet", "Finger0", "Finger1",
	"Trinket0", "Trinket1", "MainHand", "SecondaryHand",
}
local slotIDs = {}

local function updateCharacter()
	if not PaperDollFrame or not PaperDollFrame:IsVisible() then return end
	local enabled = IL.IsEnabled("ilvl_characterframe")
	for i, name in ipairs(SLOTS) do
		local button = _G["Character"..name.."Slot"]
		if button then
			if enabled then
				local itemLevel, quality = IL.FromLocation(ItemLocation:CreateFromEquipmentSlot(slotIDs[i]))
				IL.Set(button, itemLevel, quality)
			else
				IL.Set(button, nil)
			end
		end
	end
end

local function updateInspect()
	local frame = InspectFrame
	if not frame or not frame:IsShown() or not frame.unit then return end
	local enabled = IL.IsEnabled("ilvl_inspectframe")
	for i, name in ipairs(SLOTS) do
		local button = _G["Inspect"..name.."Slot"]
		if button then
			if enabled then
				IL.Set(button, IL.FromLink(GetInventoryItemLink(frame.unit, slotIDs[i])))
			else
				IL.Set(button, nil)
			end
		end
	end
end

local function hookInspect()
	InspectFrame:HookScript("OnShow", updateInspect)
end

-- more precise stats: average item level and percentages with two decimals
local function setLabelAndText(statFrame, label, _, isPercentage, numericValue)
	if not numericValue or ns.IsSecret(numericValue) then return end
	if label == STAT_AVERAGE_ITEM_LEVEL then
		local _, equipped = GetAverageItemLevel()
		statFrame.Value:SetFormattedText("%.2f", equipped)
	elseif isPercentage then
		statFrame.Value:SetFormattedText("%.2f%%", numericValue)
	end
end

ns.OnLogin("itemlevel", function()
	IL = ns.ItemLevel
	for i, name in ipairs(SLOTS) do
		slotIDs[i] = GetInventorySlotInfo(name.."Slot")
	end

	PaperDollFrame:HookScript("OnShow", updateCharacter)
	if PaperDollFrame_SetLabelAndText then
		hooksecurefunc("PaperDollFrame_SetLabelAndText", setLabelAndText)
	end

	local events = CreateFrame("Frame")
	events:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	events:RegisterEvent("INSPECT_READY")
	events:RegisterEvent("ADDON_LOADED")
	events:SetScript("OnEvent", function(_, event, arg)
		if event == "PLAYER_EQUIPMENT_CHANGED" then
			updateCharacter()
		elseif event == "INSPECT_READY" then
			updateInspect()
		elseif arg == "Blizzard_InspectUI" then
			hookInspect()
		end
	end)
	if InspectFrame then
		hookInspect()
	end

	IL.RegisterRefresher(function()
		updateCharacter()
		updateInspect()
	end)
end)
