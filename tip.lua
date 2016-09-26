--[[	based on ProTip; partially rewritten for Legion ]]

--locals
local _G = getfenv(0)
local f = CreateFrame("Frame")
local tip = CreateFrame("Frame")

-- anchor
hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
	tooltip:SetOwner(parent,"ANCHOR_NONE")
	tooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -13, 43)
	tooltip:SetScale(1)
	tooltip.default = 1
end)

-- modify backdrop, border
local backdrop = { 
	bgFile = "Interface\\Buttons\\WHITE8x8",
	edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", 
	tile = false,
	tileSize = 8,
	edgeSize = 16,
	insets = {
		left = 3,
		right = 3,
		top = 3,
		bottom = 3
	}
}

local tooltips = {
	-- general tooltips
	GameTooltip,
	ItemRefTooltip,
	WorldMapTooltip,
	-- shopping tooltips
	ShoppingTooltip1,
	ShoppingTooltip2,
	ShoppingTooltip3,
}

-- Colors for the Tooltipborder (Classes, UnitReaction and ItemQuality)
local function colorBorder(self)
	local unit = select(2, GameTooltip:GetUnit())
	local _, class = UnitClass(unit)
	local reaction = UnitReaction(unit, "player")	
	
	if unit then
		local color
		if class and UnitIsPlayer(unit) then
			color = RAID_CLASS_COLORS[class]
		else
			color = FACTION_BAR_COLORS[UnitReaction(unit, "player")] or {r = 0.2, g = 0.2, b = 0.2}
		end
		self:SetBackdropBorderColor(color.r, color.g, color.b)
	else
		self:SetBackdropBorderColor(1, 1, 1)
	end
end
GameTooltip:HookScript("OnTooltipSetUnit", colorBorder)

	
local function colorItemQuality(self)
	local tooltipName = self:GetName()
	local _, link = self:GetItem()
	
	if link then
		local quality = link and select(3, GetItemInfo(link))
		if quality then
			local r, g, b = GetItemQualityColor(quality)
			self:SetBackdropBorderColor(r, g, b)
		end
	end
end

for i=1, #tooltips do
	tooltips[i]:SetScript("OnShow", colorItemQuality)
	if tooltips[i]:GetBackdrop() then
		tooltips[i]:SetBackdrop(backdrop)
	end
	tooltips[i]:HookScript("OnShow", function(self)
		if self.GetBackdropColor then
			self:SetBackdropColor(0, 0, 0, 1)
		end
	end)
end

-- Color names after UnitClass and UnitReaction
local function colorNames(unit)
	local color
	
	if UnitPlayerControlled(unit) then
		local _, class = UnitClass(unit)
		if class and UnitIsPlayer(unit) then
			color = RAID_CLASS_COLORS[class]
		elseif UnitCanAttack(unit, "player") then
			color = FACTION_BAR_COLORS[2]
		elseif UnitCanAttack("player", unit) then
			color = FACTION_BAR_COLORS[4]
		elseif UnitIsPVP(unit) then
			--color = FACTION_BAR_COLORS[6]
			color = RAID_CLASS_COLORS[class]
		end
	elseif UnitIsTapDenied(unit, "player") then
		color = {r = 0.6, g = 0.6, b = 0.6}
	end
	
	if not color then
		local reaction = UnitReaction(unit, "player")
		color = reaction and FACTION_BAR_COLORS[reaction] or {r = 0.6, g = 0.6, b = 0.6}
	end
	return color.r, color.g, color.b
end
GameTooltip_UnitColor = colorNames

local ricon = GameTooltip:CreateTexture("GameTooltipRaidIcon", "OVERLAY")
ricon:SetHeight(18)
ricon:SetWidth(18)
ricon:SetPoint("TOP", "GameTooltip", "TOP", 0, 5)

local mobType = {
	["worldboss"] = "Boss",
	["rareelite"] = "+ Rare",
	["rare"] = "Rare",
	["elite"] = "+",
}

