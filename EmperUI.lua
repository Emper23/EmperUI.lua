local EmperUI = {}
EmperUI.__index = EmperUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- [ Anti-Detection ] 
local TargetParent = gethui and gethui() or CoreGui

local function RandomName()
    return HttpService:GenerateGUID(false):gsub("-", "")
end

-- [ Smooth Dragging System ]
local function MakeDraggable(topbarObject, object)
    local Dragging = false
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

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

-- [ Create Window ]
function EmperUI:CreateWindow(options)
    options = options or {}
    local WindowTitle = options.Title or "EmperX Hub"
    local WindowSize = options.Size or UDim2.new(0, 600, 0, 450)
    
    -- Premium Theme Palette
    local Colors = {
        Background = Color3.fromRGB(15, 15, 20),
        TopBar = Color3.fromRGB(12, 12, 16),
        Sidebar = Color3.fromRGB(18, 18, 25),
        Accent = Color3.fromRGB(0, 229, 255),
        Text = Color3.fromRGB(240, 240, 240),
        TextDim = Color3.fromRGB(150, 150, 165),
        ButtonBg = Color3.fromRGB(22, 22, 30),
        ButtonHover = Color3.fromRGB(30, 30, 42)
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = RandomName()
    ScreenGui.Parent = TargetParent
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- เงามืดด้านหลัง (Drop Shadow ซ้อนทับ)
    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = ScreenGui
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, -WindowSize.X.Offset/2 - 15, 0.5, -WindowSize.Y.Offset/2 - 15)
    DropShadow.Size = UDim2.new(0, WindowSize.X.Offset + 30, 0, WindowSize.Y.Offset + 30)
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.5
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.ScaleType = Enum.ScaleType.Slice

    -- Frame หลัก
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.Position = UDim2.new(0.5, -WindowSize.X.Offset/2, 0.5, -WindowSize.Y.Offset/2)
    MainFrame.Size = WindowSize
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Colors.Accent
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.7
    UIStroke.Parent = MainFrame

    -- แถบลากด้านบน (Topbar)
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Colors.TopBar
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BorderSizePixel = 0

    local TopbarSeparator = Instance.new("Frame")
    TopbarSeparator.Parent = Topbar
    TopbarSeparator.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TopbarSeparator.Position = UDim2.new(0, 0, 1, -1)
    TopbarSeparator.Size = UDim2.new(1, 0, 0, 1)
    TopbarSeparator.BorderSizePixel = 0

    local Title = Instance.new("TextLabel")
    Title.Parent = Topbar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = WindowTitle
    Title.TextColor3 = Colors.Accent
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    MakeDraggable(Topbar, MainFrame)
    MakeDraggable(DropShadow, MainFrame) -- ผูกเงาไว้กับเฟรมหลัก

    -- อัปเดตตำแหน่งเงาตลอดเวลา
    MainFrame:GetPropertyChangedSignal("Position"):Connect(function()
        DropShadow.Position = UDim2.new(
            MainFrame.Position.X.Scale, MainFrame.Position.X.Offset - 15,
            MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset - 15
        )
    end)

    -- โซนเก็บแท็บและคอนเทนต์
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = MainFrame
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 0, 0, 40)
    Container.Size = UDim2.new(1, 0, 1, -40)

    -- แถบ Sidebar ด้านซ้าย
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "Sidebar"
    TabContainer.Parent = Container
    TabContainer.BackgroundColor3 = Colors.Sidebar
    TabContainer.Size = UDim2.new(0, 140, 1, 0)
    TabContainer.BorderSizePixel = 0

    local SidebarSeparator = Instance.new("Frame")
    SidebarSeparator.Parent = TabContainer
    SidebarSeparator.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    SidebarSeparator.Position = UDim2.new(1, -1, 0, 0)
    SidebarSeparator.Size = UDim2.new(0, 1, 1, 0)
    SidebarSeparator.BorderSizePixel = 0

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 6)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabContainer
    TabPadding.PaddingTop = UDim.new(0, 15)

    -- ส่วนเนื้อหาขวา
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = Container
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 140, 0, 0)
    ContentContainer.Size = UDim2.new(1, -140, 1, 0)

    local Window = {
        Tabs = {},
        CurrentTab = nil
    }

    -- [ สร้าง Tab ]
    function Window:CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Colors.Sidebar
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, -20, 0, 32)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = "  " .. tabName
        TabButton.TextColor3 = Colors.TextDim
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.AutoButtonColor = false

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        -- แถบสีด้านซ้ายเวลาคลิก
        local Indicator = Instance.new("Frame")
        Indicator.Parent = TabButton
        Indicator.BackgroundColor3 = Colors.Accent
        Indicator.Position = UDim2.new(0, 0, 0.5, -8)
        Indicator.Size = UDim2.new(0, 3, 0, 16)
        Indicator.BorderSizePixel = 0
        Indicator.BackgroundTransparency = 1 -- ซ่อนไว้ก่อน
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = Indicator

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = ContentContainer
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Colors.Accent
        Page.Visible = false
        Page.BorderSizePixel = 0

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = Page
        PagePadding.PaddingTop = UDim.new(0, 15)
        PagePadding.PaddingBottom = UDim.new(0, 15)
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 30)
        end)

        TabButton.MouseButton1Click:Connect(function()
            for _, tb in pairs(Window.Tabs) do
                tb.Page.Visible = false
                TweenService:Create(tb.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Colors.TextDim}):Play()
                TweenService:Create(tb.Indicator, TweenInfo.new(0.2), {BackgroundTransparency = 1, Size = UDim2.new(0, 3, 0, 0)}):Play()
            end
            
            Page.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, TextColor3 = Colors.Accent}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundTransparency = 0, Size = UDim2.new(0, 3, 0, 16)}):Play()
        end)

        local Tab = {}
        
        -- [ สร้าง Button Component ]
        function Tab:CreateButton(btnName, callback)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Parent = Page
            ButtonFrame.BackgroundColor3 = Colors.ButtonBg
            ButtonFrame.Size = UDim2.new(1, -30, 0, 38)
            ButtonFrame.BorderSizePixel = 0

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = ButtonFrame

            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Color = Color3.fromRGB(40, 40, 55)
            BtnStroke.Thickness = 1
            BtnStroke.Parent = ButtonFrame

            local Button = Instance.new("TextButton")
            Button.Parent = ButtonFrame
            Button.BackgroundTransparency = 1
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.Font = Enum.Font.GothamSemibold
            Button.Text = "   " .. btnName
            Button.TextColor3 = Colors.Text
            Button.TextSize = 13
            Button.TextXAlignment = Enum.TextXAlignment.Left

            -- ไอคอนคลิกด้านขวา
            local ClickIcon = Instance.new("ImageLabel")
            ClickIcon.Parent = ButtonFrame
            ClickIcon.BackgroundTransparency = 1
            ClickIcon.Position = UDim2.new(1, -25, 0.5, -8)
            ClickIcon.Size = UDim2.new(0, 16, 0, 16)
            ClickIcon.Image = "rbxassetid://3944676352" -- ไอคอนลูกศรคลิก
            ClickIcon.ImageColor3 = Colors.TextDim
            ClickIcon.ImageRectOffset = Vector2.new(644, 284)
            ClickIcon.ImageRectSize = Vector2.new(36, 36)

            Button.MouseEnter:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Colors.ButtonHover}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color = Colors.Accent}):Play()
                TweenService:Create(ClickIcon, TweenInfo.new(0.2), {ImageColor3 = Colors.Accent}):Play()
            end)
            Button.MouseLeave:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Colors.ButtonBg}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 55)}):Play()
                TweenService:Create(ClickIcon, TweenInfo.new(0.2), {ImageColor3 = Colors.TextDim}):Play()
            end)

            Button.MouseButton1Click:Connect(function()
                -- เอฟเฟกต์ยุบตัวนิดนึง
                local shrink = TweenService:Create(ButtonFrame, TweenInfo.new(0.05), {Size = UDim2.new(1, -34, 0, 36)})
                shrink:Play()
                shrink.Completed:Wait()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -30, 0, 38)}):Play()
                
                if callback then callback() end
            end)
        end

        table.insert(Window.Tabs, {Button = TabButton, Page = Page, Indicator = Indicator})

        if #Window.Tabs == 1 then
            Page.Visible = true
            TabButton.BackgroundTransparency = 0.9
            TabButton.TextColor3 = Colors.Accent
            Indicator.BackgroundTransparency = 0
        end

        return Tab
    end

    return Window
end

return EmperUI
