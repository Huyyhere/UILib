local RunService   = game:GetService("RunService")
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Library = {}

local THEME = {
    Bg01    = Color3.fromHex("#080812"),
    Bg02    = Color3.fromHex("#0E0E1E"),
    Bg03    = Color3.fromHex("#16162A"),
    Text01  = Color3.fromHex("#F0F0FF"),
    Text02  = Color3.fromHex("#6868A0"),
    Text03  = Color3.fromHex("#303050"),
    Stroke  = Color3.fromHex("#1E1E38"),
    Green   = Color3.fromHex("#00E5A0"),
    Blue    = Color3.fromHex("#7B8CFF"),
    Purple  = Color3.fromHex("#A78BFF"),
    Red     = Color3.fromHex("#FF4D6D"),
    StrokeSeq = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromHex("#1A1A35")),
        ColorSequenceKeypoint.new(0.25, Color3.fromHex("#7B8CFF")),
        ColorSequenceKeypoint.new(0.5,  Color3.fromHex("#A78BFF")),
        ColorSequenceKeypoint.new(0.75, Color3.fromHex("#7B8CFF")),
        ColorSequenceKeypoint.new(1,    Color3.fromHex("#1A1A35")),
    }),
}

local function tween(obj, t, props)
    return TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Sine), props)
end

