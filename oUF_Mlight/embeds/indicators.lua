local ADDON_NAME, ns = ...
local cfg = ns.cfg

local x = "M"
local indicatorsize = 6
local symbolsize = 13
local fontsizeEdge = 8

local getTime = function(expirationTime)
    local expire = (expirationTime-GetTime())
    local timeleft = ns.FormatValue(expire)
    if expire > 0.5 then
        return ("|cffffff00"..timeleft.."|r")
    end
end

-- Priest 牧师
-- local pomCount = {1,2,3,4,5}
-- oUF.Tags.Methods['freebgrid:pom'] = function(u) -- 愈合祷言
    -- local name, _,_, c, _,_,_, fromwho = UnitAura(u, GetSpellInfo(41635)) 
    -- if fromwho == "player" then
	-- local pomCount = pomCount[c]
        -- if pomCount > 4 then
            -- return "|cffFFEA00"..pomCount.."|r"
        -- elseif pomCount > 3 then
            -- return "|cffFF9900"..pomCount.."|r"
        -- else
            -- return "|cffFF0000"..pomCount.."|r"
        -- end
	-- end	
-- end
-- oUF.Tags.Events['freebgrid:pom'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:pom'] = function(u) if UnitAura(u, GetSpellInfo(41635)) then return "|cffFFF700"..x.."|r" end end
oUF.Tags.Events['freebgrid:pom'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:rnw'] = function(u) -- 恢复
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = ns.FormatValue(spellTimer)
        if spellTimer > 0 then
            return "|cff80FF00"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:rnw'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:pws'] = function(u)
local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(17))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = ns.FormatValue(spellTimer)
        if spellTimer > 0 then
            return "|cffFFFFFF"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:pws'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:ws'] = function(u) if UnitDebuff(u, GetSpellInfo(6788)) then return "|cffFF9900"..x.."|r" end end -- 虚弱灵魂
oUF.Tags.Events['freebgrid:ws'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:fort'] = function(u) if not (UnitAura(u, GetSpellInfo(21562)) or UnitAura(u, GetSpellInfo(6307)) or UnitAura(u, GetSpellInfo(469))) then return "|cffE0FFFF"..x.."|r" end end -- 韧 小鬼 命令怒吼
oUF.Tags.Events['freebgrid:fort'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:pwb'] = function(u) if UnitAura(u, GetSpellInfo(81782)) then return "|cffEEEE00"..x.."|r" end end -- 真言术：障
oUF.Tags.Events['freebgrid:pwb'] = "UNIT_AURA"

-- Druid
local lbCount = {1,2,3}
oUF.Tags.Methods['freebgrid:lb'] = function(u) -- 生命绽放
    local name, _,_, c,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(33763))
    if(fromwho == "player") then
        local lbCount = lbCount[c]
		local spellTimer = (expirationTime-GetTime())
		local TimeLeft = ns.FormatValue(spellTimer)
        if lbCount > 2 then
            return "|cffA7FD0A"..TimeLeft.."|r"
        elseif lbCount > 1 then
            return "|cffFF9900"..TimeLeft.."|r"
        else
            return "|cffFF0000"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:lb'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:rejuv'] = function(u) -- 回春
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(774))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = ns.FormatValue(spellTimer)
        if spellTimer > 0 then
            return "|cffFF00BB"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:rejuv'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:regrow'] = function(u)
local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(8936))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = ns.FormatValue(spellTimer)
        if spellTimer > 0 then
            return "|cff33FF33"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:regrow'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:wg'] = function(u) if UnitAura(u, GetSpellInfo(48438)) then return "|cffFFFF00"..x.."|r" end end -- 野性成长
oUF.Tags.Events['freebgrid:wg'] = "UNIT_AURA"

oUF.Tags.Methods['mlight:swift'] = function(u) if (UnitAura(u, GetSpellInfo(8936)) or UnitAura(u, GetSpellInfo(774))) then 
	return "|cffA7FD0A"..x.."|r" 
	end 
end 
oUF.Tags.Events['mlight:swift'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:motw'] = function(u) if not (UnitAura(u, GetSpellInfo(1126)) or UnitAura(u, GetSpellInfo(20217)) or UnitAura(u, GetSpellInfo(115921))) then return "|cffBF3EFF"..x.."|r" end end -- 野性印记 或者 王者祝福 或者 帝王传承
oUF.Tags.Events['freebgrid:motw'] = "UNIT_AURA"

-- Warrior 战士
oUF.Tags.Methods['freebgrid:stragi'] = function(u) if not(UnitAura(u, GetSpellInfo(6673)) or UnitAura(u, GetSpellInfo(57330))) then return "|cffFF0000"..x.."|r" end end -- 战斗怒吼 寒冬号角
oUF.Tags.Events['freebgrid:stragi'] = "UNIT_AURA"

-- Shaman 萨满
oUF.Tags.Methods['freebgrid:es'] = function(u) 
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(974)) -- 激流
    if(fromwho == 'player') then return "|cffFF6A00"..x.."|r" end
