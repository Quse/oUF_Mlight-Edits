local ADDON_NAME, ns = ...
local cfg = ns.cfg

if not cfg.enableraid then return end

local texture = cfg.texture
local font, fontflag = cfg.font, cfg.fontflag
local fontsize = cfg.raidfontsize
local symbols = "Interface\\Addons\\oUF_Mlight\\media\\PIZZADUDEBULLETS.ttf"
local myclass = select(2, UnitClass("player"))

local createFont = ns.createFont
local createBackdrop = ns.createBackdrop
local Updatehealthbar = ns.Updatehealthbar
local OnMouseOver = ns.OnMouseOver
--=============================================--
--[[               Some update               ]]--
--=============================================--
local pxbackdrop = {edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 1}

local function Createpxborder(self, lvl)
	local pxbd = CreateFrame("Frame", nil, self)
	pxbd:SetPoint("TOPLEFT", self, "TOPLEFT", -0.5, 0)
	pxbd:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0.5, 0)
	pxbd:SetBackdrop(pxbackdrop)
	pxbd:SetFrameLevel(lvl)
	pxbd:Hide()
	return pxbd
end

local function ChangedTarget(self, event, unit)
	if UnitIsUnit('target', self.unit) then
		self.targetborder:Show()
	else
		self.targetborder:Hide()
	end
end

local function UpdateThreat(self, event, unit)	
	if (self.unit ~= unit) then return end
	
	unit = unit or self.unit
	local threat = UnitThreatSituation(unit)
	
	if threat and threat > 1 then
		local r, g, b = GetThreatStatusColor(threat)
		self.threatborder:SetBackdropBorderColor(r, g, b)
		self.threatborder:Show()
	else
		self.threatborder:Hide()
	end
end

local function healpreditionbar(self, color)
	local hpb = CreateFrame('StatusBar', nil, self.Health)
	hpb:SetStatusBarTexture(texture)
	hpb:SetStatusBarColor(unpack(color))
	hpb:SetPoint('TOP')
	hpb:SetPoint('BOTTOM')
	if cfg.classcolormode then
		hpb:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
	else
		hpb:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'LEFT')
	end
	hpb:SetWidth(200)
	return hpb
end

local function CreateHealPredition(self)
	local myBar = healpreditionbar(self, cfg.myhealpredictioncolor)
	local otherBar = healpreditionbar(self, cfg.otherhealpredictioncolor)
	self.HealPrediction = {
		myBar = myBar,
		otherBar = otherBar,
	}
end

local function CreateGCDframe(self)
    local Gcd = CreateFrame("StatusBar", nil, self)
    Gcd:SetAllPoints(self)
    Gcd:SetStatusBarTexture(texture)
    Gcd:SetStatusBarColor(.4, .7, .4, .6)
    Gcd:SetFrameLevel(5)
    self.GCD = Gcd
