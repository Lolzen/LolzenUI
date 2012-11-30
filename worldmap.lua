UIPanelWindows["WorldFrame"] = {area = "center", pushable = 9}
	hooksecurefunc(WorldFrame, "Show", function(self)
	self:SetScale(0.75)
end)