end
oUF.Tags.Events['freebgrid:es'] = 'UNIT_AURA'

oUF.Tags.Methods['freebgrid:ripTime'] = function(u) --激流
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(61295))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = ns.FormatValue(spellTimer)
        if spellTimer > 0 then
            return "|cff00FFDD"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:ripTime'] = 'UNIT_AURA'

local earthCount = {1,2,3,4,5,6,7,8,9}
oUF.Tags.Methods['freebgrid:earth'] = function(u) -- 大地之盾
	local name, _,_, c, _,_,_, fromwho = UnitAura(u, GetSpellInfo(974)) 
    if fromwho == "player" then
	local earthCount = earthCount[c]
        if earthCount > 6 then
            return "|cffE08A00"..earthCount.."|r"
        elseif earthCount > 3 then
            return "|cffFFFB00"..earthCount.."|r"
        else
            return "|cffFF4800"..earthCount.."|r"
        end
	end	
end
oUF.Tags.Events['freebgrid:earth'] = 'UNIT_AURA'

-- Paladin 骑士

oUF.Tags.Methods['freebgrid:might'] = function(u) if not UnitAura(u, GetSpellInfo(19740)) then return "|cffFFFF00"..x.."|r" end end --力量祝福
oUF.Tags.Events['freebgrid:might'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:beacon'] = function(u) if UnitAura(u, GetSpellInfo(53563)) then return "|cffFFB90F"..x.."|r" end end --道标
oUF.Tags.Events['freebgrid:beacon'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:forbearance'] = function(u) if UnitDebuff(u, GetSpellInfo(25771)) then return "|cffFF9900"..x.."|r" end end
oUF.Tags.Events['freebgrid:forbearance'] = "UNIT_AURA"

-- Warlock 术士
oUF.Tags.Methods['freebgrid:di'] = function(u) -- 黑暗意图
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(109773)) 
    if fromwho == "player" then
        return "|cff6600FF"..x.."|r"
    elseif name then
        return "|cffCC00FF"..x.."|r"
    end
end
oUF.Tags.Events['freebgrid:di'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:ss'] = function(u) -- 灵魂石复活
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(20707))  
    if fromwho == "player" then
        return "|cff6600FFY|r"
    elseif name then
        return "|cffCC00FFY|r"
    end
end
oUF.Tags.Events['freebgrid:ss'] = "UNIT_AURA"

-- Mage 法师
oUF.Tags.Methods['freebgrid:int'] = function(u) if not(UnitAura(u, GetSpellInfo(1459))) then return "|cff00A1DE"..x.."|r" end end
oUF.Tags.Events['freebgrid:int'] = "UNIT_AURA"

-- Monk 武僧
oUF.Tags.Methods['mlight:zs'] = function(u) -- Zen Sphere
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(124081))
        if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = ns.FormatValue(spellTimer)
        if spellTimer > 0 then
            return "|cff00FBFF"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['mlight:zs'] = 'UNIT_AURA'

oUF.Tags.Methods['mlight:sooth'] = function(u) if UnitAura(u, GetSpellInfo(115175)) then return "|cff97FFFF"..x.."|r" end end -- Soothing Mist
oUF.Tags.Events['mlight:sooth'] = "UNIT_AURA"

oUF.Tags.Methods['mlight:remist'] = function(u) -- Renewing Mist
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(115151))
        if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = ns.FormatValue(spellTimer)
        if spellTimer > 0 then
            return "|cff55FF00"..TimeLeft.."|r"
        end
    end
end 
oUF.Tags.Events['mlight:remist'] = 'UNIT_AURA'

