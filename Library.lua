local RunService   = game:GetService("RunService")
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local Library = {}

function Library:CreateLoader(config)
    config = config or {}
    local gameName = config.GameName or "Unknown Game"
    local scriptRaw = config.ScriptRaw or ""
    
    local old = CoreGui:FindFirstChild("MeyyHubLoader")
    if old then old:Destroy() end

    local NeonBlue  = Color3.fromRGB(0, 170, 255)
    local SuccGreen = Color3.fromRGB(10, 230, 130)
    local FailRed   = Color3.fromRGB(255, 65, 90)
    local PureWhite = Color3.fromRGB(255, 255, 255)
    local MutedGray = Color3.fromRGB(135, 145, 165)
    local DarkBG    = Color3.fromRGB(10, 12, 18)
    local BarTrack  = Color3.fromRGB(20, 24, 35)

    local gui = Instance.new("ScreenGui")
    gui.Name = "MeyyHubLoader"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui

    local card = Instance.new("Frame", gui)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position    = UDim2.new(0.5, 0, 0.5, 0)
    card.Size        = UDim2.new(0, 330, 0, 90)
    card.BackgroundColor3 = DarkBG
    card.BorderSizePixel  = 0

    local cc = Instance.new("UICorner", card); cc.CornerRadius = UDim.new(0, 14)

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = NeonBlue
    stroke.Thickness = 1
    stroke.Transparency = 0.8

    local canvas = Instance.new("CanvasGroup", card)
    canvas.Size = UDim2.new(1, 0, 1, 0)
    canvas.BackgroundTransparency = 1

    local dot = Instance.new("Frame", canvas)
    dot.Position = UDim2.new(0, 20, 0, 24)
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.BackgroundColor3 = NeonBlue
    dot.BorderSizePixel = 0
    local dc = Instance.new("UICorner", dot); dc.CornerRadius = UDim.new(1, 0)

    local dotGlow = Instance.new("UIStroke", dot)
    dotGlow.Color = NeonBlue
    dotGlow.Thickness = 3
    dotGlow.Transparency = 0.6

    local titleLbl = Instance.new("TextLabel", canvas)
    titleLbl.Position = UDim2.new(0, 36, 0, 12)
    titleLbl.Size = UDim2.new(1, -56, 0, 18)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "Meyy Hub  •  " .. gameName
    titleLbl.TextSize = 14
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextColor3 = PureWhite
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local subLbl = Instance.new("TextLabel", canvas)
    subLbl.Position = UDim2.new(0, 36, 0, 32)
    subLbl.Size = UDim2.new(1, -56, 0, 14)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = "Verifying secure handshake..."
    subLbl.TextSize = 11
    subLbl.Font = Enum.Font.GothamMedium
    subLbl.TextColor3 = MutedGray
    subLbl.TextXAlignment = Enum.TextXAlignment.Left

    local barBG = Instance.new("Frame", canvas)
    barBG.Position = UDim2.new(0, 20, 0, 64)
    barBG.Size = UDim2.new(1, -40, 0, 4)
    barBG.BackgroundColor3 = BarTrack
    barBG.BorderSizePixel = 0
    local bbc = Instance.new("UICorner", barBG); bbc.CornerRadius = UDim.new(1, 0)

    local barFill = Instance.new("Frame", barBG)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = NeonBlue
    barFill.BorderSizePixel = 0
    local bfc = Instance.new("UICorner", barFill); bfc.CornerRadius = UDim.new(1, 0)

    local shimmer = Instance.new("Frame", barFill)
    shimmer.Size = UDim2.new(0, 80, 1, 0)
    shimmer.Position = UDim2.new(-0.3, 0, 0, 0)
    shimmer.BorderSizePixel = 0
    shimmer.BackgroundTransparency = 0.7

    local uigradient = Instance.new("UIGradient", shimmer)
    uigradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, NeonBlue),
        ColorSequenceKeypoint.new(0.5, PureWhite),
        ColorSequenceKeypoint.new(1, NeonBlue)
    })

    local shimmerThread = task.spawn(function()
        while card.Parent do
            shimmer.Position = UDim2.new(-0.5, 0, 0, 0)
            local tween = TweenService:Create(shimmer, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Position = UDim2.new(1.5, 0, 0, 0)})
            tween:Play()
            tween.Completed:Wait()
        end
    end)

    local function fadeOutAndDestroy(delayTime)
        task.delay(delayTime, function()
            local fadeTween = TweenService:Create(canvas, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 1})
            fadeTween.Completed:Connect(function()
                gui:Destroy()
            end)
            fadeTween:Play()
        end)
    end

    if scriptRaw == "" then
        task.wait(0.2)
        local errTween = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        TweenService:Create(dot, errTween, {BackgroundColor3 = FailRed}):Play()
        TweenService:Create(dotGlow, errTween, {Color = FailRed}):Play()
        TweenService:Create(stroke, errTween, {Color = FailRed}):Play()
        TweenService:Create(barFill, errTween, {BackgroundColor3 = FailRed}):Play()
        TweenService:Create(subLbl, errTween, {TextColor3 = FailRed}):Play()
        
        barFill:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Cubic, 0.4, true)
        subLbl.Text = "No script path provided for this game!"
        
        fadeOutAndDestroy(5.0)
        return
    end

    local startTime = tick()
    local duration  = 3.2
    local connection

    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local rawProgress = math.min(elapsed / duration, 1)
        
        local smoothProgress = 1 - math.pow(1 - rawProgress, 3) 
        barFill.Size = UDim2.new(smoothProgress, 0, 1, 0)

        if rawProgress > 0.35 and rawProgress < 0.75 then
            subLbl.Text = "Bypassing anti-cheat systems..."
        elseif rawProgress >= 0.75 and rawProgress < 1 then
            subLbl.Text = "Injecting virtual machine environment..."
        end

        if rawProgress >= 1 then
            connection:Disconnect()

            local successTween = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(dot, successTween, {BackgroundColor3 = SuccGreen}):Play()
            TweenService:Create(dotGlow, successTween, {Color = SuccGreen}):Play()
            TweenService:Create(stroke, successTween, {Color = SuccGreen}):Play()
            TweenService:Create(barFill, successTween, {BackgroundColor3 = SuccGreen}):Play()
            TweenService:Create(subLbl, successTween, {TextColor3 = SuccGreen}):Play()
            
            subLbl.Text = "Execution environment verified successfully!"

            task.delay(0.8, function()
                local exitTween = TweenService:Create(canvas, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 1})
                exitTween.Completed:Connect(function()
                    gui:Destroy()
                    
                    local ok, err = pcall(function()
                        loadstring(game:HttpGet(scriptRaw, true))()
                    end)
                    if not ok then warn("[Meyy Hub Runtime Error]:", err) end
                end)
                exitTween:Play()
            end)
        end
    end)
end

return Library
