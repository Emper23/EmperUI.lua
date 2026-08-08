# EmperUI.lua

UI library แบบ dark glass สำหรับหน้าต่างและคอนโทรลใน Roblox โดยไฟล์หลักอยู่ที่ [`EmperUI.lua`](./EmperUI.lua)

> ใช้เฉพาะใน Roblox Project หรือสภาพแวดล้อมที่คุณควบคุมและได้รับอนุญาตเท่านั้น

## โหลด Library

ถ้า environment ของคุณรองรับการโหลด source จาก URL:

```lua
local source = game:HttpGet(
    "https://raw.githubusercontent.com/Emper23/EmperUI.lua/refs/heads/main/EmperUI.lua"
)
local EmperUI = loadstring(source)()
```

ถ้าใส่ไฟล์เป็น ModuleScript:

```lua
local EmperUI = require(script.EmperUI)
```

## สร้าง Window, Tab และ Section

```lua
local Window = EmperUI:CreateWindow({
    Title = "Emper Hub",
    Size = UDim2.new(0, 760, 0, 500),
    ToggleKey = Enum.KeyCode.RightControl,
    AutoScale = true,
    MotionEnabled = true,
    TouchMode = true,
})

local Tab = Window:CreateTab("Components", "layout-grid")
local Section = Tab:CreateSection({
    Side = "Left",
    Title = "Basic Controls",
})
```

`CreateSection` รองรับทั้ง `Tab:CreateSection("Left", "Title")` และรูปแบบ table ด้านบน

## Controls

```lua
Section:Button({
    Title = "Print Test",
    Desc = "ทดสอบปุ่ม",
    Tooltip = "กดเพื่อพิมพ์ข้อความ",
    Callback = function()
        print("Button works")
    end,
})

local toggle = Section:Toggle({
    Title = "Auto Save",
    Default = false,
    Callback = function(value) print("Toggle:", value) end,
})

local slider = Section:Slider({
    Title = "Volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value) print("Slider:", value) end,
})

local dropdown = Section:Dropdown({
    Title = "Method",
    Values = {"Auto", "Manual", "Safe"},
    Default = "Auto",
    Callback = function(value) print("Dropdown:", value) end,
})

Section:MultiDropdown({
    Title = "Features",
    Values = {"A", "B", "C"},
    Default = {"A"},
    Callback = function(values) print(#values) end,
})

Section:TextBox({
    Title = "Message",
    Placeholder = "พิมพ์ข้อความ",
    Callback = function(value) print(value) end,
})

Section:Keybind({
    Title = "Toggle UI",
    Default = Enum.KeyCode.RightControl,
    Callback = function(key) print(key.Name) end,
})

Section:Colorpicker({
    Title = "Accent Color",
    Default = Color3.fromRGB(0, 230, 255),
    Callback = function(color) print(color) end,
})

Section:NumberInput({
    Title = "Amount",
    Min = 0,
    Max = 1000,
    Default = 100,
    Step = 10,
})
```

นอกจากนี้ยังมี `Label`, `Divider`, `Paragraph`, `Progress` และ `Badge`

## Theme และ Motion

```lua
Window:SetTheme("Cyberpunk")
Window:SetThemeColor("Accent", Color3.fromRGB(255, 80, 180))

Window:SetMotionEnabled(false)
Window:SetMotionSpeed(1.25)
Window:SetScale(0.85)
Window:SetControlScale(1.05)
Window:SetControlRadius(8)
Window:SetControlSpacing(8)
Window:SetTouchMode(true)
Window:SetTouchPadding(10)
```

Themes ที่มีให้ใช้: `Default`, `Sakura`, `Blood`, `Ocean`, `Midnight`, `Neon`, `Forest`, `Rose`, `Cyberpunk`, `Amber`, `Lavender`, `Monochrome`

## Search และ Notification

```lua
Window:ApplySearch("slider")

EmperUI:Notify({
    Title = "SUCCESS",
    Message = "บันทึกเรียบร้อย",
    Type = "success", -- success, error, warning, info
    Duration = 4,
})
```

## Config / Profile

```lua
local folder = "EmperHub"
Window:SaveConfig(folder, "default")
Window:LoadConfig(folder, "default")
Window:CreateProfile(folder, "mobile")
Window:DeleteConfig(folder, "mobile")
Window:ResetConfig()
```

สร้างหน้า Settings อัตโนมัติได้ด้วย:

```lua
local Settings = Window:CreateTab("Settings", "settings")
Window:BuildSettingsSystem(Settings, "EmperHub")
```

ชื่อโปรไฟล์ใช้ได้เฉพาะตัวอักษร ตัวเลข `_` และ `-` โดยการบันทึกต้องใช้ filesystem API เช่น `isfolder`, `writefile`, `readfile`, `listfiles` และ `delfile`

## Theme Studio และ Dashboard

```lua
Window:CreateThemeStudioTab({
    Title = "Theme Studio",
    Folder = "EmperUI_Themes",
})

Window:CreateDashboardTab({
    Title = "Dashboard",
    MaxActivities = 6,
    Live = true,
})

Window:SetDashboardStat("fps", "120", "Stable performance")
Window:SetDashboardProgress("loading", 75, 100)
Window:AddActivity("Theme changed", "info")
```

## Key Gate แบบ Local

```lua
local Gate = EmperUI:CreateKeyGate({
    Title = "Emper Hub",
    Subtitle = "Enter your access key to continue",
    Keys = {"EMP-FREE-2026"},
    RememberKey = false,
    OnSuccess = function(key)
        print("Unlocked:", key)
    end,
    OnFailed = function(key)
        print("Invalid key:", key)
    end,
})
```

Key Gate นี้เป็นการตรวจแบบ local/demo เท่านั้น ไม่ใช่ระบบความปลอดภัยหรือระบบยืนยันผ่านเซิร์ฟเวอร์

## ซ่อน แสดง และทำลาย

```lua
Window:Hide()
Window:Show()
Window:Toggle()
Window:Destroy()
EmperUI:Destroy()
```

## ตัวอย่างเต็ม

ดูไฟล์ [`EmperUI_Test.lua`](./EmperUI_Test.lua) สำหรับตัวอย่าง Components, Theme, Motion, Touch, Config และระบบทดสอบต่าง ๆ

