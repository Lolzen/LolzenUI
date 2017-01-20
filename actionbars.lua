--A few locals for minimal customation
local size = 26
local spacing = 6

local invisible = CreateFrame("Frame", nil)
invisible:RegisterEvent("PLAYER_ENTERING_WORLD")
invisible:EnableMouse(false)
invisible:Hide()

--###Cleaning up###--
local BlizzArt = {
	MainMenuBarTexture0, MainMenuBarTexture1,
	MainMenuBarTexture2,MainMenuBarTexture3,
	MainMenuBarLeftEndCap, MainMenuBarRightEndCap,
	MainMenuBarPageNumber, ActionBarUpButton, ActionBarDownButton,
	CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot,
	MainMenuBarBackpackButton,
	StanceBarFrame,
	ReputationWatchBar, MainMenuExpBar, ArtifactWatchBar, HonorWatchBar,
}

for _, frame in pairs(BlizzArt) do
	frame:SetParent(invisible)
end

-- Make the MainMenuBar clickthrough, so it doesn't interfere with other frames placed on the bottom
MainMenuBar:EnableMouse(false)

for _, frame in pairs(BlizzArt) do
	frame:SetParent(invisible)
end

local MicroButtons = {
	CharacterMicroButton, SpellbookMicroButton, TalentMicroButton, 
	AchievementMicroButton, QuestLogMicroButton, GuildMicroButton, 
	PVPMicroButton, LFDMicroButton, CompanionsMicroButton,
	EJMicroButton, HelpMicroButton, MainMenuMicroButton,
	CollectionsMicroButton, StoreMicroButton,
}

--fix a blizz bug; thx tuller
if not _G['AchievementMicroButton_Update'] then
	_G['AchievementMicroButton_Update'] = function() end
end

function invisible.PLAYER_ENTERING_WORLD()
	for _, frame in pairs(MicroButtons) do
		frame:SetParent(invisible)
		frame:Hide()
	end
end

invisible:SetScript("OnEvent", function(self, event, ...)  
	if(self[event]) then
		self[event](self, event, ...)
	else
		print("LolzenUI - actionbars debug: "..event)
	end 
end)

--###Forming Blizz' bars###--
--Set our bars in place
local holder = CreateFrame("Frame", "MainMenuBarHolderFrame", UIParent, "SecureHandlerStateTemplate")
holder:SetSize(size*12+spacing*11, size)
holder:SetPoint("BOTTOM", UIParent, 0, 22)
holder:RegisterEvent("PLAYER_LOGIN")
holder:RegisterEvent("PLAYER_ENTERING_WORLD")

ActionButton1:ClearAllPoints()
ActionButton1:SetPoint("BOTTOMLEFT", holder, 0, 0)

MultiBarBottomLeftButton1:ClearAllPoints()
MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", 0, 5)

MultiBarBottomRightButton1:ClearAllPoints()  
MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton1, "TOPLEFT", 0, 6)

MultiBarLeftButton1:ClearAllPoints()
MultiBarLeftButton1:SetPoint("TOPLEFT", MultiBarRightButton1, "TOPLEFT", -33, 0)

MultiBarRightButton1:ClearAllPoints()
MultiBarRightButton1:SetPoint("RIGHT", UIParent, "RIGHT", -2, 150)

PetActionButton1:ClearAllPoints()
PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 25, 35)
PetActionBarFrame:SetFrameStrata('HIGH')

PossessButton1:ClearAllPoints()
PossessButton1:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 25, 30)

--Setting size
for i = 1, NUM_ACTIONBAR_BUTTONS do
	local ab = _G["ActionButton"..i]
	local mbbl = _G["MultiBarBottomLeftButton"..i]
	local mbbr = _G["MultiBarBottomRightButton"..i]
	local mbl = _G["MultiBarLeftButton"..i]
	local mbr = _G["MultiBarRightButton"..i]
	local pab = _G["PetActionButton"..i]
	local mcab = _G["MultiCastActionButton"..i]
	local pb = _G["PossessButton"..i]
	
	ab:SetSize(size, size)
	
	mbbl:SetSize(size, size)
	
	mbbr:SetSize(size, size)
	
	mbl:SetSize(size, size)
	
	mbr:SetSize(size, size)
	
	if pab then
		pab:SetSize(size, size)
	end
	
	if pb then
		pb:SetSize(size, size)
	end
