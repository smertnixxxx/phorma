--[[
    ██████╗ ██╗  ██╗ ██████╗ ██████╗ ███╗   ███╗ █████╗     ██╗    ██╗ █████╗ ██████╗ ███████╗
    ██╔══██╗██║  ██║██╔═══██╗██╔══██╗████╗ ████║██╔══██╗    ██║    ██║██╔══██╗██╔══██╗██╔════╝
    ██████╔╝███████║██║   ██║██████╔╝██╔████╔██║███████║    ██║ █╗ ██║███████║██████╔╝█████╗  
    ██╔═══╝ ██╔══██║██║   ██║██╔══██╗██║╚██╔╝██║██╔══██║    ██║███╗██║██╔══██║██╔══██╗██╔══╝  
    ██║     ██║  ██║╚██████╔╝██║  ██║██║ ╚═╝ ██║██║  ██║    ╚███╔███╔╝██║  ██║██║  ██║███████╗
    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝     ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
    
    phorma ware :: UI Library v1.0
    by phorma
    
    USAGE EXAMPLE:
    
    local PhormaLib = loadstring(game:HttpGet("..."))()
    local Window = PhormaLib:CreateWindow({
        Title = "phorma ware",
        SubTitle = "v1.0",
        ToggleKey = Enum.KeyCode.RightShift,
    })
    
    local Tab = Window:AddTab("Combat", "⚔")
    local Section = Tab:AddSection("Aimbot")
    
    Section:AddToggle("Enable Aimbot", false, function(val) end)
    Section:AddSlider("Smoothness", 1, 100, 50, function(val) end)
    Section:AddDropdown("Target Part", {"Head", "Torso", "HumanoidRootPart"}, "Head", function(val) end)
    Section:AddKeybind("Toggle Key", Enum.KeyCode.Q, function(key) end)
    Section:AddColorPicker("Color", Color3.fromRGB(255,255,255), function(col) end)
    Section:AddButton("Teleport", function() end)
    Section:AddTextBox("Player Name", "Enter name...", function(val) end)
--]]

local PhormaLib = {}
PhormaLib.__index = PhormaLib

-- ========================================
--  SERVICES
-- ========================================
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui        = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ========================================
--  THEME SYSTEM
-- ========================================
local DefaultTheme = {
    -- Backgrounds
    Background      = Color3.fromRGB(10, 10, 10),
    BackgroundLight = Color3.fromRGB(18, 18, 18),
    BackgroundLighter = Color3.fromRGB(25, 25, 25),

    -- Surfaces
    Surface         = Color3.fromRGB(22, 22, 22),
    SurfaceHover    = Color3.fromRGB(32, 32, 32),
    SurfaceActive   = Color3.fromRGB(40, 40, 40),

    -- Tab bar
    TabBar          = Color3.fromRGB(14, 14, 14),
    TabActive       = Color3.fromRGB(255, 255, 255),
    TabInactive     = Color3.fromRGB(100, 100, 100),

    -- Accent (default: white)
    Accent          = Color3.fromRGB(255, 255, 255),
    AccentDark      = Color3.fromRGB(180, 180, 180),

    -- Text
    TextPrimary     = Color3.fromRGB(240, 240, 240),
    TextSecondary   = Color3.fromRGB(150, 150, 150),
    TextMuted       = Color3.fromRGB(80, 80, 80),

    -- Elements
    Toggle          = Color3.fromRGB(255, 255, 255),
    ToggleOff       = Color3.fromRGB(50, 50, 50),
    Slider          = Color3.fromRGB(255, 255, 255),
    Border          = Color3.fromRGB(35, 35, 35),
    BorderLight     = Color3.fromRGB(55, 55, 55),

    -- Header gradient
    HeaderGradient1 = Color3.fromRGB(255, 255, 255),
    HeaderGradient2 = Color3.fromRGB(180, 180, 180),

    -- Scrollbar
    ScrollBar       = Color3.fromRGB(60, 60, 60),

    -- Font
    Font            = Enum.Font.GothamBold,
    FontLight       = Enum.Font.Gotham,

    -- Misc
    CornerRadius    = UDim.new(0, 6),
    Transparency    = 0,
}

-- Preset themes
local Themes = {
    ["Midnight"] = DefaultTheme,
    ["Snow"] = {
        Background      = Color3.fromRGB(245, 245, 248),
        BackgroundLight = Color3.fromRGB(238, 238, 242),
        BackgroundLighter = Color3.fromRGB(230, 230, 235),
        Surface         = Color3.fromRGB(255, 255, 255),
        SurfaceHover    = Color3.fromRGB(240, 240, 244),
        SurfaceActive   = Color3.fromRGB(225, 225, 230),
        TabBar          = Color3.fromRGB(235, 235, 238),
        TabActive       = Color3.fromRGB(20, 20, 20),
        TabInactive     = Color3.fromRGB(140, 140, 145),
        Accent          = Color3.fromRGB(20, 20, 20),
        AccentDark      = Color3.fromRGB(60, 60, 60),
        TextPrimary     = Color3.fromRGB(20, 20, 20),
        TextSecondary   = Color3.fromRGB(90, 90, 95),
        TextMuted       = Color3.fromRGB(170, 170, 175),
        Toggle          = Color3.fromRGB(20, 20, 20),
        ToggleOff       = Color3.fromRGB(200, 200, 205),
        Slider          = Color3.fromRGB(20, 20, 20),
        Border          = Color3.fromRGB(215, 215, 220),
        BorderLight     = Color3.fromRGB(195, 195, 200),
        HeaderGradient1 = Color3.fromRGB(20, 20, 20),
        HeaderGradient2 = Color3.fromRGB(80, 80, 80),
        ScrollBar       = Color3.fromRGB(180, 180, 185),
        Font            = Enum.Font.GothamBold,
        FontLight       = Enum.Font.Gotham,
        CornerRadius    = UDim.new(0, 6),
        Transparency    = 0,
    },
    ["Ash"] = {
        Background      = Color3.fromRGB(15, 15, 17),
        BackgroundLight = Color3.fromRGB(20, 20, 24),
        BackgroundLighter = Color3.fromRGB(28, 28, 33),
        Surface         = Color3.fromRGB(24, 24, 29),
        SurfaceHover    = Color3.fromRGB(32, 32, 38),
        SurfaceActive   = Color3.fromRGB(42, 42, 50),
        TabBar          = Color3.fromRGB(16, 16, 20),
        TabActive       = Color3.fromRGB(230, 225, 255),
        TabInactive     = Color3.fromRGB(110, 105, 130),
        Accent          = Color3.fromRGB(200, 190, 255),
        AccentDark      = Color3.fromRGB(150, 140, 200),
        TextPrimary     = Color3.fromRGB(235, 230, 255),
        TextSecondary   = Color3.fromRGB(140, 130, 165),
        TextMuted       = Color3.fromRGB(80, 75, 100),
        Toggle          = Color3.fromRGB(200, 190, 255),
        ToggleOff       = Color3.fromRGB(50, 48, 60),
        Slider          = Color3.fromRGB(200, 190, 255),
        Border          = Color3.fromRGB(38, 36, 48),
        BorderLight     = Color3.fromRGB(58, 55, 72),
        HeaderGradient1 = Color3.fromRGB(200, 190, 255),
        HeaderGradient2 = Color3.fromRGB(150, 140, 200),
        ScrollBar       = Color3.fromRGB(70, 65, 90),
        Font            = Enum.Font.GothamBold,
        FontLight       = Enum.Font.Gotham,
        CornerRadius    = UDim.new(0, 6),
        Transparency    = 0,
    },
}

