local ADDON_NAME, ns = ...
local cfg = ns.cfg

local glowBorder = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
    insets = {left = 1, right = 1, top = 1, bottom = 1}
}

local GetTime = GetTime
local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60

local FormatTime = function(s)
    if s >= day then
        return format("%dd", floor(s/day + 0.5))
    elseif s >= hour then
        return format("%dh", floor(s/hour + 0.5))
    elseif s >= minute then
        return format("%dm", floor(s/minute + 0.5))
    end

    return format("%d", fmod(s, minute))
end

local CreateAuraIcon = function(auras)
    local button = CreateFrame("Button", nil, auras)
    button:EnableMouse(false)
    button:SetAllPoints(auras)

    local icon = button:CreateTexture(nil, "OVERLAY")
    icon:SetAllPoints(button)
    icon:SetTexCoord(.07, .93, .07, .93)

    local font = cfg.font
    local count = button:CreateFontString(nil, "OVERLAY")
    count:SetFont(cfg.font, cfg.fontsize, cfg.fontflag)
    count:SetPoint("TOPRIGHT")

    local border = CreateFrame("Frame", nil, button)
    border:SetPoint("TOPLEFT", button, "TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
    border:SetFrameLevel(4)
    border:SetBackdrop(glowBorder)
    border:SetBackdropColor(0,0,0,1)
    border:SetBackdropBorderColor(0,0,0,1)
    button.border = border

    local remaining = button:CreateFontString(nil, "OVERLAY")
    remaining:SetPoint("CENTER", 1,0) 
    remaining:SetFont(cfg.font, cfg.fontsize, cfg.fontflag)
    remaining:SetTextColor(1, 1, 0)
    button.remaining = remaining

    button.parent = auras
    button.icon = icon
    button.count = count
    button.cd = cd
    button:Hide()

    return button
end

local CustomFilter = function(icons, ...)
    local _, icon, name, _, _, _, dtype, _, _, caster, spellID = ...

    icon.priority = 0

	if ns.auras.buffs[spellID] then
        icon.priority = ns.auras.buffs[spellID]
        icon.buff = true
        return true
    elseif ns.auras.buffs[name] then
        icon.priority = ns.auras.buffs[name]
        icon.buff = true
        return true
    end
end

local AuraTimer = function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed

    if self.elapsed < .2 then return end
    self.elapsed = 0

    local timeLeft = self.expires - GetTime()
    if timeLeft <= 0 then
        self.remaining:SetText(nil)
    else
        self.remaining:SetText(FormatTime(timeLeft))
    end
end

local buffcolor = { r = 0, g = 0, b = 0 }
local updateDebuff = function(icon, texture, count, dtype, duration, expires, buff)
    local color = buffcolor

    icon.border:SetBackdropBorderColor(color.r, color.g, color.b)

    icon.icon:SetTexture(texture)
    icon.count:SetText((count > 1 and count))

    icon.expires = expires
    icon.duration = duration

    icon:SetScript("OnUpdate", AuraTimer)
end

local Update = function(self, event, unit)
    if(self.unit ~= unit) then
	return end

    local cur
    local hide = true
    local auras = self.MlightTankbuff
    local icon = auras.button

    local index = 1
    while true do
        local name, rank, texture, count, dtype, duration, expires, caster, _, _, spellID = UnitBuff(unit, index)
        if not name then break end
        
        local show = CustomFilter(auras, unit, icon, name, rank, texture, count, dtype, duration, expires, caster, spellID)

        if(show) and icon.buff then
			--print(name)
            if not cur then
                cur = icon.priority
                updateDebuff(icon, texture, count, dtype, duration, expires, true)
            else
                if icon.priority > cur then
                    updateDebuff(icon, texture, count, dtype, duration, expires, true)
                end
            end

            icon:Show()
            hide = false
        end

        index = index + 1
    end

    if hide then
        icon:Hide()
    end
end

local Enable = function(self)
    local auras = self.MlightTankbuff

    if(auras) then
        auras.button = CreateAuraIcon(auras)
        self:RegisterEvent("UNIT_AURA", Update)
        return true
    end
end

local Disable = function(self)
    local auras = self.MlightTankbuff

    if(auras) then
        self:UnregisterEvent("UNIT_AURA", Update)
    end
end

oUF:AddElement('MlightTankbuff', Update, Enable, Disable)