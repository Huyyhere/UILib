local RunService   = game:GetService("RunService")
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Library = {}

function Library:CreateLoader(config)
    config = config or {}
    local gameName  = config.GameName  or "Unknown Game"
    local scriptRaw = config.ScriptRaw or ""
    local version   = config.Version   or ""
    local duration  = config.Duration  or 3.0
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

    local W, H = 400, 120

    local gui = Instance.new("ScreenGui")
    gui.Name           = "MeyyHubLoader"
    gui.ResetOnSpawn   = false
    gui.IgnoreGuiInset = true
    gui.Parent         = CoreGui

    local frame = Instance.new("Frame", gui)
    frame.AnchorPoint            = Vector2.new(0.5, 0.5)
    frame.Position               = UDim2.new(0.5, 0, 0.5, 0)
    frame.Size                   = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3       = Color3.fromHex("#0D0D1A")
    frame.BorderSizePixel        = 0
    frame.ClipsDescendants       = true
    frame.ZIndex                 = 10
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local border = Instance.new("UIStroke", frame)
    border.Color     = Color3.fromHex("#1E1E3A")
    border.Thickness = 1

    local title = Instance.new("TextLabel", frame)
    title.Size               = UDim2.new(1, -40, 0, 22)
    title.Position           = UDim2.new(0, 20, 0, 16)
    title.BackgroundTransparency = 1
    title.Font               = Enum.Font.GothamBold
    title.Text               = "Meyy Hub  ·  " .. gameName
    title.TextSize           = 14
    title.TextColor3         = Color3.fromHex("#EEEEFF")
    title.TextXAlignment     = Enum.TextXAlignment.Left
    title.ZIndex             = 11

    if version ~= "" then
        local vl = Instance.new("TextLabel", frame)
        vl.Size               = UDim2.new(1, -40, 0, 16)
        vl.Position           = UDim2.new(0, 20, 0, 40)
        vl.BackgroundTransparency = 1
        vl.Font               = Enum.Font.Gotham
        vl.Text               = version
        vl.TextSize           = 11
        vl.TextColor3         = Color3.fromHex("#7A7AA8")
        vl.TextXAlignment     = Enum.TextXAlignment.Left
        vl.ZIndex             = 11
    end

    local statusLabel = Instance.new("TextLabel", frame)
    statusLabel.Size               = UDim2.new(1, -80, 0, 18)
    statusLabel.Position           = UDim2.new(0, 20, 0, 64)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font               = Enum.Font.Gotham
    statusLabel.Text               = "Initializing"
    statusLabel.TextSize           = 11
    statusLabel.TextColor3         = Color3.fromHex("#7A7AA8")
    statusLabel.TextXAlignment     = Enum.TextXAlignment.Left
    statusLabel.ZIndex             = 11

    local pctLabel = Instance.new("TextLabel", frame)
    pctLabel.Size               = UDim2.new(0, 55, 0, 18)
    pctLabel.Position           = UDim2.new(1, -75, 0, 64)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Font               = Enum.Font.GothamBold
    pctLabel.Text               = "0%"
    pctLabel.TextSize           = 11
    pctLabel.TextColor3         = accent
    pctLabel.TextXAlignment     = Enum.TextXAlignment.Right
    pctLabel.ZIndex             = 11

    local bar = Instance.new("Frame", frame)
    bar.Size             = UDim2.new(1, -40, 0, 3)
    bar.Position         = UDim2.new(0, 20, 0, 86)
    bar.BackgroundColor3 = Color3.fromHex("#1A1A30")
    bar.BorderSizePixel  = 0
    bar.ZIndex           = 11
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", bar)
    fill.Size             = UDim2.new(0, 0, 1, 0)
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

    local function tween(obj, t, props)
        return TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Sine), props)
    end

    local function setStatus(text)
        tween(statusLabel, 0.1, {TextTransparency = 1}):Play()
        task.delay(0.05, function()
            if not statusLabel or not statusLabel.Parent then return end
            statusLabel.Text = text
            tween(statusLabel, 0.1, {TextTransparency = 0}):Play()
        end)
    end

    local function setPct(p)
        local n = math.floor(p * 100)
        pctLabel.Text = n .. "%"
        tween(fill, 0.12, {Size = UDim2.new(p, 0, 1, 0)}):Play()
    end

    local function fadeOut(delay, cb)
        task.delay(delay, function()
            tween(frame, 0.3, {BackgroundTransparency = 1, Size = UDim2.new(0, W, 0, 0)}):Play()
            tween(border, 0.3, {Thickness = 0}):Play()
            task.wait(0.35)
            gui:Destroy()
            if cb then cb() end
        end)
    end

    TweenService:Create(frame,
        TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, W, 0, H) }
    ):Play()
    task.wait(0.55)

    if scriptRaw == "" then
        setPct(1)
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
