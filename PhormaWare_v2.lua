--[[
    phorma ware v2.0
    Floating tabs | Context menu | Fixed bugs
--]]

-- ========================================
--  SERVICES
-- ========================================
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local CoreGui           = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ========================================
--  UTILITY
-- ========================================
local function Tween(obj, props, dur, style, dir)
    TweenService:Create(obj, TweenInfo.new(dur or 0.18,
        style or Enum.EasingStyle.Quad,
        dir   or Enum.EasingDirection.Out), props):Play()
end

local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = p
    return c
end

local function Pad(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 0)
    u.PaddingBottom = UDim.new(0, b or 0)
    u.PaddingLeft   = UDim.new(0, l or 0)
    u.PaddingRight  = UDim.new(0, r or 0)
    u.Parent = p
end

local function Stroke(p, col, thick)
    local s = Instance.new("UIStroke")
    s.Color     = col or Color3.fromRGB(40,40,40)
    s.Thickness = thick or 1
    s.Parent    = p
    return s
end

local function List(p, dir, gap, ha, va)
    local l = Instance.new("UIListLayout")
    l.FillDirection       = dir or Enum.FillDirection.Vertical
    l.Padding             = UDim.new(0, gap or 4)
    l.HorizontalAlignment = ha  or Enum.HorizontalAlignment.Left
    l.VerticalAlignment   = va  or Enum.VerticalAlignment.Top
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    l.Parent = p
    return l
end

local function Label(p, txt, size, col, font, xa)
    local l = Instance.new("TextLabel")
    l.Text       = txt
    l.TextSize   = size or 13
    l.TextColor3 = col  or Color3.fromRGB(230,230,230)
    l.Font       = font or Enum.Font.GothamBold
    l.BackgroundTransparency = 1
    l.Size       = UDim2.new(1,0,0,size and size+4 or 18)
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Parent = p
    return l
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local drag, ds, sp
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; ds = i.Position; sp = frame.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
        end
    end)
end

-- ========================================
--  THEME
-- ========================================
local T = {
    BG          = Color3.fromRGB(12,12,12),
    BGLight     = Color3.fromRGB(18,18,18),
    Surface     = Color3.fromRGB(22,22,22),
    SurfaceHov  = Color3.fromRGB(30,30,30),
    SurfaceAct  = Color3.fromRGB(38,38,38),
    Border      = Color3.fromRGB(38,38,38),
    BorderLight = Color3.fromRGB(55,55,55),
    Accent      = Color3.fromRGB(255,255,255),
    AccentDim   = Color3.fromRGB(160,160,160),
    TextPri     = Color3.fromRGB(235,235,235),
    TextSec     = Color3.fromRGB(140,140,140),
    TextMut     = Color3.fromRGB(70,70,70),
    ToggleOn    = Color3.fromRGB(255,255,255),
    ToggleOff   = Color3.fromRGB(45,45,45),
    SliderFill  = Color3.fromRGB(255,255,255),
    ScrollBar   = Color3.fromRGB(55,55,55),
    TabAccents  = {
        Color3.fromRGB(255,255,255),
        Color3.fromRGB(200,200,255),
        Color3.fromRGB(200,255,220),
        Color3.fromRGB(255,220,200),
        Color3.fromRGB(255,200,230),
    },
}

-- ========================================
--  SCREEN GUI
-- ========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "PhormaWare_v2"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder   = 999
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ========================================
--  NOTIFICATION SYSTEM
-- ========================================
local NotifHolder = Instance.new("Frame")
NotifHolder.Size     = UDim2.new(0,260,1,0)
NotifHolder.Position = UDim2.new(1,-270,0,0)
NotifHolder.BackgroundTransparency = 1
NotifHolder.Parent   = ScreenGui
List(NotifHolder, Enum.FillDirection.Vertical, 6,
    Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom)
Pad(NotifHolder, 0, 20, 0, 0)

local function Notify(title, msg, dur)
    dur = dur or 3.5
    local F = Instance.new("Frame")
    F.Size             = UDim2.new(1,0,0,60)
    F.BackgroundColor3 = T.Surface
    F.BackgroundTransparency = 1
    F.Parent           = NotifHolder
    Corner(F,8); Stroke(F, T.Border)

    local Bar = Instance.new("Frame")
    Bar.Size            = UDim2.new(0,3,0,36)
    Bar.Position        = UDim2.new(0,8,0.5,-18)
    Bar.BackgroundColor3 = T.Accent
    Bar.BorderSizePixel = 0
    Bar.Parent          = F; Corner(Bar,4)

    local TL = Label(F, title, 12, T.TextPri, Enum.Font.GothamBold)
    TL.Size = UDim2.new(1,-24,0,16); TL.Position = UDim2.new(0,20,0,10)

    local ML = Label(F, msg, 11, T.TextSec, Enum.Font.Gotham)
    ML.Size = UDim2.new(1,-24,0,24); ML.Position = UDim2.new(0,20,0,28)
    ML.TextWrapped = true

    Tween(F,{BackgroundTransparency=0},0.2)
    task.delay(dur, function()
        Tween(F,{BackgroundTransparency=1},0.3)
        task.delay(0.3, function() F:Destroy() end)
    end)
end

-- ========================================
--  CONTEXT MENU (правый клик)
-- ========================================
local ContextMenu = Instance.new("Frame")
ContextMenu.Name             = "ContextMenu"
ContextMenu.Size             = UDim2.new(0,160,0,0)
ContextMenu.BackgroundColor3 = T.BGLight
ContextMenu.BorderSizePixel  = 0
ContextMenu.Visible          = false
ContextMenu.ZIndex           = 100
ContextMenu.ClipsDescendants = true
ContextMenu.Parent           = ScreenGui
Corner(ContextMenu, 8)
Stroke(ContextMenu, T.BorderLight)

local ContextList = Instance.new("Frame")
ContextList.Size             = UDim2.new(1,0,0,0)
ContextList.AutomaticSize    = Enum.AutomaticSize.Y
ContextList.BackgroundTransparency = 1
ContextList.ZIndex           = 101
ContextList.Parent           = ContextMenu
List(ContextList, Enum.FillDirection.Vertical, 0)
Pad(ContextList, 4,4,0,0)

local function CloseContext()
    Tween(ContextMenu,{Size=UDim2.new(0,160,0,0)},0.15)
    task.delay(0.15, function() ContextMenu.Visible = false end)
end

