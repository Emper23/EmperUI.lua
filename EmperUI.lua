local EmperUI = {}
EmperUI.__index = EmperUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local TargetParent = gethui and gethui() or CoreGui

local function RandomName()
    return HttpService:GenerateGUID(false):gsub("-", "")
end

-- [ Notification System ]
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = RandomName()
NotifGui.Parent = TargetParent
NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotifGui.ResetOnSpawn = false

local NotifContainer = Instance.new("Frame")
NotifContainer.Parent = NotifGui
NotifContainer.BackgroundTransparency = 1
NotifContainer.AnchorPoint = Vector2.new(1, 1)
NotifContainer.Position = UDim2.new(1, -20, 1, -120)
NotifContainer.Size = UDim2.new(0, 290, 1, 0)
NotifContainer.ClipsDescendants = false

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.Parent = NotifContainer
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 8)

local NotifColors = {
    success = Color3.fromRGB(0, 200, 100),
    error   = Color3.fromRGB(220, 50, 50),
    warning = Color3.fromRGB(255, 160, 0),
    info    = Color3.fromRGB(0, 200, 255),
}
local NotifIcons = {
    success = "✓",
    error   = "✕",
    warning = "!",
    info    = "i",
}

function EmperUI:Notify(opts)
    opts = opts or {}
    local title    = opts.Title    or "Notification"
    local message  = opts.Message  or ""
    local duration = opts.Duration or 4
    local ntype    = opts.Type     or "info"
    local accent   = NotifColors[ntype] or NotifColors.info
    local icon     = NotifIcons[ntype]  or "i"

    local Card = Instance.new("Frame")
    Card.Parent = NotifContainer
    Card.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Card.Size = UDim2.new(1, 0, 0, 68)
    Card.Position = UDim2.new(0, 12, 0, 0)  -- start slightly right inside container
    Card.BackgroundTransparency = 1
    Card.BorderSizePixel = 0
    Card.ClipsDescendants = false

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 14)
    CardCorner.Parent = Card

    -- Type-tinted gradient: dark base (right) → accent-tinted (left)
    local CardGrad = Instance.new("UIGradient")
    CardGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, accent:Lerp(Color3.fromRGB(18, 18, 26), 0.82)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 26))
    })
    CardGrad.Rotation = 0
    CardGrad.Parent = Card

    -- Thin clean left accent bar (3px only)
    local Bar = Instance.new("Frame")
    Bar.Parent = Card
    Bar.BackgroundColor3 = accent
    Bar.BorderSizePixel = 0
    Bar.Position = UDim2.new(0, 0, 0, 0)
    Bar.Size = UDim2.new(0, 3, 1, 0)

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 12)
    BarCorner.Parent = Bar

    -- subtle UIStroke border (clean, thin)
    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = accent
    CardStroke.Thickness = 1
    CardStroke.Transparency = 0.7
    CardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    CardStroke.Parent = Card

    -- Soft glow behind icon (left side)
    local Glow = Instance.new("Frame")
    Glow.Parent = Card
    Glow.BackgroundColor3 = accent
    Glow.BackgroundTransparency = 0.9
    Glow.BorderSizePixel = 0
    Glow.Position = UDim2.new(0, 3, 0, 0)
    Glow.Size = UDim2.new(0, 50, 1, 0)
    local GlowGrad = Instance.new("UIGradient")
    GlowGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    GlowGrad.Rotation = 0
    GlowGrad.Parent = Glow

    -- Icon circle — smaller, vibrant, solid color
    local IconCircle = Instance.new("Frame")
    IconCircle.Parent = Card
    IconCircle.BackgroundColor3 = accent
    IconCircle.BackgroundTransparency = 0.15
    IconCircle.Position = UDim2.new(0, 18, 0.5, -11)
    IconCircle.Size = UDim2.new(0, 22, 0, 22)
    IconCircle.BorderSizePixel = 0

    local IconCircleCorner = Instance.new("UICorner")
    IconCircleCorner.CornerRadius = UDim.new(1, 0)
    IconCircleCorner.Parent = IconCircle

    local IconLabel = Instance.new("TextLabel")
    IconLabel.Parent = IconCircle
    IconLabel.BackgroundTransparency = 1
    IconLabel.Size = UDim2.new(1, 0, 1, 0)
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.TextSize = 12
    IconLabel.TextColor3 = Color3.new(1, 1, 1)  -- pure white, always readable
    IconLabel.Text = icon
    IconLabel.TextXAlignment = Enum.TextXAlignment.Center

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = Card
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 50, 0, 9)
    TitleLabel.Size = UDim2.new(1, -58, 0, 18)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 15
    TitleLabel.TextColor3 = Color3.fromRGB(240, 242, 255)
    TitleLabel.Text = title
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Message (brighter gray - easier to read)
    local MsgLabel = Instance.new("TextLabel")
    MsgLabel.Parent = Card
    MsgLabel.BackgroundTransparency = 1
    MsgLabel.Position = UDim2.new(0, 50, 0, 28)
    MsgLabel.Size = UDim2.new(1, -56, 0, 28)
    MsgLabel.Font = Enum.Font.Gotham
    MsgLabel.TextSize = 13
    MsgLabel.TextColor3 = Color3.fromRGB(175, 177, 195)
    MsgLabel.Text = message
    MsgLabel.TextWrapped = true
    MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
    MsgLabel.TextYAlignment = Enum.TextYAlignment.Top

    -- Timer line (top edge, very subtle)
    local TimerBar = Instance.new("Frame")
    TimerBar.Parent = Card
    TimerBar.BackgroundColor3 = accent
    TimerBar.BackgroundTransparency = 0.5
    TimerBar.BorderSizePixel = 0
    TimerBar.Position = UDim2.new(0, 3, 0, 0)
    TimerBar.Size = UDim2.new(1, -3, 0, 2)

    -- Slide IN + fade in
    TweenService:Create(Card, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 0
    }):Play()

    -- Timer shrink
    TweenService:Create(TimerBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 2)
    }):Play()

    task.delay(duration - 0.35, function()
        local out = TweenService:Create(Card, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1
        })
        out:Play()
        out.Completed:Connect(function()
            Card:Destroy()
        end)
    end)
end


local function MakeDraggable(topbarObject, object)
    local Dragging, DragInput, DragStart, StartPosition

    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local delta = input.Position - DragStart
            object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
        end
    end)
end