--talents
local function InspectTalents(inspect)
	local talents = {}
	local numLines, linesNeeded = GameTooltip:NumLines()
	local unit = select(2, GameTooltip:GetUnit())
	if not unit then return end
	local guild, guildRankName, guildRankIndex = GetGuildInfo(unit)
	local pvp = UnitIsPVP(unit)
	local isInRange = CheckInteractDistance(unit, 1)
	local UnitIsPlayerControlled = UnitPlayerControlled(unit)
	
	if UnitIsPlayerControlled == false then return end
	
	for i=1, GetNumSpecGroups(unit) do -- check for Dualspec
		local group = GetActiveSpecGroup(unit) --check which Spec is active
		if group == 1 then
			activegroup = "|cffddff55<|r"
		elseif group == 2 then
			activegroup = "|cFFdddd55<<|r"
		end
	end
		
	local specID = GetInspectSpecialization(unit)
	local id, name, description, icon, background, role, class = GetSpecializationInfoByID(specID)
	
	local customRole
	if role == "HEALER" then
		role = "Heal"
	elseif role == "DAMAGER" then
		role = "Damage"
	elseif role == "TANK" then
		role = "Tank"
	end

	if not icon then return end
	local linetext = ((string.format("|T%s:%d:%d:0:-1|t", icon, 16, 16)).." "..name.." ("..role..")")
	
	if isInRange then
		if guild then
			_G["GameTooltipTextLeft4"]:SetText(linetext)
			_G["GameTooltipTextLeft4"]:Show()
		elseif not guild then
			_G["GameTooltipTextLeft3"]:SetText(linetext)
			_G["GameTooltipTextLeft3"]:Show()
		else
			GameTooltip:AddLine(linetext)
		end
	end
	
	GameTooltip:AppendText("")
end

--Scripts
f:SetScript("OnEvent",function(self, event, guid)
	self:UnregisterEvent("INSPECT_READY")
	InspectTalents(1)
end)

GameTooltip:HookScript("OnHide", function(self)
	ricon:SetTexture(nil)
end)

