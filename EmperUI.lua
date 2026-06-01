local EmperUI = {}
EmperUI.__index = EmperUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- [ Anti-Detection ] 
-- ใช้ gethui() ถ้ามี (Synapse, Krnl) ถ้าไม่มีไปใช้ CoreGui
local TargetParent = gethui and gethui() or CoreGui

-- สุ่มชื่อให้ Frame เพื่อหลบ Anti-Cheat
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
    local WindowTitle = options.Title or "EmperX UI"
    local WindowSize = options.Size or UDim2.new(0, 500, 0, 350)
    
    -- Theme Palette (Cyberpunk / EmperX Style)
    local Colors = {
        MainBg = Color3.fromRGB(11, 16, 32),
        TopBg = Color3.fromRGB(15, 19, 36),
        Border = Color3.fromRGB(0, 229, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(138, 148, 184)
    }

    -- สุ่มชื่อ ScreenGui ให้สคริปต์อื่นหาไม่เจอ
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = RandomName()
    ScreenGui.Parent = TargetParent
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Frame หลัก
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = RandomName()
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Colors.MainBg
    MainFrame.Position = UDim2.new(0.5, -WindowSize.X.Offset/2, 0.5, -WindowSize.Y.Offset/2)
    MainFrame.Size = WindowSize
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true

    -- ขอบเรืองแสงสีนีออน (Cyberpunk Vibe)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Colors.Border
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.5
    UIStroke.Parent = MainFrame

    -- แถบลากด้านบน (Topbar)
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Colors.TopBg
    Topbar.Size = UDim2.new(1, 0, 0, 35)
    Topbar.BorderSizePixel = 0

    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 6)
    TopbarCorner.Parent = Topbar
    
    -- ปิดมุมมนด้านล่างของ Topbar เพื่อให้เนียนกับ MainFrame
    local TopbarFix = Instance.new("Frame")
    TopbarFix.Parent = Topbar
    TopbarFix.BackgroundColor3 = Colors.TopBg
    TopbarFix.Position = UDim2.new(0, 0, 1, -5)
    TopbarFix.Size = UDim2.new(1, 0, 0, 5)
    TopbarFix.BorderSizePixel = 0

    local Title = Instance.new("TextLabel")
    Title.Parent = Topbar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(1, -30, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = WindowTitle
    Title.TextColor3 = Colors.Border
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- ทำให้ลากได้
    MakeDraggable(Topbar, MainFrame)

    -- โซนเก็บแท็บและคอนเทนต์
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = MainFrame
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 0, 0, 35)
    Container.Size = UDim2.new(1, 0, 1, -35)

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Container
    TabContainer.BackgroundColor3 = Color3.fromRGB(13, 17, 34)
    TabContainer.Size = UDim2.new(0, 130, 1, 0)
    TabContainer.BorderSizePixel = 0

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)

    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabContainer
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = Container
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 130, 0, 0)
    ContentContainer.Size = UDim2.new(1, -130, 1, 0)

    local Window = {
        Tabs = {},
        CurrentTab = nil
    }

    -- [ สร้าง Tab ]
    function Window:CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Color3.fromRGB(20, 26, 45)
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = tabName
        TabButton.TextColor3 = Colors.TextDim
        TabButton.TextSize = 12
        TabButton.AutoButtonColor = false

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = ContentContainer
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Colors.Border
        Page.Visible = false

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)

        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = Page
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingLeft = UDim.new(0, 10)
        PagePadding.PaddingRight = UDim.new(0, 15)
        
        -- ปรับขนาด ScrollingFrame อัตโนมัติเมื่อปุ่มเพิ่ม
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)

        TabButton.MouseButton1Click:Connect(function()
            -- ซ่อนทุก Page
            for _, tb in pairs(Window.Tabs) do
                tb.Page.Visible = false
                TweenService:Create(tb.Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(20, 26, 45),
                    TextColor3 = Colors.TextDim
                }):Play()
            end
            
            -- โชว์ Page ปัจจุบัน
            Page.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 229, 255),
                TextColor3 = Color3.fromRGB(11, 16, 32)
            }):Play()
        end)

        local Tab = {}
        
        -- [ สร้าง Button Component ]
        function Tab:CreateButton(btnName, callback)
            local Button = Instance.new("TextButton")
            Button.Parent = Page
            Button.BackgroundColor3 = Color3.fromRGB(25, 33, 56)
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.Font = Enum.Font.Gotham
            Button.Text = "  " .. btnName
            Button.TextColor3 = Colors.Text
            Button.TextSize = 13
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Button.AutoButtonColor = false

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = Button

            -- เอฟเฟกต์ Hover
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 45, 75)}):Play()
            end)
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 33, 56)}):Play()
            end)

            Button.MouseButton1Click:Connect(function()
                -- คลิกแล้วปุ่มกระพริบสีนีออน
                local clickTween = TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Border})
                clickTween:Play()
                clickTween.Completed:Wait()
                TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 45, 75)}):Play()
                
                if callback then callback() end
            end)
        end

        -- บันทึกว่าแท็บนี้มีอยู่จริง
        table.insert(Window.Tabs, {Button = TabButton, Page = Page})

        -- ถ้าเป็นแท็บแรก ให้เปิดไว้เลย
        if #Window.Tabs == 1 then
            Page.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 229, 255)
            TabButton.TextColor3 = Color3.fromRGB(11, 16, 32)
        end

        return Tab
    end

    return Window
end

return EmperUI
