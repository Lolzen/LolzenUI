--// clock // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["clock"] == false then return end

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

		local function TimeFormat(time)
			local t = format("%.1ds",floor(mod(time,60)))
			if (time > 60) then
				time = floor(time / 60)
				t = format("%.1dm ",mod(time,60))..t
				if (time > 60) then
					time = floor(time / 60)
					t = format("%.1dh ",mod(time,24))..t
					if (time > 24) then
						time = floor(time / 24)
						t = format("%dd ",time)..t
					end
				end
			end
			return t
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

		local color = {r = 0.85, g =  0.55, b = 0}

		local clockFrame = CreateFrame("Button", "clock", UIParent)
		--clockFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 10)
		clockFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -5, -7)
		clockFrame:SetHeight(10)
		clockFrame:SetWidth(80)
		clockFrame:SetFrameStrata("HIGH")

		local text = clockFrame:CreateFontString(nil, "ARTWORK")
		text:SetPoint("LEFT", clockFrame)
		text:SetFont("Fonts\\FRIZQT__.TTF", 20, "THINOUTLINE")
		text:SetShadowOffset(1, -1)
		text:SetTextColor(color.r, color.g, color.b)

		local seconds = clockFrame:CreateFontString(nil, "ARTWORK")
		seconds:SetPoint("TOPLEFT", text, "TOPRIGHT", -2, 0)
		seconds:SetFont("Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE")
		seconds:SetShadowOffset(1, -1)
		seconds:SetTextColor(1, 1, 1)

		local lastUpdate = 0
		local updateDelay = 1
		clockFrame:SetScript("OnUpdate", function(self, elapsed)
			lastUpdate = lastUpdate + elapsed
			if (lastUpdate > updateDelay) then
				lastUpdate = 0
				local time, sec = date("%H|c00ffffff\46|r%M|c00ffffff|r"), date("%S")

				text:SetText(time)
				seconds:SetText(sec)
			end
		end)

		clockFrame:SetScript("OnEnter", function()
			GameTooltip:SetOwner(clockFrame, "ANCHOR_TOPLEFT", 2, 5)
			collectgarbage()

			local memory, i, addons, total, entry, total, isLoD, state
			local latencycolor = ColorizeLatency(select(3, GetNetStats()))
			local fpscolor = ColorizeFramerate(GetFramerate())

			GameTooltip:AddLine(date("%A, %d %B, %Y"), 1, 1, 1)
			GameTooltip:AddLine(" ") 
			GameTooltip:AddDoubleLine("Framerate:", format("%.1f fps", GetFramerate()), color.r, color.g, color.b, fpscolor.r, fpscolor.g, fpscolor.b)
			GameTooltip:AddDoubleLine("Latency:", format("%d ms", select(3, GetNetStats())), color.r, color.g, color.b, latencycolor.r, latencycolor.g, latencycolor.b)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("AddOns:", color.r, color.g, color.b)

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
			GameTooltip:AddDoubleLine("Total", Memory(total), color.r, color.g, color.b, cr, cg, cb)
			--GameTooltip:AppendText("")
			GameTooltip:Show()
		end)

		clockFrame:SetScript("OnLeave", function() 
			GameTooltip:Hide() 
		end)

		clockFrame:SetScript("OnClick", function()
			if (not IsAltKeyDown()) then
				UpdateAddOnMemoryUsage()
				local memBefore = gcinfo()
				collectgarbage()
				UpdateAddOnMemoryUsage()
				local memAfter = gcinfo()
				DEFAULT_CHAT_FRAME:AddMessage("Memory cleaned: |cff00FF00"..Memory(memBefore - memAfter))
			end
		end)
	end
end)