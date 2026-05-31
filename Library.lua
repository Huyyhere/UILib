local RunService   = game:GetService("RunService")
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Library = {}

local THEME = {
    Bg      = Color3.fromHex("#0A0A14"),
    Surface = Color3.fromHex("#12121E"),
    Border  = Color3.fromHex("#1E1E32"),
    Text01  = Color3.fromHex("#EEEEFF"),
    Text02  = Color3.fromHex("#7A7AA8"),
    Text03  = Color3.fromHex("#44446A"),
    Green   = Color3.fromHex("#00D68F"),
    Blue    = Color3.fromHex("#6E7FFF"),
    Purple  = Color3.fromHex("#9D7FFF"),
    Red     = Color3.fromHex("#FF4060"),
    Seq     = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromHex("#1A1A30")),
        ColorSequenceKeypoint.new(0.25, Color3.fromHex("#6E7FFF")),
        ColorSequenceKeypoint.new(0.5,  Color3.fromHex("#9D7FFF")),
        ColorSequenceKeypoint.new(0.75, Color3.fromHex("#6E7FFF")),
        ColorSequenceKeypoint.new(1,    Color3.fromHex("#1A1A30")),
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
    local W, H = 420, 140

    local gui = Instance.new("ScreenGui")
    gui.Name           = "MeyyHubLoader"
    gui.ResetOnSpawn   = false
    gui.IgnoreGuiInset = true
    gui.Parent         = CoreGui

    local frame = Instance.new("Frame", gui)
    frame.AnchorPoint            = Vector2.new(0.5, 0.5)
    frame.Position               = UDim2.new(0.5, 0, 0.5, 0)
    frame.Size                   = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3       = THEME.Bg
    frame.BorderSizePixel        = 0
    frame.ClipsDescendants       = true
    frame.ZIndex                 = 10
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

    local gradient = Instance.new("UIGradient", frame)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#0F0F20")),
        ColorSequenceKeypoint.new(1,   THEME.Bg),
    })
    gradient.Rotation = 90

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color     = THEME.Border
    stroke.Thickness = 1

    local gstroke = Instance.new("UIStroke", frame)
    gstroke.Thickness = 1.5
    gstroke.Transparency = 0.45
    local ggrad = Instance.new("UIGradient", gstroke)
    ggrad.Color = THEME.Seq
    table.insert(rotGrads, ggrad)

    local PAD = 24
    local cx = Instance.new("Frame", frame)
    cx.Size               = UDim2.new(1, -(PAD * 2), 1, -(PAD * 2))
    cx.Position           = UDim2.new(0, PAD, 0, PAD)
    cx.BackgroundTransparency = 1
    cx.ZIndex             = 11

    local title = Instance.new("TextLabel", cx)
    title.Size               = UDim2.new(0, 0, 0, 24)
    title.BackgroundTransparency = 1
    title.Font               = Enum.Font.GothamBold
    title.Text               = "Meyy Hub"
    title.TextSize           = 18
    title.TextColor3         = THEME.Text01
    title.TextXAlignment     = Enum.TextXAlignment.Left
    title.ZIndex             = 12
    title.Size               = UDim2.new(0, title.TextBounds.X + 4, 0, 24)

    local dot = Instance.new("Frame", cx)
    dot.Size             = UDim2.new(0, 6, 0, 6)
    dot.Position         = UDim2.new(0, title.TextBounds.X + 12, 0.5, -3)
    dot.BackgroundColor3 = accent
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 13
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local dotGlow = Instance.new("Frame", dot)
    dotGlow.Size               = UDim2.new(3, 0, 3, 0)
    dotGlow.Position           = UDim2.new(-1, 0, -1, 0)
    dotGlow.BackgroundColor3   = accent
    dotGlow.BackgroundTransparency = 0.6
    dotGlow.BorderSizePixel    = 0
    dotGlow.ZIndex             = 12
    Instance.new("UICorner", dotGlow).CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        local ds = Instance.new("UIScale", dot)
        local dg = dotGlow
        while dot and dot.Parent do
            tween(ds, 0.6, {Scale = 1.5}):Play()
            if dg and dg.Parent then tween(dg, 0.6, {BackgroundTransparency = 0.4}):Play() end
            task.wait(0.6)
            tween(ds, 0.6, {Scale = 1}):Play()
            if dg and dg.Parent then tween(dg, 0.6, {BackgroundTransparency = 0.6}):Play() end
            task.wait(0.6)
        end
    end)

    local subtitle = Instance.new("TextLabel", cx)
    subtitle.Size               = UDim2.new(1, 0, 0, 16)
    subtitle.Position           = UDim2.new(0, 0, 0, 28)
    subtitle.BackgroundTransparency = 1
    subtitle.Font               = Enum.Font.Gotham
    subtitle.Text               = gameName
    subtitle.TextSize           = 12
    subtitle.TextColor3         = THEME.Text02
    subtitle.TextXAlignment     = Enum.TextXAlignment.Left
    subtitle.ZIndex             = 12

    if version ~= "" then
        local vtag = Instance.new("Frame", subtitle)
        local vl = Instance.new("TextLabel", vtag)
        vl.Size               = UDim2.new(1, -10, 1, 0)
        vl.Position           = UDim2.new(0, 5, 0, 0)
        vl.BackgroundTransparency = 1
        vl.Font               = Enum.Font.Gotham
        vl.Text               = version
        vl.TextSize           = 9
        vl.TextColor3         = THEME.Text02
        vl.TextXAlignment     = Enum.TextXAlignment.Center
        vl.ZIndex             = 14
        vtag.Size               = UDim2.new(0, vl.TextBounds.X + 14, 0, 18)
        vtag.Position           = UDim2.new(0, subtitle.TextBounds.X + 10, 0.5, -9)
        vtag.BackgroundColor3   = THEME.Surface
        vtag.BorderSizePixel    = 0
        vtag.ZIndex             = 13
        Instance.new("UICorner", vtag).CornerRadius = UDim.new(0, 5)
        local vb = Instance.new("UIStroke", vtag)
        vb.Color = THEME.Border
        vb.Thickness = 1
    end

    local barTrack = Instance.new("Frame", cx)
    barTrack.Size             = UDim2.new(1, 0, 0, 4)
    barTrack.Position         = UDim2.new(0, 0, 0, 60)
    barTrack.BackgroundColor3 = Color3.fromHex("#1A1A30")
    barTrack.BorderSizePixel  = 0
    barTrack.ZIndex           = 11
    Instance.new("UICorner", barTrack).CornerRadius = UDim.new(1, 0)

    local barFill = Instance.new("Frame", barTrack)
    barFill.Size             = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = accent
    barFill.BorderSizePixel  = 0
    barFill.ZIndex           = 12
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

    local bg = Instance.new("UIGradient", barFill)
    bg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    accent),
        ColorSequenceKeypoint.new(0.5,  Color3.fromHex("#C0CCFF")),
        ColorSequenceKeypoint.new(1,    Color3.fromHex("#FFFFFF")),
    })
    table.insert(rotGrads, bg)

    local barGlow = Instance.new("Frame", barTrack)
    barGlow.Size             = UDim2.new(0, 0, 1, 10)
    barGlow.Position         = UDim2.new(0, 0, 0, -5)
    barGlow.BackgroundColor3 = accent
    barGlow.BackgroundTransparency = 0.8
    barGlow.BorderSizePixel  = 0
    barGlow.ZIndex           = 10
    Instance.new("UICorner", barGlow).CornerRadius = UDim.new(1, 0)

    local statusLabel = Instance.new("TextLabel", cx)
    statusLabel.Size               = UDim2.new(1, -65, 0, 18)
    statusLabel.Position           = UDim2.new(0, 0, 0, 74)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font               = Enum.Font.Gotham
    statusLabel.Text               = "Initializing"
    statusLabel.TextSize           = 12
    statusLabel.TextColor3         = THEME.Text02
    statusLabel.TextXAlignment     = Enum.TextXAlignment.Left
    statusLabel.ZIndex             = 12

    local pctLabel = Instance.new("TextLabel", cx)
    pctLabel.Size               = UDim2.new(0, 60, 0, 18)
    pctLabel.Position           = UDim2.new(1, -60, 0, 74)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Font               = Enum.Font.GothamBold
    pctLabel.Text               = "0%"
    pctLabel.TextSize           = 12
    pctLabel.TextColor3         = accent
    pctLabel.TextXAlignment     = Enum.TextXAlignment.Right
    pctLabel.ZIndex             = 12

    local rot = 0
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not frame.Parent then conn:Disconnect() return end
        rot = (rot + 0.8) % 360
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
            tween(gstroke, 0.35, {Thickness = 0}):Play()
            task.wait(0.4)
            gui:Destroy()
            if cb then cb() end
        end)
    end

    TweenService:Create(frame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, W, 0, H) }
    ):Play()
    task.wait(0.6)

    if scriptRaw == "" then
        setPct(1)
        setStatus("Ready")
        fadeOut(1.5)
        return
    end

    local startTime = tick()
    local stepIdx   = 0
    local conn2

    conn2 = RunService.Heartbeat:Connect(function()
        local p = math.min((tick() - startTime) / duration, 1)
        setPct(p)

        for i = 1, #steps do
            if p >= steps[i].at and stepIdx < i then
                stepIdx = i
                setStatus(steps[i].text)
            end
        end

        if p >= 1 then
            conn2:Disconnect()
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
