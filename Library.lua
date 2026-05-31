local RunService   = game:GetService("RunService")
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Library = {}

function Library:CreateLoader(config)
    config = config or {}
    local gameName  = config.GameName  or "Unknown Game"
    local scriptRaw = config.ScriptRaw or ""
    local version   = config.Version   or ""
    local duration  = config.Duration  or 3.5
    local accent    = config.Accent    or Color3.fromHex("#6E7FFF")
    local onError   = config.OnError   or function(e) warn("[Meyy Hub]:", e) end
    local steps     = config.Steps or {
        { at = 0.00, text = "Initializing"           },
        { at = 0.22, text = "Checking configuration" },
        { at = 0.50, text = "Downloading script"     },
        { at = 0.80, text = "Opening interface"      },
    }

    local old = CoreGui:FindFirstChild("MeyyHubLoader")
    if old then old:Destroy() end

    local W, H = 400, 126
    local supported = scriptRaw ~= ""
    local rotGrads = {}

    local gui = Instance.new("ScreenGui")
    gui.Name           = "MeyyHubLoader"
    gui.ResetOnSpawn   = false
    gui.IgnoreGuiInset = true
    gui.Parent         = CoreGui

    local frame = Instance.new("Frame", gui)
    frame.AnchorPoint            = Vector2.new(0.5, 0.5)
    frame.Position               = UDim2.new(0.5, 0, 0.5, 0)
    frame.Size                   = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3       = Color3.fromHex("#0C0C1A")
    frame.BorderSizePixel        = 0
    frame.ClipsDescendants       = true
    frame.ZIndex                 = 10
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

    local border = Instance.new("UIStroke", frame)
    border.Color     = Color3.fromHex("#1E1E38")
    border.Thickness = 1

    local gradBorder = Instance.new("UIStroke", frame)
    gradBorder.Thickness = 1.5
    gradBorder.Transparency = 0.5
    local grad = Instance.new("UIGradient", gradBorder)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromHex("#1A1A30")),
        ColorSequenceKeypoint.new(0.25, Color3.fromHex("#6E7FFF")),
        ColorSequenceKeypoint.new(0.5,  Color3.fromHex("#9D7FFF")),
        ColorSequenceKeypoint.new(0.75, Color3.fromHex("#6E7FFF")),
        ColorSequenceKeypoint.new(1,    Color3.fromHex("#1A1A30")),
    })
    table.insert(rotGrads, grad)

    local accentLine = Instance.new("Frame", frame)
    accentLine.Size               = UDim2.new(0, 60, 0, 2)
    accentLine.Position           = UDim2.new(0, 20, 0, 0)
    accentLine.BackgroundColor3   = accent
    accentLine.BorderSizePixel    = 0
    accentLine.ZIndex             = 12
    local alGrad = Instance.new("UIGradient", accentLine)
    alGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   accent),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#000000")),
    })

    local dot = Instance.new("Frame", frame)
    dot.Size             = UDim2.new(0, 7, 0, 7)
    dot.Position         = UDim2.new(0, 20, 0, 22)
    dot.BackgroundColor3 = accent
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 12
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local dotGlow = Instance.new("Frame", dot)
    dotGlow.Size               = UDim2.new(3, 0, 3, 0)
    dotGlow.Position           = UDim2.new(-1, 0, -1, 0)
    dotGlow.BackgroundColor3   = accent
    dotGlow.BackgroundTransparency = 0.65
    dotGlow.BorderSizePixel    = 0
    dotGlow.ZIndex             = 11
    Instance.new("UICorner", dotGlow).CornerRadius = UDim.new(1, 0)

    local function tween(obj, t, props)
        return TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Sine), props)
    end

    task.spawn(function()
        local ds = Instance.new("UIScale", dot)
        local dg = dotGlow
        while dot and dot.Parent do
            tween(ds, 0.7, {Scale = 1.5}):Play()
            if dg and dg.Parent then tween(dg, 0.7, {BackgroundTransparency = 0.45}):Play() end
            task.wait(0.7)
            tween(ds, 0.7, {Scale = 1}):Play()
            if dg and dg.Parent then tween(dg, 0.7, {BackgroundTransparency = 0.65}):Play() end
            task.wait(0.7)
        end
    end)

    local title = Instance.new("TextLabel", frame)
    title.Size               = UDim2.new(1, -90, 0, 22)
    title.Position           = UDim2.new(0, 34, 0, 20)
    title.BackgroundTransparency = 1
    title.Font               = Enum.Font.GothamBold
    title.Text               = "Meyy Hub  ·  " .. gameName
    title.TextSize           = 14
    title.TextColor3         = Color3.fromHex("#EEEEFF")
    title.TextXAlignment     = Enum.TextXAlignment.Left
    title.ZIndex             = 11

    local statusLabel = Instance.new("TextLabel", frame)
    statusLabel.Size               = UDim2.new(1, -160, 0, 18)
    statusLabel.Position           = UDim2.new(0, 20, 0, 54)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font               = Enum.Font.Gotham
    statusLabel.Text               = supported and "Initializing" or "Checking game support..."
    statusLabel.TextSize           = 12
    statusLabel.TextColor3         = Color3.fromHex("#7A7AA8")
    statusLabel.TextXAlignment     = Enum.TextXAlignment.Left
    statusLabel.ZIndex             = 11

    local pctLabel = Instance.new("TextLabel", frame)
    pctLabel.Size               = UDim2.new(0, 55, 0, 18)
    pctLabel.Position           = UDim2.new(1, -75, 0, 54)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Font               = Enum.Font.GothamBold
    pctLabel.Text               = supported and "0%" or "—"
    pctLabel.TextSize           = 12
    pctLabel.TextColor3         = supported and accent or Color3.fromHex("#505080")
    pctLabel.TextXAlignment     = Enum.TextXAlignment.Right
    pctLabel.ZIndex             = 11

    local bar = Instance.new("Frame", frame)
    bar.Size             = UDim2.new(1, -40, 0, 4)
    bar.Position         = UDim2.new(0, 20, 0, 80)
    bar.BackgroundColor3 = Color3.fromHex("#181830")
    bar.BorderSizePixel  = 0
    bar.ZIndex           = 11
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    if not supported then
        local bg = Instance.new("UIGradient", bar)
        bg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromHex("#000000")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#404060")),
            ColorSequenceKeypoint.new(1,   Color3.fromHex("#000000")),
        })
        bg.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0,   0.3),
            NumberSequenceKeypoint.new(0.5, 0.6),
            NumberSequenceKeypoint.new(1,   0.3),
        })
    end

    local fill = Instance.new("Frame", bar)
    fill.Size             = UDim2.new(0, supported and 0 or 0, 1, 0)
    fill.BackgroundColor3 = accent
    fill.BorderSizePixel  = 0
    fill.ZIndex           = 12
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local barGrad = Instance.new("UIGradient", fill)
    barGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    accent),
        ColorSequenceKeypoint.new(0.5,  Color3.fromHex("#C0CCFF")),
        ColorSequenceKeypoint.new(1,    Color3.fromHex("#FFFFFF")),
    })
    table.insert(rotGrads, barGrad)

    local barGlow = Instance.new("Frame", bar)
    barGlow.Size             = UDim2.new(0, 0, 1, 12)
    barGlow.Position         = UDim2.new(0, 0, 0, -6)
    barGlow.BackgroundColor3 = accent
    barGlow.BackgroundTransparency = 0.85
    barGlow.BorderSizePixel  = 0
    barGlow.ZIndex           = 10
    Instance.new("UICorner", barGlow).CornerRadius = UDim.new(1, 0)

    -- Bottom info
    local info = Instance.new("TextLabel", frame)
    info.Size               = UDim2.new(1, -40, 0, 14)
    info.Position           = UDim2.new(0, 20, 0, 94)
    info.BackgroundTransparency = 1
    info.Font               = Enum.Font.Gotham
    info.Text               = supported and "v" .. (version ~= "" and version or duration .. "s") or "This game is not yet supported"
    info.TextSize           = 10
    info.TextColor3         = Color3.fromHex("#505080")
    info.TextXAlignment     = Enum.TextXAlignment.Left
    info.ZIndex             = 11

    local tip = Instance.new("TextLabel", frame)
    tip.Size               = UDim2.new(1, -40, 0, 14)
    tip.Position           = UDim2.new(0, 20, 0, 108)
    tip.BackgroundTransparency = 1
    tip.Font               = Enum.Font.Gotham
    tip.Text               = supported and "Loading..." or "Close in 5s"
    tip.TextSize           = 10
    tip.TextColor3         = Color3.fromHex("#3A3A60")
    tip.TextXAlignment     = Enum.TextXAlignment.Left
    tip.ZIndex             = 11

    if not supported then
        fill.Size = UDim2.new(1, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromHex("#404060")
        fill.BackgroundTransparency = 0.4
        barGrad.Enabled = false
        barGlow.BackgroundTransparency = 1
    end

    local rot = 0
    local rotConn
    rotConn = RunService.RenderStepped:Connect(function()
        if not frame.Parent then rotConn:Disconnect() return end
        rot = (rot + 0.6) % 360
        for _, g in ipairs(rotGrads) do
            if g and g.Parent then g.Rotation = rot end
        end
    end)

    local function setStatus(text)
        tween(statusLabel, 0.2, {TextTransparency = 1}):Play()
        task.delay(0.1, function()
            if not statusLabel or not statusLabel.Parent then return end
            statusLabel.Text = text
            tween(statusLabel, 0.2, {TextTransparency = 0}):Play()
        end)
    end

    local function setPct(p)
        local n = math.floor(p * 100)
        pctLabel.Text = n .. "%"
        tween(fill, 0.25, {Size = UDim2.new(p, 0, 1, 0)}):Play()
        tween(barGlow, 0.25, {Size = UDim2.new(p, 0, 1, 12)}):Play()
    end

    local function fadeOut(delay, cb)
        task.delay(delay, function()
            tween(frame, 0.4, {BackgroundTransparency = 1, Size = UDim2.new(0, W, 0, 0)}):Play()
            tween(border, 0.4, {Thickness = 0}):Play()
            tween(gradBorder, 0.4, {Thickness = 0}):Play()
            task.wait(0.45)
            gui:Destroy()
            if cb then cb() end
        end)
    end

    TweenService:Create(frame,
        TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, W, 0, H) }
    ):Play()
    task.wait(0.75)

    if not supported then
        fadeOut(5)
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
            info.Text = "Starting..."
            fadeOut(1.5, function()
                local ok, err = pcall(function()
                    loadstring(game:HttpGet(scriptRaw, true))()
                end)
                if not ok then onError(err) end
            end)
        end
    end)
end

return Library
