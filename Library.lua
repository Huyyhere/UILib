local MeyyHub = {}
MeyyHub.Version = "1.0.0"

local TweenService = game:GetService("TweenService")
local UserInput    = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local Players      = game:GetService("Players")
local CoreGui      = game:GetService("CoreGui")
local HttpService  = game:GetService("HttpService")
local LocalPlayer  = Players.LocalPlayer

local isfolder   = isfolder   or function() return false end
local makefolder = makefolder or function() end
local writefile  = writefile  or function() end
local readfile   = readfile   or function() return "{}" end
local isfile     = isfile     or function() return false end

MeyyHub.Flags     = {}
MeyyHub.IsLoading = false
MeyyHub._conns    = {}
MeyyHub._gui      = nil
MeyyHub._window   = nil

local _reg = {
    strokes  = {},
    accents  = {},
    bgs      = {},
    switches = {},
    dividers = {},
    texts    = {},
    scrolls  = {},
    fills    = {},
}

local Themes = {
    Dark = {
        Window    = Color3.fromRGB(16, 16, 20),
        Topbar    = Color3.fromRGB(20, 20, 26),
        Sidebar   = Color3.fromRGB(12, 12, 16),
        Content   = Color3.fromRGB(18, 18, 24),
        Card      = Color3.fromRGB(24, 24, 32),
        CardHover = Color3.fromRGB(30, 30, 40),
        Input     = Color3.fromRGB(11, 11, 15),
        Stroke    = Color3.fromRGB(38, 38, 50),
        StrokeAlt = Color3.fromRGB(54, 54, 70),
        Divider   = Color3.fromRGB(28, 28, 38),
        Accent    = Color3.fromRGB(99, 116, 255),
        AccentDim = Color3.fromRGB(60, 74, 190),
        TextPri   = Color3.fromRGB(228, 228, 238),
        TextSec   = Color3.fromRGB(118, 118, 146),
        TextDim   = Color3.fromRGB(68, 68, 88),
        Toggle    = Color3.fromRGB(76, 190, 92),
        ToggleOff = Color3.fromRGB(42, 44, 56),
        Danger    = Color3.fromRGB(214, 52, 52),
        Success   = Color3.fromRGB(52, 192, 88),
        Warning   = Color3.fromRGB(214, 152, 36),
        Scrollbar = Color3.fromRGB(48, 48, 64),
        Shadow    = Color3.fromRGB(0, 0, 0),
        Tag       = Color3.fromRGB(30, 30, 40),
    },
    Moonlight = {
        Window    = Color3.fromRGB(8, 9, 20),
        Topbar    = Color3.fromRGB(10, 11, 24),
        Sidebar   = Color3.fromRGB(6, 7, 16),
        Content   = Color3.fromRGB(10, 11, 24),
        Card      = Color3.fromRGB(15, 17, 36),
        CardHover = Color3.fromRGB(20, 23, 46),
        Input     = Color3.fromRGB(6, 7, 18),
        Stroke    = Color3.fromRGB(34, 40, 78),
        StrokeAlt = Color3.fromRGB(50, 58, 114),
        Divider   = Color3.fromRGB(22, 26, 56),
        Accent    = Color3.fromRGB(114, 136, 255),
        AccentDim = Color3.fromRGB(68, 84, 196),
        TextPri   = Color3.fromRGB(214, 218, 255),
        TextSec   = Color3.fromRGB(100, 108, 166),
        TextDim   = Color3.fromRGB(58, 64, 108),
        Toggle    = Color3.fromRGB(104, 144, 255),
        ToggleOff = Color3.fromRGB(30, 34, 66),
        Danger    = Color3.fromRGB(214, 64, 84),
        Success   = Color3.fromRGB(64, 196, 126),
        Warning   = Color3.fromRGB(214, 168, 56),
        Scrollbar = Color3.fromRGB(52, 62, 130),
        Shadow    = Color3.fromRGB(2, 2, 8),
        Tag       = Color3.fromRGB(20, 23, 46),
    },
    Rose = {
        Window    = Color3.fromRGB(17, 8, 13),
        Topbar    = Color3.fromRGB(21, 10, 16),
        Sidebar   = Color3.fromRGB(12, 6, 10),
        Content   = Color3.fromRGB(21, 10, 16),
        Card      = Color3.fromRGB(27, 13, 20),
        CardHover = Color3.fromRGB(34, 17, 26),
        Input     = Color3.fromRGB(10, 5, 8),
        Stroke    = Color3.fromRGB(76, 34, 52),
        StrokeAlt = Color3.fromRGB(112, 50, 76),
        Divider   = Color3.fromRGB(52, 20, 36),
        Accent    = Color3.fromRGB(220, 88, 128),
        AccentDim = Color3.fromRGB(148, 50, 84),
        TextPri   = Color3.fromRGB(255, 216, 226),
        TextSec   = Color3.fromRGB(164, 100, 124),
        TextDim   = Color3.fromRGB(104, 56, 78),
        Toggle    = Color3.fromRGB(226, 92, 132),
        ToggleOff = Color3.fromRGB(58, 24, 38),
        Danger    = Color3.fromRGB(255, 62, 62),
        Success   = Color3.fromRGB(62, 196, 104),
        Warning   = Color3.fromRGB(220, 162, 46),
        Scrollbar = Color3.fromRGB(132, 56, 86),
        Shadow    = Color3.fromRGB(4, 0, 2),
        Tag       = Color3.fromRGB(34, 17, 26),
    },
    Ocean = {
        Window    = Color3.fromRGB(4, 12, 23),
        Topbar    = Color3.fromRGB(6, 15, 29),
        Sidebar   = Color3.fromRGB(3, 9, 18),
        Content   = Color3.fromRGB(6, 15, 29),
        Card      = Color3.fromRGB(8, 20, 38),
        CardHover = Color3.fromRGB(12, 27, 50),
        Input     = Color3.fromRGB(3, 9, 19),
        Stroke    = Color3.fromRGB(0, 58, 102),
        StrokeAlt = Color3.fromRGB(0, 90, 150),
        Divider   = Color3.fromRGB(0, 36, 68),
        Accent    = Color3.fromRGB(0, 168, 240),
        AccentDim = Color3.fromRGB(0, 100, 164),
        TextPri   = Color3.fromRGB(188, 232, 255),
        TextSec   = Color3.fromRGB(74, 150, 194),
        TextDim   = Color3.fromRGB(42, 92, 132),
        Toggle    = Color3.fromRGB(0, 188, 250),
        ToggleOff = Color3.fromRGB(8, 34, 58),
        Danger    = Color3.fromRGB(255, 72, 72),
        Success   = Color3.fromRGB(0, 204, 136),
        Warning   = Color3.fromRGB(255, 184, 36),
        Scrollbar = Color3.fromRGB(0, 92, 154),
        Shadow    = Color3.fromRGB(0, 1, 4),
        Tag       = Color3.fromRGB(12, 27, 50),
    },
    Emerald = {
        Window    = Color3.fromRGB(6, 16, 12),
        Topbar    = Color3.fromRGB(8, 20, 15),
        Sidebar   = Color3.fromRGB(4, 12, 9),
        Content   = Color3.fromRGB(8, 20, 15),
        Card      = Color3.fromRGB(11, 26, 20),
        CardHover = Color3.fromRGB(15, 34, 26),
        Input     = Color3.fromRGB(4, 12, 9),
        Stroke    = Color3.fromRGB(20, 66, 46),
        StrokeAlt = Color3.fromRGB(32, 102, 70),
        Divider   = Color3.fromRGB(13, 42, 28),
        Accent    = Color3.fromRGB(48, 204, 124),
        AccentDim = Color3.fromRGB(26, 134, 78),
        TextPri   = Color3.fromRGB(192, 246, 222),
        TextSec   = Color3.fromRGB(82, 160, 120),
        TextDim   = Color3.fromRGB(46, 100, 74),
        Toggle    = Color3.fromRGB(48, 204, 124),
        ToggleOff = Color3.fromRGB(14, 44, 30),
        Danger    = Color3.fromRGB(255, 72, 72),
        Success   = Color3.fromRGB(48, 204, 124),
        Warning   = Color3.fromRGB(214, 178, 46),
        Scrollbar = Color3.fromRGB(26, 106, 68),
        Shadow    = Color3.fromRGB(0, 2, 1),
        Tag       = Color3.fromRGB(15, 34, 26),
    },
    Violet = {
        Window    = Color3.fromRGB(12, 8, 22),
        Topbar    = Color3.fromRGB(15, 10, 28),
        Sidebar   = Color3.fromRGB(9, 6, 17),
        Content   = Color3.fromRGB(15, 10, 28),
        Card      = Color3.fromRGB(20, 13, 36),
        CardHover = Color3.fromRGB(26, 17, 46),
        Input     = Color3.fromRGB(8, 5, 16),
        Stroke    = Color3.fromRGB(60, 36, 96),
        StrokeAlt = Color3.fromRGB(88, 54, 140),
        Divider   = Color3.fromRGB(38, 20, 68),
        Accent    = Color3.fromRGB(158, 100, 255),
        AccentDim = Color3.fromRGB(100, 56, 196),
        TextPri   = Color3.fromRGB(230, 218, 255),
        TextSec   = Color3.fromRGB(130, 100, 180),
        TextDim   = Color3.fromRGB(80, 56, 118),
        Toggle    = Color3.fromRGB(158, 100, 255),
        ToggleOff = Color3.fromRGB(36, 20, 64),
        Danger    = Color3.fromRGB(220, 60, 80),
        Success   = Color3.fromRGB(60, 200, 120),
        Warning   = Color3.fromRGB(220, 170, 50),
        Scrollbar = Color3.fromRGB(88, 54, 150),
        Shadow    = Color3.fromRGB(2, 0, 4),
        Tag       = Color3.fromRGB(26, 17, 46),
    },
    Amber = {
        Window    = Color3.fromRGB(20, 14, 6),
        Topbar    = Color3.fromRGB(24, 17, 8),
        Sidebar   = Color3.fromRGB(15, 10, 4),
        Content   = Color3.fromRGB(24, 17, 8),
        Card      = Color3.fromRGB(30, 22, 10),
        CardHover = Color3.fromRGB(38, 28, 12),
        Input     = Color3.fromRGB(14, 9, 3),
        Stroke    = Color3.fromRGB(86, 58, 18),
        StrokeAlt = Color3.fromRGB(128, 88, 28),
        Divider   = Color3.fromRGB(56, 36, 10),
        Accent    = Color3.fromRGB(245, 176, 40),
        AccentDim = Color3.fromRGB(180, 118, 20),
        TextPri   = Color3.fromRGB(255, 238, 200),
        TextSec   = Color3.fromRGB(180, 140, 80),
        TextDim   = Color3.fromRGB(118, 86, 40),
        Toggle    = Color3.fromRGB(245, 176, 40),
        ToggleOff = Color3.fromRGB(52, 34, 10),
        Danger    = Color3.fromRGB(220, 60, 60),
        Success   = Color3.fromRGB(60, 200, 100),
        Warning   = Color3.fromRGB(245, 176, 40),
        Scrollbar = Color3.fromRGB(140, 96, 28),
        Shadow    = Color3.fromRGB(4, 2, 0),
        Tag       = Color3.fromRGB(38, 28, 12),
    },
}
MeyyHub.Themes = Themes