end
--=============================================--
--[[              Raid Frames                ]]--
--=============================================--
local func = function(self, unit)

	OnMouseOver(self)
    self:RegisterForClicks"AnyUp"
	self.mouseovers = {}
	
	-- shadow border for health bar --
    self.backdrop = createBackdrop(self, self, 0, 3)  -- this also use for dispel border

	-- target border --
	self.targetborder = Createpxborder(self, 7)
	self.targetborder:SetBackdropBorderColor(1, 1, .3, 0)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', ChangedTarget)
	self:RegisterEvent('GROUP_ROSTER_UPDATE', ChangedTarget)
	
	-- threat border --
	self.threatborder = Createpxborder(self, 6)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UpdateThreat)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
	
    local hp = CreateFrame("StatusBar", nil, self)
    hp:SetAllPoints(self)
	hp:SetStatusBarTexture(texture)
    hp.frequentUpdates = true
    hp.Smooth = true
	
	if not cfg.classcolormode then
		hp:SetReverseFill(true)
	end
	
	-- backdrop grey gradient --
	hp.bg = hp:CreateTexture(nil, "BACKGROUND")
	hp.bg:SetAllPoints()
	hp.bg:SetTexture(cfg.texture)
	if cfg.classcolormode then
		hp.bg:SetGradientAlpha("VERTICAL", .1, .1, .1, 1, .1, .1, .1, 1)
	else
		hp.bg:SetVertexColor(0,0,0,.2)
	end
	
    self.Health = hp
	self.Health.PostUpdate = Updatehealthbar
	
	-- gcd frane --
	if cfg.showgcd then
		CreateGCDframe(self)
	end
	
	-- heal prediction --
	if cfg.healprediction then
		CreateHealPredition(self)
	end
	
	local Leader = hp:CreateFontString(nil, "OVERLAY")
	Leader:SetPoint("BOTTOMLEFT", hp, 1, -1)
	Leader:SetFont(font, fontsize, fontflag)
	Leader:SetText("|cff777777-|r")
	self.Leader = Leader

	local lfd = createFont(hp, "OVERLAY", font, fontsize, fontflag, 1, 1, 1)
	lfd:SetPoint("BOTTOM", hp, 1, 0)
	self:Tag(lfd, '[Mlight:LFD]')
	
	local raidname = createFont(hp, "OVERLAY", font, fontsize, fontflag, 1, 1, 1)
	raidname:SetPoint("CENTER", hp, "CENTER", 1, 1)
	if not cfg.classcolormode then
		self:Tag(raidname, '[Mlight:color][Mlight:shortname]')
	else
		self:Tag(raidname, '[Mlight:shortname]')
	end
	
    local ricon = hp:CreateTexture(nil, "OVERLAY")
	ricon:SetSize(10 ,10)
    ricon:SetPoint("BOTTOM", hp, "TOP", 0 , -5)
    self.RaidIcon = ricon
	
	local status = createFont(hp, "OVERLAY", font, fontsize, fontflag, 1, 1, 1)
    status:SetPoint("TOP", 1, -1)
	self:Tag(status, '[Mlight:DDG]')
	
	local resurrecticon = hp:CreateTexture(nil, "OVERLAY")
    resurrecticon:SetSize(16, 16)
    resurrecticon:SetPoint"CENTER"
    self.ResurrectIcon = resurrecticon
	
	-- Raid debuff
    local auras = CreateFrame("Frame", nil, self)
    auras:SetSize(18, 18)
    auras:SetPoint("CENTER", hp, "CENTER", 0, 0)
	auras.tfontsize = 8
	auras.cfontsize = 8
	self.MlightAuras = auras
	
	-- Tankbuff
    -- local tankbuff = CreateFrame("Frame", nil, self)
    -- tankbuff:SetSize(14, 14)
    -- tankbuff:SetPoint("RIGHT", hp, "RIGHT", -1, 0)
	-- tankbuff.tfontsize = 8
	-- tankbuff.cfontsize = 8
	-- self.MlightTankbuff = tankbuff
	
	-- Indicators
	self.MlightIndicators = true
	
	-- Range
    local range = {
        insideAlpha = 1,
        outsideAlpha = 0.5,
    }
	
	if cfg.showarrow then
		self.freebRange = range
	else
		self.Range = range
	end
end

local dfunc = function(self, unit)

	OnMouseOver(self)
    self:RegisterForClicks"AnyUp"
	self.mouseovers = {}
	
	-- shadow border for health bar --
    self.backdrop = createBackdrop(self, self, 0, 3)  -- this also use for dispel border

    local hp = CreateFrame("StatusBar", nil, self)
    hp:SetAllPoints(self)
	hp:SetStatusBarTexture(texture)
    hp.frequentUpdates = true
    hp.Smooth = true
	
	if not cfg.classcolormode then
		hp:SetReverseFill(true)
	end
	
	-- backdrop grey gradient --
	hp.bg = hp:CreateTexture(nil, "BACKGROUND")
	hp.bg:SetAllPoints()
	hp.bg:SetTexture(cfg.texture)
	if cfg.classcolormode then
		hp.bg:SetGradientAlpha("VERTICAL", .1, .1, .1, 1, .1, .1, .1, 1)
	else
		hp.bg:SetVertexColor(0,0,0,.2)
	end
	
    self.Health = hp
	self.Health.PostUpdate = Updatehealthbar
	
	local Leader = hp:CreateFontString(nil, "OVERLAY")
	Leader:SetPoint("BOTTOMLEFT", hp, 1, -2)
	Leader:SetFont(font, fontsize, fontflag)
	Leader:SetText("|cff777777-|r")
	self.Leader = Leader
	
	local lfd = createFont(hp, "OVERLAY", font, fontsize, fontflag, 1, 1, 1)
	lfd:SetPoint("BOTTOM", hp, 0, -2)
	self:Tag(lfd, '[Mlight:LFD]')
		
	local raidname = createFont(hp, "OVERLAY", font, fontsize, fontflag, 1, 1, 1)
	raidname:SetPoint("BOTTOMLEFT", hp, "BOTTOMRIGHT", 5, 2)
	if not cfg.classcolormode then
		self:Tag(raidname, '[Mlight:color][Mlight:shortname2]')
	else
		self:Tag(raidname, '[Mlight:shortname2]')
	end
	
    local ricon = hp:CreateTexture(nil, "OVERLAY")
	ricon:SetSize(10 ,10)
    ricon:SetPoint("BOTTOM", hp, "TOP", 0 , -5)
    self.RaidIcon = ricon
	
	local status = createFont(hp, "OVERLAY", font, fontsize, fontflag, 1, 1, 1)
    status:SetPoint("CENTER")
	self:Tag(status, '[Mlight:DDG]')
	
	-- Raid debuff
    -- local auras = CreateFrame("Frame", nil, self)
    -- auras:SetSize(10, 10)
    -- auras:SetPoint("LEFT", hp, "LEFT", 2, 0)
	-- auras.tfontsize = 1
	-- auras.cfontsize = 1
	-- self.MlightAuras = auras
	
	-- Range
    local range = {
        insideAlpha = 1,
        outsideAlpha = 0.5,
    }
	
	if cfg.showarrow then
		self.freebRange = range
	else
		self.Range = range
	end
