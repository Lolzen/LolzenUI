--// clock // --

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("clock", L["desc_clock"], true)

local function getUSDayFormat(day)
	local day = tonumber(day)
			if day == 1 then
				return "st"
			elseif day == 2 then
				return "nd"
			elseif day == 3 then
				return "rd"
			else
				return "th"
			end
		end
		
local function getDate()
	local cdate = C_DateAndTime.GetCurrentCalendarTime()
	if LolzenUIcfg.clock["clock_dateformat"] == "US" then
		return CALENDAR_WEEKDAY_NAMES[cdate.weekday]..", "..CALENDAR_FULLDATE_MONTH_NAMES[cdate.month].." "..cdate.monthDay..getUSDayFormat(cdate.monthDay).." "..cdate.year
	else
		return CALENDAR_WEEKDAY_NAMES[cdate.weekday]..", "..cdate.monthDay..". "..CALENDAR_FULLDATE_MONTH_NAMES[cdate.month].." "..cdate.year
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["clock"] == false then return end

		local function Addoncompare(a, b)
			return a.memory > b.memory
		end

		local function Memory(v)
			if (v > 1000) then
				return string.format("%.2f mb", v / 1000)
			else
				return string.format("%.1f kb", v)
			end
		end

		local function ColorGradient(perc, ...)
			if (perc > 1) then
				local r, g, b = select(select('#', ...) - 2, ...)
				return r, g, b
			elseif (perc < 0) then
				local r, g, b = ...
				return r, g, b
			end

			local num = select('#', ...) / 3

			local segment, relperc = math.modf(perc*(num-1))
			local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

			return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
		end

		local function ColorizeLatency(v)
			if (v < 100) then
				return {r = 0, g = 1, b = 0}
			elseif (v < 300) then
				return {r = 1, g = 1, b = 0}
			else
				return {r = 1, g = 0, b = 0}
			end
		end

		local function ColorizeFramerate(v)
			if (v < 10) then
				return {r = 1, g = 0, b = 0}
			elseif (v < 30) then
				return {r = 1, g = 1, b = 0}
			else
				return {r = 0, g = 1, b = 0}
			end
		end

		local clockFrame = CreateFrame("Button", "clock", UIParent)
		clockFrame:SetPoint(LolzenUIcfg.clock["clock_anchor1"], UIParent, LolzenUIcfg.clock["clock_anchor2"], LolzenUIcfg.clock["clock_posx"], LolzenUIcfg.clock["clock_posy"])
		clockFrame:SetHeight(10)
		clockFrame:SetWidth(80)
		clockFrame:SetFrameStrata("HIGH")

		local text = clockFrame:CreateFontString(nil, "ARTWORK")
		text:SetPoint("LEFT", clockFrame)
		text:SetFont(LSM:Fetch("font", LolzenUIcfg.clock["clock_font"]), LolzenUIcfg.clock["clock_font_size"], LolzenUIcfg.clock["clock_font_flag"])
		text:SetShadowOffset(1, -1)
		text:SetTextColor(unpack(LolzenUIcfg.clock["clock_color"]))

		local seconds = clockFrame:CreateFontString(nil, "ARTWORK")
		seconds:SetPoint("TOPLEFT", text, "TOPRIGHT", -2, 0)
		seconds:SetFont(LSM:Fetch("font", LolzenUIcfg.clock["clock_font_seconds"]), LolzenUIcfg.clock["clock_seconds_font_size"], LolzenUIcfg.clock["clock_seconds_font_flag"])
		seconds:SetShadowOffset(1, -1)
		seconds:SetTextColor(unpack(LolzenUIcfg.clock["clock_seconds_color"]))

		local timer = clockFrame:CreateAnimationGroup()

		local timerAnim = timer:CreateAnimation()
		timerAnim:SetDuration(1)

		timer:SetScript("OnFinished", function(self, requested)
			text:SetText(date("%H|c00ffffff\46|r%M|c00ffffff|r"))
			if LolzenUIcfg.clock["clock_seconds_enabled"] == true then
				seconds:SetText(date("%S"))
			end

			self:Play()
		end)
		timer:Play()

		clockFrame:SetScript("OnEnter", function()
			GameTooltip:SetOwner(clockFrame, "ANCHOR_TOPLEFT", 2, 5)
			collectgarbage()

			local memory, i, addons, total, entry, total, isLoD, state
			local latencycolor = ColorizeLatency(select(3, GetNetStats()))
			local fpscolor = ColorizeFramerate(GetFramerate())

			GameTooltip:AddLine(getDate(), 1, 1, 1)
			GameTooltip:AddDoubleLine("Framerate:", format("%.1f fps", GetFramerate()), LolzenUIcfg.clock["clock_color"].r, LolzenUIcfg.clock["clock_color"].g, LolzenUIcfg.clock["clock_color"].b, fpscolor.r, fpscolor.g, fpscolor.b)
			GameTooltip:AddDoubleLine("Latency:", format("%d ms", select(3, GetNetStats())), LolzenUIcfg.clock["clock_color"].r, LolzenUIcfg.clock["clock_color"].g, LolzenUIcfg.clock["clock_color"].b, latencycolor.r, latencycolor.g, latencycolor.b)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("AddOns:", unpack(LolzenUIcfg.clock["clock_color"]))

			addons = {}
			total = 0
			UpdateAddOnMemoryUsage()
			for i = 1, GetNumAddOns(), 1 do
				if GetAddOnMemoryUsage(i) == 0 then
					isLoD = IsAddOnLoadOnDemand(i)
					memory = GetAddOnMemoryUsage(i)
					if isLoD then
						state = "LoD"
					else
						state = "Disabled"
					end
				else
					state = "Enabled"
				end
				memory = GetAddOnMemoryUsage(i)
					entry = {
						name = GetAddOnInfo(i),
						memory = memory,
						state = state,
					}
					table.insert(addons, entry)
					total = total + memory
			end

			table.sort(addons, Addoncompare)

			for _, entry in pairs(addons) do
				local gradientr, gradientg, gradientb = ColorGradient((entry.memory*10 / total), 0, 1, 0, 1, 1, 0, 1, 0, 0)
				if entry.memory > 0 then
					GameTooltip:AddDoubleLine(entry.name, Memory(entry.memory), 1, 1, 1, gradientr, gradientg, gradientb)
				else
					GameTooltip:AddDoubleLine(entry.name, entry.state, 0.55, 0.55, 0.55, 1, 1, 1, 1)
				end
			end  
			local cr, cg, cb = ColorGradient((entry.memory / 800), 0, 1, 0, 1, 1, 0, 1, 0, 0) 
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine("Total", Memory(total), LolzenUIcfg.clock["clock_color"].r, LolzenUIcfg.clock["clock_color"].g, LolzenUIcfg.clock["clock_color"].b, cr, cg, cb)
			GameTooltip:Show()
		end)

		clockFrame:SetScript("OnLeave", function() 
			GameTooltip:Hide() 
		end)

		clockFrame:SetScript("OnClick", function()
			UpdateAddOnMemoryUsage()
			local memBefore = gcinfo()
			collectgarbage()
			UpdateAddOnMemoryUsage()
			local memAfter = gcinfo()
			DEFAULT_CHAT_FRAME:AddMessage("Memory cleaned: |cff00FF00"..Memory(memBefore - memAfter))
		end)
	end
end)