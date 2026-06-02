local EmperUI = {}
EmperUI.__index = EmperUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local TargetParent = gethui and gethui() or CoreGui


EmperUI.Themes = {
    Default = {
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
    },
    Sakura = {
        Background = Color3.fromRGB(25, 18, 25),
        Sidebar = Color3.fromRGB(35, 25, 35),
        Topbar = Color3.fromRGB(35, 25, 35),
        Accent = Color3.fromRGB(255, 140, 180),
        Accent2 = Color3.fromRGB(255, 200, 220),
        Text = Color3.fromRGB(255, 240, 245),
        TextMuted = Color3.fromRGB(180, 150, 160),
        ElementBg = Color3.fromRGB(45, 30, 45),
        ElementHover = Color3.fromRGB(60, 40, 60),
        Border = Color3.fromRGB(75, 50, 75)
    },
    Blood = {
        Background = Color3.fromRGB(15, 5, 5),
        Sidebar = Color3.fromRGB(25, 10, 10),
        Topbar = Color3.fromRGB(25, 10, 10),
        Accent = Color3.fromRGB(220, 20, 20),
        Accent2 = Color3.fromRGB(255, 50, 50),
        Text = Color3.fromRGB(255, 220, 220),
        TextMuted = Color3.fromRGB(150, 80, 80),
        ElementBg = Color3.fromRGB(35, 15, 15),
        ElementHover = Color3.fromRGB(50, 20, 20),
        Border = Color3.fromRGB(70, 25, 25)
    },
    Ocean = {
        Background = Color3.fromRGB(5, 15, 25),
        Sidebar = Color3.fromRGB(10, 25, 40),
        Topbar = Color3.fromRGB(10, 25, 40),
        Accent = Color3.fromRGB(0, 150, 255),
        Accent2 = Color3.fromRGB(0, 200, 255),
        Text = Color3.fromRGB(220, 240, 255),
        TextMuted = Color3.fromRGB(100, 140, 180),
        ElementBg = Color3.fromRGB(15, 35, 55),
        ElementHover = Color3.fromRGB(25, 50, 75),
        Border = Color3.fromRGB(40, 70, 100)
    },
    Midnight = {
        Background = Color3.fromRGB(5, 5, 5),
        Sidebar = Color3.fromRGB(12, 12, 12),
        Topbar = Color3.fromRGB(12, 12, 12),
        Accent = Color3.fromRGB(120, 0, 255),
        Accent2 = Color3.fromRGB(180, 50, 255),
        Text = Color3.fromRGB(230, 230, 230),
        TextMuted = Color3.fromRGB(100, 100, 100),
        ElementBg = Color3.fromRGB(20, 20, 20),
        ElementHover = Color3.fromRGB(30, 30, 30),
        Border = Color3.fromRGB(40, 40, 40)
    }
}

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
    MsgLabel.TextSize = 15
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
    -- ป้องกัน UI ซ้อนทับ (ปิดอันเก่าก่อนสร้างอันใหม่)
    if getgenv().EmperUI_Instance then
        pcall(function() getgenv().EmperUI_Instance:Destroy() end)
    end

    options = options or {}
    local WindowTitle = options.Title or "PREMIUM HUB"
    local WindowIcon = options.Icon or "rbxassetid://11681541018"
    local WindowSize = options.Size or UDim2.new(0, 680, 0, 450)
    local WindowObj = { Tabs = {}, ConfigElements = {} }
    
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
    
    WindowObj.ThemeObjects = {}
    
    function WindowObj:ApplyTheme(instance, property, themeKey)
        if not instance or not Theme[themeKey] then return end
        instance[property] = Theme[themeKey]
        table.insert(WindowObj.ThemeObjects, {Instance = instance, Property = property, ThemeKey = themeKey})
    end

    function WindowObj:SetTheme(themeName)
        local selectedTheme = EmperUI.Themes[themeName]
        if not selectedTheme then return end
        
        -- Update local theme colors
        for k, v in pairs(selectedTheme) do
            Theme[k] = v
        end
        
        -- Tween all registered UI elements
        for _, data in ipairs(WindowObj.ThemeObjects) do
            if data.Instance and data.Instance.Parent then
                TweenService:Create(data.Instance, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    [data.Property] = Theme[data.ThemeKey]
                }):Play()
            end
        end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = RandomName()
    ScreenGui.Parent = TargetParent
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- เก็บอ้างอิงไว้เพื่อใช้ลบตอนรัน UI ซ้อน
    getgenv().EmperUI_Instance = ScreenGui

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
    WindowObj:ApplyTheme(MainFrame, "BackgroundColor3", "Background")
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.Position = UDim2.new(0.5, -WindowSize.X.Offset/2, 0.5, -WindowSize.Y.Offset/2)
    MainFrame.Size = WindowSize
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    
    local BackgroundImage = Instance.new("ImageLabel")
    BackgroundImage.Name = "BackgroundImage"
    BackgroundImage.Parent = MainFrame
    BackgroundImage.BackgroundTransparency = 1
    BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
    BackgroundImage.Image = ""
    BackgroundImage.ImageTransparency = 0.8
    BackgroundImage.ScaleType = Enum.ScaleType.Crop
    BackgroundImage.ZIndex = 0

    function WindowObj:SetBackgroundImage(id)
        if id and id ~= "" then
            local rbxId = id:match("%d+")
            if rbxId then
                BackgroundImage.Image = "rbxassetid://" .. rbxId
            else
                BackgroundImage.Image = ""
            end
        else
            BackgroundImage.Image = ""
        end
    end

    function WindowObj:SetBackgroundTransparency(val)
        BackgroundImage.ImageTransparency = val
    end

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
    WindowObj:ApplyTheme(Topbar, "BackgroundColor3", "Topbar")
    Topbar.BackgroundTransparency = 0.15
    Topbar.Size = UDim2.new(1, 0, 0, 45)
    Topbar.BorderSizePixel = 0

    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 10)
    TopbarCorner.Parent = Topbar

    local TopbarPatch = Instance.new("Frame")
    TopbarPatch.Parent = Topbar
    WindowObj:ApplyTheme(TopbarPatch, "BackgroundColor3", "Topbar")
    TopbarPatch.BackgroundTransparency = 0.15
    TopbarPatch.BorderSizePixel = 0
    TopbarPatch.Position = UDim2.new(0, 0, 0.5, 0)
    TopbarPatch.Size = UDim2.new(1, 0, 0.5, 0)

    local TopbarLine = Instance.new("Frame")
    TopbarLine.Parent = Topbar
    WindowObj:ApplyTheme(TopbarLine, "BackgroundColor3", "Border")
    TopbarLine.Position = UDim2.new(0, 0, 1, -1)
    TopbarLine.Size = UDim2.new(1, 0, 0, 1)
    TopbarLine.BorderSizePixel = 0

    local Title = Instance.new("TextLabel")
    Title.Parent = Topbar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 16, 0, 0)
    Title.Size = UDim2.new(1, -200, 1, 0)
    Title.Font = Enum.Font.GothamMedium
    Title.Text = WindowTitle
    WindowObj:ApplyTheme(Title, "TextColor3", "Text")
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local ClockLabel = Instance.new("TextLabel")
    ClockLabel.Parent = Topbar
    ClockLabel.BackgroundTransparency = 1
    ClockLabel.Position = UDim2.new(1, -220, 0, 0)
    ClockLabel.Size = UDim2.new(0, 100, 1, 0)
    ClockLabel.Font = Enum.Font.Gotham
    WindowObj:ApplyTheme(ClockLabel, "TextColor3", "TextMuted")
    ClockLabel.TextSize = 12
    ClockLabel.TextXAlignment = Enum.TextXAlignment.Right
    ClockLabel.Text = "00:00:00 AM"
    
    task.spawn(function()
        while task.wait(1) do
            local timeT = os.date("*t")
            local hour = timeT.hour % 12
            if hour == 0 then hour = 12 end
            local ampm = timeT.hour >= 12 and "PM" or "AM"
            ClockLabel.Text = string.format("%02d:%02d:%02d %s", hour, timeT.min, timeT.sec, ampm)
        end
    end)

    -- [ Discord Button ]
    function WindowObj:AddDiscordButton(inviteLink)
        local DiscordBtn = Instance.new("ImageButton")
        DiscordBtn.Parent = Topbar
        DiscordBtn.BackgroundTransparency = 1
        DiscordBtn.Position = UDim2.new(1, -36, 0.5, -9)
        DiscordBtn.Size = UDim2.new(0, 18, 0, 18)
        DiscordBtn.Image = "rbxassetid://11681580226" -- Default link icon (Change to Discord ID later)
        WindowObj:ApplyTheme(DiscordBtn, "ImageColor3", "TextMuted")

        DiscordBtn.MouseEnter:Connect(function()
            TweenService:Create(DiscordBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {ImageColor3 = Theme.Accent}):Play()
        end)
        
        DiscordBtn.MouseLeave:Connect(function()
            TweenService:Create(DiscordBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {ImageColor3 = Theme.TextMuted}):Play()
        end)

        DiscordBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(inviteLink)
                EmperUI:Notify({
                    Title = "Discord",
                    Message = "คัดลอกลิงก์ Discord ลงคลิปบอร์ดแล้ว!",
                    Type = "success",
                    Duration = 3
                })
            else
                EmperUI:Notify({
                    Title = "Discord",
                    Message = "Executor ของคุณไม่รองรับ setclipboard",
                    Type = "error",
                    Duration = 3
                })
            end
        end)
    end

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
        WindowObj:ApplyTheme(Btn, "BackgroundColor3", "Topbar")
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
        WindowObj:ApplyTheme(Icon, "ImageColor3", "TextMuted")

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
    WindowObj:ApplyTheme(MobileIcon, "BackgroundColor3", "Background")
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
    WindowObj:ApplyTheme(MobileIconStroke, "Color", "Accent")
    MobileIconStroke.Thickness = 2
    MobileIconStroke.Parent = MobileIcon
    
    local MobileIconImage = Instance.new("ImageLabel")
    MobileIconImage.Parent = MobileIcon
    MobileIconImage.BackgroundTransparency = 1
    MobileIconImage.Position = UDim2.new(0.5, -12, 0.5, -12)
    MobileIconImage.Size = UDim2.new(0, 24, 0, 24)
    MobileIconImage.Image = "rbxassetid://10734896206"
    WindowObj:ApplyTheme(MobileIconImage, "ImageColor3", "Text")

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
            TweenService:Create(MainScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Scale = 0.5}):Play()
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
    WindowObj:ApplyTheme(ResizeHandle, "TextColor3", "TextMuted")
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

    WindowObj.ToggleKey = options.ToggleKey or Enum.KeyCode.RightControl

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == WindowObj.ToggleKey then
            MainFrame.Visible = not MainFrame.Visible
            DropShadow.Visible = MainFrame.Visible
        end
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    WindowObj:ApplyTheme(Sidebar, "BackgroundColor3", "Sidebar")
    Sidebar.BackgroundTransparency = 0.25
    Sidebar.Position = UDim2.new(0, 12, 0, 55)
    Sidebar.Size = UDim2.new(0, 160, 1, -67)
    Sidebar.BorderSizePixel = 0

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 6)
    SidebarCorner.Parent = Sidebar

    local SidebarStroke = Instance.new("UIStroke")
    WindowObj:ApplyTheme(SidebarStroke, "Color", "Border")
    SidebarStroke.Thickness = 1
    SidebarStroke.Parent = Sidebar

    local SidebarLogo = Instance.new("ImageLabel")
    SidebarLogo.Name = "SidebarLogo"
    SidebarLogo.Parent = Sidebar
    SidebarLogo.BackgroundTransparency = 1
    SidebarLogo.Position = UDim2.new(0.5, -45, 0, 16)
    SidebarLogo.Size = UDim2.new(0, 90, 0, 90)
    
    local extractId = WindowIcon:match("%d+")
    if extractId then
        SidebarLogo.Image = "rbxthumb://type=Asset&id=" .. extractId .. "&w=150&h=150"
    else
        SidebarLogo.Image = WindowIcon
    end
    SidebarLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
    
    local SidebarLogoCorner = Instance.new("UICorner")
    SidebarLogoCorner.CornerRadius = UDim.new(1, 0)
    SidebarLogoCorner.Parent = SidebarLogo

    local SidebarLogoStroke = Instance.new("UIStroke")
    WindowObj:ApplyTheme(SidebarLogoStroke, "Color", "Accent")
    SidebarLogoStroke.Thickness = 2
    SidebarLogoStroke.Parent = SidebarLogo

    local GlobalIndicator = Instance.new("Frame")
    GlobalIndicator.Name = "GlobalIndicator"
    GlobalIndicator.Parent = Sidebar
    WindowObj:ApplyTheme(GlobalIndicator, "BackgroundColor3", "Accent")
    GlobalIndicator.Size = UDim2.new(0, 3, 0, 16)
    GlobalIndicator.Position = UDim2.new(0, 12, 0, 130)
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
    TabPadding.PaddingTop = UDim.new(0, 124)
    TabPadding.PaddingLeft = UDim.new(0, 12)
    TabPadding.PaddingRight = UDim.new(0, 12)

    local ContentArea = Instance.new("Frame")
    ContentArea.Parent = MainFrame
    WindowObj:ApplyTheme(ContentArea, "BackgroundColor3", "Sidebar")
    ContentArea.BackgroundTransparency = 0.25
    ContentArea.Position = UDim2.new(0, 184, 0, 55)
    ContentArea.Size = UDim2.new(1, -196, 1, -67)
    ContentArea.BorderSizePixel = 0

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 6)
    ContentCorner.Parent = ContentArea

    local ContentStroke = Instance.new("UIStroke")
    WindowObj:ApplyTheme(ContentStroke, "Color", "Border")
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
        WindowObj:ApplyTheme(TabBtn, "BackgroundColor3", "ElementBg")
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 36)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.Text = actualIcon and ("            " .. tabName) or ("       " .. tabName)
        WindowObj:ApplyTheme(TabBtn, "TextColor3", "TextMuted")
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
            WindowObj:ApplyTheme(TabIcon, "ImageColor3", "TextMuted")
        end

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = ContentArea
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 2
        WindowObj:ApplyTheme(Page, "ScrollBarImageColor3", "Border")
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
        WindowObj:ApplyTheme(Divider, "BackgroundColor3", "Border")
        Divider.BorderSizePixel = 0
        Divider.Position = UDim2.new(0.5, -1, 0, 16)
        Divider.Size = UDim2.new(0, 2, 0, 0)
        
        local tabIndex = #WindowObj.Tabs + 1
        local indicatorY = 124 + (tabIndex - 1) * 40 + 10
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
                TweenService:Create(tb.Button, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1, TextColor3 = Theme.TextMuted}):Play()
                if tb.Icon then
                    TweenService:Create(tb.Icon, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageColor3 = Theme.TextMuted}):Play()
                end
            end
            
            tabData.Selected = true
            Page.Visible = true
            Page.Position = UDim2.new(0, 0, 0, 25)
            TweenService:Create(Page, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
            TweenService:Create(TabBtn, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextColor3 = Theme.Accent}):Play()
            
            GlobalIndicator.BackgroundTransparency = 0
            TweenService:Create(GlobalIndicator, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 12, 0, tabData.IndicatorY)
            }):Play()
            
            if TabIcon then
                TweenService:Create(TabIcon, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageColor3 = Theme.Accent}):Play()
            end
        end)

        TabBtn.MouseEnter:Connect(function()
            if not tabData.Selected then
                TweenService:Create(TabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextColor3 = Theme.Text}):Play()
                if TabIcon then TweenService:Create(TabIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageColor3 = Theme.Text}):Play() end
            end
        end)

        TabBtn.MouseLeave:Connect(function()
            if not tabData.Selected then
                TweenService:Create(TabBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextColor3 = Theme.TextMuted}):Play()
                if TabIcon then TweenService:Create(TabIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageColor3 = Theme.TextMuted}):Play() end
            end
        end)

        local TabObj = {}
        TabObj.Page = Page
        
        -- [ Section System (2-Column) ]
        function TabObj:CreateSection(side)
            local ParentCol = (side:lower() == "left") and LeftCol or RightCol
            local Section = {}

            -- [ Create Button ]
            function Section:CreateButton(arg1, arg2)
                local btnText, descText, callback
                if type(arg1) == "table" then
                    btnText = arg1.Title or arg1.Name or "Button"
                    descText = arg1.Desc or arg1.Description
                    callback = arg1.Callback
                else
                    btnText = arg1
                    callback = arg2
                end
                
                local baseHeight = descText and 56 or 42
                
                local BtnFrame = Instance.new("Frame")
                BtnFrame.Parent = ParentCol
                WindowObj:ApplyTheme(BtnFrame, "BackgroundColor3", "ElementBg")
                BtnFrame.Size = UDim2.new(1, 0, 0, baseHeight)
                BtnFrame.BorderSizePixel = 0

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = BtnFrame

                local BtnStroke = Instance.new("UIStroke")
                WindowObj:ApplyTheme(BtnStroke, "Color", "Border")
                BtnStroke.Thickness = 1
                BtnStroke.Parent = BtnFrame

                local TitleLabel = Instance.new("TextLabel")
                TitleLabel.Parent = BtnFrame
                TitleLabel.BackgroundTransparency = 1
                TitleLabel.Size = descText and UDim2.new(1, 0, 0, 24) or UDim2.new(1, 0, 1, 0)
                TitleLabel.Position = descText and UDim2.new(0, 0, 0, 8) or UDim2.new(0, 0, 0, 0)
                TitleLabel.Font = Enum.Font.GothamMedium
                TitleLabel.Text = "    " .. btnText
                WindowObj:ApplyTheme(TitleLabel, "TextColor3", "Text")
                TitleLabel.TextSize = 15
                TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local Hitbox = Instance.new("TextButton")
                Hitbox.Parent = BtnFrame
                Hitbox.BackgroundTransparency = 1
                Hitbox.Size = UDim2.new(1, 0, 1, 0)
                Hitbox.Position = UDim2.new(0, 0, 0, 0)
                Hitbox.Text = ""
                Hitbox.ZIndex = 5
                
                if descText then
                    local DescLabel = Instance.new("TextLabel")
                    DescLabel.Parent = BtnFrame
                    DescLabel.BackgroundTransparency = 1
                    DescLabel.Size = UDim2.new(1, -30, 0, 16)
                    DescLabel.Position = UDim2.new(0, 16, 0, 30)
                    DescLabel.Font = Enum.Font.Gotham
                    DescLabel.Text = descText
                    WindowObj:ApplyTheme(DescLabel, "TextColor3", "TextMuted")
                    DescLabel.TextSize = 13
                    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                    DescLabel.TextTruncate = Enum.TextTruncate.AtEnd
                end

                local ClickIcon = Instance.new("ImageLabel")
                ClickIcon.Parent = BtnFrame
                ClickIcon.BackgroundTransparency = 1
                ClickIcon.Position = UDim2.new(1, -30, 0.5, -9)
                ClickIcon.Size = UDim2.new(0, 18, 0, 18)
                ClickIcon.Image = "rbxassetid://11681605335" 
                WindowObj:ApplyTheme(ClickIcon, "ImageColor3", "TextMuted")

                Hitbox.MouseEnter:Connect(function()
                    TweenService:Create(BtnFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.ElementHover}):Play()
                    TweenService:Create(BtnStroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Color = Theme.Accent}):Play()
                    TweenService:Create(ClickIcon, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {ImageColor3 = Theme.Accent, Position = UDim2.new(1, -26, 0.5, -9)}):Play()
                end)
                
                Hitbox.MouseLeave:Connect(function()
                    TweenService:Create(BtnFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.ElementBg}):Play()
                    TweenService:Create(BtnStroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Color = Theme.Border}):Play()
                    TweenService:Create(ClickIcon, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {ImageColor3 = Theme.TextMuted, Position = UDim2.new(1, -30, 0.5, -9)}):Play()
                end)

                Hitbox.MouseButton1Click:Connect(function()
                    local ripple = Instance.new("Frame")
                    ripple.Parent = BtnFrame
                    WindowObj:ApplyTheme(ripple, "BackgroundColor3", "Accent")
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
            function Section:CreateToggle(arg1, arg2, arg3)
                local toggleText, descText, defaultState, callback
                if type(arg1) == "table" then
                    toggleText = arg1.Title or arg1.Name or "Toggle"
                    descText = arg1.Desc or arg1.Description
                    defaultState = arg1.Value or arg1.Default or false
                    callback = arg1.Callback
                else
                    toggleText = arg1
                    defaultState = arg2
                    callback = arg3
                end
                
                local Toggled = defaultState or false
                local baseHeight = descText and 56 or 42
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Parent = ParentCol
                WindowObj:ApplyTheme(ToggleFrame, "BackgroundColor3", "ElementBg")
                ToggleFrame.Size = UDim2.new(1, 0, 0, baseHeight)
                ToggleFrame.BorderSizePixel = 0

                local TgCorner = Instance.new("UICorner")
                TgCorner.CornerRadius = UDim.new(0, 6)
                TgCorner.Parent = ToggleFrame

                local TgStroke = Instance.new("UIStroke")
                WindowObj:ApplyTheme(TgStroke, "Color", "Border")
                TgStroke.Thickness = 1
                TgStroke.Parent = ToggleFrame

                local Label = Instance.new("TextLabel")
                Label.Parent = ToggleFrame
                Label.BackgroundTransparency = 1
                Label.Size = descText and UDim2.new(1, -60, 0, 24) or UDim2.new(1, -60, 1, 0)
                Label.Position = descText and UDim2.new(0, 16, 0, 8) or UDim2.new(0, 16, 0, 0)
                Label.Font = Enum.Font.GothamMedium
                Label.Text = toggleText
                WindowObj:ApplyTheme(Label, "TextColor3", "Text")
                Label.TextSize = 15
                Label.TextXAlignment = Enum.TextXAlignment.Left
                
                if descText then
                    local DescLabel = Instance.new("TextLabel")
                    DescLabel.Parent = ToggleFrame
                    DescLabel.BackgroundTransparency = 1
                    DescLabel.Size = UDim2.new(1, -60, 0, 16)
                    DescLabel.Position = UDim2.new(0, 16, 0, 30)
                    DescLabel.Font = Enum.Font.Gotham
                    DescLabel.Text = descText
                    WindowObj:ApplyTheme(DescLabel, "TextColor3", "TextMuted")
                    DescLabel.TextSize = 13
                    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                    DescLabel.TextTruncate = Enum.TextTruncate.AtEnd
                end

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
            function Section:CreateSlider(arg1, arg2, arg3, arg4, arg5)
                local sliderText, min, max, default, callback
                if type(arg1) == "table" then
                    sliderText = arg1.Title or arg1.Name or "Slider"
                    min = arg1.Min or 0
                    max = arg1.Max or 100
                    default = arg1.Value or arg1.Default or min
                    callback = arg1.Callback
                else
                    sliderText = arg1
                    min = arg2
                    max = arg3
                    default = arg4
                    callback = arg5
                end
                
                local descText
                if type(arg1) == "table" then
                    descText = arg1.Desc or arg1.Description
                end
                
                local Value = default or min
                local baseHeight = descText and 66 or 52
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Parent = ParentCol
                WindowObj:ApplyTheme(SliderFrame, "BackgroundColor3", "ElementBg")
                SliderFrame.Size = UDim2.new(1, 0, 0, baseHeight)
                SliderFrame.BorderSizePixel = 0

                local SlCorner = Instance.new("UICorner")
                SlCorner.CornerRadius = UDim.new(0, 6)
                SlCorner.Parent = SliderFrame

                local SlStroke = Instance.new("UIStroke")
                WindowObj:ApplyTheme(SlStroke, "Color", "Border")
                SlStroke.Thickness = 1
                SlStroke.Parent = SliderFrame

                local Label = Instance.new("TextLabel")
                Label.Parent = SliderFrame
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, -100, 0, 24)
                Label.Position = UDim2.new(0, 16, 0, 4)
                Label.Font = Enum.Font.GothamMedium
                Label.Text = sliderText
                WindowObj:ApplyTheme(Label, "TextColor3", "Text")
                Label.TextSize = 15
                Label.TextXAlignment = Enum.TextXAlignment.Left

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Parent = SliderFrame
                ValLabel.BackgroundTransparency = 1
                ValLabel.Size = UDim2.new(0, 80, 0, 24)
                ValLabel.Position = UDim2.new(1, -96, 0, 4)
                ValLabel.Font = Enum.Font.GothamBold
                ValLabel.Text = tostring(Value)
                WindowObj:ApplyTheme(ValLabel, "TextColor3", "Accent")
                ValLabel.TextSize = 15
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right

                local Track = Instance.new("TextButton")
                Track.Parent = SliderFrame
                Track.BackgroundColor3 = Color3.fromRGB(35, 38, 50)
                Track.Position = descText and UDim2.new(0, 16, 0, 46) or UDim2.new(0, 16, 0, 32)
                Track.Size = UDim2.new(1, -32, 0, 6)
                Track.BorderSizePixel = 0
                
                if descText then
                    local DescLabel = Instance.new("TextLabel")
                    DescLabel.Parent = SliderFrame
                    DescLabel.BackgroundTransparency = 1
                    DescLabel.Size = UDim2.new(1, -100, 0, 16)
                    DescLabel.Position = UDim2.new(0, 16, 0, 22)
                    DescLabel.Font = Enum.Font.Gotham
                    DescLabel.Text = descText
                    WindowObj:ApplyTheme(DescLabel, "TextColor3", "TextMuted")
                    DescLabel.TextSize = 13
                    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                    DescLabel.TextTruncate = Enum.TextTruncate.AtEnd
                end
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
                WindowObj:ApplyTheme(Fill, "BackgroundColor3", "Accent")
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
            function Section:CreateDropdown(arg1, arg2, arg3, arg4)
                local dropdownText, options, defaultOption, callback
                if type(arg1) == "table" then
                    dropdownText = arg1.Title or arg1.Name or "Dropdown"
                    options = arg1.Values or arg1.Options or {}
                    defaultOption = arg1.Value or arg1.Default
                    callback = arg1.Callback
                else
                    dropdownText = arg1
                    options = arg2
                    defaultOption = arg3
                    callback = arg4
                end
                
                local descText
                if type(arg1) == "table" then
                    descText = arg1.Desc or arg1.Description
                end
                
                options = options or {}
                local CurrentOption = defaultOption or options[1] or ""
                local Expanded = false
                
                local baseHeight = descText and 56 or 42
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Parent = ParentCol
                WindowObj:ApplyTheme(DropdownFrame, "BackgroundColor3", "ElementBg")
                DropdownFrame.Size = UDim2.new(1, 0, 0, baseHeight)
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.ClipsDescendants = true

                local DpCorner = Instance.new("UICorner")
                DpCorner.CornerRadius = UDim.new(0, 6)
                DpCorner.Parent = DropdownFrame

                local DpStroke = Instance.new("UIStroke")
                WindowObj:ApplyTheme(DpStroke, "Color", "Border")
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
                WindowObj:ApplyTheme(Label, "TextColor3", "Text")
                Label.TextSize = 15
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextTruncate = Enum.TextTruncate.AtEnd

                local SelLabel = Instance.new("TextLabel")
                SelLabel.Parent = DropdownFrame
                SelLabel.BackgroundTransparency = 1
                SelLabel.Size = descText and UDim2.new(0.5, -40, 0, 24) or UDim2.new(0.5, -40, 0, 42)
                SelLabel.Position = descText and UDim2.new(0.5, 8, 0, 8) or UDim2.new(0.5, 8, 0, 0)
                SelLabel.Font = Enum.Font.GothamBold
                SelLabel.Text = tostring(CurrentOption)
                WindowObj:ApplyTheme(SelLabel, "TextColor3", "Accent")
                SelLabel.TextSize = 15
                SelLabel.TextXAlignment = Enum.TextXAlignment.Right
                SelLabel.TextTruncate = Enum.TextTruncate.AtEnd

                local ArrowIcon = Instance.new("ImageLabel")
                ArrowIcon.Parent = DropdownFrame
                ArrowIcon.BackgroundTransparency = 1
                ArrowIcon.Position = descText and UDim2.new(1, -30, 0, 19) or UDim2.new(1, -30, 0, 12)
                ArrowIcon.Size = UDim2.new(0, 18, 0, 18)
                ArrowIcon.Image = "rbxassetid://10709790948" 
                WindowObj:ApplyTheme(ArrowIcon, "ImageColor3", "TextMuted")

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
                    WindowObj:ApplyTheme(OptBtn, "BackgroundColor3", "ElementBg")
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
                    WindowObj:ApplyTheme(OptStroke, "Color", "Border")
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

                function DropdownObj:GetValue()
                    return CurrentOption
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
            function Section:CreateMultiDropdown(arg1, arg2, arg3, arg4)
                local dropdownText, options, defaultOptions, callback
                if type(arg1) == "table" then
                    dropdownText = arg1.Title or arg1.Name or "Multi Dropdown"
                    options = arg1.Values or arg1.Options or {}
                    defaultOptions = arg1.Value or arg1.Default
                    callback = arg1.Callback
                else
                    dropdownText = arg1
                    options = arg2
                    defaultOptions = arg3
                    callback = arg4
                end
                
                options = options or {}
                local CurrentOptions = type(defaultOptions) == "table" and defaultOptions or {}
                local Expanded = false
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Parent = ParentCol
                WindowObj:ApplyTheme(DropdownFrame, "BackgroundColor3", "ElementBg")
                DropdownFrame.Size = UDim2.new(1, 0, 0, 42)
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.ClipsDescendants = true

                local DpCorner = Instance.new("UICorner")
                DpCorner.CornerRadius = UDim.new(0, 6)
                DpCorner.Parent = DropdownFrame

                local DpStroke = Instance.new("UIStroke")
                WindowObj:ApplyTheme(DpStroke, "Color", "Border")
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
                WindowObj:ApplyTheme(Label, "TextColor3", "Text")
                Label.TextSize = 15
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextTruncate = Enum.TextTruncate.AtEnd

                local SelLabel = Instance.new("TextLabel")
                SelLabel.Parent = DropdownFrame
                SelLabel.BackgroundTransparency = 1
                SelLabel.Size = UDim2.new(0.5, -40, 0, 42)
                SelLabel.Position = UDim2.new(0.5, 8, 0, 0)
                SelLabel.Font = Enum.Font.GothamBold
                
                local function UpdateSelLabel()
                    if #CurrentOptions == 0 then
                        SelLabel.Text = "None"
                        WindowObj:ApplyTheme(SelLabel, "TextColor3", "TextMuted")
                    else
                        SelLabel.Text = table.concat(CurrentOptions, ", ")
                        WindowObj:ApplyTheme(SelLabel, "TextColor3", "Accent")
                    end
                end
                UpdateSelLabel()
                
                SelLabel.TextSize = 15
                SelLabel.TextXAlignment = Enum.TextXAlignment.Right
                SelLabel.TextTruncate = Enum.TextTruncate.AtEnd

                local ArrowIcon = Instance.new("ImageLabel")
                ArrowIcon.Parent = DropdownFrame
                ArrowIcon.BackgroundTransparency = 1
                ArrowIcon.Position = UDim2.new(1, -30, 0, 12)
                ArrowIcon.Size = UDim2.new(0, 18, 0, 18)
                ArrowIcon.Image = "rbxassetid://10709790948" 
                WindowObj:ApplyTheme(ArrowIcon, "ImageColor3", "TextMuted")

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
                    WindowObj:ApplyTheme(OptBtn, "BackgroundColor3", "ElementBg")
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
                    WindowObj:ApplyTheme(OptStroke, "Color", "Border")
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
            function Section:CreateTextBox(arg1, arg2, arg3)
                local tbText, placeholder, callback
                if type(arg1) == "table" then
                    tbText = arg1.Title or arg1.Name or "TextBox"
                    placeholder = arg1.Placeholder or ""
                    callback = arg1.Callback
                else
                    tbText = arg1
                    placeholder = arg2
                    callback = arg3
                end
                
                local descText
                if type(arg1) == "table" then
                    descText = arg1.Desc or arg1.Description
                end
                
                local baseHeight = descText and 56 or 42
                
                local TbFrame = Instance.new("Frame")
                TbFrame.Parent = ParentCol
                WindowObj:ApplyTheme(TbFrame, "BackgroundColor3", "ElementBg")
                TbFrame.Size = UDim2.new(1, 0, 0, baseHeight)
                TbFrame.BorderSizePixel = 0

                local TbCorner = Instance.new("UICorner")
                TbCorner.CornerRadius = UDim.new(0, 6)
                TbCorner.Parent = TbFrame

                local TbStroke = Instance.new("UIStroke")
                WindowObj:ApplyTheme(TbStroke, "Color", "Border")
                TbStroke.Thickness = 1
                TbStroke.Parent = TbFrame

                local TbLabel = Instance.new("TextLabel")
                TbLabel.Parent = TbFrame
                TbLabel.BackgroundTransparency = 1
                TbLabel.Position = UDim2.new(0, 16, 0, 0)
                TbLabel.Size = descText and UDim2.new(0.5, -16, 0, 24) or UDim2.new(0.5, -16, 1, 0)
                TbLabel.Position = descText and UDim2.new(0, 16, 0, 8) or UDim2.new(0, 16, 0, 0)
                TbLabel.Font = Enum.Font.GothamMedium
                TbLabel.Text = tbText
                WindowObj:ApplyTheme(TbLabel, "TextColor3", "Text")
                TbLabel.TextSize = 15
                TbLabel.TextXAlignment = Enum.TextXAlignment.Left

                if descText then
                    local DescLabel = Instance.new("TextLabel")
                    DescLabel.Parent = TbFrame
                    DescLabel.BackgroundTransparency = 1
                    DescLabel.Size = UDim2.new(0.5, -16, 0, 16)
                    DescLabel.Position = UDim2.new(0, 16, 0, 30)
                    DescLabel.Font = Enum.Font.Gotham
                    DescLabel.Text = descText
                    WindowObj:ApplyTheme(DescLabel, "TextColor3", "TextMuted")
                    DescLabel.TextSize = 13
                    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                    DescLabel.TextTruncate = Enum.TextTruncate.AtEnd
                end

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
                WindowObj:ApplyTheme(BgStroke, "Color", "Border")
                BgStroke.Thickness = 1
                BgStroke.Parent = TextBoxBg

                local TextBox = Instance.new("TextBox")
                TextBox.Parent = TextBoxBg
                TextBox.BackgroundTransparency = 1
                TextBox.Size = UDim2.new(1, 0, 1, 0)
                TextBox.Font = Enum.Font.Gotham
                TextBox.PlaceholderText = placeholder or ""
                TextBox.Text = ""
                WindowObj:ApplyTheme(TextBox, "TextColor3", "Text")
                WindowObj:ApplyTheme(TextBox, "PlaceholderColor3", "TextMuted")
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
                
                function TextBoxObj:GetValue()
                    return TextBox.Text
                end

                WindowObj.ConfigElements[tbText] = {
                    Type = "TextBox",
                    GetValue = function() return TextBox.Text end,
                    SetValue = function(val) TextBox.Text = tostring(val) end
                }

                return TextBoxObj
            end

            -- [ Create Keybind ]
            function Section:CreateKeybind(arg1, arg2, arg3)
                local kbText, defaultKey, callback
                if type(arg1) == "table" then
                    kbText = arg1.Title or arg1.Name or "Keybind"
                    defaultKey = arg1.Value or arg1.Key or arg1.Default
                    callback = arg1.Callback
                else
                    kbText = arg1
                    defaultKey = arg2
                    callback = arg3
                end
                
                local descText
                if type(arg1) == "table" then
                    descText = arg1.Desc or arg1.Description
                end
                
                local baseHeight = descText and 56 or 42
                
                local KbFrame = Instance.new("Frame")
                KbFrame.Parent = ParentCol
                WindowObj:ApplyTheme(KbFrame, "BackgroundColor3", "ElementBg")
                KbFrame.Size = UDim2.new(1, 0, 0, baseHeight)
                KbFrame.BorderSizePixel = 0

                local KbCorner = Instance.new("UICorner")
                KbCorner.CornerRadius = UDim.new(0, 6)
                KbCorner.Parent = KbFrame

                local KbStroke = Instance.new("UIStroke")
                WindowObj:ApplyTheme(KbStroke, "Color", "Border")
                KbStroke.Thickness = 1
                KbStroke.Parent = KbFrame

                local KbLabel = Instance.new("TextLabel")
                KbLabel.Parent = KbFrame
                KbLabel.BackgroundTransparency = 1
                KbLabel.Size = descText and UDim2.new(0.5, -16, 0, 24) or UDim2.new(0.5, -20, 1, 0)
                KbLabel.Position = descText and UDim2.new(0, 16, 0, 8) or UDim2.new(0, 16, 0, 0)
                KbLabel.Font = Enum.Font.GothamMedium
                KbLabel.Text = kbText
                WindowObj:ApplyTheme(KbLabel, "TextColor3", "Text")
                KbLabel.TextSize = 15
                KbLabel.TextXAlignment = Enum.TextXAlignment.Left

                if descText then
                    local DescLabel = Instance.new("TextLabel")
                    DescLabel.Parent = KbFrame
                    DescLabel.BackgroundTransparency = 1
                    DescLabel.Size = UDim2.new(0.5, -16, 0, 16)
                    DescLabel.Position = UDim2.new(0, 16, 0, 30)
                    DescLabel.Font = Enum.Font.Gotham
                    DescLabel.Text = descText
                    WindowObj:ApplyTheme(DescLabel, "TextColor3", "TextMuted")
                    DescLabel.TextSize = 13
                    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                    DescLabel.TextTruncate = Enum.TextTruncate.AtEnd
                end

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
                WindowObj:ApplyTheme(BgStroke, "Color", "Border")
                BgStroke.Thickness = 1
                BgStroke.Parent = BindBg

                local BindBtn = Instance.new("TextButton")
                BindBtn.Parent = BindBg
                BindBtn.BackgroundTransparency = 1
                BindBtn.Size = UDim2.new(1, 0, 1, 0)
                BindBtn.Font = Enum.Font.GothamMedium
                BindBtn.Text = defaultKey.Name
                WindowObj:ApplyTheme(BindBtn, "TextColor3", "TextMuted")
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
            function Section:CreateLabel(arg1)
                local labelText
                if type(arg1) == "table" then
                    labelText = arg1.Title or arg1.Text or arg1.Name or "Label"
                else
                    labelText = arg1
                end
                
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
                WindowObj:ApplyTheme(Lbl, "TextColor3", "TextMuted")
                Lbl.TextSize = 15
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
                WindowObj:ApplyTheme(Line, "BackgroundColor3", "Border")
                Line.BorderSizePixel = 0
                Line.Size = UDim2.new(1, -20, 0, 1)
                Line.Position = UDim2.new(0, 10, 0.5, 0)
            end

            -- [ Create Colorpicker ]
            function Section:CreateColorpicker(arg1, arg2, arg3)
                local cpText, defaultColor, callback
                if type(arg1) == "table" then
                    cpText = arg1.Title or arg1.Name or "Colorpicker"
                    defaultColor = arg1.Value or arg1.Color or arg1.Default or Color3.new(1, 1, 1)
                    callback = arg1.Callback
                else
                    cpText = arg1
                    defaultColor = arg2
                    callback = arg3
                end
                
                local CurrentColor = defaultColor or Color3.fromRGB(255, 255, 255)
                local Expanded = false

                local CpFrame = Instance.new("Frame")
                CpFrame.Parent = ParentCol
                WindowObj:ApplyTheme(CpFrame, "BackgroundColor3", "ElementBg")
                CpFrame.Size = UDim2.new(1, 0, 0, 42)
                CpFrame.BorderSizePixel = 0
                CpFrame.ClipsDescendants = true

                local CpCorner = Instance.new("UICorner")
                CpCorner.CornerRadius = UDim.new(0, 6)
                CpCorner.Parent = CpFrame

                local CpStroke = Instance.new("UIStroke")
                WindowObj:ApplyTheme(CpStroke, "Color", "Border")
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
                WindowObj:ApplyTheme(CpLabel, "TextColor3", "Text")
                CpLabel.TextSize = 15
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
                    WindowObj:ApplyTheme(Lbl, "TextColor3", "Text")
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

            -- [ Aliases for modern dictionary API ]
            Section.Button = Section.CreateButton
            Section.Toggle = Section.CreateToggle
            Section.Slider = Section.CreateSlider
            Section.Dropdown = Section.CreateDropdown
            Section.MultiDropdown = Section.CreateMultiDropdown
            Section.TextBox = Section.CreateTextBox
            Section.Keybind = Section.CreateKeybind
            Section.Colorpicker = Section.CreateColorpicker
            Section.Label = Section.CreateLabel
            Section.Divider = Section.CreateDivider

            return Section
        end

        table.insert(WindowObj.Tabs, tabData)

        if #WindowObj.Tabs == 1 then
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            WindowObj:ApplyTheme(TabBtn, "TextColor3", "Accent")
            GlobalIndicator.BackgroundTransparency = 0
            GlobalIndicator.Position = UDim2.new(0, 12, 0, tabData.IndicatorY)
            if TabIcon then
                WindowObj:ApplyTheme(TabIcon, "ImageColor3", "Accent")
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

    -- === BANNER (REMOVED AS PER USER REQUEST) ===
    -- Banner was removed to make it clean around the profile picture.

    -- === AVATAR ===
    local AvatarGlow = Instance.new("ImageLabel")
    AvatarGlow.Parent = HeaderContainer
    AvatarGlow.BackgroundTransparency = 1
    AvatarGlow.Position = UDim2.new(0.5, -60, 0, 40)
    AvatarGlow.Size = UDim2.new(0, 120, 0, 120)
    AvatarGlow.Image = "rbxassetid://13192853046"
    WindowObj:ApplyTheme(AvatarGlow, "ImageColor3", "Accent")
    AvatarGlow.ImageTransparency = 0.4
    AvatarGlow.ZIndex = 4

    local ProfileAvatar = Instance.new("ImageLabel")
    ProfileAvatar.Parent = HeaderContainer
    WindowObj:ApplyTheme(ProfileAvatar, "BackgroundColor3", "ElementBg")
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
    WindowObj:ApplyTheme(AvatarBorder, "Color", "Accent")
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
    WindowObj:ApplyTheme(ProfileName, "TextColor3", "Text")
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
        WindowObj:ApplyTheme(Card, "BackgroundColor3", "ElementBg")
        Card.BorderSizePixel = 0
        Card.Parent = StatsFrame

        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 8)
        CardCorner.Parent = Card

        local CardStroke = Instance.new("UIStroke")
        WindowObj:ApplyTheme(CardStroke, "Color", "Accent")
        CardStroke.Thickness = 1
        CardStroke.Transparency = 0.5
        CardStroke.Parent = Card

        local Icon = Instance.new("ImageLabel")
        Icon.Parent = Card
        Icon.BackgroundTransparency = 1
        Icon.Position = UDim2.new(0, 8, 0, 10)
        Icon.Size = UDim2.new(0, 14, 0, 14)
        Icon.Image = iconId
        WindowObj:ApplyTheme(Icon, "ImageColor3", "Accent")
        Icon.ImageTransparency = 0.2

        local ValLabel = Instance.new("TextLabel")
        ValLabel.Parent = Card
        ValLabel.BackgroundTransparency = 1
        ValLabel.Position = UDim2.new(0, 26, 0, 7)
        ValLabel.Size = UDim2.new(1, -30, 0, 22)
        ValLabel.Font = Enum.Font.GothamBold
        ValLabel.TextSize = 15
        WindowObj:ApplyTheme(ValLabel, "TextColor3", "Text")
        ValLabel.Text = value
        ValLabel.TextXAlignment = Enum.TextXAlignment.Left

        local KeyLabel = Instance.new("TextLabel")
        KeyLabel.Parent = Card
        KeyLabel.BackgroundTransparency = 1
        KeyLabel.Position = UDim2.new(0, 8, 0, 34)
        KeyLabel.Size = UDim2.new(1, -16, 0, 16)
        KeyLabel.Font = Enum.Font.Gotham
        KeyLabel.TextSize = 11
        WindowObj:ApplyTheme(KeyLabel, "TextColor3", "TextMuted")
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
        WindowObj:ApplyTheme(DialogBox, "BackgroundColor3", "Background")
        DialogBox.Size = UDim2.new(0, 300, 0, 140)
        DialogBox.Position = UDim2.new(0.5, -150, 0.5, -70)
        DialogBox.ZIndex = 51
        DialogBox.BorderSizePixel = 0
        
        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 8)
        BoxCorner.Parent = DialogBox
        
        local BoxStroke = Instance.new("UIStroke")
        WindowObj:ApplyTheme(BoxStroke, "Color", "Border")
        BoxStroke.Thickness = 1
        BoxStroke.Parent = DialogBox

        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Parent = DialogBox
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Size = UDim2.new(1, 0, 0, 40)
        TitleLbl.Font = Enum.Font.GothamBold
        TitleLbl.Text = title
        WindowObj:ApplyTheme(TitleLbl, "TextColor3", "Text")
        TitleLbl.TextSize = 16
        TitleLbl.ZIndex = 52

        local MsgLbl = Instance.new("TextLabel")
        MsgLbl.Parent = DialogBox
        MsgLbl.BackgroundTransparency = 1
        MsgLbl.Position = UDim2.new(0, 20, 0, 40)
        MsgLbl.Size = UDim2.new(1, -40, 0, 40)
        MsgLbl.Font = Enum.Font.Gotham
        MsgLbl.Text = message
        WindowObj:ApplyTheme(MsgLbl, "TextColor3", "TextMuted")
        MsgLbl.TextSize = 15
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
            WindowObj:ApplyTheme(Btn, "BackgroundColor3", "ElementBg")
            Btn.Size = UDim2.new(0, 80, 1, 0)
            Btn.Font = Enum.Font.GothamMedium
            Btn.Text = opt
            WindowObj:ApplyTheme(Btn, "TextColor3", "Text")
            Btn.TextSize = 13
            Btn.ZIndex = 53
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Btn

            local BtnStroke = Instance.new("UIStroke")
            WindowObj:ApplyTheme(BtnStroke, "Color", "Border")
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

    function WindowObj:DeleteConfig(folderName, fileName)
        if not isfile or not delfile then return end
        local path = folderName .. "/" .. fileName .. ".json"
        if isfile(path) then
            pcall(delfile, path)
            EmperUI:Notify({Title = "Config Deleted", Message = "Deleted configuration " .. fileName .. ".json", Type = "info", Duration = 3})
        end
    end

    function WindowObj:BuildSettingsSystem(ParentObj, folderName)
        folderName = folderName or "EmperHub"
        
        local ConfigSection, ThemeSection
        if ParentObj.CreateSection then
            -- It's a Tab, create separate columns
            ConfigSection = ParentObj:CreateSection("Left")
            ThemeSection = ParentObj:CreateSection("Right")
        else
            -- It's a Section, stack them
            ConfigSection = ParentObj
            ThemeSection = ParentObj
        end
        
        ConfigSection:Label("Configuration System")
        
        local ConfigNameBox = ConfigSection:TextBox({
            Title = "Config Name",
            Placeholder = "ตั้งชื่อ Config ที่นี่...",
            Callback = function() end
        })

        local ConfigDropdown = ConfigSection:Dropdown({
            Title = "Saved Configs",
            Values = WindowObj:GetConfigs(folderName),
            Value = "Select Config",
            Callback = function() end
        })

        ConfigSection:Button({
            Title = "Save Config",
            Desc = "บันทึกการตั้งค่าปัจจุบัน",
            Callback = function()
                local name = ConfigNameBox:GetValue()
                if name == "" then
                    EmperUI:Notify({Title = "Error", Message = "กรุณาตั้งชื่อ Config ในช่องด้านบนก่อน!", Type = "error", Duration = 3})
                    return
                end
                WindowObj:SaveConfig(folderName, name)
                ConfigDropdown:Refresh(WindowObj:GetConfigs(folderName), name)
            end
        })

        ConfigSection:Button({
            Title = "Load Config",
            Desc = "โหลดการตั้งค่าที่เลือก",
            Callback = function()
                local name = ConfigDropdown:GetValue()
                if name == "" or name == "Select Config" then
                    EmperUI:Notify({Title = "Error", Message = "กรุณาเลือก Config จากดรอปดาวน์ก่อน!", Type = "error", Duration = 3})
                    return
                end
                WindowObj:LoadConfig(folderName, name)
                ConfigNameBox:SetValue(name)
            end
        })

        ConfigSection:Button({
            Title = "Delete Config",
            Desc = "ลบไฟล์การตั้งค่าที่เลือก",
            Callback = function()
                local name = ConfigDropdown:GetValue()
                if name == "" or name == "Select Config" then
                    EmperUI:Notify({Title = "Error", Message = "กรุณาเลือก Config ที่ต้องการลบก่อน!", Type = "error", Duration = 3})
                    return
                end
                
                WindowObj:ShowDialog("Delete Config", "Are you sure you want to delete config '" .. name .. "'?", {"Yes", "Cancel"}, function(choice)
                    if choice == "Yes" then
                        WindowObj:DeleteConfig(folderName, name)
                        ConfigDropdown:Refresh(WindowObj:GetConfigs(folderName))
                        ConfigNameBox:SetValue("")
                    end
                end)
            end
        })

        ConfigSection:Button({
            Title = "Refresh Configs",
            Callback = function()
                ConfigDropdown:Refresh(WindowObj:GetConfigs(folderName))
                EmperUI:Notify({Title = "Refreshed", Message = "รีเฟรชรายชื่อ Config เรียบร้อย", Type = "success", Duration = 2})
            end
        })

        local AutoLoadToggle = ConfigSection:Toggle({
            Title = "Auto Load Config",
            Desc = "บันทึกและโหลดออโต้เมื่อเปิดสคริปต์",
            Default = false,
            Callback = function(state)
                if writefile then
                    local targetConfig = state and ConfigDropdown:GetValue() or ""
                    if targetConfig == "Select Config" then targetConfig = "" end
                    
                    if not isfolder(folderName) then makefolder(folderName) end
                    writefile(folderName .. "/autoload.txt", targetConfig)
                    
                    if state and targetConfig ~= "" then
                        EmperUI:Notify({Title = "Auto Load Enabled", Message = "ตั้งออโต้โหลด: " .. targetConfig, Type = "success", Duration = 3})
                    end
                end
            end
        })

        if ConfigSection == ThemeSection then
            ThemeSection:Divider()
        end
        
        ThemeSection:Label("Theme Settings")
        
        local themeNames = {}
        for tName, _ in pairs(EmperUI.Themes) do
            table.insert(themeNames, tName)
        end
        
        ThemeSection:Dropdown({
            Title = "UI Theme",
            Values = themeNames,
            Value = "Default",
            Callback = function(val)
                WindowObj:SetTheme(val)
            end,
            Flag = "EmperUI_Theme"
        })

        ThemeSection:TextBox({
            Title = "Background Image ID",
            Placeholder = "ใส่ตัวเลข ID รูปภาพ...",
            Callback = function(val)
                WindowObj:SetBackgroundImage(val)
            end,
            Flag = "EmperUI_BgImage"
        })

        ThemeSection:Slider({
            Title = "Background Transparency",
            Min = 0,
            Max = 100,
            Default = 80,
            Callback = function(val)
                WindowObj:SetBackgroundTransparency(val / 100)
            end,
            Flag = "EmperUI_BgTrans"
        })

        task.spawn(function()
            if isfile and isfile(folderName .. "/autoload.txt") then
                local autoName = readfile(folderName .. "/autoload.txt")
                if autoName and autoName ~= "" then
                    task.wait(0.5)
                    pcall(function()
                        WindowObj:LoadConfig(folderName, autoName)
                        ConfigNameBox:SetValue(autoName)
                        ConfigDropdown:Refresh(WindowObj:GetConfigs(folderName), autoName)
                        AutoLoadToggle:SetState(true)
                        EmperUI:Notify({
                            Title = "Auto Load", 
                            Message = "โหลด Config [" .. autoName .. "] อัตโนมัติแล้ว!", 
                            Type = "success", 
                            Duration = 4
                        })
                    end)
                end
            end
        end)
    end

    -- [ Premium Feature: Live Watermark ]
    function WindowObj:SetWatermark(text)
        if WindowObj.Watermark then
            WindowObj.Watermark:Destroy()
        end

        local WM = Instance.new("Frame")
        WM.Name = "Watermark"
        WM.Parent = ScreenGui
        WM.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        WM.BackgroundTransparency = 0.2
        WM.BorderSizePixel = 0
        WM.Position = UDim2.new(0, 10, 0, 10)
        WM.Size = UDim2.new(0, 200, 0, 26)
        WindowObj.Watermark = WM

        local WMCorner = Instance.new("UICorner")
        WMCorner.CornerRadius = UDim.new(0, 6)
        WMCorner.Parent = WM

        local WMStroke = Instance.new("UIStroke")
        WMStroke.Thickness = 1.5
        WMStroke.Transparency = 0.2
        WindowObj:ApplyTheme(WMStroke, "Color", "Accent")
        WMStroke.Parent = WM

        local WMLabel = Instance.new("TextLabel")
        WMLabel.Parent = WM
        WMLabel.BackgroundTransparency = 1
        WMLabel.Position = UDim2.new(0, 8, 0, 0)
        WMLabel.Size = UDim2.new(1, -16, 1, 0)
        WMLabel.Font = Enum.Font.GothamMedium
        WMLabel.TextSize = 12
        WindowObj:ApplyTheme(WMLabel, "TextColor3", "Text")
        WMLabel.TextXAlignment = Enum.TextXAlignment.Left
        WMLabel.RichText = true

        MakeDraggable(WM, WM)

        task.spawn(function()
            local runService = game:GetService("RunService")
            local stats = game:GetService("Stats")
            local frames = 0
            local fps = 60
            
            runService.RenderStepped:Connect(function()
                frames = frames + 1
            end)
            
            while task.wait(1) do
                fps = frames
                frames = 0
                local ping = math.floor(stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                local timeStr = os.date("%H:%M:%S")
                
                local finalText = text
                finalText = finalText:gsub("{fps}", tostring(fps))
                finalText = finalText:gsub("{ping}", tostring(ping) .. "ms")
                finalText = finalText:gsub("{time}", timeStr)
                
                WMLabel.Text = finalText
                
                -- Auto resize
                local textBounds = WMLabel.TextBounds
                TweenService:Create(WM, TweenInfo.new(0.2), {Size = UDim2.new(0, textBounds.X + 24, 0, 26)}):Play()
            end
        end)
    end

    -- [ Premium Feature: Aurora Background (Glassmorphism Effect) ]
    function WindowObj:EnableAuroraBackground()
        local AuroraFolder = Instance.new("Folder")
        AuroraFolder.Name = "AuroraEffects"
        AuroraFolder.Parent = MainFrame
        
        local function CreateOrb(size, pos, colorKey)
            local Orb = Instance.new("ImageLabel")
            Orb.Parent = MainFrame
            Orb.BackgroundTransparency = 1
            Orb.Position = pos
            Orb.Size = size
            Orb.Image = "rbxassetid://13192853046"
            WindowObj:ApplyTheme(Orb, "ImageColor3", colorKey)
            Orb.ImageTransparency = 0.5
            Orb.ZIndex = 0
            
            -- Animate Orb floating
            task.spawn(function()
                while task.wait() do
                    local rx = math.random(-50, 50)
                    local ry = math.random(-50, 50)
                    local time = math.random(5, 10)
                    local newPos = UDim2.new(pos.X.Scale, pos.X.Offset + rx, pos.Y.Scale, pos.Y.Offset + ry)
                    
                    local tw = TweenService:Create(Orb, TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = newPos})
                    tw:Play()
                    tw.Completed:Wait()
                end
            end)
        end

        CreateOrb(UDim2.new(0, 300, 0, 300), UDim2.new(0, -50, 0, -50), "Accent")
        CreateOrb(UDim2.new(0, 250, 0, 250), UDim2.new(1, -200, 1, -200), "Accent2")
    end

    return WindowObj
end

return EmperUI
