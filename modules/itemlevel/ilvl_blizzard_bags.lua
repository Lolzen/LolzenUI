local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

local function updateItemButton(button)
    if not button or not button.GetItemLocation then return end
    
    local itemLocation = button:GetItemLocation()
    if not itemLocation or not C_Item.DoesItemExist(itemLocation) then
        if button.itemLevel then button.itemLevel:Hide() end
        return
    end

    local itemLink = C_Item.GetItemLink(itemLocation)
    if not itemLink then
        if button.itemLevel then button.itemLevel:Hide() end
        return
    end

    local itemLevel = GetDetailedItemLevelInfo(itemLink)
    local _, _, _, _, _, itemClassID = GetItemInfoInstant(itemLink)
    local isEquippable = itemClassID == Enum.ItemClass.Weapon or itemClassID == Enum.ItemClass.Armor

    if isEquippable and itemLevel then
        if not button.itemLevel then
            button.itemLevel = button:CreateFontString(nil, "OVERLAY")
            button.itemLevel:SetPoint(LolzenUIcfg.itemlevel["ilvl_anchor"], button, LolzenUIcfg.itemlevel["ilvl_font_posx"], LolzenUIcfg.itemlevel["ilvl_font_posy"])
            button.itemLevel:SetFont(LSM:Fetch("font", LolzenUIcfg.itemlevel["ilvl_font"]), LolzenUIcfg.itemlevel["ilvl_font_size"], LolzenUIcfg.itemlevel["ilvl_font_flag"])
        end
        button.itemLevel:SetText(itemLevel)
        button.itemLevel:SetTextColor(unpack(LolzenUIcfg.itemlevel["ilvl_font_color"]))
        button.itemLevel:Show()
    elseif button.itemLevel then
        button.itemLevel:Hide()
    end
end

local function updateContainer(container)
    if not container then return end
    for _, button in pairs(container.Items or {}) do
        updateItemButton(button)
    end
end

local function updateAllBags()
    if ContainerFrameCombinedBags:IsShown() then
        updateContainer(ContainerFrameCombinedBags)
    else
        for i = 1, NUM_BAG_FRAMES do
            updateContainer(_G["ContainerFrame"..i])
        end
    end
    if BankFrame and BankFrame:IsShown() then
        for i = 1, NUM_BANKGENERIC_SLOTS do
            updateItemButton(_G["BankFrameItem"..i])
        end
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("BAG_UPDATE")
f:RegisterEvent("BAG_UPDATE_DELAYED")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("BANKFRAME_OPENED")
f:RegisterEvent("BANKFRAME_CLOSED")
f:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
f:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE")

f:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if not LolzenUIcfg or not LolzenUIcfg.modules or LolzenUIcfg.modules["itemlevel"] == false then return end
        updateAllBags()
        hooksecurefunc("ToggleAllBags", updateAllBags)
        hooksecurefunc("ToggleBag", updateAllBags)
        hooksecurefunc(ContainerFrameCombinedBags, "Show", updateAllBags)
        if ContainerFrameUtil_UpdateContainerFrameAnchors then
            hooksecurefunc("ContainerFrameUtil_UpdateContainerFrameAnchors", updateAllBags)
        end
    elseif event == "BAG_UPDATE" or event == "BAG_UPDATE_DELAYED" or
           event == "BANKFRAME_OPENED" or event == "BANKFRAME_CLOSED" then
        updateAllBags()
    elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" or event == "PLAYER_INTERACTION_MANAGER_FRAME_HIDE" then
        if ... == Enum.PlayerInteractionType.Banker then
            updateAllBags()
        end
    end
end)