local function OpenContext(pos, items)
    -- Clear old items
    for _, c in ipairs(ContextList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end

    for _, item in ipairs(items) do
        local Btn = Instance.new("TextButton")
        Btn.Size             = UDim2.new(1,0,0,30)
        Btn.BackgroundColor3 = T.BGLight
        Btn.BackgroundTransparency = 1
        Btn.Text             = ""
        Btn.BorderSizePixel  = 0
        Btn.ZIndex           = 102
        Btn.Parent           = ContextList

        local Ico = Instance.new("TextLabel")
        Ico.Text       = item.icon or "•"
        Ico.TextSize   = 12
        Ico.Font       = Enum.Font.GothamBold
        Ico.TextColor3 = item.color or T.TextSec
        Ico.BackgroundTransparency = 1
        Ico.Size       = UDim2.new(0,22,1,0)
        Ico.Position   = UDim2.new(0,8,0,0)
        Ico.ZIndex     = 103
        Ico.Parent     = Btn

        local Lbl = Instance.new("TextLabel")
        Lbl.Text       = item.label
        Lbl.TextSize   = 12
        Lbl.Font       = Enum.Font.Gotham
        Lbl.TextColor3 = item.color or T.TextPri
        Lbl.BackgroundTransparency = 1
        Lbl.Size       = UDim2.new(1,-30,1,0)
        Lbl.Position   = UDim2.new(0,28,0,0)
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.ZIndex     = 103
        Lbl.Parent     = Btn

        Btn.MouseEnter:Connect(function()
            Tween(Btn,{BackgroundTransparency=0.7},0.1)
            Btn.BackgroundColor3 = T.SurfaceHov
        end)
        Btn.MouseLeave:Connect(function()
            Tween(Btn,{BackgroundTransparency=1},0.1)
        end)
        Btn.MouseButton1Click:Connect(function()
            CloseContext()
            pcall(item.action)
        end)

        -- Divider
        if item.divider then
            local Div = Instance.new("Frame")
            Div.Size            = UDim2.new(1,-16,0,1)
            Div.Position        = UDim2.new(0,8,0,0)
            Div.BackgroundColor3 = T.Border
            Div.BorderSizePixel = 0
            Div.ZIndex          = 102
            Div.Parent          = ContextList
        end
    end

    local totalH = #items * 30 + 8
    ContextMenu.Position = UDim2.new(0, pos.X, 0, pos.Y)
    ContextMenu.Size     = UDim2.new(0,160,0,0)
    ContextMenu.Visible  = true
    Tween(ContextMenu, {Size=UDim2.new(0,160,0,totalH)}, 0.2, Enum.EasingStyle.Quart)
end

-- Close context on click elsewhere
UserInputService.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        CloseContext()
    end
end)

-- ========================================
--  TAB BUILDER
-- ========================================
local TabCount = 0
local AllTabs  = {}

-- Tab bar (горизонтальная полоска сверху)
local TabBar = Instance.new("Frame")
TabBar.Name             = "TabBar"
TabBar.Size             = UDim2.new(0,0,0,34)
TabBar.Position         = UDim2.new(0.5,-200,0,8)
TabBar.BackgroundColor3 = T.BGLight
TabBar.BorderSizePixel  = 0
TabBar.AutomaticSize    = Enum.AutomaticSize.X
TabBar.Parent           = ScreenGui
Corner(TabBar, 10)
Stroke(TabBar, T.Border)

