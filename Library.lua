-- [[
    SNOWY UI | ULTIMATE WEB-PARITY ROBLOX LIBRARY
    VERSION: 1.4.0 (PREMIUM RELEASE)
    Converted from React/Next.js Design System
]]

local Library = {
    Tabs = {},
    Unloaded = false,
}

-- [[ Services ]]
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- [[ Variables ]]
local Viewport = workspace.CurrentCamera.ViewportSize
local BaseRes = Vector2.new(1920, 1080)
local Scaling = math.min(Viewport.X / BaseRes.X, Viewport.Y / BaseRes.Y) * 1.05

-- [[ Theme Configuration ]]
local Theme = {
    Main = Color3.fromRGB(8, 8, 8),
    Accent = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(255, 255, 255),
    
    -- Opacity System (Mapped to Tailwind Utility classes)
    BgTrans = 0.97,       -- bg-white/[0.03]
    HoverBgTrans = 0.94,  -- bg-white/[0.06]
    BorderTrans = 0.90,   -- border-white/10
    HeaderTrans = 0.98,   -- bg-white/[0.02]
    
    -- Fonts
    Font = Enum.Font.BuilderSansExtraBold, -- Heading
    FontSemi = Enum.Font.BuilderSansMedium, -- Body
    
    -- Animations
    Default = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Fast = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
}

-- [[ Utility Functions ]]
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    inst.Parent = props.Parent
    return inst
end

local function Tween(obj, info, goal)
    local t = TweenService:Create(obj, info, goal)
    t:Play()
    return t
end

-- Proper Shadow Image Generator
local function AddShadow(parent, trans)
    return Create("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 40, 1, 40),
        ZIndex = -1,
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = trans or 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        Parent = parent
    })
end

