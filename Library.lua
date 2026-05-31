local RunService   = game:GetService("RunService")
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Library = {}

local THEME = {
    Bg01   = Color3.fromHex("#0D0D1A"),
    Bg02   = Color3.fromHex("#12121F"),
    Border = Color3.fromHex("#1E1E35"),
    Text01 = Color3.fromHex("#EEEEFF"),
    Text02 = Color3.fromHex("#6B6B8D"),
    Text03 = Color3.fromHex("#3A3A55"),
    Green  = Color3.fromHex("#00D68F"),
    Blue   = Color3.fromHex("#6E7FFF"),
    Purple = Color3.fromHex("#9D7FFF"),
}

local function makeTween(obj, t, props)
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

    local W, H = 420, 112

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
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

    local innerGlow = Instance.new("Frame", frame)
    innerGlow.Size               = UDim2.new(1, 0, 1, 0)
    innerGlow.BackgroundColor3   = Color3.fromHex("#FFFFFF")
    innerGlow.BackgroundTransparency = 0.985
    innerGlow.BorderSizePixel    = 0
    innerGlow.ZIndex             = 1

    local border = Instance.new("UIStroke", frame)
    border.Color     = THEME.Border
    border.Thickness = 1

    local PAD = 22
    local content = Instance.new("Frame", frame)
    content.Size               = UDim2.new(1, -(PAD * 2), 1, -(PAD * 2))
    content.Position           = UDim2.new(0, PAD, 0, PAD)
    content.BackgroundTransparency = 1
    content.ZIndex             = 11

    local dot = Instance.new("Frame", content)
    dot.Size             = UDim2.new(0, 8, 0, 8)
    dot.Position         = UDim2.new(0, 0, 0, 0)
    dot.BackgroundColor3 = accent
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 12
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        local ds = Instance.new("UIScale", dot)
        while dot and dot.Parent do
            makeTween(ds, 0.8, {Scale = 1.3}):Play()
            task.wait(0.8)
            makeTween(ds, 0.8, {Scale = 1}):Play()
            task.wait(0.8)
        end
    end)

    local titleLabel = Instance.new("TextLabel", content)
    titleLabel.Size               = UDim2.new(0, 0, 0, 16)
    titleLabel.Position           = UDim2.new(0, 18, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font               = Enum.Font.GothamBold
    titleLabel.Text               = "Meyy Hub"
    titleLabel.TextSize           = 13
    titleLabel.TextColor3         = THEME.Text01
    titleLabel.TextXAlignment     = Enum.TextXAlignment.Left
    titleLabel.ZIndex             = 12
    titleLabel.Size               = UDim2.new(0, titleLabel.TextBounds.X, 0, 16)

    local sep = Instance.new("TextLabel", content)
    sep.Size               = UDim2.new(0, 0, 0, 16)
    sep.Position           = UDim2.new(0, titleLabel.TextBounds.X + 22, 0, 0)
    sep.BackgroundTransparency = 1
    sep.Font               = Enum.Font.Gotham
    sep.Text               = "/"
    sep.TextSize           = 12
    sep.TextColor3         = THEME.Text03
    sep.TextXAlignment     = Enum.TextXAlignment.Left
    sep.ZIndex             = 12
    sep.Size               = UDim2.new(0, sep.TextBounds.X, 0, 16)

    local gameLabel = Instance.new("TextLabel", content)
    gameLabel.Size               = UDim2.new(0, 0, 0, 16)
    gameLabel.Position           = UDim2.new(0, titleLabel.TextBounds.X + sep.TextBounds.X + 26, 0, 0)
    gameLabel.BackgroundTransparency = 1
    gameLabel.Font               = Enum.Font.Gotham
    gameLabel.Text               = gameName
    gameLabel.TextSize           = 12
    gameLabel.TextColor3         = THEME.Text02
    gameLabel.TextXAlignment     = Enum.TextXAlignment.Left
    gameLabel.ZIndex             = 12
    gameLabel.Size               = UDim2.new(0, 0, 0, 16)

    if version ~= "" then
        local verTag = Instance.new("Frame", content)
        verTag.Size               = UDim2.new(0, 0, 0, 18)
        verTag.Position           = UDim2.new(1, 0, 0, -1)
        verTag.BackgroundColor3   = THEME.Bg02
        verTag.BorderSizePixel    = 0
        verTag.ZIndex             = 12
        Instance.new("UICorner", verTag).CornerRadius = UDim.new(0, 4)

        local border = Instance.new("UIStroke", verTag)
        border.Color     = THEME.Border
        border.Thickness = 1

        local verLabel = Instance.new("TextLabel", verTag)
        verLabel.Size               = UDim2.new(1, -12, 1, 0)
        verLabel.Position           = UDim2.new(0, 6, 0, 0)
        verLabel.BackgroundTransparency = 1
        verLabel.Font               = Enum.Font.Gotham
        verLabel.Text               = version
        verLabel.TextSize           = 9
        verLabel.TextColor3         = THEME.Text02
        verLabel.TextXAlignment     = Enum.TextXAlignment.Center
        verLabel.ZIndex             = 13
        verTag.Size = UDim2.new(0, verLabel.TextBounds.X + 18, 0, 18)
        verTag.Position = UDim2.new(1, -verTag.Size.X.Offset, 0, -1)
    end

    local statusRow = Instance.new("Frame", content)
    statusRow.Size               = UDim2.new(1, 0, 0, 16)
    statusRow.Position           = UDim2.new(0, 0, 0, 32)
    statusRow.BackgroundTransparency = 1
    statusRow.ZIndex             = 11

    local statusLabel = Instance.new("TextLabel", statusRow)
    statusLabel.Size               = UDim2.new(1, 0, 1, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font               = Enum.Font.Gotham
    statusLabel.Text               = "Initializing"
    statusLabel.TextSize           = 11
    statusLabel.TextColor3         = THEME.Text02
    statusLabel.TextXAlignment     = Enum.TextXAlignment.Left
    statusLabel.ZIndex             = 11

    local pctLabel = Instance.new("TextLabel", statusRow)
    pctLabel.Size               = UDim2.new(0, 40, 1, 0)
    pctLabel.Position           = UDim2.new(1, -40, 0, 0)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Font               = Enum.Font.GothamBold
    pctLabel.Text               = "0%"
    pctLabel.TextSize           = 10
    pctLabel.TextColor3         = accent
    pctLabel.TextXAlignment     = Enum.TextXAlignment.Right
    pctLabel.ZIndex             = 11

    local barTrack = Instance.new("Frame", content)
    barTrack.Size             = UDim2.new(1, 0, 0, 4)
    barTrack.Position         = UDim2.new(0, 0, 0, 54)
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

    local barGrad = Instance.new("UIGradient", barFill)
    barGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    accent),
        ColorSequenceKeypoint.new(0.6,  Color3.fromHex("#C0CCFF")),
        ColorSequenceKeypoint.new(1,    Color3.fromHex("#FFFFFF")),
    })

    local barGlow = Instance.new("Frame", barTrack)
    barGlow.Size             = UDim2.new(0, 0, 1, 8)
    barGlow.Position         = UDim2.new(0, 0, 0, -4)
    barGlow.BackgroundColor3 = accent
    barGlow.BackgroundTransparency = 0.8
    barGlow.BorderSizePixel  = 0
    barGlow.ZIndex           = 10
    Instance.new("UICorner", barGlow).CornerRadius = UDim.new(1, 0)

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
        makeTween(barGlow, 0.12, {Size = UDim2.new(p, 0, 1, 8)}):Play()
    end

    local function fadeOut(delay, cb)
        task.delay(delay, function()
            makeTween(frame, 0.35, {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, W, 0, 0),
            }):Play()
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
        setStatus("Completed")
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