local TabBarList = Instance.new("Frame")
TabBarList.Size          = UDim2.new(0,0,1,0)
TabBarList.AutomaticSize = Enum.AutomaticSize.X
TabBarList.BackgroundTransparency = 1
TabBarList.Parent        = TabBar
List(TabBarList, Enum.FillDirection.Horizontal, 2,
    Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
Pad(TabBarList, 0,0,6,6)

MakeDraggable(TabBar, TabBar)

-- Logo на таб баре
local LogoBtn = Instance.new("TextButton")
LogoBtn.Size             = UDim2.new(0,90,0,26)
LogoBtn.BackgroundTransparency = 1
LogoBtn.Text             = ""
LogoBtn.BorderSizePixel  = 0
LogoBtn.Parent           = TabBarList

local LogoLbl = Instance.new("TextLabel")
LogoLbl.Text       = "◆ phorma"
LogoLbl.TextSize   = 13
LogoLbl.Font       = Enum.Font.GothamBold
LogoLbl.TextColor3 = T.Accent
LogoLbl.BackgroundTransparency = 1
LogoLbl.Size       = UDim2.new(1,0,1,0)
LogoLbl.TextXAlignment = Enum.TextXAlignment.Left
LogoLbl.Parent     = LogoBtn

local Divider = Instance.new("Frame")
Divider.Size            = UDim2.new(0,1,0,18)
Divider.BackgroundColor3 = T.Border
Divider.BorderSizePixel = 0
Divider.Parent          = TabBarList

-- ========================================
--  CREATE FLOATING WINDOW
-- ========================================
local function CreateFloatingTab(name, icon, accentColor, startPos)
    TabCount = TabCount + 1
    local idx = TabCount
    accentColor = accentColor or T.TabAccents[idx] or T.Accent

    -- ---- TAB BUTTON ----
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name             = "Tab_"..name
    TabBtn.Size             = UDim2.new(0,0,0,26)
    TabBtn.AutomaticSize    = Enum.AutomaticSize.X
    TabBtn.BackgroundColor3 = T.SurfaceAct
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text             = ""
    TabBtn.BorderSizePixel  = 0
    TabBtn.Parent           = TabBarList
    Corner(TabBtn, 7)

    local TabBtnInner = Instance.new("Frame")
    TabBtnInner.Size             = UDim2.new(1,0,1,0)
    TabBtnInner.BackgroundTransparency = 1
    TabBtnInner.Parent           = TabBtn
    List(TabBtnInner, Enum.FillDirection.Horizontal, 5,
        Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)
    Pad(TabBtnInner, 0,0,10,10)

    local TabIco = Instance.new("TextLabel")
    TabIco.Text       = icon or "◈"
    TabIco.TextSize   = 12
    TabIco.Font       = Enum.Font.GothamBold
    TabIco.TextColor3 = T.TextMut
    TabIco.BackgroundTransparency = 1
    TabIco.Size       = UDim2.new(0,14,1,0)
    TabIco.AutomaticSize = Enum.AutomaticSize.X
    TabIco.Parent     = TabBtnInner

    local TabLbl = Instance.new("TextLabel")
    TabLbl.Text       = name
    TabLbl.TextSize   = 12
    TabLbl.Font       = Enum.Font.GothamBold
    TabLbl.TextColor3 = T.TextSec
    TabLbl.BackgroundTransparency = 1
    TabLbl.Size       = UDim2.new(0,0,1,0)
    TabLbl.AutomaticSize = Enum.AutomaticSize.X
    TabLbl.Parent     = TabBtnInner

    -- ---- FLOATING WINDOW ----
    local WinX = startPos and startPos.X or (80 + (idx-1)*30)
    local WinY = startPos and startPos.Y or (80 + (idx-1)*20)

    local Win = Instance.new("Frame")
    Win.Name             = "Win_"..name
    Win.Size             = UDim2.new(0,280,0,0)
    Win.Position         = UDim2.new(0, WinX, 0, WinY)
    Win.BackgroundColor3 = T.BG
    Win.BorderSizePixel  = 0
    Win.AutomaticSize    = Enum.AutomaticSize.Y
    Win.Visible          = false
    Win.ClipsDescendants = false
    Win.Parent           = ScreenGui
    Corner(Win, 10)
    Stroke(Win, T.Border)

    -- Window header
    local WinHeader = Instance.new("Frame")
    WinHeader.Name             = "Header"
    WinHeader.Size             = UDim2.new(1,0,0,36)
    WinHeader.BackgroundColor3 = T.BGLight
    WinHeader.BorderSizePixel  = 0
    WinHeader.Parent           = Win
    Corner(WinHeader, 10)

    -- Header bottom square corners fix
    local HFix = Instance.new("Frame")
    HFix.Size            = UDim2.new(1,0,0,10)
    HFix.Position        = UDim2.new(0,0,1,-10)
    HFix.BackgroundColor3 = T.BGLight
    HFix.BorderSizePixel = 0
    HFix.Parent          = WinHeader

    -- Accent dot
    local Dot = Instance.new("Frame")
    Dot.Size            = UDim2.new(0,6,0,6)
    Dot.Position        = UDim2.new(0,12,0.5,-3)
    Dot.BackgroundColor3 = accentColor
    Dot.BorderSizePixel = 0
    Dot.Parent          = WinHeader
    Corner(Dot, 4)

    local WinTitle = Instance.new("TextLabel")
    WinTitle.Text       = name
    WinTitle.TextSize   = 12
    WinTitle.Font       = Enum.Font.GothamBold
    WinTitle.TextColor3 = T.TextPri
    WinTitle.BackgroundTransparency = 1
    WinTitle.Size       = UDim2.new(1,-50,1,0)
    WinTitle.Position   = UDim2.new(0,26,0,0)
    WinTitle.TextXAlignment = Enum.TextXAlignment.Left
    WinTitle.Parent     = WinHeader

    -- Close btn
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size             = UDim2.new(0,20,0,20)
    CloseBtn.Position         = UDim2.new(1,-28,0.5,-10)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    CloseBtn.Text             = "✕"
    CloseBtn.TextSize         = 9
    CloseBtn.Font             = Enum.Font.GothamBold
    CloseBtn.TextColor3       = T.TextSec
    CloseBtn.BorderSizePixel  = 0
    CloseBtn.Parent           = WinHeader
    Corner(CloseBtn, 6)

    -- Accent line bottom of header
    local AccentLine = Instance.new("Frame")
    AccentLine.Size            = UDim2.new(1,0,0,1)
    AccentLine.Position        = UDim2.new(0,0,1,0)
    AccentLine.BackgroundColor3 = accentColor
    AccentLine.BorderSizePixel = 0
    AccentLine.BackgroundTransparency = 0.7
    AccentLine.Parent          = WinHeader

    -- Content scroll
    local Content = Instance.new("ScrollingFrame")
    Content.Name                = "Content"
    Content.Size                = UDim2.new(1,0,0,0)
    Content.Position            = UDim2.new(0,0,0,36)
    Content.AutomaticSize       = Enum.AutomaticSize.Y
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel     = 0
    Content.ScrollBarThickness  = 3
    Content.ScrollBarImageColor3 = T.ScrollBar
    Content.CanvasSize          = UDim2.new(0,0,0,0)
    Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Content.ScrollingDirection  = Enum.ScrollingDirection.Y
    Content.Parent              = Win
    Pad(Content, 8,8,8,8)
    List(Content, Enum.FillDirection.Vertical, 8)

    MakeDraggable(Win, WinHeader)

    -- ---- TOGGLE LOGIC ----
    local winVisible = false

    local function ShowWin(v)
        winVisible = v
        if v then
            Win.Visible = true
            Win.Size    = UDim2.new(0,280,0,0)
            Tween(Win, {Size=UDim2.new(0,280,0,0)}, 0) -- reset
            Win.AutomaticSize = Enum.AutomaticSize.Y
            Tween(TabBtn, {BackgroundTransparency=0}, 0.15)
            TabBtn.BackgroundColor3 = T.SurfaceAct
            Tween(TabIco, {TextColor3=accentColor}, 0.15)
            Tween(TabLbl, {TextColor3=T.TextPri},   0.15)
        else
            Tween(Win, {Size=UDim2.new(0,280,0,36)}, 0.2, Enum.EasingStyle.Quart)
            task.delay(0.2, function()
                Win.Visible = false
                Win.AutomaticSize = Enum.AutomaticSize.Y
            end)
            Tween(TabBtn, {BackgroundTransparency=1}, 0.15)
            Tween(TabIco, {TextColor3=T.TextMut},  0.15)
            Tween(TabLbl, {TextColor3=T.TextSec},  0.15)
        end
    end

    TabBtn.MouseButton1Click:Connect(function()
        ShowWin(not winVisible)
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        ShowWin(false)
    end)

    -- Hover on tab btn
    TabBtn.MouseEnter:Connect(function()
        if not winVisible then
            Tween(TabBtn, {BackgroundTransparency=0.7}, 0.1)
            TabBtn.BackgroundColor3 = T.SurfaceHov
        end
    end)
    TabBtn.MouseLeave:Connect(function()
        if not winVisible then
            Tween(TabBtn, {BackgroundTransparency=1}, 0.1)
        end
    end)

    -- Right-click context menu on tab btn
    TabBtn.MouseButton2Click:Connect(function()
        local mp = UserInputService:GetMouseLocation()
        OpenContext(mp, {
            {
                icon   = "◈",
                label  = "Open / Close",
                action = function() ShowWin(not winVisible) end,
            },
            {
                icon   = "⇲",
                label  = "Reset position",
                action = function()
                    Tween(Win, {Position=UDim2.new(0, WinX, 0, WinY)}, 0.3, Enum.EasingStyle.Back)
                end,
            },
            {
                icon   = "◉",
                label  = "Pin to top",
                action = function()
                    Win.Position = UDim2.new(0, Win.AbsolutePosition.X, 0, 50)
                end,
            },
            {
                icon   = "✕",
                label  = "Hide tab",
                color  = Color3.fromRGB(220,80,80),
                action = function()
                    ShowWin(false)
                    Tween(TabBtn, {Size=UDim2.new(0,0,0,26)}, 0.2)
                    task.delay(0.2, function() TabBtn.Visible = false end)
                end,
            },
        })
    end)

    -- Right-click on window header too
    WinHeader.MouseButton2Click = nil
    local WinHeaderBtn = Instance.new("TextButton")
    WinHeaderBtn.Size             = UDim2.new(1,0,1,0)
    WinHeaderBtn.BackgroundTransparency = 1
    WinHeaderBtn.Text             = ""
    WinHeaderBtn.ZIndex           = 0
    WinHeaderBtn.Parent           = WinHeader
    WinHeaderBtn.MouseButton2Click:Connect(function()
        local mp = UserInputService:GetMouseLocation()
        OpenContext(mp, {
            {
                icon   = "⇲",
                label  = "Reset position",
                action = function()
                    Tween(Win, {Position=UDim2.new(0, WinX, 0, WinY)}, 0.3, Enum.EasingStyle.Back)
                end,
            },
            {
                icon   = "◉",
                label  = "Pin to top",
                action = function()
                    Win.Position = UDim2.new(0, Win.AbsolutePosition.X, 0, 50)
                end,
            },
            {
                icon   = "✕",
                label  = "Close",
                color  = Color3.fromRGB(220,80,80),
                action = function() ShowWin(false) end,
            },
        })
    end)

    -- ============================================================
    --  TAB OBJECT API
    -- ============================================================
    local TabObj  = {}
    local ElemOrd = 0

    local function NO()
        ElemOrd = ElemOrd + 1
        return ElemOrd
    end

    -- Section
    function TabObj:AddSection(sName)
        local SF = Instance.new("Frame")
        SF.Name          = "Sec_"..sName
        SF.Size          = UDim2.new(1,0,0,0)
        SF.AutomaticSize = Enum.AutomaticSize.Y
        SF.BackgroundColor3 = T.Surface
        SF.BorderSizePixel  = 0
        SF.LayoutOrder   = NO()
        SF.Parent        = Content
        Corner(SF, 8)
        Stroke(SF, T.Border)

        local SI = Instance.new("Frame")
        SI.Size          = UDim2.new(1,0,0,0)
        SI.AutomaticSize = Enum.AutomaticSize.Y
        SI.BackgroundTransparency = 1
        SI.Parent        = SF
        Pad(SI,10,10,10,10)
        List(SI, Enum.FillDirection.Vertical, 8)

        -- Section label
        local SH = Instance.new("Frame")
        SH.Size          = UDim2.new(1,0,0,20)
        SH.BackgroundTransparency = 1
        SH.LayoutOrder   = 0
        SH.Parent        = SI

        local SBar = Instance.new("Frame")
        SBar.Size            = UDim2.new(0,3,0,12)
        SBar.Position        = UDim2.new(0,0,0.5,-6)
        SBar.BackgroundColor3 = accentColor
        SBar.BorderSizePixel = 0
        SBar.Parent          = SH
        Corner(SBar, 4)

        local SLbl = Label(SH, sName, 10, T.TextSec, Enum.Font.GothamBold)
        SLbl.Size     = UDim2.new(1,-14,1,0)
        SLbl.Position = UDim2.new(0,10,0,0)

        local SDivide = Instance.new("Frame")
        SDivide.Size            = UDim2.new(1,0,0,1)
        SDivide.Position        = UDim2.new(0,0,1,0)
        SDivide.BackgroundColor3 = T.Border
        SDivide.BorderSizePixel = 0
        SDivide.Parent          = SH

        local Sec = {}
        local SO  = 1
        local function SNO() SO=SO+1; return SO end

        -- TOGGLE --
        function Sec:AddToggle(lbl, default, cb)
            local val = default or false
            local EF  = Instance.new("Frame")
            EF.Size   = UDim2.new(1,0,0,30)
            EF.BackgroundTransparency = 1
            EF.LayoutOrder = SNO()
            EF.Parent  = SI

            local L = Label(EF, lbl, 12, T.TextPri, Enum.Font.GothamBold)
            L.Size    = UDim2.new(1,-52,1,0)

            local Track = Instance.new("Frame")
            Track.Size            = UDim2.new(0,40,0,20)
            Track.Position        = UDim2.new(1,-40,0.5,-10)
            Track.BackgroundColor3 = val and T.ToggleOn or T.ToggleOff
            Track.BorderSizePixel = 0
            Track.Parent          = EF
            Corner(Track, 10)

            local Knob = Instance.new("Frame")
            Knob.Size            = UDim2.new(0,14,0,14)
            Knob.Position        = UDim2.new(0, val and 23 or 3, 0.5,-7)
            Knob.BackgroundColor3 = val and T.BG or T.TextPri
            Knob.BorderSizePixel = 0
            Knob.Parent          = Track
            Corner(Knob, 7)

            local function Set(v)
                val = v
                Tween(Track,{BackgroundColor3 = v and T.ToggleOn or T.ToggleOff},0.18)
                Tween(Knob, {Position=UDim2.new(0,v and 23 or 3,0.5,-7),
                             BackgroundColor3 = v and T.BG or T.TextPri},0.18)
                pcall(cb, v)
            end

            local CA = Instance.new("TextButton")
            CA.Size = UDim2.new(1,0,1,0)
            CA.BackgroundTransparency=1; CA.Text=""
            CA.Parent = EF
            CA.MouseButton1Click:Connect(function() Set(not val) end)

            local A={}
            function A:Set(v) Set(v) end
            function A:Get() return val end
            return A
        end

        -- SLIDER --
        function Sec:AddSlider(lbl, min, max, default, cb)
            local val = math.clamp(default or min, min, max)
            local EF  = Instance.new("Frame")
            EF.Size   = UDim2.new(1,0,0,46)
            EF.BackgroundTransparency = 1
            EF.LayoutOrder = SNO()
            EF.Parent  = SI

            local Top = Instance.new("Frame")
            Top.Size  = UDim2.new(1,0,0,18)
            Top.BackgroundTransparency=1
            Top.Parent = EF

            local L = Label(Top, lbl, 12, T.TextPri, Enum.Font.GothamBold)
            L.Size = UDim2.new(1,-44,1,0)

            local VL = Instance.new("TextLabel")
            VL.Text       = tostring(val)
            VL.TextSize   = 11
            VL.Font       = Enum.Font.GothamBold
            VL.TextColor3 = accentColor
            VL.BackgroundTransparency=1
            VL.Size       = UDim2.new(0,40,1,0)
            VL.Position   = UDim2.new(1,-40,0,0)
            VL.TextXAlignment = Enum.TextXAlignment.Right
            VL.Parent     = Top

            local TR = Instance.new("Frame")
            TR.Size            = UDim2.new(1,0,0,4)
            TR.Position        = UDim2.new(0,0,0,28)
            TR.BackgroundColor3 = T.ToggleOff
            TR.BorderSizePixel = 0
            TR.Parent          = EF
            Corner(TR, 4)

            local Fill = Instance.new("Frame")
            Fill.Size            = UDim2.new((val-min)/(max-min),0,1,0)
            Fill.BackgroundColor3 = T.SliderFill
            Fill.BorderSizePixel = 0
            Fill.Parent          = TR
            Corner(Fill, 4)

            local KN = Instance.new("Frame")
            KN.Size            = UDim2.new(0,12,0,12)
            KN.Position        = UDim2.new((val-min)/(max-min),-6,0.5,-6)
            KN.BackgroundColor3 = T.TextPri
            KN.BorderSizePixel = 0
            KN.Parent          = TR
            Corner(KN, 6)
            Stroke(KN, T.BG, 2)

            local drag=false
            TR.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
                    local rx = math.clamp((i.Position.X-TR.AbsolutePosition.X)/TR.AbsoluteSize.X,0,1)
                    val = math.floor(min+(max-min)*rx)
                    VL.Text    = tostring(val)
                    Fill.Size  = UDim2.new(rx,0,1,0)
                    KN.Position= UDim2.new(rx,-6,0.5,-6)
                    pcall(cb, val)
                end
            end)

            local A={}
            function A:Set(v)
                v=math.clamp(v,min,max); val=v
                local rx=(v-min)/(max-min)
                VL.Text=tostring(v)
                Fill.Size=UDim2.new(rx,0,1,0)
                KN.Position=UDim2.new(rx,-6,0.5,-6)
                pcall(cb,v)
            end
            function A:Get() return val end
            return A
        end

        -- BUTTON --
        function Sec:AddButton(lbl, cb, sub)
            local EF = Instance.new("Frame")
            EF.Size  = UDim2.new(1,0,0,32)
            EF.BackgroundTransparency=1
            EF.LayoutOrder=SNO(); EF.Parent=SI

            local Btn = Instance.new("TextButton")
            Btn.Size            = UDim2.new(1,0,1,0)
            Btn.BackgroundColor3 = T.SurfaceHov
            Btn.Text            = ""; Btn.BorderSizePixel=0
            Btn.Parent          = EF
            Corner(Btn,6); Stroke(Btn,T.BorderLight)

            local BL = Instance.new("TextLabel")
            BL.Text       = lbl; BL.TextSize=12
            BL.Font       = Enum.Font.GothamBold
            BL.TextColor3 = T.TextPri
            BL.BackgroundTransparency=1
            BL.Size       = UDim2.new(1,-20,1,0)
            BL.Position   = UDim2.new(0,10,0,0)
            BL.TextXAlignment=Enum.TextXAlignment.Left
            BL.Parent     = Btn

            if sub then
                local SL=Label(Btn,sub,10,T.TextMut,Enum.Font.Gotham,Enum.TextXAlignment.Right)
                SL.Size=UDim2.new(0,70,1,0); SL.Position=UDim2.new(1,-76,0,0)
            end

            Btn.MouseEnter:Connect(function() Tween(Btn,{BackgroundColor3=T.SurfaceAct},0.1) end)
            Btn.MouseLeave:Connect(function() Tween(Btn,{BackgroundColor3=T.SurfaceHov},0.1) end)
            Btn.MouseButton1Down:Connect(function() Tween(Btn,{BackgroundColor3=T.Border},0.06) end)
            Btn.MouseButton1Up:Connect(function()
                Tween(Btn,{BackgroundColor3=T.SurfaceAct},0.1)
                pcall(cb)
            end)
        end

        -- DROPDOWN --
        function Sec:AddDropdown(lbl, opts, default, cb)
            local val  = default or opts[1]
            local open = false

            local EF = Instance.new("Frame")
            EF.Size  = UDim2.new(1,0,0,52)
            EF.BackgroundTransparency=1
            EF.ClipsDescendants=false
            EF.LayoutOrder=SNO(); EF.Parent=SI

            local L=Label(EF, lbl, 12, T.TextPri, Enum.Font.GothamBold)
            L.Size=UDim2.new(1,0,0,18)

            local DB = Instance.new("TextButton")
            DB.Size            = UDim2.new(1,0,0,28)
            DB.Position        = UDim2.new(0,0,0,20)
            DB.BackgroundColor3 = T.SurfaceHov
            DB.Text            = ""; DB.BorderSizePixel=0
            DB.Parent          = EF
            Corner(DB,6); Stroke(DB,T.BorderLight)

            local DL=Label(DB, val, 11, T.TextPri, Enum.Font.Gotham)
            DL.Size=UDim2.new(1,-32,1,0); DL.Position=UDim2.new(0,8,0,0)

            local Arr=Label(DB,"▾",13,T.TextSec,Enum.Font.GothamBold,Enum.TextXAlignment.Right)
            Arr.Size=UDim2.new(0,24,1,0); Arr.Position=UDim2.new(1,-26,0,0)

            -- Dropdown list — в screenGui чтобы не обрезалось
            local DDP = Instance.new("Frame")
            DDP.Size            = UDim2.new(0,0,0,0)
            DDP.BackgroundColor3 = T.BGLight
            DDP.BorderSizePixel = 0
            DDP.Visible         = false
            DDP.ZIndex          = 50
            DDP.ClipsDescendants= true
            DDP.Parent          = ScreenGui
            Corner(DDP,8); Stroke(DDP,T.BorderLight)
            List(DDP, Enum.FillDirection.Vertical, 0)
            Pad(DDP,4,4,0,0)

            local itemH = 26
            local fullH = #opts*itemH+8

            for _, opt in ipairs(opts) do
                local OB = Instance.new("TextButton")
                OB.Size            = UDim2.new(1,0,0,itemH)
                OB.BackgroundColor3 = T.BGLight
                OB.BackgroundTransparency = 1
                OB.Text            = ""; OB.BorderSizePixel=0
                OB.ZIndex          = 51
                OB.Parent          = DDP

                local OL=Label(OB,opt,11,opt==val and accentColor or T.TextPri,Enum.Font.Gotham)
                OL.Size=UDim2.new(1,-16,1,0); OL.Position=UDim2.new(0,8,0,0)
                OL.ZIndex=52

                OB.MouseEnter:Connect(function() Tween(OB,{BackgroundTransparency=0.6},0.1); OB.BackgroundColor3=T.SurfaceHov end)
                OB.MouseLeave:Connect(function() Tween(OB,{BackgroundTransparency=1},0.1) end)
                OB.MouseButton1Click:Connect(function()
                    val=opt; DL.Text=opt
                    open=false
                    Tween(DDP,{Size=UDim2.new(0,DB.AbsoluteSize.X,0,0)},0.15)
                    task.delay(0.15,function() DDP.Visible=false end)
                    Tween(Arr,{Rotation=0},0.18)
                    for _,c in ipairs(DDP:GetChildren()) do
                        if c:IsA("TextButton") then
                            local cl=c:FindFirstChildOfClass("TextLabel")
                            if cl then cl.TextColor3=(cl.Text==opt and accentColor or T.TextPri) end
                        end
                    end
                    pcall(cb, opt)
                end)
            end

            DB.MouseButton1Click:Connect(function()
                open=not open
                local ap = DB.AbsolutePosition
                local as = DB.AbsoluteSize
                DDP.Position = UDim2.new(0, ap.X, 0, ap.Y+as.Y+3)
                DDP.Size     = UDim2.new(0, as.X, 0, 0)
                if open then
                    DDP.Visible=true
                    Tween(DDP,{Size=UDim2.new(0,as.X,0,fullH)},0.2,Enum.EasingStyle.Quart)
                    Tween(Arr,{Rotation=180},0.2)
                else
                    Tween(DDP,{Size=UDim2.new(0,as.X,0,0)},0.15)
                    task.delay(0.15,function() DDP.Visible=false end)
                    Tween(Arr,{Rotation=0},0.18)
                end
            end)

            local A={}
            function A:Set(v) val=v; DL.Text=v; pcall(cb,v) end
            function A:Get() return val end
            return A
        end

        -- TEXTBOX --
        function Sec:AddTextBox(lbl, ph, cb)
            local EF=Instance.new("Frame")
            EF.Size=UDim2.new(1,0,0,52)
            EF.BackgroundTransparency=1
            EF.LayoutOrder=SNO(); EF.Parent=SI

            local L=Label(EF,lbl,12,T.TextPri,Enum.Font.GothamBold)
            L.Size=UDim2.new(1,0,0,18)

            local TF=Instance.new("Frame")
            TF.Size=UDim2.new(1,0,0,28)
            TF.Position=UDim2.new(0,0,0,20)
            TF.BackgroundColor3=T.SurfaceHov
            TF.BorderSizePixel=0; TF.Parent=EF
            Corner(TF,6); local TFStroke=Stroke(TF,T.BorderLight)

            local TB=Instance.new("TextBox")
            TB.Size=UDim2.new(1,-16,1,0); TB.Position=UDim2.new(0,8,0,0)
            TB.BackgroundTransparency=1
            TB.PlaceholderText=ph or "..."
            TB.PlaceholderColor3=T.TextMut
            TB.Text=""; TB.TextSize=11
            TB.Font=Enum.Font.Gotham
            TB.TextColor3=T.TextPri
            TB.TextXAlignment=Enum.TextXAlignment.Left
            TB.ClearTextOnFocus=false; TB.Parent=TF

            TB.Focused:Connect(function()
                Tween(TF,{BackgroundColor3=T.SurfaceAct},0.12)
                TFStroke.Color=accentColor
            end)
            TB.FocusLost:Connect(function(enter)
                Tween(TF,{BackgroundColor3=T.SurfaceHov},0.12)
                TFStroke.Color=T.BorderLight
                if enter then pcall(cb,TB.Text) end
            end)

            local A={}
            function A:Set(v) TB.Text=v end
            function A:Get() return TB.Text end
            return A
        end

        -- KEYBIND --
        function Sec:AddKeybind(lbl, default, cb)
            local key=default or Enum.KeyCode.Unknown
            local binding=false

            local EF=Instance.new("Frame")
            EF.Size=UDim2.new(1,0,0,30)
            EF.BackgroundTransparency=1
            EF.LayoutOrder=SNO(); EF.Parent=SI

            local L=Label(EF,lbl,12,T.TextPri,Enum.Font.GothamBold)
            L.Size=UDim2.new(1,-90,1,0)

            local KB=Instance.new("TextButton")
            KB.Size=UDim2.new(0,76,0,22)
            KB.Position=UDim2.new(1,-76,0.5,-11)
            KB.BackgroundColor3=T.SurfaceHov
            KB.Text=key.Name; KB.TextSize=10
            KB.Font=Enum.Font.GothamBold
            KB.TextColor3=T.TextSec
            KB.BorderSizePixel=0; KB.Parent=EF
            Corner(KB,5); Stroke(KB,T.BorderLight)

            KB.MouseButton1Click:Connect(function()
                if binding then return end
                binding=true
                KB.Text="..."; KB.TextColor3=accentColor
            end)
            UserInputService.InputBegan:Connect(function(i)
                if binding and i.UserInputType==Enum.UserInputType.Keyboard then
                    binding=false; key=i.KeyCode
                    KB.Text=key.Name; KB.TextColor3=T.TextSec
                    pcall(cb,key)
                end
            end)

            local A={}
            function A:Set(k) key=k; KB.Text=k.Name end
            function A:Get() return key end
            return A
        end

        -- COLOR PICKER (fixed — отдельный фрейм в ScreenGui) --
        function Sec:AddColorPicker(lbl, default, cb)
            local color = default or Color3.fromRGB(255,255,255)
            local open  = false
            local h,s,v = Color3.toHSV(color)

            local EF=Instance.new("Frame")
            EF.Size=UDim2.new(1,0,0,30)
            EF.BackgroundTransparency=1
            EF.LayoutOrder=SNO(); EF.Parent=SI

            local L=Label(EF,lbl,12,T.TextPri,Enum.Font.GothamBold)
            L.Size=UDim2.new(1,-50,1,0)

            local PV=Instance.new("TextButton")
            PV.Size=UDim2.new(0,36,0,20)
            PV.Position=UDim2.new(1,-36,0.5,-10)
            PV.BackgroundColor3=color
            PV.Text=""; PV.BorderSizePixel=0; PV.Parent=EF
            Corner(PV,5); Stroke(PV,T.BorderLight)

            -- Panel — в ScreenGui чтобы не обрезалось
            local Panel=Instance.new("Frame")
            Panel.Size=UDim2.new(0,210,0,0)
            Panel.BackgroundColor3=T.BGLight
            Panel.BorderSizePixel=0
            Panel.Visible=false
            Panel.ZIndex=60
            Panel.ClipsDescendants=true
            Panel.Parent=ScreenGui
            Corner(Panel,8); Stroke(Panel,T.BorderLight)

            local PI=Instance.new("Frame")
            PI.Size=UDim2.new(1,0,0,0)
            PI.AutomaticSize=Enum.AutomaticSize.Y
            PI.BackgroundTransparency=1
            PI.ZIndex=61; PI.Parent=Panel
            List(PI,Enum.FillDirection.Vertical,8)
            Pad(PI,10,10,10,10)

            -- Color preview inside panel
            local PanelPreview=Instance.new("Frame")
            PanelPreview.Size=UDim2.new(1,0,0,28)
            PanelPreview.BackgroundColor3=color
            PanelPreview.BorderSizePixel=0
            PanelPreview.ZIndex=62; PanelPreview.Parent=PI
            Corner(PanelPreview,6)

            local HexLabel=Instance.new("TextLabel")
            HexLabel.Size=UDim2.new(1,0,1,0)
            HexLabel.BackgroundTransparency=1
            HexLabel.Text=""
            HexLabel.TextSize=10; HexLabel.Font=Enum.Font.GothamBold
            HexLabel.TextColor3=Color3.fromRGB(255,255,255)
            HexLabel.ZIndex=63; HexLabel.Parent=PanelPreview

            local function UpdateColor()
                local c=Color3.fromHSV(h,s,v)
                color=c; PV.BackgroundColor3=c
                PanelPreview.BackgroundColor3=c
                local r,g,b=math.floor(c.R*255),math.floor(c.G*255),math.floor(c.B*255)
                HexLabel.Text=string.format("#%02X%02X%02X",r,g,b)
                HexLabel.TextColor3=(v>0.5 and Color3.fromRGB(30,30,30) or Color3.fromRGB(220,220,220))
                pcall(cb,c)
            end

            local function AddHSVSlider(slbl, getVal, setVal, gradC0, gradC1)
                local row=Instance.new("Frame")
                row.Size=UDim2.new(1,0,0,32); row.BackgroundTransparency=1
                row.ZIndex=62; row.Parent=PI

                local RL=Label(row,slbl,9,T.TextSec,Enum.Font.GothamBold)
                RL.Size=UDim2.new(0,10,0,14); RL.Position=UDim2.new(0,0,0,0)
                RL.ZIndex=63

                local TR=Instance.new("Frame")
                TR.Size=UDim2.new(1,-36,0,6)
                TR.Position=UDim2.new(0,16,0,4)
                TR.BackgroundColor3=T.ToggleOff
                TR.BorderSizePixel=0; TR.ZIndex=63; TR.Parent=row
                Corner(TR,4)

                local TRGrad=Instance.new("UIGradient")
                TRGrad.Color=ColorSequence.new(gradC0,gradC1)
                TRGrad.Parent=TR

                local KN=Instance.new("Frame")
                KN.Size=UDim2.new(0,10,0,10)
                KN.Position=UDim2.new(getVal(),-5,0.5,-5)
                KN.BackgroundColor3=Color3.fromRGB(255,255,255)
                KN.BorderSizePixel=0; KN.ZIndex=64; KN.Parent=TR
                Corner(KN,5); Stroke(KN,Color3.fromRGB(0,0,0),1)

                local VL=Label(row,tostring(math.floor(getVal()*100)),9,T.TextSec,Enum.Font.Gotham,Enum.TextXAlignment.Right)
                VL.Size=UDim2.new(0,18,0,14); VL.Position=UDim2.new(1,-18,0,0)
                VL.ZIndex=63

                local dragging=false
                TR.InputBegan:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
                        local rx=math.clamp((i.Position.X-TR.AbsolutePosition.X)/TR.AbsoluteSize.X,0,1)
                        setVal(rx)
                        KN.Position=UDim2.new(rx,-5,0.5,-5)
                        VL.Text=tostring(math.floor(rx*100))
                        UpdateColor()
                    end
                end)
            end

            AddHSVSlider("H",
                function() return h end,
                function(v2) h=v2 end,
                Color3.fromRGB(255,0,0),
                Color3.fromRGB(255,0,255)
            )
            AddHSVSlider("S",
                function() return s end,
                function(v2) s=v2 end,
                Color3.fromRGB(200,200,200),
                accentColor
            )
            AddHSVSlider("V",
                function() return v end,
                function(v2) v=v2 end,
                Color3.fromRGB(0,0,0),
                Color3.fromRGB(255,255,255)
            )

            -- Открываем/закрываем
            local panelOpen=false
            PV.MouseButton1Click:Connect(function()
                panelOpen=not panelOpen
                if panelOpen then
                    local ap=PV.AbsolutePosition
                    local as=PV.AbsoluteSize
                    Panel.Position=UDim2.new(0,ap.X-170,0,ap.Y+as.Y+4)
                    Panel.Size=UDim2.new(0,210,0,0)
                    Panel.Visible=true
                    Tween(Panel,{Size=UDim2.new(0,210,0,160)},0.22,Enum.EasingStyle.Quart)
                else
                    Tween(Panel,{Size=UDim2.new(0,210,0,0)},0.15)
                    task.delay(0.15,function() Panel.Visible=false end)
                end
            end)

            -- Close on click outside
            UserInputService.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 and panelOpen then
                    local mp=UserInputService:GetMouseLocation()
                    local pp=Panel.AbsolutePosition
                    local ps=Panel.AbsoluteSize
                    if not(mp.X>=pp.X and mp.X<=pp.X+ps.X and mp.Y>=pp.Y and mp.Y<=pp.Y+ps.Y) then
                        panelOpen=false
                        Tween(Panel,{Size=UDim2.new(0,210,0,0)},0.15)
                        task.delay(0.15,function() Panel.Visible=false end)
                    end
                end
            end)

            local A={}
            function A:Set(c) color=c; PV.BackgroundColor3=c; PanelPreview.BackgroundColor3=c; pcall(cb,c) end
            function A:Get() return color end
            return A
        end

        -- LABEL / SEPARATOR --
        function Sec:AddLabel(txt)
            local L=Label(SI,txt,11,T.TextSec,Enum.Font.Gotham)
            L.Size=UDim2.new(1,0,0,16); L.LayoutOrder=SNO()
            L.TextWrapped=true; L.AutomaticSize=Enum.AutomaticSize.Y
            return L
        end

        function Sec:AddSeparator()
            local S=Instance.new("Frame")
            S.Size=UDim2.new(1,0,0,1)
            S.BackgroundColor3=T.Border
            S.BorderSizePixel=0; S.LayoutOrder=SNO()
            S.Parent=SI
        end

        return Sec
    end -- AddSection

    -- Show on create
    ShowWin(true)

    table.insert(AllTabs, {obj=TabObj, show=ShowWin, win=Win})
    return TabObj
