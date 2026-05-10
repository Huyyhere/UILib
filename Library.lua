local Library = {}
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local UI_Elements = {
	AnimatedGradients = {},
	AnimatedStrokes = {},
	RowStrokes = {},
	RowStrokeGradients = {},
	DivGradients = {},
	TabGradients = {},
	Switches = {}
}

local CurrentTheme = "Sakura"
local Notifications = {}

local Themes = {
	["Moonlight"] = {
		MainStroke = Color3.fromRGB(180, 180, 180),
		Wave = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 40)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 240)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 40))
		}),
		TitleStroke = Color3.fromRGB(150, 150, 150),
		TextGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
		}),
		TabGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150))
		}),
		DivGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 200)),
			ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
		}),
		RowStroke = Color3.fromRGB(100, 100, 100),
		RowStrokeGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150))
		}),
		ToggleActive = Color3.fromRGB(200, 200, 200),
		LoopSeq = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150))
		})
	},
	["Sakura"] = {
		MainStroke = Color3.fromRGB(255, 235, 240),
		Wave = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 240, 240)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 120, 120)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 140, 140))
		}),
		TitleStroke = Color3.fromRGB(255, 235, 240),
		TextGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 210, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 235, 240))
		}),
		TabGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 210, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 235, 240))
		}),
		DivGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 250, 250)),
			ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
		}),
		RowStroke = Color3.new(1, 1, 1),
		RowStrokeGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 210, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 235, 240))
		}),
		ToggleActive = Color3.fromRGB(255, 235, 240),
		LoopSeq = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 240, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 240, 245))
		})
	},
	["Blue"] = {
		MainStroke = Color3.new(1, 1, 1),
		Wave = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 180)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 120, 120)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 140, 140))
		}),
		TitleStroke = Color3.fromRGB(130, 190, 250),
		TextGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 180, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 240, 255))
		}),
		TabGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 180, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 240, 255))
		}),
		DivGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 220, 255)),
			ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
		}),
		RowStroke = Color3.new(1, 1, 1),
		RowStrokeGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 180, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 240, 255))
		}),
		ToggleActive = Color3.fromRGB(100, 180, 255),
		LoopSeq = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 230, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 230, 255))
		})
	}
}

-- ============================================================
-- NOTIFICATION
-- ============================================================
function Library:SendNotification(titleText, descText)
	local g2 = Instance.new("ScreenGui")
	g2.Name = "UI_Cloud_Notification_" .. math.random(100, 999)
	g2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function() g2.Parent = CoreGui end)
	if not g2.Parent then g2.Parent = LocalPlayer:WaitForChild("PlayerGui") end

	local m2 = Instance.new("Frame", g2)
	m2.Name = "Main"
	m2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	m2.BackgroundTransparency = 0.3
	m2.Size = UDim2.new(0, 260, 0, 80)
	m2.AnchorPoint = Vector2.new(1, 1)
	m2.Position = UDim2.new(1, 50, 1, -20)
	Instance.new("UICorner", m2).CornerRadius = UDim.new(0, 10)

	local u2 = Instance.new("UIStroke", m2)
	u2.Thickness = 2.5
	u2.Color = Themes[CurrentTheme].MainStroke
	local e2 = Instance.new("UIGradient", u2)
	e2.Color = Themes[CurrentTheme].LoopSeq

	local bgGradient = Instance.new("UIGradient", m2)
	bgGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 248, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(224, 240, 255))
	})

	local statusGradients = {}
	local function CreateStatusLabel(name, pos, text, size)
		local label = Instance.new("TextLabel", m2)
		label.Name = name
		label.Size = UDim2.new(1, -20, 0, 25)
		label.Position = UDim2.new(0.5, 0, 0, pos)
		label.AnchorPoint = Vector2.new(0.5, 0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamBold
		label.Text = text
		label.TextSize = size or 12
		label.TextColor3 = Color3.new(1, 1, 1)
		local txtStroke = Instance.new("UIStroke", label)
		txtStroke.Thickness = 1.2
		txtStroke.Color = Themes[CurrentTheme].TitleStroke
		local txtGrad = Instance.new("UIGradient", label)
		txtGrad.Color = Themes[CurrentTheme].TextGrad
		table.insert(statusGradients, txtGrad)
	end

	CreateStatusLabel("Title", 12, titleText, 16)
	CreateStatusLabel("Subtitle", 40, descText, 12)

	local r2 = 0
	local conn
	conn = RunService.RenderStepped:Connect(function()
		r2 = (r2 + 1.5) % 360
		e2.Rotation = r2
		for _, g in ipairs(statusGradients) do g.Rotation = r2 end
		bgGradient.Offset = Vector2.new(math.sin(tick() * 1.5) * 0.3, 0)
	end)

	for i, notif in ipairs(Notifications) do
		if notif and notif.Parent then
			TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = UDim2.new(1, -20, 1, -20 - (i * 90))
			}):Play()
		end
	end

	table.insert(Notifications, 1, m2)
	if #Notifications > 5 then
		local old = table.remove(Notifications, 6)
		if old then
			TweenService:Create(old, TweenInfo.new(0.3), {Position = UDim2.new(1, 300, 1, old.Position.Y.Offset)}):Play()
			task.delay(0.3, function() old.Parent:Destroy() end)
		end
	end

	TweenService:Create(m2, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -20, 1, -20)
	}):Play()

	task.delay(3, function()
		for i, notif in ipairs(Notifications) do
			if notif == m2 then table.remove(Notifications, i) break end
		end
		local hide = TweenService:Create(m2, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 300, 1, m2.Position.Y.Offset)
		})
		hide:Play()
		hide.Completed:Connect(function()
			if conn then conn:Disconnect() end
			g2:Destroy()
			for i, notif in ipairs(Notifications) do
				if notif and notif.Parent then
					TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						Position = UDim2.new(1, -20, 1, -20 - ((i - 1) * 90))
					}):Play()
				end
			end
		end)
	end)
end


