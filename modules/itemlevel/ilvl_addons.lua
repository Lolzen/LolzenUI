--// itemlevel (bag addons) // --
-- Bagnon, Combuctor, Baggins, Inventorian, LiteBag and BaudBag

local _, ns = ...

local IL
local integrations = {}

local function getBag(button)
	if button.GetBag then
		return button:GetBag()
	end
	if button.bag then
		return button.bag
	end
	local parent = button:GetParent()
	return parent and parent:GetID()
end

local function getLink(button, bag, slot)
	local info = button.info
	if type(info) == "table" and info.hyperlink then
		return info.hyperlink
	end
	if bag and slot then
		return C_Container.GetContainerItemLink(bag, slot)
	end
end

-- works for cached (offline) items as well, as it only needs the item link
local function updateButton(button)
	if not button or not IL.IsEnabled("ilvl_bags") then
		return button and IL.Set(button, nil)
	end
	local bag, slot = getBag(button), button:GetID()
	IL.Set(button, IL.FromLink(getLink(button, bag, slot)))
end

integrations.Bagnon = function()
	local class = Bagnon.Item or Bagnon.ItemSlot
	if class and class.Update then
		hooksecurefunc(class, "Update", updateButton)
	end
end

integrations.Combuctor = function()
	local class = Combuctor.Item or Combuctor.ItemSlot
	if class and class.Update then
		hooksecurefunc(class, "Update", updateButton)
	end
end

integrations.Baggins = function()
	if Baggins.UpdateItemButton then
		hooksecurefunc(Baggins, "UpdateItemButton", function(_, _, button)
			updateButton(button)
		end)
	end
end

integrations.Inventorian = function()
	local addon = LibStub("AceAddon-3.0", true) and LibStub("AceAddon-3.0"):GetAddon("Inventorian", true)
	local class = addon and addon.Item and addon.Item.prototype
	if class and class.Update then
		hooksecurefunc(class, "Update", updateButton)
	end
end

integrations.LiteBag = function()
	if LiteBag_RegisterHook then
		LiteBag_RegisterHook("LiteBagItemButton_Update", updateButton)
	end
end

integrations.BaudBag = function()
	local events = CreateFrame("Frame")
	events:RegisterEvent("BAG_UPDATE_DELAYED")
	events:RegisterEvent("BANKFRAME_OPENED")
	events:SetScript("OnEvent", function()
		for bag = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS do
			for slot = 1, C_Container.GetContainerNumSlots(bag) do
				local button = _G["BaudBagSubBag"..bag.."Item"..slot]
				if button then
					local itemLevel, quality = IL.FromLink(C_Container.GetContainerItemLink(bag, slot))
					IL.Set(button, itemLevel, quality, IL.IsEnabled("ilvl_bags"))
				end
			end
		end
	end)
end

local function setup(addon)
	local integration = integrations[addon]
	if integration then
		integrations[addon] = nil
		xpcall(integration, geterrorhandler())
	end
end

ns.OnLogin("itemlevel", function()
	IL = ns.ItemLevel
	for addon in pairs(integrations) do
		if C_AddOns.IsAddOnLoaded(addon) then
			setup(addon)
		end
	end
	if next(integrations) then
		local loader = CreateFrame("Frame")
		loader:RegisterEvent("ADDON_LOADED")
		loader:SetScript("OnEvent", function(self, _, addon)
			setup(addon)
			if not next(integrations) then
				self:UnregisterAllEvents()
			end
		end)
	end
end)
