local RunService   = game:GetService("RunService")
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Library = {}

local function tween(obj, t, props)
    return TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Sine), props)
end

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

    local W, H = 380, 148
    local supported = scriptRaw ~= ""

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
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

    local grad = Instance.new("UIGradient", frame)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#111128")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#0D0D1A")),
    })
    grad.Rotation = 90

    local border = Instance.new("UIStroke", frame)
    border.Color     = Color3.fromHex("#1E1E38")
    border.Thickness = 1

    -- Dots container
    local dots = Instance.new("Frame", frame)
    dots.Size               = UDim2.new(0, 36, 0, 8)
    dots.Position           = UDim2.new(0.5, -18, 0, 22)
    dots.BackgroundTransparency = 1
    dots.ZIndex             = 12

    for i = 1, 3 do
        local d = Instance.new("Frame", dots)
        d.Size             = UDim2.new(0, 7, 0, 7)
        d.Position         = UDim2.new(0, (i - 1) * 14, 0, 0)
        d.BackgroundColor3 = accent
        d.BorderSizePixel  = 0
        d.ZIndex           = 13
        Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)

        local dg = Instance.new("Frame", d)
        dg.Size               = UDim2.new(2.5, 0, 2.5, 0)
        dg.Position           = UDim2.new(-0.75, 0, -0.75, 0)
        dg.BackgroundColor3   = accent
        dg.BackgroundTransparency = 0.6
        dg.BorderSizePixel    = 0
        dg.ZIndex             = 12
        Instance.new("UICorner", dg).CornerRadius = UDim.new(1, 0)

        task.spawn(function()
            local waitTime = i > 1 and (i - 1) * 0.2 or 0
            task.wait(waitTime)
            local scale = Instance.new("UIScale", d)
            local glow = dg
            while d and d.Parent do
                tween(scale, 0.5, {Scale = 1.6}):Play()
                if glow and glow.Parent then tween(glow, 0.5, {BackgroundTransparency = 0.35}):Play() end
                task.wait(0.5)
                tween(scale, 0.5, {Scale = 1}):Play()
                if glow and glow.Parent then tween(glow, 0.5, {BackgroundTransparency = 0.6}):Play() end
                task.wait(0.5)
            end
        end)
    end

    local title = Instance.new("TextLabel", frame)
    title.Size               = UDim2.new(1, -40, 0, 20)
    title.Position           = UDim2.new(0, 20, 0, 44)
    title.BackgroundTransparency = 1
    title.Font               = Enum.Font.GothamBold
    title.Text               = "Meyy Hub"
    title.TextSize           = 16
    title.TextColor3         = Color3.fromHex("#EEEEFF")
    title.TextXAlignment     = Enum.TextXAlignment.Center
    title.ZIndex             = 11

    local gameLabel = Instance.new("TextLabel", frame)
    gameLabel.Size               = UDim2.new(1, -40, 0, 16)
    gameLabel.Position           = UDim2.new(0, 20, 0, 66)
    gameLabel.BackgroundTransparency = 1
    gameLabel.Font               = Enum.Font.Gotham
    gameLabel.Text               = gameName
    gameLabel.TextSize           = 12
    gameLabel.TextColor3         = Color3.fromHex("#6B6B9A")
    gameLabel.TextXAlignment     = Enum.TextXAlignment.Center
    gameLabel.ZIndex             = 11

    if version ~= "" then
        local vtag = Instance.new("Frame", frame)
        vtag.Size               = UDim2.new(0, 54, 0, 18)
        vtag.Position           = UDim2.new(0.5, -27, 0, 84)
        vtag.BackgroundColor3   = Color3.fromHex("#181830")
        vtag.BorderSizePixel    = 0
        vtag.ZIndex             = 12
        Instance.new("UICorner", vtag).CornerRadius = UDim.new(0, 5)
        local vb = Instance.new("UIStroke", vtag)
        vb.Color = Color3.fromHex("#282848")
        vb.Thickness = 1
        local vl = Instance.new("TextLabel", vtag)
        vl.Size               = UDim2.new(1, 0, 1, 0)
        vl.BackgroundTransparency = 1
        vl.Font               = Enum.Font.Gotham
        vl.Text               = version
        vl.TextSize           = 9
        vl.TextColor3         = Color3.fromHex("#7A7AA8")
        vl.TextXAlignment     = Enum.TextXAlignment.Center
        vl.ZIndex             = 13
    end

    local statusLabel = Instance.new("TextLabel", frame)
    statusLabel.Size               = UDim2.new(1, -40, 0, 16)
    statusLabel.Position           = UDim2.new(0, 20, 0, supported and 106 or 106)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font               = Enum.Font.Gotham
    statusLabel.Text               = supported and "Initializing..." or "Game not supported"
    statusLabel.TextSize           = 11
    statusLabel.TextColor3         = supported and Color3.fromHex("#6B6B9A") or Color3.fromHex("#505080")
    statusLabel.TextXAlignment     = Enum.TextXAlignment.Center
    statusLabel.ZIndex             = 11

    if supported then
        local progressFrame = Instance.new("Frame", frame)
        progressFrame.Size               = UDim2.new(1, -48, 0, 3)
        progressFrame.Position           = UDim2.new(0, 24, 0, 126)
        progressFrame.BackgroundColor3   = Color3.fromHex("#1A1A32")
        progressFrame.BorderSizePixel    = 0
        progressFrame.ZIndex             = 11
        Instance.new("UICorner", progressFrame).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame", progressFrame)
        fill.Size             = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = accent
        fill.BorderSizePixel  = 0
        fill.ZIndex           = 12
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local pctLabel = Instance.new("TextLabel", frame)
        pctLabel.Size               = UDim2.new(0, 60, 0, 16)
        pctLabel.Position           = UDim2.new(1, -80, 0, 106)
        pctLabel.BackgroundTransparency = 1
        pctLabel.Font               = Enum.Font.GothamBold
        pctLabel.Text               = "0%"
        pctLabel.TextSize           = 11
        pctLabel.TextColor3         = accent
        pctLabel.TextXAlignment     = Enum.TextXAlignment.Right
        pctLabel.ZIndex             = 11

        local function setStatus(text)
            tween(statusLabel, 0.15, {TextTransparency = 1}):Play()
            task.delay(0.08, function()
                if not statusLabel or not statusLabel.Parent then return end
                statusLabel.Text = text
                tween(statusLabel, 0.15, {TextTransparency = 0}):Play()
            end)
        end

        TweenService:Create(frame,
            TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Size = UDim2.new(0, W, 0, H) }
        ):Play()
        task.wait(0.65)

        local startTime = tick()
        local stepIdx   = 0
        local conn

        conn = RunService.Heartbeat:Connect(function()
            local p = math.min((tick() - startTime) / duration, 1)
            local n = math.floor(p * 100)
            pctLabel.Text = n .. "%"
            tween(fill, 0.15, {Size = UDim2.new(p, 0, 1, 0)}):Play()

            for i = 1, #steps do
                if p >= steps[i].at and stepIdx < i then
                    stepIdx = i
                    setStatus(steps[i].text)
                end
            end

            if p >= 1 then
                conn:Disconnect()
                pctLabel.Text = "100%"
                fill.Size = UDim2.new(1, 0, 1, 0)
                statusLabel.Text = "Ready"
                statusLabel.TextColor3 = Color3.fromHex("#00D68F")
                pctLabel.TextColor3 = Color3.fromHex("#00D68F")

                task.wait(0.8)
                tween(frame, 0.35, {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, W, 0, 0),
                }):Play()
                tween(border, 0.35, {Thickness = 0}):Play()
                task.wait(0.4)
                gui:Destroy()

                local ok, err = pcall(function()
                    loadstring(game:HttpGet(scriptRaw, true))()
                end)
                if not ok then onError(err) end
            end
        end)
    else
        TweenService:Create(frame,
            TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Size = UDim2.new(0, W, 0, H) }
        ):Play()
        task.wait(2.5)
        tween(frame, 0.35, {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, W, 0, 0),
        }):Play()
        tween(border, 0.35, {Thickness = 0}):Play()
        task.wait(0.4)
        gui:Destroy()
    end
end

return Library
