local _, ns = ...

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

	--[[
	local overlay = button.overlay
	overlay.SetVertexColor = overlayProxy
	overlay:SetTexture("Interface\\AddOns\\LolzenUI\\media\\auraborder")
	overlay:SetTexCoord(.07, .93, .07, .93)
	]]
end

local PostUpdateIcon = function(icons, unit, button, index, offset, filter, isDebuff)
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
	self.Auras = Auras
end

function ns.AddBuffs(self, unit)
	local Buffs = CreateAura(self, 8)
	self.Buffs = Buffs
end

function ns.AddDebuffs(self, unit)
	local Debuffs = CreateAura(self, 8)
	self.Debuffs = Debuffs
end