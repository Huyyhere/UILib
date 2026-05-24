local RunService   = game:GetService("RunService")
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Library = {}

function Library:CreateLoader(config)
    config = config or {}
    local gameName = config.GameName or "Game Script"
    local scriptRaw = config.ScriptRaw or ""
    
    local old = CoreGui:FindFirstChild("MeyyHubLoader")
    if old then old:Destroy() end

    local Blue  = Color3.fromRGB(59, 130, 246)
    local Green = Color3.fromRGB(34, 197, 94)
    local Red   = Color3.fromRGB(239, 68, 68)
    local White = Color3.fromRGB(255, 255, 255)
    local Gray  = Color3.fromRGB(150, 150, 150)
    local Dark  = Color3.fromRGB(25, 25, 25)
    local Track = Color3.fromRGB(45, 45, 45)

    local gui = Instance.new("ScreenGui")
    gui.Name = "MeyyHubLoader"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = CoreGui

    local card = Instance.new("Frame", gui)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position    = UDim2.new(0.5, 0, 0.5, 0)
    card.Size        = UDim2.new(0, 300, 0, 80)
    card.BackgroundColor3 = Dark
    card.BorderSizePixel  = 0

    local cc = Instance.new("UICorner", card); cc.CornerRadius = UDim.new(0, 8)

    local canvas = Instance.new("CanvasGroup", card)
    canvas.Size = UDim2.new(1, 0, 1, 0)
    canvas.BackgroundTransparency = 1

    local dot = Instance.new("Frame", canvas)
    dot.Position = UDim2.new(0, 15, 0, 20)
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.BackgroundColor3 = Blue
    dot.BorderSizePixel = 0
    local dc = Instance.new("UICorner", dot); dc.CornerRadius = UDim.new(1, 0)

    local titleLbl = Instance.new("TextLabel", canvas)
    titleLbl.Position = UDim2.new(0, 32, 0, 10)
    titleLbl.Size = UDim2.new(1, -47, 0, 16)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "Meyy Hub - " .. gameName
    titleLbl.TextSize = 14
    titleLbl.Font = Enum.Font.SourceSansBold
    titleLbl.TextColor3 = White
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local subLbl = Instance.new("TextLabel", canvas)
    subLbl.Position = UDim2.new(0, 32, 0, 28)
    subLbl.Size = UDim2.new(1, -47, 0, 14)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = "Checking configuration..."
    subLbl.TextSize = 12
    subLbl.Font = Enum.Font.SourceSans
    subLbl.TextColor3 = Gray
    subLbl.TextXAlignment = Enum.TextXAlignment.Left

    local barBG = Instance.new("Frame", canvas)
    barBG.Position = UDim2.new(0, 15, 0, 54)
    barBG.Size = UDim2.new(1, -30, 0, 4)
    barBG.BackgroundColor3 = Track
    barBG.BorderSizePixel = 0
    local bbc = Instance.new("UICorner", barBG); bbc.CornerRadius = UDim.new(1, 0)

    local barFill = Instance.new("Frame", barBG)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Blue
    barFill.BorderSizePixel = 0
    local bfc = Instance.new("UICorner", barFill); bfc.CornerRadius = UDim.new(1, 0)

    local function fadeOutAndDestroy(delayTime)
        task.delay(delayTime, function()
            local fadeTween = TweenService:Create(canvas, TweenInfo.new(0.4), {GroupTransparency = 1})
            fadeTween.Completed:Connect(function()
                gui:Destroy()
            end)
            fadeTween:Play()
        end)
    end

    if scriptRaw == "" then
        task.wait(0.1)
        dot.BackgroundColor3 = Red
        barFill.BackgroundColor3 = Red
        barFill.Size = UDim2.new(1, 0, 1, 0)
        subLbl.TextColor3 = Red
        subLbl.Text = "Game not supported!"
        fadeOutAndDestroy(4.0)
        return
    end

    local startTime = tick()
    local duration  = 2.5
    local connection

    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / duration, 1)
        
        barFill.Size = UDim2.new(progress, 0, 1, 0)

        if progress > 0.3 and progress < 0.7 then
            subLbl.Text = "Downloading script data..."
        elseif progress >= 0.7 and progress < 1 then
            subLbl.Text = "Opening interface..."
        end

        if progress >= 1 then
            connection:Disconnect()

            dot.BackgroundColor3 = Green
            barFill.BackgroundColor3 = Green
            subLbl.TextColor3 = Green
            subLbl.Text = "Loaded successfully!"

            task.delay(0.5, function()
                local exitTween = TweenService:Create(canvas, TweenInfo.new(0.3), {GroupTransparency = 1})
                exitTween.Completed:Connect(function()
                    gui:Destroy()
                    
                    local ok, err = pcall(function()
                        loadstring(game:HttpGet(scriptRaw, true))()
                    end)
                    if not ok then warn("[Meyy Hub Error]:", err) end
                end)
                exitTween:Play()
            end)
        end
    end)
end

return Library