end

-- ========================================
--  GLOBAL HIDE (RightShift)
-- ========================================
local allVisible=true
UserInputService.InputBegan:Connect(function(inp,gpe)
    if gpe then return end
    if inp.KeyCode==Enum.KeyCode.RightShift then
        allVisible=not allVisible
        for _,t in ipairs(AllTabs) do
            t.show(allVisible)
        end
        TabBar.Visible=allVisible
    end
end)

-- ========================================
--  PHORMA WARE — RETURN LIBRARY
-- ========================================
local PhormaLib = {}
PhormaLib.CreateTab  = CreateFloatingTab
PhormaLib.Notify     = Notify
PhormaLib.ScreenGui  = ScreenGui

-- ========================================
--  EXAMPLE USAGE
-- ========================================

-- TAB: RAGE
local Rage = CreateFloatingTab("Rage", "⚔", Color3.fromRGB(255,100,100), {X=60,Y=80})
local RS = Rage:AddSection("Aimbot")
RS:AddToggle("Enable", false, function(v) end)
RS:AddSlider("Smoothness", 1, 100, 25, function(v) end)
RS:AddSlider("FOV", 10, 500, 120, function(v) end)
RS:AddDropdown("Target", {"Head","Torso","HumanoidRootPart"}, "Head", function(v) end)
RS:AddKeybind("Hold Key", Enum.KeyCode.Q, function(k) end)
local RS2 = Rage:AddSection("Triggerbot")
RS2:AddToggle("Enable", false, function(v) end)
RS2:AddSlider("Delay (ms)", 0, 500, 80, function(v) end)

