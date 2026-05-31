local RunService   = game:GetService("RunService")
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Library = {}

local THEME = {
    Bg       = Color3.fromHex("#0B0B14"),
    Surface  = Color3.fromHex("#111122"),
    Surface2 = Color3.fromHex("#18182D"),
    TextHi   = Color3.fromHex("#EEEEFF"),
    TextLo   = Color3.fromHex("#3C3C5A"),
    TextDim  = Color3.fromHex("#252540"),
    Green    = Color3.fromHex("#00D68F"),
    Red      = Color3.fromHex("#FF4060"),
    Blue     = Color3.fromHex("#6E7FFF"),
    Purple   = Color3.fromHex("#9D7FFF"),
    StrokeSeq = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#181830")),
        ColorSequenceKeypoint.new(0.25, Color3.fromHex("#6E7FFF")),
        ColorSequenceKeypoint.new(0.5,  Color3.fromHex("#9D7FFF")),
        ColorSequenceKeypoint.new(0.75, Color3.fromHex("#6E7FFF")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#181830")),
    }),
}

local function makeTween(obj, t, props, ease)
    return TweenService:Create(obj, TweenInfo.new(t, ease or Enum.EasingStyle.Sine), props)
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
    local W, H = 420, 110

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
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel        = 0
    frame.ClipsDescendants       = true
    frame.ZIndex                 = 10
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

    local outerStroke = Instance.new("UIStroke", frame)
    outerStroke.Thickness = 1.2
    outerStroke.Transparency = 0.1
    local outerGrad = Instance.new("UIGradient", outerStroke)
    outerGrad.Color = THEME.StrokeSeq
    table.insert(rotGrads, outerGrad)

    local topHighlight = Instance.new("Frame", frame)
    topHighlight.Size               = UDim2.new(0.5, 0, 0, 1)
    topHighlight.Position           = UDim2.new(0.25, 0, 0, 0)
    topHighlight.BackgroundColor3   = Color3.new(1, 1, 1)
    topHighlight.BackgroundTransparency = 0.7
    topHighlight.BorderSizePixel    = 0
    topHighlight.ZIndex             = 20
    local thGrad = Instance.new("UIGradient", topHighlight)
    thGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#000000")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#000000")),
    })

    local function makeBlob(parent, color, size, pos, trans)
        local b = Instance.new("Frame", parent)
        b.Size               = UDim2.new(0, size, 0, size)
        b.Position           = pos
        b.BackgroundColor3   = color
        b.BackgroundTransparency = trans
        b.BorderSizePixel    = 0
        b.ZIndex             = 2
        Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
        return b
    end
    makeBlob(frame, accent,       170, UDim2.new(1, -30, 1, -20), 0.92)
    makeBlob(frame, THEME.Purple, 110, UDim2.new(0, -25, 0, -15), 0.94)

    local header = Instance.new("Frame", frame)
    header.Size               = UDim2.new(1, 0, 0, 58)
    header.BackgroundColor3   = THEME.Surface
    header.BackgroundTransparency = 0.3
    header.BorderSizePixel    = 0
    header.ZIndex             = 11
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

    local headerClip = Instance.new("Frame", header)
    headerClip.Size               = UDim2.new(1, 0, 0, 14)
    headerClip.Position           = UDim2.new(0, 0, 1, -14)
    headerClip.BackgroundColor3   = THEME.Surface
    headerClip.BackgroundTransparency = 0.3
    headerClip.BorderSizePixel    = 0
    headerClip.ZIndex             = 12

    local dot = Instance.new("Frame", header)
    dot.Size             = UDim2.new(0, 7, 0, 7)
    dot.Position         = UDim2.new(0, 18, 0.5, 0)
    dot.AnchorPoint      = Vector2.new(0, 0.5)
    dot.BackgroundColor3 = accent
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 14
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local dotGlow = Instance.new("Frame", dot)
    dotGlow.Size               = UDim2.new(3, 0, 3, 0)
    dotGlow.Position           = UDim2.new(-1, 0, -1, 0)
    dotGlow.BackgroundColor3   = accent
    dotGlow.BackgroundTransparency = 0.7
    dotGlow.BorderSizePixel    = 0
    dotGlow.ZIndex             = 13
    Instance.new("UICorner", dotGlow).CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        local ds = Instance.new("UIScale", dot)
        local dg = dotGlow
        while dot and dot.Parent do
            makeTween(ds, 0.7, {Scale = 1.4}):Play()
            if dg and dg.Parent then
                makeTween(dg, 0.7, {BackgroundTransparency = 0.55}):Play()
            end
            task.wait(0.7)
            makeTween(ds, 0.7, {Scale = 1}):Play()
            if dg and dg.Parent then
                makeTween(dg, 0.7, {BackgroundTransparency = 0.7}):Play()
            end
            task.wait(0.7)
        end
    end)

    local titleLabel = Instance.new("TextLabel", header)
    titleLabel.Size               = UDim2.new(1, -110, 0, 18)
    titleLabel.Position           = UDim2.new(0, 32, 0.5, -10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font               = Enum.Font.GothamBold
    titleLabel.Text               = "Meyy Hub  ·  " .. gameName .. " Script"
    titleLabel.TextSize           = 12
    titleLabel.TextColor3         = THEME.TextHi
    titleLabel.TextXAlignment     = Enum.TextXAlignment.Left
    titleLabel.TextTruncate       = Enum.TextTruncate.AtEnd
    titleLabel.ZIndex             = 14
    local titleGrad = Instance.new("UIGradient", titleLabel)
    titleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(0.55, Color3.fromHex("#CCCCEE")),
        ColorSequenceKeypoint.new(1,    Color3.fromHex("#8888BB")),
    })

    local subtitleLabel = Instance.new("TextLabel", header)
    subtitleLabel.Size               = UDim2.new(1, -110, 0, 12)
    subtitleLabel.Position           = UDim2.new(0, 32, 0.5, 10)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Font               = Enum.Font.Gotham
    subtitleLabel.Text               = version ~= "" and version or "Meyy Hub"
    subtitleLabel.TextSize           = 9
    subtitleLabel.TextColor3         = THEME.TextLo
    subtitleLabel.TextXAlignment     = Enum.TextXAlignment.Left
    subtitleLabel.ZIndex             = 13

    local chip = Instance.new("Frame", header)
    chip.Size               = UDim2.new(0, 62, 0, 20)
    chip.Position           = UDim2.new(1, -74, 0.5, -10)
    chip.BackgroundColor3   = THEME.Surface2
    chip.BackgroundTransparency = 0
    chip.BorderSizePixel    = 0
    chip.ZIndex             = 14
    Instance.new("UICorner", chip).CornerRadius = UDim.new(0, 6)
    local chipStroke = Instance.new("UIStroke", chip)
    chipStroke.Color     = THEME.TextDim
    chipStroke.Thickness = 1

    local chipDot = Instance.new("Frame", chip)
    chipDot.Size             = UDim2.new(0, 5, 0, 5)
    chipDot.Position         = UDim2.new(0, 8, 0.5, 0)
    chipDot.AnchorPoint      = Vector2.new(0, 0.5)
    chipDot.BackgroundColor3 = accent
    chipDot.BorderSizePixel  = 0
    chipDot.ZIndex           = 15
    Instance.new("UICorner", chipDot).CornerRadius = UDim.new(1, 0)

    local chipDotGlow = Instance.new("Frame", chipDot)
    chipDotGlow.Size               = UDim2.new(2.5, 0, 2.5, 0)
    chipDotGlow.Position           = UDim2.new(-0.75, 0, -0.75, 0)
    chipDotGlow.BackgroundColor3   = accent
    chipDotGlow.BackgroundTransparency = 0.65
    chipDotGlow.BorderSizePixel    = 0
    chipDotGlow.ZIndex             = 14
    Instance.new("UICorner", chipDotGlow).CornerRadius = UDim.new(1, 0)

    local chipLabel = Instance.new("TextLabel", chip)
    chipLabel.Size               = UDim2.new(1, -18, 1, 0)
    chipLabel.Position           = UDim2.new(0, 18, 0, 0)
    chipLabel.BackgroundTransparency = 1
    chipLabel.Font               = Enum.Font.GothamBold
    chipLabel.Text               = "Loading"
    chipLabel.TextSize           = 9
    chipLabel.TextColor3         = accent
    chipLabel.TextXAlignment     = Enum.TextXAlignment.Left
    chipLabel.ZIndex             = 15

    task.spawn(function()
        local cs = Instance.new("UIScale", chipDot)
        local cg = chipDotGlow
        while chipDot and chipDot.Parent do
            makeTween(cs, 0.55, {Scale = 1.5}):Play()
            if cg and cg.Parent then
                makeTween(cg, 0.55, {BackgroundTransparency = 0.5}):Play()
            end
            task.wait(0.55)
            makeTween(cs, 0.55, {Scale = 1}):Play()
            if cg and cg.Parent then
                makeTween(cg, 0.55, {BackgroundTransparency = 0.65}):Play()
            end
            task.wait(0.55)
        end
    end)

    local divider = Instance.new("Frame", frame)
    divider.Size               = UDim2.new(1, -32, 0, 1)
    divider.Position           = UDim2.new(0, 16, 0, 58)
    divider.BackgroundColor3   = Color3.fromHex("#FFFFFF")
    divider.BackgroundTransparency = 0.93
    divider.BorderSizePixel    = 0
    divider.ZIndex             = 12
    local divGrad = Instance.new("UIGradient", divider)
    divGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#000000")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#000000")),
    })

    local content = Instance.new("Frame", frame)
    content.Size               = UDim2.new(1, -32, 1, -74)
    content.Position           = UDim2.new(0, 16, 0, 66)
    content.BackgroundTransparency = 1
    content.ZIndex             = 11

    local statusRow = Instance.new("Frame", content)
    statusRow.Size               = UDim2.new(1, 0, 0, 14)
    statusRow.Position           = UDim2.new(0, 0, 0, 0)
    statusRow.BackgroundTransparency = 1
    statusRow.ZIndex             = 11

    local statusLabel = Instance.new("TextLabel", statusRow)
    statusLabel.Size               = UDim2.new(1, -50, 1, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font               = Enum.Font.Gotham
    statusLabel.Text               = "Initializing"
    statusLabel.TextSize           = 10
    statusLabel.TextColor3         = THEME.TextLo
    statusLabel.TextXAlignment     = Enum.TextXAlignment.Left
    statusLabel.ZIndex             = 11

    local pctLabel = Instance.new("TextLabel", statusRow)
    pctLabel.Size               = UDim2.new(0, 45, 1, 0)
    pctLabel.Position           = UDim2.new(1, -45, 0, 0)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Font               = Enum.Font.GothamBold
    pctLabel.Text               = "0%"
    pctLabel.TextSize           = 10
    pctLabel.TextColor3         = accent
    pctLabel.TextXAlignment     = Enum.TextXAlignment.Right
    pctLabel.ZIndex             = 11

    local barTrack = Instance.new("Frame", content)
    barTrack.Size             = UDim2.new(1, 0, 0, 2)
    barTrack.Position         = UDim2.new(0, 0, 0, 22)
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

    local barGrad = Instance.new("UIGradient", barFill)
    barGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    accent),
        ColorSequenceKeypoint.new(0.65, Color3.fromHex("#C0CCFF")),
        ColorSequenceKeypoint.new(1,    Color3.fromHex("#FFFFFF")),
    })
    table.insert(rotGrads, barGrad)

    local shimmer = Instance.new("Frame", barFill)
    shimmer.Size             = UDim2.new(0.28, 0, 1, 0)
    shimmer.Position         = UDim2.new(-0.32, 0, 0, 0)
    shimmer.BackgroundColor3 = Color3.new(1, 1, 1)
    shimmer.BackgroundTransparency = 0.6
    shimmer.BorderSizePixel  = 0
    shimmer.ZIndex           = 13
    Instance.new("UICorner", shimmer).CornerRadius = UDim.new(1, 0)
    local shimGrad = Instance.new("UIGradient", shimmer)
    shimGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#000000")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#000000")),
    })
    task.spawn(function()
        while shimmer and shimmer.Parent do
            TweenService:Create(shimmer, TweenInfo.new(1.4, Enum.EasingStyle.Sine), {
                Position = UDim2.new(1.32, 0, 0, 0)
            }):Play()
            task.wait(1.6)
            shimmer.Position = UDim2.new(-0.32, 0, 0, 0)
        end
    end)

    local rot = 0
    local rotConn
    rotConn = RunService.RenderStepped:Connect(function()
        if not frame.Parent then rotConn:Disconnect() return end
        rot = (rot + 0.9) % 360
        for _, g in ipairs(rotGrads) do
            if g and g.Parent then g.Rotation = rot end
        end
    end)

    local function setStatus(text)
        makeTween(statusLabel, 0.12, {TextTransparency = 1}):Play()
        task.delay(0.06, function()
            if not statusLabel or not statusLabel.Parent then return end
            statusLabel.Text = text
            makeTween(statusLabel, 0.12, {TextTransparency = 0}):Play()
        end)
    end

    local lastPct = -1
    local function setPct(p)
        local n = math.floor(p * 100)
        if n ~= lastPct then
            lastPct = n
            pctLabel.Text = n .. "%"
        end
        makeTween(barFill, 0.12, {Size = UDim2.new(p, 0, 1, 0)}):Play()
    end

    local function finalize(color, statusText, chipText, fail)
        barGrad.Enabled          = false
        barFill.BackgroundColor3 = color
        chipDot.BackgroundColor3 = color
        chipLabel.TextColor3     = color
        chipLabel.Text           = chipText
        chipStroke.Color         = color
        chipDotGlow.BackgroundColor3 = color
        pctLabel.TextColor3      = color
        pctLabel.Text            = fail and "—" or "100%"
        dot.BackgroundColor3     = color
        dotGlow.BackgroundColor3 = color
        setStatus(statusText)
    end

    local function fadeOut(delay, cb)
        task.delay(delay, function()
            makeTween(frame, 0.4, {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, W, 0, 0),
            }):Play()
            makeTween(outerStroke, 0.4, {Thickness = 0}):Play()
            task.wait(0.45)
            gui:Destroy()
            if cb then cb() end
        end)
    end

    TweenService:Create(frame,
        TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, W, 0, H) }
    ):Play()

    task.wait(0.65)

    if scriptRaw == "" then
        setPct(1)
        finalize(THEME.Red, "Game not supported", "Error", true)
        fadeOut(3.5)
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
            finalize(THEME.Green, "Loaded successfully", "Ready", false)
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
