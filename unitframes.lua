--[[	unitframes based on oUF_Lily & oUF_Lolzen ; depends on oUF 1.6.5
	ToDo:
	*party/raidframes
	*bossframe(?)
	*cleanup
	---------------
	combobar
	runebar
	soulshardbar
	etc
]]

-- tags
local siValue = function(val)
	if val >= 1e6 then
		return ('%.1f'):format(val / 1e6):gsub('%.', 'm')
	elseif val >= 1e4 then
		return ("%.1f"):format(val / 1e3):gsub('%.', 'k')
	else
		return val
	end
end

local tags = oUF.Tags.Methods or oUF.Tags
local tagevents = oUF.TagEvents or oUF.Tags.Events

tags["lolzen:health"] = function(unit)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
	
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	return siValue(min)
end

tags["lolzen:power"] = function(unit)
	local min, max = UnitPower(unit), UnitPowerMax(unit)
	if min == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end

	return siValue(min)
end
tagevents["lolzen:power"] = tagevents.missingpp

tags["lolzen:level"] = function(unit)
	if not UnitLevel(unit) or UnitLevel(unit) == -1 then
		return "|cffff0000??|r "
	else
		return ("|cff%02x%02x%02x%d|r"):format(GetQuestDifficultyColor(UnitLevel(unit)).r*255, GetQuestDifficultyColor(UnitLevel(unit)).g*255, GetQuestDifficultyColor(UnitLevel(unit)).b*255, UnitLevel(unit))
	end
end
-- tags end

-- change some power colors
oUF.colors.power[0] = {48/255, 113/255, 191/255} --mana
oUF.colors.power[2] = {255/255, 178/255, 0} --focus
oUF.colors.power[3] = {1.00, 1.00, 34/255} --energy
oUF.colors.power[13] = {0.84, 0.1, 0.87} --insanity (everything darker is unseeable on the powerbar)

local RAID_TARGET_UPDATE = function(self, event)
	local index = GetRaidTargetIndex(self.unit)
	if index then
		self.RIcon:SetText(ICON_LIST[index].."23|t")
	else
		self.RIcon:SetText()
	end
end

local PostCastStart = function(Castbar, unit, spell, spellrank)
	if not unit == "targettarget" then
		Castbar:GetParent().Name:SetText(spell)
	end
end

local PostCastStop = function(Castbar, unit)
	local name
	if unit:sub(1,4) == "boss" then
		-- And people complain about Lua's lack for full regexp support.
		name = UnitName(unit):gsub('(%u)%S* %l*%s*', '%1 ')
	else
		name = UnitName(unit)
	end

	Castbar:GetParent().Name:SetText(name)
end

local PostCastStopUpdate = function(self, event, unit)
	if unit ~= self.unit then return end
	return PostCastStop(self.Castbar, unit)
end

local PostUpdateHealth = function(Health, unit, min, max)
	if UnitIsDead(unit) then
		Health:SetValue(0)
	elseif UnitIsGhost(unit) then
		Health:SetValue(0)
	end
	local gradient = { 1, 1, 0, 0, 1, 1, 0, 0, 1, 0}

	--this is somewhat bugged, howewer gradient table matches Health.colorSmooth = true
	--local r, g, b = oUF.ColorGradient(min / max, unpack(oUF.colors.smooth)) 
	local r, g, b = oUF.ColorGradient(min / max, unpack(gradient))
	Health.value:SetTextColor(r,g,b)
end

local PostUpdateThreat = function(Threat, unit)
	local Glow = Threat:GetParent()
	local status = UnitThreatSituation(unit)
	if status and status > 0 then
		Glow:Show()
	else
		Glow:Hide()
	end
end

local PostUpdatePower = function(Power, unit, min, max)
	local Health = Power:GetParent().Health
	local color = oUF.colors.power[UnitPowerType(unit)]
	
	if min == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		Power:Hide()
		if unit == "targettarget" then
			Health:SetHeight(18)
		else
			Health:SetHeight(21)
		end
	else
		
		if unit == "targettarget" then
			Health:SetHeight(18)
		else
			Health:SetHeight(19)
			Power:Show()
		end
	end
	--power.colorPower won't overtake the custom power colors set earlier
	Power:SetStatusBarColor(color[1], color[2], color[3])
	Power.value:SetTextColor(color[1], color[2], color[3])
end