-- TAB: LEGIT
local Legit = CreateFloatingTab("Legit", "◎", Color3.fromRGB(120,200,255), {X=360,Y=80})
local LS = Legit:AddSection("Silent Aim")
LS:AddToggle("Enable", false, function(v) end)
LS:AddSlider("Accuracy %", 1, 100, 75, function(v) end)
LS:AddDropdown("Priority", {"Closest","Random","Lowest HP"}, "Closest", function(v) end)
local LS2 = Legit:AddSection("Anti Recoil")
LS2:AddToggle("Enable", false, function(v) end)
LS2:AddSlider("Strength", 0, 100, 50, function(v) end)

-- TAB: VISUALS
local Visuals = CreateFloatingTab("Visuals", "👁", Color3.fromRGB(180,255,180), {X=60,Y=380})
local VS = Visuals:AddSection("ESP")
VS:AddToggle("Box ESP", true, function(v) end)
VS:AddToggle("Name ESP", true, function(v) end)
VS:AddToggle("Health Bar", false, function(v) end)
VS:AddColorPicker("ESP Color", Color3.fromRGB(255,255,255), function(c) end)
VS:AddSlider("Distance", 100, 2000, 600, function(v) end)
local VS2 = Visuals:AddSection("World")
VS2:AddToggle("No Fog", false, function(v)
    if v then game.Lighting.FogEnd=1e9 else game.Lighting.FogEnd=100000 end
end)
VS2:AddSlider("Time of Day", 0, 24, 14, function(v)
    game.Lighting.TimeOfDay = v..":00:00"
end)
VS2:AddColorPicker("Ambient", Color3.fromRGB(100,100,100), function(c)
    game.Lighting.Ambient = c
end)
VS2:AddToggle("Full Bright", false, function(v)
    game.Lighting.Brightness = v and 2 or 1
end)

