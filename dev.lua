-- Reloading faster
SLASH_RELOAD1 = "/rl"
SlashCmdList["RELOAD"] = function() 
	ReloadUI() 
end

-- Getting the Framename, the mouse is over
SLASH_FRAMENAME1 = "/frame"
SlashCmdList["FRAMENAME"] = function() 
	print( GetMouseFocus():GetName() )
end

-- Getting the Childframes, the mouse is over
SLASH_CHILDFRAMES1 = "/child"
SlashCmdList["CHILDFRAMES"] = function() 
	for k,v in pairs({GetMouseFocus():GetChildren()}) do
		print(v:GetName(),'-',v:GetObjectType())
	end 
end

-- /gm if we want to open a GM ticket
SLASH_GM1 = "/gm"
SlashCmdList["GM"] = function() 
	ToggleHelpFrame()
	HelpFrame_ShowFrame("GMTalk")
end

-- /uiscale for the optimal scale
SLASH_SCALE1 = "/uiscale"
SlashCmdList["SCALE"] = function() 
	SetCVar("uiScale", 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))
end

----------------------------------

-- Dev "UI" --still experimental
local isDevMode = false
SLASH_DEVUI1 = "/dev"
SlashCmdList["DEVUI"] = function()
	if isDevMode == false then
		GameTooltip:SetScript("OnUpdate", function(self, elpased)
			if self:GetAnchorType() == "ANCHOR_CURSOR" then
				return 
			end
			local x, y = GetCursorPosition()
			local effScale = self:GetEffectiveScale()
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", (x / effScale + 25), (y / effScale + -25))
		end)
		GameTooltip:SetScript("OnShow", function(self)
			self:SetText(GetMouseFocus():GetName())
		end)
		isDevMode = true
		print("DevMode On")
	elseif isDevMode == true then
		GameTooltip:HookScript("OnShow", function(self)
			self:ClearLines()
		end)
	
	--	GameTooltip:HookScript("GameTooltip_SetDefaultAnchor", function(self, parent)
	--		self:SetOwner(parent,"ANCHOR_NONE")
	--		self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -13, 63)
	--	end)
		hooksecurefunc("GameTooltip_SetDefaultAnchor", function(GameTooltip, parent)
			GameTooltip:SetOwner(parent,"ANCHOR_NONE")
			GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -13, 63)
		end)
		GameTooltip:SetScale(1)
		GameTooltip.default = 1
		isDevMode = false
		print("DevMode Off")
	end
end
--print( GetMouseFocus():GetName() )
--end