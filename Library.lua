local RunService   = game:GetService("RunService")
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Library = {}

local THEME = {
    MainBg      = Color3.fromHex("#0D0D0D"),
    MainBgTrans = 0.08,
    ContainerBg = Color3.fromHex("#1A1A1A"),
    TextPrimary = Color3.fromHex("#FFFFFF"),
    TextSecond  = Color3.fromHex("#666666"),
    Green       = Color3.fromHex("#00E676"),
    Red         = Color3.fromHex("#FF5252"),
    Blue        = Color3.fromHex("#82B1FF"),
    StrokeSeq   = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#444444")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#222222")),
    }),
    TextGradSeq = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#AAAAAA")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#777777")),
    }),
}

local function applyGrad(label)
    label.TextColor3 = THEME.TextPrimary
    local g = Instance.new("UIGradient", label)
    g.Rotation = 90
    g.Color = THEME.TextGradSeq
end

local function addRotStroke(parent, grads, thickness)
    local s = Instance.new("UIStroke", parent)
    s.Thickness = thickness or 1.4
    local g = Instance.new("UIGradient", s)
    g.Color = THEME.StrokeSeq
    if grads then table.insert(grads, g) end
    return s, g
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
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local mainStroke = Instance.new("UIStroke", frame)
    mainStroke.Thickness = 1.6
    local mainStrokeGrad = Instance.new("UIGradient", mainStroke)
    mainStrokeGrad.Color = THEME.StrokeSeq
    table.insert(rotGrads, mainStrokeGrad)

    local snowContainer = Instance.new("Frame", frame)
    snowContainer.Size = UDim2.new(1, 0, 1, 0)
    snowContainer.BackgroundTransparency = 1
    snowContainer.ClipsDescendants = true
    snowContainer.ZIndex = 1

    task.spawn(function()
        while task.wait(0.28) do
            if not frame.Parent then break end
            local f = Instance.new("Frame", snowContainer)
            f.BackgroundColor3 = Color3.new(1, 1, 1)
            f.BackgroundTransparency = math.random(70, 92) / 100
            local s = math.random(2, 4)
            f.Size = UDim2.new(0, s, 0, s)
            f.Position = UDim2.new(math.random(), 0, -0.05, 0)
            f.BorderSizePixel = 0
            f.ZIndex = 1
            Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
            local tw = TweenService:Create(f,
                TweenInfo.new(math.random(6, 10), Enum.EasingStyle.Linear),
                { Position = UDim2.new(f.Position.X.Scale + math.random(-6, 6)/100, 0, 1.05, 0) }
            )
            tw:Play()
            tw.Completed:Connect(function() f:Destroy() end)
        end
    end)

    local topBar = Instance.new("Frame", frame)
    topBar.Size = UDim2.new(1, 0, 0, 46)
    topBar.BackgroundTransparency = 1
    topBar.ZIndex = 12

    local titleLabel = Instance.new("TextLabel", topBar)
    titleLabel.Size = UDim2.new(1, -20, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "Meyy Hub  —  " .. gameName
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 12
    applyGrad(titleLabel)

    local divider = Instance.new("Frame", frame)
    divider.Size = UDim2.new(1, -32, 0, 1)
    divider.Position = UDim2.new(0, 16, 0, 46)
    divider.BackgroundColor3 = Color3.fromHex("#FFFFFF")
    divider.BorderSizePixel = 0
    divider.ZIndex = 11
    local divGrad = Instance.new("UIGradient", divider)
    divGrad.Color = THEME.StrokeSeq
    divGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.3),
        NumberSequenceKeypoint.new(1, 1),
    })

    local content = Instance.new("Frame", frame)
    content.Size = UDim2.new(1, -32, 1, -62)
    content.Position = UDim2.new(0, 16, 0, 56)
    content.BackgroundTransparency = 1
    content.ZIndex = 11

    local statusLabel = Instance.new("TextLabel", content)
    statusLabel.Size = UDim2.new(1, 0, 0, 16)
    statusLabel.Position = UDim2.new(0, 0, 0, 2)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Text = "Checking configuration..."
    statusLabel.TextSize = 12
    statusLabel.TextColor3 = THEME.TextSecond
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.ZIndex = 11

    local pctLabel = Instance.new("TextLabel", content)
    pctLabel.Size = UDim2.new(0, 40, 0, 16)
    pctLabel.Position = UDim2.new(1, -40, 0, 2)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Font = Enum.Font.GothamBold
    pctLabel.Text = "0%"
    pctLabel.TextSize = 12
    pctLabel.TextColor3 = THEME.Blue
    pctLabel.TextXAlignment = Enum.TextXAlignment.Right
    pctLabel.ZIndex = 11

    local barBg = Instance.new("Frame", content)
    barBg.Size = UDim2.new(1, 0, 0, 4)
    barBg.Position = UDim2.new(0, 0, 0, 26)
    barBg.BackgroundColor3 = Color3.fromHex("#2A2A2A")
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 11
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)
    addRotStroke(barBg, nil, 0.8)

    local barFill = Instance.new("Frame", barBg)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = THEME.Blue
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 12
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

    local barGrad = Instance.new("UIGradient", barFill)
    barGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#4488FF")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#AACCFF")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#FFFFFF")),
    })
    table.insert(rotGrads, barGrad)

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
        statusLabel.Text = text
        statusLabel.TextColor3 = color or THEME.TextSecond
    end

    local function setPct(p)
        pctLabel.Text = math.floor(p * 100) .. "%"
        TweenService:Create(barFill, TweenInfo.new(0.12, Enum.EasingStyle.Sine), {
            Size = UDim2.new(p, 0, 1, 0)
        }):Play()
    end

    local function fadeOut(delayTime, cb)
        task.delay(delayTime, function()
            TweenService:Create(frame,
                TweenInfo.new(0.4, Enum.EasingStyle.Sine),
                { BackgroundTransparency = 1 }
            ):Play()
            TweenService:Create(mainStroke, TweenInfo.new(0.4), {Thickness = 0}):Play()
            task.wait(0.45)
            gui:Destroy()
            if cb then cb() end
        end)
    end

    TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 370, 0, 105)
    }):Play()

    task.wait(0.6)

    if scriptRaw == "" then
        setPct(1)
        barFill.BackgroundColor3 = THEME.Red
        barGrad.Enabled = false
        pctLabel.TextColor3 = THEME.Red
        pctLabel.Text = "!"
        setStatus("Game not supported!", THEME.Red)
        fadeOut(3.5)
        return
    end

    local startTime = tick()
    local duration  = 2.5
    local steps = {
        { at = 0.00, text = "Checking configuration...", color = THEME.TextSecond },
        { at = 0.35, text = "Downloading script data...", color = THEME.TextSecond },
        { at = 0.70, text = "Opening interface...",       color = THEME.TextSecond },
    }
    local stepIdx = 1

    local conn
    conn = RunService.Heartbeat:Connect(function()
        local p = math.min((tick() - startTime) / duration, 1)
        setPct(p)

        for i = #steps, 1, -1 do
            if p >= steps[i].at and stepIdx <= i then
                stepIdx = i + 1
                setStatus(steps[i].text, steps[i].color)
                break
            end
        end

        if p >= 1 then
            conn:Disconnect()
            barFill.BackgroundColor3 = THEME.Green
            barGrad.Enabled = false
            pctLabel.TextColor3 = THEME.Green
            pctLabel.Text = "100%"
            setStatus("Loaded successfully!", THEME.Green)
            fadeOut(0.8, function()
                local ok, err = pcall(function()
                    loadstring(game:HttpGet(scriptRaw, true))()
                end)
                if not ok then warn("[Meyy Hub]:", err) end
            end)
        end
    end)
end

return Library