local PostCreateIcon = function(Auras, button)
	local count = button.count
	count:ClearAllPoints()
	count:SetPoint"BOTTOM"

	button.icon:SetTexCoord(.07, .93, .07, .93)
	
	local iconborder = CreateFrame("Frame")
	iconborder:SetBackdrop({
		edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	iconborder:SetParent(button)
	iconborder:SetPoint("TOPLEFT", button, -2, 3)
	iconborder:SetPoint("BOTTOMRIGHT", button, 3, -2)
	iconborder:SetBackdropBorderColor(0, 0, 0)
	iconborder:SetFrameLevel(3)
	
	local overlay = button.overlay
	overlay.SetVertexColor = overlayProxy
	overlay:Hide()
	overlay.Show = overlay.Hide
	overlay.Hide = overlayHide
end

local PostUpdateIcon
do
	local playerUnits = {
		player = true,
		pet = true,
		vehicle = true,
	}

	PostUpdateIcon = function(icons, unit, icon, index, offset, filter, isDebuff)
		local texture = icon.icon
		if(playerUnits[icon.owner]) then
			texture:SetDesaturated(false)
		else
			texture:SetDesaturated(true)
		end
	end
end

local PostUpdateGapIcon = function(Auras, unit, icon, visibleBuffs)
	if(Auras.currentGap) then
		Auras.currentGap.Border:Show()
	end

	icon.Border:Hide()
	Auras.currentGap = icon
end

local CreateAura = function(self, num)
	local size = 23
	local Auras = CreateFrame("Frame", nil, self)

	Auras:SetSize(num * (size + 4), size)
	Auras.num = num
	Auras.size = size
	Auras.spacing = 4

	Auras.PostCreateIcon = PostCreateIcon

	return Auras
end

local shared = function(self, unit, isSingle)
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	self:RegisterForClicks("AnyUp")
	
	local Border = CreateFrame("Frame", nil, self)
	Border:SetBackdrop({
		edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	if unit == "targettarget" then
		Border:SetPoint("TOPLEFT", self, -3, 3)
		Border:SetPoint("BOTTOMRIGHT", self, 3, -1)
	else
		Border:SetPoint("TOPLEFT", self, -3, 3)
		Border:SetPoint("BOTTOMRIGHT", self, 3, -2)
	end
	Border:SetBackdropBorderColor(0, 0, 0)
	Border:SetFrameLevel(3)

	local Glow = CreateFrame("Frame", nil, self)
	Glow:SetBackdrop({
		edgeFile ="Interface\\AddOns\\LolzenUI\\media\\glow", edgeSize = 5,
		insets = {left = 4, right = 4, top = 4, bottom = 4}
	})
	if unit == "player" then
		Glow:SetPoint("TOPLEFT", self, -5, 5)
		Glow:SetPoint("BOTTOMRIGHT", self, 5, -5)
		Glow:SetBackdropBorderColor(6, 0, 0)
	end

	-- workaround so we can actually have an glow border
	local threat = Glow:CreateTexture(nil, "OVERLAY")
	self.Threat = threat
	
	local Health = CreateFrame("StatusBar", nil, self)
	if unit == "targettarget" then
		Health:SetHeight(16)
	else
		Health:SetHeight(19)
	end
	Health:SetStatusBarTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")

	Health.frequentUpdates = true
	Health.colorTapping = true
	Health.colorClass = true
	Health.colorReaction = true

	Health:SetPoint("TOP")
	Health:SetPoint("LEFT")
	Health:SetPoint("RIGHT")

	self.Health = Health

	local HealthPoints = Health:CreateFontString(nil, "OVERLAY")
	HealthPoints:SetPoint("RIGHT", -2, 8)
	if unit == "targettarget" then
		HealthPoints:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 18, "THINOUTLINE")
	else
		HealthPoints:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 24, "THINOUTLINE")
	end
	self:Tag(HealthPoints, "[|cffc41f3b>dead<|r][|cff999999>offline<|r][lolzen:health]") 

	Health.value = HealthPoints

	local Power = CreateFrame("StatusBar", nil, self)
	Power:SetHeight(3)
	Power:SetStatusBarTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")

	Power.frequentUpdates = true

	Power:SetPoint("LEFT")
	Power:SetPoint("RIGHT")
	Power:SetPoint("TOP", Health, "BOTTOM")

	self.Power = Power

	local PowerPoints = Power:CreateFontString(nil, "OVERLAY")
	PowerPoints:SetPoint("RIGHT", HealthPoints, "LEFT", 0, 0)
	PowerPoints:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 18, "THINOUTLINE")
	PowerPoints:SetTextColor(1, 1, 1)
	self:Tag(PowerPoints, "[lolzen:power< ]")

	Power.value = PowerPoints
	
	local bg = self:CreateTexture(nil, "BORDER")
	bg:SetAllPoints(self)
	bg:SetTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
	bg:SetVertexColor(0.3, 0.3, 0.3)
	bg:SetAlpha(1)
	
	local level = Health:CreateFontString(nil, "OVERLAY")
	level:SetPoint("LEFT", Health, "LEFT", 2, -21) 
	level:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 12, "THINOUTLINE")
	
	self.Level = level
	
	local RaidIcon = Health:CreateFontString(nil, "OVERLAY")
	RaidIcon:SetPoint("CENTER", 0, 10)
	RaidIcon:SetJustifyH("LEFT")
	RaidIcon:SetFontObject(GameFontNormalSmall)
	RaidIcon:SetTextColor(1, 1, 1)

	self.RIcon = RaidIcon
	self:RegisterEvent("RAID_TARGET_UPDATE", RAID_TARGET_UPDATE)
	table.insert(self.__elements, RAID_TARGET_UPDATE)
	
	local Castbar = CreateFrame("StatusBar", nil, self)
	Castbar:SetStatusBarTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
	Castbar:SetAllPoints(Health)