function Library:CreateLoader(config)
    config = config or {}
    local gameName  = config.GameName  or "Unknown Game"
    local scriptRaw = config.ScriptRaw or ""
    local version   = config.Version   or ""
    local duration  = config.Duration  or 3.0
    local accent    = config.Accent    or THEME.Blue
    local onError   = config.OnError   or function(e) warn("[Meyy Hub]:", e) end
    local steps     = config.Steps or {
        { at = 0.00, text = "Initializing"           },
        { at = 0.22, text = "Checking configuration" },
        { at = 0.50, text = "Downloading script"     },
        { at = 0.80, text = "Opening interface"      },
    }

    local old = CoreGui:FindFirstChild("MeyyHubLoader")
    if old then old:Destroy() end

    local rotGrads = {}
    local W, H = 380, 160

    local gui = Instance.new("ScreenGui")
    gui.Name           = "MeyyHubLoader"
    gui.ResetOnSpawn   = false
    gui.IgnoreGuiInset = true
    gui.Parent         = CoreGui

    local frame = Instance.new("Frame", gui)
    frame.AnchorPoint            = Vector2.new(0.5, 0.5)
    frame.Position               = UDim2.new(0.5, 0, 0.5, 0)
    frame.Size                   = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3       = THEME.Bg01
    frame.BorderSizePixel        = 0
    frame.ClipsDescendants       = true
    frame.ZIndex                 = 10
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)

    local glass = Instance.new("Frame", frame)
    glass.Size               = UDim2.new(1, 0, 1, 0)
    glass.BackgroundColor3   = Color3.fromHex("#FFFFFF")
    glass.BackgroundTransparency = 0.97
    glass.BorderSizePixel    = 0
    glass.ZIndex             = 1

    local cardGrad = Instance.new("UIGradient", frame)
    cardGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#000000")),
    })
    cardGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.96),
        NumberSequenceKeypoint.new(1,   0.995),
    })
    cardGrad.Rotation = 45

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color     = THEME.Stroke
    stroke.Thickness = 1

    local gradStroke = Instance.new("UIStroke", frame)
    gradStroke.Thickness = 1.5
    gradStroke.Transparency = 0.3
    local gradStrokeGrad = Instance.new("UIGradient", gradStroke)
    gradStrokeGrad.Color = THEME.StrokeSeq
    table.insert(rotGrads, gradStrokeGrad)

    local innerGlow = Instance.new("Frame", frame)
    innerGlow.Size               = UDim2.new(1, -2, 1, -2)
    innerGlow.Position           = UDim2.new(0, 1, 0, 1)
    innerGlow.BackgroundColor3   = Color3.fromHex("#FFFFFF")
    innerGlow.BackgroundTransparency = 0.98
    innerGlow.BorderSizePixel    = 0
    innerGlow.ZIndex             = 2
    Instance.new("UICorner", innerGlow).CornerRadius = UDim.new(0, 19)

    local accentLine = Instance.new("Frame", frame)
    accentLine.Size               = UDim2.new(0.5, 0, 0, 2)
    accentLine.Position           = UDim2.new(0.25, 0, 0, 0)
    accentLine.BackgroundColor3   = accent
    accentLine.BorderSizePixel    = 0
    accentLine.ZIndex             = 20
    local alGrad = Instance.new("UIGradient", accentLine)
    alGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#000000")),
        ColorSequenceKeypoint.new(0.5, accent),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#000000")),
    })

    local PAD = 28
    local cx = Instance.new("Frame", frame)
    cx.Size               = UDim2.new(1, -(PAD * 2), 1, -(PAD * 2))
    cx.Position           = UDim2.new(0, PAD, 0, PAD + 4)
    cx.BackgroundTransparency = 1
    cx.ZIndex             = 11

    local dots = {}
    for i = 1, 3 do
        local d = Instance.new("Frame", cx)
        d.Size             = UDim2.new(0, 6, 0, 6)
        d.Position         = UDim2.new(0, (i - 1) * 14, 0, 0)
        d.BackgroundColor3 = accent
        d.BorderSizePixel  = 0
        d.ZIndex           = 12
        Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
        dots[i] = d

        local g = Instance.new("Frame", d)
        g.Size               = UDim2.new(2.5, 0, 2.5, 0)
        g.Position           = UDim2.new(-0.75, 0, -0.75, 0)
        g.BackgroundColor3   = accent
        g.BackgroundTransparency = 0.65
        g.BorderSizePixel    = 0
        g.ZIndex             = 11
        Instance.new("UICorner", g).CornerRadius = UDim.new(1, 0)

        task.spawn(function()
            local ds = Instance.new("UIScale", d)
            local gt = g
            while d and d.Parent do
                tween(ds, 0.5, {Scale = 1.6}):Play()
                if gt and gt.Parent then
                    tween(gt, 0.5, {BackgroundTransparency = 0.4}):Play()
                end
                task.wait(0.5)
                tween(ds, 0.5, {Scale = 1}):Play()
                if gt and gt.Parent then
                    tween(gt, 0.5, {BackgroundTransparency = 0.65}):Play()
                end
                task.wait(0.5)
            end
        end)
        if i > 1 then
            task.spawn(function()
                while true do
                    task.wait((i - 1) * 0.18)
                    if not dots[i] or not dots[i].Parent then break end
                    break
                end
            end)
            local delay = task.spawn(function() end)
        end
    end

    local statusLabel = Instance.new("TextLabel", cx)
    statusLabel.Size               = UDim2.new(1, 0, 0, 20)
    statusLabel.Position           = UDim2.new(0, 0, 0, 20)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font               = Enum.Font.Gotham
    statusLabel.Text               = "Initializing"
    statusLabel.TextSize           = 13
    statusLabel.TextColor3         = THEME.Text02
    statusLabel.TextXAlignment     = Enum.TextXAlignment.Left
    statusLabel.ZIndex             = 12

    local barTrack = Instance.new("Frame", cx)
    barTrack.Size             = UDim2.new(1, 0, 0, 3)
    barTrack.Position         = UDim2.new(0, 0, 0, 52)
    barTrack.BackgroundColor3 = Color3.fromHex("#181830")
    barTrack.BorderSizePixel  = 0
    barTrack.ZIndex           = 11
    Instance.new("UICorner", barTrack).CornerRadius = UDim.new(1, 0)

    local barFill = Instance.new("Frame", barTrack)
    barFill.Size             = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = accent
    barFill.BorderSizePixel  = 0
    barFill.ZIndex           = 12
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

    local barGlow = Instance.new("Frame", barTrack)
    barGlow.Size             = UDim2.new(0, 0, 1, 10)
    barGlow.Position         = UDim2.new(0, 0, 0, -5)
    barGlow.BackgroundColor3 = accent
    barGlow.BackgroundTransparency = 0.85
    barGlow.BorderSizePixel  = 0
    barGlow.ZIndex           = 10
    Instance.new("UICorner", barGlow).CornerRadius = UDim.new(1, 0)

    local pctLabel = Instance.new("TextLabel", cx)
    pctLabel.Size               = UDim2.new(0, 50, 0, 16)
    pctLabel.Position           = UDim2.new(1, -50, 0, 36)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Font               = Enum.Font.GothamBold
    pctLabel.Text               = "0%"
    pctLabel.TextSize           = 11
    pctLabel.TextColor3         = THEME.Text03
    pctLabel.TextXAlignment     = Enum.TextXAlignment.Right
    pctLabel.ZIndex             = 12

    local rot = 0
    local rotConn
    rotConn = RunService.RenderStepped:Connect(function()
        if not frame.Parent then rotConn:Disconnect() return end
        rot = (rot + 0.7) % 360
        for _, g in ipairs(rotGrads) do
            if g and g.Parent then g.Rotation = rot end
        end
    end)

    local function setStatus(text)
        tween(statusLabel, 0.12, {TextTransparency = 1}):Play()
        task.delay(0.06, function()
            if not statusLabel or not statusLabel.Parent then return end
            statusLabel.Text = text
            tween(statusLabel, 0.12, {TextTransparency = 0}):Play()
        end)
    end

    local lastPct = -1
    local function setPct(p)
        local n = math.floor(p * 100)
        if n ~= lastPct then
            lastPct = n
            pctLabel.Text = n .. "%"
            tween(pctLabel, 0.1, {TextColor3 = accent}):Play()
            task.delay(0.15, function()
                if not pctLabel or not pctLabel.Parent then return end
                tween(pctLabel, 0.2, {TextColor3 = THEME.Text03}):Play()
            end)
        end
        tween(barFill, 0.12, {Size = UDim2.new(p, 0, 1, 0)}):Play()
        tween(barGlow, 0.12, {Size = UDim2.new(p, 0, 1, 10)}):Play()
    end

    local function fadeOut(delay, cb)
        task.delay(delay, function()
            tween(frame, 0.35, {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, W, 0, 0),
            }):Play()
            tween(stroke, 0.35, {Thickness = 0}):Play()
            tween(gradStroke, 0.35, {Thickness = 0}):Play()
            task.wait(0.4)
            gui:Destroy()
            if cb then cb() end
        end)
    end

    TweenService:Create(frame,
        TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, W, 0, H) }
    ):Play()

    task.wait(0.65)

    setStatus("Loading" .. (gameName ~= "" and " " .. gameName or ""))

    task.wait(0.3)

    if scriptRaw == "" then
        setPct(1)
        setStatus("Ready")
        fadeOut(1.5)
        return
    end

    local startTime = tick()
    local stepIdx   = 0
    local conn

    conn = RunService.Heartbeat:Connect(function()
        local p = math.min((tick() - startTime) / duration, 1)
        setPct(p)

        for i = 1, #steps do
            if p >= steps[i].at and stepIdx < i then
                stepIdx = i
                setStatus(steps[i].text)
            end
        end

        if p >= 1 then
            conn:Disconnect()
            setStatus("Ready")
            fadeOut(0.9, function()
                local ok, err = pcall(function()
                    loadstring(game:HttpGet(scriptRaw, true))()
                end)
                if not ok then onError(err) end
            end)
        end
    end)
end

return Library