classIndicators={
    ["DRUID"] = {
        ["TL"] = "[freebgrid:rejuv]",
        ["TR"] = "[freebgrid:lb]",
        ["BL"] = "[mlight:swift]",
        ["BR"] = "[freebgrid:motw]",
        ["Cen"] = "[freebgrid:regrow]",
    },
    ["PRIEST"] = {
        ["TLS"] = "[freebgrid:pom]",
		["TL"] = "",
		--["TL"] = "[freebgrid:rnw]",
		["TR"] = "[freebgrid:rnw]",
        --["TR"] = "[freebgrid:pom]",
        ["BL"] = "[freebgrid:ws][freebgrid:pwb]",
        ["BR"] = "[freebgrid:fort]",
        ["Cen"] = "[freebgrid:pws]",
    },
    ["PALADIN"] = {
        ["TLS"] = "[freebgrid:forbearance]",
        ["TR"] = "",
        ["BL"] = "[freebgrid:beacon]",
        ["BR"] = "[freebgrid:motw] [freebgrid:might]",
        ["Cen"] = "",
    },
    ["WARLOCK"] = {
        ["TL"] = "[freebgrid:di]",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "[freebgrid:ss]",
        ["Cen"] = "",
    },
    ["WARRIOR"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["DEATHKNIGHT"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["SHAMAN"] = {
        ["TL"] = "[freebgrid:ripTime]",
        ["TR"] = "[freebgrid:earth]",
        ["BL"] = "[freebgrid:es]",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["HUNTER"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["ROGUE"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["MAGE"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "[freebgrid:int]",
        ["Cen"] = "",
    },
	["MONK"] = {
        ["TLS"] = "[mlight:sooth]",
		["TL"] = "",
        ["BR"] = "[freebgrid:motw]",
        ["BL"] = "",
        ["TR"] = "[mlight:remist]",
        ["Cen"] = "[mlight:zs]",
    },
}
local _, class = UnitClass("player")
local symbols = "Interface\\Addons\\oUF_Mlight\\media\\PIZZADUDEBULLETS.ttf"

local update = .25

local Enable = function(self)
    if(self.MlightIndicators) then
        self.AuraStatusBL = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusBL:ClearAllPoints()
        self.AuraStatusBL:SetPoint("BOTTOMLEFT", self.Health, 0, 2)
		self.AuraStatusBL:SetJustifyH("LEFT")
        self.AuraStatusBL:SetFont(symbols, indicatorsize, cfg.fontflag)
        self.AuraStatusBL.frequentUpdates = update
        self:Tag(self.AuraStatusBL, classIndicators[class]["BL"])	

		self.AuraStatusTR = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusTR:ClearAllPoints()
        self.AuraStatusTR:SetPoint("TOPRIGHT", self.Health, 2, -1.5)
		self.AuraStatusTR:SetJustifyH("RIGHT")
        self.AuraStatusTR:SetFont(cfg.font, fontsizeEdge, cfg.fontflag)
        self.AuraStatusTR.frequentUpdates = update
        self:Tag(self.AuraStatusTR, classIndicators[class]["TR"])
		
		self.AuraStatusTL = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusTL:ClearAllPoints()
        self.AuraStatusTL:SetPoint("TOPLEFT", self.Health, 1, -1.5)
		self.AuraStatusTL:SetJustifyH("LEFT")
        self.AuraStatusTL:SetFont(cfg.font, fontsizeEdge, cfg.fontflag)
        self.AuraStatusTL.frequentUpdates = update
        self:Tag(self.AuraStatusTL, classIndicators[class]["TL"])
		
        -- self.AuraStatusTL = self.Health:CreateFontString(nil, "OVERLAY")
        -- self.AuraStatusTL:ClearAllPoints()
        -- self.AuraStatusTL:SetPoint("TOPLEFT", self.Health, 0, 0)
        -- self.AuraStatusTL:SetFont(symbols, indicatorsize, cfg.fontflag)
        -- self.AuraStatusTL.frequentUpdates = update
        -- self:Tag(self.AuraStatusTL, classIndicators[class]["TL"])
		
		self.AuraStatusTLS = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusTLS:ClearAllPoints()
        self.AuraStatusTLS:SetPoint("TOPLEFT", self.Health, 0, 0)
        self.AuraStatusTLS:SetFont(symbols, indicatorsize, cfg.fontflag)
        self.AuraStatusTLS.frequentUpdates = update
        self:Tag(self.AuraStatusTLS, classIndicators[class]["TLS"])
		
        self.AuraStatusBR = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusBR:ClearAllPoints()
        self.AuraStatusBR:SetPoint("BOTTOMRIGHT", self.Health, 2, 2)
        self.AuraStatusBR:SetFont(symbols, indicatorsize, cfg.fontflag)
        self.AuraStatusBR.frequentUpdates = update
        self:Tag(self.AuraStatusBR, classIndicators[class]["BR"])
		
        self.AuraStatusCen = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusCen:SetPoint("TOP", self.Health, 1, -1.5)
        self.AuraStatusCen:SetJustifyH("CENTER")
        self.AuraStatusCen:SetFont(cfg.font, fontsizeEdge, cfg.fontflag)
        self.AuraStatusCen:SetWidth(0)
        self.AuraStatusCen.frequentUpdates = update
        self:Tag(self.AuraStatusCen, classIndicators[class]["Cen"])
    end
end

oUF:AddElement('MlightIndicators', nil, Enable, nil)