-- ========================================
--  UTILITY FUNCTIONS
-- ========================================
local function Tween(obj, props, dur, style, dir)
    style = style or Enum.EasingStyle.Quad
    dir   = dir   or Enum.EasingDirection.Out
    return TweenService:Create(obj, TweenInfo.new(dur or 0.18, style, dir), props):Play()
end

local function MakeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or UDim.new(0, 6)
    c.Parent = parent
    return c
end

local function MakePadding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.PaddingLeft   = UDim.new(0, left   or 0)
    p.PaddingRight  = UDim.new(0, right  or 0)
    p.Parent = parent
    return p
end

local function MakeStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color       = color or Color3.fromRGB(35, 35, 35)
    s.Thickness   = thickness or 1
    s.Transparency = transparency or 0
    s.Parent      = parent
    return s
end

local function MakeGradient(parent, c0, c1, rotation)
    local g = Instance.new("UIGradient")
    g.Color    = ColorSequence.new(c0, c1)
    g.Rotation = rotation or 90
    g.Parent   = parent
    return g
end

local function MakeListLayout(parent, dir, padding, halign, valign)
    local l = Instance.new("UIListLayout")
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.Padding       = UDim.new(0, padding or 4)
    l.HorizontalAlignment = halign or Enum.HorizontalAlignment.Left
    l.VerticalAlignment   = valign or Enum.VerticalAlignment.Top
    l.SortOrder   = Enum.SortOrder.LayoutOrder
    l.Parent      = parent
    return l
end

local function MakeLabel(parent, text, size, color, font, xa, ya)
    local l = Instance.new("TextLabel")
    l.Text            = text
    l.TextSize        = size or 13
    l.TextColor3      = color or Color3.fromRGB(240,240,240)
    l.Font            = font or Enum.Font.GothamBold
    l.BackgroundTransparency = 1
    l.Size            = UDim2.new(1, 0, 0, size and size + 4 or 18)
    l.TextXAlignment  = xa or Enum.TextXAlignment.Left
    l.TextYAlignment  = ya or Enum.TextYAlignment.Center
    l.Parent          = parent
    return l
end