function EmperUI:CreateWindow(options)
    options = options or {}
    local WindowTitle = options.Title or "PREMIUM HUB"
    local WindowSize = options.Size or UDim2.new(0, 680, 0, 450)
    
    local Theme = {
        Background = Color3.fromRGB(15, 15, 20),
        Sidebar = Color3.fromRGB(20, 20, 28),
        Topbar = Color3.fromRGB(20, 20, 28),
        Accent = Color3.fromRGB(0, 230, 255),
        Accent2 = Color3.fromRGB(255, 0, 128),
        Text = Color3.fromRGB(245, 245, 250),
        TextMuted = Color3.fromRGB(120, 122, 138),
        ElementBg = Color3.fromRGB(25, 27, 38),
        ElementHover = Color3.fromRGB(35, 37, 50),
        Border = Color3.fromRGB(45, 48, 65)
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = RandomName()
    ScreenGui.Parent = TargetParent
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = ScreenGui
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, -WindowSize.X.Offset/2 - 25, 0.5, -WindowSize.Y.Offset/2 - 25)
    DropShadow.Size = UDim2.new(0, WindowSize.X.Offset + 50, 0, WindowSize.Y.Offset + 50)
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.3
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.ScaleType = Enum.ScaleType.Slice

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.Position = UDim2.new(0.5, -WindowSize.X.Offset/2, 0.5, -WindowSize.Y.Offset/2)
    MainFrame.Size = WindowSize
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.new(1, 1, 1)
    MainStroke.Thickness = 1.5
    MainStroke.LineJoinMode = Enum.LineJoinMode.Round
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame

    local StrokeGradient = Instance.new("UIGradient")
    StrokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Accent),
        ColorSequenceKeypoint.new(0.5, Theme.Accent2),
        ColorSequenceKeypoint.new(1, Theme.Accent)
    })
    StrokeGradient.Parent = MainStroke

    task.spawn(function()
        local runService = game:GetService("RunService")
        local rot = 0
        runService.RenderStepped:Connect(function(dt)
            rot = (rot + dt * 60) % 360
            StrokeGradient.Rotation = rot
        end)
    end)

    local MainScale = Instance.new("UIScale")
    MainScale.Parent = MainFrame
    MainScale.Scale = 1

    local Topbar = Instance.new("Frame")
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Theme.Topbar
    Topbar.BackgroundTransparency = 0.15
    Topbar.Size = UDim2.new(1, 0, 0, 45)
    Topbar.BorderSizePixel = 0

    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 10)
    TopbarCorner.Parent = Topbar

    local TopbarPatch = Instance.new("Frame")
    TopbarPatch.Parent = Topbar
    TopbarPatch.BackgroundColor3 = Theme.Topbar
    TopbarPatch.BackgroundTransparency = 0.15
    TopbarPatch.BorderSizePixel = 0
    TopbarPatch.Position = UDim2.new(0, 0, 0.5, 0)
    TopbarPatch.Size = UDim2.new(1, 0, 0.5, 0)

    local TopbarLine = Instance.new("Frame")
    TopbarLine.Parent = Topbar
    TopbarLine.BackgroundColor3 = Theme.Border
    TopbarLine.Position = UDim2.new(0, 0, 1, -1)
    TopbarLine.Size = UDim2.new(1, 0, 0, 1)
    TopbarLine.BorderSizePixel = 0

    local TitleIcon = Instance.new("ImageLabel")
    TitleIcon.Parent = Topbar
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Position = UDim2.new(0, 16, 0.5, -9)
    TitleIcon.Size = UDim2.new(0, 18, 0, 18)
    TitleIcon.Image = "rbxassetid://11681541018"
    TitleIcon.ImageColor3 = Theme.Accent

    local Title = Instance.new("TextLabel")
    Title.Parent = Topbar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 42, 0, 0)
    Title.Size = UDim2.new(1, -200, 1, 0)
    Title.Font = Enum.Font.GothamMedium
    Title.Text = WindowTitle
    Title.TextColor3 = Theme.Text
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- [ Window Controls: Minimize, Maximize, Close ]
    local Controls = Instance.new("Frame")
    Controls.Name = "Controls"
    Controls.Parent = Topbar
    Controls.BackgroundTransparency = 1
    Controls.Position = UDim2.new(1, -120, 0, 0)
    Controls.Size = UDim2.new(0, 120, 1, 0)

    local ControlLayout = Instance.new("UIListLayout")
    ControlLayout.Parent = Controls
    ControlLayout.FillDirection = Enum.FillDirection.Horizontal
    ControlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ControlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ControlLayout.Padding = UDim.new(0, 5)

    local ControlPadding = Instance.new("UIPadding")
    ControlPadding.Parent = Controls
    ControlPadding.PaddingRight = UDim.new(0, 10)

    local function CreateControlButton(iconId, hoverColor, callback)
        local Btn = Instance.new("TextButton")
        Btn.Parent = Controls
        Btn.BackgroundColor3 = Theme.Topbar
        Btn.Size = UDim2.new(0, 28, 0, 28)
        Btn.Text = ""
        Btn.AutoButtonColor = false

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 4)
        Corner.Parent = Btn

        local Icon = Instance.new("ImageLabel")
        Icon.Parent = Btn
        Icon.BackgroundTransparency = 1
        Icon.Position = UDim2.new(0.5, -7, 0.5, -7)
        Icon.Size = UDim2.new(0, 14, 0, 14)
        Icon.Image = iconId
        Icon.ImageColor3 = Theme.TextMuted

        Btn.MouseEnter:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 32, 40)}):Play()
            TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = hoverColor}):Play()
        end)
        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Topbar}):Play()
            TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = Theme.TextMuted}):Play()
        end)
        Btn.MouseButton1Click:Connect(callback)
    end

    local MobileIcon = Instance.new("ImageButton")
    MobileIcon.Parent = ScreenGui
    MobileIcon.BackgroundColor3 = Theme.Background
    MobileIcon.Position = UDim2.new(0.5, -25, 0, 20)
    MobileIcon.Size = UDim2.new(0, 50, 0, 50)
    MobileIcon.Visible = false
    MobileIcon.ZIndex = 100
    MobileIcon.AutoButtonColor = false
    MobileIcon.ClipsDescendants = true

    local MobileIconCorner = Instance.new("UICorner")
    MobileIconCorner.CornerRadius = UDim.new(0, 10)
    MobileIconCorner.Parent = MobileIcon

    local MobileIconStroke = Instance.new("UIStroke")
    MobileIconStroke.Color = Theme.Accent
    MobileIconStroke.Thickness = 2
    MobileIconStroke.Parent = MobileIcon
    
    local MobileIconImage = Instance.new("ImageLabel")
    MobileIconImage.Parent = MobileIcon
    MobileIconImage.BackgroundTransparency = 1
    MobileIconImage.Position = UDim2.new(0.5, -12, 0.5, -12)
    MobileIconImage.Size = UDim2.new(0, 24, 0, 24)
    MobileIconImage.Image = "rbxassetid://10734896206"
    MobileIconImage.ImageColor3 = Theme.Text

    MakeDraggable(MobileIcon, MobileIcon)

    local isMinimized = false
    
    MobileIcon.MouseButton1Click:Connect(function()
        isMinimized = false
        MobileIcon.Visible = false
        MainFrame.Visible = true
        DropShadow.Visible = true
    end)

    CreateControlButton("rbxassetid://10734896206", Theme.Text, function()
        isMinimized = true
        MainFrame.Visible = false
        DropShadow.Visible = false
        MobileIcon.Visible = true
    end)
    local isMaximized = false
    local preMaximizeScale = 1

    CreateControlButton("rbxassetid://10734965702", Theme.Accent, function()
        if isMinimized then return end
        isMaximized = not isMaximized
        if isMaximized then
            preMaximizeScale = MainScale.Scale
            TweenService:Create(MainScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Scale = 1.35}):Play()
        else
            TweenService:Create(MainScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Scale = preMaximizeScale}):Play()
        end
    end)
    CreateControlButton("rbxassetid://10747384394", Color3.fromRGB(255, 75, 75), function()
        WindowObj:ShowDialog("Close UI", "Are you sure you want to close the Hub?", {"Yes", "Cancel"}, function(choice)
            if choice == "Yes" then
                ScreenGui:Destroy()
            end
        end)
    end)

    MakeDraggable(Topbar, MainFrame)
    
    local function UpdateShadow()
        local scale = MainScale.Scale
        local width = MainFrame.Size.X.Offset * scale
        local height = MainFrame.Size.Y.Offset * scale
        DropShadow.Size = UDim2.new(0, width + 50, 0, height + 50)
        DropShadow.Position = UDim2.new(
            MainFrame.Position.X.Scale, MainFrame.Position.X.Offset - 25,
            MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset - 25
        )
    end
    MainScale:GetPropertyChangedSignal("Scale"):Connect(UpdateShadow)
    MainFrame:GetPropertyChangedSignal("Size"):Connect(UpdateShadow)
    MainFrame:GetPropertyChangedSignal("Position"):Connect(UpdateShadow)
    UpdateShadow()

    local ResizeHandle = Instance.new("TextButton")
    ResizeHandle.Parent = MainFrame
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Position = UDim2.new(1, -15, 1, -15)
    ResizeHandle.Size = UDim2.new(0, 15, 0, 15)
    ResizeHandle.Text = "◢"
    ResizeHandle.TextSize = 14
    ResizeHandle.TextColor3 = Theme.TextMuted
    ResizeHandle.ZIndex = 100
    
    local Resizing = false
    local ResizeStart
    local StartScale
    
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Resizing = true
            ResizeStart = input.Position
            StartScale = MainScale.Scale
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if Resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - ResizeStart
            local baseWidth = WindowSize.X.Offset
            local scaleDelta = delta.X / baseWidth
            local targetScale = math.clamp(StartScale + scaleDelta, 0.4, 2.5)
            
            MainScale.Scale = targetScale
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Resizing = false
        end
    end)

    local WindowObj = { 
        Tabs = {}, 
        ConfigElements = {},
        ToggleKey = options.ToggleKey or Enum.KeyCode.RightControl 
    }

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == WindowObj.ToggleKey then
            MainFrame.Visible = not MainFrame.Visible
            DropShadow.Visible = MainFrame.Visible
        end
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BackgroundTransparency = 0.25
    Sidebar.Position = UDim2.new(0, 12, 0, 55)
    Sidebar.Size = UDim2.new(0, 160, 1, -67)
    Sidebar.BorderSizePixel = 0

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 6)
    SidebarCorner.Parent = Sidebar

    local SidebarStroke = Instance.new("UIStroke")
    SidebarStroke.Color = Theme.Border
    SidebarStroke.Thickness = 1
    SidebarStroke.Parent = Sidebar

    local GlobalIndicator = Instance.new("Frame")
    GlobalIndicator.Name = "GlobalIndicator"
    GlobalIndicator.Parent = Sidebar
    GlobalIndicator.BackgroundColor3 = Theme.Accent
    GlobalIndicator.Size = UDim2.new(0, 3, 0, 16)
    GlobalIndicator.Position = UDim2.new(0, 12, 0, 22)
    GlobalIndicator.BorderSizePixel = 0
    GlobalIndicator.ZIndex = 2
    GlobalIndicator.BackgroundTransparency = 1

    local GlobalIndCorner = Instance.new("UICorner")
    GlobalIndCorner.CornerRadius = UDim.new(1, 0)
    GlobalIndCorner.Parent = GlobalIndicator

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BorderSizePixel = 0

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabContainer
    TabPadding.PaddingTop = UDim.new(0, 12)
    TabPadding.PaddingLeft = UDim.new(0, 12)
    TabPadding.PaddingRight = UDim.new(0, 12)

    local ContentArea = Instance.new("Frame")
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundColor3 = Theme.Sidebar
    ContentArea.BackgroundTransparency = 0.25
    ContentArea.Position = UDim2.new(0, 184, 0, 55)
    ContentArea.Size = UDim2.new(1, -196, 1, -67)
    ContentArea.BorderSizePixel = 0

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 6)
    ContentCorner.Parent = ContentArea

    local ContentStroke = Instance.new("UIStroke")
    ContentStroke.Color = Theme.Border
    ContentStroke.Thickness = 1
    ContentStroke.Parent = ContentArea

    local Icons = {
        ["home"] = "rbxassetid://10723407389",
        ["house"] = "rbxassetid://10723407389",
        ["user"] = "rbxassetid://10747373176",
        ["player"] = "rbxassetid://10747373176",
        ["combat"] = "rbxassetid://10734975692",
        ["swords"] = "rbxassetid://10734975692",
        ["target"] = "rbxassetid://10734977012",
        ["settings"] = "rbxassetid://10734950309",
        ["cog"] = "rbxassetid://10709810948",
        ["shield"] = "rbxassetid://10709813000",
        ["search"] = "rbxassetid://10709810841",
        ["menu"] = "rbxassetid://10709804006"
    }

    -- WindowObj defined above

    function WindowObj:CreateTab(tabName, iconId)
        local actualIcon = iconId
        if iconId and Icons[iconId:lower()] then
            actualIcon = Icons[iconId:lower()]
        end

        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabContainer
        TabBtn.BackgroundColor3 = Theme.ElementBg
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 36)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.Text = actualIcon and ("            " .. tabName) or ("       " .. tabName)
        TabBtn.TextColor3 = Theme.TextMuted
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.AutoButtonColor = false

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabBtn

        local TabIcon
        if actualIcon then
            TabIcon = Instance.new("ImageLabel")
            TabIcon.Parent = TabBtn
            TabIcon.BackgroundTransparency = 1
            TabIcon.Position = UDim2.new(0, 12, 0.5, -8)
            TabIcon.Size = UDim2.new(0, 16, 0, 16)
            TabIcon.Image = actualIcon
            TabIcon.ImageColor3 = Theme.TextMuted
        end

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = ContentArea
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Theme.Border
        Page.Visible = false
        Page.BorderSizePixel = 0

        -- 2-Column Layout Containers
        local LeftCol = Instance.new("Frame")
        LeftCol.Name = "LeftCol"
        LeftCol.Parent = Page
        LeftCol.BackgroundTransparency = 1
        LeftCol.Size = UDim2.new(0.5, -20, 1, 0)
        LeftCol.Position = UDim2.new(0, 12, 0, 16)

        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.Parent = LeftCol
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Padding = UDim.new(0, 10)

        local RightCol = Instance.new("Frame")
        RightCol.Name = "RightCol"
        RightCol.Parent = Page
        RightCol.BackgroundTransparency = 1
        RightCol.Size = UDim2.new(0.5, -20, 1, 0)
        RightCol.Position = UDim2.new(0.5, 8, 0, 16)

        local RightLayout = Instance.new("UIListLayout")
        RightLayout.Parent = RightCol
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Padding = UDim.new(0, 10)
        
        local Divider = Instance.new("Frame")
        Divider.Name = "Divider"
        Divider.Parent = Page
        Divider.BackgroundColor3 = Theme.Border
        Divider.BorderSizePixel = 0
        Divider.Position = UDim2.new(0.5, -1, 0, 16)
        Divider.Size = UDim2.new(0, 2, 0, 0)
        
        local tabIndex = #WindowObj.Tabs + 1
        local indicatorY = 12 + (tabIndex - 1) * 40 + 10
        local tabData = {Button = TabBtn, Page = Page, IndicatorY = indicatorY, Icon = TabIcon, Selected = false}

        local function UpdateCanvas()
            local leftSize = LeftLayout.AbsoluteContentSize.Y
            local rightSize = RightLayout.AbsoluteContentSize.Y
            
            LeftCol.Size = UDim2.new(0.5, -20, 0, leftSize)
            RightCol.Size = UDim2.new(0.5, -20, 0, rightSize)
            
            local maxSize = math.max(leftSize, rightSize)
            local yOffset = LeftCol.Position.Y.Offset
            Page.CanvasSize = UDim2.new(0, 0, 0, maxSize + yOffset + 32)
            
            local visibleHeight = Page.AbsoluteWindowSize.Y > 0 and (Page.AbsoluteWindowSize.Y - yOffset - 16) or 500
            local dividerHeight = math.max(maxSize, visibleHeight)
            
            if maxSize > 0 then
                Divider.Size = UDim2.new(0, 2, 0, dividerHeight)
                Divider.Visible = true
            else
                Divider.Visible = false
            end
        end
        LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
        RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
        Page:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(UpdateCanvas)

        TabBtn.MouseButton1Click:Connect(function()
            for _, tb in pairs(WindowObj.Tabs) do
                tb.Selected = false
                tb.Page.Visible = false
                TweenService:Create(tb.Button, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundTransparency = 1, TextColor3 = Theme.TextMuted}):Play()
                if tb.Icon then
                    TweenService:Create(tb.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {ImageColor3 = Theme.TextMuted}):Play()
                end
            end
            
            tabData.Selected = true
            Page.Visible = true
            Page.Position = UDim2.new(0, 0, 0, 15)
            TweenService:Create(Page, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
            TweenService:Create(TabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundTransparency = 0, TextColor3 = Theme.Accent}):Play()
            
            GlobalIndicator.BackgroundTransparency = 0
            TweenService:Create(GlobalIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 12, 0, tabData.IndicatorY)
            }):Play()
            
            if TabIcon then
                TweenService:Create(TabIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {ImageColor3 = Theme.Accent}):Play()
            end
        end)

        TabBtn.MouseEnter:Connect(function()
            if not tabData.Selected then
                TweenService:Create(TabBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {TextColor3 = Theme.Text}):Play()
                if TabIcon then TweenService:Create(TabIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {ImageColor3 = Theme.Text}):Play() end
            end
        end)

        TabBtn.MouseLeave:Connect(function()
            if not tabData.Selected then
                TweenService:Create(TabBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {TextColor3 = Theme.TextMuted}):Play()
                if TabIcon then TweenService:Create(TabIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {ImageColor3 = Theme.TextMuted}):Play() end
            end
        end)

        local TabObj = {}
        TabObj.Page = Page
        
        -- [ Section System (2-Column) ]
        function TabObj:CreateSection(side)
            local ParentCol = (side:lower() == "left") and LeftCol or RightCol
            local Section = {}

            -- [ Create Button ]
            function Section:CreateButton(btnText, callback)
                local BtnFrame = Instance.new("Frame")
                BtnFrame.Parent = ParentCol
                BtnFrame.BackgroundColor3 = Theme.ElementBg
                BtnFrame.Size = UDim2.new(1, 0, 0, 42)
                BtnFrame.BorderSizePixel = 0

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = BtnFrame

                local BtnStroke = Instance.new("UIStroke")
                BtnStroke.Color = Theme.Border
                BtnStroke.Thickness = 1
                BtnStroke.Parent = BtnFrame

                local Btn = Instance.new("TextButton")
                Btn.Parent = BtnFrame
                Btn.BackgroundTransparency = 1
                Btn.Size = UDim2.new(1, 0, 1, 0)
                Btn.Font = Enum.Font.GothamMedium
                Btn.Text = "    " .. btnText
                Btn.TextColor3 = Theme.Text
                Btn.TextSize = 13
                Btn.TextXAlignment = Enum.TextXAlignment.Left

                local ClickIcon = Instance.new("ImageLabel")
                ClickIcon.Parent = BtnFrame
                ClickIcon.BackgroundTransparency = 1
                ClickIcon.Position = UDim2.new(1, -30, 0.5, -9)
                ClickIcon.Size = UDim2.new(0, 18, 0, 18)
                ClickIcon.Image = "rbxassetid://11681605335" 
                ClickIcon.ImageColor3 = Theme.TextMuted

                Btn.MouseEnter:Connect(function()
                    TweenService:Create(BtnFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.ElementHover}):Play()
                    TweenService:Create(BtnStroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Color = Theme.Accent}):Play()
                    TweenService:Create(ClickIcon, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {ImageColor3 = Theme.Accent, Position = UDim2.new(1, -26, 0.5, -9)}):Play()
                end)
                
                Btn.MouseLeave:Connect(function()
                    TweenService:Create(BtnFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.ElementBg}):Play()
                    TweenService:Create(BtnStroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Color = Theme.Border}):Play()
                    TweenService:Create(ClickIcon, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {ImageColor3 = Theme.TextMuted, Position = UDim2.new(1, -30, 0.5, -9)}):Play()
                end)

                Btn.MouseButton1Click:Connect(function()
                    local ripple = Instance.new("Frame")
                    ripple.Parent = BtnFrame
                    ripple.BackgroundColor3 = Theme.Accent
                    ripple.BackgroundTransparency = 0.8
                    ripple.BorderSizePixel = 0
                    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
                    ripple.Size = UDim2.new(0, 0, 0, 0)
                    
                    local rc = Instance.new("UICorner")
                    rc.CornerRadius = UDim.new(1, 0)
                    rc.Parent = ripple
                    
                    TweenService:Create(ripple, TweenInfo.new(0.4), {
                        Size = UDim2.new(1.5, 0, 3, 0),
                        Position = UDim2.new(-0.25, 0, -1, 0),
                        BackgroundTransparency = 1
                    }):Play()
                    
                    delay(0.4, function() ripple:Destroy() end)
                    
                    if callback then callback() end
                end)
            end

            -- [ Create Toggle ]
            function Section:CreateToggle(toggleText, defaultState, callback)
                local Toggled = defaultState or false
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Parent = ParentCol
                ToggleFrame.BackgroundColor3 = Theme.ElementBg
                ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
                ToggleFrame.BorderSizePixel = 0

                local TgCorner = Instance.new("UICorner")
                TgCorner.CornerRadius = UDim.new(0, 6)
                TgCorner.Parent = ToggleFrame

                local TgStroke = Instance.new("UIStroke")
                TgStroke.Color = Theme.Border
                TgStroke.Thickness = 1
                TgStroke.Parent = ToggleFrame

                local Label = Instance.new("TextLabel")
                Label.Parent = ToggleFrame
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, -60, 1, 0)
                Label.Position = UDim2.new(0, 16, 0, 0)
                Label.Font = Enum.Font.GothamMedium
                Label.Text = toggleText
                Label.TextColor3 = Theme.Text
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left

                local SwitchBg = Instance.new("Frame")
                SwitchBg.Parent = ToggleFrame
                SwitchBg.BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(40, 42, 55)
                SwitchBg.Position = UDim2.new(1, -45, 0.5, -10)
                SwitchBg.Size = UDim2.new(0, 34, 0, 20)
                SwitchBg.BorderSizePixel = 0

                local SwitchCorner = Instance.new("UICorner")
                SwitchCorner.CornerRadius = UDim.new(1, 0)
                SwitchCorner.Parent = SwitchBg
                
                local Knob = Instance.new("Frame")
                Knob.Parent = SwitchBg
                Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Knob.Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                Knob.Size = UDim2.new(0, 16, 0, 16)
                Knob.BorderSizePixel = 0
                
                local KnobCorner = Instance.new("UICorner")
                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = Knob

                local Hitbox = Instance.new("TextButton")
                Hitbox.Parent = ToggleFrame
                Hitbox.BackgroundTransparency = 1
                Hitbox.Size = UDim2.new(1, 0, 1, 0)
                Hitbox.Text = ""

                Hitbox.MouseEnter:Connect(function()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.ElementHover}):Play()
                    TweenService:Create(TgStroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Color = Theme.Accent}):Play()
                end)
                
                Hitbox.MouseLeave:Connect(function()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.ElementBg}):Play()
                    TweenService:Create(TgStroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Color = Theme.Border}):Play()
                end)

                Hitbox.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    TweenService:Create(SwitchBg, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                        BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(40, 42, 55)
                    }):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    }):Play()
                    if callback then callback(Toggled) end
                end)
                
                if Toggled and callback then
                    task.spawn(callback, Toggled)
                end

                local ToggleObj = {}
                function ToggleObj:SetState(state)
                    Toggled = state
                    TweenService:Create(SwitchBg, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                        BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(40, 42, 55)
                    }):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    }):Play()
                    if callback then callback(Toggled) end
                end

                function ToggleObj:GetState()
                    return Toggled
                end

                WindowObj.ConfigElements[toggleText] = {
                    Type = "Toggle",
                    GetValue = function() return Toggled end,
                    SetValue = function(val) ToggleObj:SetState(val) end
                }

                return ToggleObj
            end

            -- [ Create Slider ]
            function Section:CreateSlider(sliderText, min, max, defaultValue, callback)
                local Value = defaultValue or min
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Parent = ParentCol
                SliderFrame.BackgroundColor3 = Theme.ElementBg
                SliderFrame.Size = UDim2.new(1, 0, 0, 52)
                SliderFrame.BorderSizePixel = 0

                local SlCorner = Instance.new("UICorner")
                SlCorner.CornerRadius = UDim.new(0, 6)
                SlCorner.Parent = SliderFrame

                local SlStroke = Instance.new("UIStroke")
                SlStroke.Color = Theme.Border
                SlStroke.Thickness = 1
                SlStroke.Parent = SliderFrame

                local Label = Instance.new("TextLabel")
                Label.Parent = SliderFrame
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, -100, 0, 24)
                Label.Position = UDim2.new(0, 16, 0, 4)
                Label.Font = Enum.Font.GothamMedium
                Label.Text = sliderText
                Label.TextColor3 = Theme.Text
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Parent = SliderFrame
                ValLabel.BackgroundTransparency = 1
                ValLabel.Size = UDim2.new(0, 80, 0, 24)
                ValLabel.Position = UDim2.new(1, -96, 0, 4)
                ValLabel.Font = Enum.Font.GothamBold
                ValLabel.Text = tostring(Value)
                ValLabel.TextColor3 = Theme.Accent
                ValLabel.TextSize = 13
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right

                local Track = Instance.new("TextButton")
                Track.Parent = SliderFrame
                Track.BackgroundColor3 = Color3.fromRGB(35, 38, 50)
                Track.Position = UDim2.new(0, 16, 0, 32)
                Track.Size = UDim2.new(1, -32, 0, 6)
                Track.BorderSizePixel = 0
                Track.Text = ""
                Track.AutoButtonColor = false

                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = Track

                local Hitbox = Instance.new("TextButton")
                Hitbox.Parent = SliderFrame
                Hitbox.BackgroundTransparency = 1
                Hitbox.Position = UDim2.new(0, 0, 0, 0)
                Hitbox.Size = UDim2.new(1, 0, 1, 0)
                Hitbox.Text = ""
                Hitbox.ZIndex = 5

                local Fill = Instance.new("Frame")
                Fill.Parent = Track
                Fill.BackgroundColor3 = Theme.Accent
                Fill.Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
                Fill.BorderSizePixel = 0

                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = Fill

                local Knob = Instance.new("Frame")
                Knob.Parent = Track
                Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Knob.Size = UDim2.new(0, 12, 0, 12)
                Knob.Position = UDim2.new((Value - min) / (max - min), -6, 0.5, -6)
                Knob.BorderSizePixel = 0

                local KnobCorner = Instance.new("UICorner")
                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = Knob

                local function UpdateSliderInput(input)
                    local relativeX = input.Position.X - Track.AbsolutePosition.X
                    local ratio = math.clamp(relativeX / Track.AbsoluteSize.X, 0, 1)
                    
                    local rawValue = min + (max - min) * ratio
                    local roundedValue = math.round(rawValue)
                    
                    ValLabel.Text = tostring(roundedValue)
                    
                    TweenService:Create(Fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(ratio, 0, 1, 0)
                    }):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Position = UDim2.new(ratio, -6, 0.5, -6)
                    }):Play()
                    
                    if callback then callback(roundedValue) end
                end

                local Dragging = false
                Hitbox.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        UpdateSliderInput(input)
                    end
                end)

                Hitbox.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSliderInput(input)
                    end
                end)

                SliderFrame.MouseEnter:Connect(function()
                    TweenService:Create(SliderFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.ElementHover}):Play()
                    TweenService:Create(SlStroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Color = Theme.Accent}):Play()
                end)
                
                SliderFrame.MouseLeave:Connect(function()
                    TweenService:Create(SliderFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.ElementBg}):Play()
                    TweenService:Create(SlStroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Color = Theme.Border}):Play()
                end)

                local SliderObj = {}
                function SliderObj:SetValue(val)
                    val = math.clamp(val, min, max)
                    Value = val
                    local ratio = (val - min) / (max - min)
                    ValLabel.Text = tostring(val)
                    TweenService:Create(Fill, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(ratio, 0, 1, 0)}):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(ratio, -6, 0.5, -6)}):Play()
                    if callback then callback(val) end
                end

                WindowObj.ConfigElements[sliderText] = {
                    Type = "Slider",
                    GetValue = function() return Value end,
                    SetValue = function(val) SliderObj:SetValue(val) end
                }

                return SliderObj
            end

            -- [ Create Dropdown ]
            function Section:CreateDropdown(dropdownText, options, defaultOption, callback)
                options = options or {}
                local CurrentOption = defaultOption or options[1] or ""
                local Expanded = false
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Parent = ParentCol
                DropdownFrame.BackgroundColor3 = Theme.ElementBg
                DropdownFrame.Size = UDim2.new(1, 0, 0, 42)
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.ClipsDescendants = true

                local DpCorner = Instance.new("UICorner")
                DpCorner.CornerRadius = UDim.new(0, 6)
                DpCorner.Parent = DropdownFrame

                local DpStroke = Instance.new("UIStroke")
                DpStroke.Color = Theme.Border
                DpStroke.Thickness = 1
                DpStroke.Parent = DropdownFrame

                local HeaderBtn = Instance.new("TextButton")
                HeaderBtn.Parent = DropdownFrame
                HeaderBtn.BackgroundTransparency = 1
                HeaderBtn.Size = UDim2.new(1, 0, 0, 42)
                HeaderBtn.Font = Enum.Font.GothamMedium
                HeaderBtn.Text = ""

                local Label = Instance.new("TextLabel")
                Label.Parent = DropdownFrame
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(0.5, -16, 0, 42)
                Label.Position = UDim2.new(0, 16, 0, 0)
                Label.Font = Enum.Font.GothamMedium
                Label.Text = dropdownText
                Label.TextColor3 = Theme.Text
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left

                local SelLabel = Instance.new("TextLabel")
                SelLabel.Parent = DropdownFrame
                SelLabel.BackgroundTransparency = 1
                SelLabel.Size = UDim2.new(0.5, -40, 0, 42)
                SelLabel.Position = UDim2.new(0.5, 8, 0, 0)
                SelLabel.Font = Enum.Font.GothamBold
                SelLabel.Text = tostring(CurrentOption)
                SelLabel.TextColor3 = Theme.Accent
                SelLabel.TextSize = 13
                SelLabel.TextXAlignment = Enum.TextXAlignment.Right

                local ArrowIcon = Instance.new("ImageLabel")
                ArrowIcon.Parent = DropdownFrame
                ArrowIcon.BackgroundTransparency = 1
                ArrowIcon.Position = UDim2.new(1, -30, 0, 12)
                ArrowIcon.Size = UDim2.new(0, 18, 0, 18)
                ArrowIcon.Image = "rbxassetid://10709790948" 
                ArrowIcon.ImageColor3 = Theme.TextMuted

                local OptionContainer = Instance.new("Frame")
                OptionContainer.Name = "OptionContainer"
                OptionContainer.Parent = DropdownFrame
                OptionContainer.BackgroundTransparency = 1
                OptionContainer.Position = UDim2.new(0, 0, 0, 42)
                OptionContainer.Size = UDim2.new(1, 0, 0, 0)

                local OptionLayout = Instance.new("UIListLayout")
                OptionLayout.Parent = OptionContainer
                OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
                OptionLayout.Padding = UDim.new(0, 2)

                local OptionPadding = Instance.new("UIPadding")
                OptionPadding.Parent = OptionContainer
                OptionPadding.PaddingLeft = UDim.new(0, 8)
                OptionPadding.PaddingRight = UDim.new(0, 8)
                OptionPadding.PaddingTop = UDim.new(0, 4)
                OptionPadding.PaddingBottom = UDim.new(0, 4)

                local function UpdateDropdownSize()
                    local targetHeight = Expanded and (42 + OptionLayout.AbsoluteContentSize.Y + 8) or 42
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                        Size = UDim2.new(1, 0, 0, targetHeight)
                    }):Play()
                    TweenService:Create(ArrowIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                        Rotation = Expanded and 180 or 0
                    }):Play()
                end

                local DropdownObj = { Options = {} }

                local function CreateOptionButton(optName)
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Parent = OptionContainer
                    OptBtn.BackgroundColor3 = Theme.ElementBg
                    OptBtn.Size = UDim2.new(1, 0, 0, 30)
                    OptBtn.Font = Enum.Font.GothamMedium
                    OptBtn.Text = "        " .. tostring(optName)
                    OptBtn.TextColor3 = (CurrentOption == optName) and Theme.Accent or Theme.TextMuted
                    OptBtn.TextSize = 12
                    OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                    OptBtn.AutoButtonColor = false

                    local OptCorner = Instance.new("UICorner")
                    OptCorner.CornerRadius = UDim.new(0, 4)
                    OptCorner.Parent = OptBtn

                    local OptStroke = Instance.new("UIStroke")
                    OptStroke.Color = Theme.Border
                    OptStroke.Thickness = 1
                    OptStroke.Parent = OptBtn
                    OptStroke.Enabled = (CurrentOption == optName)

                    OptBtn.MouseEnter:Connect(function()
                        if CurrentOption ~= optName then
                            TweenService:Create(OptBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementHover, TextColor3 = Theme.Text}):Play()
                        end
                    end)

                    OptBtn.MouseLeave:Connect(function()
                        if CurrentOption ~= optName then
                            TweenService:Create(OptBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementBg, TextColor3 = Theme.TextMuted}):Play()
                        end
                    end)

                    OptBtn.MouseButton1Click:Connect(function()
                        CurrentOption = optName
                        SelLabel.Text = tostring(optName)
                        Expanded = false
                        UpdateDropdownSize()
                        
                        for _, btnInfo in pairs(DropdownObj.Options) do
                            local isSelected = (btnInfo.Name == optName)
                            btnInfo.Button.TextColor3 = isSelected and Theme.Accent or Theme.TextMuted
                            btnInfo.Stroke.Enabled = isSelected
                        end

                        if callback then callback(optName) end
                    end)

                    table.insert(DropdownObj.Options, {Name = optName, Button = OptBtn, Stroke = OptStroke})
                end

                for _, option in ipairs(options) do
                    CreateOptionButton(option)
                end

                HeaderBtn.MouseEnter:Connect(function()
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.ElementHover}):Play()
                    TweenService:Create(DpStroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Color = Theme.Accent}):Play()
                    TweenService:Create(ArrowIcon, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {ImageColor3 = Theme.Accent}):Play()
                end)

                HeaderBtn.MouseLeave:Connect(function()
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.ElementBg}):Play()
                    TweenService:Create(DpStroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Color = Theme.Border}):Play()
                    TweenService:Create(ArrowIcon, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {ImageColor3 = Theme.TextMuted}):Play()
                end)

                HeaderBtn.MouseButton1Click:Connect(function()
                    Expanded = not Expanded
                    UpdateDropdownSize()
                end)

                OptionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    if Expanded then
                        OptionContainer.Size = UDim2.new(1, 0, 0, OptionLayout.AbsoluteContentSize.Y + 8)
                        DropdownFrame.Size = UDim2.new(1, 0, 0, 42 + OptionLayout.AbsoluteContentSize.Y + 8)
                    else
                        OptionContainer.Size = UDim2.new(1, 0, 0, 0)
                        DropdownFrame.Size = UDim2.new(1, 0, 0, 42)
                    end
                end)

                function DropdownObj:Refresh(newOptions, newDefault)
                    for _, opt in pairs(DropdownObj.Options) do
                        opt.Button:Destroy()
                    end
                    DropdownObj.Options = {}
                    
                    CurrentOption = newDefault or newOptions[1] or ""
                    SelLabel.Text = tostring(CurrentOption)

                    for _, option in ipairs(newOptions) do
                        CreateOptionButton(option)
                    end
                    UpdateDropdownSize()
                end

                WindowObj.ConfigElements[dropdownText] = {
                    Type = "Dropdown",
                    GetValue = function() return CurrentOption end,
                    SetValue = function(val) 
                        CurrentOption = val
                        SelLabel.Text = tostring(val)
                        for _, btnInfo in pairs(DropdownObj.Options) do
                            local isSelected = (btnInfo.Name == val)
                            btnInfo.Button.TextColor3 = isSelected and Theme.Accent or Theme.TextMuted
                            btnInfo.Stroke.Enabled = isSelected
                        end
                        if callback then callback(val) end
                    end
                }

                return DropdownObj
            end

            -- [ Create Multi Dropdown ]
            function Section:CreateMultiDropdown(dropdownText, options, defaultOptions, callback)
                options = options or {}
                local CurrentOptions = type(defaultOptions) == "table" and defaultOptions or {}
                local Expanded = false
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Parent = ParentCol
                DropdownFrame.BackgroundColor3 = Theme.ElementBg
                DropdownFrame.Size = UDim2.new(1, 0, 0, 42)
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.ClipsDescendants = true

                local DpCorner = Instance.new("UICorner")
                DpCorner.CornerRadius = UDim.new(0, 6)
                DpCorner.Parent = DropdownFrame

                local DpStroke = Instance.new("UIStroke")
                DpStroke.Color = Theme.Border
                DpStroke.Thickness = 1
                DpStroke.Parent = DropdownFrame

                local HeaderBtn = Instance.new("TextButton")
                HeaderBtn.Parent = DropdownFrame
                HeaderBtn.BackgroundTransparency = 1
                HeaderBtn.Size = UDim2.new(1, 0, 0, 42)
                HeaderBtn.Font = Enum.Font.GothamMedium
                HeaderBtn.Text = ""

                local Label = Instance.new("TextLabel")
                Label.Parent = DropdownFrame
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(0.4, -16, 0, 42)
                Label.Position = UDim2.new(0, 16, 0, 0)
                Label.Font = Enum.Font.GothamMedium
                Label.Text = dropdownText
                Label.TextColor3 = Theme.Text
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left

                local SelLabel = Instance.new("TextLabel")
                SelLabel.Parent = DropdownFrame
                SelLabel.BackgroundTransparency = 1
                SelLabel.Size = UDim2.new(0.6, -40, 0, 42)
                SelLabel.Position = UDim2.new(0.4, 8, 0, 0)
                SelLabel.Font = Enum.Font.GothamBold
                
                local function UpdateSelLabel()
                    if #CurrentOptions == 0 then
                        SelLabel.Text = "None"
                        SelLabel.TextColor3 = Theme.TextMuted
                    else
                        SelLabel.Text = table.concat(CurrentOptions, ", ")
                        SelLabel.TextColor3 = Theme.Accent
                    end
                end
                UpdateSelLabel()
                
                SelLabel.TextSize = 13
                SelLabel.TextXAlignment = Enum.TextXAlignment.Right
                SelLabel.TextTruncate = Enum.TextTruncate.AtEnd

                local ArrowIcon = Instance.new("ImageLabel")
                ArrowIcon.Parent = DropdownFrame
                ArrowIcon.BackgroundTransparency = 1
                ArrowIcon.Position = UDim2.new(1, -30, 0, 12)
                ArrowIcon.Size = UDim2.new(0, 18, 0, 18)
                ArrowIcon.Image = "rbxassetid://10709790948" 
                ArrowIcon.ImageColor3 = Theme.TextMuted

                local OptionContainer = Instance.new("Frame")
                OptionContainer.Name = "OptionContainer"
                OptionContainer.Parent = DropdownFrame
                OptionContainer.BackgroundTransparency = 1
                OptionContainer.Position = UDim2.new(0, 0, 0, 42)
                OptionContainer.Size = UDim2.new(1, 0, 0, 0)

                local OptionLayout = Instance.new("UIListLayout")
                OptionLayout.Parent = OptionContainer
                OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
                OptionLayout.Padding = UDim.new(0, 2)

                local OptionPadding = Instance.new("UIPadding")
                OptionPadding.Parent = OptionContainer
                OptionPadding.PaddingLeft = UDim.new(0, 8)
                OptionPadding.PaddingRight = UDim.new(0, 8)
                OptionPadding.PaddingTop = UDim.new(0, 4)
                OptionPadding.PaddingBottom = UDim.new(0, 4)

                local function UpdateDropdownSize()
                    local targetHeight = Expanded and (42 + OptionLayout.AbsoluteContentSize.Y + 8) or 42
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                        Size = UDim2.new(1, 0, 0, targetHeight)
                    }):Play()
                    TweenService:Create(ArrowIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                        Rotation = Expanded and 180 or 0
                    }):Play()
                end

                local MultiDropdownObj = { Options = {} }

                local function CreateOptionButton(optName)
                    local isOptSelected = table.find(CurrentOptions, optName) ~= nil
                    
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Parent = OptionContainer
                    OptBtn.BackgroundColor3 = Theme.ElementBg
                    OptBtn.Size = UDim2.new(1, 0, 0, 30)
                    OptBtn.Font = Enum.Font.GothamMedium
                    OptBtn.Text = "        " .. tostring(optName)
                    OptBtn.TextColor3 = isOptSelected and Theme.Accent or Theme.TextMuted
                    OptBtn.TextSize = 12
                    OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                    OptBtn.AutoButtonColor = false

                    local OptCorner = Instance.new("UICorner")
                    OptCorner.CornerRadius = UDim.new(0, 4)
                    OptCorner.Parent = OptBtn

                    local OptStroke = Instance.new("UIStroke")
                    OptStroke.Color = Theme.Border
                    OptStroke.Thickness = 1
                    OptStroke.Parent = OptBtn
                    OptStroke.Enabled = isOptSelected

                    OptBtn.MouseEnter:Connect(function()
                        if not table.find(CurrentOptions, optName) then
                            TweenService:Create(OptBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementHover, TextColor3 = Theme.Text}):Play()
                        end
                    end)

                    OptBtn.MouseLeave:Connect(function()
                        if not table.find(CurrentOptions, optName) then
                            TweenService:Create(OptBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementBg, TextColor3 = Theme.TextMuted}):Play()
                        end
                    end)

                    OptBtn.MouseButton1Click:Connect(function()
                        local idx = table.find(CurrentOptions, optName)
                        if idx then
                            table.remove(CurrentOptions, idx)
                        else
                            table.insert(CurrentOptions, optName)
                        end
                        
                        UpdateSelLabel()
                        
                        for _, btnInfo in pairs(MultiDropdownObj.Options) do
                            local selected = table.find(CurrentOptions, btnInfo.Name) ~= nil
                            btnInfo.Button.TextColor3 = selected and Theme.Accent or Theme.TextMuted
                            btnInfo.Stroke.Enabled = selected
                        end

                        if callback then callback(CurrentOptions) end
                    end)

                    table.insert(MultiDropdownObj.Options, {Name = optName, Button = OptBtn, Stroke = OptStroke})
                end

                for _, option in ipairs(options) do
                    CreateOptionButton(option)
                end

                HeaderBtn.MouseEnter:Connect(function()
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.ElementHover}):Play()
                    TweenService:Create(DpStroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Color = Theme.Accent}):Play()
                    TweenService:Create(ArrowIcon, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {ImageColor3 = Theme.Accent}):Play()
                end)

                HeaderBtn.MouseLeave:Connect(function()
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.ElementBg}):Play()
                    TweenService:Create(DpStroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Color = Theme.Border}):Play()
                    TweenService:Create(ArrowIcon, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {ImageColor3 = Theme.TextMuted}):Play()
                end)

                HeaderBtn.MouseButton1Click:Connect(function()
                    Expanded = not Expanded
                    UpdateDropdownSize()
                end)

                function MultiDropdownObj:Refresh(newOptions, newDefault)
                    for _, btnInfo in pairs(MultiDropdownObj.Options) do
                        btnInfo.Button:Destroy()
                    end
                    MultiDropdownObj.Options = {}
                    options = newOptions or {}
                    CurrentOptions = type(newDefault) == "table" and newDefault or {}
                    UpdateSelLabel()
                    
                    for _, option in ipairs(options) do
                        CreateOptionButton(option)
                    end
                    Expanded = false
                    UpdateDropdownSize()
                end

                WindowObj.ConfigElements[dropdownText] = {
                    Type = "MultiDropdown",
                    GetValue = function() return CurrentOptions end,
                    SetValue = function(val) 
                        if type(val) == "table" then
                            CurrentOptions = val
                            UpdateSelLabel()
                            for _, btnInfo in pairs(MultiDropdownObj.Options) do
                                local selected = table.find(CurrentOptions, btnInfo.Name) ~= nil
                                btnInfo.Button.TextColor3 = selected and Theme.Accent or Theme.TextMuted
                                btnInfo.Stroke.Enabled = selected
                            end
                            if callback then callback(CurrentOptions) end
                        end
                    end
                }

                return MultiDropdownObj
            end

            -- [ Create TextBox ]
            function Section:CreateTextBox(tbText, placeholder, callback)
                local TbFrame = Instance.new("Frame")
                TbFrame.Parent = ParentCol
                TbFrame.BackgroundColor3 = Theme.ElementBg
                TbFrame.Size = UDim2.new(1, 0, 0, 42)
                TbFrame.BorderSizePixel = 0

                local TbCorner = Instance.new("UICorner")
                TbCorner.CornerRadius = UDim.new(0, 6)
                TbCorner.Parent = TbFrame

                local TbStroke = Instance.new("UIStroke")
                TbStroke.Color = Theme.Border
                TbStroke.Thickness = 1
                TbStroke.Parent = TbFrame

                local TbLabel = Instance.new("TextLabel")
                TbLabel.Parent = TbFrame
                TbLabel.BackgroundTransparency = 1
                TbLabel.Position = UDim2.new(0, 16, 0, 0)
                TbLabel.Size = UDim2.new(0.5, -20, 1, 0)
                TbLabel.Font = Enum.Font.GothamMedium
                TbLabel.Text = tbText
                TbLabel.TextColor3 = Theme.Text
                TbLabel.TextSize = 13
                TbLabel.TextXAlignment = Enum.TextXAlignment.Left

                local TextBoxBg = Instance.new("Frame")
                TextBoxBg.Parent = TbFrame
                TextBoxBg.BackgroundColor3 = Color3.fromRGB(35, 38, 50)
                TextBoxBg.Position = UDim2.new(0.5, 0, 0.5, -13)
                TextBoxBg.Size = UDim2.new(0.5, -16, 0, 26)
                TextBoxBg.BorderSizePixel = 0
                TextBoxBg.ClipsDescendants = true

                local BgCorner = Instance.new("UICorner")
                BgCorner.CornerRadius = UDim.new(0, 4)
                BgCorner.Parent = TextBoxBg

                local BgStroke = Instance.new("UIStroke")
                BgStroke.Color = Theme.Border
                BgStroke.Thickness = 1
                BgStroke.Parent = TextBoxBg

                local TextBox = Instance.new("TextBox")
                TextBox.Parent = TextBoxBg
                TextBox.BackgroundTransparency = 1
                TextBox.Size = UDim2.new(1, 0, 1, 0)
                TextBox.Font = Enum.Font.Gotham
                TextBox.PlaceholderText = placeholder or ""
                TextBox.Text = ""
                TextBox.TextColor3 = Theme.Text
                TextBox.PlaceholderColor3 = Theme.TextMuted
                TextBox.TextSize = 12

                TextBox.Focused:Connect(function()
                    TweenService:Create(BgStroke, TweenInfo.new(0.2), {Color = Theme.Accent}):Play()
                end)

                TextBox.FocusLost:Connect(function(enterPressed)
                    TweenService:Create(BgStroke, TweenInfo.new(0.2), {Color = Theme.Border}):Play()
                    if callback then
                        callback(TextBox.Text)
                    end
                end)

                local TextBoxObj = {}
                function TextBoxObj:GetValue()
                    return TextBox.Text
                end
                function TextBoxObj:SetValue(val)
                    TextBox.Text = tostring(val)
                end

                WindowObj.ConfigElements[tbText] = {
                    Type = "TextBox",
                    GetValue = function() return TextBox.Text end,
                    SetValue = function(val) TextBox.Text = tostring(val) end
                }

                return TextBoxObj
            end

            -- [ Create Keybind ]
            function Section:CreateKeybind(kbText, defaultKey, callback)
                local KbFrame = Instance.new("Frame")
                KbFrame.Parent = ParentCol
                KbFrame.BackgroundColor3 = Theme.ElementBg
                KbFrame.Size = UDim2.new(1, 0, 0, 42)
                KbFrame.BorderSizePixel = 0

                local KbCorner = Instance.new("UICorner")
                KbCorner.CornerRadius = UDim.new(0, 6)
                KbCorner.Parent = KbFrame

                local KbStroke = Instance.new("UIStroke")
                KbStroke.Color = Theme.Border
                KbStroke.Thickness = 1
                KbStroke.Parent = KbFrame

                local KbLabel = Instance.new("TextLabel")
                KbLabel.Parent = KbFrame
                KbLabel.BackgroundTransparency = 1
                KbLabel.Position = UDim2.new(0, 16, 0, 0)
                KbLabel.Size = UDim2.new(0.5, -20, 1, 0)
                KbLabel.Font = Enum.Font.GothamMedium
                KbLabel.Text = kbText
                KbLabel.TextColor3 = Theme.Text
                KbLabel.TextSize = 13
                KbLabel.TextXAlignment = Enum.TextXAlignment.Left

                local BindBg = Instance.new("Frame")
                BindBg.Parent = KbFrame
                BindBg.BackgroundColor3 = Color3.fromRGB(35, 38, 50)
                BindBg.Position = UDim2.new(0.5, 0, 0.5, -12)
                BindBg.Size = UDim2.new(0.5, -16, 0, 24)
                BindBg.BorderSizePixel = 0
                BindBg.ClipsDescendants = true

                local BgCorner = Instance.new("UICorner")
                BgCorner.CornerRadius = UDim.new(0, 4)
                BgCorner.Parent = BindBg

                local BgStroke = Instance.new("UIStroke")
                BgStroke.Color = Theme.Border
                BgStroke.Thickness = 1
                BgStroke.Parent = BindBg

                local BindBtn = Instance.new("TextButton")
                BindBtn.Parent = BindBg
                BindBtn.BackgroundTransparency = 1
                BindBtn.Size = UDim2.new(1, 0, 1, 0)
                BindBtn.Font = Enum.Font.GothamMedium
                BindBtn.Text = defaultKey.Name
                BindBtn.TextColor3 = Theme.TextMuted
                BindBtn.TextSize = 12

                local CurrentKey = defaultKey
                local IsBinding = false

                BindBtn.MouseButton1Click:Connect(function()
                    if IsBinding then return end
                    IsBinding = true
                    BindBtn.Text = "..."
                    TweenService:Create(BindBg, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementHover}):Play()
                    TweenService:Create(BgStroke, TweenInfo.new(0.2), {Color = Theme.Accent}):Play()
                end)

                BindBtn.MouseEnter:Connect(function()
                    if not IsBinding then
                        TweenService:Create(BindBg, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementHover}):Play()
                        TweenService:Create(BgStroke, TweenInfo.new(0.2), {Color = Theme.Accent}):Play()
                    end
                end)

                BindBtn.MouseLeave:Connect(function()
                    if not IsBinding then
                        TweenService:Create(BindBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 38, 50)}):Play()
                        TweenService:Create(BgStroke, TweenInfo.new(0.2), {Color = Theme.Border}):Play()
                    end
                end)

                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not gameProcessed and not IsBinding then
                        if input.KeyCode == CurrentKey then
                            if callback then callback(CurrentKey) end
                        end
                    elseif IsBinding and input.UserInputType == Enum.UserInputType.Keyboard then
                        local key = input.KeyCode
                        if key == Enum.KeyCode.Escape or key == Enum.KeyCode.Backspace then
                            IsBinding = false
                            BindBtn.Text = CurrentKey.Name
                        else
                            CurrentKey = key
                            BindBtn.Text = CurrentKey.Name
                           if callback then callback(key) end
                        end
                        task.delay(0.1, function()
                            IsBinding = false
                            TweenService:Create(BindBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 38, 50)}):Play()
                            TweenService:Create(BgStroke, TweenInfo.new(0.2), {Color = Theme.Border}):Play()
                        end)
                    end
                end)

                WindowObj.ConfigElements[kbText] = {
                    Type = "Keybind",
                    GetValue = function() return CurrentKey.Name end,
                    SetValue = function(val) 
                        local keyEnum = Enum.KeyCode[val]
                        if keyEnum then
                            CurrentKey = keyEnum
                            BindBtn.Text = CurrentKey.Name
                            if callback then callback(CurrentKey) end
                        end
                    end
                }
            end

            -- [ Create Label ]
            function Section:CreateLabel(labelText)
                local LblFrame = Instance.new("Frame")
                LblFrame.Parent = ParentCol
                LblFrame.BackgroundTransparency = 1
                LblFrame.Size = UDim2.new(1, 0, 0, 24)
                
                local Lbl = Instance.new("TextLabel")
                Lbl.Parent = LblFrame
                Lbl.BackgroundTransparency = 1
                Lbl.Size = UDim2.new(1, -20, 1, 0)
                Lbl.Position = UDim2.new(0, 10, 0, 0)
                Lbl.Font = Enum.Font.Gotham
                Lbl.Text = labelText
                Lbl.TextColor3 = Theme.TextMuted
                Lbl.TextSize = 13
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.TextWrapped = true
                
                local LblObj = {}
                function LblObj:SetText(newText)
                    Lbl.Text = newText
                end
                return LblObj
            end

            -- [ Create Divider ]
            function Section:CreateDivider()
                local DivFrame = Instance.new("Frame")
                DivFrame.Parent = ParentCol
                DivFrame.BackgroundTransparency = 1
                DivFrame.Size = UDim2.new(1, 0, 0, 16)
                
                local Line = Instance.new("Frame")
                Line.Parent = DivFrame
                Line.BackgroundColor3 = Theme.Border
                Line.BorderSizePixel = 0
                Line.Size = UDim2.new(1, -20, 0, 1)
                Line.Position = UDim2.new(0, 10, 0.5, 0)
            end

            -- [ Create Colorpicker ]
            function Section:CreateColorpicker(cpText, defaultColor, callback)
                local CurrentColor = defaultColor or Color3.fromRGB(255, 255, 255)
                local Expanded = false

                local CpFrame = Instance.new("Frame")
                CpFrame.Parent = ParentCol
                CpFrame.BackgroundColor3 = Theme.ElementBg
                CpFrame.Size = UDim2.new(1, 0, 0, 42)
                CpFrame.BorderSizePixel = 0
                CpFrame.ClipsDescendants = true

                local CpCorner = Instance.new("UICorner")
                CpCorner.CornerRadius = UDim.new(0, 6)
                CpCorner.Parent = CpFrame

                local CpStroke = Instance.new("UIStroke")
                CpStroke.Color = Theme.Border
                CpStroke.Thickness = 1
                CpStroke.Parent = CpFrame

                local HeaderBtn = Instance.new("TextButton")
                HeaderBtn.Parent = CpFrame
                HeaderBtn.BackgroundTransparency = 1
                HeaderBtn.Size = UDim2.new(1, 0, 0, 42)
                HeaderBtn.Text = ""

                local CpLabel = Instance.new("TextLabel")
                CpLabel.Parent = CpFrame
                CpLabel.BackgroundTransparency = 1
                CpLabel.Position = UDim2.new(0, 16, 0, 0)
                CpLabel.Size = UDim2.new(0.5, -20, 0, 42)
                CpLabel.Font = Enum.Font.GothamMedium
                CpLabel.Text = cpText
                CpLabel.TextColor3 = Theme.Text
                CpLabel.TextSize = 13
                CpLabel.TextXAlignment = Enum.TextXAlignment.Left

                local ColorDisplay = Instance.new("Frame")
                ColorDisplay.Parent = CpFrame
                ColorDisplay.BackgroundColor3 = CurrentColor
                ColorDisplay.Position = UDim2.new(1, -40, 0, 11)
                ColorDisplay.Size = UDim2.new(0, 24, 0, 20)
                ColorDisplay.BorderSizePixel = 0
                
                local DisplayCorner = Instance.new("UICorner")
                DisplayCorner.CornerRadius = UDim.new(0, 4)
                DisplayCorner.Parent = ColorDisplay
                
                local DisplayStroke = Instance.new("UIStroke")
                DisplayStroke.Color = Color3.fromRGB(255,255,255)
                DisplayStroke.Thickness = 1
                DisplayStroke.Transparency = 0.8
                DisplayStroke.Parent = ColorDisplay

                local SliderContainer = Instance.new("Frame")
                SliderContainer.Parent = CpFrame
                SliderContainer.BackgroundTransparency = 1
                SliderContainer.Position = UDim2.new(0, 0, 0, 42)
                SliderContainer.Size = UDim2.new(1, 0, 0, 90)
                
                local function UpdateCpSize()
                    local targetHeight = Expanded and (42 + 90) or 42
                    TweenService:Create(CpFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                        Size = UDim2.new(1, 0, 0, targetHeight)
                    }):Play()
                end
                
                HeaderBtn.MouseButton1Click:Connect(function()
                    Expanded = not Expanded
                    UpdateCpSize()
                end)

                local function MakeCPTrack(name, yPos, initVal, onChange)
                    local SlFrame = Instance.new("Frame")
                    SlFrame.Parent = SliderContainer
                    SlFrame.BackgroundTransparency = 1
                    SlFrame.Position = UDim2.new(0, 0, 0, yPos)
                    SlFrame.Size = UDim2.new(1, 0, 0, 30)

                    local Lbl = Instance.new("TextLabel")
                    Lbl.Parent = SlFrame
                    Lbl.BackgroundTransparency = 1
                    Lbl.Position = UDim2.new(0, 16, 0, 0)
                    Lbl.Size = UDim2.new(0, 20, 1, 0)
                    Lbl.Font = Enum.Font.GothamMedium
                    Lbl.Text = name
                    Lbl.TextColor3 = Theme.Text
                    Lbl.TextSize = 12
                    Lbl.TextXAlignment = Enum.TextXAlignment.Left

                    local Track = Instance.new("Frame")
                    Track.Parent = SlFrame
                    Track.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Track.Position = UDim2.new(0, 40, 0.5, -3)
                    Track.Size = UDim2.new(1, -56, 0, 6)
                    Track.BorderSizePixel = 0
                    local TrackCorner = Instance.new("UICorner")
                    TrackCorner.CornerRadius = UDim.new(1, 0)
                    TrackCorner.Parent = Track

                    local Gradient = Instance.new("UIGradient")
                    Gradient.Parent = Track

                    local Knob = Instance.new("Frame")
                    Knob.Parent = Track
                    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Knob.Position = UDim2.new(initVal, -6, 0.5, -6)
                    Knob.Size = UDim2.new(0, 12, 0, 12)
                    local KnobCorner = Instance.new("UICorner")
                    KnobCorner.CornerRadius = UDim.new(1, 0)
                    KnobCorner.Parent = Knob
                    
                    local KnobStroke = Instance.new("UIStroke")
                    KnobStroke.Color = Color3.fromRGB(0,0,0)
                    KnobStroke.Thickness = 1
                    KnobStroke.Transparency = 0.5
                    KnobStroke.Parent = Knob

                    local Hitbox = Instance.new("TextButton")
                    Hitbox.Parent = SlFrame
                    Hitbox.BackgroundTransparency = 1
                    Hitbox.Position = UDim2.new(0, 30, 0, 0)
                    Hitbox.Size = UDim2.new(1, -40, 1, 0)
                    Hitbox.Text = ""

                    local dragging = false
                    Hitbox.MouseButton1Down:Connect(function() dragging = true end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                    end)
                    
                    local function updateSlider(input)
                        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                        Knob.Position = UDim2.new(pos, -6, 0.5, -6)
                        onChange(pos)
                    end

                    Hitbox.MouseButton1Down:Connect(function()
                        local input = UserInputService:GetMouseLocation()
                        updateSlider({Position = Vector2.new(input.X, input.Y - 36)})
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            updateSlider(input)
                        end
                    end)
                    
                    return Gradient, function(newVal)
                        Knob.Position = UDim2.new(newVal, -6, 0.5, -6)
                    end
                end

                local h, s, v = Color3.toHSV(CurrentColor)
                local gradH, setH
                local gradS, setS
                local gradV, setV
                
                local function UpdateColor()
                    CurrentColor = Color3.fromHSV(h, s, v)
                    ColorDisplay.BackgroundColor3 = CurrentColor
                    
                    local hueColor = Color3.fromHSV(h, 1, 1)
                    gradS.Color = ColorSequence.new(Color3.fromRGB(255,255,255), hueColor)
                    gradV.Color = ColorSequence.new(Color3.fromRGB(0,0,0), Color3.fromHSV(h, s, 1))

                    if callback then callback(CurrentColor) end
                end

                gradH, setH = MakeCPTrack("H", 0, h, function(val) h = val; UpdateColor() end)
                gradS, setS = MakeCPTrack("S", 30, s, function(val) s = val; UpdateColor() end)
                gradV, setV = MakeCPTrack("V", 60, v, function(val) v = val; UpdateColor() end)
                
                gradH.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                })
                UpdateColor()
                
                local CpObj = {}
                function CpObj:SetColor(newColor)
                    CurrentColor = newColor
                    h, s, v = Color3.toHSV(newColor)
                    setH(h) setS(s) setV(v)
                    UpdateColor()
                end
                
                WindowObj.ConfigElements[cpText] = {
                    Type = "Colorpicker",
                    GetValue = function() return {R = CurrentColor.R, G = CurrentColor.G, B = CurrentColor.B} end,
                    SetValue = function(val) 
                        if type(val) == "table" and val.R and val.G and val.B then
                            CpObj:SetColor(Color3.new(val.R, val.G, val.B))
                        end
                    end
                }

                return CpObj
            end

            return Section
        end

        table.insert(WindowObj.Tabs, tabData)

        if #WindowObj.Tabs == 1 then
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = Theme.Accent
            GlobalIndicator.BackgroundTransparency = 0
            GlobalIndicator.Position = UDim2.new(0, 12, 0, tabData.IndicatorY)
            if TabIcon then
                TabIcon.ImageColor3 = Theme.Accent
            end
            tabData.Selected = true
        end

        return TabObj
    end

    -- [ Auto-generate Profile Tab ]
    local ProfileTab = WindowObj:CreateTab("Profile", "user")
    local ProfilePage = ProfileTab.Page
    
    local leftCol = ProfilePage:FindFirstChild("LeftCol")
    local rightCol = ProfilePage:FindFirstChild("RightCol")
    local divider = ProfilePage:FindFirstChild("Divider")
    
    if leftCol then leftCol.Position = UDim2.new(0, 12, 0, 400) end
    if rightCol then rightCol.Position = UDim2.new(0.5, 8, 0, 400) end
    if divider then divider.Position = UDim2.new(0.5, -1, 0, 400) end

    local HeaderContainer = Instance.new("Frame")
    HeaderContainer.Parent = ProfilePage
    HeaderContainer.BackgroundTransparency = 1
    HeaderContainer.Size = UDim2.new(1, 0, 0, 390)
    HeaderContainer.Position = UDim2.new(0, 0, 0, 0)

    -- === BANNER ===
    local BannerBase = Instance.new("Frame")
    BannerBase.Parent = HeaderContainer
    BannerBase.Size = UDim2.new(1, 0, 0, 110)
    BannerBase.Position = UDim2.new(0, 0, 0, 0)
    BannerBase.BorderSizePixel = 0
    BannerBase.BackgroundColor3 = Theme.Sidebar
    BannerBase.ZIndex = 1

    local Banner = Instance.new("Frame")
    Banner.Parent = HeaderContainer
    Banner.Size = UDim2.new(1, 0, 0, 110)
    Banner.Position = UDim2.new(0, 0, 0, 0)
    Banner.BorderSizePixel = 0
    Banner.BackgroundColor3 = Theme.Accent
    Banner.ZIndex = 2
    Banner.BackgroundTransparency = 0.6

    local BannerGrad = Instance.new("UIGradient")
    BannerGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
    })
    BannerGrad.Rotation = 90
    BannerGrad.Parent = Banner

    local BannerCorner = Instance.new("UICorner")
    BannerCorner.CornerRadius = UDim.new(0, 6)
    BannerCorner.Parent = Banner
    local BaseCorner = Instance.new("UICorner")
    BaseCorner.CornerRadius = UDim.new(0, 6)
    BaseCorner.Parent = BannerBase

    local BannerBottomPatch = Instance.new("Frame")
    BannerBottomPatch.Parent = BannerBase
    BannerBottomPatch.BackgroundColor3 = Theme.Sidebar
    BannerBottomPatch.BorderSizePixel = 0
    BannerBottomPatch.Position = UDim2.new(0, 0, 1, -6)
    BannerBottomPatch.Size = UDim2.new(1, 0, 0, 6)
    BannerBottomPatch.ZIndex = 1

    -- === AVATAR ===
    local AvatarGlow = Instance.new("ImageLabel")
    AvatarGlow.Parent = HeaderContainer
    AvatarGlow.BackgroundTransparency = 1
    AvatarGlow.Position = UDim2.new(0.5, -60, 0, 40)
    AvatarGlow.Size = UDim2.new(0, 120, 0, 120)
    AvatarGlow.Image = "rbxassetid://13192853046"
    AvatarGlow.ImageColor3 = Theme.Accent
    AvatarGlow.ImageTransparency = 0.4
    AvatarGlow.ZIndex = 4

    local ProfileAvatar = Instance.new("ImageLabel")
    ProfileAvatar.Parent = HeaderContainer
    ProfileAvatar.BackgroundColor3 = Theme.ElementBg
    ProfileAvatar.Position = UDim2.new(0.5, -45, 0, 55)
    ProfileAvatar.Size = UDim2.new(0, 90, 0, 90)
    ProfileAvatar.ScaleType = Enum.ScaleType.Crop
    ProfileAvatar.ZIndex = 5
    ProfileAvatar.Image = ""

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = ProfileAvatar

    local AvatarBorder = Instance.new("UIStroke")
    AvatarBorder.Thickness = 3
    AvatarBorder.Color = Theme.Accent
    AvatarBorder.Parent = ProfileAvatar

    -- === INFO SECTION ===
    local ProfileInfo = Instance.new("Frame")
    ProfileInfo.Parent = HeaderContainer
    ProfileInfo.BackgroundTransparency = 1
    ProfileInfo.Position = UDim2.new(0, 0, 0, 155)
    ProfileInfo.Size = UDim2.new(1, 0, 0, 80)

    local ProfileName = Instance.new("TextLabel")
    ProfileName.Parent = ProfileInfo
    ProfileName.BackgroundTransparency = 1
    ProfileName.Position = UDim2.new(0, 0, 0, 0)
    ProfileName.Size = UDim2.new(1, 0, 0, 28)
    ProfileName.Font = Enum.Font.GothamBold
    ProfileName.TextSize = 24
    ProfileName.TextColor3 = Theme.Text
    ProfileName.Text = "Loading..."
    ProfileName.TextXAlignment = Enum.TextXAlignment.Center

    local ProfileUsername = Instance.new("TextLabel")
    ProfileUsername.Parent = ProfileInfo
    ProfileUsername.BackgroundTransparency = 1
    ProfileUsername.Position = UDim2.new(0, 0, 0, 30)
    ProfileUsername.Size = UDim2.new(1, 0, 0, 18)
    ProfileUsername.Font = Enum.Font.Gotham
    ProfileUsername.TextSize = 13
    ProfileUsername.TextColor3 = Color3.fromRGB(150, 150, 160)
    ProfileUsername.Text = "@..."
    ProfileUsername.TextXAlignment = Enum.TextXAlignment.Center

    local RoleContainer = Instance.new("Frame")
    RoleContainer.Parent = ProfileInfo
    RoleContainer.BackgroundTransparency = 1
    RoleContainer.Position = UDim2.new(0.5, -50, 0, 54)
    RoleContainer.Size = UDim2.new(0, 100, 0, 20)

    local RoleLayout = Instance.new("UIListLayout")
    RoleLayout.Parent = RoleContainer
    RoleLayout.FillDirection = Enum.FillDirection.Horizontal
    RoleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    RoleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    RoleLayout.Padding = UDim.new(0, 5)

    local RoleIcon = Instance.new("ImageLabel")
    RoleIcon.Parent = RoleContainer
    RoleIcon.BackgroundTransparency = 1
    RoleIcon.Size = UDim2.new(0, 14, 0, 14)
    RoleIcon.Image = "rbxassetid://10734900011"
    RoleIcon.ImageColor3 = Color3.fromRGB(255, 215, 0)

    local ProfileRole = Instance.new("TextLabel")
    ProfileRole.Parent = RoleContainer
    ProfileRole.BackgroundTransparency = 1
    ProfileRole.Size = UDim2.new(0, 85, 1, 0)
    ProfileRole.Font = Enum.Font.GothamMedium
    ProfileRole.TextSize = 12
    ProfileRole.TextColor3 = Color3.fromRGB(255, 215, 0)
    ProfileRole.Text = "Premium User"
    ProfileRole.TextXAlignment = Enum.TextXAlignment.Left

    -- === STATS CARDS ===
    local StatsFrame = Instance.new("Frame")
    StatsFrame.Parent = HeaderContainer
    StatsFrame.BackgroundTransparency = 1
    StatsFrame.Position = UDim2.new(0, 16, 0, 240)
    StatsFrame.Size = UDim2.new(1, -32, 0, 140)

    local StatsLayout = Instance.new("UIGridLayout")
    StatsLayout.Parent = StatsFrame
    StatsLayout.CellSize = UDim2.new(0, 210, 0, 60)
    StatsLayout.CellPadding = UDim2.new(0, 15, 0, 15)
    StatsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    StatsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local function MakeStatCard(label, value, iconId)
        local Card = Instance.new("Frame")
        Card.BackgroundColor3 = Theme.ElementBg
        Card.BorderSizePixel = 0
        Card.Parent = StatsFrame

        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 8)
        CardCorner.Parent = Card

        local CardStroke = Instance.new("UIStroke")
        CardStroke.Color = Theme.Accent
        CardStroke.Thickness = 1
        CardStroke.Transparency = 0.5
        CardStroke.Parent = Card

        local Icon = Instance.new("ImageLabel")
        Icon.Parent = Card
        Icon.BackgroundTransparency = 1
        Icon.Position = UDim2.new(0, 8, 0, 10)
        Icon.Size = UDim2.new(0, 14, 0, 14)
        Icon.Image = iconId
        Icon.ImageColor3 = Theme.Accent
        Icon.ImageTransparency = 0.2

        local ValLabel = Instance.new("TextLabel")
        ValLabel.Parent = Card
        ValLabel.BackgroundTransparency = 1
        ValLabel.Position = UDim2.new(0, 26, 0, 7)
        ValLabel.Size = UDim2.new(1, -30, 0, 22)
        ValLabel.Font = Enum.Font.GothamBold
        ValLabel.TextSize = 13
        ValLabel.TextColor3 = Theme.Text
        ValLabel.Text = value
        ValLabel.TextXAlignment = Enum.TextXAlignment.Left

        local KeyLabel = Instance.new("TextLabel")
        KeyLabel.Parent = Card
        KeyLabel.BackgroundTransparency = 1
        KeyLabel.Position = UDim2.new(0, 8, 0, 34)
        KeyLabel.Size = UDim2.new(1, -16, 0, 16)
        KeyLabel.Font = Enum.Font.Gotham
        KeyLabel.TextSize = 11
        KeyLabel.TextColor3 = Theme.TextMuted
        KeyLabel.Text = label
        KeyLabel.TextXAlignment = Enum.TextXAlignment.Left

        return ValLabel
    end

    local accountAgeVal = MakeStatCard("Account Age", "---", "rbxassetid://10734898355")
    local versionVal    = MakeStatCard("Script Ver.", "v1.0", "rbxassetid://10723341490")
    local statusVal     = MakeStatCard("Executor", "Active", "rbxassetid://10723354921")
    local playTimeVal   = MakeStatCard("Play Time", "00:00", "rbxassetid://10723415903")

    task.spawn(function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        if player then
            ProfileName.Text = player.DisplayName
            ProfileUsername.Text = "@" .. player.Name
            accountAgeVal.Text = tostring(player.AccountAge) .. " days"
            local success, avatarImage = pcall(function()
                return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            end)
            if success and avatarImage then
                ProfileAvatar.Image = avatarImage
            end
        else
            ProfileName.Text = "Guest"
            ProfileUsername.Text = "@unknown"
        end
    end)

    task.spawn(function()
        while task.wait(1) do
            local elapsed = time()
            local h = math.floor(elapsed / 3600)
            local m = math.floor((elapsed % 3600) / 60)
            local s = math.floor(elapsed % 60)
            
            if h > 0 then
                playTimeVal.Text = string.format("%02d:%02d:%02d", h, m, s)
            else
                playTimeVal.Text = string.format("%02d:%02d", m, s)
            end
        end
    end)

    -- [ Create Dialog ]
    function WindowObj:ShowDialog(title, message, options, callback)
        options = options or {"Yes", "No"}
        
        local Overlay = Instance.new("Frame")
        Overlay.Parent = MainFrame
        Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Overlay.BackgroundTransparency = 0.5
        Overlay.Size = UDim2.new(1, 0, 1, 0)
        Overlay.ZIndex = 50
        Overlay.BorderSizePixel = 0
        
        local DialogCorner = Instance.new("UICorner")
        DialogCorner.CornerRadius = UDim.new(0, 8)
        DialogCorner.Parent = Overlay

        local DialogBox = Instance.new("Frame")
        DialogBox.Parent = Overlay
        DialogBox.BackgroundColor3 = Theme.Background
        DialogBox.Size = UDim2.new(0, 300, 0, 140)
        DialogBox.Position = UDim2.new(0.5, -150, 0.5, -70)
        DialogBox.ZIndex = 51
        DialogBox.BorderSizePixel = 0
        
        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 8)
        BoxCorner.Parent = DialogBox
        
        local BoxStroke = Instance.new("UIStroke")
        BoxStroke.Color = Theme.Border
        BoxStroke.Thickness = 1
        BoxStroke.Parent = DialogBox

        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Parent = DialogBox
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Size = UDim2.new(1, 0, 0, 40)
        TitleLbl.Font = Enum.Font.GothamBold
        TitleLbl.Text = title
        TitleLbl.TextColor3 = Theme.Text
        TitleLbl.TextSize = 16
        TitleLbl.ZIndex = 52

        local MsgLbl = Instance.new("TextLabel")
        MsgLbl.Parent = DialogBox
        MsgLbl.BackgroundTransparency = 1
        MsgLbl.Position = UDim2.new(0, 20, 0, 40)
        MsgLbl.Size = UDim2.new(1, -40, 0, 40)
        MsgLbl.Font = Enum.Font.Gotham
        MsgLbl.Text = message
        MsgLbl.TextColor3 = Theme.TextMuted
        MsgLbl.TextSize = 13
        MsgLbl.TextWrapped = true
        MsgLbl.ZIndex = 52

        local BtnContainer = Instance.new("Frame")
        BtnContainer.Parent = DialogBox
        BtnContainer.BackgroundTransparency = 1
        BtnContainer.Position = UDim2.new(0, 0, 1, -45)
        BtnContainer.Size = UDim2.new(1, 0, 0, 35)
        BtnContainer.ZIndex = 52

        local BtnLayout = Instance.new("UIListLayout")
        BtnLayout.Parent = BtnContainer
        BtnLayout.FillDirection = Enum.FillDirection.Horizontal
        BtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        BtnLayout.Padding = UDim.new(0, 10)

        for _, opt in ipairs(options) do
            local Btn = Instance.new("TextButton")
            Btn.Parent = BtnContainer
            Btn.BackgroundColor3 = Theme.ElementBg
            Btn.Size = UDim2.new(0, 80, 1, 0)
            Btn.Font = Enum.Font.GothamMedium
            Btn.Text = opt
            Btn.TextColor3 = Theme.Text
            Btn.TextSize = 13
            Btn.ZIndex = 53
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Btn

            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Color = Theme.Border
            BtnStroke.Thickness = 1
            BtnStroke.Parent = Btn

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementHover}):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementBg}):Play()
            end)

            Btn.MouseButton1Click:Connect(function()
                Overlay:Destroy()
                if callback then callback(opt) end
            end)
        end
    end

    -- [ Save / Load Config ]
    function WindowObj:GetConfigs(folderName)
        if not isfolder or not listfiles then return {} end
        if not isfolder(folderName) then makefolder(folderName) end
        
        local configs = {}
        pcall(function()
            for _, file in ipairs(listfiles(folderName)) do
                if file:sub(-5) == ".json" then
                    local name = file:match("([^/\\]+)%.json$")
                    if name then
                        table.insert(configs, name)
                    end
                end
            end
        end)
        return configs
    end

    function WindowObj:SaveConfig(folderName, fileName)
        if not isfolder or not writefile then return end
        if not isfolder(folderName) then makefolder(folderName) end
        
        local data = {}
        for key, element in pairs(WindowObj.ConfigElements) do
            data[key] = element.GetValue()
        end
        
        local HttpService = game:GetService("HttpService")
        local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
        if success then
            writefile(folderName .. "/" .. fileName .. ".json", encoded)
            EmperUI:Notify({Title = "Config Saved", Message = "Saved configuration to " .. fileName .. ".json", Type = "success", Duration = 3})
        end
    end

    function WindowObj:LoadConfig(folderName, fileName)
        if not isfile or not readfile then return end
        local path = folderName .. "/" .. fileName .. ".json"
        if not isfile(path) then return end
        
        local HttpService = game:GetService("HttpService")
        local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(path))
        if success and type(decoded) == "table" then
            for key, val in pairs(decoded) do
                if WindowObj.ConfigElements[key] then
                    pcall(function()
                        WindowObj.ConfigElements[key].SetValue(val)
                    end)
                end
            end
            EmperUI:Notify({Title = "Config Loaded", Message = "Loaded configuration from " .. fileName .. ".json", Type = "success", Duration = 3})
        end
    end

    return WindowObj
end

return EmperUI