-- TAB: MISC
local Misc = CreateFloatingTab("Misc", "◈", Color3.fromRGB(220,180,255), {X=360,Y=380})
local MS = Misc:AddSection("Movement")
MS:AddSlider("Walk Speed", 16, 300, 16, function(v)
    local chr = LocalPlayer.Character
    if chr then local h=chr:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed=v end end
end)
MS:AddSlider("Jump Power", 50, 500, 50, function(v)
    local chr = LocalPlayer.Character
    if chr then local h=chr:FindFirstChildOfClass("Humanoid"); if h then h.JumpPower=v end end
end)
MS:AddToggle("No Clip", false, function(v) end)
local MS2 = Misc:AddSection("Utilities")
MS2:AddButton("Anti AFK", function()
    local VU=game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VU:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        VU:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
    Notify("Anti AFK","Activated!",3)
end)
MS2:AddButton("Copy Job ID", function()
    pcall(function() setclipboard(game.JobId) end)
    Notify("Copied","Job ID copied to clipboard",3)
end)
MS2:AddTextBox("Teleport to", "Player name...", function(name)
    local t=game.Players:FindFirstChild(name)
    if t and t.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame=t.Character.HumanoidRootPart.CFrame+Vector3.new(3,0,0)
        Notify("Teleported","→ "..name,3)
    else
        Notify("Error","Player not found",3)
    end
end)

-- Startup notif
task.delay(0.8, function()
    Notify("phorma ware v2", "Loaded · RightShift to hide", 4)
end)

return PhormaLib