-- Drag support
local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ========================================
--  LIBRARY CONSTRUCTOR
-- ========================================
function PhormaLib:CreateWindow(cfg)
    cfg = cfg or {}
    local Title     = cfg.Title     or "phorma ware"
    local SubTitle  = cfg.SubTitle  or "v1.0"
    local ToggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift
    local Size      = cfg.Size      or {620, 420}
    local ThemeName = cfg.Theme     or "Midnight"

    local T = {}
    for k, v in pairs(Themes[ThemeName] or DefaultTheme) do T[k] = v end
    -- Override with custom theme if passed
    if cfg.CustomTheme then
        for k, v in pairs(cfg.CustomTheme) do T[k] = v end
    end

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name            = "PhormaWare_" .. math.random(1000,9999)
    ScreenGui.ResetOnSpawn    = false
    ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder    = 999
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- ============================================================
    --  MAIN WINDOW FRAME
    -- ============================================================
    local MainFrame = Instance.new("Frame")
    MainFrame.Name              = "MainFrame"
    MainFrame.Size              = UDim2.new(0, Size[1], 0, Size[2])
    MainFrame.Position          = UDim2.new(0.5, -Size[1]/2, 0.5, -Size[2]/2)
    MainFrame.BackgroundColor3  = T.Background
    MainFrame.BorderSizePixel   = 0
    MainFrame.ClipsDescendants  = true
    MainFrame.Parent            = ScreenGui
    MakeCorner(MainFrame, UDim.new(0, 10))
    MakeStroke(MainFrame, T.Border, 1, 0)

    -- Drop shadow (simulated)
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name               = "Shadow"
    Shadow.Size               = UDim2.new(1, 40, 1, 40)
    Shadow.Position           = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image              = "rbxassetid://6014261993"
    Shadow.ImageColor3        = Color3.fromRGB(0,0,0)
    Shadow.ImageTransparency  = 0.6
    Shadow.ScaleType          = Enum.ScaleType.Slice
    Shadow.SliceCenter        = Rect.new(49,49,450,450)
    Shadow.ZIndex             = 0
    Shadow.Parent             = MainFrame

    -- ============================================================
    --  HEADER
    -- ============================================================
    local Header = Instance.new("Frame")
    Header.Name             = "Header"
    Header.Size             = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = T.BackgroundLight
    Header.BorderSizePixel  = 0
    Header.Parent           = MainFrame

    local HeaderGrad = Instance.new("UIGradient")
    HeaderGrad.Color    = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.BackgroundLighter),
        ColorSequenceKeypoint.new(1, T.Background),
    })
    HeaderGrad.Rotation = 180
    HeaderGrad.Parent   = Header

    -- Logo / Title area
    local TitleContainer = Instance.new("Frame")
    TitleContainer.Name             = "TitleContainer"
    TitleContainer.Size             = UDim2.new(0, 220, 1, 0)
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Parent           = Header
    MakePadding(TitleContainer, 0, 0, 16, 0)

    local TitleList = Instance.new("UIListLayout")
    TitleList.FillDirection       = Enum.FillDirection.Horizontal
    TitleList.VerticalAlignment   = Enum.VerticalAlignment.Center
    TitleList.Padding             = UDim.new(0, 8)
    TitleList.Parent              = TitleContainer

    -- Logo dot
    local LogoDot = Instance.new("Frame")
    LogoDot.Name            = "LogoDot"
    LogoDot.Size            = UDim2.new(0, 8, 0, 8)
    LogoDot.BackgroundColor3 = T.Accent
    LogoDot.BorderSizePixel = 0
    LogoDot.Parent          = TitleContainer
    MakeCorner(LogoDot, UDim.new(1, 0))

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name            = "TitleLabel"
    TitleLabel.Text            = Title
    TitleLabel.TextSize        = 16
    TitleLabel.Font            = Enum.Font.GothamBold
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size            = UDim2.new(0, 140, 1, 0)
    TitleLabel.TextXAlignment  = Enum.TextXAlignment.Left
    TitleLabel.Parent          = TitleContainer

    -- Gradient on title text
    local TitleGrad = Instance.new("UIGradient")
    TitleGrad.Color    = ColorSequence.new(T.HeaderGradient1, T.HeaderGradient2)
    TitleGrad.Rotation = 0
    TitleGrad.Parent   = TitleLabel

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Name             = "SubLabel"
    SubLabel.Text             = SubTitle
    SubLabel.TextSize         = 11
    SubLabel.Font             = Enum.Font.Gotham
    SubLabel.BackgroundTransparency = 1
    SubLabel.TextColor3       = T.TextMuted
    SubLabel.Size             = UDim2.new(1, -220, 1, 0)
    SubLabel.Position         = UDim2.new(0, 220, 0, 0)
    SubLabel.TextXAlignment   = Enum.TextXAlignment.Left
    SubLabel.Parent           = Header

    -- Close / minimize buttons
    local BtnContainer = Instance.new("Frame")
    BtnContainer.Name             = "BtnContainer"
    BtnContainer.Size             = UDim2.new(0, 60, 0, 20)
    BtnContainer.Position         = UDim2.new(1, -75, 0.5, -10)
    BtnContainer.BackgroundTransparency = 1
    BtnContainer.Parent           = Header

    local BtnList = Instance.new("UIListLayout")
    BtnList.FillDirection     = Enum.FillDirection.Horizontal
    BtnList.VerticalAlignment = Enum.VerticalAlignment.Center
    BtnList.Padding           = UDim.new(0, 6)
    BtnList.Parent            = BtnContainer

    local function MakeHeaderBtn(icon, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size              = UDim2.new(0, 18, 0, 18)
        btn.BackgroundColor3  = color
        btn.Text              = ""
        btn.BorderSizePixel   = 0
        btn.Parent            = BtnContainer
        MakeCorner(btn, UDim.new(1, 0))

        local lbl = Instance.new("TextLabel")
        lbl.Text              = icon
        lbl.TextSize          = 8
        lbl.Font              = Enum.Font.GothamBold
        lbl.BackgroundTransparency = 1
        lbl.TextColor3        = Color3.fromRGB(0,0,0)
        lbl.Size              = UDim2.new(1,0,1,0)
        lbl.TextTransparency  = 1
        lbl.Parent            = btn

        btn.MouseEnter:Connect(function() lbl.TextTransparency = 0 end)
        btn.MouseLeave:Connect(function() lbl.TextTransparency = 1 end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local minimized = false
    local ContentHeight = Size[2] - 50

    MakeHeaderBtn("–", Color3.fromRGB(255, 200, 50), function()
        minimized = not minimized
        Tween(MainFrame, {
            Size = minimized
                and UDim2.new(0, Size[1], 0, 50)
                or  UDim2.new(0, Size[1], 0, Size[2])
        }, 0.22, Enum.EasingStyle.Quart)
    end)

    local visible = true
    MakeHeaderBtn("✕", Color3.fromRGB(255, 80, 80), function()
        Tween(MainFrame, {Size = UDim2.new(0, Size[1], 0, 0)}, 0.2)
        task.delay(0.2, function() ScreenGui:Destroy() end)
    end)

    MakeDraggable(MainFrame, Header)

    -- Divider
    local Divider = Instance.new("Frame")
    Divider.Size            = UDim2.new(1, 0, 0, 1)
    Divider.Position        = UDim2.new(0, 0, 0, 50)
    Divider.BackgroundColor3 = T.Border
    Divider.BorderSizePixel = 0
    Divider.Parent          = MainFrame

    -- ============================================================
    --  TAB BAR (left sidebar)
    -- ============================================================
    local Sidebar = Instance.new("Frame")
    Sidebar.Name            = "Sidebar"
    Sidebar.Size            = UDim2.new(0, 130, 1, -51)
    Sidebar.Position        = UDim2.new(0, 0, 0, 51)
    Sidebar.BackgroundColor3 = T.TabBar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent          = MainFrame

    local SidebarList = Instance.new("ScrollingFrame")
    SidebarList.Name             = "SidebarList"
    SidebarList.Size             = UDim2.new(1, 0, 1, -10)
    SidebarList.Position         = UDim2.new(0, 0, 0, 8)
    SidebarList.BackgroundTransparency = 1
    SidebarList.BorderSizePixel  = 0
    SidebarList.ScrollBarThickness = 0
    SidebarList.CanvasSize       = UDim2.new(0, 0, 0, 0)
    SidebarList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SidebarList.Parent           = Sidebar
    MakePadding(SidebarList, 0, 0, 8, 8)
    MakeListLayout(SidebarList, Enum.FillDirection.Vertical, 3)

    -- Sidebar divider
    local SBDivider = Instance.new("Frame")
    SBDivider.Size            = UDim2.new(0, 1, 1, -51)
    SBDivider.Position        = UDim2.new(0, 130, 0, 51)
    SBDivider.BackgroundColor3 = T.Border
    SBDivider.BorderSizePixel = 0
    SBDivider.Parent          = MainFrame

    -- ============================================================
    --  CONTENT AREA
    -- ============================================================
    local ContentArea = Instance.new("Frame")
    ContentArea.Name            = "ContentArea"
    ContentArea.Size            = UDim2.new(1, -132, 1, -51)
    ContentArea.Position        = UDim2.new(0, 132, 0, 51)
    ContentArea.BackgroundColor3 = T.Background
    ContentArea.BorderSizePixel = 0
    ContentArea.ClipsDescendants = true
    ContentArea.Parent          = MainFrame

    -- Keybind toggle
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == ToggleKey then
            visible = not visible
            if visible then
                MainFrame.Visible = true
                Tween(MainFrame, {Size = UDim2.new(0, Size[1], 0, Size[2])}, 0.25, Enum.EasingStyle.Back)
            else
                Tween(MainFrame, {Size = UDim2.new(0, Size[1], 0, 0)}, 0.2)
                task.delay(0.2, function() MainFrame.Visible = false end)
            end
        end
    end)

    -- ============================================================
    --  NOTIFICATION SYSTEM
    -- ============================================================
    local NotifContainer = Instance.new("Frame")
    NotifContainer.Name             = "NotifContainer"
    NotifContainer.Size             = UDim2.new(0, 260, 1, 0)
    NotifContainer.Position         = UDim2.new(1, -270, 0, 0)
    NotifContainer.BackgroundTransparency = 1
    NotifContainer.Parent           = ScreenGui
    MakeListLayout(NotifContainer, Enum.FillDirection.Vertical, 6,
        Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom)
    MakePadding(NotifContainer, 0, 20, 0, 10)

    local function Notify(title, message, duration)
        duration = duration or 4
        local NFrame = Instance.new("Frame")
        NFrame.Name             = "Notif"
        NFrame.Size             = UDim2.new(1, 0, 0, 64)
        NFrame.BackgroundColor3 = T.Surface
        NFrame.BorderSizePixel  = 0
        NFrame.BackgroundTransparency = 1
        NFrame.Parent           = NotifContainer
        MakeCorner(NFrame, UDim.new(0, 8))
        MakeStroke(NFrame, T.Border, 1, 0)

        -- Accent bar
        local AccentBar = Instance.new("Frame")
        AccentBar.Size            = UDim2.new(0, 3, 1, -16)
        AccentBar.Position        = UDim2.new(0, 8, 0, 8)
        AccentBar.BackgroundColor3 = T.Accent
        AccentBar.BorderSizePixel = 0
        AccentBar.Parent          = NFrame
        MakeCorner(AccentBar, UDim.new(1, 0))

        local NTitle = MakeLabel(NFrame, title, 13, T.TextPrimary, Enum.Font.GothamBold)
        NTitle.Size     = UDim2.new(1, -28, 0, 18)
        NTitle.Position = UDim2.new(0, 22, 0, 10)

        local NMsg = MakeLabel(NFrame, message, 11, T.TextSecondary, Enum.Font.Gotham)
        NMsg.Size     = UDim2.new(1, -28, 0, 28)
        NMsg.Position = UDim2.new(0, 22, 0, 28)
        NMsg.TextWrapped = true

        Tween(NFrame, {BackgroundTransparency = 0}, 0.2)
        task.delay(duration, function()
            Tween(NFrame, {BackgroundTransparency = 1}, 0.3)
            task.delay(0.3, function() NFrame:Destroy() end)
        end)
    end

    -- ============================================================
    --  WINDOW OBJECT API
    -- ============================================================
    local Window    = {}
    local TabButtons = {}
    local TabPages   = {}
    local CurrentTab = nil

    function Window:Notify(title, msg, dur)
        Notify(title, msg, dur)
    end

    function Window:SetTheme(themeName)
        local newT = Themes[themeName]
        if not newT then return end
        for k, v in pairs(newT) do T[k] = v end
        -- Apply new colors
        MainFrame.BackgroundColor3   = T.Background
        Header.BackgroundColor3      = T.BackgroundLight
        Sidebar.BackgroundColor3     = T.TabBar
        ContentArea.BackgroundColor3 = T.Background
        TitleLabel.TextColor3        = T.TextPrimary
        SubLabel.TextColor3          = T.TextMuted
    end

    function Window:Destroy()
        ScreenGui:Destroy()
    end

    -- ============================================================
    --  ADD TAB
    -- ============================================================
    function Window:AddTab(name, icon)
        local tabIndex = #TabPages + 1

        -- Tab button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name             = "Tab_" .. name
        TabBtn.Size             = UDim2.new(1, 0, 0, 36)
        TabBtn.BackgroundColor3 = T.SurfaceActive
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text             = ""
        TabBtn.BorderSizePixel  = 0
        TabBtn.Parent           = SidebarList
        MakeCorner(TabBtn, UDim.new(0, 6))

        local TabBtnLayout = Instance.new("UIListLayout")
        TabBtnLayout.FillDirection     = Enum.FillDirection.Horizontal
        TabBtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        TabBtnLayout.Padding           = UDim.new(0, 8)
        TabBtnLayout.Parent            = TabBtn
        MakePadding(TabBtn, 0, 0, 10, 0)

        local IconLabel = Instance.new("TextLabel")
        IconLabel.Text             = icon or "◈"
        IconLabel.TextSize         = 14
        IconLabel.Font             = Enum.Font.GothamBold
        IconLabel.TextColor3       = T.TabInactive
        IconLabel.BackgroundTransparency = 1
        IconLabel.Size             = UDim2.new(0, 18, 1, 0)
        IconLabel.Parent           = TabBtn

        local NameLabel = Instance.new("TextLabel")
        NameLabel.Text             = name
        NameLabel.TextSize         = 12
        NameLabel.Font             = Enum.Font.GothamBold
        NameLabel.TextColor3       = T.TabInactive
        NameLabel.BackgroundTransparency = 1
        NameLabel.Size             = UDim2.new(1, -30, 1, 0)
        NameLabel.TextXAlignment   = Enum.TextXAlignment.Left
        NameLabel.Parent           = TabBtn

        -- Active indicator
        local ActiveBar = Instance.new("Frame")
        ActiveBar.Size            = UDim2.new(0, 3, 0, 20)
        ActiveBar.Position        = UDim2.new(0, -10, 0.5, -10)
        ActiveBar.BackgroundColor3 = T.Accent
        ActiveBar.BorderSizePixel = 0
        ActiveBar.BackgroundTransparency = 1
        ActiveBar.Parent          = TabBtn
        MakeCorner(ActiveBar, UDim.new(1, 0))

        -- Tab page (scroll container)
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name                = "TabPage_" .. name
        TabPage.Size                = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel     = 0
        TabPage.ScrollBarThickness  = 3
        TabPage.ScrollBarImageColor3 = T.ScrollBar
        TabPage.CanvasSize          = UDim2.new(0, 0, 0, 0)
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.Visible             = false
        TabPage.Parent              = ContentArea
        MakePadding(TabPage, 12, 12, 12, 12)
        MakeListLayout(TabPage, Enum.FillDirection.Vertical, 10)

        table.insert(TabButtons, {btn = TabBtn, icon = IconLabel, lbl = NameLabel, bar = ActiveBar})
        table.insert(TabPages,   TabPage)

        local function SelectTab()
            for i, tb in ipairs(TabButtons) do
                local active = (i == tabIndex)
                Tween(tb.icon, {TextColor3 = active and T.TabActive or T.TabInactive}, 0.15)
                Tween(tb.lbl,  {TextColor3 = active and T.TabActive or T.TabInactive}, 0.15)
                Tween(tb.bar,  {BackgroundTransparency = active and 0 or 1}, 0.15)
                if active then
                    Tween(tb.btn, {BackgroundTransparency = 0}, 0.15)
                    tb.btn.BackgroundColor3 = T.SurfaceActive
                else
                    Tween(tb.btn, {BackgroundTransparency = 1}, 0.15)
                end
                TabPages[i].Visible = active
            end
            CurrentTab = tabIndex
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)

        -- Auto-select first tab
        if tabIndex == 1 then
            SelectTab()
        end

        -- ========================================================
        --  TAB OBJECT
        -- ========================================================
        local Tab = {}

        -- --------------------------------------------------------
        --  ADD SECTION
        -- --------------------------------------------------------
        function Tab:AddSection(sectionName)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name             = "Section_" .. sectionName
            SectionFrame.Size             = UDim2.new(1, 0, 0, 0)
            SectionFrame.AutomaticSize    = Enum.AutomaticSize.Y
            SectionFrame.BackgroundColor3 = T.Surface
            SectionFrame.BorderSizePixel  = 0
            SectionFrame.Parent           = TabPage
            MakeCorner(SectionFrame, UDim.new(0, 8))
            MakeStroke(SectionFrame, T.Border, 1, 0)

            local SectionInner = Instance.new("Frame")
            SectionInner.Name          = "Inner"
            SectionInner.Size          = UDim2.new(1, 0, 0, 0)
            SectionInner.AutomaticSize = Enum.AutomaticSize.Y
            SectionInner.BackgroundTransparency = 1
            SectionInner.Parent        = SectionFrame
            MakePadding(SectionInner, 10, 10, 12, 12)
            MakeListLayout(SectionInner, Enum.FillDirection.Vertical, 8)

            -- Section header
            local SectionHeader = Instance.new("Frame")
            SectionHeader.Name             = "SectionHeader"
            SectionHeader.Size             = UDim2.new(1, 0, 0, 22)
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.LayoutOrder      = 0
            SectionHeader.Parent           = SectionInner

            local SHLine1 = Instance.new("Frame")
            SHLine1.Size            = UDim2.new(0, 4, 0, 14)
            SHLine1.Position        = UDim2.new(0, 0, 0.5, -7)
            SHLine1.BackgroundColor3 = T.Accent
            SHLine1.BorderSizePixel = 0
            SHLine1.Parent          = SectionHeader
            MakeCorner(SHLine1, UDim.new(1, 0))

            local SHLabel = Instance.new("TextLabel")
            SHLabel.Text           = sectionName
            SHLabel.TextSize       = 11
            SHLabel.Font           = Enum.Font.GothamBold
            SHLabel.TextColor3     = T.TextSecondary
            SHLabel.BackgroundTransparency = 1
            SHLabel.Size           = UDim2.new(1, -14, 1, 0)
            SHLabel.Position       = UDim2.new(0, 10, 0, 0)
            SHLabel.TextXAlignment = Enum.TextXAlignment.Left
            SHLabel.Parent         = SectionHeader

            local SHDivider = Instance.new("Frame")
            SHDivider.Size            = UDim2.new(1, 0, 0, 1)
            SHDivider.Position        = UDim2.new(0, 0, 1, 0)
            SHDivider.BackgroundColor3 = T.Border
            SHDivider.BorderSizePixel = 0
            SHDivider.Parent          = SectionHeader

            -- ====================================================
            --  SECTION OBJECT
            -- ====================================================
            local Section = {}
            local ElemOrder = 1

            local function NextOrder()
                ElemOrder = ElemOrder + 1
                return ElemOrder
            end

            -- ---------------------------------
            --  TOGGLE
            -- ---------------------------------
            function Section:AddToggle(label, default, callback)
                local value = default or false
                local ElemFrame = Instance.new("Frame")
                ElemFrame.Name             = "Toggle_" .. label
                ElemFrame.Size             = UDim2.new(1, 0, 0, 32)
                ElemFrame.BackgroundTransparency = 1
                ElemFrame.LayoutOrder      = NextOrder()
                ElemFrame.Parent           = SectionInner

                local Lbl = MakeLabel(ElemFrame, label, 13, T.TextPrimary, T.Font)
                Lbl.Size = UDim2.new(1, -55, 1, 0)

                -- Toggle track
                local Track = Instance.new("Frame")
                Track.Name             = "Track"
                Track.Size             = UDim2.new(0, 42, 0, 22)
                Track.Position         = UDim2.new(1, -42, 0.5, -11)
                Track.BackgroundColor3 = value and T.Toggle or T.ToggleOff
                Track.BorderSizePixel  = 0
                Track.Parent           = ElemFrame
                MakeCorner(Track, UDim.new(1, 0))

                local Knob = Instance.new("Frame")
                Knob.Name             = "Knob"
                Knob.Size             = UDim2.new(0, 16, 0, 16)
                Knob.Position         = UDim2.new(0, value and 22 or 3, 0.5, -8)
                Knob.BackgroundColor3 = value and T.Background or T.TextPrimary
                Knob.BorderSizePixel  = 0
                Knob.Parent           = Track
                MakeCorner(Knob, UDim.new(1, 0))

                local function SetValue(v)
                    value = v
                    Tween(Track, {BackgroundColor3 = v and T.Toggle or T.ToggleOff}, 0.18)
                    Tween(Knob,  {Position = UDim2.new(0, v and 22 or 3, 0.5, -8),
                                  BackgroundColor3 = v and T.Background or T.TextPrimary}, 0.18)
                    pcall(callback, v)
                end

                local ClickArea = Instance.new("TextButton")
                ClickArea.Size             = UDim2.new(1, 0, 1, 0)
                ClickArea.BackgroundTransparency = 1
                ClickArea.Text             = ""
                ClickArea.Parent           = ElemFrame
                ClickArea.MouseButton1Click:Connect(function() SetValue(not value) end)

                local Api = {Value = value}
                function Api:Set(v) SetValue(v) end
                function Api:Get() return value end
                return Api
            end

            -- ---------------------------------
            --  SLIDER
            -- ---------------------------------
            function Section:AddSlider(label, min, max, default, callback)
                local value = math.clamp(default or min, min, max)
                local ElemFrame = Instance.new("Frame")
                ElemFrame.Name             = "Slider_" .. label
                ElemFrame.Size             = UDim2.new(1, 0, 0, 48)
                ElemFrame.BackgroundTransparency = 1
                ElemFrame.LayoutOrder      = NextOrder()
                ElemFrame.Parent           = SectionInner

                -- Top row: label + value
                local TopRow = Instance.new("Frame")
                TopRow.Size             = UDim2.new(1, 0, 0, 20)
                TopRow.BackgroundTransparency = 1
                TopRow.Parent           = ElemFrame

                local Lbl = MakeLabel(TopRow, label, 13, T.TextPrimary, T.Font)
                Lbl.Size = UDim2.new(1, -50, 1, 0)

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Text          = tostring(value)
                ValLabel.TextSize      = 12
                ValLabel.Font          = Enum.Font.GothamBold
                ValLabel.TextColor3    = T.Accent
                ValLabel.BackgroundTransparency = 1
                ValLabel.Size          = UDim2.new(0, 48, 1, 0)
                ValLabel.Position      = UDim2.new(1, -48, 0, 0)
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValLabel.Parent        = TopRow

                -- Track
                local SliderTrack = Instance.new("Frame")
                SliderTrack.Name             = "Track"
                SliderTrack.Size             = UDim2.new(1, 0, 0, 6)
                SliderTrack.Position         = UDim2.new(0, 0, 0, 28)
                SliderTrack.BackgroundColor3 = T.ToggleOff
                SliderTrack.BorderSizePixel  = 0
                SliderTrack.Parent           = ElemFrame
                MakeCorner(SliderTrack, UDim.new(1, 0))

                local SliderFill = Instance.new("Frame")
                SliderFill.Name             = "Fill"
                SliderFill.Size             = UDim2.new((value - min) / (max - min), 0, 1, 0)
                SliderFill.BackgroundColor3 = T.Slider
                SliderFill.BorderSizePixel  = 0
                SliderFill.Parent           = SliderTrack
                MakeCorner(SliderFill, UDim.new(1, 0))

                local SliderKnob = Instance.new("Frame")
                SliderKnob.Name             = "Knob"
                SliderKnob.Size             = UDim2.new(0, 14, 0, 14)
                SliderKnob.Position         = UDim2.new((value - min) / (max - min), -7, 0.5, -7)
                SliderKnob.BackgroundColor3 = T.TextPrimary
                SliderKnob.BorderSizePixel  = 0
                SliderKnob.Parent           = SliderTrack
                MakeCorner(SliderKnob, UDim.new(1, 0))
                MakeStroke(SliderKnob, T.Background, 2, 0)

                local dragging = false

                local function UpdateSlider(input)
                    local trackPos  = SliderTrack.AbsolutePosition.X
                    local trackSize = SliderTrack.AbsoluteSize.X
                    local relX      = math.clamp((input.Position.X - trackPos) / trackSize, 0, 1)
                    local newVal    = math.floor(min + (max - min) * relX)
                    value           = newVal
                    ValLabel.Text   = tostring(newVal)
                    SliderFill.Size = UDim2.new(relX, 0, 1, 0)
                    SliderKnob.Position = UDim2.new(relX, -7, 0.5, -7)
                    pcall(callback, newVal)
                end

                SliderTrack.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        UpdateSlider(inp)
                    end
                end)

                UserInputService.InputChanged:Connect(function(inp)
                    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(inp)
                    end
                end)

                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                local Api = {}
                function Api:Set(v)
                    v = math.clamp(v, min, max)
                    value = v
                    local relX = (v - min) / (max - min)
                    ValLabel.Text   = tostring(v)
                    SliderFill.Size = UDim2.new(relX, 0, 1, 0)
                    SliderKnob.Position = UDim2.new(relX, -7, 0.5, -7)
                    pcall(callback, v)
                end
                function Api:Get() return value end
                return Api
            end

            -- ---------------------------------
            --  BUTTON
            -- ---------------------------------
            function Section:AddButton(label, callback, subLabel)
                local ElemFrame = Instance.new("Frame")
                ElemFrame.Name             = "Button_" .. label
                ElemFrame.Size             = UDim2.new(1, 0, 0, 34)
                ElemFrame.BackgroundTransparency = 1
                ElemFrame.LayoutOrder      = NextOrder()
                ElemFrame.Parent           = SectionInner

                local Btn = Instance.new("TextButton")
                Btn.Name             = "Btn"
                Btn.Size             = UDim2.new(1, 0, 1, 0)
                Btn.BackgroundColor3 = T.SurfaceHover
                Btn.Text             = ""
                Btn.BorderSizePixel  = 0
                Btn.Parent           = ElemFrame
                MakeCorner(Btn, UDim.new(0, 6))
                MakeStroke(Btn, T.BorderLight, 1, 0)

                local BtnLbl = Instance.new("TextLabel")
                BtnLbl.Text          = label
                BtnLbl.TextSize      = 13
                BtnLbl.Font          = Enum.Font.GothamBold
                BtnLbl.TextColor3    = T.TextPrimary
                BtnLbl.BackgroundTransparency = 1
                BtnLbl.Size          = UDim2.new(1, -20, 1, 0)
                BtnLbl.Position      = UDim2.new(0, 12, 0, 0)
                BtnLbl.TextXAlignment = Enum.TextXAlignment.Left
                BtnLbl.Parent        = Btn

                if subLabel then
                    local SubLbl = Instance.new("TextLabel")
                    SubLbl.Text         = subLabel
                    SubLbl.TextSize     = 10
                    SubLbl.Font         = Enum.Font.Gotham
                    SubLbl.TextColor3   = T.TextMuted
                    SubLbl.BackgroundTransparency = 1
                    SubLbl.Size         = UDim2.new(0, 100, 1, 0)
                    SubLbl.Position     = UDim2.new(1, -110, 0, 0)
                    SubLbl.TextXAlignment = Enum.TextXAlignment.Right
                    SubLbl.Parent       = Btn
                end

                Btn.MouseEnter:Connect(function()
                    Tween(Btn, {BackgroundColor3 = T.SurfaceActive}, 0.12)
                end)
                Btn.MouseLeave:Connect(function()
                    Tween(Btn, {BackgroundColor3 = T.SurfaceHover}, 0.12)
                end)
                Btn.MouseButton1Down:Connect(function()
                    Tween(Btn, {BackgroundColor3 = T.Border}, 0.08)
                end)
                Btn.MouseButton1Up:Connect(function()
                    Tween(Btn, {BackgroundColor3 = T.SurfaceActive}, 0.12)
                    pcall(callback)
                end)
            end

            -- ---------------------------------
            --  DROPDOWN
            -- ---------------------------------
            function Section:AddDropdown(label, options, default, callback)
                local value = default or options[1]
                local open  = false

                local ElemFrame = Instance.new("Frame")
                ElemFrame.Name             = "Dropdown_" .. label
                ElemFrame.Size             = UDim2.new(1, 0, 0, 56)
                ElemFrame.BackgroundTransparency = 1
                ElemFrame.LayoutOrder      = NextOrder()
                ElemFrame.ClipsDescendants = false
                ElemFrame.Parent           = SectionInner

                local Lbl = MakeLabel(ElemFrame, label, 13, T.TextPrimary, T.Font)
                Lbl.Size = UDim2.new(1, 0, 0, 20)

                local DDBtn = Instance.new("TextButton")
                DDBtn.Name             = "DDBtn"
                DDBtn.Size             = UDim2.new(1, 0, 0, 30)
                DDBtn.Position         = UDim2.new(0, 0, 0, 22)
                DDBtn.BackgroundColor3 = T.SurfaceHover
                DDBtn.Text             = ""
                DDBtn.BorderSizePixel  = 0
                DDBtn.Parent           = ElemFrame
                MakeCorner(DDBtn, UDim.new(0, 6))
                MakeStroke(DDBtn, T.BorderLight, 1, 0)

                local DDLabel = Instance.new("TextLabel")
                DDLabel.Text          = value
                DDLabel.TextSize      = 12
                DDLabel.Font          = Enum.Font.Gotham
                DDLabel.TextColor3    = T.TextPrimary
                DDLabel.BackgroundTransparency = 1
                DDLabel.Size          = UDim2.new(1, -36, 1, 0)
                DDLabel.Position      = UDim2.new(0, 10, 0, 0)
                DDLabel.TextXAlignment = Enum.TextXAlignment.Left
                DDLabel.Parent        = DDBtn

                local Arrow = Instance.new("TextLabel")
                Arrow.Text           = "▾"
                Arrow.TextSize       = 14
                Arrow.Font           = Enum.Font.GothamBold
                Arrow.TextColor3     = T.TextSecondary
                Arrow.BackgroundTransparency = 1
                Arrow.Size           = UDim2.new(0, 24, 1, 0)
                Arrow.Position       = UDim2.new(1, -26, 0, 0)
                Arrow.Parent         = DDBtn

                -- Dropdown list
                local DDList = Instance.new("Frame")
                DDList.Name            = "DDList"
                DDList.Size            = UDim2.new(1, 0, 0, 0)
                DDList.Position        = UDim2.new(0, 0, 1, 2)
                DDList.BackgroundColor3 = T.Surface
                DDList.BorderSizePixel = 0
                DDList.Visible         = false
                DDList.ClipsDescendants = true
                DDList.ZIndex          = 10
                DDList.Parent          = DDBtn
                MakeCorner(DDList, UDim.new(0, 6))
                MakeStroke(DDList, T.BorderLight, 1, 0)
                MakeListLayout(DDList, Enum.FillDirection.Vertical, 0)

                local fullH = #options * 28

                for _, opt in ipairs(options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Name             = "Opt_" .. opt
                    OptBtn.Size             = UDim2.new(1, 0, 0, 28)
                    OptBtn.BackgroundColor3 = T.Surface
                    OptBtn.BackgroundTransparency = opt == value and 0.5 or 1
                    OptBtn.Text             = ""
                    OptBtn.BorderSizePixel  = 0
                    OptBtn.ZIndex           = 11
                    OptBtn.Parent           = DDList

                    local OptLbl = Instance.new("TextLabel")
                    OptLbl.Text           = opt
                    OptLbl.TextSize       = 12
                    OptLbl.Font           = Enum.Font.Gotham
                    OptLbl.TextColor3     = T.TextPrimary
                    OptLbl.BackgroundTransparency = 1
                    OptLbl.Size           = UDim2.new(1, -16, 1, 0)
                    OptLbl.Position       = UDim2.new(0, 10, 0, 0)
                    OptLbl.TextXAlignment = Enum.TextXAlignment.Left
                    OptLbl.ZIndex         = 12
                    OptLbl.Parent         = OptBtn

                    OptBtn.MouseEnter:Connect(function()
                        Tween(OptBtn, {BackgroundTransparency = 0.4}, 0.1)
                    end)
                    OptBtn.MouseLeave:Connect(function()
                        Tween(OptBtn, {BackgroundTransparency = opt == value and 0.5 or 1}, 0.1)
                    end)
                    OptBtn.MouseButton1Click:Connect(function()
                        value = opt
                        DDLabel.Text = opt
                        open = false
                        Tween(DDList, {Size = UDim2.new(1, 0, 0, 0)}, 0.18, Enum.EasingStyle.Quart)
                        task.delay(0.18, function() DDList.Visible = false end)
                        Tween(Arrow, {Rotation = 0}, 0.18)
                        pcall(callback, opt)
                    end)
                end

                DDBtn.MouseButton1Click:Connect(function()
                    open = not open
                    if open then
                        DDList.Visible = true
                        Tween(DDList, {Size = UDim2.new(1, 0, 0, fullH)}, 0.22, Enum.EasingStyle.Quart)
                        Tween(Arrow, {Rotation = 180}, 0.22)
                    else
                        Tween(DDList, {Size = UDim2.new(1, 0, 0, 0)}, 0.18)
                        task.delay(0.18, function() DDList.Visible = false end)
                        Tween(Arrow, {Rotation = 0}, 0.18)
                    end
                end)

                local Api = {}
                function Api:Set(v)
                    value = v
                    DDLabel.Text = v
                    pcall(callback, v)
                end
                function Api:Get() return value end
                return Api
            end

            -- ---------------------------------
            --  TEXTBOX
            -- ---------------------------------
            function Section:AddTextBox(label, placeholder, callback)
                local ElemFrame = Instance.new("Frame")
                ElemFrame.Name             = "TextBox_" .. label
                ElemFrame.Size             = UDim2.new(1, 0, 0, 56)
                ElemFrame.BackgroundTransparency = 1
                ElemFrame.LayoutOrder      = NextOrder()
                ElemFrame.Parent           = SectionInner

                local Lbl = MakeLabel(ElemFrame, label, 13, T.TextPrimary, T.Font)
                Lbl.Size = UDim2.new(1, 0, 0, 20)

                local TBFrame = Instance.new("Frame")
                TBFrame.Size            = UDim2.new(1, 0, 0, 30)
                TBFrame.Position        = UDim2.new(0, 0, 0, 22)
                TBFrame.BackgroundColor3 = T.SurfaceHover
                TBFrame.BorderSizePixel = 0
                TBFrame.Parent          = ElemFrame
                MakeCorner(TBFrame, UDim.new(0, 6))
                MakeStroke(TBFrame, T.BorderLight, 1, 0)

                local TB = Instance.new("TextBox")
                TB.Name             = "TB"
                TB.Size             = UDim2.new(1, -20, 1, 0)
                TB.Position         = UDim2.new(0, 10, 0, 0)
                TB.BackgroundTransparency = 1
                TB.PlaceholderText  = placeholder or "Enter text..."
                TB.PlaceholderColor3 = T.TextMuted
                TB.Text             = ""
                TB.TextSize         = 12
                TB.Font             = Enum.Font.Gotham
                TB.TextColor3       = T.TextPrimary
                TB.TextXAlignment   = Enum.TextXAlignment.Left
                TB.ClearTextOnFocus = false
                TB.Parent           = TBFrame

                TB.Focused:Connect(function()
                    Tween(TBFrame, {BackgroundColor3 = T.SurfaceActive}, 0.12)
                    MakeStroke(TBFrame, T.Accent, 1, 0)
                end)
                TB.FocusLost:Connect(function(enter)
                    Tween(TBFrame, {BackgroundColor3 = T.SurfaceHover}, 0.12)
                    MakeStroke(TBFrame, T.BorderLight, 1, 0)
                    if enter then pcall(callback, TB.Text) end
                end)

                local Api = {}
                function Api:Set(v) TB.Text = v end
                function Api:Get() return TB.Text end
                return Api
            end

            -- ---------------------------------
            --  KEYBIND
            -- ---------------------------------
            function Section:AddKeybind(label, default, callback)
                local key     = default or Enum.KeyCode.Unknown
                local binding = false

                local ElemFrame = Instance.new("Frame")
                ElemFrame.Name             = "Keybind_" .. label
                ElemFrame.Size             = UDim2.new(1, 0, 0, 32)
                ElemFrame.BackgroundTransparency = 1
                ElemFrame.LayoutOrder      = NextOrder()
                ElemFrame.Parent           = SectionInner

                local Lbl = MakeLabel(ElemFrame, label, 13, T.TextPrimary, T.Font)
                Lbl.Size = UDim2.new(1, -90, 1, 0)

                local KeyBtn = Instance.new("TextButton")
                KeyBtn.Name             = "KeyBtn"
                KeyBtn.Size             = UDim2.new(0, 80, 0, 24)
                KeyBtn.Position         = UDim2.new(1, -80, 0.5, -12)
                KeyBtn.BackgroundColor3 = T.SurfaceHover
                KeyBtn.Text             = key.Name
                KeyBtn.TextSize         = 11
                KeyBtn.Font             = Enum.Font.GothamBold
                KeyBtn.TextColor3       = T.TextSecondary
                KeyBtn.BorderSizePixel  = 0
                KeyBtn.Parent           = ElemFrame
                MakeCorner(KeyBtn, UDim.new(0, 5))
                MakeStroke(KeyBtn, T.BorderLight, 1, 0)

                KeyBtn.MouseButton1Click:Connect(function()
                    if binding then return end
                    binding = true
                    KeyBtn.Text      = "..."
                    KeyBtn.TextColor3 = T.Accent
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                        binding = false
                        key     = input.KeyCode
                        KeyBtn.Text      = key.Name
                        KeyBtn.TextColor3 = T.TextSecondary
                        pcall(callback, key)
                    end
                end)

                local Api = {}
                function Api:Set(k) key = k; KeyBtn.Text = k.Name end
                function Api:Get() return key end
                return Api
            end

            -- ---------------------------------
            --  COLOR PICKER
            -- ---------------------------------
            function Section:AddColorPicker(label, default, callback)
                local color = default or Color3.fromRGB(255, 255, 255)
                local open  = false

                local ElemFrame = Instance.new("Frame")
                ElemFrame.Name             = "ColorPicker_" .. label
                ElemFrame.Size             = UDim2.new(1, 0, 0, 32)
                ElemFrame.BackgroundTransparency = 1
                ElemFrame.ClipsDescendants = false
                ElemFrame.LayoutOrder      = NextOrder()
                ElemFrame.Parent           = SectionInner

                local Lbl = MakeLabel(ElemFrame, label, 13, T.TextPrimary, T.Font)
                Lbl.Size = UDim2.new(1, -50, 1, 0)

                local Preview = Instance.new("TextButton")
                Preview.Name             = "Preview"
                Preview.Size             = UDim2.new(0, 38, 0, 22)
                Preview.Position         = UDim2.new(1, -38, 0.5, -11)
                Preview.BackgroundColor3 = color
                Preview.Text             = ""
                Preview.BorderSizePixel  = 0
                Preview.Parent           = ElemFrame
                MakeCorner(Preview, UDim.new(0, 5))
                MakeStroke(Preview, T.BorderLight, 1, 0)

                -- Simple HSV picker panel
                local Panel = Instance.new("Frame")
                Panel.Name             = "Panel"
                Panel.Size             = UDim2.new(0, 200, 0, 160)
                Panel.Position         = UDim2.new(1, -200, 1, 4)
                Panel.BackgroundColor3 = T.Surface
                Panel.BorderSizePixel  = 0
                Panel.Visible          = false
                Panel.ZIndex           = 20
                Panel.Parent           = ElemFrame
                MakeCorner(Panel, UDim.new(0, 8))
                MakeStroke(Panel, T.BorderLight, 1, 0)
                MakePadding(Panel, 10, 10, 10, 10)

                local PanelList = Instance.new("UIListLayout")
                PanelList.FillDirection = Enum.FillDirection.Vertical
                PanelList.Padding       = UDim.new(0, 6)
                PanelList.Parent        = Panel

                local function AddSliderRow(lbl, min, max, val, clr)
                    local row = Instance.new("Frame")
                    row.Size            = UDim2.new(1, 0, 0, 28)
                    row.BackgroundTransparency = 1
                    row.Parent          = Panel

                    local rowLbl = MakeLabel(row, lbl, 10, T.TextSecondary, Enum.Font.Gotham)
                    rowLbl.Size = UDim2.new(0, 14, 1, 0)

                    local track = Instance.new("Frame")
                    track.Size            = UDim2.new(1, -40, 0, 6)
                    track.Position        = UDim2.new(0, 20, 0.5, -3)
                    track.BackgroundColor3 = T.ToggleOff
                    track.BorderSizePixel = 0
                    track.Parent          = row
                    MakeCorner(track, UDim.new(1, 0))

                    local fill = Instance.new("Frame")
                    fill.Size            = UDim2.new(val / max, 0, 1, 0)
                    fill.BackgroundColor3 = clr
                    fill.BorderSizePixel = 0
                    fill.Parent          = track
                    MakeCorner(fill, UDim.new(1, 0))

                    local knob = Instance.new("Frame")
                    knob.Size            = UDim2.new(0, 12, 0, 12)
                    knob.Position        = UDim2.new(val / max, -6, 0.5, -6)
                    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
                    knob.BorderSizePixel = 0
                    knob.Parent          = track
                    MakeCorner(knob, UDim.new(1, 0))

                    local valLbl = MakeLabel(row, tostring(math.floor(val * max)), 10, T.TextSecondary, Enum.Font.Gotham)
                    valLbl.Size     = UDim2.new(0, 22, 1, 0)
                    valLbl.Position = UDim2.new(1, -22, 0, 0)
                    valLbl.TextXAlignment = Enum.TextXAlignment.Right

                    local dragging = false
                    track.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                    end)

                    local currentVal = val
                    UserInputService.InputChanged:Connect(function(inp)
                        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                            local rx = math.clamp((inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                            currentVal = rx
                            fill.Size = UDim2.new(rx, 0, 1, 0)
                            knob.Position = UDim2.new(rx, -6, 0.5, -6)
                            valLbl.Text = tostring(math.floor(rx * max))
                            return rx
                        end
                    end)

                    return function() return currentVal end
                end

                local h, s, v = Color3.toHSV(color)
                local getH = AddSliderRow("H", 0, 360, h, Color3.fromHSV(h, 1, 1))
                local getS = AddSliderRow("S", 0, 100, s, Color3.fromRGB(200,200,200))
                local getV = AddSliderRow("V", 0, 100, v, Color3.fromRGB(200,200,200))

                RunService.Heartbeat:Connect(function()
                    if open then
                        local nh, ns, nv = getH(), getS(), getV()
                        color = Color3.fromHSV(nh, ns, nv)
                        Preview.BackgroundColor3 = color
                        pcall(callback, color)
                    end
                end)

                Preview.MouseButton1Click:Connect(function()
                    open = not open
                    Panel.Visible = open
                end)

                local Api = {}
                function Api:Set(c) color = c; Preview.BackgroundColor3 = c; pcall(callback, c) end
                function Api:Get() return color end
                return Api
            end

            -- ---------------------------------
            --  LABEL (read-only info)
            -- ---------------------------------
            function Section:AddLabel(text)
                local Lbl = MakeLabel(SectionInner, text, 12, T.TextSecondary, T.FontLight)
                Lbl.LayoutOrder = NextOrder()
                Lbl.TextWrapped = true
                Lbl.Size        = UDim2.new(1, 0, 0, 18)
                Lbl.AutomaticSize = Enum.AutomaticSize.Y
                return Lbl
            end

            -- ---------------------------------
            --  SEPARATOR
            -- ---------------------------------
            function Section:AddSeparator()
                local Sep = Instance.new("Frame")
                Sep.Size            = UDim2.new(1, 0, 0, 1)
                Sep.BackgroundColor3 = T.Border
                Sep.BorderSizePixel = 0
                Sep.LayoutOrder     = NextOrder()
                Sep.Parent          = SectionInner
            end

            return Section
        end -- AddSection

        return Tab
    end -- AddTab

    -- ============================================================
    --  SETTINGS TAB (built-in customization)
    -- ============================================================
    local SettingsTab = Window:AddTab("Settings", "⚙")
    local ThemeSection = SettingsTab:AddSection("Theme")

    ThemeSection:AddDropdown("Preset Theme", {"Midnight", "Snow", "Ash"}, "Midnight", function(val)
        Window:SetTheme(val)
    end)

    ThemeSection:AddButton("Reset Window Position", function()
        Tween(MainFrame, {Position = UDim2.new(0.5, -Size[1]/2, 0.5, -Size[2]/2)}, 0.3, Enum.EasingStyle.Back)
    end, "utility")

    local InfoSection = SettingsTab:AddSection("Info")
    InfoSection:AddLabel("phorma ware — UI Library")
    InfoSection:AddLabel("Toggle visibility: " .. ToggleKey.Name)
    InfoSection:AddSeparator()
    InfoSection:AddLabel("Drag the header to move the window.")

    return Window
end

return PhormaLib
