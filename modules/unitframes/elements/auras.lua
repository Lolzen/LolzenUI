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
end

local PostCreateIcon = function(Auras, button)
	local count = button.count
	count:ClearAllPoints()
	count:SetPoint("TOPLEFT")

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

	button.overlay:SetTexture("Interface\\AddOns\\LolzenUI\\media\\auraborder")
	button.overlay:SetTexCoord(.07, .93, .07, .93)
	button.overlay.Hide = function(self)
		self:SetVertexColor(0, 0, 0)
	end

	-- hide the default cooldown numbers
	button.cd:SetHideCountdownNumbers(true)

	local TimerP = CreateFrame("Frame", nil, button)
	TimerP:SetFrameLevel(20)
	
	local Duration = TimerP:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	Duration:SetFont("Interface\Addons\LolzenUI\fonts\DroidSansBold.ttf", 12, "THICKOUTLINE")
	Duration:SetTextColor(1, 1, 1)
	Duration:SetPoint("BOTTOMRIGHT", button, 0, 0)
	button.Duration = Duration
end

local PostUpdateIcon = function(icons, unit, button, index, offset, filter, isDebuff)
	local _, _, _, _, duration, expiration, owner, canStealOrPurge = UnitAura(unit, index, button.filter)
	if(duration and duration > 0) then
		button.expiration = expiration - GetTime()
		button:HookScript('OnUpdate', UpdateAuraTimer)
	else
		button.expiration = math.huge
		button:HookScript('OnUpdate', nil)
	end

	-- fix for boss, party & raid
	-- these have a number attached to their names
	if string.find(unit, "boss") then
		unit = "boss"
	elseif string.find(unit, "party") then
		unit = "party"
	elseif string.find(unit, "raid") then
		unit = "raid"
	end

	if LolzenUIcfg.unitframes[unit] and LolzenUIcfg.unitframes[unit]["uf_"..unit.."_aura_desature_nonplayer_auras"] == true then
		if button.isPlayer then
			button.icon:SetDesaturated(false)
		else
			button.icon:SetDesaturated(true)
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

	Auras.PostCreateIcon = PostCreateIcon
	Auras.PostUpdateIcon = PostUpdateIcon

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