--// clock // --

local _, ns = ...
local L = ns.L

ns.RegisterModule("clock", L["desc_clock"], true)

local cfg
local clockFrame, text, seconds
local lastTime, lastSeconds

local function getUSDaySuffix(day)
	if day == 1 or day == 21 or day == 31 then
		return "st"
	elseif day == 2 or day == 22 then
		return "nd"
	elseif day == 3 or day == 23 then
		return "rd"
	end
	return "th"
end

local function getDate()
	local date = C_DateAndTime.GetCurrentCalendarTime()
	local weekday = CALENDAR_WEEKDAY_NAMES[date.weekday]
	local month = CALENDAR_FULLDATE_MONTH_NAMES[date.month]
	if cfg["clock_dateformat"] == "US" then
		return ("%s, %s %d%s %d"):format(weekday, month, date.monthDay, getUSDaySuffix(date.monthDay), date.year)
	end
	return ("%s, %d. %s %d"):format(weekday, date.monthDay, month, date.year)
end

local function updateTime()
	local us = cfg["clock_dateformat"] == "US"
	local time = date(us and "%I|cffffffff.|r%M" or "%H|cffffffff.|r%M")
	if time ~= lastTime then
		lastTime = time
		text:SetText(time)
	end

	local sec
	if cfg["clock_seconds_enabled"] then
		sec = us and date("%S %p") or date("%S")
	else
		sec = us and date("%p") or ""
	end
	if sec ~= lastSeconds then
		lastSeconds = sec
		seconds:SetText(sec)
	end
end

local function applyStyle()
	ns.SetFont(text, cfg["clock_font"], cfg["clock_font_size"], cfg["clock_font_flag"])
	text:SetTextColor(ns.RGB(cfg["clock_color"]))
	ns.SetFont(seconds, cfg["clock_font_seconds"], cfg["clock_seconds_font_size"], cfg["clock_seconds_font_flag"])
	seconds:SetTextColor(ns.RGB(cfg["clock_seconds_color"]))
	lastTime, lastSeconds = nil, nil
	updateTime()
	clockFrame:SetSize(math.max(20, text:GetStringWidth() + seconds:GetStringWidth()), math.max(10, text:GetStringHeight()))
end

--[[ tooltip ]]----------------------------------------------------------------

local function formatMemory(kb)
	if kb > 1000 then
		return ("%.2f mb"):format(kb / 1000)
	end
	return ("%.1f kb"):format(kb)
end

local function gradient(perc)
	-- green -> yellow -> red
	perc = math.max(0, math.min(1, perc))
	if perc < 0.5 then
		return perc * 2, 1, 0
	end
	return 1, (1 - perc) * 2, 0
end

local function latencyColor(ms)
	if ms < 100 then return 0, 1, 0 end
	if ms < 300 then return 1, 1, 0 end
	return 1, 0, 0
end

local function framerateColor(fps)
	if fps < 10 then return 1, 0, 0 end
	if fps < 30 then return 1, 1, 0 end
	return 0, 1, 0
end

-- reused between tooltip updates to avoid creating garbage on every hover
local entries = {}
local function sortByMemory(a, b)
	return a.memory > b.memory
end

local function onEnter(self)
	local r, g, b = ns.RGB(cfg["clock_color"])
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
	GameTooltip:AddLine(getDate(), 1, 1, 1)

	local fps = GetFramerate()
	local latency = select(4, GetNetStats())
	GameTooltip:AddDoubleLine(L["Framerate:"], ("%.1f fps"):format(fps), r, g, b, framerateColor(fps))
	GameTooltip:AddDoubleLine(L["Latency:"], ("%d ms"):format(latency), r, g, b, latencyColor(latency))
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(ADDONS..":", r, g, b)

	UpdateAddOnMemoryUsage()
	local total, count = 0, 0
	for i = 1, C_AddOns.GetNumAddOns() do
		if C_AddOns.IsAddOnLoaded(i) then
			count = count + 1
			local entry = entries[count] or {}
			entries[count] = entry
			entry.name = C_AddOns.GetAddOnInfo(i)
			entry.memory = GetAddOnMemoryUsage(i)
			total = total + entry.memory
		end
	end
	for i = count + 1, #entries do
		entries[i] = nil
	end
	table.sort(entries, sortByMemory)

	local highest = entries[1] and entries[1].memory or 1
	for i = 1, count do
		local entry = entries[i]
		GameTooltip:AddDoubleLine(entry.name, formatMemory(entry.memory), 1, 1, 1, gradient(entry.memory / highest))
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(TOTAL, formatMemory(total), r, g, b, 1, 1, 1)
	GameTooltip:Show()
end

local function onClick()
	UpdateAddOnMemoryUsage()
	local before = collectgarbage("count")
	collectgarbage()
	local after = collectgarbage("count")
	ns.Print(L["Memory cleaned:"].." |cff00ff00"..formatMemory(before - after).."|r")
end

--[[ init ]]-------------------------------------------------------------------

ns.OnInit("clock", function()
	cfg = LolzenUIcfg.clock

	clockFrame = CreateFrame("Button", "LolzenUI_Clock", UIParent)
	clockFrame:SetFrameStrata("HIGH")
	clockFrame:SetScript("OnEnter", onEnter)
	clockFrame:SetScript("OnLeave", GameTooltip_Hide)
	clockFrame:SetScript("OnClick", onClick)

	text = clockFrame:CreateFontString(nil, "ARTWORK")
	text:SetPoint("LEFT", clockFrame)
	text:SetShadowOffset(1, -1)

	seconds = clockFrame:CreateFontString(nil, "ARTWORK")
	seconds:SetPoint("TOPLEFT", text, "TOPRIGHT", -2, 0)
	seconds:SetShadowOffset(1, -1)

	applyStyle()
	C_Timer.NewTicker(1, updateTime)

	local options = ns.Options.New("clock", function() return LolzenUIcfg.clock end, ns.defaults.clock, applyStyle)
	options:Header(L["clock_hours_and_minutes_header"])
	options:FontGroup("clock_font", nil, "clock_font_size", "clock_font_flag")
	options:Color("clock_color", L["color"])
	options:Select("clock_dateformat", L["clock_date"], ns.Options.ListValues({"EU", "US"}))
	options:Header(L["clock_seconds_header"])
	options:Toggle("clock_seconds_enabled", L["clock_seconds_enabled"])
	options:FontGroup("clock_font_seconds", nil, "clock_seconds_font_size", "clock_seconds_font_flag")
	options:Color("clock_seconds_color", L["color"])

	ns.EditMode:AddFrame(clockFrame, {
		name = L["LolzenUI: Clock"],
		pos = {
			db = function() return LolzenUIcfg.clock end,
			point = "clock_anchor1",
			rel = "clock_anchor2",
			x = "clock_posx",
			y = "clock_posy",
		},
		defaults = ns.defaults.clock,
		options = options,
	})
end)