local currentTheme = "Dark"
local function TH() return Themes[currentTheme] end

local function normalizeTheme(name)
    if type(name) ~= "string" then return nil end
    if Themes[name] then return name end
    local lower = string.lower(name)
    for k in pairs(Themes) do
        if string.lower(k) == lower then return k end
    end
    return nil
end

local function tw(obj, props, t, s, d)
    pcall(function()
        TweenService:Create(obj,
            TweenInfo.new(t or 0.2, s or Enum.EasingStyle.Quart, d or Enum.EasingDirection.Out),
            props):Play()
    end)
end

local function corner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end

local function pad(p, l, r, t, b)
    local u = Instance.new("UIPadding", p)
    u.PaddingLeft   = UDim.new(0, l or 0)
    u.PaddingRight  = UDim.new(0, r or 0)
    u.PaddingTop    = UDim.new(0, t or 0)
    u.PaddingBottom = UDim.new(0, b or 0)
    return u
end

local function stroke(p, thick, col, mode)
    local s = Instance.new("UIStroke", p)
    s.Thickness = thick or 1
    s.Color = col or TH().Stroke
    s.ApplyStrokeMode = mode or Enum.ApplyStrokeMode.Border
    return s
end

local function listLayout(p, gap, ha, va)
    local l = Instance.new("UIListLayout", p)
    l.Padding = UDim.new(0, gap or 0)
    l.HorizontalAlignment = ha or Enum.HorizontalAlignment.Left
    l.VerticalAlignment   = va or Enum.VerticalAlignment.Top
    l.SortOrder = Enum.SortOrder.LayoutOrder
    return l
end

local function scrollFrame(p, name, size, pos, zi)
    local sf = Instance.new("ScrollingFrame", p)
    sf.Name = name or "Scroll"
    sf.Size = size or UDim2.new(1, 0, 1, 0)
    sf.Position = pos or UDim2.new(0, 0, 0, 0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel = 0
    sf.ScrollBarThickness = 2
    sf.ScrollBarImageColor3 = TH().Scrollbar
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.CanvasSize = UDim2.new(0, 0, 0, 0)
    sf.ZIndex = zi or 2
    table.insert(_reg.scrolls, sf)
    return sf
end

local function frame(p, name, size, pos, bg, alpha, zi, clip)
    local f = Instance.new("Frame", p)
    f.Name = name or "Frame"
    f.Size = size or UDim2.new(1, 0, 1, 0)
    f.Position = pos or UDim2.new(0, 0, 0, 0)
    f.BackgroundColor3 = bg or TH().Card
    f.BackgroundTransparency = alpha or 0
    f.ZIndex = zi or 2
    f.BorderSizePixel = 0
    if clip then f.ClipsDescendants = true end
    return f
end

local function lbl(p, txt, font, sz, col, xa, zi)
    local l = Instance.new("TextLabel", p)
    l.BackgroundTransparency = 1
    l.Font = font or Enum.Font.Gotham
    l.Text = txt or ""
    l.TextSize = sz or 13
    l.TextColor3 = col or TH().TextPri
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.ZIndex = zi or ((p.ZIndex or 2) + 1)
    return l
end

local function textBtn(p, zi)
    local b = Instance.new("TextButton", p)
    b.BackgroundTransparency = 1
    b.Text = ""
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.AutoButtonColor = false
    b.ZIndex = zi or ((p.ZIndex or 2) + 2)
    return b
end

local function regBg(obj, key)     table.insert(_reg.bgs,     {obj = obj, key = key}) end
local function regText(obj, key)   table.insert(_reg.texts,   {obj = obj, key = key}) end
local function regAccent(obj, prop) table.insert(_reg.accents, {obj = obj, prop = prop or "BackgroundColor3"}) end

local function applyTheme(name)
    local th = Themes[name]
    if not th then return end
    currentTheme = name
    for _, s in ipairs(_reg.strokes) do
        if s and s.Parent then s.Color = th.Stroke end
    end
    for _, a in ipairs(_reg.accents) do
        if a.obj and a.obj.Parent then
            pcall(function() a.obj[a.prop] = th.Accent end)
        end
    end
    for _, b in ipairs(_reg.bgs) do
        if b.obj and b.obj.Parent then tw(b.obj, {BackgroundColor3 = th[b.key]}) end
    end
    for _, sw in ipairs(_reg.switches) do
        if sw.track and sw.track.Parent then
            tw(sw.track, {BackgroundColor3 = sw.active and th.Toggle or th.ToggleOff})
        end
    end
    for _, t in ipairs(_reg.texts) do
        if t.obj and t.obj.Parent then tw(t.obj, {TextColor3 = th[t.key]}) end
    end
    for _, sf in ipairs(_reg.scrolls) do
        if sf and sf.Parent then sf.ScrollBarImageColor3 = th.Scrollbar end
    end
    for _, d in ipairs(_reg.dividers) do
        if d and d.Parent then
            d.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,   Color3.new(0,0,0)),
                ColorSequenceKeypoint.new(0.5, th.Divider),
                ColorSequenceKeypoint.new(1,   Color3.new(0,0,0)),
            })
        end
    end
    for _, f in ipairs(_reg.fills) do
        if f and f.Parent then tw(f, {BackgroundColor3 = th.Accent}) end
    end
end

MeyyHub.GetThemes = function(self)
    local names = {}
    for k in pairs(Themes) do table.insert(names, k) end
    table.sort(names)
    return names
end

MeyyHub.SetTheme = function(self, name)
    local n = normalizeTheme(name)
    if n then applyTheme(n) end
end


-- ============================================================
-- NOTIFICATION
-- ============================================================
local notifList = {}