GameTooltip:HookScript("OnTooltipSetunit", function(self)
	local unit = select(2, GameTooltip:GetUnit())
	if not unit or not UnitExists(unit) then return end
	
	local name, realm = UnitName(unit)
	local _, pRealm = UnitName("player")
	local reaction = UnitReaction(unit, "player")
	
	if UnitIsPlayer(unit) and (UnitLevel(unit) > 9 or UnitLevel(unit) == -1) then
		if not InspectFrame or not InspectFrame:IsShown() then
			if CheckInteractDistance(unit,1) and CanInspect(unit) then
		
				f:RegisterEvent("INSPECT_READY")
				NotifyInspect(unit)
			end
		end
	end
	
	local class, race
	if UnitIsPlayer(unit) then
		race = UnitRace(unit)
		class = UnitClass(unit)
		local status
		if UnitIsAFK(unit) then
			status = CHAT_FLAG_AFK
		elseif UnitIsDND(unit) then
			status = CHAT_FLAG_DND
		elseif not UnitIsConnected(unit) then
			status = "(Off) "
		else
			status = "" 
		end
		if realm and not realm == pRealm then
			name = status..name.."-"..realm
		else
			name = status..name
		end
	end
	
	local creatureType = UnitCreatureType(unit) or ""

	local level = UnitLevel(unit)
	local classif = UnitClassification(unit)
	mobType = mobType and mobType[classif] or ""
	if not level or level == -1 then
		level = "|cffff0000??|r "
	else
		local diff = GetQuestDifficultyColor(level)
		level = ("|cff%02x%02x%02x%d|r"):format(diff.r*255, diff.g*255, diff.b*255, level)
	end

	local text
	if UnitIsPlayer(unit) then
		text = level.." "..race.." "..class
	else
		text = level.." "..classif.." "..creatureType
	end
	
	local PvPColor
	if UnitIsFriend("player", unit) then
		PvPcolor = "|cff00ff00"
	else
		PvPcolor = "|cffff0000"
	end
	
	local numLines = GameTooltip:NumLines()	
	if UnitIsPlayer(unit) and UnitIsPVP(unit) and isInInstance ~= "pvp" and isInInstance ~= "arena" and GetZonePVPInfo() ~= "combat" then
		_G["GameTooltipTextLeft1"]:SetText(PvPcolor.."(PvP) |r"..name)
	else
		_G["GameTooltipTextLeft1"]:SetText(name)
	end
	
	if UnitIsPlayer(unit) and UnitIsPVP(unit) then
		for i=2, numLines do
			if _G["GameTooltipTextLeft"..i]:GetText():find(PVP_ENABLED) then
				_G["GameTooltipTextLeft"..i]:Hide()
				GameTooltip:AppendText("")
			end
		end
	end
	
	for i=1, numLines do
		if _G["GameTooltipTextLeft"..i]:GetText():find("^"..LEVEL) then
			_G["GameTooltipTextLeft"..i]:SetText(text)
		end
	end

	if UnitIsPlayer(unit) and IsInGuild() then
		local guild, guildRankName, guildRankIndex = GetGuildInfo(unit)
		for i=1, numLines do
			if _G["GameTooltipTextLeft"..i]:GetText():find("^"..GetGuildInfo("player")) then
				_G["GameTooltipTextLeft"..i]:SetText("|cff22eeee"..guild.."|r")
			end
		end
	end
	
	GameTooltipStatusBar:ClearAllPoints()
	GameTooltipStatusBar:SetPoint("BOTTOMLEFT", 5, 4)
	GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", -5, 4)
	GameTooltipStatusBar:SetStatusBarTexture("Interface\\AddOns\\ProTip\\media\\statusbar")
	GameTooltipStatusBar:SetStatusBarColor(0.3, 0.9, 0.3, 1)
	GameTooltipStatusBar:SetHeight(2)
	
	--Background for our bar
	if not GameTooltipStatusBar.bg then
		local bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(GameTooltipStatusBar)
		bg:SetTexture("Interface\\AddOns\\ProTip\\media\\statusbar")
		bg:SetVertexColor(0.4, 0.4, 0.4, 0.4)
	end
	
	local raidIndex = GetRaidTargetIndex(unit)
	if raidIndex then
		ricon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..raidIndex)
	end
end)

-- ClassColors
local function ClassColors(class)
	local unit = select(2, GameTooltip:GetUnit())
	if not unit then return end
	local _, class = UnitClass(unit.."target")
	local color
	if IsAddOnLoaded("!ClassColors") then
		color = CUSTOM_CLASS_COLORS[class]
	else
		color = RAID_CLASS_COLORS[class]
	end
	return ("|cff%.2x%.2x%.2x"):format(color.r*255,color.g*255,color.b*255)
end

local activetl
local updateTime = 0
tip:SetScript("OnUpdate", function(self, elapsed)
	local _, unit = GameTooltip:GetUnit()
	if not unit or not UnitExists(unit) then return end

	updateTime = updateTime - elapsed
	if(updateTime > 0) then return end
	updateTime = 0.1

	unit = unit.."target"

	local text, ureaction
	if UnitIsPlayer(unit) and UnitName(unit) == UnitName("player") then
		text = "|cffffffff[YOU]"
	elseif UnitIsPlayer(unit) then
		text = ClassColors()..UnitName(unit).."|r"
	else
		ureaction = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
		if ureaction then
			text = ("|cff%02x%02x%02x%s|r"):format(ureaction.r*255, ureaction.g*255, ureaction.b*255, UnitName(unit))
		end
	end	
	
	if UnitExists(unit) then
		_G["GameTooltipTextRight1"]:SetText("|cffffffff>>|r"..text)
		_G["GameTooltipTextRight1"]:Show()
	elseif not UnitExists(unit) then
		_G["GameTooltipTextRight1"]:Hide()
	else
		print("TARGETLINE ERROR")
	end
	
	GameTooltip:AppendText("")
end)