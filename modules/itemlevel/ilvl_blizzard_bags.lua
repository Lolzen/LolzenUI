--// itemlevel (Blizzard bags & bank) // --

local _, ns = ...

local IL
local containers = {}

local function updateButton(button, bag, slot)
	if IL.IsEnabled("ilvl_bags") then
		IL.Set(button, IL.FromBagSlot(bag, slot))
	else
		IL.Set(button, nil)
	end
end

local function updateContainer(frame)
	if not frame:IsShown() then return end
	if frame.EnumerateValidItems then
		for _, button in frame:EnumerateValidItems() do
			updateButton(button, button:GetBagID(), button:GetID())
		end
	elseif frame.Items then
		for _, button in ipairs(frame.Items) do
			if button.GetBagID then
				updateButton(button, button:GetBagID(), button:GetID())
			end
		end
	end
end

-- 11.2+ bank panel
local function updateBank()
	local panel = BankPanel
	if not panel or not panel:IsShown() or not panel.EnumerateValidItems then return end
	for button in panel:EnumerateValidItems() do
		local bag = (button.GetBankTabID and button:GetBankTabID()) or button.bankTabID
		local slot = (button.GetContainerSlotID and button:GetContainerSlotID()) or button.containerSlotID
		updateButton(button, bag, slot)
	end
end

local function refresh()
	for frame in pairs(containers) do
		updateContainer(frame)
	end
	updateBank()
end

ns.OnLogin("itemlevel", function()
	IL = ns.ItemLevel

	local frames = {ContainerFrameCombinedBags}
	for i = 1, (NUM_TOTAL_BAG_FRAMES or NUM_CONTAINER_FRAMES or 13) do
		frames[#frames + 1] = _G["ContainerFrame"..i]
	end
	for _, frame in pairs(frames) do
		if frame and not containers[frame] then
			containers[frame] = true
			-- the container frames update their buttons in UpdateItems
			if frame.UpdateItems then
				hooksecurefunc(frame, "UpdateItems", updateContainer)
			end
			frame:HookScript("OnShow", updateContainer)
		end
	end

	if BankPanel then
		BankPanel:HookScript("OnShow", function() C_Timer.After(0, updateBank) end)
	end

	local events = CreateFrame("Frame")
	events:RegisterEvent("BAG_UPDATE_DELAYED")
	events:RegisterEvent("BANKFRAME_OPENED")
	pcall(events.RegisterEvent, events, "PLAYERBANKSLOTS_CHANGED")
	-- the container frames are covered by the UpdateItems hook
	events:SetScript("OnEvent", updateBank)

	IL.RegisterRefresher(refresh)
end)