--	Castbar:SetStatusBarColor(0.8, 0, 0)
	self.Castbar = Castbar
		
	local Spark = Castbar:CreateTexture(nil, "OVERLAY")
	Spark:SetSize(8, 23)
	Spark:SetBlendMode("ADD")
	Spark:SetParent(Castbar)
	self.Castbar.Spark = Spark
		
	local icon = Castbar:CreateTexture(nil, "OVERLAY")
	icon:SetHeight(33)
	icon:SetWidth(33)
	icon:SetTexCoord(.07, .93, .07, .93)
	icon:SetPoint("RIGHT", Health, "LEFT", -4, 6)
	self.Castbar.Icon = icon
		
	local iconborder = CreateFrame("Frame")
	iconborder:SetBackdrop({
		edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	iconborder:SetParent(Castbar)
	iconborder:SetPoint("TOPLEFT", icon, -2, 3)
	iconborder:SetPoint("BOTTOMRIGHT", icon, 3, -2)
	iconborder:SetBackdropBorderColor(0, 0, 0)
	iconborder:SetFrameLevel(3)
	self.Castbar.Iconborder = iconborder
	
	local Time = Castbar:CreateFontString(nil, "OVERLAY")
	Time:SetPoint("TOPLEFT", icon, "TOPRIGHT", 8, 2)
	Time:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12 ,"OUTLINE")
	Time:SetTextColor(1, 1, 1)
	self.Castbar.Time = Time
		
	local cbtext = Castbar:CreateFontString(nil, "OVERLAY")
	cbtext:SetPoint("LEFT", Health, "LEFT", 2, 0)
	cbtext:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 14 ,"OUTLINE")
	cbtext:SetTextColor(1, 1, 1)
	self.Castbar.Text = cbtext
	
	local name = Health:CreateFontString(nil, "OVERLAY")
	if unit == "party" then
		name:SetPoint("LEFT", Health, "LEFT", 2, -2)
		name:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 14, "THINOUTLINE")
	else
		name:SetPoint("RIGHT", Health, "RIGHT", -2, -21)
		name:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 12, "THINOUTLINE")
	end
	name:SetTextColor(1, 1, 1)

	self.Name = name
	
	if(isSingle) then
		self:SetSize(220, 21)
	end
	
	if unit == "target" then
		self:Tag(level, '[lolzen:level][shortclassification]')
	end
	
	self:RegisterEvent('UNIT_NAME_UPDATE', PostCastStopUpdate)
	table.insert(self.__elements, PostCastStopUpdate)
	
	Castbar.PostChannelStart = PostCastStart
	Castbar.PostCastStart = PostCastStart

	Castbar.PostCastStop = PostCastStop
	Castbar.PostChannelStop = PostCastStop
	
	Health.PostUpdate = PostUpdateHealth
	Power.PostUpdate = PostUpdatePower
	
	threat.PostUpdate = PostUpdateThreat
end