end

oUF:RegisterStyle("Mlight_Healerraid", func)
oUF:RegisterStyle("Mlight_DPSraid", dfunc)

local healerraid
local dpsraid

local function Spawnhealraid()
	oUF:SetActiveStyle"Mlight_Healerraid"
	healerraid = oUF:SpawnHeader('HealerRaid_Mlight', nil, 'raid,party,solo',
		'oUF-initialConfigFunction', ([[
		self:SetWidth(%d)
		self:SetHeight(%d)
		self:SetScale(%d)
		]]):format(cfg.healerraidwidth, cfg.healerraidheight, 1),
		'showPlayer', true,
		'showSolo', cfg.showsolo,
		'showParty', true,
		'showRaid', true,
		'xoffset', 5,
		'yOffset', -5,
		'point', cfg.anchor,
		'groupFilter', '1,2,3,4,5,6,7,8',
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', 5,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', cfg.partyanchor
	)
	healerraid:SetPoint(unpack(cfg.healerraidposition))
end

local function Spawndpsraid()
	oUF:SetActiveStyle"Mlight_DPSraid"
	dpsraid = oUF:SpawnHeader('DpsRaid_Mlight', nil, 'raid,party,solo',
		'oUF-initialConfigFunction', ([[
		self:SetWidth(%d)
		self:SetHeight(%d)
		self:SetScale(%d)
		]]):format(cfg.dpsraidwidth, cfg.dpsraidheight, 1),
		'showPlayer', true,
		'showSolo', cfg.showsolo,
		'showParty', true,
		'showRaid', true,
		'yOffset', -5,
		'groupFilter', '1,2,3,4,5,6,7,8',
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'unitsPerColumn', 25
	)
	dpsraid:SetPoint(unpack(cfg.dpsraidposition))
end

local function CheckRole()
	local role
	local tree = GetSpecialization()
	if ((myclass == "MONK" and tree == 2) or (myclass == "PRIEST" and (tree == 1 or tree ==2)) or (myclass == "PALADIN" and tree == 1)) or (myclass == "DRUID" and tree == 4) or (myclass == "SHAMAN" and tree == 3) then
		role = "Healer"
	end
	return role
end

local function hiderf(f)
	if cfg.showsolo and f:GetAttribute("showSolo") then f:SetAttribute("showSolo", false) end
	if f:GetAttribute("showParty") then f:SetAttribute("showParty", false) end
	if f:GetAttribute("showRaid") then f:SetAttribute("showRaid", false) end
end

local function showrf(f)
	if cfg.showsolo and not f:GetAttribute("showSolo") then f:SetAttribute("showSolo", true) end
	if not f:GetAttribute("showParty") then f:SetAttribute("showParty", true) end
	if not f:GetAttribute("showRaid") then f:SetAttribute("showRaid", true) end
end

function togglerf()
	local Role = CheckRole()
	if Role then
		hiderf(dpsraid)
		showrf(healerraid)
	else
		hiderf(healerraid)
		showrf(dpsraid)
	end
end

local EventFrame = CreateFrame("Frame")

EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
--EventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

EventFrame:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

function EventFrame:ADDON_LOADED(arg1)
	if arg1 ~= "oUF_Mlight" then return end
	Spawnhealraid()
	Spawndpsraid()
end

function EventFrame:PLAYER_TALENT_UPDATE()
	togglerf()
end

function EventFrame:PLAYER_ENTERING_WORLD()
	CompactRaidFrameManager:Hide()
	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameContainer:Hide()
	CompactRaidFrameContainer:UnregisterAllEvents()
	CompactRaidFrameManager.Show = CompactRaidFrameManager.Hide
	CompactRaidFrameContainer.Show = CompactRaidFrameContainer.Hide

	EventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

local function SlashCmd(cmd)
    if (cmd:match"healer") then
		hiderf(dpsraid)
		showrf(healerraid)
    elseif (cmd:match"dps") then
		hiderf(healerraid)
		showrf(dpsraid)
    else
      print("|c0000FF00oUF_Mlight command list:|r")
      print("|c0000FF00\/rf healer")
      print("|c0000FF00\/rf dps")
    end
end

SlashCmdList["MlightRaid"] = SlashCmd;
SLASH_MlightRaid1 = "/rf"