function MeyyHub:Notify(cfg)
    cfg = cfg or {}
    local th = TH()
    local sg = Instance.new("ScreenGui")
    sg.Name = "MeyyNotif_" .. math.random(10000, 99999)
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local nf = frame(sg, "N", UDim2.new(0, 268, 0, 70), UDim2.new(1, 60, 1, -18), th.Card, 0, 50)
    nf.AnchorPoint = Vector2.new(1, 1)
    corner(nf, 10)
    local ns = stroke(nf, 1, th.Stroke)
    ns.Transparency = 0.28
    table.insert(_reg.strokes, ns)

    local acBar = frame(nf, "Bar", UDim2.new(0, 3, 1, -16), UDim2.new(0, 0, 0, 8), cfg.Color or th.Accent, 0, 51)
    corner(acBar, 2)

    local tl = lbl(nf, cfg.Title or "Notice", Enum.Font.GothamBold, 13, th.TextPri, Enum.TextXAlignment.Left, 51)
    tl.Size = UDim2.new(1, -20, 0, 20)
    tl.Position = UDim2.new(0, 14, 0, 10)

    local dl = lbl(nf, cfg.Content or "", Enum.Font.Gotham, 11, th.TextSec, Enum.TextXAlignment.Left, 51)
    dl.Size = UDim2.new(1, -20, 0, 30)
    dl.Position = UDim2.new(0, 14, 0, 30)
    dl.TextWrapped = true
    dl.TextTruncate = Enum.TextTruncate.None

    for i, n in ipairs(notifList) do
        if n and n.Parent then tw(n, {Position = UDim2.new(1, -18, 1, -18 - i * 82)}, 0.16) end
    end
    table.insert(notifList, 1, nf)
    if #notifList > 6 then
        local old = table.remove(notifList, 7)
        if old then
            tw(old, {Position = UDim2.new(1, 320, 1, old.Position.Y.Offset)}, 0.16)
            task.delay(0.2, function() if old.Parent then old.Parent:Destroy() end end)
        end
    end
    tw(nf, {Position = UDim2.new(1, -18, 1, -18)}, 0.34, Enum.EasingStyle.Back)
    task.delay(cfg.Duration or 4, function()
        for i, n in ipairs(notifList) do
            if n == nf then table.remove(notifList, i) break end
        end
        tw(nf, {Position = UDim2.new(1, 320, 1, nf.Position.Y.Offset)}, 0.26, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.delay(0.3, function()
            sg:Destroy()
            for i2, n in ipairs(notifList) do
                if n and n.Parent then tw(n, {Position = UDim2.new(1, -18, 1, -18 - (i2-1)*82)}, 0.16) end
            end
        end)
    end)
end
MeyyHub.SendNotification = MeyyHub.Notify

-- ============================================================
-- CONFIG
-- ============================================================
function MeyyHub:SaveConfig(name, silent)
    local folder = self._folder or "MeyyHub"
    if not isfolder(folder) then makefolder(folder) end
    local d = {}
    for flag, elem in pairs(self.Flags) do d[flag] = elem.Value end
    pcall(writefile, folder .. "/" .. name .. ".json", HttpService:JSONEncode(d))
    if not silent then self:Notify({Title = "Config", Content = "Saved: " .. name}) end
end

function MeyyHub:LoadConfig(name, silent)
    local folder = self._folder or "MeyyHub"
    local path = folder .. "/" .. name .. ".json"
    if not isfile(path) then
        if not silent then self:Notify({Title = "Config", Content = "Not found: " .. name}) end
        return false
    end
    local ok, d = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
    if ok and type(d) == "table" then
        self.IsLoading = true
        for flag, val in pairs(d) do
            if self.Flags[flag] and self.Flags[flag].Set then
                pcall(self.Flags[flag].Set, val)
            end
        end
        self.IsLoading = false
        if not silent then self:Notify({Title = "Config", Content = "Loaded: " .. name}) end
        return true
    end
    return false
end


-- ============================================================
-- CREATE WINDOW
-- ============================================================
function MeyyHub:CreateWindow(cfg)
    cfg = cfg or {}
    if self._window then warn("[MeyyHub] CreateWindow called more than once") return nil end

    local WIN_W  = (cfg.Size and cfg.Size.X.Offset) or 700
    local WIN_H  = (cfg.Size and cfg.Size.Y.Offset) or 490
    local MIN_W  = 560; local MAX_W = 900
    local MIN_H  = 340; local MAX_H = 580
    local SIDE_W = cfg.SideBarWidth or 200
    local TOP_H  = (cfg.Topbar and cfg.Topbar.Height) or 48
    local AV_H   = 78
    local FOLDER = cfg.Folder or "MeyyHub"
    local MinKey = cfg.ToggleKey or cfg.MinimizeKey or Enum.KeyCode.RightShift
    local Resizable = cfg.Resizable ~= false
    local MacBtns   = cfg.Topbar and cfg.Topbar.ButtonsType == "Mac"

    self._folder = FOLDER
    local themeName = normalizeTheme(cfg.Theme) or "Dark"
    currentTheme = themeName

    if getgenv and getgenv().__MeyyHub_Root then
        pcall(function() getgenv().__MeyyHub_Root:Destroy() end)
    end
    self.Flags = {}; self._conns = {}
    _reg.strokes={}; _reg.accents={}; _reg.bgs={}; _reg.switches={}
    _reg.dividers={}; _reg.texts={}; _reg.scrolls={}; _reg.fills={}

    local Root = Instance.new("ScreenGui")
    Root.Name = "MeyyHub_" .. math.random(10000,99999)
    Root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Root.ResetOnSpawn = false
    Root.IgnoreGuiInset = true
    pcall(function() Root.Parent = CoreGui end)
    if not Root.Parent then Root.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    if getgenv then getgenv().__MeyyHub_Root = Root end
    self._gui = Root

    local th = TH()

    -- Shadows
    local Sh1 = frame(Root,"Sh1",UDim2.new(0,WIN_W+28,0,WIN_H+28),UDim2.new(0.5,0,0.5,7),th.Shadow,0.44,1)
    Sh1.AnchorPoint = Vector2.new(0.5,0.5); corner(Sh1,18)
    local Sh2 = frame(Root,"Sh2",UDim2.new(0,WIN_W+12,0,WIN_H+12),UDim2.new(0.5,0,0.5,3),th.Shadow,0.62,1)
    Sh2.AnchorPoint = Vector2.new(0.5,0.5); corner(Sh2,15)

    -- Main window
    local Win = frame(Root,"Window",UDim2.new(0,WIN_W,0,WIN_H),UDim2.new(0.5,0,0.5,0),th.Window,0,2,true)
    Win.AnchorPoint = Vector2.new(0.5,0.5); corner(Win,12)
    regBg(Win,"Window")
    local winStroke = stroke(Win,1,th.Stroke)
    table.insert(_reg.strokes, winStroke)

    local normalSize = UDim2.new(0,WIN_W,0,WIN_H)
    local normalPos  = UDim2.new(0.5,0,0.5,0)
    local isMini, isMax, isHidden = false, false, false

    local function syncShadow(v) Sh1.Visible=v; Sh2.Visible=v end
    local function syncShadowPos(p)
        Sh1.Position = UDim2.new(p.X.Scale,p.X.Offset,p.Y.Scale,p.Y.Offset+7)
        Sh2.Position = UDim2.new(p.X.Scale,p.X.Offset,p.Y.Scale,p.Y.Offset+3)
    end

    -- Topbar
    local Topbar = frame(Win,"Topbar",UDim2.new(1,0,0,TOP_H),UDim2.new(0,0,0,0),th.Topbar,0,10)
    regBg(Topbar,"Topbar")
    local topLine = frame(Topbar,"Line",UDim2.new(1,0,0,1),UDim2.new(0,0,1,-1),th.Divider,0,11)
    regBg(topLine,"Divider")

    local titleX = 14
    if cfg.Icon and cfg.Icon ~= "" then
        local ico = Instance.new("ImageLabel",Topbar)
        ico.Size = UDim2.new(0,20,0,20)
        ico.Position = UDim2.new(0,14,0.5,0); ico.AnchorPoint = Vector2.new(0,0.5)
        ico.BackgroundTransparency = 1
        ico.Image = tostring(cfg.Icon):match("^%d+$") and ("rbxassetid://"..cfg.Icon) or cfg.Icon
        ico.ImageColor3 = th.Accent; ico.ZIndex = 12
        regAccent(ico,"ImageColor3"); titleX = 40
    end

    local titleLbl = lbl(Topbar, cfg.Title or "MeyyHub", Enum.Font.GothamBold, 13, th.TextPri, Enum.TextXAlignment.Left, 12)
    titleLbl.Size = UDim2.new(0,240,1,0); titleLbl.Position = UDim2.new(0,titleX,0,0)

    if cfg.Author and cfg.Author ~= "" then
        local authL = lbl(Topbar, cfg.Author, Enum.Font.Gotham, 10, th.TextSec, Enum.TextXAlignment.Left, 12)
        authL.Size = UDim2.new(0,160,1,0); authL.Position = UDim2.new(0,titleX+2,0,14)
        regText(authL,"TextSec")
    end

    -- Window buttons
    local function mkWinBtn(icon, xOff, danger)
        local b = Instance.new("TextButton",Topbar)
        b.Size = UDim2.new(0,26,0,26)
        b.Position = MacBtns and UDim2.new(0,xOff,0.5,0) or UDim2.new(1,xOff,0.5,0)
        b.AnchorPoint = Vector2.new(0,0.5)
        b.BackgroundColor3 = danger and th.Danger or th.Card
        b.BackgroundTransparency = danger and 0.56 or 0.72
        b.Font = Enum.Font.GothamBold; b.Text = icon
        b.TextColor3 = danger and Color3.fromRGB(255,200,202) or th.TextSec
        b.TextSize = MacBtns and 0 or 10; b.ZIndex = 12; b.AutoButtonColor = false
        corner(b, MacBtns and 13 or 6)
        if MacBtns then b.BackgroundTransparency = 0 end
        b.MouseEnter:Connect(function()
            tw(b,{BackgroundTransparency = danger and 0.1 or 0.46, TextColor3 = TH().TextPri})
        end)
        b.MouseLeave:Connect(function()
            tw(b,{BackgroundTransparency = danger and 0.56 or 0.72,
                TextColor3 = danger and Color3.fromRGB(255,200,202) or TH().TextSec})
        end)
        return b
    end

    local BtnClose, BtnMin, BtnMax
    if MacBtns then
        BtnClose = mkWinBtn("",12,false); BtnMin = mkWinBtn("",40,false); BtnMax = mkWinBtn("",68,false)
        BtnClose.BackgroundColor3 = Color3.fromRGB(255,95,87)
        BtnMin.BackgroundColor3   = Color3.fromRGB(255,189,46)
        BtnMax.BackgroundColor3   = Color3.fromRGB(39,201,63)
    else
        BtnMin   = mkWinBtn("_",  -100, false)
        BtnMax   = mkWinBtn("[]", -66,  false)
        BtnClose = mkWinBtn("X",  -32,  true)
    end

    -- Side divider
    local SideDiv = frame(Win,"SideDiv",UDim2.new(0,1,1,-TOP_H),UDim2.new(0,SIDE_W,0,TOP_H),th.Divider,0,6)
    regBg(SideDiv,"Divider")

    -- Sidebar
    local Sidebar = frame(Win,"Sidebar",UDim2.new(0,SIDE_W,1,-TOP_H),UDim2.new(0,0,0,TOP_H),th.Sidebar,0,5,true)
    regBg(Sidebar,"Sidebar")

    local TabScroll = scrollFrame(Sidebar,"TabScroll",UDim2.new(1,0,1,-AV_H),UDim2.new(0,0,0,0),5)
    listLayout(TabScroll,2,Enum.HorizontalAlignment.Center)
    pad(TabScroll,0,0,8,10)

    -- Profile / Avatar card at bottom of sidebar
    local AvCard = frame(Sidebar,"AvatarCard",UDim2.new(1,0,0,AV_H),UDim2.new(0,0,1,-AV_H),th.Card,0.56,6)
    regBg(AvCard,"Card")
    local avTopLine = frame(AvCard,"Line",UDim2.new(1,0,0,1),UDim2.new(0,0,0,0),th.Divider,0,7)
    regBg(avTopLine,"Divider")

    local avHolder = frame(AvCard,"AvHolder",UDim2.new(0,42,0,42),UDim2.new(0,14,0.5,0),th.Card,0.2,7)
    avHolder.AnchorPoint = Vector2.new(0,0.5); corner(avHolder,21); regBg(avHolder,"Card")
    local avS = stroke(avHolder,1.5,th.Accent); avS.Transparency = 0.36; regAccent(avS,"Color")

    local avImg = Instance.new("ImageLabel",avHolder)
    avImg.Size = UDim2.new(1,-4,1,-4); avImg.Position = UDim2.new(0,2,0,2)
    avImg.BackgroundTransparency = 1; avImg.ScaleType = Enum.ScaleType.Crop; avImg.ZIndex = 8
    corner(avImg,19)

    local onDot = frame(avHolder,"Dot",UDim2.new(0,10,0,10),UDim2.new(1,0,1,0),th.Success,0,9)
    onDot.AnchorPoint = Vector2.new(1,1); corner(onDot,5)
    local dotBorder = stroke(onDot,2,th.Sidebar); table.insert(_reg.strokes,dotBorder)

    local nameLbl = lbl(AvCard,"Username",Enum.Font.GothamBold,13,th.TextPri,Enum.TextXAlignment.Left,7)
    nameLbl.Size = UDim2.new(1,-70,0,18); nameLbl.Position = UDim2.new(0,64,0,17)
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd; regText(nameLbl,"TextPri")

    local subLbl = lbl(AvCard,"Roblox Player",Enum.Font.Gotham,10,th.TextSec,Enum.TextXAlignment.Left,7)
    subLbl.Size = UDim2.new(1,-70,0,14); subLbl.Position = UDim2.new(0,64,0,38)
    subLbl.TextTruncate = Enum.TextTruncate.AtEnd; regText(subLbl,"TextSec")

    local userCfg = cfg.User or {}
    if userCfg.Enabled ~= false then
        task.spawn(function()
            pcall(function()
                if userCfg.Anonymous then
                    nameLbl.Text = "Anonymous"; subLbl.Text = "@anonymous"
                else
                    nameLbl.Text = LocalPlayer.Name
                    subLbl.Text  = "@" .. string.lower(LocalPlayer.Name)
                    avImg.Image  = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
                end
            end)
        end)
        if userCfg.Callback then
            local avClick = textBtn(AvCard,8)
            avClick.Size = UDim2.new(1,0,1,0)
            avClick.MouseButton1Click:Connect(userCfg.Callback)
        end
    end

    -- Content area
    local ContentArea = frame(Win,"ContentArea",
        UDim2.new(1,-SIDE_W-1,1,-TOP_H), UDim2.new(0,SIDE_W+1,0,TOP_H),
        th.Content,0,4,true)
    regBg(ContentArea,"Content")

    -- Open/toggle button
    local openCfg = cfg.OpenButton or {}
    local OpenBtn = Instance.new("ImageButton",Root)
    OpenBtn.Name = "OpenBtn"
    OpenBtn.Size = UDim2.new(0,42,0,42); OpenBtn.Position = UDim2.new(0,16,1,-60)
    OpenBtn.BackgroundColor3 = th.Card; OpenBtn.BackgroundTransparency = 0.12
    OpenBtn.Image = "rbxassetid://6031090990"; OpenBtn.ZIndex = 50; OpenBtn.AutoButtonColor = false
    corner(OpenBtn,21); regBg(OpenBtn,"Card")
    local obS = stroke(OpenBtn,1.5,th.Accent); obS.Transparency = 0.35; regAccent(obS,"Color")

    if openCfg.Title and openCfg.Title ~= "" then
        local obL = lbl(OpenBtn,openCfg.Title,Enum.Font.GothamBold,9,th.TextSec,Enum.TextXAlignment.Center,51)
        obL.Size = UDim2.new(1,0,0,14); obL.Position = UDim2.new(0,0,1,4)
    end

    local obDrag,obMoved,obStart,obPos = false,false,nil,nil
    if openCfg.Draggable ~= false then
        OpenBtn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                obDrag=true; obMoved=false; obStart=i.Position; obPos=OpenBtn.Position
            end
        end)
        local cOB = UserInput.InputChanged:Connect(function(i)
            if obDrag and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - obStart
                if d.Magnitude > 5 then obMoved = true end
                OpenBtn.Position = UDim2.new(obPos.X.Scale,obPos.X.Offset+d.X,obPos.Y.Scale,obPos.Y.Offset+d.Y)
            end
        end)
        local cOBE = UserInput.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then obDrag=false end
        end)
        table.insert(self._conns,cOB); table.insert(self._conns,cOBE)
    end

    local function toggleUI()
        if isHidden then
            isHidden=false; Win.Visible=true
            local ts = isMini and UDim2.new(0,WIN_W,0,TOP_H) or (isMax and UDim2.new(1,0,1,0) or normalSize)
            local tp = isMini and UDim2.new(0.5,0,0,22) or normalPos
            Win.Size = UDim2.new(0,0,0,0)
            tw(Win,{Size=ts,Position=tp},0.42,Enum.EasingStyle.Back)
            if not isMini then syncShadow(true) end
        else
            isHidden=true; syncShadow(false)
            tw(Win,{Size=UDim2.new(0,0,0,0)},0.26,Enum.EasingStyle.Back,Enum.EasingDirection.In)
            task.delay(0.28,function() Win.Visible=false end)
        end
    end

    OpenBtn.MouseButton1Click:Connect(function() if not obMoved then toggleUI() end end)
    local cKey = UserInput.InputBegan:Connect(function(i,gpe)
        if gpe then return end
        if i.KeyCode == MinKey then toggleUI() end
    end)
    table.insert(self._conns,cKey)


    -- Window controls
    local function restoreContent()
        Sidebar.Visible=true; SideDiv.Visible=true; ContentArea.Visible=true
    end

    local function showDialog(dcfg)
        dcfg = dcfg or {}
        local ovl = frame(Root,"Overlay",UDim2.new(1,0,1,0),UDim2.new(0,0,0,0),Color3.new(0,0,0),0.5,200)
        local dlg = frame(ovl,"Dialog",UDim2.new(0,dcfg.Width or 320,0,0),UDim2.new(0.5,0,0.42,0),TH().Card,0,201)
        dlg.AutomaticSize = Enum.AutomaticSize.Y; dlg.AnchorPoint = Vector2.new(0.5,0.5); corner(dlg,11)
        local ds = stroke(dlg,1,TH().Accent); ds.Transparency = 0.5
        listLayout(dlg,0); pad(dlg,14,14,14,14)

        local dT = lbl(dlg,dcfg.Title or "Dialog",Enum.Font.GothamBold,15,TH().TextPri,Enum.TextXAlignment.Left,202)
        dT.LayoutOrder=1; dT.Size=UDim2.new(1,0,0,22)
        local dD = lbl(dlg,dcfg.Content or "",Enum.Font.Gotham,11,TH().TextSec,Enum.TextXAlignment.Left,202)
        dD.LayoutOrder=2; dD.Size=UDim2.new(1,0,0,0); dD.AutomaticSize=Enum.AutomaticSize.Y
        dD.TextWrapped=true; dD.TextTruncate=Enum.TextTruncate.None

        local sp = frame(dlg,"Sp",UDim2.new(1,0,0,10),UDim2.new(0,0,0,0),TH().Card,1,201); sp.LayoutOrder=3
        local btnsRow = frame(dlg,"Btns",UDim2.new(1,0,0,36),UDim2.new(0,0,0,0),TH().Card,1,201); btnsRow.LayoutOrder=4
        local bRow = listLayout(btnsRow,8,Enum.HorizontalAlignment.Right)
        bRow.FillDirection = Enum.FillDirection.Horizontal

        local buttons = dcfg.Buttons or {
            {Title="Cancel",Variant="Secondary",Callback=function()end},
            {Title="Close UI",Variant="Primary",Callback=function()
                syncShadow(false)
                tw(Win,{Size=UDim2.new(0,0,0,0)},0.28,Enum.EasingStyle.Back,Enum.EasingDirection.In)
                task.delay(0.35,function()
                    for _,c in ipairs(MeyyHub._conns) do pcall(function()c:Disconnect()end)end
                    Root:Destroy(); MeyyHub._window=nil
                end)
            end},
        }
        for _,bcfg in ipairs(buttons) do
            local isPri = bcfg.Variant=="Primary"
            local bb = Instance.new("TextButton",btnsRow)
            bb.Size=UDim2.new(0,0,0,34); bb.AutomaticSize=Enum.AutomaticSize.X
            bb.BackgroundColor3 = isPri and TH().Accent or TH().Card
            bb.BackgroundTransparency = isPri and 0.06 or 0
            bb.Font=Enum.Font.GothamBold; bb.Text=bcfg.Title or "OK"
            bb.TextColor3 = isPri and Color3.new(1,1,1) or TH().TextPri
            bb.TextSize=12; bb.ZIndex=202; bb.AutoButtonColor=false
            corner(bb,7); pad(bb,14,14,0,0)
            if not isPri then stroke(bb,1,TH().Stroke) end
            bb.MouseEnter:Connect(function() tw(bb,{BackgroundTransparency=isPri and 0 or 0.55}) end)
            bb.MouseLeave:Connect(function() tw(bb,{BackgroundTransparency=isPri and 0.06 or 0}) end)
            bb.MouseButton1Click:Connect(function() ovl:Destroy(); if bcfg.Callback then bcfg.Callback() end end)
        end
        dlg.Position=UDim2.new(0.5,0,0.36,0)
        tw(dlg,{Position=UDim2.new(0.5,0,0.42,0)},0.28,Enum.EasingStyle.Back)
        ovl.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then
                tw(dlg,{Size=UDim2.new(0,0,0,0)},0.2,Enum.EasingStyle.Back,Enum.EasingDirection.In)
                task.delay(0.22,function()ovl:Destroy()end)
            end
        end)
        return ovl
    end

    BtnClose.MouseButton1Click:Connect(function()
        showDialog({Title="Close UI",Content="Are you sure you want to close the UI?",Buttons={
            {Title="Cancel",Variant="Secondary",Callback=function()end},
            {Title="Close UI",Variant="Primary",Callback=function()
                syncShadow(false)
                tw(Win,{Size=UDim2.new(0,0,0,0)},0.28,Enum.EasingStyle.Back,Enum.EasingDirection.In)
                task.delay(0.35,function()
                    for _,c in ipairs(MeyyHub._conns) do pcall(function()c:Disconnect()end)end
                    Root:Destroy(); MeyyHub._window=nil
                end)
            end},
        }})
    end)

    BtnMin.MouseButton1Click:Connect(function()
        if not isMini then
            isMini=true; isMax=false
            tw(Win,{Size=UDim2.new(0,WIN_W,0,TOP_H),Position=UDim2.new(0.5,0,0,22)},0.28,Enum.EasingStyle.Quart)
            syncShadow(false)
            task.delay(0.04,function() Sidebar.Visible=false; SideDiv.Visible=false; ContentArea.Visible=false end)
        else
            isMini=false
            tw(Win,{Size=normalSize,Position=normalPos},0.38,Enum.EasingStyle.Back)
            syncShadow(true); task.delay(0.16,restoreContent)
        end
    end)

    BtnMax.MouseButton1Click:Connect(function()
        if not isMax then
            isMax=true; isMini=false
            tw(Win,{Size=UDim2.new(1,0,1,0),Position=UDim2.new(0.5,0,0.5,0)},0.28,Enum.EasingStyle.Quart)
            syncShadow(false); restoreContent()
        else
            isMax=false
            tw(Win,{Size=normalSize,Position=normalPos},0.28,Enum.EasingStyle.Quart); syncShadow(true)
        end
    end)

    -- Drag
    local drag,dStart,dWP = false,nil,nil
    Topbar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true;dStart=i.Position;dWP=Win.Position end
    end)
    local cD1 = UserInput.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-dStart
            local np=UDim2.new(dWP.X.Scale,dWP.X.Offset+d.X,dWP.Y.Scale,dWP.Y.Offset+d.Y)
            Win.Position=np; syncShadowPos(np)
        end
    end)
    local cD2 = UserInput.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
    table.insert(self._conns,cD1); table.insert(self._conns,cD2)

    -- Resize
    if Resizable then
        local rh = frame(Win,"ResizeHandle",UDim2.new(0,16,0,16),UDim2.new(1,-16,1,-16),Color3.new(1,1,1),1,12)
        local rImg = Instance.new("ImageLabel",rh)
        rImg.Size=UDim2.new(1,0,1,0); rImg.BackgroundTransparency=1
        rImg.Image="rbxassetid://6031280882"; rImg.ImageColor3=TH().TextDim; rImg.ZIndex=13
        local resizing,rsStart,rsWSize=false,nil,nil
        rh.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then
                resizing=true;rsStart=i.Position;rsWSize=Vector2.new(Win.AbsoluteSize.X,Win.AbsoluteSize.Y)
            end
        end)
        local cR1=UserInput.InputChanged:Connect(function(i)
            if resizing and i.UserInputType==Enum.UserInputType.MouseMovement then
                local d=i.Position-rsStart
                Win.Size=UDim2.new(0,math.clamp(rsWSize.X+d.X,MIN_W,MAX_W),0,math.clamp(rsWSize.Y+d.Y,MIN_H,MAX_H))
                normalSize=Win.Size
            end
        end)
        local cR2=UserInput.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then resizing=false end
        end)
        table.insert(self._conns,cR1); table.insert(self._conns,cR2)
    end

    -- Render loop (no snow, no emoji animations)
    local cLoop = RunService.RenderStepped:Connect(function()
        winStroke.Color = TH().Stroke
    end)
    table.insert(self._conns,cLoop)

    -- ============================================================
    -- ELEMENT BUILDER
    -- ============================================================
    local function makeCard(parent, lo, h, auto)
        local c = frame(parent,"Card",UDim2.new(1,-2,0,h or 42),UDim2.new(0,0,0,0),TH().Card,0.12,(parent.ZIndex or 4)+1)
        c.LayoutOrder = lo or 0
        if auto then c.AutomaticSize=Enum.AutomaticSize.Y; c.Size=UDim2.new(1,-2,0,0) end
        corner(c,8); regBg(c,"Card")
        local cs = stroke(c,1,TH().Stroke); cs.Transparency=0.40; table.insert(_reg.strokes,cs)
        c.MouseEnter:Connect(function() tw(c,{BackgroundTransparency=0.04}) end)
        c.MouseLeave:Connect(function() tw(c,{BackgroundTransparency=0.12}) end)
        return c
    end

    local function buildElements(Tab, page)
        local eo = 0
        local function N() eo=eo+1; return eo end

        function Tab:Space(h)
            local f=frame(page,"Space",UDim2.new(1,0,0,h or 6),UDim2.new(0,0,0,0),TH().Card,1,page.ZIndex or 4)
            f.LayoutOrder=N()
        end

        function Tab:Divider()
            local div=frame(page,"Div",UDim2.new(1,-4,0,1),UDim2.new(0,2,0,0),TH().Divider,0,page.ZIndex or 4)
            div.LayoutOrder=N(); regBg(div,"Divider")
            local dg=Instance.new("UIGradient",div)
            dg.Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),
                ColorSequenceKeypoint.new(0.5,TH().Divider),
                ColorSequenceKeypoint.new(1,Color3.new(0,0,0)),
            })
            table.insert(_reg.dividers,dg)
        end

        function Tab:Section(c2)
            c2=c2 or {}
            local sec=frame(page,"Section",UDim2.new(1,0,0,0),UDim2.new(0,0,0,0),TH().Card,1,page.ZIndex or 4)
            sec.AutomaticSize=Enum.AutomaticSize.Y; sec.LayoutOrder=N(); listLayout(sec,5)
            if c2.Title and c2.Title~="" then
                local sl=lbl(sec,(c2.Title or ""):upper(),Enum.Font.GothamBold,c2.TextSize or 11,TH().TextDim,Enum.TextXAlignment.Left,(page.ZIndex or 4)+1)
                sl.Size=UDim2.new(1,0,0,16); sl.LayoutOrder=1; regText(sl,"TextDim")
            end
        end

        function Tab:Paragraph(c2)
            c2=c2 or {}
            local card=makeCard(page,N(),nil,true)
            listLayout(card,4); pad(card,13,13,10,10)
            if c2.Title and c2.Title~="" then
                local tl=lbl(card,c2.Title,Enum.Font.GothamBold,c2.TitleSize or 13,TH().TextPri,Enum.TextXAlignment.Left,card.ZIndex+1)
                tl.Size=UDim2.new(1,0,0,0); tl.AutomaticSize=Enum.AutomaticSize.Y
                tl.LayoutOrder=1; tl.TextWrapped=true; tl.TextTruncate=Enum.TextTruncate.None; regText(tl,"TextPri")
            end
            if c2.Content and c2.Content~="" then
                local dl=lbl(card,c2.Content,Enum.Font.Gotham,11,TH().TextSec,Enum.TextXAlignment.Left,card.ZIndex+1)
                dl.Size=UDim2.new(1,0,0,0); dl.AutomaticSize=Enum.AutomaticSize.Y
                dl.LayoutOrder=2; dl.TextWrapped=true; dl.TextTruncate=Enum.TextTruncate.None; regText(dl,"TextSec")
            end
        end

        function Tab:Label(c2)
            c2=c2 or {}
            Tab:Paragraph({Title=c2.Title or c2.Text, Content=c2.Content or c2.Desc})
        end


        function Tab:Button(c2)
            c2=c2 or {}
            local hasDesc=c2.Desc and c2.Desc~=""
            local h=hasDesc and 56 or 42
            local card=makeCard(page,N(),h)
            local acBar=frame(card,"Bar",UDim2.new(0,3,0.52,0),UDim2.new(0,0,0.5,0),c2.Color or TH().Accent,0,card.ZIndex+1)
            acBar.AnchorPoint=Vector2.new(0,0.5); corner(acBar,2)
            if not c2.Color then regAccent(acBar,"BackgroundColor3") end
            local tl=lbl(card,c2.Title or "Button",Enum.Font.GothamBold,13,TH().TextPri,Enum.TextXAlignment.Left,card.ZIndex+1)
            tl.Size=UDim2.new(1,-68,0,hasDesc and 22 or h); tl.Position=UDim2.new(0,16,0,hasDesc and 8 or 0); regText(tl,"TextPri")
            if hasDesc then
                local dl=lbl(card,c2.Desc,Enum.Font.Gotham,10,TH().TextSec,Enum.TextXAlignment.Left,card.ZIndex+1)
                dl.Size=UDim2.new(1,-68,0,18); dl.Position=UDim2.new(0,16,0,28); regText(dl,"TextSec")
            end
            local cz=textBtn(card,card.ZIndex+3); cz.Size=UDim2.new(1,0,1,0)
            local ripple=frame(card,"Rip",UDim2.new(0,0,0,0),UDim2.new(0.5,0,0.5,0),TH().Accent,0.7,card.ZIndex+1)
            ripple.AnchorPoint=Vector2.new(0.5,0.5); corner(ripple,4)
            cz.MouseButton1Down:Connect(function()
                ripple.Size=UDim2.new(0,0,0,0); ripple.BackgroundTransparency=0.62
                tw(ripple,{Size=UDim2.new(0,230,0,92),BackgroundTransparency=1},0.44)
            end)
            cz.MouseButton1Click:Connect(function() if c2.Callback then c2.Callback() end end)
            local El={}
            function El:SetTitle(t) tl.Text=t end
            function El:Lock() cz.Active=false end
            function El:Unlock() cz.Active=true end
            return El
        end

        function Tab:Toggle(c2)
            c2=c2 or {}
            local hasDesc=c2.Desc and c2.Desc~=""
            local h=hasDesc and 56 or 42
            local card=makeCard(page,N(),h)
            local active=c2.Value==true
            local isCheck=c2.Type=="Checkbox"
            local tl=lbl(card,c2.Title or "Toggle",Enum.Font.GothamBold,13,TH().TextPri,Enum.TextXAlignment.Left,card.ZIndex+1)
            tl.Size=UDim2.new(1,-62,0,hasDesc and 22 or h); tl.Position=UDim2.new(0,14,0,hasDesc and 8 or 0); regText(tl,"TextPri")
            if hasDesc then
                local dl=lbl(card,c2.Desc,Enum.Font.Gotham,10,TH().TextSec,Enum.TextXAlignment.Left,card.ZIndex+1)
                dl.Size=UDim2.new(1,-62,0,18); dl.Position=UDim2.new(0,14,0,28); regText(dl,"TextSec")
            end
            local track,knob; local sw={active=active}
            if isCheck then
                track=frame(card,"Track",UDim2.new(0,20,0,20),UDim2.new(1,-40,0.5,0),active and TH().Accent or TH().ToggleOff,0,card.ZIndex+2)
                track.AnchorPoint=Vector2.new(0,0.5); corner(track,5)
                local cs=stroke(track,1.5,active and TH().Accent or TH().Stroke); cs.Transparency=active and 0.28 or 0
                local chkIcon=lbl(track,active and "✓" or "",Enum.Font.GothamBold,13,Color3.new(1,1,1),Enum.TextXAlignment.Center,card.ZIndex+3)
                chkIcon.Size=UDim2.new(1,0,1,0); sw.track=track
                local function Set(v)
                    active=v; sw.active=v
                    tw(track,{BackgroundColor3=v and TH().Accent or TH().ToggleOff})
                    cs.Color=v and TH().Accent or TH().Stroke; cs.Transparency=v and 0.28 or 0
                    chkIcon.Text=v and "✓" or ""
                    if c2.Flag and MeyyHub.Flags[c2.Flag] then MeyyHub.Flags[c2.Flag].Value=v end
                    if c2.Callback then c2.Callback(v) end
                    if not MeyyHub.IsLoading then MeyyHub:SaveConfig("AutoSave",true) end
                end
                if c2.Flag then MeyyHub.Flags[c2.Flag]={Value=active,Set=Set} end
                table.insert(_reg.switches,sw)
                local cz=textBtn(card,card.ZIndex+4); cz.Size=UDim2.new(1,0,1,0)
                cz.MouseButton1Click:Connect(function() if not c2.Locked then Set(not active) end end)
                local El={}; function El:Set(v)Set(v)end; function El:Get()return active end
                function El:Lock()c2.Locked=true end; function El:Unlock()c2.Locked=false end; return El
            else
                track=Instance.new("TextButton",card)
                track.Size=UDim2.new(0,38,0,20); track.Position=UDim2.new(1,-52,0.5,0)
                track.AnchorPoint=Vector2.new(0,0.5); track.BackgroundColor3=active and TH().Toggle or TH().ToggleOff
                track.Text=""; track.AutoButtonColor=false; track.ZIndex=card.ZIndex+2; corner(track,10)
                sw.track=track; table.insert(_reg.switches,sw)
                knob=frame(track,"Knob",UDim2.new(0,14,0,14),active and UDim2.new(1,-16,0.5,0) or UDim2.new(0,2,0.5,0),Color3.fromRGB(234,236,255),0,card.ZIndex+3)
                knob.AnchorPoint=Vector2.new(0,0.5); corner(knob,7)
                local function Set(v)
                    active=v; sw.active=v
                    tw(track,{BackgroundColor3=v and TH().Toggle or TH().ToggleOff})
                    tw(knob,{Position=v and UDim2.new(1,-16,0.5,0) or UDim2.new(0,2,0.5,0)})
                    if c2.Flag and MeyyHub.Flags[c2.Flag] then MeyyHub.Flags[c2.Flag].Value=v end
                    if c2.Callback then c2.Callback(v) end
                    if not MeyyHub.IsLoading then MeyyHub:SaveConfig("AutoSave",true) end
                end
                if c2.Flag then MeyyHub.Flags[c2.Flag]={Value=active,Set=Set} end
                track.MouseButton1Click:Connect(function() if not c2.Locked then Set(not active) end end)
                local El={}; function El:Set(v)Set(v)end; function El:Get()return active end
                function El:Lock()c2.Locked=true end; function El:Unlock()c2.Locked=false end; return El
            end
        end

        function Tab:Slider(c2)
            c2=c2 or {}
            local vc=c2.Value or {}
            local minV=vc.Min or 0; local maxV=vc.Max or 100; local defV=vc.Default or 50
            local step=c2.Step or 1; local hasD=c2.Desc and c2.Desc~=""; local h=hasD and 70 or 56
            local card=makeCard(page,N(),h); local curVal=defV
            local tl=lbl(card,c2.Title or "",Enum.Font.GothamBold,13,TH().TextPri,Enum.TextXAlignment.Left,card.ZIndex+1)
            tl.Size=UDim2.new(0.62,0,0,24); tl.Position=UDim2.new(0,14,0,7); regText(tl,"TextPri")
            if hasD then
                local dl=lbl(card,c2.Desc,Enum.Font.Gotham,10,TH().TextSec,Enum.TextXAlignment.Left,card.ZIndex+1)
                dl.Size=UDim2.new(0.62,0,0,14); dl.Position=UDim2.new(0,14,0,26); regText(dl,"TextSec")
            end
            local inp=Instance.new("TextBox",card)
            inp.Size=UDim2.new(0,52,0,24); inp.Position=UDim2.new(1,-66,0,7)
            inp.BackgroundColor3=TH().Input; inp.BackgroundTransparency=0.22
            inp.Font=Enum.Font.GothamBold; inp.Text=tostring(defV); inp.TextColor3=TH().TextPri
            inp.TextSize=12; inp.ZIndex=card.ZIndex+3; inp.ClearTextOnFocus=false
            inp.TextXAlignment=Enum.TextXAlignment.Center; corner(inp,6)
            stroke(inp,1,TH().Stroke); regBg(inp,"Input"); regText(inp,"TextPri")
            local trackBg=frame(card,"Track",UDim2.new(1,-28,0,4),UDim2.new(0,14,0,h-14),TH().ToggleOff,0.16,card.ZIndex+1)
            corner(trackBg,3); regBg(trackBg,"ToggleOff")
            local fillBar=frame(trackBg,"Fill",UDim2.new(math.clamp((defV-minV)/(maxV-minV),0,1),0,1,0),UDim2.new(0,0,0,0),TH().Accent,0,trackBg.ZIndex+1)
            corner(fillBar,3); table.insert(_reg.fills,fillBar)
            local knob=Instance.new("TextButton",fillBar)
            knob.Size=UDim2.new(0,14,0,14); knob.Position=UDim2.new(1,0,0.5,0); knob.AnchorPoint=Vector2.new(0.5,0.5)
            knob.BackgroundColor3=Color3.fromRGB(240,242,255); knob.Text=""; knob.AutoButtonColor=false
            knob.ZIndex=trackBg.ZIndex+2; corner(knob,7)
            local function Set(v)
                v=math.clamp(math.floor(v/step+0.5)*step,minV,maxV); curVal=v
                local pct=(v-minV)/(maxV-minV)
                tw(fillBar,{Size=UDim2.new(pct,0,1,0)}); inp.Text=tostring(v)
                if c2.Flag and MeyyHub.Flags[c2.Flag] then MeyyHub.Flags[c2.Flag].Value=v end
                if c2.Callback then c2.Callback(v) end
            end
            if c2.Flag then MeyyHub.Flags[c2.Flag]={Value=defV,Set=Set} end
            local function fromX(i)
                local pct=math.clamp((i.Position.X-trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)
                Set(minV+(maxV-minV)*pct)
            end
            local slid=false
            knob.MouseButton1Down:Connect(function() slid=true end)
            trackBg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then fromX(i) end end)
            local cSl=UserInput.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 and slid then
                    slid=false; if not MeyyHub.IsLoading then MeyyHub:SaveConfig("AutoSave",true) end
                end
            end)
            local cSlM=UserInput.InputChanged:Connect(function(i)
                if slid and i.UserInputType==Enum.UserInputType.MouseMovement then fromX(i) end
            end)
            table.insert(self._conns,cSl); table.insert(self._conns,cSlM)
            inp.FocusLost:Connect(function()
                Set(tonumber(inp.Text) or curVal)
                if not MeyyHub.IsLoading then MeyyHub:SaveConfig("AutoSave",true) end
            end)
            local El={}; function El:Set(v)Set(v)end; function El:Get()return curVal end; return El
        end


        function Tab:Input(c2)
            c2=c2 or {}
            local isArea=c2.Type=="Textarea"; local hasD=c2.Desc and c2.Desc~=""
            local h=isArea and (hasD and 102 or 88) or (hasD and 56 or 42)
            local card=makeCard(page,N(),h)
            local tl=lbl(card,c2.Title or "Input",Enum.Font.GothamBold,13,TH().TextPri,Enum.TextXAlignment.Left,card.ZIndex+1)
            tl.Size=UDim2.new(0.42,0,0,isArea and h or 42); tl.Position=UDim2.new(0,14,0,0); regText(tl,"TextPri")
            if hasD then
                local dl=lbl(card,c2.Desc,Enum.Font.Gotham,10,TH().TextSec,Enum.TextXAlignment.Left,card.ZIndex+1)
                dl.Size=UDim2.new(0.42,0,0,14); dl.Position=UDim2.new(0,14,0,26); regText(dl,"TextSec")
            end
            local ib=Instance.new("TextBox",card)
            ib.Size=UDim2.new(0,206,0,isArea and (h-12) or 28); ib.Position=UDim2.new(1,-220,0.5,0)
            ib.AnchorPoint=Vector2.new(0,0.5); ib.BackgroundColor3=TH().Input; ib.BackgroundTransparency=0.18
            ib.Font=Enum.Font.Gotham; ib.Text=c2.Value or ""; ib.PlaceholderText=c2.Placeholder or "Type here..."
            ib.PlaceholderColor3=TH().TextDim; ib.TextColor3=TH().TextPri; ib.TextSize=12
            ib.ZIndex=card.ZIndex+2; ib.TextWrapped=isArea; ib.MultiLine=isArea
            ib.TextXAlignment=Enum.TextXAlignment.Left; ib.ClearTextOnFocus=false
            corner(ib,6); stroke(ib,1,TH().Stroke); pad(ib,8,8,4,4)
            regBg(ib,"Input"); regText(ib,"TextPri")
            ib.Focused:Connect(function() tw(ib,{BackgroundTransparency=0.04}) end)
            ib.FocusLost:Connect(function()
                tw(ib,{BackgroundTransparency=0.18})
                if c2.Flag and MeyyHub.Flags[c2.Flag] then MeyyHub.Flags[c2.Flag].Value=ib.Text end
                if c2.Callback then c2.Callback(ib.Text) end
                if not MeyyHub.IsLoading then MeyyHub:SaveConfig("AutoSave",true) end
            end)
            if c2.Flag then MeyyHub.Flags[c2.Flag]={Value=c2.Value or "",Set=function(v)ib.Text=v end} end
            local El={}; function El:Set(v)ib.Text=v end; function El:Get()return ib.Text end
            function El:Lock()ib.TextEditable=false end; function El:Unlock()ib.TextEditable=true end; return El
        end

        function Tab:Keybind(c2)
            c2=c2 or {}
            local card=makeCard(page,N(),42); local curKey=c2.Value or "None"; local isListen=false
            local tl=lbl(card,c2.Title or "Keybind",Enum.Font.GothamBold,13,TH().TextPri,Enum.TextXAlignment.Left,card.ZIndex+1)
            tl.Size=UDim2.new(0.56,0,1,0); tl.Position=UDim2.new(0,14,0,0); regText(tl,"TextPri")
            local kb=Instance.new("TextButton",card)
            kb.Size=UDim2.new(0,96,0,28); kb.Position=UDim2.new(1,-110,0.5,0); kb.AnchorPoint=Vector2.new(0,0.5)
            kb.BackgroundColor3=TH().Input; kb.BackgroundTransparency=0.22
            kb.Font=Enum.Font.GothamBold; kb.Text=curKey; kb.TextColor3=TH().Accent
            kb.TextSize=11; kb.ZIndex=card.ZIndex+2; kb.AutoButtonColor=false; corner(kb,6)
            local kbS=stroke(kb,1,TH().Accent); kbS.Transparency=0.46
            regBg(kb,"Input"); regAccent(kbS,"Color")
            kb.MouseButton1Click:Connect(function()
                if isListen then return end; isListen=true; kb.Text="..."; kb.TextColor3=TH().TextSec
                local cKB; cKB=UserInput.InputBegan:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.Keyboard then
                        isListen=false; cKB:Disconnect()
                        curKey=tostring(i.KeyCode):gsub("Enum%.KeyCode%.",""); kb.Text=curKey; kb.TextColor3=TH().Accent
                        if c2.Flag and MeyyHub.Flags[c2.Flag] then MeyyHub.Flags[c2.Flag].Value=curKey end
                        if c2.Callback then c2.Callback(curKey) end
                        if not MeyyHub.IsLoading then MeyyHub:SaveConfig("AutoSave",true) end
                    end
                end)
            end)
            if c2.Flag then MeyyHub.Flags[c2.Flag]={Value=curKey,Set=function(v)curKey=v;kb.Text=v end} end
            local El={}; function El:Get()return curKey end; return El
        end

        function Tab:Dropdown(c2)
            c2=c2 or {}
            local isMulti=c2.Multi==true; local vals=c2.Values or {}; local isOpen=false; local selected
            local outer=frame(page,"DropOuter",UDim2.new(1,-2,0,42),UDim2.new(0,0,0,0),TH().Card,1,page.ZIndex or 4)
            outer.LayoutOrder=N(); outer.ClipsDescendants=false
            local card=makeCard(outer,0,42); card.Size=UDim2.new(1,0,0,42); card.LayoutOrder=0
            local tl=lbl(card,c2.Title or "Dropdown",Enum.Font.GothamBold,13,TH().TextPri,Enum.TextXAlignment.Left,card.ZIndex+1)
            tl.Size=UDim2.new(0.5,0,1,0); tl.Position=UDim2.new(0,14,0,0); regText(tl,"TextPri")
            local dBtn=Instance.new("TextButton",card)
            dBtn.Size=UDim2.new(0,136,0,28); dBtn.Position=UDim2.new(1,-150,0.5,0); dBtn.AnchorPoint=Vector2.new(0,0.5)
            dBtn.BackgroundColor3=TH().Input; dBtn.BackgroundTransparency=0.18
            dBtn.Font=Enum.Font.Gotham; dBtn.TextColor3=TH().TextPri; dBtn.TextSize=11
            dBtn.TextTruncate=Enum.TextTruncate.AtEnd; dBtn.TextXAlignment=Enum.TextXAlignment.Left
            dBtn.AutoButtonColor=false; dBtn.ZIndex=card.ZIndex+2; corner(dBtn,6)
            stroke(dBtn,1,TH().Stroke); pad(dBtn,8,22,0,0); regBg(dBtn,"Input")
            local arrow=lbl(dBtn,"▾",Enum.Font.GothamBold,10,TH().TextSec,Enum.TextXAlignment.Center,dBtn.ZIndex+1)
            arrow.Size=UDim2.new(0,18,1,0); arrow.Position=UDim2.new(1,-18,0,0); arrow.TextTruncate=Enum.TextTruncate.None
            local dList=scrollFrame(outer,"DList",UDim2.new(1,0,0,0),UDim2.new(0,0,0,46),30)
            dList.BackgroundColor3=TH().Card; dList.BackgroundTransparency=0.04
            dList.Visible=false; dList.ClipsDescendants=true; corner(dList,8)
            local dls=stroke(dList,1,TH().Accent); dls.Transparency=0.50
            pad(dList,4,4,4,4); listLayout(dList,2,Enum.HorizontalAlignment.Center); regBg(dList,"Card")
            local function initSel()
                if isMulti then selected={}
                    if type(c2.Value)=="table" then for _,v in ipairs(c2.Value) do selected[v]=true end end
                else
                    local dv=c2.Value
                    if type(dv)=="number" and vals[dv] then local v=vals[dv]; selected=type(v)=="table" and v.Title or v
                    elseif type(dv)=="string" then selected=dv
                    else local v=vals[1]; selected=v and (type(v)=="table" and v.Title or v) or "Select..." end
                end
            end
            initSel()
            local function getText()
                if isMulti then
                    local names={}; for k in pairs(selected) do table.insert(names,k) end; table.sort(names)
                    if #names==0 then return "None" end; if #names==1 then return names[1] end
                    return "("..#names.." selected)"
                else return type(selected)=="table" and selected.Title or tostring(selected or "Select...") end
            end
            dBtn.Text=getText()
            local optBtns={}
            local function refreshList()
                for _,ob in ipairs(optBtns) do pcall(function()ob:Destroy()end) end; optBtns={}
                for _,val in ipairs(vals) do
                    if type(val)=="table" and val.Type=="Divider" then
                        local div=frame(dList,"D",UDim2.new(1,-8,0,1),UDim2.new(0,4,0,0),TH().Divider,0,31)
                        table.insert(optBtns,div)
                    else
                        local optTitle=type(val)=="table" and val.Title or tostring(val)
                        local isSel=isMulti and (selected[optTitle]==true) or (selected==optTitle or (type(selected)=="table" and selected.Title==optTitle))
                        local ob=Instance.new("TextButton",dList)
                        ob.Size=UDim2.new(1,-4,0,30); ob.BackgroundColor3=TH().CardHover
                        ob.BackgroundTransparency=isSel and 0.36 or 0.84
                        ob.Font=Enum.Font.Gotham; ob.Text=optTitle
                        ob.TextColor3=isSel and TH().Accent or TH().TextPri
                        ob.TextSize=12; ob.TextXAlignment=Enum.TextXAlignment.Left
                        ob.AutoButtonColor=false; ob.ZIndex=31; corner(ob,6); pad(ob,10,10,0,0)
                        regBg(ob,"CardHover")
                        ob.MouseEnter:Connect(function() tw(ob,{BackgroundTransparency=isSel and 0.22 or 0.62}) end)
                        ob.MouseLeave:Connect(function() tw(ob,{BackgroundTransparency=isSel and 0.36 or 0.84}) end)
                        ob.MouseButton1Click:Connect(function()
                            if isMulti then
                                isSel=not isSel; selected[optTitle]=isSel or nil
                                ob.BackgroundTransparency=isSel and 0.36 or 0.84
                                ob.TextColor3=isSel and TH().Accent or TH().TextPri; dBtn.Text=getText()
                                if c2.Flag and MeyyHub.Flags[c2.Flag] then
                                    local arr={}; for k in pairs(selected) do table.insert(arr,k) end
                                    MeyyHub.Flags[c2.Flag].Value=arr
                                end
                                if c2.Callback then local arr={}; for k in pairs(selected) do table.insert(arr,k) end; c2.Callback(arr) end
                            else
                                selected=type(val)=="table" and val or optTitle; dBtn.Text=optTitle; isOpen=false
                                tw(outer,{Size=UDim2.new(1,-2,0,42)},0.18); tw(arrow,{Rotation=0},0.18)
                                task.delay(0.2,function()dList.Visible=false end)
                                if c2.Flag and MeyyHub.Flags[c2.Flag] then MeyyHub.Flags[c2.Flag].Value=optTitle end
                                if c2.Callback then c2.Callback(type(val)=="table" and val or optTitle) end
                            end
                            if not MeyyHub.IsLoading then MeyyHub:SaveConfig("AutoSave",true) end
                        end)
                        table.insert(optBtns,ob)
                    end
                end
            end
            refreshList()
            dBtn.MouseButton1Click:Connect(function()
                isOpen=not isOpen
                local tH=isOpen and math.min(#vals*32+12,170) or 0
                if isOpen then dList.Visible=true end
                tw(outer,{Size=UDim2.new(1,-2,0,42+tH+4)},0.2); tw(arrow,{Rotation=isOpen and 180 or 0},0.2)
                if not isOpen then task.delay(0.22,function()dList.Visible=false end) end
            end)
            if c2.Flag then
                MeyyHub.Flags[c2.Flag]={Value=isMulti and {} or getText(),Set=function(v)
                    if isMulti then selected={}; if type(v)=="table" then for _,k in ipairs(v) do selected[k]=true end end
                    else selected=v end; dBtn.Text=getText(); refreshList()
                end}
            end
            local El={}
            function El:Refresh(nv) vals=nv; refreshList() end
            function El:Get() if isMulti then local a={}; for k in pairs(selected) do table.insert(a,k) end; return a else return selected end end
            function El:Lock() dBtn.Active=false end; function El:Unlock() dBtn.Active=true end; return El
        end

        function Tab:Colorpicker(c2)
            c2=c2 or {}
            local current=c2.Default or Color3.fromRGB(255,255,255); local isOpen2=false; local hue=0
            local card=makeCard(page,N(),42)
            local tl=lbl(card,c2.Title or "Color",Enum.Font.GothamBold,13,TH().TextPri,Enum.TextXAlignment.Left,card.ZIndex+1)
            tl.Size=UDim2.new(0.58,0,1,0); tl.Position=UDim2.new(0,14,0,0); regText(tl,"TextPri")
            local hexL=lbl(card,"#"..string.format("%02X%02X%02X",math.floor(current.R*255),math.floor(current.G*255),math.floor(current.B*255)),
                Enum.Font.Gotham,10,TH().TextSec,Enum.TextXAlignment.Left,card.ZIndex+1)
            hexL.Size=UDim2.new(0,60,0,16); hexL.Position=UDim2.new(1,-140,0.5,0); hexL.AnchorPoint=Vector2.new(0,0.5)
            local preview=Instance.new("TextButton",card)
            preview.Size=UDim2.new(0,60,0,26); preview.Position=UDim2.new(1,-74,0.5,0); preview.AnchorPoint=Vector2.new(0,0.5)
            preview.BackgroundColor3=current; preview.Text=""; preview.AutoButtonColor=false; preview.ZIndex=card.ZIndex+2; corner(preview,6)
            stroke(preview,1.5,TH().Stroke)
            local picker=frame(card,"Picker",UDim2.new(1,-2,0,0),UDim2.new(0,1,1,4),TH().Card,0.04,card.ZIndex+10)
            picker.Visible=false; corner(picker,8); stroke(picker,1,TH().Accent)
            listLayout(picker,6); pad(picker,10,10,10,10); regBg(picker,"Card")
            local hueBar=frame(picker,"Hue",UDim2.new(1,0,0,12),UDim2.new(0,0,0,0),Color3.new(1,0,0),0,picker.ZIndex+1)
            hueBar.LayoutOrder=1; corner(hueBar,4)
            local hueGrad=Instance.new("UIGradient",hueBar)
            hueGrad.Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),ColorSequenceKeypoint.new(0.167,Color3.fromRGB(255,255,0)),
                ColorSequenceKeypoint.new(0.333,Color3.fromRGB(0,255,0)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),
                ColorSequenceKeypoint.new(0.667,Color3.fromRGB(0,0,255)),ColorSequenceKeypoint.new(0.833,Color3.fromRGB(255,0,255)),
                ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0)),
            })
            local hKnob=frame(hueBar,"HK",UDim2.new(0,10,0,10),UDim2.new(0,0,0.5,0),Color3.new(1,1,1),0,hueBar.ZIndex+1)
            hKnob.AnchorPoint=Vector2.new(0.5,0.5); corner(hKnob,5); stroke(hKnob,1.5,Color3.new(0,0,0))
            local hexBox=Instance.new("TextBox",picker); hexBox.LayoutOrder=2
            hexBox.Size=UDim2.new(1,0,0,28); hexBox.BackgroundColor3=TH().Input; hexBox.BackgroundTransparency=0.2
            hexBox.Font=Enum.Font.GothamBold; hexBox.Text="#"..string.format("%02X%02X%02X",math.floor(current.R*255),math.floor(current.G*255),math.floor(current.B*255))
            hexBox.TextColor3=TH().TextPri; hexBox.TextSize=12; hexBox.ZIndex=picker.ZIndex+1
            hexBox.ClearTextOnFocus=false; hexBox.TextXAlignment=Enum.TextXAlignment.Center
            corner(hexBox,5); stroke(hexBox,1,TH().Stroke); pad(hexBox,8,0,0,0); regBg(hexBox,"Input"); regText(hexBox,"TextPri")
            local function updateColor(col)
                current=col; preview.BackgroundColor3=col
                local hx=string.format("%02X%02X%02X",math.floor(col.R*255),math.floor(col.G*255),math.floor(col.B*255))
                hexL.Text="#"..hx; hexBox.Text="#"..hx
                if c2.Flag and MeyyHub.Flags[c2.Flag] then MeyyHub.Flags[c2.Flag].Value=col end
                if c2.Callback then c2.Callback(col) end
                if not MeyyHub.IsLoading then MeyyHub:SaveConfig("AutoSave",true) end
            end
            local hDrag=false
            hueBar.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then
                    hDrag=true; local p=math.clamp((i.Position.X-hueBar.AbsolutePosition.X)/hueBar.AbsoluteSize.X,0,1)
                    hue=p; hKnob.Position=UDim2.new(p,0,0.5,0); updateColor(Color3.fromHSV(hue,1,1))
                end
            end)
            local cH1=UserInput.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then hDrag=false end end)
            local cH2=UserInput.InputChanged:Connect(function(i)
                if hDrag and i.UserInputType==Enum.UserInputType.MouseMovement then
                    local p=math.clamp((i.Position.X-hueBar.AbsolutePosition.X)/hueBar.AbsoluteSize.X,0,1)
                    hue=p; hKnob.Position=UDim2.new(p,0,0.5,0); updateColor(Color3.fromHSV(hue,1,1))
                end
            end)
            table.insert(self._conns,cH1); table.insert(self._conns,cH2)
            hexBox.FocusLost:Connect(function()
                local hx=hexBox.Text:gsub("#",""):gsub("%s","")
                if #hx==6 then
                    updateColor(Color3.fromRGB(tonumber("0x"..hx:sub(1,2)) or 255,tonumber("0x"..hx:sub(3,4)) or 255,tonumber("0x"..hx:sub(5,6)) or 255))
                end
            end)
            preview.MouseButton1Click:Connect(function()
                isOpen2=not isOpen2; picker.Visible=isOpen2
                if isOpen2 then tw(picker,{Size=UDim2.new(1,-2,0,96)},0.2)
                else tw(picker,{Size=UDim2.new(1,-2,0,0)},0.2); task.delay(0.22,function()picker.Visible=false end) end
            end)
            if c2.Flag then MeyyHub.Flags[c2.Flag]={Value=current,Set=updateColor} end
            local El={}; function El:Set(v)updateColor(v)end; function El:Get()return current end; return El
        end
    end -- end buildElements


    -- ============================================================
    -- WINDOW TAB API
    -- ============================================================
    local tabObjects={}; local pageObjects={}; local tabLO=0

    local function makePage(name, active)
        local pg=scrollFrame(ContentArea,name.."_Page",UDim2.new(1,0,1,0),UDim2.new(0,0,0,0),4)
        pg.Visible=active; pad(pg,14,18,10,28); listLayout(pg,7)
        return pg
    end

    local Window={}

    function Window:Tab(c2)
        c2=c2 or {}
        local isFirst=#tabObjects==0
        local btn=Instance.new("TextButton",TabScroll)
        btn.LayoutOrder=tabLO; tabLO=tabLO+1
        btn.Size=UDim2.new(1,-10,0,35); btn.BackgroundTransparency=1
        btn.Font=Enum.Font.GothamMedium; btn.Text="  "..(c2.Title or "Tab")
        btn.TextColor3=TH().TextSec; btn.TextSize=13; btn.TextXAlignment=Enum.TextXAlignment.Left
        btn.AutoButtonColor=false; btn.ZIndex=6; regText(btn,"TextSec")
        local ind=frame(btn,"Ind",UDim2.new(0,3,0,18),UDim2.new(0,6,0.5,0),TH().Accent,0,7)
        ind.AnchorPoint=Vector2.new(0,0.5); corner(ind,2); ind.Visible=isFirst; regAccent(ind,"BackgroundColor3")
        table.insert(tabObjects,{btn=btn,ind=ind})
        local page=makePage(c2.Title or "Tab",isFirst); table.insert(pageObjects,page)
        btn.MouseEnter:Connect(function()
            if not ind.Visible then tw(btn,{BackgroundTransparency=0.88,TextColor3=TH().TextPri}) end
        end)
        btn.MouseLeave:Connect(function()
            if not ind.Visible then tw(btn,{BackgroundTransparency=1,TextColor3=TH().TextSec}) end
        end)
        btn.MouseButton1Click:Connect(function()
            for _,p in ipairs(pageObjects) do p.Visible=false end
            for _,tb in ipairs(tabObjects) do tb.ind.Visible=false; tw(tb.btn,{TextColor3=TH().TextSec}) end
            page.Visible=true; ind.Visible=true; tw(btn,{TextColor3=TH().TextPri})
        end)
        local Tab={}; buildElements(Tab,page); return Tab
    end

    function Window:CreateTab(name, isFirstPage)
        local tab=Window:Tab({Title=name})
        if isFirstPage then
            for _,p in ipairs(pageObjects) do p.Visible=false end
            for _,tb in ipairs(tabObjects) do tb.ind.Visible=false end
            local pg=pageObjects[#pageObjects]; local tb=tabObjects[#tabObjects]
            if pg then pg.Visible=true end; if tb then tb.ind.Visible=true end
        end
        return tab
    end

    function Window:Section(c2)
        c2=c2 or {}
        local sec=Instance.new("TextButton",TabScroll)
        sec.LayoutOrder=tabLO; tabLO=tabLO+1; sec.Size=UDim2.new(1,-10,0,22)
        sec.BackgroundTransparency=1; sec.Font=Enum.Font.GothamBold
        sec.Text=(c2.Title or ""):upper(); sec.TextColor3=TH().TextDim
        sec.TextSize=9; sec.TextXAlignment=Enum.TextXAlignment.Left
        sec.AutoButtonColor=false; sec.ZIndex=6; pad(sec,6,0,0,0); regText(sec,"TextDim")
    end

    function Window:Divider()
        local div=frame(TabScroll,"Div",UDim2.new(1,-10,0,1),UDim2.new(0,0,0,0),TH().Divider,0,6)
        div.LayoutOrder=tabLO; tabLO=tabLO+1; regBg(div,"Divider")
    end

    function Window:Dialog(c2) showDialog(c2) end

    function Window:Open()
        isHidden=false; Win.Visible=true
        tw(Win,{Size=normalSize,Position=normalPos},0.45,Enum.EasingStyle.Back); syncShadow(true)
    end

    function Window:Close()
        isHidden=true; syncShadow(false)
        tw(Win,{Size=UDim2.new(0,0,0,0)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In)
        task.delay(0.32,function()Win.Visible=false end)
    end

    function Window:Toggle() toggleUI() end

    function Window:Destroy()
        tw(Win,{Size=UDim2.new(0,0,0,0)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In)
        task.delay(0.35,function()
            for _,c in ipairs(MeyyHub._conns) do pcall(function()c:Disconnect()end) end
            Root:Destroy(); MeyyHub._window=nil
        end)
    end

    function Window:SetTitle(t) titleLbl.Text=t end
    function Window:SetToggleKey(k) MinKey=k end

    function Window:ApplyTheme(name)
        local n=normalizeTheme(name)
        if n then applyTheme(n); MeyyHub:Notify({Title="Theme",Content="Applied: "..n}) end
    end

    -- Built-in Settings Tab
    local SettingsTab=Window:Tab({Title="⚙ Settings"})
    local lastEntry=tabObjects[#tabObjects]
    if lastEntry then lastEntry.btn.LayoutOrder=99999 end

    SettingsTab:Dropdown({
        Flag="__MeyyHub_Theme", Title="Theme",
        Values={"Dark","Moonlight","Rose","Ocean","Emerald","Violet","Amber"},
        Value=currentTheme,
        Callback=function(v)
            local name=type(v)=="table" and v.Title or v
            applyTheme(name); MeyyHub:Notify({Title="Theme",Content="Applied: "..name})
        end,
    })
    local kStr=tostring(MinKey):gsub("Enum%.KeyCode%.","")
    SettingsTab:Paragraph({Title="Toggle Key", Content=kStr.." — toggle UI visibility"})
    SettingsTab:Space()
    SettingsTab:Button({Title="Save Config",  Callback=function()MeyyHub:SaveConfig("ManualSave")end})
    SettingsTab:Button({Title="Load Config",  Callback=function()MeyyHub:LoadConfig("ManualSave")end})

    -- Open animation
    Win.Size=UDim2.new(0,0,0,0)
    TweenService:Create(Win,TweenInfo.new(0.6,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=normalSize}):Play()
    task.spawn(function() task.wait(1.5); MeyyHub:LoadConfig("AutoSave",true) end)
    MeyyHub:Notify({Title="MeyyHub v"..MeyyHub.Version, Content="Ready — "..(cfg.Title or "MeyyHub")})
    self._window=Window
    return Window
end

return MeyyHub
