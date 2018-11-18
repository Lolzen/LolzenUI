--[[
# Element: Combat Fader

Changes the opacity of a unit frame based on whether the frame's unit is in combat.

## Widget

CombatFade - A table containing opacity values.

## Notes

Based on oUF_Fader by p3lim.

## Options

.outofcombatAlpha - Opacity when the unit is out of combat. Defaults to 0.3 (number)[0-1].
.incombatAlpha  - Opacity when the unit is in combat. Defaults to 1 (number)[0-1].
.smoothFade  - Enables smooth Transition fading (boolean).
.fadeTime  - Time which it take to fade in/out depending on combatsituation (number).
.elements  - Elements which are faded (table).


## Examples

	-- Register with oUF
    self.CombatFade = {
        incombatAlpha = 1,
        outofcombatAlpha = 0.3,
		smoothFade = true,
		fadeTime = 0.3,
		elements = {Health, Power},
    }
--]]

local _, ns = ...
local oUF = ns.oUF

local UnitAffectingCombat = UnitAffectingCombat

local function Update(self, event)
	local element = self.CombatFade
	local unit = self.unit

	--[[ Callback: CombatFade:PreUpdate()
	Called before the element has been updated.

	* self - the CombatFade element
	--]]
	if(element.PreUpdate) then
		element:PreUpdate()
	end
	
	local inCombat = UnitAffectingCombat(unit)
	for _, elements in pairs(element.elements) do
		if(inCombat) then
			if elements:GetAlpha() == element.incombatAlpha then return end
			if element.smoothFade then
				UIFrameFadeIn(elements, element.fadeTime, elements:GetAlpha(), element.incombatAlpha)
			else
				elements:SetAlpha(element.incombatAlpha)
			end
		else
			if elements:GetAlpha() == element.outofcombatAlpha then return end
			if element.smoothFade then
				UIFrameFadeOut(elements, element.fadeTime, elements:GetAlpha(), element.outofcombatAlpha)
			else
				elements:SetAlpha(element.outofcombatAlpha)
			end
		end
	end

	--[[ Callback: CombatFade:PostUpdate(object, inCombat)
	Called after the element has been updated.

	* self         - the CombatFade element
	* object       - the parent object
	* inCombat     - indicates if the unit was in combat (boolean)
	--]]
	if(element.PostUpdate) then
		return element:PostUpdate(self, inCombat)
	end
end

local function ForceUpdate(element)
	return Update(element.__owner, 'ForceUpdate')
end

local function Enable(self)
	local element = self.CombatFade
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		element.incombatAlpha = element.incombatAlpha or 1
		element.outofcombatAlpha = element.outofcombatAlpha or 0.3

		self:RegisterEvent('PLAYER_REGEN_ENABLED', Update)
		self:RegisterEvent('PLAYER_REGEN_DISABLED', Update)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', Update)
		self:HookScript('OnShow', Update)
		self:RegisterEvent('UNIT_TARGET', Update)

		Update(self)

		return true
	end
end

local function Disable(self)
	local element = self.CombatFade
	if(element) then
		self:UnregisterEvent('PLAYER_REGEN_ENABLED', Update)
		self:UnregisterEvent('PLAYER_REGEN_DISABLED', Update)
		self:UnregisterEvent('PLAYER_TARGET_CHANGED', Update)
		self:UnregisterEvent('UNIT_TARGET', Update)
	end
end

oUF:AddElement('CombatFade', nil, Enable, Disable)