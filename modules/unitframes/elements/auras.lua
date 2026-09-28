local _, ns = ...

local function FormatTime(seconds)
	local day, hour, minute = 86400, 3600, 60
	if (seconds >= day) then
		return format('%dd', floor(seconds/day + 0.5))
	elseif (seconds >= hour) then
		return format('%dh', floor(seconds/hour + 0.5))
	elseif (seconds >= minute) then
		if (seconds <= minute * 5) then
			return format('%d:%02d', floor(seconds/minute), seconds % minute)
		end
		return format('%dm', floor(seconds/minute + 0.5))
	else
		return format('%d', ceil(seconds))
	end
end
		
local function UpdateAuraTimer(self, elapsed)
	if(self.expiration) then
		self.expiration = self.expiration - elapsed

		if(self.expiration > 0) then
			self.Duration:SetFormattedText(FormatTime(self.expiration))
		end
	end
	
	--[[
	local timeLeft = aura.timeLeft - elapsed
	aura.Timer:SetText((timeLeft > 0) and FormatTime(timeLeft) or '')
	aura.timeLeft = timeLeft
	]]
end

local PostCreateIcon = function(Auras, button)
	local count = button.Count
	count:ClearAllPoints()
	count:SetPoint("TOPLEFT")

	button.Icon:SetTexCoord(.07, .93, .07, .93)

	local iconborder = CreateFrame("Frame", nil, button, "BackdropTemplate")
	iconborder:SetBackdrop({
		edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	iconborder:SetParent(button)
	iconborder:SetPoint("TOPLEFT", button, -2, 3)
	iconborder:SetPoint("BOTTOMRIGHT", button, 3, -2)
	iconborder:SetBackdropBorderColor(0, 0, 0)
	iconborder:SetFrameLevel(3)

	button.Overlay:SetTexture("Interface\\AddOns\\LolzenUI\\media\\auraborder")
	button.Overlay:SetTexCoord(.07, .93, .07, .93)
	button.Overlay.Hide = function(self)
		self:SetVertexColor(0, 0, 0)
	end

	-- hide the default cooldown numbers
	button.Cooldown:SetHideCountdownNumbers(true)
	--button.Cooldown.disableCooldown(true)

	local TimerP = CreateFrame("Frame", nil, button)
	TimerP:SetFrameLevel(20)
	
	local Duration = TimerP:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	Duration:SetFont("Interface\Addons\LolzenUI\fonts\DroidSansBold.ttf", 12, "THICKOUTLINE")
	Duration:SetTextColor(1, 1, 1)
	Duration:SetPoint("BOTTOMRIGHT", button, 0, 0)
	button.Duration = Duration

	button:HookScript('OnUpdate', UpdateAuraTimer)
	
--	local cd = button.Cooldown
--	cd = TimerP:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
--	cd:SetFont("Interface\Addons\LolzenUI\fonts\DroidSansBold.ttf", 12, "THICKOUTLINE")
--	cd:SetTextColor(1, 1, 1)
--	cd:SetPoint("BOTTOMRIGHT", button, 0, 0)
end

local PostUpdateIcon = function(element, button, unit, data, position)
	--local _, _, _, _, duration, expiration, owner, canStealOrPurge = UnitAura(unit, index, button.filter)
	if(data.duration and data.duration > 0 and data.duration <= 60) then
		button.expiration = data.expirationTime - data.duration
		--button.Duration:SetText(data.expirationTime)
	end

	-- fix for boss, party & raid
	-- these have a number attached to their names
--	if unit ~= nil then
--		if string.find(unit, "boss") then
--			unit = "boss"
--		elseif string.find(unit, "party") then
--			unit = "party"
--		elseif string.find(unit, "raid") then
--			unit = "raid"
--		elseif string.find(unit, "arena") then
--			unit = "arena"
--		end
--	end

	if button and button.Icon then
		if LolzenUIcfg.unitframes[unit] and LolzenUIcfg.unitframes[unit]["uf_"..unit.."_aura_desature_nonplayer_auras"] == true then
			--if button.isPlayer then
			--button.caster
			if data.sourceUnit == UnitName("player") then
				button.Icon:SetDesaturated(false)
			else
				button.Icon:SetDesaturated(true)
			end
		else
			button.Icon:SetDesaturated(false)
		end
	end
end

local CreateAura = function(self, num)
	local Auras = CreateFrame("Frame", nil, self)
	local unit = self.unit

	-- fix for boss, party & raid
	-- these have a number attached to their names
	if string.find(unit, "boss") then
		unit = "boss"
	elseif string.find(unit, "party") then
		unit = "party"
	elseif string.find(unit, "raid") then
		unit = "raid"
	elseif string.find(unit, "arena") then
		unit = "arena"
	end

	-- check if SVs exist, otherwise do nothing
	if LolzenUIcfg.unitframes[unit] and LolzenUIcfg.unitframes[unit]["uf_"..unit.."_aura_size"] then
		Auras:SetSize(num * (LolzenUIcfg.unitframes[unit]["uf_"..unit.."_aura_size"] + 4), LolzenUIcfg.unitframes[unit]["uf_"..unit.."_aura_size"])
		Auras.size = LolzenUIcfg.unitframes[unit]["uf_"..unit.."_aura_size"]
	-- create a fallback to prevent getting errors in BfA
	else
		Auras:SetSize(num * (23 + 4) , 23)
		Auras.size = 23
	end
	if LolzenUIcfg.unitframes[unit]["uf_"..unit.."_aura_spacing"] then
		Auras.spacing = LolzenUIcfg.unitframes[unit]["uf_"..unit.."_aura_spacing"]
	end

	Auras.PostCreateButton = PostCreateIcon
--	Auras.PostUpdateButton = PostUpdateIcon

	return Auras
end

function ns.AddAuras(self, unit)
	local Auras = CreateAura(self, 8)
	Auras.showDebuffType = true
	self.Auras = Auras
end

function ns.AddBuffs(self, unit)
	local Buffs = CreateAura(self, 8)
	self.Buffs = Buffs
end

function ns.AddDebuffs(self, unit)
	local Debuffs = CreateAura(self, 8)
	Debuffs.showDebuffType = true
	self.Debuffs = Debuffs
end