-- ============================================================
-- CREATE WINDOW
-- ============================================================
function Library:CreateWindow(config)
	local Window = {}
	config = config or {}
	local windowTitle = config.Title or "Hub Premium"

	if getgenv().MainUI_Library then
		pcall(function() getgenv().MainUI_Library:Destroy() end)
		getgenv().MainUI_Library = nil
	end

	local g = Instance.new("ScreenGui")
	g.Name = "Hub_Premium_" .. math.random(100, 999)
	g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	g.ResetOnSpawn = false
	pcall(function() g.Parent = CoreGui end)
	if not g.Parent then g.Parent = LocalPlayer:WaitForChild("PlayerGui") end
	getgenv().MainUI_Library = g

	local m = Instance.new("Frame", g)
	m.Name = "MainFrame"
	m.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	m.BackgroundTransparency = 0.5
	m.Size = UDim2.new(0, 700, 0, 500)
	m.Position = UDim2.new(0.5, 0, 0.5, 0)
	m.AnchorPoint = Vector2.new(0.5, 0.5)
	m.ClipsDescendants = true
	Instance.new("UICorner", m).CornerRadius = UDim.new(0, 15)

	local isMini = false
	local isMax = false

	-- Snow
	local SnowContainer = Instance.new("Frame", m)
	SnowContainer.Name = "SnowContainer"
	SnowContainer.Size = UDim2.new(1, -20, 1, -20)
	SnowContainer.Position = UDim2.new(0, 10, 0, 10)
	SnowContainer.BackgroundTransparency = 1
	SnowContainer.ZIndex = 0
	SnowContainer.ClipsDescendants = true
	Instance.new("UICorner", SnowContainer).CornerRadius = UDim.new(0, 15)

	task.spawn(function()
		while task.wait(0.15) do
			if not m.Visible or isMini then continue end
			local flake = Instance.new("ImageLabel", SnowContainer)
			flake.BackgroundTransparency = 1
			local iconId = "137906289429512"
			if CurrentTheme == "Sakura" then iconId = "129633366976969"
			elseif CurrentTheme == "Moonlight" then iconId = "116750779040036" end
			flake.Image = "rbxthumb://type=Asset&id=" .. iconId .. "&w=150&h=150"
			local randomSize = math.random(13, 20)
			flake.Size = UDim2.new(0, randomSize, 0, randomSize)
			flake.Position = UDim2.new(math.random(), 0, -0.1, 0)
			flake.ImageTransparency = math.random(2, 6) / 10
			local tween = TweenService:Create(flake, TweenInfo.new(math.random(40, 70) / 10, Enum.EasingStyle.Linear), {
				Position = UDim2.new(flake.Position.X.Scale, 0, 1.1, 0),
				Rotation = math.random(-180, 180)
			})
			tween:Play()
			tween.Completed:Connect(function() flake:Destroy() end)
		end
	end)

	-- Toggle Icon
	local ToggleIcon = Instance.new("ImageButton", g)
	ToggleIcon.Name = "ToggleIcon"
	ToggleIcon.Size = UDim2.new(0, 45, 0, 45)
	ToggleIcon.Position = UDim2.new(0, 20, 1, -65)
	ToggleIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ToggleIcon.Image = "rbxassetid://6031090990"
	ToggleIcon.BackgroundTransparency = 0.5
	Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)

	ToggleIcon.MouseButton1Click:Connect(function()
		if not m then return end
		if m.Size.X.Offset > 0 or m.Size.X.Scale > 0 then
			TweenService:Create(m, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
			task.wait(0.3); m.Visible = false
		else
			m.Visible = true
			local targetSize = isMini and UDim2.new(0, 700, 0, 45) or (isMax and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 700, 0, 500))
			local targetPos = isMini and UDim2.new(0.5, 0, 0, 25) or UDim2.new(0.5, 0, 0.5, 0)
			TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = targetSize, Position = targetPos}):Play()
		end
	end)

	-- Main Stroke
	local u = Instance.new("UIStroke", m)
	u.Thickness = 4.5
	u.Color = Themes[CurrentTheme].MainStroke
	table.insert(UI_Elements.AnimatedStrokes, {Obj = u, Type = "MainStroke"})
	local e = Instance.new("UIGradient", u)

	-- Wave BG
	local waveBg = Instance.new("Frame", m)
	waveBg.Size = UDim2.new(1, 0, 1, 0)
	waveBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	waveBg.BackgroundTransparency = 0.7
	waveBg.ZIndex = 0
	Instance.new("UICorner", waveBg).CornerRadius = UDim.new(0, 15)
	local waveGrad = Instance.new("UIGradient", waveBg)
	waveGrad.Color = Themes[CurrentTheme].Wave

	-- Title Bar
	local titleBar = Instance.new("Frame", m)
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 55)
	titleBar.BackgroundTransparency = 1
	titleBar.ZIndex = 2

	local hubTitle = Instance.new("TextLabel", titleBar)
	hubTitle.Size = UDim2.new(0, 300, 1, 0)
	hubTitle.Position = UDim2.new(0, 20, 0, 0)
	hubTitle.BackgroundTransparency = 1
	hubTitle.Font = Enum.Font.GothamMedium
	hubTitle.Text = windowTitle
	hubTitle.TextColor3 = Color3.new(1, 1, 1)
	hubTitle.TextSize = 15
	hubTitle.TextXAlignment = Enum.TextXAlignment.Left

	local hubTitleStroke = Instance.new("UIStroke", hubTitle)
	hubTitleStroke.Thickness = 1.2
	hubTitleStroke.Color = Themes[CurrentTheme].TitleStroke
	hubTitleStroke.Transparency = 0.2
	table.insert(UI_Elements.AnimatedStrokes, {Obj = hubTitleStroke, Type = "TitleStroke"})
	local hubTitleGrad = Instance.new("UIGradient", hubTitle)
	hubTitleGrad.Color = Themes[CurrentTheme].TextGrad
	table.insert(UI_Elements.AnimatedGradients, hubTitleGrad)

	local function CreateWinBtn(text, pos)
		local btn = Instance.new("TextButton", titleBar)
		btn.Size = UDim2.new(0, 30, 0, 30)
		btn.Position = UDim2.new(1, pos, 0.5, 0)
		btn.AnchorPoint = Vector2.new(0, 0.5)
		btn.BackgroundTransparency = 1
		btn.Text = text
		btn.Font = Enum.Font.GothamMedium
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.TextSize = 16
		local btnStroke = Instance.new("UIStroke", btn)
		btnStroke.Thickness = 1
		btnStroke.Color = Themes[CurrentTheme].TitleStroke
		table.insert(UI_Elements.AnimatedStrokes, {Obj = btnStroke, Type = "TitleStroke"})
		local btnGrad = Instance.new("UIGradient", btn)
		btnGrad.Color = Themes[CurrentTheme].TextGrad
		table.insert(UI_Elements.AnimatedGradients, btnGrad)
		return btn
	end

	local minBtn   = CreateWinBtn("--", -105)
	local maxBtn   = CreateWinBtn("▢",  -70)
	local closeBtn = CreateWinBtn("X",  -35)

	minBtn.MouseButton1Click:Connect(function()
		if not isMini then
			isMini = true; isMax = false
			TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 700, 0, 45), Position = UDim2.new(0.5, 0, 0, 25)
			}):Play()
			for _, c in pairs(m:GetChildren()) do
				if c.Name == "Sidebar" or c.Name == "LeftDivider" or c.Name == "TopDivider" then c.Visible = false end
				if c:IsA("ScrollingFrame") and c.Name:match("Page$") then c.Visible = false end
			end
		else
			isMini = false
			TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 700, 0, 500), Position = UDim2.new(0.5, 0, 0.5, 0)
			}):Play()
			for _, c in pairs(m:GetChildren()) do
				if c.Name == "Sidebar" or c.Name == "LeftDivider" or c.Name == "TopDivider" then c.Visible = true end
			end
			if m:FindFirstChild("Sidebar") then
				for _, btn in pairs(m.Sidebar:GetChildren()) do
					if btn:IsA("TextButton") and btn:FindFirstChild("Indicator") and btn.Indicator.Visible then
						local pg = m:FindFirstChild(btn.Text:gsub("%s+", "") .. "Page")
						if pg then pg.Visible = true end
					end
				end
			end
		end
	end)

	maxBtn.MouseButton1Click:Connect(function()
		if not isMax then
			isMax = true; isMini = false
			TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0.5, 0, 0.5, 0)
			}):Play()
		else
			isMax = false
			TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 700, 0, 500), Position = UDim2.new(0.5, 0, 0.5, 0)
			}):Play()
		end
	end)

	closeBtn.MouseButton1Click:Connect(function()
		if m.Size.X.Offset > 0 or m.Size.X.Scale > 0 then
			TweenService:Create(m, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
			task.wait(0.3); m.Visible = false
		end
	end)

	-- Drag
	local dragging, dragStart, startPos
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = input.Position; startPos = m.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - dragStart
			m.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	-- Dividers
	local TopDivider = Instance.new("Frame", m)
	TopDivider.Name = "TopDivider"
	TopDivider.Size = UDim2.new(1, -40, 0, 1)
	TopDivider.Position = UDim2.new(0, 20, 0, 55)
	TopDivider.BackgroundColor3 = Color3.new(1, 1, 1)
	TopDivider.BorderSizePixel = 0
	TopDivider.ZIndex = 3
	local topDivGrad = Instance.new("UIGradient", TopDivider)
	topDivGrad.Color = Themes[CurrentTheme].DivGrad
	topDivGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1)
	})
	table.insert(UI_Elements.DivGradients, topDivGrad)

	local LeftDivider = Instance.new("Frame", m)
	LeftDivider.Name = "LeftDivider"
	LeftDivider.Size = UDim2.new(0, 1, 1, -80)
	LeftDivider.Position = UDim2.new(0, 190, 0, 65)
	LeftDivider.BackgroundColor3 = Color3.new(1, 1, 1)
	LeftDivider.BorderSizePixel = 0
	LeftDivider.ZIndex = 3
	local leftDivGrad = Instance.new("UIGradient", LeftDivider)
	leftDivGrad.Rotation = 90
	leftDivGrad.Color = Themes[CurrentTheme].DivGrad
	leftDivGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1)
	})
	table.insert(UI_Elements.DivGradients, leftDivGrad)

	-- Sidebar
	local Sidebar = Instance.new("ScrollingFrame", m)
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 180, 1, -65)
	Sidebar.Position = UDim2.new(0, 5, 0, 60)
	Sidebar.BackgroundTransparency = 1
	Sidebar.BorderSizePixel = 0
	Sidebar.ScrollBarThickness = 0
	Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Sidebar.ZIndex = 2
	local sideLayout = Instance.new("UIListLayout", Sidebar)
	sideLayout.Padding = UDim.new(0, 5)
	sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local TabsList = {}
	local PagesList = {}


	-- ============================================================
	-- CREATE TAB
	-- ============================================================
	function Window:CreateTab(name, isFirstPage)
		local Tab = {}

		local btn = Instance.new("TextButton", Sidebar)
		btn.Size = UDim2.new(1, -20, 0, 35)
		btn.BackgroundTransparency = 1
		btn.Font = Enum.Font.GothamMedium
		btn.Text = " " .. name
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.TextSize = 15
		btn.TextXAlignment = Enum.TextXAlignment.Left

		local indicator = Instance.new("Frame", btn)
		indicator.Name = "Indicator"
		indicator.Size = UDim2.new(0, 4, 0, 18)
		indicator.Position = UDim2.new(0, 8, 0.5, 0)
		indicator.AnchorPoint = Vector2.new(0, 0.5)
		indicator.BackgroundColor3 = Color3.new(1, 1, 1)
		indicator.BorderSizePixel = 0
		indicator.Visible = isFirstPage
		Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
		local indiGrad = Instance.new("UIGradient", indicator)
		indiGrad.Color = Themes[CurrentTheme].TextGrad
		table.insert(UI_Elements.AnimatedGradients, indiGrad)

		local btnStroke = Instance.new("UIStroke", btn)
		btnStroke.Thickness = 2.2
		btnStroke.Color = Themes[CurrentTheme].TitleStroke
		btnStroke.Transparency = 1.5
		table.insert(UI_Elements.AnimatedStrokes, {Obj = btnStroke, Type = "TitleStroke"})

		local tabGrad = Instance.new("UIGradient", btn)
		tabGrad.Color = Themes[CurrentTheme].TabGrad
		table.insert(UI_Elements.TabGradients, tabGrad)
		table.insert(UI_Elements.AnimatedGradients, tabGrad)
		table.insert(TabsList, btn)

		local page = Instance.new("ScrollingFrame", m)
		page.Name = name .. "Page"
		page.Size = UDim2.new(1, -235, 1, -85)
		page.Position = UDim2.new(0, 215, 0, 70)
		page.BackgroundTransparency = 1
		page.ScrollBarThickness = 0
		page.ZIndex = 2
		page.Visible = isFirstPage
		page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		local pagePadding = Instance.new("UIPadding", page)
		pagePadding.PaddingLeft = UDim.new(0, 10)
		pagePadding.PaddingRight = UDim.new(0, 20)
		pagePadding.PaddingTop = UDim.new(0, 5)
		local contentLayout = Instance.new("UIListLayout", page)
		contentLayout.Padding = UDim.new(0, 8)
		table.insert(PagesList, page)

		btn.MouseButton1Click:Connect(function()
			for _, p in pairs(PagesList) do p.Visible = false end
			for _, t in pairs(TabsList) do if t:FindFirstChild("Indicator") then t.Indicator.Visible = false end end
			page.Visible = true
			indicator.Visible = true
			Library:SendNotification("Tab Selected", name)
		end)

		function Tab:CreatePageTitle(text)
			local wrapper = Instance.new("Frame", page)
			wrapper.Size = UDim2.new(1, 0, 0, 45)
			wrapper.BackgroundTransparency = 1
			local title = Instance.new("TextLabel", wrapper)
			title.Size = UDim2.new(1, 0, 1, 0)
			title.Position = UDim2.new(0, 10, 0, 0)
			title.BackgroundTransparency = 1
			title.Font = Enum.Font.GothamBold
			title.Text = text
			title.TextColor3 = Color3.new(1, 1, 1)
			title.TextSize = 26
			title.TextXAlignment = Enum.TextXAlignment.Left
			local s = Instance.new("UIStroke", title)
			s.Thickness = 1.5
			s.Color = Themes[CurrentTheme].TitleStroke
			table.insert(UI_Elements.AnimatedStrokes, {Obj = s, Type = "TitleStroke"})
			local g = Instance.new("UIGradient", title)
			g.Color = Themes[CurrentTheme].TextGrad
			table.insert(UI_Elements.AnimatedGradients, g)
		end

		function Tab:CreatePageSubTitle(text)
			local wrapper = Instance.new("Frame", page)
			wrapper.Size = UDim2.new(1, 0, 0, 35)
			wrapper.BackgroundTransparency = 1
			local title = Instance.new("TextLabel", wrapper)
			title.Size = UDim2.new(1, 0, 1, 0)
			title.Position = UDim2.new(0, 10, 0, 0)
			title.BackgroundTransparency = 1
			title.Font = Enum.Font.GothamBold
			title.Text = text
			title.TextColor3 = Color3.new(1, 1, 1)
			title.TextSize = 20
			title.TextXAlignment = Enum.TextXAlignment.Left
			local s = Instance.new("UIStroke", title)
			s.Thickness = 1.2
			s.Color = Themes[CurrentTheme].TitleStroke
			table.insert(UI_Elements.AnimatedStrokes, {Obj = s, Type = "TitleStroke"})
			local g = Instance.new("UIGradient", title)
			g.Color = Themes[CurrentTheme].TextGrad
			table.insert(UI_Elements.AnimatedGradients, g)
		end


		local function MakeRow(parent)
			local row = Instance.new("Frame", parent)
			row.Size = UDim2.new(1, 0, 0, 42)
			row.Position = UDim2.new(0, 0, 0, 2)
			row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			row.BackgroundTransparency = 0.8
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
			local rs = Instance.new("UIStroke", row)
			rs.Color = Themes[CurrentTheme].RowStroke
			rs.Thickness = 1.2
			table.insert(UI_Elements.RowStrokes, rs)
			local rg = Instance.new("UIGradient", rs)
			rg.Color = Themes[CurrentTheme].RowStrokeGrad
			table.insert(UI_Elements.RowStrokeGradients, rg)
			table.insert(UI_Elements.AnimatedGradients, rg)
			return row
		end

		local function MakeLabel(parent, text)
			local label = Instance.new("TextLabel", parent)
			label.Size = UDim2.new(0.5, -10, 1, 0)
			label.Position = UDim2.new(0, 15, 0, 0)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.GothamMedium
			label.Text = text
			label.TextColor3 = Color3.new(1, 1, 1)
			label.TextSize = 14.5
			label.TextXAlignment = Enum.TextXAlignment.Left
			local ls = Instance.new("UIStroke", label)
			ls.Thickness = 0.5
			ls.Color = Themes[CurrentTheme].TitleStroke
			ls.Transparency = 0.2
			table.insert(UI_Elements.AnimatedStrokes, {Obj = ls, Type = "TitleStroke"})
			local lg = Instance.new("UIGradient", label)
			lg.Color = Themes[CurrentTheme].TextGrad
			table.insert(UI_Elements.AnimatedGradients, lg)
		end

		local function MakeDropBtn(parent, defaultText)
			local dropBtn = Instance.new("TextButton", parent)
			dropBtn.Size = UDim2.new(0, 130, 0, 30)
			dropBtn.Position = UDim2.new(1, -145, 0.5, 0)
			dropBtn.AnchorPoint = Vector2.new(0, 0.5)
			dropBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			dropBtn.BackgroundTransparency = 0.8
			dropBtn.Text = defaultText
			dropBtn.Font = Enum.Font.GothamMedium
			dropBtn.TextColor3 = Color3.new(1, 1, 1)
			dropBtn.TextSize = 12.5
			dropBtn.TextTruncate = Enum.TextTruncate.AtEnd
			Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
			local ds = Instance.new("UIStroke", dropBtn)
			ds.Thickness = 1
			ds.Color = Themes[CurrentTheme].TitleStroke
			ds.Transparency = 0.2
			table.insert(UI_Elements.AnimatedStrokes, {Obj = ds, Type = "TitleStroke"})
			local dg = Instance.new("UIGradient", dropBtn)
			dg.Color = Themes[CurrentTheme].TextGrad
			table.insert(UI_Elements.AnimatedGradients, dg)
			local arrow = Instance.new("TextLabel", dropBtn)
			arrow.Size = UDim2.new(0, 20, 1, 0)
			arrow.Position = UDim2.new(1, -25, 0, 0)
			arrow.BackgroundTransparency = 1
			arrow.Text = "▼"
			arrow.TextColor3 = Color3.new(1, 1, 1)
			arrow.TextSize = 10
			local ag = Instance.new("UIGradient", arrow)
			ag.Color = Themes[CurrentTheme].TextGrad
			table.insert(UI_Elements.AnimatedGradients, ag)
			return dropBtn, arrow
		end

		local function MakeDropList(parent)
			local dropList = Instance.new("ScrollingFrame", parent)
			dropList.Size = UDim2.new(1, 0, 1, -48)
			dropList.Position = UDim2.new(0, 0, 0, 48)
			dropList.BackgroundTransparency = 0.8
			dropList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			dropList.BorderSizePixel = 0
			dropList.ScrollBarThickness = 2
			dropList.Visible = false
			Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 8)
			local ll = Instance.new("UIListLayout", dropList)
			ll.Padding = UDim.new(0, 5)
			ll.HorizontalAlignment = Enum.HorizontalAlignment.Center
			local dls = Instance.new("UIStroke", dropList)
			dls.Color = Themes[CurrentTheme].TitleStroke
			dls.Thickness = 1.2
			table.insert(UI_Elements.AnimatedStrokes, {Obj = dls, Type = "TitleStroke"})
			return dropList
		end

		function Tab:CreateDropdown(text, default, optionsList, callback)
			local container = Instance.new("Frame", page)
			container.Size = UDim2.new(1, -4, 0, 46)
			container.Position = UDim2.new(0, 2, 0, 0)
			container.BackgroundTransparency = 1
			container.ClipsDescendants = false

			local row = MakeRow(container)
			MakeLabel(row, text)
			local dropBtn, arrow = MakeDropBtn(row, default)
			local dropList = MakeDropList(container)

			local isDropped = false
			optionsList = optionsList or {"Sample Mode"}

			for _, opt in pairs(optionsList) do
				local ob = Instance.new("TextButton", dropList)
				ob.Size = UDim2.new(1, -10, 0, 30)
				ob.BackgroundTransparency = 1
				ob.Text = opt
				ob.Font = Enum.Font.GothamMedium
				ob.TextColor3 = Color3.new(1, 1, 1)
				ob.TextSize = 12
				ob.MouseButton1Click:Connect(function()
					dropBtn.Text = opt
					isDropped = false
					dropList.Visible = false
					TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -4, 0, 46)}):Play()
					TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
					if callback then callback(opt) end
					Library:SendNotification("Selected Mode", opt)
				end)
			end

			dropBtn.MouseButton1Click:Connect(function()
				isDropped = not isDropped
				if not isDropped then dropList.Visible = false end
				TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -4, 0, isDropped and 165 or 46)}):Play()
				if isDropped then dropList.Visible = true end
				TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = isDropped and 180 or 0}):Play()
			end)
		end

		function Tab:CreateMultiDropdown(text, defaultSelections, optionsList, callback)
			local container = Instance.new("Frame", page)
			container.Size = UDim2.new(1, -4, 0, 46)
			container.Position = UDim2.new(0, 2, 0, 0)
			container.BackgroundTransparency = 1
			container.ClipsDescendants = false

			local row = MakeRow(container)
			MakeLabel(row, text)
			local dropBtn, arrow = MakeDropBtn(row, "None Selected")
			local dropList = MakeDropList(container)

			local isDropped = false
			local selectedItems = {}
			optionsList = optionsList or {"Sample Mode 1", "Sample Mode 2"}
			defaultSelections = defaultSelections or {}
			for _, v in pairs(defaultSelections) do table.insert(selectedItems, v) end

			local function UpdateButtonText()
				if #selectedItems == 0 then dropBtn.Text = "None Selected"
				elseif #selectedItems == 1 then dropBtn.Text = selectedItems[1]
				elseif #selectedItems == 2 then dropBtn.Text = selectedItems[1] .. ", " .. selectedItems[2]
				else dropBtn.Text = "Selected (" .. #selectedItems .. ")" end
			end
			UpdateButtonText()

			for _, opt in pairs(optionsList) do
				local ob = Instance.new("TextButton", dropList)
				ob.Size = UDim2.new(1, -10, 0, 30)
				ob.BackgroundTransparency = 1
				ob.Text = opt
				ob.Font = Enum.Font.GothamMedium
				ob.TextColor3 = Color3.new(1, 1, 1)
				ob.TextSize = 12
				local og = Instance.new("UIGradient", ob)
				og.Color = Themes[CurrentTheme].TextGrad
				og.Enabled = false
				table.insert(UI_Elements.AnimatedGradients, og)

				local isSelected = false
				for _, v in pairs(selectedItems) do if v == opt then isSelected = true break end end

				local function UpdateVisuals()
					og.Enabled = isSelected
				end
				UpdateVisuals()

				ob.MouseButton1Click:Connect(function()
					if isSelected then
						isSelected = false
						for i, v in ipairs(selectedItems) do if v == opt then table.remove(selectedItems, i) break end end
					else
						isSelected = true
						table.insert(selectedItems, opt)
					end
					UpdateVisuals()
					UpdateButtonText()
					if callback then callback(selectedItems) end
				end)
			end

			dropBtn.MouseButton1Click:Connect(function()
				isDropped = not isDropped
				if not isDropped then dropList.Visible = false end
				TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -4, 0, isDropped and 165 or 46)}):Play()
				if isDropped then dropList.Visible = true end
				TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = isDropped and 180 or 0}):Play()
			end)
		end


		function Tab:CreateButton(text, callback)
			local row = Instance.new("Frame", page)
			row.Size = UDim2.new(1, -4, 0, 42)
			row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			row.BackgroundTransparency = 0.8
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
			local rs = Instance.new("UIStroke", row)
			rs.Color = Themes[CurrentTheme].RowStroke
			rs.Thickness = 1.2
			rs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			table.insert(UI_Elements.RowStrokes, rs)
			local rg = Instance.new("UIGradient", rs)
			rg.Color = Themes[CurrentTheme].RowStrokeGrad
			table.insert(UI_Elements.RowStrokeGradients, rg)
			table.insert(UI_Elements.AnimatedGradients, rg)
			local btn = Instance.new("TextButton", row)
			btn.Size = UDim2.new(1, 0, 1, 0)
			btn.BackgroundTransparency = 1
			btn.Font = Enum.Font.GothamBold
			btn.Text = text
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.TextSize = 15
			local bs = Instance.new("UIStroke", btn)
			bs.Thickness = 1.2
			bs.Color = Themes[CurrentTheme].TitleStroke
			bs.Transparency = 0.2
			table.insert(UI_Elements.AnimatedStrokes, {Obj = bs, Type = "TitleStroke"})
			local bg = Instance.new("UIGradient", btn)
			bg.Color = Themes[CurrentTheme].TextGrad
			table.insert(UI_Elements.AnimatedGradients, bg)
			btn.MouseButton1Down:Connect(function() TweenService:Create(row, TweenInfo.new(0.1), {BackgroundTransparency = 0.6}):Play() end)
			btn.MouseButton1Up:Connect(function() TweenService:Create(row, TweenInfo.new(0.1), {BackgroundTransparency = 0.8}):Play() end)
			btn.MouseButton1Click:Connect(function()
				if callback then callback() end
				Library:SendNotification("Button Clicked", text)
			end)
		end

		function Tab:CreateSwitch(text, default, callback)
			local row = Instance.new("Frame", page)
			row.Size = UDim2.new(1, -4, 0, 42)
			row.Position = UDim2.new(0, 2, 0, 0)
			row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			row.BackgroundTransparency = 0.8
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
			local rs = Instance.new("UIStroke", row)
			rs.Color = Themes[CurrentTheme].RowStroke
			rs.Thickness = 1.2
			table.insert(UI_Elements.RowStrokes, rs)
			local rg = Instance.new("UIGradient", rs)
			rg.Color = Themes[CurrentTheme].RowStrokeGrad
			table.insert(UI_Elements.RowStrokeGradients, rg)
			table.insert(UI_Elements.AnimatedGradients, rg)
			local label = Instance.new("TextLabel", row)
			label.Size = UDim2.new(0.7, -10, 1, 0)
			label.Position = UDim2.new(0, 15, 0, 0)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.GothamMedium
			label.Text = text
			label.TextColor3 = Color3.new(1, 1, 1)
			label.TextSize = 14.5
			label.TextXAlignment = Enum.TextXAlignment.Left
			local ls = Instance.new("UIStroke", label)
			ls.Thickness = 0.5
			ls.Color = Themes[CurrentTheme].TitleStroke
			ls.Transparency = 0.2
			table.insert(UI_Elements.AnimatedStrokes, {Obj = ls, Type = "TitleStroke"})
			local lg = Instance.new("UIGradient", label)
			lg.Color = Themes[CurrentTheme].TextGrad
			table.insert(UI_Elements.AnimatedGradients, lg)
			local toggleFrame = Instance.new("TextButton", row)
			toggleFrame.Size = UDim2.new(0, 40, 0, 20)
			toggleFrame.Position = UDim2.new(1, -55, 0.5, 0)
			toggleFrame.AnchorPoint = Vector2.new(0, 0.5)
			toggleFrame.BackgroundColor3 = default and Themes[CurrentTheme].ToggleActive or Color3.fromRGB(150, 150, 150)
			toggleFrame.Text = ""
			Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1, 0)
			local ball = Instance.new("Frame", toggleFrame)
			ball.Size = UDim2.new(0, 16, 0, 16)
			ball.Position = default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
			ball.AnchorPoint = Vector2.new(0, 0.5)
			ball.BackgroundColor3 = Color3.new(1, 1, 1)
			Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)
			local active = default
			local switchData = {Frame = toggleFrame, Active = active}
			table.insert(UI_Elements.Switches, switchData)
			toggleFrame.MouseButton1Click:Connect(function()
				active = not active
				switchData.Active = active
				TweenService:Create(toggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = active and Themes[CurrentTheme].ToggleActive or Color3.fromRGB(150, 150, 150)}):Play()
				TweenService:Create(ball, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}):Play()
				if callback then callback(active) end
				Library:SendNotification("Switch Toggled", text .. ": " .. (active and "Enabled" or "Disabled"))
			end)
		end

		function Tab:CreateSlider(text, min, max, default, callback)
			local container = Instance.new("Frame", page)
			container.Size = UDim2.new(1, -4, 0, 65)
			container.BackgroundTransparency = 1
			local row = Instance.new("Frame", container)
			row.Size = UDim2.new(1, 0, 0, 60)
			row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			row.BackgroundTransparency = 0.8
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
			local rs = Instance.new("UIStroke", row)
			rs.Color = Themes[CurrentTheme].RowStroke
			rs.Thickness = 1.2
			table.insert(UI_Elements.RowStrokes, rs)
			local rg = Instance.new("UIGradient", rs)
			rg.Color = Themes[CurrentTheme].RowStrokeGrad
			table.insert(UI_Elements.RowStrokeGradients, rg)
			table.insert(UI_Elements.AnimatedGradients, rg)
			local label = Instance.new("TextLabel", row)
			label.Size = UDim2.new(0.6, 0, 0, 30)
			label.Position = UDim2.new(0, 15, 0, 5)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.GothamMedium
			label.Text = text
			label.TextColor3 = Color3.new(1, 1, 1)
			label.TextSize = 14
			label.TextXAlignment = Enum.TextXAlignment.Left
			local lg = Instance.new("UIGradient", label)
			lg.Color = Themes[CurrentTheme].TextGrad
			table.insert(UI_Elements.AnimatedGradients, lg)
			local inputField = Instance.new("TextBox", row)
			inputField.Size = UDim2.new(0, 50, 0, 22)
			inputField.Position = UDim2.new(1, -65, 0, 10)
			inputField.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			inputField.BackgroundTransparency = 0.9
			inputField.Font = Enum.Font.GothamBold
			inputField.Text = tostring(default)
			inputField.TextColor3 = Color3.new(1, 1, 1)
			inputField.TextSize = 12
			Instance.new("UICorner", inputField).CornerRadius = UDim.new(0, 5)
			local is = Instance.new("UIStroke", inputField)
			is.Thickness = 1
			is.Color = Themes[CurrentTheme].TitleStroke
			is.Transparency = 0.5
			local sliderBg = Instance.new("Frame", row)
			sliderBg.Size = UDim2.new(1, -30, 0, 6)
			sliderBg.Position = UDim2.new(0, 15, 0, 45)
			sliderBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			sliderBg.BackgroundTransparency = 0.9
			Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
			local sliderFill = Instance.new("Frame", sliderBg)
			sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			sliderFill.BackgroundColor3 = Color3.new(1, 1, 1)
			sliderFill.BorderSizePixel = 0
			Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
			local fg = Instance.new("UIGradient", sliderFill)
			fg.Color = Themes[CurrentTheme].TextGrad
			table.insert(UI_Elements.AnimatedGradients, fg)
			local circle = Instance.new("Frame", sliderFill)
			circle.Size = UDim2.new(0, 14, 0, 14)
			circle.Position = UDim2.new(1, 0, 0.5, 0)
			circle.AnchorPoint = Vector2.new(0.5, 0.5)
			circle.BackgroundColor3 = Color3.new(1, 1, 1)
			Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
			local cs = Instance.new("UIStroke", circle)
			cs.Thickness = 2
			cs.Color = Themes[CurrentTheme].TitleStroke
			table.insert(UI_Elements.AnimatedStrokes, {Obj = cs, Type = "TitleStroke"})
			local function move(input)
				local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
				local value = math.floor(min + (max - min) * pos)
				sliderFill.Size = UDim2.new(pos, 0, 1, 0)
				inputField.Text = tostring(value)
				if callback then callback(value) end
			end
			local draggingSlider = false
			circle.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = true end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then move(input) end
			end)
			inputField.FocusLost:Connect(function()
				local val = math.clamp(tonumber(inputField.Text) or default, min, max)
				inputField.Text = tostring(val)
				TweenService:Create(sliderFill, TweenInfo.new(0.2), {Size = UDim2.new((val - min) / (max - min), 0, 1, 0)}):Play()
				if callback then callback(val) end
			end)
		end

		return Tab
	end

	-- ============================================================
	-- PROFILE CARD
	-- ============================================================
	function Window:CreateProfileCard(config)
		config = config or {}
		local badgeText = config.Badge or "✦ Premium"

		local profileCard = Instance.new("Frame", m)
		profileCard.Name = "ProfileCard"
		profileCard.Size = UDim2.new(0, 460, 0, 120)
		profileCard.Position = UDim2.new(0.5, 0, 0.5, 0)
		profileCard.AnchorPoint = Vector2.new(0.5, 0.5)
		profileCard.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		profileCard.BackgroundTransparency = 0.5
		profileCard.ClipsDescendants = true
		profileCard.ZIndex = 10
		Instance.new("UICorner", profileCard).CornerRadius = UDim.new(0, 15)

		local snow = Instance.new("Frame", profileCard)
		snow.Size = UDim2.new(1, -20, 1, -20)
		snow.Position = UDim2.new(0, 10, 0, 10)
		snow.BackgroundTransparency = 1
		snow.ZIndex = 0
		snow.ClipsDescendants = true
		Instance.new("UICorner", snow).CornerRadius = UDim.new(0, 15)
		task.spawn(function()
			while task.wait(0.15) do
				if not profileCard.Parent then break end
				local flake = Instance.new("ImageLabel", snow)
				flake.BackgroundTransparency = 1
				local iconId = "137906289429512"
				if CurrentTheme == "Sakura" then iconId = "129633366976969"
				elseif CurrentTheme == "Moonlight" then iconId = "116750779040036" end
				flake.Image = "rbxthumb://type=Asset&id=" .. iconId .. "&w=150&h=150"
				local s = math.random(13, 20)
				flake.Size = UDim2.new(0, s, 0, s)
				flake.Position = UDim2.new(math.random(), 0, -0.1, 0)
				flake.ImageTransparency = math.random(2, 6) / 10
				local t = TweenService:Create(flake, TweenInfo.new(math.random(40, 70) / 10, Enum.EasingStyle.Linear), {
					Position = UDim2.new(flake.Position.X.Scale, 0, 1.1, 0),
					Rotation = math.random(-180, 180)
				})
				t:Play()
				t.Completed:Connect(function() flake:Destroy() end)
			end
		end)

		local waveBg = Instance.new("Frame", profileCard)
		waveBg.Size = UDim2.new(1, 0, 1, 0)
		waveBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		waveBg.BackgroundTransparency = 0.7
		waveBg.ZIndex = 0
		Instance.new("UICorner", waveBg).CornerRadius = UDim.new(0, 15)
		local profileWaveGrad = Instance.new("UIGradient", waveBg)
		profileWaveGrad.Color = Themes[CurrentTheme].Wave

		local profileStroke = Instance.new("UIStroke", profileCard)
		profileStroke.Thickness = 4.5
		profileStroke.Color = Themes[CurrentTheme].MainStroke
		table.insert(UI_Elements.AnimatedStrokes, {Obj = profileStroke, Type = "MainStroke"})
		local profileStrokeGrad = Instance.new("UIGradient", profileStroke)
		profileStrokeGrad.Color = Themes[CurrentTheme].LoopSeq

		local avatarFrame = Instance.new("Frame", profileCard)
		avatarFrame.Size = UDim2.new(0, 80, 0, 80)
		avatarFrame.Position = UDim2.new(0, 20, 0.5, 0)
		avatarFrame.AnchorPoint = Vector2.new(0, 0.5)
		avatarFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		avatarFrame.BackgroundTransparency = 0.6
		avatarFrame.ZIndex = 2
		Instance.new("UICorner", avatarFrame).CornerRadius = UDim.new(1, 0)
		local avs = Instance.new("UIStroke", avatarFrame)
		avs.Thickness = 2.5
		avs.Color = Themes[CurrentTheme].TitleStroke
		table.insert(UI_Elements.AnimatedStrokes, {Obj = avs, Type = "TitleStroke"})
		local avg = Instance.new("UIGradient", avs)
		avg.Color = Themes[CurrentTheme].LoopSeq
		table.insert(UI_Elements.AnimatedGradients, avg)
		local avatarImg = Instance.new("ImageLabel", avatarFrame)
		avatarImg.Size = UDim2.new(1, -6, 1, -6)
		avatarImg.Position = UDim2.new(0, 3, 0, 3)
		avatarImg.BackgroundTransparency = 1
		avatarImg.ZIndex = 3
		avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
		Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

		local divider = Instance.new("Frame", profileCard)
		divider.Size = UDim2.new(0, 1, 1, -30)
		divider.Position = UDim2.new(0, 115, 0, 15)
		divider.BackgroundColor3 = Color3.new(1, 1, 1)
		divider.BorderSizePixel = 0
		divider.ZIndex = 3
		local dg = Instance.new("UIGradient", divider)
		dg.Rotation = 90
		dg.Color = Themes[CurrentTheme].DivGrad
		dg.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1)
		})
		table.insert(UI_Elements.DivGradients, dg)

		local infoFrame = Instance.new("Frame", profileCard)
		infoFrame.Size = UDim2.new(1, -135, 1, 0)
		infoFrame.Position = UDim2.new(0, 125, 0, 0)
		infoFrame.BackgroundTransparency = 1
		infoFrame.ZIndex = 2

		local function CreateInfoLabel(text, posY, textSize, bold)
			local lbl = Instance.new("TextLabel", infoFrame)
			lbl.Size = UDim2.new(1, -10, 0, 28)
			lbl.Position = UDim2.new(0, 5, 0, posY)
			lbl.BackgroundTransparency = 1
			lbl.Font = bold and Enum.Font.GothamBold or Enum.Font.GothamMedium
			lbl.Text = text
			lbl.TextColor3 = Color3.new(1, 1, 1)
			lbl.TextSize = textSize
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = 3
			local ls = Instance.new("UIStroke", lbl)
			ls.Thickness = 1.2
			ls.Color = Themes[CurrentTheme].TitleStroke
			ls.Transparency = 0.2
			table.insert(UI_Elements.AnimatedStrokes, {Obj = ls, Type = "TitleStroke"})
			local lg = Instance.new("UIGradient", lbl)
			lg.Color = Themes[CurrentTheme].TextGrad
			table.insert(UI_Elements.AnimatedGradients, lg)
		end

		CreateInfoLabel(LocalPlayer.DisplayName, 12, 18, true)
		CreateInfoLabel("@" .. LocalPlayer.Name, 40, 13, false)
		CreateInfoLabel("ID: " .. tostring(LocalPlayer.UserId), 65, 12, false)

		local badge = Instance.new("Frame", profileCard)
		badge.Size = UDim2.new(0, 95, 0, 24)
		badge.Position = UDim2.new(1, -110, 0, 12)
		badge.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		badge.BackgroundTransparency = 0.8
		badge.ZIndex = 4
		Instance.new("UICorner", badge).CornerRadius = UDim.new(1, 0)
		local bgs = Instance.new("UIStroke", badge)
		bgs.Thickness = 1.2
		bgs.Color = Themes[CurrentTheme].TitleStroke
		bgs.Transparency = 0.2
		table.insert(UI_Elements.AnimatedStrokes, {Obj = bgs, Type = "TitleStroke"})
		local badgeLabel = Instance.new("TextLabel", badge)
		badgeLabel.Size = UDim2.new(1, 0, 1, 0)
		badgeLabel.BackgroundTransparency = 1
		badgeLabel.Font = Enum.Font.GothamBold
		badgeLabel.Text = badgeText
		badgeLabel.TextColor3 = Color3.new(1, 1, 1)
		badgeLabel.TextSize = 11
		badgeLabel.ZIndex = 5
		local bls = Instance.new("UIStroke", badgeLabel)
		bls.Thickness = 1.2
		bls.Color = Themes[CurrentTheme].TitleStroke
		table.insert(UI_Elements.AnimatedStrokes, {Obj = bls, Type = "TitleStroke"})
		local blg = Instance.new("UIGradient", badgeLabel)
		blg.Color = Themes[CurrentTheme].TextGrad
		table.insert(UI_Elements.AnimatedGradients, blg)

		local rp = 0
		RunService.RenderStepped:Connect(function()
			rp = (rp + 1.5) % 360
			profileStrokeGrad.Rotation = rp
			profileStrokeGrad.Color = Themes[CurrentTheme].LoopSeq
			profileWaveGrad.Rotation = math.sin(tick() * 0.5) * 10
			profileWaveGrad.Offset = Vector2.new(math.sin(tick() * 1.2) * 0.5, 0)
		end)

		profileCard.Size = UDim2.new(0, 0, 0, 0)
		TweenService:Create(profileCard, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 460, 0, 120)
		}):Play()

		return profileCard
	end

	-- ============================================================
	-- APPLY THEME
	-- ============================================================
	function Window:ApplyTheme(name)
		local t = Themes[name]
		if not t then return end
		CurrentTheme = name
		for _, item in pairs(UI_Elements.AnimatedStrokes) do
			if item.Obj and item.Obj.Parent then
				TweenService:Create(item.Obj, TweenInfo.new(0.3), {Color = t[item.Type]}):Play()
			end
		end
		for _, s in pairs(UI_Elements.RowStrokes) do
			if s and s.Parent then TweenService:Create(s, TweenInfo.new(0.3), {Color = t.RowStroke}):Play() end
		end
		for _, g in pairs(UI_Elements.AnimatedGradients) do
			if g and g.Parent then g.Color = t.TextGrad end
		end
		for _, g in pairs(UI_Elements.RowStrokeGradients) do
			if g and g.Parent then g.Color = t.RowStrokeGrad end
		end
		for _, g in pairs(UI_Elements.TabGradients) do
			if g and g.Parent then g.Color = t.TabGrad end
		end
		for _, d in pairs(UI_Elements.DivGradients) do
			if d and d.Parent then d.Color = t.DivGrad end
		end
		if waveGrad then waveGrad.Color = t.Wave end
		for _, sw in pairs(UI_Elements.Switches) do
			if sw.Active then
				TweenService:Create(sw.Frame, TweenInfo.new(0.3), {BackgroundColor3 = t.ToggleActive}):Play()
			end
		end
	end

	-- Main render loop
	local r = 0
	RunService.RenderStepped:Connect(function()
		r = (r + 1.5) % 360
		e.Rotation = r
		e.Color = Themes[CurrentTheme].LoopSeq
		if waveGrad then
			waveGrad.Rotation = math.sin(tick() * 0.5) * 10
			waveGrad.Offset = Vector2.new(math.sin(tick() * 1.2) * 0.5, 0)
		end
		local animOffset = Vector2.new(math.sin(tick() * 2) * 0.4, 0)
		for _, grad in pairs(UI_Elements.AnimatedGradients) do
			if grad and grad.Parent then grad.Offset = animOffset end
		end
		for _, grad in pairs(UI_Elements.RowStrokeGradients) do
			if grad and grad.Parent then grad.Offset = animOffset end
		end
		for _, grad in pairs(UI_Elements.TabGradients) do
			if grad and grad.Parent then grad.Offset = animOffset end
		end
	end)

	m.Size = UDim2.new(0, 0, 0, 0)
	TweenService:Create(m, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 700, 0, 500)
	}):Play()
	Library:SendNotification("Status", "Hub Initialized!")

	return Window
end

return Library