end

--###Altering Appearance###--
local function applyTheme(self)
	local name = self:GetName()

	_G[name.."Icon"]:SetTexCoord(.08, .92, .08, .92)
	_G[name.."Icon"]:SetPoint("TOPLEFT", _G[name], "TOPLEFT", 2, -2)
	_G[name.."Icon"]:SetPoint("BOTTOMRIGHT", _G[name], "BOTTOMRIGHT", -2, 2)
	
	_G[name.."Flash"]:SetTexture("Interface\\AddOns\\LolzenUI\\media\\flash")
	_G[name]:SetNormalTexture("Interface\\AddOns\\LolzenUI\\media\\gloss")
	_G[name]:SetCheckedTexture("Interface\\AddOns\\LolzenUI\\media\\checked")
	_G[name]:SetHighlightTexture("Interface\\AddOns\\LolzenUI\\media\\hover")
	_G[name]:SetPushedTexture("Interface\\AddOns\\LolzenUI\\media\\pushed")
	
	if _G[name.."Border"] then
		_G[name.."Border"]:SetTexture(nil)
	end
	
	if _G[name.."Cooldown"] then
		_G[name.."Cooldown"]:SetPoint("TOPLEFT", _G[name], "TOPLEFT", 2, -2)
		_G[name.."Cooldown"]:SetPoint("BOTTOMRIGHT", _G[name], "BOTTOMRIGHT", -2, 2)
	end
	
	if _G[name.."HotKey"] then
		_G[name.."HotKey"]:Hide()
	end
		
	if _G[name.."Name"] then
		_G[name.."Name"]:Hide()
	end
		
	if _G[name.."FloatingBG"] then
		_G[name.."FloatingBG"]:Hide()
	end
	
	if _G[name.."NormalTexture"] then
		_G[name.."NormalTexture"]:SetAllPoints(_G[name])
		return
	end
end

local function applyPetBarTheme(self, i)
	local button = self..i

	_G[button.."Icon"]:SetTexCoord(.08, .92, .08, .92)
	_G[button.."Icon"]:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
	_G[button.."Icon"]:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)

    _G[button.."Flash"]:SetTexture("Interface\\AddOns\\LolzenUI\\media\\flash")
    _G[button]:SetNormalTexture("Interface\\AddOns\\LolzenUI\\media\\gloss")
	_G[button]:SetCheckedTexture("Interface\\AddOns\\LolzenUI\\media\\checked")
	_G[button]:SetHighlightTexture("Interface\\AddOns\\LolzenUI\\media\\hover")
	_G[button]:SetPushedTexture("Interface\\AddOns\\LolzenUI\\media\\pushed")
	
	_G[button.."Cooldown"]:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
	_G[button.."Cooldown"]:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	
	_G[button.."NormalTexture2"]:SetVertexColor(0, 0, 0)
	_G[button.."NormalTexture2"]:SetPoint("TOPLEFT", button, "TOPLEFT", -0, 0)
	_G[button.."NormalTexture2"]:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, -0)
	
	--Autocast stuff on petbar
	if _G[button.."Shine"] then
		_G[button.."Shine"]:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
		_G[button.."Shine"]:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	end
	
	if _G[button.."AutoCastable"] then
		_G[button.."AutoCastable"]:SetPoint("TOPLEFT", button, "TOPLEFT", -12, 12)
		_G[button.."AutoCastable"]:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 12, -12)
	end
end

local function applyThemeToPetBar()
	for i = 1, NUM_PET_ACTION_SLOTS do
		applyPetBarTheme("PetActionButton", i)
	end
end

hooksecurefunc("ActionButton_Update", applyTheme)
hooksecurefunc("PetActionBar_Update", applyThemeToPetBar)