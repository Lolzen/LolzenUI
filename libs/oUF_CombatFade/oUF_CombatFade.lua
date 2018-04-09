--[[
# Element: Combat Fader

Changes the opacity of a unit frame based on whether the frame's unit is in combat.

## Widget

CombatFade - A table containing opacity values.

## Notes

Based on oUF Range element.

## Options

.outofcombatAlpha - Opacity when the unit is out of combat. Defaults to 0.3 (number)[0-1].
.incombatAlpha  - Opacity when the unit is in combat. Defaults to 1 (number)[0-1].

## Examples

	-- Register with oUF
    self.CombatFade = {
        incombatAlpha = 1,
        outofcombatAlpha = 0.3,
		elements = {Health, Power},
    }
--]]

local _, ns = ...
local oUF = ns.oUF

local _FRAMES = {}
local onCombatFrame
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
			elements:SetAlpha(element.incombatAlpha)
		else
			elements:SetAlpha(element.outofcombatAlpha)
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

local function Path(self, ...)
	--[[ Override: CombatFade.Override(self, event)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	--]]
	return (self.CombatFade.Override or Update) (self, ...)
end

-- Internal updating method
local timer = 0
local function OnCombatUpdate(_, elapsed)
	timer = timer + elapsed

	if(timer >= .20) then
		for _, object in next, _FRAMES do
			if(object:IsShown()) then
				Path(object, 'OnUpdate')
			end
		end

		timer = 0
	end
end

local function Enable(self)
	local element = self.CombatFade
	if(element) then
		element.__owner = self
		element.incombatAlpha = element.incombatAlpha or 1
		element.outofcombatAlpha = element.outofcombatAlpha or 0.3

		if(not OnCombatFrame) then
			OnCombatFrame = CreateFrame('Frame')
			OnCombatFrame:SetScript('OnUpdate', OnCombatUpdate)
		end

		table.insert(_FRAMES, self)
		OnCombatFrame:Show()

		return true
	end
end

local function Disable(self)
	local element = self.CombatFade
	if(element) then
		for index, frame in next, _FRAMES do
			if(frame == self) then
				table.remove(_FRAMES, index)
				break
			end
		end
		self.elements:SetAlpha(element.incombatAlpha)

		if(#_FRAMES == 0) then
			OnCombatFrame:Hide()
		end
	end
end

oUF:AddElement('CombatFade', nil, Enable, Disable)