local UnitSpecific = {
	player = function(self, ...)
		shared(self, ...)
		local AltPowerBar = CreateFrame("StatusBar", nil, self)
		AltPowerBar:SetHeight(3)
		AltPowerBar:SetStatusBarTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
		AltPowerBar:SetStatusBarColor(1, 1, 1)

		AltPowerBar:SetPoint("LEFT")
		AltPowerBar:SetPoint("RIGHT")
		AltPowerBar:SetPoint("TOP", self.Power, "BOTTOM")

		self.AltPowerBar = AltPowerBar
		
		local Background = AltPowerBar:CreateTexture(nil, 'BORDER')
		Background:SetTexture(0, 0, 0, .4)
		Background:SetAllPoints()
		
		self.Name:Hide()
	end,
	
	target = function(self, ...)
		shared(self, ...)
		
		local Debuffs = CreateAura(self, 8)
		Debuffs:SetPoint("TOP", self, "BOTTOM", 0, -30)
		Debuffs.showDebuffType = true
		Debuffs.onlyShowPlayer = true
		Debuffs.PostUpdateIcon = PostUpdateIcon

		self.Debuffs = Debuffs
		
		--local dcounter = 
		
		local panel = CreateFrame("Frame")
		panel:SetBackdrop({
			bgFile = "Interface\\AddOns\\LolzenUI\\media\\statusbar",
			edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12,
			insets = {left = 2, right = 2, top = 2, bottom = 2},
		})
		panel:SetParent(self)
		panel:SetSize(224, 18)
		panel:SetPoint("TOP", self.Health, "BOTTOM", 0, -2)
		panel:SetBackdropBorderColor(0, 0, 0)
		panel:SetFrameLevel(3)
		panel:SetBackdropColor(0, 0, 0, 0.8)
	end,
	
	targettarget = function(self, ...)
		shared(self, ...)

		self:SetSize(120, 19)
		self.Castbar:SetAlpha(0)
		self.Power:SetAlpha(0)
		self.Name:Hide()
	end,

	party = function(self, ...)
		shared(self, ...)
		
		self.Castbar:SetAlpha(0)
		self.Power:SetAlpha(0)
		self.Name:Hide()
	end,
	
	pet = function(self, ...)
		shared(self, ...)
		
		self:SetSize(120, 19)
		self.Power:SetAlpha(0)
		self.Name:Hide()
	end,
}

-- A small helper to change the style into a unit specific, if it exists.
local spawnHelper = function(self, unit, ...)
	if(UnitSpecific[unit]) then
		self:SetActiveStyle('Lolzen - ' .. unit:gsub("^%l", string.upper))
	elseif(UnitSpecific[unit:match('%D+')]) then -- boss1 -> boss
		self:SetActiveStyle('Lolzen - ' .. unit:match('%D+'):gsub("^%l", string.upper))
	else
		self:SetActiveStyle'Lolzen'
	end

	local object = self:Spawn(unit)
	object:SetPoint(...)
	return object
end

oUF:RegisterStyle("Lolzen", shared)
for unit,layout in next, UnitSpecific do
	-- Capitalize the unit name, so it looks better.
	oUF:RegisterStyle('Lolzen - ' .. unit:gsub("^%l", string.upper), layout)
end

oUF:Factory(function(self)
--	local base = 100
--	spawnHelper(self, 'focus', "BOTTOM", 0, base + (40 * 1))
	spawnHelper(self, 'pet', "CENTER", -300, -177)
	spawnHelper(self, 'player', "CENTER", -250, -200)
	spawnHelper(self, 'target', "CENTER", 250, -200)
	spawnHelper(self, 'targettarget', "CENTER", 300, -177)

--	for n=1, MAX_BOSS_FRAMES or 5 do
--		spawnHelper(self,'boss' .. n, 'TOPRIGHT', -10, -155 - (40 * n))
--	end

	self:SetActiveStyle("Lolzen - Party")
	
	local party = self:SpawnHeader(
		nil, nil, 'party,solo', 
		'showParty', true, 
		'showPlayer', true,
		'showSolo', false,
		'xOffset', 7,
		'yoffset', 0,
		'oUF-initialConfigFunction', [[
			self:SetHeight(19)
			self:SetWidth(70)
		]],
		'maxColumns', 5, 
		'unitsperColumn', 1, 
		'columnSpacing', 7, 
		'columnAnchorPoint', "RIGHT"
	)
	party:SetPoint("BOTTOM", UIParent, 0, 140)
	--party:SetPoint("CENTER", 280, -70)
	
--		local raid = self:SpawnHeader(nil, nil, 'raid,party,solo',
--		'showPlayer', true,
--		'showSolo', false,
--		'showParty', true,
--		'showRaid', true,
--		'xoffset', 5,
--		'yOffset', -4,
--		'point', "TOP",
--		'groupFilter', '1,2,3,4,5,6,7,8',
--		'groupingOrder', '1,2,3,4,5,6,7,8',
--		'groupBy', 'GROUP',
--		'maxColumns', 7,
--		'unitsPerColumn', 5,
--		'columnSpacing', 5,
--		'columnAnchorPoint', "LEFT"
--	)
--	raid:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 40, -40)
end)