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

    local W, H = 420, 112
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
    frame.BackgroundColor3       = Color3.fromHex("#0E0E1C")
    frame.BorderSizePixel        = 0
    frame.ClipsDescendants       = true
    frame.ZIndex                 = 10
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local border = Instance.new("UIStroke", frame)
    border.Color     = Color3.fromHex("#1E1E3A")
    border.Thickness = 1

    local title = Instance.new("TextLabel", frame)
    title.Size               = UDim2.new(1, -40, 0, 24)
    title.Position           = UDim2.new(0, 20, 0, 18)
    title.BackgroundTransparency = 1
    title.Font               = Enum.Font.GothamBold
    title.Text               = "Meyy Hub"
    title.TextSize           = 16
    title.TextColor3         = Color3.fromHex("#EEEEFF")
    title.TextXAlignment     = Enum.TextXAlignment.Left
    title.ZIndex             = 11

    local gameLabel = Instance.new("TextLabel", frame)
    gameLabel.Size               = UDim2.new(1, -40, 0, 16)
    gameLabel.Position           = UDim2.new(0, 20, 0, 44)
    gameLabel.BackgroundTransparency = 1
    gameLabel.Font               = Enum.Font.Gotham
    gameLabel.Text               = gameName
    gameLabel.TextSize           = 12
    gameLabel.TextColor3         = Color3.fromHex("#7A7AA8")
    gameLabel.TextXAlignment     = Enum.TextXAlignment.Left
    gameLabel.ZIndex             = 11

    local statusLabel = Instance.new("TextLabel", frame)
    statusLabel.Size               = UDim2.new(1, -80, 0, 20)
    statusLabel.Position           = UDim2.new(0, 20, 0, 72)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font               = Enum.Font.Gotham
    statusLabel.Text               = supported and "Initializing" or "Unsupported game"
    statusLabel.TextSize           = 12
    statusLabel.TextColor3         = supported and Color3.fromHex("#7A7AA8") or Color3.fromHex("#505080")
    statusLabel.TextXAlignment     = Enum.TextXAlignment.Left
    statusLabel.ZIndex             = 11

    local pctLabel = Instance.new("TextLabel", frame)
    pctLabel.Size               = UDim2.new(0, 55, 0, 20)
    pctLabel.Position           = UDim2.new(1, -75, 0, 72)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Font               = Enum.Font.GothamBold
    pctLabel.Text               = supported and "0%" or "—"
    pctLabel.TextSize           = 12
    pctLabel.TextColor3         = supported and accent or Color3.fromHex("#505080")
    pctLabel.TextXAlignment     = Enum.TextXAlignment.Right
    pctLabel.ZIndex             = 11

    local function tween(obj, t, props)
        return TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Sine), props)
    end

    local function setStatus(text)
        tween(statusLabel, 0.15, {TextTransparency = 1}):Play()
        task.delay(0.08, function()
            if not statusLabel or not statusLabel.Parent then return end
            statusLabel.Text = text
            tween(statusLabel, 0.15, {TextTransparency = 0}):Play()
        end)
    end

    local function fadeOut(delay, cb)
        task.delay(delay, function()
            tween(frame, 0.35, {BackgroundTransparency = 1, Size = UDim2.new(0, W, 0, 0)}):Play()
            tween(border, 0.35, {Thickness = 0}):Play()
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

    if not supported then
        task.wait(2)
        fadeOut()
        return
    end

    local startTime = tick()
    local stepIdx   = 0
    local conn

    conn = RunService.Heartbeat:Connect(function()
        local p = math.min((tick() - startTime) / duration, 1)
        local n = math.floor(p * 100)
        pctLabel.Text = n .. "%"
        tween(pctLabel, 0.08, {TextColor3 = accent}):Play()
        task.delay(0.12, function()
            if pctLabel and pctLabel.Parent then
                tween(pctLabel, 0.15, {TextColor3 = Color3.fromHex("#7A7AA8")}):Play()
            end
        end)

        for i = 1, #steps do
            if p >= steps[i].at and stepIdx < i then
                stepIdx = i
                setStatus(steps[i].text)
            end
        end

        if p >= 1 then
            conn:Disconnect()
            local n2 = 100
            pctLabel.Text = n2 .. "%"
            pctLabel.TextColor3 = Color3.fromHex("#00D68F")
            statusLabel.TextColor3 = Color3.fromHex("#00D68F")
            statusLabel.Text = "Ready"
            fadeOut(1.2, function()
                local ok, err = pcall(function()
                    loadstring(game:HttpGet(scriptRaw, true))()
                end)
                if not ok then onError(err) end
            end)
        end
    end)
end

return Library