-- [[ Component Factory ]]
function Library:CreateWindow(title, version)
    local SnowyUI = Create("ScreenGui", {
        Name = "SnowyUI_Ultimate",
        ResetOnSpawn = false,
        DisplayOrder = 100,
        Parent = CoreGui
    })

    local RootScale = Create("UIScale", {
        Scale = Scaling,
        Parent = SnowyUI
    })

    -- Draggable State
    local Dragging, DragInput, DragStart, StartPos

    local Main = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 660, 0, 480),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Main,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = SnowyUI
    })

    Create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = Main})
    Create("UIStroke", {
        Thickness = 1.3,
        Color = Theme.Accent,
        Transparency = Theme.BorderTrans,
        Parent = Main
    })

    AddShadow(Main, 0.6)

    -- Header (Glass Layer)
    local Header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundTransparency = Theme.HeaderTrans,
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = Main
    })

    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -48, 1, 0),
        Position = UDim2.new(0, 24, 0, 0),
        BackgroundTransparency = 1,
        Text = string.upper(title),
        TextColor3 = Theme.Text,
        TextTransparency = 0.5,
        TextSize = 10,
        Font = Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })

    -- Navigation Container
    local ContentFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 1, -56),
        Position = UDim2.new(0, 0, 0, 56),
        BackgroundTransparency = 1,
        Parent = Main
    })

    local Sidebar = Create("Frame", {
        Size = UDim2.new(0, 180, 1, 0),
        BackgroundTransparency = 1,
        Parent = ContentFrame
    })

    local SidebarLine = Create("Frame", {
        Size = UDim2.new(0, 1, 0.85, 0),
        Position = UDim2.new(1, 0, 0.075, 0),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.97,
        BorderSizePixel = 0,
        Parent = Sidebar
    })

    local ContentArea = Create("Frame", {
        Size = UDim2.new(1, -180, 1, 0),
        Position = UDim2.new(0, 180, 0, 0),
        BackgroundTransparency = 1,
        Parent = ContentFrame
    })

    local TabList = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -40),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        Parent = Sidebar
    })

    Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = TabList
    })

    -- Dragging Handler
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging, DragStart, StartPos = true, input.Position, Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = input.Position - DragStart
            Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)

    local Tabs = {Current = nil}

    function Tabs:CreateTab(name)
        local TabBtn = Create("TextButton", {
            Name = name,
            Size = UDim2.new(0.85, 0, 0, 36),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            Parent = TabList
        })

        local TabText = Create("TextLabel", {
            Size = UDim2.new(1, -14, 1, 0),
            Position = UDim2.new(0, 14, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Theme.Text,
            TextTransparency = 0.7,
            TextSize = 11,
            Font = Theme.FontSemi,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabBtn
        })

        local Indicator = Create("Frame", {
            Size = UDim2.new(0, 2, 0, 0),
            Position = UDim2.new(0, -2, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            Parent = TabBtn
        })

        local TabPage = Create("ScrollingFrame", {
            Name = name .. "_Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 1.5,
            ScrollBarImageTransparency = 0.9,
            Visible = false,
            Parent = ContentArea
        })

        Create("UIListLayout", {Padding = UDim.new(0, 16), HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = TabPage})
        Create("UIPadding", {PaddingTop = UDim.new(0, 30), PaddingBottom = UDim.new(0, 30), Parent = TabPage})

        local function Switch()
            if Tabs.Current == TabPage then return end
            if Tabs.Current then
                Tabs.Current.Visible = false
                Tween(Tabs.CurrentBtn.TextLabel, Theme.Default, {TextTransparency = 0.7})
                Tween(Tabs.CurrentBtn.Frame, Theme.Default, {Size = UDim2.new(0, 2, 0, 0)})
            end
            Tabs.Current = TabPage
            Tabs.CurrentBtn = TabBtn
            TabPage.Visible = true
            Tween(TabText, Theme.Default, {TextTransparency = 0})
            Tween(Indicator, Theme.Default, {Size = UDim2.new(0, 2, 0.5, 0)})
        end

        TabBtn.MouseButton1Click:Connect(Switch)
        if not Tabs.Current then Switch() end

        local Sections = {}

        function Sections:CreateSection(label)
            local Section = Create("Frame", {
                Size = UDim2.new(0.9, 0, 0, 0),
                BackgroundTransparency = 1,
                Parent = TabPage
            })

            local SecLayout = Create("UIListLayout", {Padding = UDim.new(0, 10), Parent = Section})
            
            local SecHead = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundTransparency = 1,
                Parent = Section
            })

            Create("TextLabel", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = string.upper(label),
                TextColor3 = Theme.Accent,
                TextTransparency = 0.75,
                TextSize = 9.5,
                Font = Theme.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SecHead
            })

            Create("Frame", {
                Size = UDim2.new(1, -110, 0, 1),
                Position = UDim2.new(0, 120, 0.5, 0),
                BackgroundColor3 = Theme.Accent,
                BackgroundTransparency = 0.97,
                BorderSizePixel = 0,
                Parent = SecHead
            })

            SecLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Section.Size = UDim2.new(0.9, 0, 0, SecLayout.AbsoluteContentSize.Y)
            end)

            local Items = {}

            -- [[ Toggle Component ]]
            function Items:CreateToggle(title, desc, default, callback)
                local Tgl = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 56),
                    BackgroundColor3 = Theme.Accent,
                    BackgroundTransparency = Theme.BgTrans,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = Section
                })

                Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Tgl})
                Create("UIStroke", {Thickness = 1, Color = Theme.Accent, Transparency = Theme.BorderTrans, Parent = Tgl})

                local Title = Create("TextLabel", {
                    Size = UDim2.new(1, -70, 0, 20),
                    Position = UDim2.new(0, 18, 0, desc and 12 or 18),
                    BackgroundTransparency = 1,
                    Text = title,
                    TextColor3 = Theme.Text,
                    TextTransparency = 0.2,
                    TextSize = 12,
                    Font = Theme.Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Tgl
                })

                if desc then
                    Create("TextLabel", {
                        Size = UDim2.new(1, -70, 0, 16),
                        Position = UDim2.new(0, 18, 0, 30),
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Theme.Text,
                        TextTransparency = 0.75,
                        TextSize = 10,
                        Font = Theme.FontSemi,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = Tgl
                    })
                    Tgl.Size = UDim2.new(1, 0, 0, 64)
                end

                local Sw = Create("Frame", {
                    Size = UDim2.new(0, 34, 0, 19),
                    Position = UDim2.new(1, -52, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                    Parent = Tgl
                })
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Sw})
                
                local Dot = Create("Frame", {
                    Size = UDim2.new(0, 13, 0, 13),
                    Position = UDim2.new(0, 3, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromRGB(150, 150, 155),
                    Parent = Sw
                })
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Dot})

                local Active = default or false
                local function Update()
                    Tween(Sw, Theme.Default, {BackgroundColor3 = Active and Theme.Accent or Color3.fromRGB(35, 35, 40)})
                    Tween(Dot, Theme.Default, {
                        Position = UDim2.new(0, Active and 18 or 3, 0.5, 0),
                        BackgroundColor3 = Active and Color3.fromRGB(0,0,0) or Color3.fromRGB(150, 150, 155)
                    })
                    callback(Active)
                end

                Tgl.MouseButton1Click:Connect(function() Active = not Active Update() end)
                Tgl.MouseEnter:Connect(function() Tween(Tgl, Theme.Fast, {BackgroundTransparency = Theme.HoverBgTrans}) end)
                Tgl.MouseLeave:Connect(function() Tween(Tgl, Theme.Fast, {BackgroundTransparency = Theme.BgTrans}) end)
                Update()
            end

            -- [[ Button Component ]]
            function Items:CreateButton(title, desc, callback)
                local Btn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 52),
                    BackgroundColor3 = Theme.Accent,
                    BackgroundTransparency = Theme.BgTrans,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = Section
                })

                Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Btn})
                Create("UIStroke", {Thickness = 1, Color = Theme.Accent, Transparency = Theme.BorderTrans, Parent = Btn})

                local Title = Create("TextLabel", {
                    Size = UDim2.new(1, -40, 1, 0),
                    Position = UDim2.new(0, 18, 0, 0),
                    BackgroundTransparency = 1,
                    Text = string.upper(title),
                    TextColor3 = Theme.Text,
                    TextTransparency = 0.2,
                    TextSize = 10,
                    Font = Theme.Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Btn
                })

                Btn.MouseEnter:Connect(function() Tween(Btn, Theme.Fast, {BackgroundTransparency = Theme.HoverBgTrans}) end)
                Btn.MouseLeave:Connect(function() Tween(Btn, Theme.Fast, {BackgroundTransparency = Theme.BgTrans}) end)
                Btn.MouseButton1Click:Connect(callback)
            end

            return Items
        end
        return Sections
    end
    return Tabs
end

return Library
