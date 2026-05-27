local RunService   = game:GetService("RunService")
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Library = {}

local THEME = {
    MainBg      = Color3.fromHex("#0A0A0A"),
    MainBgTrans = 0.05,
    ContainerBg = Color3.fromHex("#141414"),
    TextPrimary = Color3.fromHex("#FFFFFF"),
    TextSecond  = Color3.fromHex("#555555"),
    Green       = Color3.fromHex("#00E676"),
    Red         = Color3.fromHex("#FF5252"),
    Blue        = Color3.fromHex("#82B1FF"),
    StrokeSeq   = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#333333")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#1A1A1A")),
    }),
    TextGradSeq = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#999999")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#666666")),
    }),
}

local function applyGrad(label)
    label.TextColor3 = THEME.TextPrimary
    local g = Instance.new("UIGradient", label)
    g.Rotation = 90
    g.Color = THEME.TextGradSeq
end

function Library:CreateLoader(config)
    config = config or {}
    local gameName  = config.GameName  or "Game Script"
    local scriptRaw = config.ScriptRaw or ""

    local old = CoreGui:FindFirstChild("MeyyHubLoader")
    if old then old:Destroy() end

    local rotGrads = {}

    local gui = Instance.new("ScreenGui")
    gui.Name = "MeyyHubLoader"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = CoreGui

    local frame = Instance.new("Frame", gui)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = THEME.MainBg
    frame.BackgroundTransparency = THEME.MainBgTrans
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.ZIndex = 10
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

    local mainStroke = Instance.new("UIStroke", frame)
    mainStroke.Thickness = 1.5
    local mainStrokeGrad = Instance.new("UIGradient", mainStroke)
    mainStrokeGrad.Color = THEME.StrokeSeq
    table.insert(rotGrads, mainStrokeGrad)

    local innerGlow = Instance.new("Frame", frame)
    innerGlow.Size = UDim2.new(1, 0, 0, 1)
    innerGlow.Position = UDim2.new(0, 0, 0, 0)
    innerGlow.BackgroundColor3 = Color3.fromHex("#FFFFFF")
    innerGlow.BackgroundTransparency = 0.85
    innerGlow.BorderSizePixel = 0
    innerGlow.ZIndex = 11
    local igGrad = Instance.new("UIGradient", innerGlow)
    igGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#000000")),
        ColorSequenceKeypoint.new(0.3, Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(0.7, Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#000000")),
    })

    local snowContainer = Instance.new("Frame", frame)
    snowContainer.Size = UDim2.new(1, 0, 1, 0)
    snowContainer.BackgroundTransparency = 1
    snowContainer.ClipsDescendants = true
    snowContainer.ZIndex = 1

    task.spawn(function()
        while task.wait(0.3) do
            if not frame.Parent then break end
            local f = Instance.new("Frame", snowContainer)
            f.BackgroundColor3 = Color3.new(1, 1, 1)
            f.BackgroundTransparency = math.random(75, 94) / 100
            local s = math.random(1, 3)
            f.Size = UDim2.new(0, s, 0, s)
            f.Position = UDim2.new(math.random(), 0, -0.05, 0)
            f.BorderSizePixel = 0
            f.ZIndex = 1
            Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
            local tw = TweenService:Create(f,
                TweenInfo.new(math.random(7, 12), Enum.EasingStyle.Linear),
                { Position = UDim2.new(f.Position.X.Scale + math.random(-5, 5)/100, 0, 1.05, 0) }
            )
            tw:Play()
            tw.Completed:Connect(function() f:Destroy() end)
        end
    end)

    local topBar = Instance.new("Frame", frame)
    topBar.Size = UDim2.new(1, 0, 0, 50)
    topBar.BackgroundTransparency = 1
    topBar.ZIndex = 12

    local badge = Instance.new("Frame", topBar)
    badge.Size = UDim2.new(0, 4, 0, 20)
    badge.Position = UDim2.new(0, 16, 0.5, 0)
    badge.AnchorPoint = Vector2.new(0, 0.5)
    badge.BackgroundColor3 = THEME.Blue
    badge.BorderSizePixel = 0
    badge.ZIndex = 13
    Instance.new("UICorner", badge).CornerRadius = UDim.new(1, 0)
    local badgeGrad = Instance.new("UIGradient", badge)
    badgeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#82B1FF")),
    })
    badgeGrad.Rotation = 90

    local titleLabel = Instance.new("TextLabel", topBar)
    titleLabel.Size = UDim2.new(1, -50, 0, 18)
    titleLabel.Position = UDim2.new(0, 28, 0.5, -9)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "Meyy Hub"
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 12
    applyGrad(titleLabel)

    local gameLabel = Instance.new("TextLabel", topBar)
    gameLabel.Size = UDim2.new(1, -50, 0, 13)
    gameLabel.Position = UDim2.new(0, 28, 0.5, 9)
    gameLabel.BackgroundTransparency = 1
    gameLabel.Font = Enum.Font.Gotham
    gameLabel.Text = gameName
    gameLabel.TextSize = 11
    gameLabel.TextColor3 = THEME.TextSecond
    gameLabel.TextXAlignment = Enum.TextXAlignment.Left
    gameLabel.ZIndex = 12

    local divider = Instance.new("Frame", frame)
    divider.Size = UDim2.new(1, -32, 0, 1)
    divider.Position = UDim2.new(0, 16, 0, 50)
    divider.BackgroundColor3 = Color3.fromHex("#FFFFFF")
    divider.BorderSizePixel = 0
    divider.ZIndex = 11
    local divGrad = Instance.new("UIGradient", divider)
    divGrad.Color = THEME.StrokeSeq
    divGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.55),
        NumberSequenceKeypoint.new(1, 1),
    })

    local content = Instance.new("Frame", frame)
    content.Size = UDim2.new(1, -32, 1, -66)
    content.Position = UDim2.new(0, 16, 0, 58)
    content.BackgroundTransparency = 1
    content.ZIndex = 11

    local statusRow = Instance.new("Frame", content)
    statusRow.Size = UDim2.new(1, 0, 0, 16)
    statusRow.Position = UDim2.new(0, 0, 0, 4)
    statusRow.BackgroundTransparency = 1
    statusRow.ZIndex = 11

    local statusLabel = Instance.new("TextLabel", statusRow)
    statusLabel.Size = UDim2.new(1, -50, 1, 0)
    statusLabel.Position = UDim2.new(0, 0, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Text = "Initializing..."
    statusLabel.TextSize = 11
    statusLabel.TextColor3 = THEME.TextSecond
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.ZIndex = 11

    local pctLabel = Instance.new("TextLabel", statusRow)
    pctLabel.Size = UDim2.new(0, 45, 1, 0)
    pctLabel.Position = UDim2.new(1, -45, 0, 0)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Font = Enum.Font.GothamBold
    pctLabel.Text = "0%"
    pctLabel.TextSize = 11
    pctLabel.TextColor3 = THEME.Blue
    pctLabel.TextXAlignment = Enum.TextXAlignment.Right
    pctLabel.ZIndex = 11

    local barBg = Instance.new("Frame", content)
    barBg.Size = UDim2.new(1, 0, 0, 3)
    barBg.Position = UDim2.new(0, 0, 0, 28)
    barBg.BackgroundColor3 = Color3.fromHex("#222222")
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 11
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local barFill = Instance.new("Frame", barBg)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = THEME.Blue
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 12
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

    local barGrad = Instance.new("UIGradient", barFill)
    barGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#3366FF")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#99BBFF")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#FFFFFF")),
    })
    table.insert(rotGrads, barGrad)

    local shimmer = Instance.new("Frame", barFill)
    shimmer.Size = UDim2.new(0, 40, 1, 0)
    shimmer.Position = UDim2.new(-0.2, 0, 0, 0)
    shimmer.BackgroundColor3 = Color3.new(1, 1, 1)
    shimmer.BackgroundTransparency = 0.7
    shimmer.BorderSizePixel = 0
    shimmer.ZIndex = 13
    Instance.new("UICorner", shimmer).CornerRadius = UDim.new(1, 0)
    local shimGrad = Instance.new("UIGradient", shimmer)
    shimGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#000000")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#000000")),
    })

    task.spawn(function()
        while shimmer and shimmer.Parent do
            TweenService:Create(shimmer, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {
                Position = UDim2.new(1.2, 0, 0, 0)
            }):Play()
            task.wait(1.4)
            shimmer.Position = UDim2.new(-0.2, 0, 0, 0)
        end
    end)

    local rot = 0
    local rotConn
    rotConn = RunService.RenderStepped:Connect(function()
        if not frame.Parent then rotConn:Disconnect() return end
        rot = (rot + 1.2) % 360
        for _, g in ipairs(rotGrads) do
            if g and g.Parent then g.Rotation = rot end
        end
    end)

    local function setStatus(text, color)
        TweenService:Create(statusLabel, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
            TextTransparency = 1
        }):Play()
        task.delay(0.15, function()
            if statusLabel and statusLabel.Parent then
                statusLabel.Text = text
                statusLabel.TextColor3 = color or THEME.TextSecond
                TweenService:Create(statusLabel, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
                    TextTransparency = 0
                }):Play()
            end
        end)
    end

    local lastPct = 0
    local function setPct(p)
        local pInt = math.floor(p * 100)
        if pInt ~= lastPct then
            lastPct = pInt
            pctLabel.Text = pInt .. "%"
        end
        TweenService:Create(barFill, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
            Size = UDim2.new(p, 0, 1, 0)
        }):Play()
    end

    local function setSuccess()
        barGrad.Enabled = false
        barFill.BackgroundColor3 = THEME.Green
        pctLabel.TextColor3 = THEME.Green
        pctLabel.Text = "100%"
        badge.BackgroundColor3 = THEME.Green
        badgeGrad.Enabled = false
        setStatus("Loaded successfully!", THEME.Green)
    end

    local function setError()
        barGrad.Enabled = false
        barFill.BackgroundColor3 = THEME.Red
        pctLabel.TextColor3 = THEME.Red
        pctLabel.Text = "!"
        badge.BackgroundColor3 = THEME.Red
        badgeGrad.Enabled = false
        setStatus("Game not supported!", THEME.Red)
    end

    local function fadeOut(delayTime, cb)
        task.delay(delayTime, function()
            TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 370, 0, 0)
            }):Play()
            TweenService:Create(mainStroke, TweenInfo.new(0.5), {Thickness = 0}):Play()
            task.wait(0.55)
            gui:Destroy()
            if cb then cb() end
        end)
    end

    TweenService:Create(frame, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 370, 0, 110)
    }):Play()

    task.wait(0.65)

    if scriptRaw == "" then
        setPct(1)
        setError()
        fadeOut(3.5)
        return
    end

    local startTime = tick()
    local duration  = 2.5
    local steps = {
        { at = 0.00, text = "Initializing...",           color = THEME.TextSecond },
        { at = 0.25, text = "Checking configuration...", color = THEME.TextSecond },
        { at = 0.50, text = "Downloading script data...", color = THEME.TextSecond },
        { at = 0.80, text = "Opening interface...",       color = THEME.TextSecond },
    }
    local stepIdx = 0

    local conn
    conn = RunService.Heartbeat:Connect(function()
        local p = math.min((tick() - startTime) / duration, 1)
        setPct(p)

        for i = 1, #steps do
            if p >= steps[i].at and stepIdx < i then
                stepIdx = i
                setStatus(steps[i].text, steps[i].color)
            end
        end

        if p >= 1 then
            conn:Disconnect()
            setSuccess()
            fadeOut(0.9, function()
                local ok, err = pcall(function()
                    loadstring(game:HttpGet(scriptRaw, true))()
                end)
                if not ok then warn("[Meyy Hub]:", err) end
            end)
        end
    end)
end

return Library
