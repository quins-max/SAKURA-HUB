local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local HttpService = game:GetService("HttpService")
local StatsService = game:GetService("Stats")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

_G.BETA_TOP_GUI_ZINDEX = 2147483647

function _G.BETA_FORCE_GUI_ON_TOP(gui)
if not gui then return end
pcall(function()

gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

end)

pcall(function()

gui.DisplayOrder = _G.BETA_TOP_GUI_ZINDEX

end)

for _, obj in ipairs(gui:GetDescendants()) do

if obj:IsA("GuiObject") then

pcall(function()

obj.ZIndex = _G.BETA_TOP_GUI_ZINDEX

end)

end

end

gui.DescendantAdded:Connect(function(obj)

if obj:IsA("GuiObject") then

pcall(function()

obj.ZIndex = _G.BETA_TOP_GUI_ZINDEX

end)

end

end)

end

local BETA_SCRIPT_VERSION = "preciseware-free-topbar-logo-v2"

if _G.BETA_GUI_RUNNING and PlayerGui:FindFirstChild("BETA_GUI") and _G.BETA_GUI_VERSION == BETA_SCRIPT_VERSION then

local existing = PlayerGui:FindFirstChild("BETA_GUI")

_G.BETA_FORCE_GUI_ON_TOP(existing)

existing.Enabled = true

local existingMain = existing:FindFirstChild("Main", true)

if existingMain then

existingMain.Visible = true

end

return

end

if _G.BETA_KILL_CURRENT then

pcall(function()

_G.BETA_KILL_CURRENT()

end)

end

_G.BETA_GUI_RUNNING = true

_G.BETA_GUI_VERSION = BETA_SCRIPT_VERSION

local DEFAULTS = {

FOV_Radius = 100,

FOV_Visible = false,

FOV_Enabled = false,

FOV_Style = "Circle",

CL_Smoothness = 1,

LockPart = "HumanoidRootPart",

Camlock_WallCheck = false,

Camlock_TeamCheck = false,

Camlock_VisibleCheck = false,

Camlock_DeathCheck = false,

AutoUnlockDeath = false,

AutoUnlockDistance = 2000,

WalkSpeed = 16,

WalkSpeedBoost = false,

JumpHeight = 50,

Fly = false,

FlySpeed = 50,

FlyMethod = "CFrame",

OrbitRadius = 8,

OrbitSpeed = 4,

ReturnDeathDelay = 0.4,

SwimAnywhere = false,

PhaseDash = false,

PhaseDistance = 32,

TeleportClick = false,

GravityModifier = false,

GravityValue = 90,

SuspiciousAimSensitivity = 90,

SuspiciousAimTime = 8,

ESP_Enabled = false,

ESP_Tracers_Enabled = false,

ESP_Names_Enabled = false,

ESP_Distance_Enabled = false,

ESP_DistanceLimit = 1000,

ESP_ColorPreset = "Gold",

ESP_EnemyColorPreset = "Red",

ESP_FriendColorPreset = "Blue",

ESP_TracerColorPreset = "Gold",

ESP_Box_Enabled = false,

ESP_BoxThickness = 1,

ESP_Skeleton_Enabled = false,

ESP_TeamCheck = false,

ESP_FriendColor = false,

ESP_EnemyColor = false,

ESP_Rainbow = false,

ESP_OffscreenArrows = false,

ESP_LockedOnly = false,

ESP_HideWhenGuiHidden = false,

ESP_ToolName = false,

ESP_HealthBar = false,

TracerOrigin = "Bottom",

TracerThickness = 1,

TracerTransparency = 0,

WorldMouseDot = false,

CrosshairEnabled = false,

CrosshairSize = 16,

CrosshairGap = 5,

CrosshairDot = false,

CrosshairColorPreset = "Gold",

LowHPAlertEnabled = false,

LowHPThreshold = 35,

DamageFlash = false,

HitMarkerEffect = false,

HitMarkerSound = false,

ChamsOverlay = false,

AmmoCounter = false,

KillFeed = false,

DamageIndicators = false,

HitChams = false,

VelocityMeter = false,

ThemeName = "Dark Gold",

GUI_Scale = 100,

UI_Opacity = 0,

RoundedCorners = false,

FontName = "Code",

Notifications = false,

NotificationPosition = "TopRight",

UISounds = false,

UIBlur = false,

RGBRainbowMode = false,

GuiLockPosition = false,

AutoOpenLastTab = false,

LastTab = "Combat",

MiniMode = false,

Watermark = false,

WatchColorPreset = "Purple",

ReplayTrail = false,

}

local CONFIG_FILE = "BetaGuiConfig.txt"

for key, value in pairs(DEFAULTS) do

_G[key] = value

end

_G.BETA_KILLED = false

_G.CL_T = nil

_G.OrbitTarget = nil

_G.OrbitAngle = 0

_G.ReturnDeathCFrame = nil

_G.SavedPosition = nil

_G.WatchList = {}

_G.EvidenceLog = {}

local FreecamState = {

Enabled = false,

Connections = {},

Keys = {},

RightMouse = false,

Pitch = 0,

Yaw = 0,

Speed = 1.4,

SavedCameraType = nil,

SavedCameraSubject = nil,

SavedCameraCFrame = nil,

Controls = nil,

SavedWalkSpeed = nil,

SavedJumpPower = nil,

SavedJumpHeight = nil,

SavedAutoRotate = nil

}

local ViewState = {

Enabled = false,

All = false,

Connection = nil,

SavedCameraType = nil,

SavedCameraSubject = nil,

Index = 1,

LastSwitch = 0

}

local HitboxState = {

Folder = nil,

Targets = {}

}

local XrayState = {

Enabled = false,

Saved = {},

Connection = nil

}

local ClickKillState = {

Enabled = false,

Connection = nil

}

local GodmodeState = {

Enabled = false,

Connection = nil,

ForceField = nil,

OldMaxHealth = nil,

OldHealth = nil

}

local OriginalLighting = {

Brightness = Lighting.Brightness,

Ambient = Lighting.Ambient,

GlobalShadows = Lighting.GlobalShadows,

ClockTime = Lighting.ClockTime,

OutdoorAmbient = Lighting.OutdoorAmbient,

FogColor = Lighting.FogColor,

FogStart = Lighting.FogStart,

FogEnd = Lighting.FogEnd

}

local Themes = {

["Dark Gold"] = {

M = Color3.fromRGB(9,9,8), T = Color3.fromRGB(13,12,10), S = Color3.fromRGB(12,12,10),

V = Color3.fromRGB(8,8,7), P = Color3.fromRGB(18,17,14), P2 = Color3.fromRGB(24,23,19),

CARD = Color3.fromRGB(15,15,13), TX = Color3.fromRGB(230,224,205), SUB = Color3.fromRGB(160,148,110),

A2 = Color3.fromRGB(61,51,27), W = Color3.fromRGB(245,209,92), TR = Color3.fromRGB(31,29,24),

FL = Color3.fromRGB(235,198,82), KN = Color3.fromRGB(255,230,133), RED = Color3.fromRGB(145,47,55),

RED2 = Color3.fromRGB(89,31,35)

},

["Red"] = {

M = Color3.fromRGB(10,7,7), T = Color3.fromRGB(16,9,9), S = Color3.fromRGB(15,8,8),

V = Color3.fromRGB(9,6,6), P = Color3.fromRGB(22,12,12), P2 = Color3.fromRGB(31,16,16),

CARD = Color3.fromRGB(18,10,10), TX = Color3.fromRGB(242,220,220), SUB = Color3.fromRGB(178,124,124),

A2 = Color3.fromRGB(70,25,25), W = Color3.fromRGB(255,75,75), TR = Color3.fromRGB(38,20,20),

FL = Color3.fromRGB(240,55,55), KN = Color3.fromRGB(255,115,115), RED = Color3.fromRGB(170,40,40),

RED2 = Color3.fromRGB(95,25,25)

},

["Purple"] = {

M = Color3.fromRGB(8,7,12), T = Color3.fromRGB(13,10,19), S = Color3.fromRGB(12,9,17),

V = Color3.fromRGB(7,6,11), P = Color3.fromRGB(18,14,25), P2 = Color3.fromRGB(27,20,38),

CARD = Color3.fromRGB(15,12,22), TX = Color3.fromRGB(232,224,245), SUB = Color3.fromRGB(155,130,180),

A2 = Color3.fromRGB(53,35,78), W = Color3.fromRGB(185,112,255), TR = Color3.fromRGB(30,24,42),

FL = Color3.fromRGB(165,85,245), KN = Color3.fromRGB(215,160,255), RED = Color3.fromRGB(145,47,90),

RED2 = Color3.fromRGB(90,28,55)

},

["Blue"] = {

M = Color3.fromRGB(6,8,12), T = Color3.fromRGB(8,13,20), S = Color3.fromRGB(7,12,18),

V = Color3.fromRGB(5,8,13), P = Color3.fromRGB(11,17,26), P2 = Color3.fromRGB(14,25,39),

CARD = Color3.fromRGB(9,15,24), TX = Color3.fromRGB(220,232,245), SUB = Color3.fromRGB(120,150,180),

A2 = Color3.fromRGB(25,48,78), W = Color3.fromRGB(80,170,255), TR = Color3.fromRGB(18,29,43),

FL = Color3.fromRGB(65,145,230), KN = Color3.fromRGB(140,205,255), RED = Color3.fromRGB(145,47,55),

RED2 = Color3.fromRGB(89,31,35)

}

}

local ColorPresets = {

Red = Color3.fromRGB(255,55,55),

Gold = Color3.fromRGB(245,209,92),

Blue = Color3.fromRGB(80,170,255),

Purple = Color3.fromRGB(185,112,255),

Green = Color3.fromRGB(80,255,130),

White = Color3.fromRGB(240,240,240)

}

local Fonts = {

Code = Enum.Font.Code,

Gotham = Enum.Font.Gotham,

SourceSans = Enum.Font.SourceSans,

Arcade = Enum.Font.Arcade

}

local C = Themes[_G.ThemeName] or Themes["Dark Gold"]

local SelectedTab = "Combat"

local PanicKey = Enum.KeyCode.RightControl

local SavedPositions = {}

local LastHealth = nil

local LastDamageSnapshot = "No damage recorded."

local DeathSnapshot = "No death recorded."

local EvidenceText = ""

local LastCommandText = nil

local LastCommandTime = 0

local CommandLogs = {}

local CommandLogsGui = nil

local CommandLogCounter = 0

local LastTeleportCFrame = nil

local CustomLocations = {}

local OriginalWorkspaceGravity = workspace.Gravity

local PlayerHealthCache = {}

local KillFeedLines = {}

local LastRainbowTick = 0

local Root, Main, MiniBar, MainScale, NotifHolder, FOVFrame, FOVCorner, FOVCross, Crosshair, LowHPOverlay, HitMarker, WatermarkLabel, KillFeedFrame, AmmoCounterLabel, ViewFrame, SideButtons

local CrossParts = {}

local WorldMouseDotPart, BlurEffect, UIBeep

local TargetInfoLabel, TargetInfoOverlay, CharacterInfoLabel, VelocityLabel, SavedPositionLabel, KeybindLabel, SuspiciousAimLabel, WatchInfoLabel, EvidenceLabel, DamageSnapshotLabel, DeathSnapshotLabel, SearchBox

local Connections, SliderConnections, ThemeObjects, TextObjects, CornerObjects, Cards = {}, {}, {}, {}, {}, {}

local Toggles, Sliders, Cycles, Binds, Rows = {}, {}, {}, {}, {}

local Pages, TabButtons, TabBars, TabTexts = {}, {}, {}, {}

local CurrentWait = nil

local Handlers = {}

local function addConn(c)

table.insert(Connections, c)

return c

end

local function disconnect(c)

if c then pcall(function() c:Disconnect() end) end

end

local function disconnectAll(list)

for _, c in ipairs(list) do disconnect(c) end

table.clear(list)

end

local function getFont()

return Fonts[_G.FontName] or Enum.Font.Code

end

local function getColor(name)

return ColorPresets[name] or ColorPresets.Gold

end

local function rainbow()

return Color3.fromHSV((os.clock() * 0.18) % 1, 0.95, 1)

end

local function isAlive(char)

return char and char.Parent and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") and char.Humanoid.Health > 0

end

local function isKnocked(char)

if not char then return false end

local hum = char:FindFirstChild("Humanoid")

if hum and hum.Health <= 0 then return true end

local body = char:FindFirstChild("BodyEffects")

if body then

for _, n in ipairs({"K.O", "KO", "Knocked", "Dead"}) do

local v = body:FindFirstChild(n)

if v and v:IsA("BoolValue") and v.Value then return true end

end

end

local knocked = char:FindFirstChild("K.O") or char:FindFirstChild("KO") or char:FindFirstChild("Knocked")

if knocked and knocked:IsA("BoolValue") and knocked.Value then return true end

return false

end

local function getPart(char, preferred)

if not char then return nil end

if preferred and char:FindFirstChild(preferred) then return char[preferred] end

return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")

end

local function equippedToolName(char)

local tool = char and char:FindFirstChildOfClass("Tool")

return tool and tool.Name or "None"

end

local function getPing()

local ok, result = pcall(function()

return StatsService.Network.ServerStatsItem["Data Ping"]:GetValueString()

end)

return ok and result or "N/A"

end

local function softBorderColor()

return C.A2:Lerp(C.M, 0.55)

end

local function stroke(obj, color, thickness)

local s = Instance.new("UIStroke")

s.Color = color or softBorderColor()

s.Thickness = thickness or 1

s.Transparency = 0.35

s.Parent = obj

return s

end

local function corner(obj, radius)

local c = Instance.new("UICorner")

c.CornerRadius = UDim.new(0, radius or 6)

c.Parent = obj

table.insert(CornerObjects, c)

return c

end

local function themeObj(obj, role)

table.insert(ThemeObjects, {Object = obj, Role = role})

return obj

end

local function textObj(obj)

table.insert(TextObjects, obj)

return obj

end

local function applyOpacity(obj)

if obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("TextLabel") or obj:IsA("TextBox") then

if obj.BackgroundTransparency < 1 then

obj.BackgroundTransparency = math.clamp((_G.UI_Opacity or 0) / 100, 0, 0.85)

end

end

end

local function applyThemeOne(obj, role)

if not obj or not obj.Parent then return end

if role == "Main" then obj.BackgroundColor3 = C.M

elseif role == "Top" then obj.BackgroundColor3 = C.T

elseif role == "Side" then obj.BackgroundColor3 = C.S

elseif role == "View" then obj.BackgroundColor3 = C.V

elseif role == "Card" then obj.BackgroundColor3 = C.CARD

elseif role == "Button" then obj.BackgroundColor3 = C.P2

elseif role == "Button2" then obj.BackgroundColor3 = C.P

elseif role == "Accent" then obj.BackgroundColor3 = C.W

elseif role == "Track" then obj.BackgroundColor3 = C.TR

elseif role == "Fill" then obj.BackgroundColor3 = C.FL

elseif role == "Knob" then obj.BackgroundColor3 = C.KN

elseif role == "Text" then obj.TextColor3 = C.TX

elseif role == "SubText" then obj.TextColor3 = C.SUB

elseif role == "AccentText" then obj.TextColor3 = C.W

end

local s = obj:FindFirstChildOfClass("UIStroke")

if s then

if role == "Accent" or role == "Knob" then

s.Color = C.W

s.Transparency = 0.15

elseif role == "Main" then

s.Color = Color3.fromRGB(0, 0, 0)

s.Transparency = 0

elseif role == "Card" or role == "Button" or role == "Button2" or role == "Track" or role == "Top" or role == "Side" or role == "View" then

s.Color = softBorderColor()

s.Transparency = 0.38

else

s.Color = softBorderColor()

s.Transparency = 0.55

end

end

applyOpacity(obj)

end

local function refreshTheme()

C = Themes[_G.ThemeName] or Themes["Dark Gold"]

for _, item in ipairs(ThemeObjects) do

pcall(function() applyThemeOne(item.Object, item.Role) end)

end

for _, t in ipairs(TextObjects) do

if t and t.Parent then t.Font = getFont() end

end

for _, cr in ipairs(CornerObjects) do

if cr and cr.Parent then

cr.CornerRadius = _G.RoundedCorners and UDim.new(0, 8) or UDim.new(0, 0)

end

end

if FOVFrame then

local s = FOVFrame:FindFirstChildOfClass("UIStroke")

if s then s.Color = C.W end

end

if FOVCross then

for _, f in ipairs(FOVCross:GetChildren()) do

if f:IsA("Frame") then f.BackgroundColor3 = C.W end

end

end

for name, btn in pairs(TabButtons) do

local active = name == SelectedTab

btn.BackgroundColor3 = active and C.A2 or C.P

TabBars[name].BackgroundColor3 = active and C.W or C.A2

TabTexts[name].TextColor3 = active and C.W or C.TX

end

end

local function playUISound()

return

end

local function setNotifPosition()

if not NotifHolder then return end

local p = _G.NotificationPosition

if p == "BottomRight" then

NotifHolder.Position = UDim2.new(1, -250, 1, -320)

elseif p == "TopLeft" then

NotifHolder.Position = UDim2.new(0, 10, 0, 16)

elseif p == "BottomLeft" then

NotifHolder.Position = UDim2.new(0, 10, 1, -320)

else

NotifHolder.Position = UDim2.new(1, -250, 0, 16)

end

end

local notify

local function commandAgeText(t)

local diff = math.max(0, os.time() - (t or os.time()))

if diff < 60 then

return tostring(diff) .. " seconds ago"

elseif diff < 3600 then

return tostring(math.floor(diff / 60)) .. " minutes ago"

end

return tostring(math.floor(diff / 3600)) .. " hours ago"

end

local function pushCommandLog(commandText)

CommandLogCounter += 1

table.insert(CommandLogs, 1, {

User = LocalPlayer.Name,

Command = commandText,

Time = os.time(),

Order = CommandLogCounter

})

while #CommandLogs > 250 do

table.remove(CommandLogs)

end

end

local function closeCommandLogsGui()

if CommandLogsGui then

CommandLogsGui:Destroy()

CommandLogsGui = nil

end

end

local function openCommandLogsGui()

if not Root then return end

closeCommandLogsGui()

local holder = Instance.new("Frame")

holder.Name = "BETA_CommandLogs"

holder.Size = UDim2.new(0, 580, 0, 335)

holder.Position = UDim2.new(0.5, -290, 0.5, -70)

holder.BackgroundColor3 = Color3.fromRGB(23, 30, 31)

holder.BackgroundTransparency = 1

holder.BorderSizePixel = 0

holder.ZIndex = 9000

holder.Parent = Root

CommandLogsGui = holder

local scale = Instance.new("UIScale")

scale.Scale = 0.92

scale.Parent = holder

local outline = Instance.new("UIStroke")

outline.Color = Color3.fromRGB(155, 190, 190)

outline.Thickness = 1

outline.Transparency = 0.25

outline.Parent = holder

local titleBar = Instance.new("Frame")

titleBar.Size = UDim2.new(1, 0, 0, 22)

titleBar.BackgroundColor3 = Color3.fromRGB(42, 61, 63)

titleBar.BorderSizePixel = 0

titleBar.ZIndex = 9001

titleBar.Parent = holder

local title = Instance.new("TextLabel")

title.Size = UDim2.new(1, -28, 1, 0)

title.Position = UDim2.new(0, 6, 0, 0)

title.BackgroundTransparency = 1

title.Text = "COMMAND LOGS"

title.Font = Enum.Font.SourceSansBold

title.TextSize = 14

title.TextColor3 = Color3.fromRGB(245, 245, 245)

title.TextXAlignment = Enum.TextXAlignment.Left

title.ZIndex = 9002

title.Parent = titleBar

local close = Instance.new("TextButton")

close.Size = UDim2.new(0, 22, 1, 0)

close.Position = UDim2.new(1, -22, 0, 0)

close.BackgroundTransparency = 1

close.Text = "X"

close.Font = Enum.Font.SourceSansBold

close.TextSize = 16

close.TextColor3 = Color3.fromRGB(255, 0, 0)

close.ZIndex = 9002

close.Parent = titleBar

close.MouseButton1Click:Connect(closeCommandLogsGui)

local search = Instance.new("TextBox")

search.Size = UDim2.new(1, -12, 0, 18)

search.Position = UDim2.new(0, 6, 0, 23)

search.BackgroundColor3 = Color3.fromRGB(16, 21, 22)

search.BorderSizePixel = 0

search.PlaceholderText = "Search"

search.Text = ""

search.Font = Enum.Font.SourceSansItalic

search.TextSize = 13

search.TextColor3 = Color3.fromRGB(240, 240, 240)

search.PlaceholderColor3 = Color3.fromRGB(220, 220, 220)

search.TextXAlignment = Enum.TextXAlignment.Left

search.ZIndex = 9001

search.Parent = holder

local header = Instance.new("Frame")

header.Size = UDim2.new(1, -12, 0, 24)

header.Position = UDim2.new(0, 6, 0, 43)

header.BackgroundColor3 = Color3.fromRGB(62, 82, 84)

header.BorderSizePixel = 0

header.ZIndex = 9001

header.Parent = holder

local function headerCell(txt, x, w)

local cell = Instance.new("TextLabel")

cell.Size = UDim2.new(w, 0, 1, 0)

cell.Position = UDim2.new(x, 0, 0, 0)

cell.BackgroundTransparency = 1

cell.Text = txt

cell.Font = Enum.Font.SourceSansBold

cell.TextSize = 14

cell.TextColor3 = Color3.fromRGB(225, 225, 225)

cell.TextXAlignment = Enum.TextXAlignment.Left

cell.ZIndex = 9002

cell.Parent = header

end

headerCell("USER", 0.00, 0.28)

headerCell("COMMAND", 0.28, 0.45)

headerCell("WHEN", 0.73, 0.27)

local list = Instance.new("ScrollingFrame")

list.Size = UDim2.new(1, -12, 1, -105)

list.Position = UDim2.new(0, 6, 0, 69)

list.BackgroundColor3 = Color3.fromRGB(12, 12, 12)

list.BorderSizePixel = 0

list.CanvasSize = UDim2.new(0, 0, 0, 0)

list.AutomaticCanvasSize = Enum.AutomaticSize.Y

list.ScrollBarThickness = 6

list.ScrollBarImageColor3 = Color3.fromRGB(190, 190, 190)

list.ZIndex = 9001

list.Parent = holder

local listLayout = Instance.new("UIListLayout")

listLayout.SortOrder = Enum.SortOrder.LayoutOrder

listLayout.Padding = UDim.new(0, 3)

listLayout.Parent = list

local bottom = Instance.new("Frame")

bottom.Size = UDim2.new(1, -12, 0, 30)

bottom.Position = UDim2.new(0, 6, 1, -32)

bottom.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

bottom.BorderSizePixel = 0

bottom.ZIndex = 9001

bottom.Parent = holder

local pageText = Instance.new("TextLabel")

pageText.Size = UDim2.new(0, 110, 1, 0)

pageText.Position = UDim2.new(0.5, -55, 0, 0)

pageText.BackgroundTransparency = 1

pageText.Text = "1 / 1"

pageText.Font = Enum.Font.SourceSansBold

pageText.TextSize = 14

pageText.TextColor3 = Color3.fromRGB(245, 245, 245)

pageText.ZIndex = 9002

pageText.Parent = bottom

local refresh = Instance.new("TextButton")

refresh.Size = UDim2.new(0, 70, 0, 25)

refresh.Position = UDim2.new(1, -75, 0, 3)

refresh.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

refresh.BorderSizePixel = 0

refresh.Text = "Refresh"

refresh.Font = Enum.Font.SourceSans

refresh.TextSize = 13

refresh.TextColor3 = Color3.fromRGB(245, 245, 245)

refresh.ZIndex = 9002

refresh.Parent = bottom

local page = 1

local perPage = 10

local function clearRows()

for _, child in ipairs(list:GetChildren()) do

if child:IsA("Frame") then

child:Destroy()

end

end

end

local function render()

clearRows()

local q = string.lower(search.Text or "")

local filtered = {}

for _, entry in ipairs(CommandLogs) do

local searchable = string.lower((entry.User or "") .. " " .. (entry.Command or "") .. " " .. commandAgeText(entry.Time))

if q == "" or string.find(searchable, q, 1, true) then

table.insert(filtered, entry)

end

end

local pages = math.max(1, math.ceil(#filtered / perPage))

page = math.clamp(page, 1, pages)

pageText.Text = tostring(page) .. " / " .. tostring(pages)

local first = (page - 1) * perPage + 1

local last = math.min(first + perPage - 1, #filtered)

for i = first, last do

local entry = filtered[i]

local row = Instance.new("Frame")

row.Size = UDim2.new(1, -2, 0, 21)

row.BackgroundColor3 = (i % 2 == 0) and Color3.fromRGB(31, 31, 31) or Color3.fromRGB(18, 18, 18)

row.BorderSizePixel = 0

row.LayoutOrder = i

row.ZIndex = 9002

row.Parent = list

local function cell(txt, x, w, bold)

local c = Instance.new("TextLabel")

c.Size = UDim2.new(w, -4, 1, 0)

c.Position = UDim2.new(x, 4, 0, 0)

c.BackgroundTransparency = 1

c.Text = txt

c.Font = bold and Enum.Font.SourceSansBold or Enum.Font.SourceSans

c.TextSize = 14

c.TextColor3 = Color3.fromRGB(245, 245, 245)

c.TextXAlignment = Enum.TextXAlignment.Left

c.TextTruncate = Enum.TextTruncate.AtEnd

c.ZIndex = 9003

c.Parent = row

end

cell(entry.User or "Unknown", 0.00, 0.28, true)

cell(entry.Command or "", 0.28, 0.45, false)

cell(commandAgeText(entry.Time), 0.73, 0.27, true)

end

end

local function navButton(txt, x, cb)

local b = Instance.new("TextButton")

b.Size = UDim2.new(0, 28, 0, 25)

b.Position = UDim2.new(0.5, x, 0, 3)

b.BackgroundTransparency = 1

b.Text = txt

b.Font = Enum.Font.SourceSansBold

b.TextSize = 16

b.TextColor3 = Color3.fromRGB(245, 245, 245)

b.ZIndex = 9002

b.Parent = bottom

b.MouseButton1Click:Connect(function()

cb()

render()

end)

end

navButton("<<", -112, function() page = 1 end)

navButton("<", -78, function() page -= 1 end)

navButton(">", 52, function() page += 1 end)

navButton(">>", 86, function() page = math.huge end)

refresh.MouseButton1Click:Connect(render)

search:GetPropertyChangedSignal("Text"):Connect(function()

page = 1

render()

end)

TweenService:Create(holder, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {

Position = UDim2.new(0.5, -290, 0.5, -120),

BackgroundTransparency = 0

}):Play()

TweenService:Create(scale, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {

Scale = 1

}):Play()

render()

end

local function sendChatMessage(message)

message = tostring(message or "")

pcall(function()

if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then

local channels = TextChatService:WaitForChild("TextChannels", 5)

local channel = channels and (channels:FindFirstChild("RBXGeneral") or channels:FindFirstChild("General"))

if channel then

channel:SendAsync(message)

return

end

end

local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")

local sayRequest = chatEvents and chatEvents:FindFirstChild("SayMessageRequest")

if sayRequest then

sayRequest:FireServer(message, "All")

end

end)

end

local function betaWait(seconds)

seconds = tonumber(seconds) or 0

if task and task.wait then

task.wait(seconds)

return

end

local started = os.clock()

repeat

RunService.Heartbeat:Wait()

until os.clock() - started >= seconds

end

local function betaSpawn(fn)

if task and task.spawn then

task.spawn(fn)

else

coroutine.wrap(fn)()

end

end

local function createStartupOverlay(message)

if not Root or _G.BETA_KILLED then return nil end

local old = Root:FindFirstChild("StartupFullScreenNotice")

if old then

old:Destroy()

end

local overlay = Instance.new("Frame")

overlay.Name = "StartupFullScreenNotice"

overlay.Size = UDim2.new(1, 0, 1, 0)

overlay.Position = UDim2.new(0, 0, 0, 0)

overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

overlay.BackgroundTransparency = 0.22

overlay.BorderSizePixel = 0

overlay.ZIndex = 9000

overlay.Parent = Root

local label = Instance.new("TextLabel")

label.AnchorPoint = Vector2.new(0.5, 0.5)

label.Size = UDim2.new(1, -40, 0, 90)

label.Position = UDim2.new(0.5, 0, 0.5, 0)

label.BackgroundTransparency = 1

label.Text = tostring(message or "")

label.Font = getFont()

label.TextSize = 38

label.TextColor3 = C.W

label.TextStrokeTransparency = 0.35

label.TextTransparency = 0

label.TextXAlignment = Enum.TextXAlignment.Center

label.TextYAlignment = Enum.TextYAlignment.Center

label.ZIndex = 9001

label.Parent = overlay

themeObj(label, "AccentText")

textObj(label)

return overlay, label

end

local function fadeStartupOverlay(overlay, label)

if not overlay or not overlay.Parent then return end

TweenService:Create(overlay, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {

BackgroundTransparency = 1

}):Play()

if label and label.Parent then

TweenService:Create(label, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {

TextTransparency = 1,

TextStrokeTransparency = 1

}):Play()

end

task.wait(0.5)

if overlay then

overlay:Destroy()

end

end

local function forceStartupMiniNotice(message)

if not Root or _G.BETA_KILLED then return end

local holder = NotifHolder

if not holder then return end

local n = Instance.new("TextLabel")

n.Size = UDim2.new(0, 260, 0, 28)

n.BackgroundColor3 = C.CARD

n.BackgroundTransparency = 0

n.BorderSizePixel = 0

n.Text = tostring(message or "")

n.Font = getFont()

n.TextSize = 11

n.TextColor3 = C.TX

n.TextTransparency = 0

n.TextXAlignment = Enum.TextXAlignment.Left

n.Parent = holder

themeObj(n, "Card")

textObj(n)

stroke(n, C.W, 1)

corner(n, 6)

local pad = Instance.new("UIPadding")

pad.PaddingLeft = UDim.new(0, 8)

pad.Parent = n

task.delay(0.45, function()

if n and n.Parent then

TweenService:Create(n, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {

BackgroundTransparency = 1,

TextTransparency = 1

}):Play()

task.wait(0.38)

if n then

n:Destroy()

end

end

end)

end

local function announceUniversalGui()

betaSpawn(function()

local ok, err = pcall(function()

local promoMsg = "32Dev_LOL on tiktok"

local welcomeName = LocalPlayer.DisplayName or LocalPlayer.Name

local welcomeMsg = "welcome " .. tostring(welcomeName)

betaWait(0.15)

local welcomeOverlay, welcomeLabel = createStartupOverlay(welcomeMsg)

if welcomeOverlay and welcomeLabel then

betaWait(0.9)

fadeStartupOverlay(welcomeOverlay, welcomeLabel)

end

betaWait(0.12)

local overlay, label = createStartupOverlay(promoMsg)

showStartupGuiSmoothly()

local miniDone = false

betaSpawn(function()

for i = 1, 100 do

if _G.BETA_KILLED then return end

forceStartupMiniNotice(promoMsg)

betaWait(0.025)

end

miniDone = true

end)

if overlay and label then

betaWait(1.15)

fadeStartupOverlay(overlay, label)

end

while not miniDone and not _G.BETA_KILLED do

betaWait(0.05)

end

end)

if not ok then

warn("[BETA GUI] startup notification failed:", err)

showStartupGuiSmoothly()

end

end)

end

notify = function(text)

if not NotifHolder or _G.BETA_KILLED or not _G.Notifications then return end

playUISound()

local n = Instance.new("TextLabel")

n.Size = UDim2.new(0, 230, 0, 28)

n.BackgroundColor3 = C.CARD

n.BorderSizePixel = 0

n.Text = text

n.Font = getFont()

n.TextSize = 11

n.TextColor3 = C.TX

n.TextXAlignment = Enum.TextXAlignment.Left

n.Parent = NotifHolder

themeObj(n, "Card")

textObj(n)

stroke(n, C.W, 1)

corner(n, 6)

local pad = Instance.new("UIPadding")

pad.PaddingLeft = UDim.new(0, 8)

pad.Parent = n

task.delay(2.4, function()

if n and n.Parent then

TweenService:Create(n, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()

task.wait(0.35)

if n and n.Parent then n:Destroy() end

end

end)

end

local function updateKeybindList()

if not KeybindLabel then return end

local lines = {"RightShift: Toggle GUI", "Panic Hide: " .. PanicKey.Name}

for name, code in pairs(Binds) do

table.insert(lines, name .. ": " .. code.Name)

end

if #lines == 2 then table.insert(lines, "No feature keybinds set.") end

KeybindLabel.Text = table.concat(lines, "\n")

end

local function setSlider(name, value)

if Sliders[name] and Sliders[name].Set then

Sliders[name].Set(value)

else

_G[name] = value

end

end

local function setToggle(name, value, fire)

if Toggles[name] and Toggles[name].Set then

Toggles[name].Set(value, fire)

else

_G[name] = value

end

end

local function addEvidence(text)

local line = os.date("[%H:%M:%S] ") .. text

table.insert(_G.EvidenceLog, 1, line)

while #_G.EvidenceLog > 20 do table.remove(_G.EvidenceLog) end

EvidenceText = table.concat(_G.EvidenceLog, "\n")

if EvidenceLabel then EvidenceLabel.Text = EvidenceText ~= "" and EvidenceText or "No evidence recorded." end

end

local function encodeConfig()

local parts = {}

for key in pairs(DEFAULTS) do

table.insert(parts, key .. "=" .. tostring(_G[key]))

end

table.insert(parts, "PanicKey=" .. PanicKey.Name)

table.insert(parts, "LastTab=" .. tostring(SelectedTab))

return table.concat(parts, "\n")

end

local function decodeValue(v)

if v == "true" then return true end

if v == "false" then return false end

local n = tonumber(v)

if n ~= nil then return n end

return v

end

local function applySettingsToUI(fireFeatures)

for key, value in pairs(DEFAULTS) do

if Sliders[key] then

Sliders[key].Set(_G[key])

elseif Toggles[key] then

Toggles[key].Set(_G[key], fireFeatures)

end

end

for name, cyc in pairs(Cycles) do

if cyc.Refresh then cyc.Refresh() end

end

if MainScale then MainScale.Scale = (_G.GUI_Scale or 100) / 100 end

if BlurEffect then BlurEffect.Enabled = _G.UIBlur end

if savedPositionLabel then SavedPositionLabel.Text = "Saved: None" end

setNotifPosition()

refreshTheme()

end

local function saveConfig()

if writefile then

writefile(CONFIG_FILE, encodeConfig())

notify("Config Saved")

else

notify("Save Config not supported")

end

end

local function loadConfig()

if not readfile or not isfile then

notify("Load Config not supported")

return

end

if not isfile(CONFIG_FILE) then

notify("No Saved Config")

return

end

local data = readfile(CONFIG_FILE)

for line in string.gmatch(data, "[^\r\n]+") do

local key, value = line:match("^([^=]+)=(.*)$")

if key and value then

if DEFAULTS[key] ~= nil then

_G[key] = decodeValue(value)

elseif key == "PanicKey" and Enum.KeyCode[value] then

PanicKey = Enum.KeyCode[value]

elseif key == "LastTab" then

_G.LastTab = value

end

end

end

applySettingsToUI(true)

if _G.AutoOpenLastTab and Pages[_G.LastTab] then

SelectedTab = _G.LastTab

end

notify("Config Loaded")

end

local function resetConfig()

for key, value in pairs(DEFAULTS) do

_G[key] = value

end

PanicKey = Enum.KeyCode.RightControl

table.clear(Binds)

applySettingsToUI(true)

updateKeybindList()

notify("Fresh Defaults Restored")

end

local function resetLighting()

for prop, value in pairs(OriginalLighting) do

pcall(function() Lighting[prop] = value end)

end

if BlurEffect then BlurEffect.Enabled = false end

end

local function resetCharacterPhysics()

if LocalPlayer.Character then

local hum = LocalPlayer.Character:FindFirstChild("Humanoid")

local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

if hum then

hum.WalkSpeed = 16

hum.Sit = false

pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true) end)

end

if hrp then

hrp.AssemblyLinearVelocity = Vector3.zero

hrp.AssemblyAngularVelocity = Vector3.zero

hrp.Velocity = Vector3.zero

end

for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do

if v:IsA("BasePart") then v.CanCollide = true end

end

end

end

local function isSameTeam(plr)

return plr

and LocalPlayer.Team ~= nil

and plr.Team ~= nil

and LocalPlayer.Team == plr.Team

end

local function isPartOnScreen(part)

local cam = workspace.CurrentCamera

if not cam or not part then

return false

end

local _, visible = cam:WorldToViewportPoint(part.Position)

return visible == true

end

local function hasLineOfSightToPart(part, char)

local cam = workspace.CurrentCamera

if not cam or not part then

return false

end

local origin = cam.CFrame.Position

local direction = part.Position - origin

if direction.Magnitude <= 0.1 then

return true

end

local params = RaycastParams.new()

params.FilterType = Enum.RaycastFilterType.Exclude

params.FilterDescendantsInstances = {LocalPlayer.Character}

params.IgnoreWater = true

local result = workspace:Raycast(origin, direction, params)

if not result then

return true

end

return char and result.Instance and result.Instance:IsDescendantOf(char)

end

local function passesCamlockChecks(plr, part)

if not plr or not part or not isAlive(plr.Character) then

return false

end

if _G.Camlock_TeamCheck and isSameTeam(plr) then

return false

end

if _G.Camlock_VisibleCheck and not isPartOnScreen(part) then

return false

end

if _G.Camlock_WallCheck and not hasLineOfSightToPart(part, plr.Character) then

return false

end

return true

end

local function getClosestPlayerToMouse()

local cam = workspace.CurrentCamera

if not cam then return nil end

local mousePos = UserInputService:GetMouseLocation()

local closest, closestDistance = nil, math.huge

local fovEnabled = (_G.FOV_Enabled == true)

local fovRadius = math.clamp(tonumber(_G.FOV_Radius) or 100, 5, 1000)

for _, plr in ipairs(Players:GetPlayers()) do

if plr ~= LocalPlayer and isAlive(plr.Character) then

local part = getPart(plr.Character, _G.LockPart == "Random" and "HumanoidRootPart" or _G.LockPart)

or plr.Character:FindFirstChild("HumanoidRootPart")

if part and passesCamlockChecks(plr, part) then

local pos, visible = cam:WorldToViewportPoint(part.Position)

if visible then

local screenDistance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude

if (not fovEnabled or screenDistance <= fovRadius) and screenDistance < closestDistance then

closestDistance = screenDistance

closest = plr

end

end

end

end

end

return closest

end

local function getClosestPlayerToCharacter()

if not isAlive(LocalPlayer.Character) then return nil end

local myRoot = LocalPlayer.Character.HumanoidRootPart

local closest, closestDistance = nil, math.huge

for _, plr in ipairs(Players:GetPlayers()) do

if plr ~= LocalPlayer and isAlive(plr.Character) then

local d = (plr.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude

if d < closestDistance then

closestDistance = d

closest = plr

end

end

end

return closest

end

local function findPlayerByPartial(query)

query = tostring(query or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")

if query == "" then return nil end

local best = nil

local bestScore = math.huge

for _, plr in ipairs(Players:GetPlayers()) do

if plr ~= LocalPlayer then

local name = plr.Name:lower()

local display = plr.DisplayName:lower()

local score = math.huge

if name == query or display == query then

score = 1

elseif name:sub(1, #query) == query or display:sub(1, #query) == query then

score = 2

elseif string.find(name, query, 1, true) or string.find(display, query, 1, true) then

score = 3

end

if score < bestScore then

best = plr

bestScore = score

end

end

end

return best

end

local function teleportToPlayerByName(query)

local target = findPlayerByPartial(query)

if not target then

notify("Player not found: " .. tostring(query or ""))

return

end

if not isAlive(LocalPlayer.Character) then

notify("Your character is not ready")

return

end

if not isAlive(target.Character) then

notify("Target is not alive: " .. target.Name)

return

end

local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")

if not myRoot or not targetRoot then

notify("Teleport failed")

return

end

LastTeleportCFrame = myRoot.CFrame

myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)

myRoot.AssemblyLinearVelocity = Vector3.zero

myRoot.AssemblyAngularVelocity = Vector3.zero

notify("Teleported to " .. target.Name)

addEvidence("Command .tpto used on " .. target.Name)

end

local function teleportNearPlayer(query, heightOffset)

local target = findPlayerByPartial(query)

if not target then

notify("Player not found: " .. tostring(query or ""))

return

end

if not isAlive(LocalPlayer.Character) then

notify("Your character is not ready")

return

end

if not isAlive(target.Character) then

notify("Target is not alive: " .. target.Name)

return

end

local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")

if not myRoot or not targetRoot then

notify("Teleport failed")

return

end

LastTeleportCFrame = myRoot.CFrame

local side = targetRoot.CFrame.RightVector * 7

local back = -targetRoot.CFrame.LookVector * 5

local up = Vector3.new(0, heightOffset or 3, 0)

myRoot.CFrame = CFrame.new(targetRoot.Position + side + back + up, targetRoot.Position)

myRoot.AssemblyLinearVelocity = Vector3.zero

myRoot.AssemblyAngularVelocity = Vector3.zero

notify("Teleported near " .. target.Name)

addEvidence("Command .near used on " .. target.Name)

end

local function backToLastTeleport()

if not LastTeleportCFrame then

notify("No back position saved")

return

end

if not isAlive(LocalPlayer.Character) then

notify("Your character is not ready")

return

end

local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

if not root then

notify("Back failed")

return

end

root.CFrame = LastTeleportCFrame + Vector3.new(0, 3, 0)

root.AssemblyLinearVelocity = Vector3.zero

root.AssemblyAngularVelocity = Vector3.zero

notify("Returned with .back")

end

function stopFollowPlayer()

if _G.BETA_FOLLOW_CONN then

pcall(function()

_G.BETA_FOLLOW_CONN:Disconnect()

end)

_G.BETA_FOLLOW_CONN = nil

end

_G.BETA_FOLLOW_TARGET = nil

notify("Follow stopped")

end

function stopTalkCommand()

if _G.BETA_TALK_CONN then

pcall(function()

_G.BETA_TALK_CONN:Disconnect()

end)

_G.BETA_TALK_CONN = nil

end

_G.BETA_TALK_TARGET = nil

notify("Talk stopped")

end

function pickFriendlyReply(message, displayName)

local raw = tostring(message or "")

local msg = string.lower(raw)

msg = msg:gsub("[%c\r\n]", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

if msg == "" or msg:sub(1, 1) == "." or #msg > 180 then

return nil

end

local name = tostring(displayName or "bro")

local function has(word)

return string.find(msg, word, 1, true) ~= nil

end

local function hasAny(words)

for _, word in ipairs(words) do

if has(word) then return true end

end

return false

end

local function pick(list)

_G.BETA_TALK_REPLY_INDEX = ((_G.BETA_TALK_REPLY_INDEX or 0) % #list) + 1

return list[_G.BETA_TALK_REPLY_INDEX]

end

local function shortTopic()

local topic = msg

topic = topic:gsub("%?", "")

topic = topic:gsub("what is", ""):gsub("whats", ""):gsub("what's", "")

topic = topic:gsub("why", ""):gsub("how", ""):gsub("where", "")

topic = topic:gsub("can you", ""):gsub("do you", ""):gsub("are you", ""):gsub("is it", "")

topic = topic:gsub("^%s+", ""):gsub("%s+$", "")

if #topic > 38 then topic = topic:sub(1, 38) end

return topic

end

local function rememberTopic(topic)

if topic and topic ~= "" then

_G.BETA_TALK_LAST_TOPIC = topic

end

end

if hasAny({"hello", "hi", "yo", "sup", "wassup", "wsg", "hey"}) then

return pick({"yo " .. name, "hey " .. name, "wsg", "yo whats up", "sup bro"})

end

if hasAny({"how are", "hru", "how r u", "you good", "u good", "how you doing"}) then

return pick({"im good wbu", "im chillin wbu", "yeah im good", "doing good rn", "im straight wbu"})

end

if hasAny({"what you doing", "wyd", "what u doing", "what are you doing"}) then

return pick({"just playing rn", "just chilling", "nothing crazy", "just moving around", "im just testing stuff"})

end

if hasAny({"thanks", "thank you", "thx", "ty", "preciate"}) then

return pick({"np", "all good", "gotchu", "you good", "no problem"})

end

if hasAny({"sorry", "my bad", "mb", "my fault"}) then

return pick({"ur good", "all good", "dont worry about it", "you good", "its fine"})

end

if hasAny({"lol", "lmao", "lmfao", "haha", "funny"}) then

return pick({"lol", "nah fr", "that was funny", "lmao", "bro lol"})

end

if hasAny({"gg", "good game", "ggs"}) then

return pick({"gg", "ggs", "gg bro", "that was clean", "good game"})

end

if hasAny({"help", "come", "follow me", "come here", "over here", "team", "help me"}) then

return pick({"i gotchu", "coming", "bet im coming", "where you at", "alr im going"})

end

if hasAny({"where are you", "where r u", "where you", "where u", "location"}) then

return pick({"im near you", "im around here", "look for me", "im close", "im by you"})

end

if hasAny({"run", "go", "move", "hurry", "quick"}) then

return pick({"alr go", "bet move", "im going", "go go", "alr hurry"})

end

if hasAny({"wait", "stop", "hold on", "hold up"}) then

return pick({"alr wait", "ok hold up", "bet", "im waiting", "alr"})

end

if hasAny({"shoot", "fight", "kill", "attack"}) then

return pick({"alr", "bet", "watch out", "i see them", "careful"})

end

if hasAny({"behind", "left", "right", "front"}) then

return pick({"i see", "ok", "bet", "got it", "im looking"})

end

if hasAny({"good", "nice", "clean", "cool"}) then

rememberTopic(shortTopic())

return pick({"yeah its clean", "fr", "true", "looks good", "thats nice"})

end

if hasAny({"bad", "trash", "boring", "annoying"}) then

rememberTopic(shortTopic())

return pick({"yeah kinda", "fr", "i feel you", "thats fair", "lowkey true"})

end

if hasAny({"shut", "stupid", "dumb", "trash", "ez", "noob", "kid", "mad"}) then

return pick({"chill", "its not that deep", "all good bro", "relax lol", "we just playing"})

end

if msg:sub(-1) == "?" then

local topic = shortTopic()

if topic ~= "" and #topic >= 4 then rememberTopic(topic) end

if hasAny({"why", "how come"}) then

return pick({"idk maybe", "not sure tbh", "could be", "maybe thats why", "i dont really know"})

end

if hasAny({"can you", "could you", "will you"}) then

return pick({"yeah i can try", "maybe", "bet", "i gotchu", "sure"})

end

if hasAny({"do you", "are you", "is it", "what", "whats", "what's", "how"}) then

if topic ~= "" and #topic >= 4 then

return pick({

"idk about " .. topic .. " tbh",

"maybe " .. topic,

"could be " .. topic,

"not sure about " .. topic,

"i think " .. topic

})

end

return pick({"idk tbh", "maybe", "not sure", "could be", "i think so"})

end

return pick({"maybe", "idk", "not sure", "could be", "probably"})

end

if hasAny({"ok", "okay", "alright", "alr", "bet"}) then

return pick({"bet", "alr", "sounds good", "ok", "gotchu"})

end

if hasAny({"yes", "yeah", "yep", "true", "fr", "facts"}) then

return pick({"yeah", "fr", "true", "facts", "exactly"})

end

if hasAny({"no", "nah", "nope"}) then

return pick({"nah?", "why not", "alr then", "fair", "oh ok"})

end

if _G.BETA_TALK_LAST_TOPIC and _G.BETA_TALK_LAST_TOPIC ~= "" and string.find(msg, _G.BETA_TALK_LAST_TOPIC, 1, true) then

return pick({"yeah thats what i meant", "fr", "exactly", "thats what im saying", "yeah lowkey"})

end

return pick({

"yeah",

"fr",

"true",

"bet",

"i feel you",

"thats fair",

"same",

"alr",

"lowkey",

"nah fr",

"i get you",

"makes sense"

})

end

function startTalkCommand(query)

local target = findPlayerByPartial(query)

if not target then

notify("Player not found: " .. tostring(query or ""))

return

end

if target == LocalPlayer then

notify("Cannot talk to yourself")

return

end

if _G.BETA_TALK_CONN then

stopTalkCommand()

end

_G.BETA_TALK_TARGET = target

_G.BETA_TALK_LAST_REPLY = 0

_G.BETA_TALK_CONN = target.Chatted:Connect(function(message)

if not _G.BETA_TALK_TARGET or _G.BETA_TALK_TARGET ~= target then

return

end

local now = os.clock()

if now - (_G.BETA_TALK_LAST_REPLY or 0) < 1.65 then

return

end

local reply = pickFriendlyReply(message, target.DisplayName or target.Name)

if not reply or reply == "" then

return

end

_G.BETA_TALK_LAST_REPLY = now

sendChatMessage(reply)

end)

notify("Talking with " .. target.Name)

end

function startFollowPlayer(query)

local target = findPlayerByPartial(query)

if not target then

notify("Player not found: " .. tostring(query or ""))

return

end

if not isAlive(LocalPlayer.Character) then

notify("Your character is not ready")

return

end

if not isAlive(target.Character) then

notify("Target is not alive: " .. target.Name)

return

end

if _G.BETA_FOLLOW_CONN then

stopFollowPlayer()

end

if Toggles.AntiSit then

Toggles.AntiSit.Set(true, true)

else

_G.AntiSit = true

end

teleportNearPlayer(query, 3)

_G.BETA_FOLLOW_TARGET = target

local lastMove = 0

local lastJump = 0

local lastCatchupTeleport = 0

local lastPathTime = 0

local lastTargetPathPosition = nil

local waypoints = {}

local waypointIndex = 1

local blockedConnection = nil

local CATCHUP_DISTANCE = 55

local CATCHUP_COOLDOWN = 0

local PATH_REFRESH = 0.55

local TARGET_MOVED_REPATH = 5

local WAYPOINT_REACHED_DISTANCE = 3.5

local function clearBlockedConnection()

if blockedConnection then

pcall(function()

blockedConnection:Disconnect()

end)

blockedConnection = nil

end

end

local function getBehindPosition(targetRoot, distanceBack, sideOffset, heightOffset)

distanceBack = distanceBack or 6

sideOffset = sideOffset or 0

heightOffset = heightOffset or 0

return targetRoot.Position

+ (-targetRoot.CFrame.LookVector * distanceBack)

+ (targetRoot.CFrame.RightVector * sideOffset)

+ Vector3.new(0, heightOffset, 0)

end

local function setDirectMove(hum, targetRoot)

local destination = getBehindPosition(targetRoot, 6, 0, 0)

hum:MoveTo(destination)

end

local function safePathJump(hum, myRoot, waypoint)

if not hum or not myRoot or not waypoint then

return

end

local state = hum:GetState()

if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall then

return

end

if hum.FloorMaterial == Enum.Material.Air then

return

end

if os.clock() - lastJump < 0.65 then

return

end

if myRoot.AssemblyLinearVelocity.Y > 35 then

myRoot.AssemblyLinearVelocity = Vector3.new(myRoot.AssemblyLinearVelocity.X, 18, myRoot.AssemblyLinearVelocity.Z)

end

lastJump = os.clock()

hum.Jump = true

end

local function computePath(myRoot, targetRoot)

clearBlockedConnection()

local destination = getBehindPosition(targetRoot, 6, 0, 0)

local path = PathfindingService:CreatePath({

AgentRadius = 2,

AgentHeight = 5,

AgentCanJump = true,

AgentCanClimb = true,

WaypointSpacing = 4,

Costs = {}

})

local ok = pcall(function()

path:ComputeAsync(myRoot.Position, destination)

end)

if not ok or path.Status ~= Enum.PathStatus.Success then

waypoints = {}

waypointIndex = 1

return false

end

waypoints = path:GetWaypoints()

waypointIndex = math.min(2, #waypoints)

lastTargetPathPosition = targetRoot.Position

lastPathTime = os.clock()

blockedConnection = path.Blocked:Connect(function(blockedIndex)

if blockedIndex >= waypointIndex then

waypoints = {}

waypointIndex = 1

lastPathTime = 0

end

end)

return #waypoints > 0

end

_G.BETA_FOLLOW_CONN = RunService.Heartbeat:Connect(function()

if _G.BETA_KILLED then

stopFollowPlayer()

clearBlockedConnection()

return

end

local followTarget = _G.BETA_FOLLOW_TARGET

if not followTarget or not followTarget.Parent then

stopFollowPlayer()

clearBlockedConnection()

return

end

if not isAlive(LocalPlayer.Character) or not isAlive(followTarget.Character) then

return

end

local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

local targetRoot = followTarget.Character:FindFirstChild("HumanoidRootPart")

if not hum or not myRoot or not targetRoot then

return

end

hum.Sit = false

hum.PlatformStand = false

pcall(function()

hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)

hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)

end)

if myRoot.AssemblyLinearVelocity.Y > 70 then

myRoot.AssemblyLinearVelocity = Vector3.new(myRoot.AssemblyLinearVelocity.X, 28, myRoot.AssemblyLinearVelocity.Z)

end

local distance = (targetRoot.Position - myRoot.Position).Magnitude

if distance > CATCHUP_DISTANCE and os.clock() - lastCatchupTeleport >= CATCHUP_COOLDOWN then

lastCatchupTeleport = os.clock()

local catchupPosition = getBehindPosition(targetRoot, 7, 0, 3)

myRoot.CFrame = CFrame.new(catchupPosition, targetRoot.Position)

myRoot.AssemblyLinearVelocity = Vector3.zero

myRoot.AssemblyAngularVelocity = Vector3.zero

hum:Move(Vector3.zero, false)

waypoints = {}

waypointIndex = 1

lastPathTime = 0

return

end

local behindSpot = getBehindPosition(targetRoot, 6, 0, 0)

local localOffset = targetRoot.CFrame:PointToObjectSpace(myRoot.Position)

if distance <= 6 or localOffset.Z < 1 or math.abs(localOffset.X) > 7 then

if os.clock() - lastMove >= 0.12 then

lastMove = os.clock()

hum:MoveTo(behindSpot)

end

return

end

local needsPath = #waypoints == 0

or waypointIndex > #waypoints

or os.clock() - lastPathTime >= PATH_REFRESH

or (lastTargetPathPosition and (targetRoot.Position - lastTargetPathPosition).Magnitude >= TARGET_MOVED_REPATH)

if needsPath then

local pathOk = computePath(myRoot, targetRoot)

if not pathOk then

if os.clock() - lastMove >= 0.18 then

lastMove = os.clock()

setDirectMove(hum, targetRoot)

end

return

end

end

local waypoint = waypoints[waypointIndex]

if not waypoint then

if os.clock() - lastMove >= 0.18 then

lastMove = os.clock()

setDirectMove(hum, targetRoot)

end

return

end

if (myRoot.Position - waypoint.Position).Magnitude <= WAYPOINT_REACHED_DISTANCE then

waypointIndex += 1

waypoint = waypoints[waypointIndex]

end

if waypoint and os.clock() - lastMove >= 0.12 then

lastMove = os.clock()

if waypoint.Action == Enum.PathWaypointAction.Jump then

safePathJump(hum, myRoot, waypoint)

end

hum:MoveTo(waypoint.Position)

end

end)

notify("Following " .. target.Name .. " with pathfinding")

end

local function fixCharacterCommand()

stopFreecam()

stopViewCommand()

stopXray()

if stopFollowPlayer then stopFollowPlayer() end

resetCharacterPhysics()

resetLighting()

pcall(function()

workspace.Gravity = OriginalWorkspaceGravity or 196.2

end)

for _, toggleName in ipairs({

"Fly",

"FlyWalk",

"Noclip",

"InfiniteJump",

"AntiSit",

"AntiFling",

"Orbit",

"SwimAnywhere",

"TeleportClick",

"GravityModifier",

"PhaseDash"

}) do

if Toggles[toggleName] then

Toggles[toggleName].Set(false, true)

else

_G[toggleName] = false

end

end

if isAlive(LocalPlayer.Character) then

local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

if hum then

hum.Sit = false

hum.PlatformStand = false

hum.AutoRotate = true

hum.WalkSpeed = 16

pcall(function()

hum.UseJumpPower = true

hum.JumpPower = 50

hum.JumpHeight = 7.2

end)

pcall(function()

hum:ChangeState(Enum.HumanoidStateType.Running)

end)

end

if root then

root.Anchored = false

root.AssemblyLinearVelocity = Vector3.zero

root.AssemblyAngularVelocity = Vector3.zero

root.Velocity = Vector3.zero

root.RotVelocity = Vector3.zero

end

for _, obj in ipairs(LocalPlayer.Character:GetDescendants()) do

if obj:IsA("BasePart") then

obj.CanCollide = true

end

end

end

notify("Character fixed")

end

local PrisonLocationAliases = {

cells = {"cells", "cell", "prison cells", "jail cells", "cellblock", "cell block"},

yard = {"yard", "prison yard", "courtyard"},

armory = {"armory", "gun room", "weapons", "weapon room"},

cafe = {"cafe", "cafeteria", "lunchroom"},

crimbase = {"criminal base", "crim base", "criminalbase", "criminals", "hideout"},

prison = {"prison", "jail", "main prison"}

}

local function getCFrameFromInstance(obj)

if not obj then return nil end

if obj:IsA("BasePart") then

return obj.CFrame

end

if obj:IsA("Model") then

local ok, cf = pcall(function()

return obj:GetPivot()

end)

if ok and cf then

return cf

end

local part = obj:FindFirstChildWhichIsA("BasePart", true)

return part and part.CFrame or nil

end

if obj:IsA("Attachment") then

return obj.WorldCFrame

end

return nil

end

local function findMapLocationCFrame(locationKey)

local aliases = PrisonLocationAliases[locationKey]

if not aliases then return nil end

local best, bestScore

for _, obj in ipairs(workspace:GetDescendants()) do

local name = string.lower(obj.Name)

for _, alias in ipairs(aliases) do

local score = nil

if name == alias then

score = 1

elseif string.find(name, alias, 1, true) then

score = 2

end

if score and (not bestScore or score < bestScore) and getCFrameFromInstance(obj) then

best = obj

bestScore = score

end

end

end

return getCFrameFromInstance(best), best

end

local function teleportToCFrame(cf, label)

if not cf then

notify("Location not found: " .. tostring(label or "unknown"))

return

end

if not isAlive(LocalPlayer.Character) then

notify("Your character is not ready")

return

end

local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

if not root then

notify("Teleport failed")

return

end

LastTeleportCFrame = root.CFrame

root.CFrame = cf + Vector3.new(0, 4, 0)

root.AssemblyLinearVelocity = Vector3.zero

root.AssemblyAngularVelocity = Vector3.zero

notify("Teleported to " .. tostring(label or "location"))

end

local function teleportPrisonLocation(locationKey)

local cf = CustomLocations[locationKey]

local label = locationKey

if not cf then

local found

cf, found = findMapLocationCFrame(locationKey)

if found then

label = found.Name

end

end

teleportToCFrame(cf, label)

end

local function saveCustomLocation(name)

name = tostring(name or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")

if name == "" then

notify("Usage: .setloc name")

return

end

if not isAlive(LocalPlayer.Character) then

notify("Your character is not ready")

return

end

local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

if not root then

notify("Save failed")

return

end

CustomLocations[name] = root.CFrame

notify("Saved location: " .. name)

end

local function gotoCustomLocation(name)

name = tostring(name or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")

if name == "" then

notify("Usage: .gotoloc name")

return

end

if not CustomLocations[name] then

notify("No saved location: " .. name)

return

end

teleportToCFrame(CustomLocations[name], name)

end

local function deleteCustomLocation(name)

name = tostring(name or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")

if name == "" then

notify("Usage: .delloc name")

return

end

CustomLocations[name] = nil

notify("Deleted location: " .. name)

end

local function listCustomLocations()

local names = {}

for name in pairs(CustomLocations) do

table.insert(names, name)

end

table.sort(names)

notify("Locations: " .. (#names > 0 and table.concat(names, ", ") or "none"))

end

local function copyCurrentPosition()

if not isAlive(LocalPlayer.Character) then

notify("Your character is not ready")

return

end

local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

if not root then

notify("No root part")

return

end

local p = root.Position

print(string.format("Current position: Vector3.new(%.3f, %.3f, %.3f)", p.X, p.Y, p.Z))

notify("Position printed to console")

end

local RealRigHitboxParts = {

Head = true,

HumanoidRootPart = true,

Torso = true,

UpperTorso = true,

LowerTorso = true,

["Left Arm"] = true,

["Right Arm"] = true,

["Left Leg"] = true,

["Right Leg"] = true,

LeftUpperArm = true,

LeftLowerArm = true,

LeftHand = true,

RightUpperArm = true,

RightLowerArm = true,

RightHand = true,

LeftUpperLeg = true,

LeftLowerLeg = true,

LeftFoot = true,

RightUpperLeg = true,

RightLowerLeg = true,

RightFoot = true,

}

local function isRealCharacterHitboxPart(part)

return part

and part:IsA("BasePart")

and RealRigHitboxParts[part.Name] == true

and not part:FindFirstAncestorOfClass("Accessory")

end

local function getOrCreateHitboxFolder()

if HitboxState.Folder and HitboxState.Folder.Parent then

return HitboxState.Folder

end

local folder = Instance.new("Folder")

folder.Name = "BETA_CommandHitboxes"

folder.Parent = Root or PlayerGui

HitboxState.Folder = folder

return folder

end

local function clearHitboxForPlayer(player)

if not HitboxState.Folder then return end

if player == "all" then

HitboxState.Folder:ClearAllChildren()

HitboxState.Targets = {}

if HitboxState.Connections then

for _, list in pairs(HitboxState.Connections) do

for _, conn in ipairs(list) do

disconnect(conn)

end

end

HitboxState.Connections = {}

end

return

end

local key = typeof(player) == "Instance" and tostring(player.UserId) or tostring(player)

for _, obj in ipairs(HitboxState.Folder:GetChildren()) do

if obj.Name == "Hitbox_" .. key then

obj:Destroy()

end

end

HitboxState.Targets[key] = nil

if HitboxState.Connections and HitboxState.Connections[key] then

for _, conn in ipairs(HitboxState.Connections[key]) do

disconnect(conn)

end

HitboxState.Connections[key] = nil

end

end

local function showHitboxForPlayer(player)

if not player or not player.Character then

notify("Hitbox target not found")

return

end

local folder = getOrCreateHitboxFolder()

local key = tostring(player.UserId)

clearHitboxForPlayer(player)

local count = 0

for _, part in ipairs(player.Character:GetChildren()) do

if isRealCharacterHitboxPart(part) then

local box = Instance.new("BoxHandleAdornment")

box.Name = "Hitbox_" .. key

box.Adornee = part

box.AlwaysOnTop = true

box.ZIndex = 10

box.Size = part.Size

box.Color3 = Color3.fromRGB(255, 60, 60)

box.Transparency = 0.48

box.Parent = folder

count += 1

end

end

HitboxState.Targets[key] = player

if not HitboxState.Connections then

HitboxState.Connections = {}

end

if HitboxState.Connections[key] then

for _, conn in ipairs(HitboxState.Connections[key]) do

disconnect(conn)

end

end

HitboxState.Connections[key] = {

player.CharacterRemoving:Connect(function()

clearHitboxForPlayer(player)

end),

player.AncestryChanged:Connect(function(_, parent)

if parent == nil then

clearHitboxForPlayer(player)

end

end)

}

if count == 0 then

notify("No real body hitboxes found")

end

end

local function showHitboxCommand(targetText)

targetText = tostring(targetText or "")

if targetText == "" then

notify("Usage: .showhitbox player/all")

return

end

if targetText:lower() == "all" then

for _, player in ipairs(Players:GetPlayers()) do

if player ~= LocalPlayer and player.Character then

showHitboxForPlayer(player)

end

end

notify("Hitboxes shown for all players")

return

end

local target = findPlayerByPartial(targetText)

if not target then

notify("Player not found: " .. targetText)

return

end

showHitboxForPlayer(target)

notify("Hitbox shown: " .. target.Name)

end

local function unshowHitboxCommand(targetText)

targetText = tostring(targetText or "")

if targetText == "" or targetText:lower() == "all" then

clearHitboxForPlayer("all")

notify("Hitboxes cleared")

return

end

local target = findPlayerByPartial(targetText)

if not target then

notify("Player not found: " .. targetText)

return

end

clearHitboxForPlayer(target)

notify("Hitbox removed: " .. target.Name)

end

local function startFreecam()

if FreecamState.Enabled then

notify("Freecam already on")

return

end

local camera = workspace.CurrentCamera

if not camera then return end

FreecamState.Enabled = true

FreecamState.Keys = {}

FreecamState.RightMouse = false

FreecamState.SavedCameraType = camera.CameraType

FreecamState.SavedCameraSubject = camera.CameraSubject

FreecamState.SavedCameraCFrame = workspace.CurrentCamera.CFrame

local _, y, _ = workspace.CurrentCamera.CFrame:ToOrientation()

FreecamState.Yaw = y

FreecamState.Pitch = 0

camera.CameraType = Enum.CameraType.Scriptable

pcall(function()

local playerModule = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))

FreecamState.Controls = playerModule:GetControls()

FreecamState.Controls:Disable()

end)

if isAlive(LocalPlayer.Character) then

local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

if humanoid then

FreecamState.SavedWalkSpeed = humanoid.WalkSpeed

FreecamState.SavedJumpPower = humanoid.JumpPower

FreecamState.SavedJumpHeight = humanoid.JumpHeight

FreecamState.SavedAutoRotate = humanoid.AutoRotate

humanoid.WalkSpeed = 0

humanoid.JumpPower = 0

humanoid.JumpHeight = 0

humanoid.AutoRotate = false

end

if root then

root.AssemblyLinearVelocity = Vector3.zero

root.AssemblyAngularVelocity = Vector3.zero

end

end

table.insert(FreecamState.Connections, UserInputService.InputBegan:Connect(function(input, gpe)

if gpe then return end

if input.UserInputType == Enum.UserInputType.MouseButton2 then

FreecamState.RightMouse = true

UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition

return

end

if input.UserInputType == Enum.UserInputType.Keyboard then

FreecamState.Keys[input.KeyCode] = true

end

end))

table.insert(FreecamState.Connections, UserInputService.InputEnded:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton2 then

FreecamState.RightMouse = false

UserInputService.MouseBehavior = Enum.MouseBehavior.Default

return

end

if input.UserInputType == Enum.UserInputType.Keyboard then

FreecamState.Keys[input.KeyCode] = nil

end

end))

table.insert(FreecamState.Connections, UserInputService.InputChanged:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseMovement and FreecamState.RightMouse then

FreecamState.Yaw -= input.Delta.X * 0.003

FreecamState.Pitch = math.clamp(FreecamState.Pitch - input.Delta.Y * 0.003, -1.45, 1.45)

end

end))

table.insert(FreecamState.Connections, RunService.RenderStepped:Connect(function()

if not FreecamState.Enabled then return end

local cam = workspace.CurrentCamera

if not cam then return end

local rot = CFrame.Angles(0, FreecamState.Yaw, 0) * CFrame.Angles(FreecamState.Pitch, 0, 0)

local move = Vector3.zero

if FreecamState.Keys[Enum.KeyCode.W] then move += Vector3.new(0, 0, -1) end

if FreecamState.Keys[Enum.KeyCode.S] then move += Vector3.new(0, 0, 1) end

if FreecamState.Keys[Enum.KeyCode.A] then move += Vector3.new(-1, 0, 0) end

if FreecamState.Keys[Enum.KeyCode.D] then move += Vector3.new(1, 0, 0) end

if FreecamState.Keys[Enum.KeyCode.E] then move += Vector3.new(0, 1, 0) end

if FreecamState.Keys[Enum.KeyCode.Q] then move += Vector3.new(0, -1, 0) end

local speed = FreecamState.Keys[Enum.KeyCode.LeftShift] and 3.8 or FreecamState.Speed

if move.Magnitude > 0 then

cam.CFrame = CFrame.new(cam.CFrame.Position + rot:VectorToWorldSpace(move.Unit * speed)) * rot

else

cam.CFrame = CFrame.new(cam.CFrame.Position) * rot

end

end))

notify("Freecam ON | WASD/QE move | Right-click look")

addEvidence("Command .freecam used")

end

local function stopFreecam()

if not FreecamState.Enabled then

notify("Freecam already off")

return

end

FreecamState.Enabled = false

for _, conn in ipairs(FreecamState.Connections) do

disconnect(conn)

end

table.clear(FreecamState.Connections)

table.clear(FreecamState.Keys)

UserInputService.MouseBehavior = Enum.MouseBehavior.Default

pcall(function()

if FreecamState.Controls then

FreecamState.Controls:Enable()

end

end)

if isAlive(LocalPlayer.Character) then

local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

if humanoid then

humanoid.WalkSpeed = FreecamState.SavedWalkSpeed or _G.WalkSpeed or 16

humanoid.JumpPower = FreecamState.SavedJumpPower or _G.JumpHeight or 50

humanoid.JumpHeight = FreecamState.SavedJumpHeight or 7.2

humanoid.AutoRotate = FreecamState.SavedAutoRotate ~= false

end

end

FreecamState.Controls = nil

FreecamState.SavedWalkSpeed = nil

FreecamState.SavedJumpPower = nil

FreecamState.SavedJumpHeight = nil

FreecamState.SavedAutoRotate = nil

local camera = workspace.CurrentCamera

if camera then

camera.CameraType = FreecamState.SavedCameraType or Enum.CameraType.Custom

camera.CameraSubject = FreecamState.SavedCameraSubject or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"))

if FreecamState.SavedCameraCFrame then

workspace.CurrentCamera.CFrame = FreecamState.SavedCameraCFrame

end

end

notify("Freecam OFF")

end

local function startViewCommand(targetText)

targetText = tostring(targetText or "")

if targetText == "" then

notify("Usage: .view player/all")

return

end

local camera = workspace.CurrentCamera

if not camera then return end

if not ViewState.Enabled then

ViewState.SavedCameraType = camera.CameraType

ViewState.SavedCameraSubject = camera.CameraSubject

end

if ViewState.Connection then

ViewState.Connection:Disconnect()

ViewState.Connection = nil

end

ViewState.Enabled = true

if targetText:lower() == "all" then

ViewState.All = true

ViewState.Index = 1

ViewState.LastSwitch = 0

ViewState.Connection = RunService.RenderStepped:Connect(function()

local available = {}

for _, player in ipairs(Players:GetPlayers()) do

if player ~= LocalPlayer and isAlive(player.Character) then

table.insert(available, player)

end

end

if #available == 0 then return end

if os.clock() - ViewState.LastSwitch >= 3 then

ViewState.Index = (ViewState.Index % #available) + 1

ViewState.LastSwitch = os.clock()

end

local target = available[ViewState.Index]

if target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then

camera.CameraType = Enum.CameraType.Custom

camera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")

end

end)

notify("Viewing all players")

return

end

local target = findPlayerByPartial(targetText)

if not target or not target.Character or not target.Character:FindFirstChildOfClass("Humanoid") then

notify("View target not found: " .. targetText)

return

end

ViewState.All = false

camera.CameraType = Enum.CameraType.Custom

camera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")

notify("Viewing " .. target.Name)

end

local function stopViewCommand()

if ViewState.Connection then

ViewState.Connection:Disconnect()

ViewState.Connection = nil

end

ViewState.Enabled = false

ViewState.All = false

local camera = workspace.CurrentCamera

if camera then

camera.CameraType = ViewState.SavedCameraType or Enum.CameraType.Custom

camera.CameraSubject = ViewState.SavedCameraSubject or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid"))

end

notify("View OFF")

end

local function startXray()

if XrayState.Enabled then

notify("Xray already on")

return

end

XrayState.Enabled = true

XrayState.Saved = {}

local function apply(part)

if not part:IsA("BasePart") then return end

if LocalPlayer.Character and part:IsDescendantOf(LocalPlayer.Character) then return end

for _, player in ipairs(Players:GetPlayers()) do

if player.Character and part:IsDescendantOf(player.Character) then

return

end

end

if part.Transparency < 1 then

XrayState.Saved[part] = part.LocalTransparencyModifier

part.LocalTransparencyModifier = math.max(part.LocalTransparencyModifier, 0.72)

end

end

for _, obj in ipairs(workspace:GetDescendants()) do

apply(obj)

end

XrayState.Connection = workspace.DescendantAdded:Connect(function(obj)

task.wait()

if XrayState.Enabled then

apply(obj)

end

end)

notify("Xray ON")

addEvidence("Command .xray used")

end

local function stopXray()

if not XrayState.Enabled then

notify("Xray already off")

return

end

XrayState.Enabled = false

if XrayState.Connection then

XrayState.Connection:Disconnect()

XrayState.Connection = nil

end

for part, oldValue in pairs(XrayState.Saved) do

if part and part.Parent then

part.LocalTransparencyModifier = oldValue

end

end

XrayState.Saved = {}

notify("Xray OFF")

end

local function startGodmodeVisual()

if GodmodeState.Enabled then

notify("Godmode already on")

return

end

GodmodeState.Enabled = true

local function apply()

local character = LocalPlayer.Character

local humanoid = character and character:FindFirstChildOfClass("Humanoid")

if not character or not humanoid then

return

end

if GodmodeState.OldMaxHealth == nil then

GodmodeState.OldMaxHealth = humanoid.MaxHealth

GodmodeState.OldHealth = humanoid.Health

end

if not GodmodeState.ForceField or not GodmodeState.ForceField.Parent then

GodmodeState.ForceField = Instance.new("ForceField")

GodmodeState.ForceField.Name = "BETA_LocalGodmodeBlueBubble"

GodmodeState.ForceField.Visible = true

GodmodeState.ForceField.Parent = character

end

pcall(function()

humanoid.MaxHealth = math.max(humanoid.MaxHealth, 1000000000)

if humanoid.Health < humanoid.MaxHealth then

humanoid.Health = humanoid.MaxHealth

end

end)

end

apply()

GodmodeState.Connection = RunService.Heartbeat:Connect(function()

if GodmodeState.Enabled then

apply()

end

end)

notify("Godmode ON")

addEvidence("Godmode enabled")

end

local function stopGodmodeVisual()

if GodmodeState.Connection then

GodmodeState.Connection:Disconnect()

GodmodeState.Connection = nil

end

if GodmodeState.ForceField and GodmodeState.ForceField.Parent then

GodmodeState.ForceField:Destroy()

end

local character = LocalPlayer.Character

local humanoid = character and character:FindFirstChildOfClass("Humanoid")

if humanoid then

pcall(function()

if GodmodeState.OldMaxHealth then

humanoid.MaxHealth = GodmodeState.OldMaxHealth

end

if GodmodeState.OldHealth then

humanoid.Health = math.clamp(GodmodeState.OldHealth, 1, humanoid.MaxHealth)

end

end)

end

GodmodeState.ForceField = nil

GodmodeState.OldMaxHealth = nil

GodmodeState.OldHealth = nil

GodmodeState.Enabled = false

notify("Godmode OFF")

end

local function isPrisonLifeCmdsLoaded()

return PlayerGui and PlayerGui:FindFirstChild("BETA_PRISON_LIFE_LOADER") ~= nil

end

local function requirePrisonLifeCmds()

if isPrisonLifeCmdsLoaded() then

return true

end

notify("Open In Game Loaders > Prison Life first")

return false

end

local setTab

local phaseDash, teleportToMouse, returnLastTeleport

Handlers.PhaseDash = function(v)

if v then

if phaseDash then

phaseDash()

else

notify("Phase Dash not ready")

end

task.defer(function()

if setToggle then

setToggle("PhaseDash", false, false)

end

end)

end

end

Handlers.GravityModifier = function(v)

if not v then

workspace.Gravity = OriginalWorkspaceGravity or 196.2

end

end

Handlers.RGBRainbowMode = function(v)

if not v then

refreshTheme()

end

end

local function runChatCommand(rawText)

local text = tostring(rawText or "")

if text:sub(1, 1) ~= "." then return false end

local now = os.clock()

if LastCommandText == text and now - LastCommandTime < 0.25 then

return true

end

LastCommandText = text

LastCommandTime = now

local command, rest = text:match("^%.(%S+)%s*(.*)$")

command = command and command:lower() or ""

rest = rest or ""

pushCommandLog(text)

if command == "cmds" or command == "commands" then

setTab("Commands")

notify("Commands opened")

return true

end

if command == "logs" then

openCommandLogsGui()

return true

end

if (command == "kill" or command == "unkill") and not requirePrisonLifeCmds() then

return true

end

if command == "tpto" then

if rest == "" then notify("Usage: .tpto player") else teleportToPlayerByName(rest) end

return true

end

if command == "near" then

if rest == "" then notify("Usage: .near player") else teleportNearPlayer(rest, 3) end

return true

end

if command == "above" then

if rest == "" then notify("Usage: .above player") else teleportNearPlayer(rest, 18) end

return true

end

if command == "back" then

backToLastTeleport()

return true

end

if command == "follow" then

if rest == "" then notify("Usage: .follow player") else startFollowPlayer(rest) end

return true

end

if command == "unfollow" then

stopFollowPlayer()

return true

end

if command == "talk" then

if rest == "" then notify("Usage: .talk player") else startTalkCommand(rest) end

return true

end

if command == "untalk" then

stopTalkCommand()

return true

end

if command == "fixchar" then

fixCharacterCommand()

return true

end

if command == "tpcells" then

if not requirePrisonLifeCmds() then return true end

teleportPrisonLocation("cells")

return true

end

if command == "tpyard" then

if not requirePrisonLifeCmds() then return true end

teleportPrisonLocation("yard")

return true

end

if command == "tparmory" then

if not requirePrisonLifeCmds() then return true end

teleportPrisonLocation("armory")

return true

end

if command == "tpcafe" then

if not requirePrisonLifeCmds() then return true end

teleportPrisonLocation("cafe")

return true

end

if command == "tpcrimbase" then

if not requirePrisonLifeCmds() then return true end

teleportPrisonLocation("crimbase")

return true

end

if command == "tpprison" then

if not requirePrisonLifeCmds() then return true end

teleportPrisonLocation("prison")

return true

end

if command == "setloc" then

if not requirePrisonLifeCmds() then return true end

saveCustomLocation(rest)

return true

end

if command == "gotoloc" then

if not requirePrisonLifeCmds() then return true end

gotoCustomLocation(rest)

return true

end

if command == "delloc" or command == "delpos" then

if not requirePrisonLifeCmds() then return true end

deleteCustomLocation(rest)

return true

end

if command == "locations" or command == "positions" then

if not requirePrisonLifeCmds() then return true end

listCustomLocations()

return true

end

if command == "copypos" then

if not requirePrisonLifeCmds() then return true end

copyCurrentPosition()

return true

end

if command == "goto" and rest:lower() == "mouse" then

if teleportToMouse then teleportToMouse() else notify("Teleport Click not ready") end

return true

end

if command == "return" then

if returnLastTeleport then returnLastTeleport() else notify("Return not ready") end

return true

end

if command == "phasedash" then

if phaseDash then phaseDash() else notify("Phase Dash not ready") end

return true

end

if command == "teleclick" then

setToggle("TeleportClick", true, true)

return true

end

if command == "unteleclick" then

setToggle("TeleportClick", false, true)

return true

end

if command == "gravity" then

local g = tonumber(rest) or _G.GravityValue or 90

setSlider("GravityValue", math.clamp(g, 20, 196))

setToggle("GravityModifier", true, true)

return true

end

if command == "ungravity" then

setToggle("GravityModifier", false, true)

workspace.Gravity = OriginalWorkspaceGravity or 196.2

return true

end

if command == "swim" then

setToggle("SwimAnywhere", true, true)

return true

end

if command == "unswim" then

setToggle("SwimAnywhere", false, true)

return true

end

if command == "freecam" then

startFreecam()

return true

end

if command == "unfreecam" then

stopFreecam()

return true

end

if command == "view" then

startViewCommand(rest)

return true

end

if command == "unview" then

stopViewCommand()

return true

end

if command == "showhitbox" then

showHitboxCommand(rest)

return true

end

if command == "unshowhitbox" then

unshowHitboxCommand(rest)

return true

end

if command == "xray" then

startXray()

return true

end

if command == "unxray" then

stopXray()

return true

end

notify("Unknown command: ." .. command)

return true

end

local function setupCommandListener()

addConn(LocalPlayer.Chatted:Connect(function(message)

runChatCommand(message)

end))

pcall(function()

addConn(TextChatService.SendingMessage:Connect(function(message)

local text = message and message.Text

if text then

runChatCommand(text)

end

end))

end)

end

local function getTracerOrigin(cam)

if _G.TracerOrigin == "Center" then

return Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

elseif _G.TracerOrigin == "Mouse" then

local m = UserInputService:GetMouseLocation()

return Vector2.new(m.X, m.Y)

end

return Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)

end

local function updateLine(line, p1, p2, thickness, color, transparency)

local dx, dy = p2.X - p1.X, p2.Y - p1.Y

local length = math.sqrt(dx * dx + dy * dy)

line.Visible = length > 1

line.BackgroundColor3 = color

line.BackgroundTransparency = transparency or 0

line.Size = UDim2.new(0, length, 0, thickness or 1)

line.Position = UDim2.new(0, (p1.X + p2.X) / 2, 0, (p1.Y + p2.Y) / 2)

line.Rotation = math.deg(math.atan2(dy, dx))

end

local function getESPColorForPlayer(plr)

if _G.ESP_Rainbow then return rainbow() end

local isFriend = false

pcall(function() isFriend = LocalPlayer:IsFriendsWith(plr.UserId) end)

if _G.ESP_FriendColor and isFriend then return getColor(_G.ESP_FriendColorPreset) end

if _G.ESP_EnemyColor then return getColor(_G.ESP_EnemyColorPreset) end

return getColor(_G.ESP_ColorPreset)

end

local function getTracerColor()

if _G.ESP_Rainbow then return rainbow() end

return getColor(_G.ESP_TracerColorPreset)

end

local function shouldHideByTeam(plr)

return _G.ESP_TeamCheck and LocalPlayer.Team and plr.Team and LocalPlayer.Team == plr.Team

end

local function isWatched(plr)

return _G.WatchList and _G.WatchList[plr.UserId] == true

end

local function createMouseDot()

if WorldMouseDotPart then WorldMouseDotPart:Destroy() end

local part = Instance.new("Part")

part.Name = "BETA_WorldMouseDot"

part.Shape = Enum.PartType.Ball

part.Size = Vector3.new(0.35, 0.35, 0.35)

part.Anchored = true

part.CanCollide = false

pcall(function() part.CanQuery = false end)

pcall(function() part.CanTouch = false end)

part.Material = Enum.Material.Neon

part.Color = C.W

part.Transparency = 1

part.Parent = workspace

WorldMouseDotPart = part

end

local function removeMouseDot()

if WorldMouseDotPart then

WorldMouseDotPart:Destroy()

WorldMouseDotPart = nil

end

end

local function showHitCham(char)

if not _G.HitChams or not char then return end

local folder = workspace:FindFirstChild("BETA_HitChams")

if not folder then

folder = Instance.new("Folder")

folder.Name = "BETA_HitChams"

folder.Parent = workspace

end

local model = Instance.new("Model")

model.Name = "HitCham_" .. tostring(os.clock())

model.Parent = folder

local realParts = {

Head = true,

HumanoidRootPart = true,

Torso = true,

UpperTorso = true,

LowerTorso = true,

["Left Arm"] = true,

["Right Arm"] = true,

["Left Leg"] = true,

["Right Leg"] = true,

LeftUpperArm = true,

LeftLowerArm = true,

LeftHand = true,

RightUpperArm = true,

RightLowerArm = true,

RightHand = true,

LeftUpperLeg = true,

LeftLowerLeg = true,

LeftFoot = true,

RightUpperLeg = true,

RightLowerLeg = true,

RightFoot = true

}

for _, part in ipairs(char:GetChildren()) do

if part:IsA("BasePart") and realParts[part.Name] then

local ghost = Instance.new("Part")

ghost.Name = part.Name

ghost.Size = part.Size

ghost.CFrame = part.CFrame

ghost.Anchored = true

ghost.CanCollide = false

ghost.CanTouch = false

ghost.CanQuery = false

ghost.Material = Enum.Material.Neon

ghost.Color = Color3.fromRGB(255, 35, 35)

ghost.Transparency = 0.35

ghost.Parent = model

TweenService:Create(ghost, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {

Transparency = 1

}):Play()

end

end

Debris:AddItem(model, 1.6)

end

function showDamageIndicator(amount, char)

if not Root or not _G.DamageIndicators then return end

local cam = workspace.CurrentCamera

local root = char and char:FindFirstChild("HumanoidRootPart")

if not cam or not root then return end

local pos, visible = cam:WorldToViewportPoint(root.Position + Vector3.new(0, 2.5, 0))

if not visible then return end

local label = Instance.new("TextLabel")

label.Size = UDim2.new(0, 90, 0, 28)

label.Position = UDim2.new(0, pos.X - 45, 0, pos.Y - 20)

label.BackgroundTransparency = 1

label.Text = "-" .. tostring(math.floor(amount))

label.Font = Enum.Font.SourceSansBold

label.TextSize = 24

label.TextColor3 = Color3.fromRGB(255, 85, 85)

label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

label.TextStrokeTransparency = 0.2

label.ZIndex = 7000

label.Parent = Root

TweenService:Create(label, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {

Position = label.Position - UDim2.new(0, 0, 0, 34),

TextTransparency = 1,

TextStrokeTransparency = 1

}):Play()

task.delay(0.6, function()

if label then label:Destroy() end

end)

end

function addKillFeedLine(textValue)

if not KillFeedFrame then return end

table.insert(KillFeedLines, 1, os.date("%H:%M:%S") .. " " .. textValue)

while #KillFeedLines > 6 do table.remove(KillFeedLines) end

for _, child in ipairs(KillFeedFrame:GetChildren()) do

if child:IsA("TextLabel") then child:Destroy() end

end

for i, line in ipairs(KillFeedLines) do

local label = Instance.new("TextLabel")

label.Size = UDim2.new(1, 0, 0, 18)

label.Position = UDim2.new(0, 0, 0, (i - 1) * 18)

label.BackgroundTransparency = 1

label.Font = getFont()

label.TextSize = 12

label.TextColor3 = C.W

label.TextStrokeTransparency = 0.35

label.TextXAlignment = Enum.TextXAlignment.Left

label.Text = line

label.ZIndex = 5200

label.Parent = KillFeedFrame

textObj(label)

end

end

function getAmmoText()

local char = LocalPlayer.Character

local tool = char and char:FindFirstChildOfClass("Tool")

if not tool then return "Ammo: No Tool" end

local ammo, reserve

for _, obj in ipairs(tool:GetDescendants()) do

local n = string.lower(obj.Name)

if obj:IsA("IntValue") or obj:IsA("NumberValue") then

if ammo == nil and (n == "ammo" or n == "clip" or n == "mag" or n == "magazine") then

ammo = obj.Value

elseif reserve == nil and (n == "reserve" or n == "reserveammo" or n == "storedammo") then

reserve = obj.Value

end

end

end

if ammo == nil and tool:GetAttribute("Ammo") ~= nil then ammo = tool:GetAttribute("Ammo") end

if reserve == nil and tool:GetAttribute("Reserve") ~= nil then reserve = tool:GetAttribute("Reserve") end

if ammo == nil then return "Ammo: " .. tool.Name end

if reserve ~= nil then return "Ammo: " .. tostring(ammo) .. " / " .. tostring(reserve) end

return "Ammo: " .. tostring(ammo)

end

phaseDash = function()

if not isAlive(LocalPlayer.Character) then

notify("Character not ready")

return

end

local root = LocalPlayer.Character.HumanoidRootPart

root.CFrame = root.CFrame + (root.CFrame.LookVector * (_G.PhaseDistance or 32))

root.AssemblyLinearVelocity = Vector3.zero

root.AssemblyAngularVelocity = Vector3.zero

notify("Phase Dash")

end

teleportToMouse = function()

if not isAlive(LocalPlayer.Character) then

notify("Character not ready")

return

end

local cam = workspace.CurrentCamera

local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

if not cam or not root then

notify("Teleport failed")

return

end

local mousePos = UserInputService:GetMouseLocation()

local ray = cam:ViewportPointToRay(mousePos.X, mousePos.Y)

local params = RaycastParams.new()

params.FilterType = Enum.RaycastFilterType.Exclude

params.FilterDescendantsInstances = {LocalPlayer.Character}

params.IgnoreWater = true

local result = workspace:Raycast(ray.Origin, ray.Direction * 2000, params)

local destination = result and result.Position or (ray.Origin + ray.Direction * 250)

LastTeleportCFrame = root.CFrame

root.CFrame = CFrame.new(destination + Vector3.new(0, 4, 0))

root.AssemblyLinearVelocity = Vector3.zero

root.AssemblyAngularVelocity = Vector3.zero

notify("Teleported to mouse")

end

returnLastTeleport = function()

if not LastTeleportCFrame then

notify("No previous teleport")

return

end

if isAlive(LocalPlayer.Character) then

LocalPlayer.Character.HumanoidRootPart.CFrame = LastTeleportCFrame + Vector3.new(0, 3, 0)

notify("Returned")

end

end

function applyRainbowAccent(col)

for _, item in ipairs(ThemeObjects) do

local obj, role = item.Object, item.Role

if obj and obj.Parent then

if role == "Accent" or role == "Fill" or role == "Knob" then

pcall(function() obj.BackgroundColor3 = col end)

elseif role == "AccentText" then

pcall(function() obj.TextColor3 = col end)

end

local s = obj:FindFirstChildOfClass("UIStroke")

if s then

s.Color = col

end

end

end

end

function showHitMarker()

if not HitMarker or not _G.HitMarkerEffect then return end

HitMarker.Visible = true

HitMarker.TextTransparency = 0

TweenService:Create(HitMarker, TweenInfo.new(0.25), {TextTransparency = 1}):Play()

task.delay(0.28, function()

if HitMarker then HitMarker.Visible = false end

end)

end

function playHitSound()

if not _G.HitMarkerSound then return end

pcall(function()

local s = Instance.new("Sound")

s.SoundId = ""

s.Volume = 0.7

s.Parent = PlayerGui

s:Play()

game:GetService("Debris"):AddItem(s, 2)

end)

end

function flashDamage()

if not _G.DamageFlash or not Root then return end

local f = Instance.new("Frame")

f.Size = UDim2.new(1, 0, 1, 0)

f.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

f.BackgroundTransparency = 0.72

f.BorderSizePixel = 0

f.ZIndex = 8000

f.Parent = Root

TweenService:Create(f, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()

task.delay(0.3, function()

if f then f:Destroy() end

end)

end

function makeSnapshot(reason)

if not isAlive(LocalPlayer.Character) then

return reason .. "\nCharacter unavailable."

end

local myRoot = LocalPlayer.Character.HumanoidRootPart

local closest = getClosestPlayerToCharacter()

local lines = {reason}

if closest and closest.Character and closest.Character:FindFirstChild("HumanoidRootPart") then

local dist = math.floor((closest.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude)

local rayParams = RaycastParams.new()

rayParams.FilterType = Enum.RaycastFilterType.Blacklist

rayParams.FilterDescendantsInstances = {LocalPlayer.Character, closest.Character}

local result = workspace:Raycast(closest.Character.HumanoidRootPart.Position, myRoot.Position - closest.Character.HumanoidRootPart.Position, rayParams)

table.insert(lines, "Closest: " .. closest.Name)

table.insert(lines, "Distance: " .. dist .. " studs")

table.insert(lines, "Tool: " .. equippedToolName(closest.Character))

table.insert(lines, "Line of Sight: " .. (result and "Blocked" or "Clear"))

else

table.insert(lines, "Closest: None")

end

local nearby = {}

for _, plr in ipairs(Players:GetPlayers()) do

if plr ~= LocalPlayer and isAlive(plr.Character) then

local d = (plr.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude

if d <= 120 then

table.insert(nearby, plr.Name .. " (" .. math.floor(d) .. ")")

end

end

end

table.insert(lines, "Nearby: " .. (#nearby > 0 and table.concat(nearby, ", ") or "None"))

return table.concat(lines, "\n")

end

function pickLockedTarget()

local plr = getClosestPlayerToMouse()

_G.CL_T = plr and plr.Character or nil

if _G.CL_T then notify("Target Locked: " .. plr.Name) end

end

function clearLockedTarget()

_G.CL_T = nil

notify("Target Cleared")

end

function setPreset(name)

if name == "Legit" then

setSlider("CL_Smoothness", 18)

setSlider("FOV_Radius", 90)

elseif name == "Smooth" then

setSlider("CL_Smoothness", 38)

setSlider("FOV_Radius", 130)

elseif name == "Fast" then

setSlider("CL_Smoothness", 5)

setSlider("FOV_Radius", 180)

elseif name == "Wide" then

setSlider("CL_Smoothness", 10)

setSlider("FOV_Radius", 275)

end

_G.FOV_Enabled = true

_G.FOV_Visible = true

setToggle("FOV_Enabled", true, true)

setToggle("FOV_Visible", true, true)

notify("Preset: " .. name)

end

function topLine(parent)

local line = Instance.new("Frame")

line.Size = UDim2.new(1, 0, 0, 1)

line.BackgroundColor3 = C.W

line.BorderSizePixel = 0

line.ZIndex = 3

line.Parent = parent

themeObj(line, "Accent")

return line

end

function page(name)

local p = Instance.new("ScrollingFrame")

p.Name = name

p.Size = UDim2.new(1, -18, 1, -18)

p.Position = UDim2.new(0, 9, 0, 9)

p.BackgroundTransparency = 1

p.BorderSizePixel = 0

p.Visible = false

p.CanvasSize = UDim2.new(0, 0, 0, 0)

p.AutomaticCanvasSize = Enum.AutomaticSize.Y

p.ScrollBarThickness = 4

p.ScrollBarImageColor3 = C.W

p.Parent = ViewFrame

if name == "Commands" or name == "Own/Troll/Funny" or name == "In Game Loaders" then

local list = Instance.new("UIListLayout")

list.Padding = UDim.new(0, 12)

list.SortOrder = Enum.SortOrder.LayoutOrder

list.Parent = p

else

local grid = Instance.new("UIGridLayout")

grid.CellPadding = UDim2.new(0, 12, 0, 12)

grid.CellSize = UDim2.new(0.5, -8, 0, 178)

grid.SortOrder = Enum.SortOrder.LayoutOrder

grid.Parent = p

end

Pages[name] = p

return p

end

function card(parent, title, order)

local frame = Instance.new("Frame")

frame.BackgroundColor3 = C.CARD

frame.BorderSizePixel = 0

frame.LayoutOrder = order or 0

frame.Name = "Card_" .. title

frame.Parent = parent

themeObj(frame, "Card")

stroke(frame, C.W, 1)

corner(frame, 8)

topLine(frame)

local label = Instance.new("TextLabel")

label.Size = UDim2.new(1, -14, 0, 22)

label.Position = UDim2.new(0, 7, 0, 2)

label.BackgroundTransparency = 1

label.Font = getFont()

label.Text = title

label.TextSize = 12

label.TextColor3 = C.W

label.TextXAlignment = Enum.TextXAlignment.Left

label.Parent = frame

themeObj(label, "AccentText")

textObj(label)

local content = Instance.new("Frame")

content.Size = UDim2.new(1, -14, 1, -28)

content.Position = UDim2.new(0, 7, 0, 25)

content.BackgroundTransparency = 1

content.Parent = frame

local layout = Instance.new("UIListLayout")

layout.Padding = UDim.new(0, 4)

layout.SortOrder = Enum.SortOrder.LayoutOrder

layout.Parent = content

table.insert(Cards, {Frame = frame, Title = string.lower(title), Page = parent})

return content, frame

end

function addQuestion(parent, title, body, x)

local q = Instance.new("TextButton")

q.Size = UDim2.new(0, 22, 0, 17)

q.Position = UDim2.new(0, x or 0, 0, 0)

q.BackgroundTransparency = 1

q.BorderSizePixel = 0

q.Text = "(?)"

q.Font = getFont()

q.TextSize = 10

q.TextColor3 = C.SUB

q.ZIndex = 50

q.Parent = parent

themeObj(q, "SubText")

textObj(q)

q.MouseEnter:Connect(function()

q.TextColor3 = C.W

if Root and Root:FindFirstChild("Tooltip") then

Root.Tooltip.Title.Text = title

Root.Tooltip.Body.Text = body

Root.Tooltip.Visible = true

end

end)

q.MouseLeave:Connect(function()

q.TextColor3 = C.SUB

if Root and Root:FindFirstChild("Tooltip") then

Root.Tooltip.Visible = false

end

end)

return q

end

function makeButton(parent, text, order, callback)

local b = Instance.new("TextButton")

b.Size = UDim2.new(1, 0, 0, 22)

b.BackgroundColor3 = C.P2

b.BorderSizePixel = 0

b.Text = text

b.Font = getFont()

b.TextSize = 11

b.TextColor3 = C.TX

b.LayoutOrder = order or 0

b.Parent = parent

themeObj(b, "Button")

textObj(b)

stroke(b, C.W, 1)

corner(b, 6)

b.MouseEnter:Connect(function()

b.BackgroundColor3 = C.A2

b.TextColor3 = C.W

end)

b.MouseLeave:Connect(function()

b.BackgroundColor3 = C.P2

b.TextColor3 = C.TX

end)

b.MouseButton1Click:Connect(function()

if _G.BETA_KILLED then return end

playUISound()

callback()

end)

return b

end

function makeToggle(parent, text, name, hasKey, order, tip, defaultValue)

local row = Instance.new("Frame")

row.Size = UDim2.new(1, 0, 0, 20)

row.BackgroundTransparency = 1

row.LayoutOrder = order or 0

row.Parent = parent

local box = Instance.new("Frame")

box.Size = UDim2.new(0, 13, 0, 13)

box.Position = UDim2.new(0, 0, 0, 3)

box.BackgroundColor3 = Color3.fromRGB(12, 12, 10)

box.BorderSizePixel = 0

box.Parent = row

stroke(box, C.W, 1)

corner(box, 3)

local check = Instance.new("Frame")

check.Size = UDim2.new(1, -4, 1, -4)

check.Position = UDim2.new(0, 2, 0, 2)

check.BackgroundColor3 = C.W

check.BorderSizePixel = 0

check.Visible = false

check.Parent = box

themeObj(check, "Accent")

corner(check, 2)

local label = Instance.new("TextLabel")

label.Size = UDim2.new(1, hasKey and -118 or -48, 1, 0)

label.Position = UDim2.new(0, 20, 0, 0)

label.BackgroundTransparency = 1

label.Text = text

label.TextSize = 11

label.Font = getFont()

label.TextColor3 = C.TX

label.TextXAlignment = Enum.TextXAlignment.Left

label.Parent = row

themeObj(label, "Text")

textObj(label)

local click = Instance.new("TextButton")

click.Size = UDim2.new(1, hasKey and -95 or 0, 1, 0)

click.Position = UDim2.new(0, 0, 0, 0)

click.Text = ""

click.BackgroundTransparency = 1

click.ZIndex = 10

click.Parent = row

if tip then addQuestion(row, text, tip, hasKey and 142 or 115) end

local keyButton

if hasKey then

keyButton = Instance.new("TextButton")

keyButton.Size = UDim2.new(0, 70, 0, 18)

keyButton.Position = UDim2.new(1, -72, 0, 1)

keyButton.BackgroundColor3 = C.P2

keyButton.BorderSizePixel = 0

keyButton.Text = "None"

keyButton.TextSize = 10

keyButton.Font = getFont()

keyButton.TextColor3 = C.SUB

keyButton.ZIndex = 20

keyButton.Parent = row

themeObj(keyButton, "Button")

textObj(keyButton)

stroke(keyButton, C.W, 1)

corner(keyButton, 4)

keyButton.MouseButton1Click:Connect(function()

if _G.BETA_KILLED then return end

CurrentWait = name

keyButton.Text = "..."

end)

end

local state = defaultValue == true

local function visual(v)

state = v

check.Visible = v

box.BackgroundColor3 = v and C.A2 or Color3.fromRGB(12, 12, 10)

label.TextColor3 = v and C.W or C.TX

end

local function set(v, fire)

visual(v)

_G[name] = v

if fire and Handlers[name] then

Handlers[name](v)

end

end

local function toggle()

if _G.BETA_KILLED then return end

set(not state, true)

end

click.MouseButton1Click:Connect(toggle)

Toggles[name] = {

Toggle = toggle,

Set = set,

SetVisual = visual,

KeyBtn = keyButton,

Row = row,

Get = function() return state end

}

visual(state)

return Toggles[name]

end

function makeSlider(parent, label, name, min, max, order, tip)

local row = Instance.new("Frame")

row.Size = UDim2.new(1, 0, 0, 34)

row.BackgroundTransparency = 1

row.LayoutOrder = order or 0

row.Parent = parent

local title = Instance.new("TextLabel")

title.Size = UDim2.new(1, -42, 0, 14)

title.Position = UDim2.new(0, 0, 0, 0)

title.Text = label .. tostring(_G[name])

title.TextSize = 11

title.Font = getFont()

title.TextColor3 = C.TX

title.BackgroundTransparency = 1

title.TextXAlignment = Enum.TextXAlignment.Left

title.Parent = row

themeObj(title, "Text")

textObj(title)

if tip then

local q = addQuestion(row, label:gsub(": ", ""), tip, 135)

q.Position = UDim2.new(0, 135, 0, -2)

end

local bar = Instance.new("Frame")

bar.Size = UDim2.new(1, -12, 0, 6)

bar.Position = UDim2.new(0, 6, 0, 22)

bar.BackgroundColor3 = C.TR

bar.BorderSizePixel = 0

bar.Active = true

bar.Parent = row

themeObj(bar, "Track")

stroke(bar, C.W, 1)

corner(bar, 4)

local fill = Instance.new("Frame")

fill.BackgroundColor3 = C.FL

fill.BorderSizePixel = 0

fill.Parent = bar

themeObj(fill, "Fill")

corner(fill, 4)

local knob = Instance.new("TextButton")

knob.Size = UDim2.new(0, 10, 0, 14)

knob.AnchorPoint = Vector2.new(0.5, 0.5)

knob.BackgroundColor3 = C.KN

knob.BorderSizePixel = 0

knob.Text = ""

knob.AutoButtonColor = false

knob.Parent = bar

themeObj(knob, "Knob")

stroke(knob, C.W, 1)

corner(knob, 4)

local dragging = false

local function set(v)

if _G.BETA_KILLED then return end

v = math.clamp(math.floor(v), min, max)

_G[name] = v

local pct = (v - min) / (max - min)

fill.Size = UDim2.new(pct, 0, 1, 0)

knob.Position = UDim2.new(pct, 0, 0.5, 0)

title.Text = label .. tostring(v)

if name == "GUI_Scale" and MainScale then MainScale.Scale = v / 100 end

if name == "UI_Opacity" then refreshTheme() end

end

local function setFromX(x)

local pct = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)

set(min + pct * (max - min))

end

set(_G[name])

local function beginDrag(input)

if _G.BETA_KILLED then return end

dragging = true

if input and input.Position then

setFromX(input.Position.X)

else

local m = UserInputService:GetMouseLocation()

setFromX(m.X)

end

end

table.insert(SliderConnections, knob.MouseButton1Down:Connect(function()

beginDrag()

end))

table.insert(SliderConnections, bar.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

beginDrag(input)

end

end))

table.insert(SliderConnections, UserInputService.InputEnded:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

dragging = false

end

end))

table.insert(SliderConnections, UserInputService.InputChanged:Connect(function(input)

if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then

dragging = false

return

end

setFromX(input.Position.X)

end

end))

table.insert(SliderConnections, RunService.RenderStepped:Connect(function()

if dragging and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then

dragging = false

end

end))

Sliders[name] = {Set = set}

return Sliders[name]

end

function makeCycle(parent, label, values, key, order, onChange)

local b

local function refresh()

if b then b.Text = label .. ": " .. tostring(_G[key]) end

end

b = makeButton(parent, label .. ": " .. tostring(_G[key]), order, function()

local current = _G[key]

local index = table.find(values, current) or 0

local nextValue = values[(index % #values) + 1]

_G[key] = nextValue

refresh()

if onChange then onChange(nextValue) end

notify(label .. ": " .. tostring(nextValue))

end)

Cycles[key] = {Refresh = refresh}

return b

end

setTab = function(name)

if not Pages[name] then return end

SelectedTab = name

_G.LastTab = name

for n, p in pairs(Pages) do p.Visible = n == name end

for n, b in pairs(TabButtons) do

local active = n == name

b.BackgroundColor3 = active and C.A2 or C.P

TabBars[n].BackgroundColor3 = active and C.W or C.A2

TabTexts[n].TextColor3 = active and C.W or C.TX

end

end

function makeTab(name, order)

local b = Instance.new("TextButton")

b.Size = UDim2.new(1, 0, 0, 27)

b.BackgroundColor3 = C.P

b.BorderSizePixel = 0

b.Text = ""

b.LayoutOrder = order

b.Parent = SideButtons

themeObj(b, "Button2")

stroke(b, C.W, 1)

corner(b, 4)

local bar = Instance.new("Frame")

bar.Size = UDim2.new(0, 3, 1, 0)

bar.BackgroundColor3 = C.A2

bar.BorderSizePixel = 0

bar.Parent = b

local t = Instance.new("TextLabel")

t.Size = UDim2.new(1, -17, 1, 0)

t.Position = UDim2.new(0, 12, 0, 0)

t.BackgroundTransparency = 1

t.Font = getFont()

t.Text = name

t.TextSize = name == "Cheater Prevention" and 10 or 12

t.TextColor3 = C.TX

t.TextXAlignment = Enum.TextXAlignment.Left

t.Parent = b

textObj(t)

b.MouseButton1Click:Connect(function() setTab(name) end)

b.MouseEnter:Connect(function() if t.TextColor3 ~= C.W then b.BackgroundColor3 = C.P2 end end)

b.MouseLeave:Connect(function() if t.TextColor3 ~= C.W then b.BackgroundColor3 = C.P end end)

TabButtons[name], TabBars[name], TabTexts[name] = b, bar, t

end

function applySearch(query)

query = string.lower(query or "")

for _, item in ipairs(Cards) do

if query == "" then

item.Frame.Visible = true

else

item.Frame.Visible = string.find(item.Title, query, 1, true) ~= nil

end

end

end

local StartupFadeData = {}

function prepareStartupGuiHidden()

StartupFadeData = {}

if not Main then return end

local function save(obj, prop)

local ok, value = pcall(function()

return obj[prop]

end)

if ok and value ~= nil then

table.insert(StartupFadeData, {Obj = obj, Prop = prop, Value = value})

pcall(function()

obj[prop] = 1

end)

end

end

local function grab(obj)

if obj:IsA("GuiObject") then

save(obj, "BackgroundTransparency")

if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then

save(obj, "TextTransparency")

save(obj, "TextStrokeTransparency")

end

if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then

save(obj, "ImageTransparency")

end

elseif obj:IsA("UIStroke") then

save(obj, "Transparency")

end

end

grab(Main)

for _, obj in ipairs(Main:GetDescendants()) do

grab(obj)

end

Main.Visible = false

end

function showStartupGuiSmoothly()

if _G.BETA_STARTUP_MAIN_FADED then return end

_G.BETA_STARTUP_MAIN_FADED = true

if not Main then return end

Main.Visible = true

for _, item in ipairs(StartupFadeData) do

if item.Obj and item.Obj.Parent then

pcall(function()

TweenService:Create(item.Obj, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {

[item.Prop] = item.Value

}):Play()

end)

end

end

end

function buildUI()

if PlayerGui:FindFirstChild("BETA_GUI") then PlayerGui.BETA_GUI:Destroy() end

Root = Instance.new("ScreenGui")

Root.Name = "BETA_GUI"

Root.ResetOnSpawn = false

Root.IgnoreGuiInset = true

Root.Parent = PlayerGui

_G.BETA_FORCE_GUI_ON_TOP(Root)

UIBeep = Instance.new("Sound")

UIBeep.Name = "BETA_UISound"

UIBeep.SoundId = ""

UIBeep.Volume = 0

UIBeep.Parent = Root

BlurEffect = Lighting:FindFirstChild("BETA_UIBlur") or Instance.new("BlurEffect")

BlurEffect.Name = "BETA_UIBlur"

BlurEffect.Size = 14

BlurEffect.Enabled = false

BlurEffect.Parent = Lighting

FOVFrame = Instance.new("Frame")

FOVFrame.Name = "BETA_FOV_FRAME"

FOVFrame.BackgroundTransparency = 1

FOVFrame.BorderSizePixel = 0

FOVFrame.Visible = false

FOVFrame.Parent = Root

FOVCorner = corner(FOVFrame, 999)

stroke(FOVFrame, C.W, 2)

FOVCross = Instance.new("Frame")

FOVCross.Name = "BETA_FOV_CROSS"

FOVCross.BackgroundTransparency = 1

FOVCross.Visible = false

FOVCross.Parent = Root

local fcx = Instance.new("Frame")

fcx.AnchorPoint = Vector2.new(0.5, 0.5)

fcx.Size = UDim2.new(1, 0, 0, 2)

fcx.Position = UDim2.new(0.5, 0, 0.5, 0)

fcx.BackgroundColor3 = C.W

fcx.BorderSizePixel = 0

fcx.Parent = FOVCross

local fcy = Instance.new("Frame")

fcy.AnchorPoint = Vector2.new(0.5, 0.5)

fcy.Size = UDim2.new(0, 2, 1, 0)

fcy.Position = UDim2.new(0.5, 0, 0.5, 0)

fcy.BackgroundColor3 = C.W

fcy.BorderSizePixel = 0

fcy.Parent = FOVCross

Crosshair = Instance.new("Frame")

Crosshair.Name = "BETA_CROSSHAIR"

Crosshair.Size = UDim2.new(0, 120, 0, 120)

Crosshair.Position = UDim2.new(0.5, -60, 0.5, -60)

Crosshair.BackgroundTransparency = 1

Crosshair.Visible = false

Crosshair.Parent = Root

local function crossPiece(name)

local f = Instance.new("Frame")

f.Name = name

f.BackgroundColor3 = getColor(_G.CrosshairColorPreset)

f.BorderSizePixel = 0

f.Parent = Crosshair

return f

end

CrossParts.Left = crossPiece("Left")

CrossParts.Right = crossPiece("Right")

CrossParts.Up = crossPiece("Up")

CrossParts.Down = crossPiece("Down")

CrossParts.Dot = crossPiece("Dot")

CrossParts.Dot.Size = UDim2.new(0, 4, 0, 4)

LowHPOverlay = Instance.new("TextLabel")

LowHPOverlay.Size = UDim2.new(0, 300, 0, 40)

LowHPOverlay.Position = UDim2.new(0.5, -150, 0.14, 0)

LowHPOverlay.BackgroundTransparency = 1

LowHPOverlay.Text = "LOW HP"

LowHPOverlay.Font = getFont()

LowHPOverlay.TextSize = 28

LowHPOverlay.TextColor3 = Color3.fromRGB(255, 70, 70)

LowHPOverlay.Visible = false

LowHPOverlay.Parent = Root

textObj(LowHPOverlay)

HitMarker = Instance.new("TextLabel")

HitMarker.Size = UDim2.new(0, 70, 0, 70)

HitMarker.Position = UDim2.new(0.5, -35, 0.5, -35)

HitMarker.BackgroundTransparency = 1

HitMarker.Text = "X"

HitMarker.Font = getFont()

HitMarker.TextSize = 36

HitMarker.TextColor3 = Color3.fromRGB(255, 255, 255)

HitMarker.TextTransparency = 1

HitMarker.Visible = false

HitMarker.Parent = Root

textObj(HitMarker)

WatermarkLabel = Instance.new("TextLabel")

WatermarkLabel.Size = UDim2.new(0, 370, 0, 22)

WatermarkLabel.Position = UDim2.new(0, 10, 0, 8)

WatermarkLabel.BackgroundColor3 = C.CARD

WatermarkLabel.BackgroundTransparency = 0.2

WatermarkLabel.BorderSizePixel = 0

WatermarkLabel.Font = getFont()

WatermarkLabel.TextSize = 11

WatermarkLabel.TextColor3 = C.W

WatermarkLabel.TextXAlignment = Enum.TextXAlignment.Left

WatermarkLabel.Parent = Root

themeObj(WatermarkLabel, "Card")

textObj(WatermarkLabel)

stroke(WatermarkLabel, C.W, 1)

corner(WatermarkLabel, 6)

local wpad = Instance.new("UIPadding")

wpad.PaddingLeft = UDim.new(0, 8)

wpad.Parent = WatermarkLabel

TargetInfoOverlay = Instance.new("TextLabel")

TargetInfoOverlay.Name = "BETA_TargetInfoOverlay"

TargetInfoOverlay.Size = UDim2.new(0, 500, 0, 80)

TargetInfoOverlay.Position = UDim2.new(0.5, -250, 1, -122)

TargetInfoOverlay.BackgroundTransparency = 1

TargetInfoOverlay.BorderSizePixel = 0

TargetInfoOverlay.Font = Enum.Font.Code

TargetInfoOverlay.TextSize = 15

TargetInfoOverlay.TextColor3 = C.W

TargetInfoOverlay.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

TargetInfoOverlay.TextStrokeTransparency = 0.25

TargetInfoOverlay.TextWrapped = true

TargetInfoOverlay.TextXAlignment = Enum.TextXAlignment.Center

TargetInfoOverlay.TextYAlignment = Enum.TextYAlignment.Center

TargetInfoOverlay.Visible = false

TargetInfoOverlay.ZIndex = 6000

TargetInfoOverlay.Parent = Root

themeObj(TargetInfoOverlay, "AccentText")

textObj(TargetInfoOverlay)

KillFeedFrame = Instance.new("Frame")

KillFeedFrame.Name = "BETA_KillFeed"

KillFeedFrame.Size = UDim2.new(0, 330, 0, 120)

KillFeedFrame.Position = UDim2.new(0, 12, 0.35, 0)

KillFeedFrame.BackgroundTransparency = 1

KillFeedFrame.Visible = false

KillFeedFrame.ZIndex = 5200

KillFeedFrame.Parent = Root

AmmoCounterLabel = Instance.new("TextLabel")

AmmoCounterLabel.Name = "BETA_AmmoCounter"

AmmoCounterLabel.Size = UDim2.new(0, 230, 0, 36)

AmmoCounterLabel.Position = UDim2.new(1, -250, 1, -84)

AmmoCounterLabel.BackgroundColor3 = C.CARD

AmmoCounterLabel.BackgroundTransparency = 0.2

AmmoCounterLabel.BorderSizePixel = 0

AmmoCounterLabel.Font = Enum.Font.Code

AmmoCounterLabel.TextSize = 17

AmmoCounterLabel.TextColor3 = C.W

AmmoCounterLabel.TextStrokeTransparency = 0.4

AmmoCounterLabel.Text = "Ammo: --"

AmmoCounterLabel.Visible = false

AmmoCounterLabel.ZIndex = 5400

AmmoCounterLabel.Parent = Root

themeObj(AmmoCounterLabel, "Card")

textObj(AmmoCounterLabel)

stroke(AmmoCounterLabel, C.W, 1)

corner(AmmoCounterLabel, 4)

NotifHolder = Instance.new("Frame")

NotifHolder.Size = UDim2.new(0, 240, 0, 300)

NotifHolder.BackgroundTransparency = 1

NotifHolder.Parent = Root

local notifLayout = Instance.new("UIListLayout")

notifLayout.Padding = UDim.new(0, 6)

notifLayout.SortOrder = Enum.SortOrder.LayoutOrder

notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top

notifLayout.Parent = NotifHolder

setNotifPosition()

local tooltip = Instance.new("Frame")

tooltip.Name = "Tooltip"

tooltip.Size = UDim2.new(0, 245, 0, 54)

tooltip.BackgroundColor3 = C.CARD

tooltip.BorderSizePixel = 0

tooltip.Visible = false

tooltip.ZIndex = 9000

tooltip.Parent = Root

themeObj(tooltip, "Card")

stroke(tooltip, C.W, 1)

corner(tooltip, 6)

local tt = Instance.new("TextLabel")

tt.Name = "Title"

tt.Size = UDim2.new(1, -12, 0, 18)

tt.Position = UDim2.new(0, 6, 0, 4)

tt.BackgroundTransparency = 1

tt.Font = getFont()

tt.TextSize = 12

tt.TextColor3 = C.W

tt.TextXAlignment = Enum.TextXAlignment.Left

tt.ZIndex = 9001

tt.Parent = tooltip

themeObj(tt, "AccentText")

textObj(tt)

local tb = Instance.new("TextLabel")

tb.Name = "Body"

tb.Size = UDim2.new(1, -12, 1, -24)

tb.Position = UDim2.new(0, 6, 0, 23)

tb.BackgroundTransparency = 1

tb.Font = getFont()

tb.TextSize = 11

tb.TextColor3 = C.TX

tb.TextWrapped = true

tb.TextXAlignment = Enum.TextXAlignment.Left

tb.TextYAlignment = Enum.TextYAlignment.Top

tb.ZIndex = 9001

tb.Parent = tooltip

themeObj(tb, "Text")

textObj(tb)

Main = Instance.new("Frame")

Main.Name = "Main"

Main.Size = UDim2.new(0, 900, 0, 590)

Main.Position = UDim2.new(0.5, -450, 0.5, -295)

Main.BackgroundColor3 = C.M

Main.BorderSizePixel = 0

Main.Parent = Root

themeObj(Main, "Main")

stroke(Main, Color3.fromRGB(0, 0, 0), 2)

corner(Main, 8)

MainScale = Instance.new("UIScale")

MainScale.Scale = _G.GUI_Scale / 100

MainScale.Parent = Main

MiniBar = Instance.new("TextButton")

MiniBar.Name = "MiniBar"

MiniBar.Size = UDim2.new(0, 250, 0, 32)

MiniBar.Position = UDim2.new(0.5, -125, 0, 60)

MiniBar.BackgroundColor3 = C.CARD

MiniBar.BorderSizePixel = 0

MiniBar.Text = "BETA GUI - MINI"

MiniBar.Font = getFont()

MiniBar.TextSize = 13

MiniBar.TextColor3 = C.W

MiniBar.Visible = false

MiniBar.Parent = Root

themeObj(MiniBar, "Card")

textObj(MiniBar)

stroke(MiniBar, C.W, 1)

corner(MiniBar, 8)

MiniBar.MouseButton1Click:Connect(function()

_G.MiniMode = false

Main.Visible = true

MiniBar.Visible = false

end)

local top = Instance.new("Frame")

top.Name = "Top"

top.Size = UDim2.new(1, 0, 0, 34)

top.BackgroundColor3 = C.T

top.BorderSizePixel = 0

top.Active = true

top.Parent = Main

themeObj(top, "Top")

stroke(top, C.W, 1)

local line = Instance.new("Frame")

line.Size = UDim2.new(1, 0, 0, 1)

line.BackgroundColor3 = C.W

line.BorderSizePixel = 0

line.ZIndex = 5

line.Parent = top

themeObj(line, "Accent")

local title = Instance.new("TextLabel")

title.Name = "SakuraHUBFreeTitle"

title.Size = UDim2.new(1, -260, 1, 0)

title.Position = UDim2.new(0, 14, 0, 0)

title.BackgroundTransparency = 1

title.Font = getFont()

title.Text = "SakuraHUB Free Version | https://discord.gg/BTEbHUqzzU"

title.TextSize = 11

title.TextColor3 = C.W

title.TextXAlignment = Enum.TextXAlignment.Left

title.TextYAlignment = Enum.TextYAlignment.Center

title.TextTruncate = Enum.TextTruncate.AtEnd

title.ZIndex = 6

title.Parent = top

themeObj(title, "AccentText")

textObj(title)

title.Name = "SakuraHUBFreeTitle"

title.Text = "SakuraHUB Free Version | https://discord.gg/BTEbHUqzzU"

title.TextSize = 11

title.TextScaled = false

title.TextWrapped = false

title.TextTruncate = Enum.TextTruncate.AtEnd

title.TextXAlignment = Enum.TextXAlignment.Left

title.Size = UDim2.new(1, -260, 1, 0)

title.Position = UDim2.new(0, 14, 0, 0)

for _, child in ipairs(top:GetChildren()) do

if child:IsA("TextLabel") and child ~= title then

child:Destroy()

end

end

local oldLogo = top:FindFirstChild("SakuraHUBTopRightP")

if oldLogo then

oldLogo:Destroy()

end

local logoBox = Instance.new("Frame")

logoBox.Name = "SakuraHUBTopRightP"

logoBox.Size = UDim2.new(0, 38, 0, 26)

logoBox.AnchorPoint = Vector2.new(1, 0)

logoBox.Position = UDim2.new(1, -12, 0, 12)

logoBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

logoBox.BackgroundTransparency = 0

logoBox.BorderSizePixel = 0

logoBox.Active = true

logoBox.ZIndex = 7

logoBox.Parent = Root

local logoStroke = Instance.new("UIStroke")

logoStroke.Color = Color3.fromRGB(255, 0, 0)

logoStroke.Thickness = 1

logoStroke.Transparency = 0.1

logoStroke.Parent = logoBox

local pLogo = Instance.new("TextLabel")

pLogo.Name = "P"

pLogo.Size = UDim2.new(1, 0, 1, 0)

pLogo.Position = UDim2.new(0, 0, 0, -1)

pLogo.BackgroundTransparency = 1

pLogo.Text = "P"

pLogo.Font = Enum.Font.GothamBlack

pLogo.TextScaled = true

pLogo.TextColor3 = Color3.fromRGB(255, 25, 25)

pLogo.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

pLogo.TextStrokeTransparency = 0.1

pLogo.ZIndex = 8

pLogo.Parent = logoBox

local discordInviteOpen = false

local function showDiscordInvitePopup()

if discordInviteOpen then return end

discordInviteOpen = true

local oldInvite = Root:FindFirstChild("SakuraHUBDiscordInvite")

if oldInvite then

oldInvite:Destroy()

end

local invite = Instance.new("Frame")

invite.Name = "SakuraHUBDiscordInvite"

invite.Size = UDim2.new(0, 370, 0, 125)

invite.Position = UDim2.new(1, -385, 0, 62)

invite.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

invite.BackgroundTransparency = 0.05

invite.BorderSizePixel = 0

invite.ZIndex = 999998

invite.Parent = Root

local inviteStroke = Instance.new("UIStroke")

inviteStroke.Color = Color3.fromRGB(255, 0, 0)

inviteStroke.Thickness = 2

inviteStroke.Transparency = 0.15

inviteStroke.Parent = invite

local inviteTitle = Instance.new("TextLabel")

inviteTitle.Size = UDim2.new(1, -44, 0, 30)

inviteTitle.Position = UDim2.new(0, 10, 0, 5)

inviteTitle.BackgroundTransparency = 1

inviteTitle.Text = "Join Discord?"

inviteTitle.Font = Enum.Font.GothamBold

inviteTitle.TextSize = 15

inviteTitle.TextColor3 = Color3.fromRGB(255, 60, 60)

inviteTitle.TextXAlignment = Enum.TextXAlignment.Left

inviteTitle.ZIndex = 999999

inviteTitle.Parent = invite

local closeInvite = Instance.new("TextButton")

closeInvite.Size = UDim2.new(0, 30, 0, 26)

closeInvite.Position = UDim2.new(1, -35, 0, 4)

closeInvite.BackgroundTransparency = 1

closeInvite.Text = "X"

closeInvite.Font = Enum.Font.GothamBold

closeInvite.TextSize = 14

closeInvite.TextColor3 = Color3.fromRGB(255, 80, 80)

closeInvite.ZIndex = 999999

closeInvite.Parent = invite

local copyButton = Instance.new("TextButton")

copyButton.Size = UDim2.new(1, -20, 0, 34)

copyButton.Position = UDim2.new(0, 10, 0, 44)

copyButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

copyButton.BorderSizePixel = 0

copyButton.Text = "https://discord.gg/rGExJBsGU"

copyButton.Font = Enum.Font.Code

copyButton.TextSize = 13

copyButton.TextColor3 = Color3.fromRGB(245, 209, 92)

copyButton.TextXAlignment = Enum.TextXAlignment.Center

copyButton.ZIndex = 999999

copyButton.Parent = invite

local copyStroke = Instance.new("UIStroke")

copyStroke.Color = Color3.fromRGB(245, 209, 92)

copyStroke.Thickness = 1

copyStroke.Transparency = 0.35

copyStroke.Parent = copyButton

local copiedText = Instance.new("TextLabel")

copiedText.Size = UDim2.new(1, -20, 0, 18)

copiedText.Position = UDim2.new(0, 10, 0, 92)

copiedText.BackgroundTransparency = 1

copiedText.Text = ""

copiedText.Font = Enum.Font.Code

copiedText.TextSize = 11

copiedText.TextColor3 = Color3.fromRGB(80, 255, 130)

copiedText.TextTransparency = 1

copiedText.TextXAlignment = Enum.TextXAlignment.Center

copiedText.ZIndex = 999999

copiedText.Parent = invite

copyButton.MouseButton1Click:Connect(function()

local copied = false

if typeof(setclipboard) == "function" then

copied = pcall(function()

setclipboard("https://discord.gg/rGExJBsGU")

end)

end

copiedText.Text = copied and "copied to clipboard" or "clipboard unavailable in Roblox"

copiedText.TextColor3 = copied and Color3.fromRGB(80, 255, 130) or Color3.fromRGB(255, 90, 90)

TweenService:Create(copiedText, TweenInfo.new(0.12), {

TextTransparency = 0

}):Play()

task.delay(0.85, function()

if copiedText and copiedText.Parent then

TweenService:Create(copiedText, TweenInfo.new(0.22), {

TextTransparency = 1

}):Play()

end

end)

end)

local note = Instance.new("TextLabel")

note.Size = UDim2.new(1, -20, 0, 18)

note.Position = UDim2.new(0, 10, 0, 80)

note.BackgroundTransparency = 1

note.Text = "Copy the link and paste it into your browser."

note.Font = Enum.Font.Code

note.TextSize = 10

note.TextColor3 = Color3.fromRGB(180, 170, 140)

note.TextXAlignment = Enum.TextXAlignment.Center

note.ZIndex = 999999

note.Parent = invite

closeInvite.MouseButton1Click:Connect(function()

discordInviteOpen = false

invite:Destroy()

end)

task.delay(10, function()

if invite and invite.Parent then

discordInviteOpen = false

invite:Destroy()

end

end)

end

logoBox.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

showDiscordInvitePopup()

end

end)

logoBox.MouseEnter:Connect(function()

TweenService:Create(logoBox, TweenInfo.new(0.12), {

BackgroundTransparency = 0.7

}):Play()

TweenService:Create(logoStroke, TweenInfo.new(0.12), {

Transparency = 0.55

}):Play()

TweenService:Create(pLogo, TweenInfo.new(0.12), {

TextTransparency = 0.45,

TextStrokeTransparency = 0.65

}):Play()

end)

logoBox.MouseLeave:Connect(function()

TweenService:Create(logoBox, TweenInfo.new(0.12), {

BackgroundTransparency = 0

}):Play()

TweenService:Create(logoStroke, TweenInfo.new(0.12), {

Transparency = 0.1

}):Play()

TweenService:Create(pLogo, TweenInfo.new(0.12), {

TextTransparency = 0,

TextStrokeTransparency = 0.1

}):Play()

end)

local kill = Instance.new("TextButton")

kill.Size = UDim2.new(0, 110, 0, 22)

kill.Position = UDim2.new(1, -124, 0, 6)

kill.BackgroundColor3 = C.RED2

kill.BorderSizePixel = 0

kill.Text = "Kill Script"

kill.Font = getFont()

kill.TextSize = 12

kill.TextColor3 = Color3.fromRGB(255, 222, 222)

kill.AutoButtonColor = true

kill.ZIndex = 500

kill.Parent = top

textObj(kill)

stroke(kill, C.RED, 1)

corner(kill, 4)

local side = Instance.new("Frame")

side.Name = "Side"

side.Size = UDim2.new(0, 180, 1, -34)

side.Position = UDim2.new(0, 0, 0, 34)

side.BackgroundColor3 = C.S

side.BorderSizePixel = 0

side.Parent = Main

themeObj(side, "Side")

stroke(side, C.W, 1)

local view = Instance.new("Frame")

view.Name = "View"

view.Size = UDim2.new(1, -180, 1, -34)

view.Position = UDim2.new(0, 180, 0, 34)

view.BackgroundColor3 = C.V

view.BorderSizePixel = 0

view.Parent = Main

ViewFrame = view

themeObj(view, "View")

stroke(view, C.W, 1)

local sideHeader = Instance.new("TextLabel")

sideHeader.Size = UDim2.new(1, -20, 0, 25)

sideHeader.Position = UDim2.new(0, 10, 0, 8)

sideHeader.BackgroundTransparency = 1

sideHeader.Font = getFont()

sideHeader.Text = "MENU"

sideHeader.TextSize = 15

sideHeader.TextColor3 = C.W

sideHeader.TextXAlignment = Enum.TextXAlignment.Left

sideHeader.Parent = side

themeObj(sideHeader, "AccentText")

textObj(sideHeader)

SearchBox = Instance.new("TextBox")

SearchBox.Size = UDim2.new(1, -20, 0, 24)

SearchBox.Position = UDim2.new(0, 10, 0, 36)

SearchBox.BackgroundColor3 = C.P2

SearchBox.BorderSizePixel = 0

SearchBox.PlaceholderText = "Search..."

SearchBox.Text = ""

SearchBox.Font = getFont()

SearchBox.TextSize = 11

SearchBox.TextColor3 = C.TX

SearchBox.PlaceholderColor3 = C.SUB

SearchBox.Parent = side

themeObj(SearchBox, "Button")

textObj(SearchBox)

stroke(SearchBox, C.W, 1)

corner(SearchBox, 5)

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()

applySearch(SearchBox.Text)

end)

local sideButtonHolder = Instance.new("Frame")

sideButtonHolder.Name = "Buttons"

sideButtonHolder.Size = UDim2.new(1, -20, 1, -78)

sideButtonHolder.Position = UDim2.new(0, 10, 0, 70)

sideButtonHolder.BackgroundTransparency = 1

sideButtonHolder.BorderSizePixel = 0

sideButtonHolder.Parent = side

SideButtons = sideButtonHolder

local sideLayout = Instance.new("UIListLayout")

sideLayout.Padding = UDim.new(0, 5)

sideLayout.SortOrder = Enum.SortOrder.LayoutOrder

sideLayout.Parent = sideButtonHolder

kill.MouseButton1Click:Connect(function()

if _G.BETA_KILL_CURRENT then _G.BETA_KILL_CURRENT() end

end)

local dragButton = Instance.new("TextButton")

dragButton.Name = "BetterDragButton"

dragButton.Size = UDim2.new(1, -130, 1, 0)

dragButton.Position = UDim2.new(0, 0, 0, 0)

dragButton.BackgroundTransparency = 1

dragButton.Text = ""

dragButton.BorderSizePixel = 0

dragButton.AutoButtonColor = false

dragButton.ZIndex = 100

dragButton.Parent = top

title.ZIndex = 300

line.ZIndex = 300

kill.ZIndex = 500

local dragging, dragStartMouse, dragStartPos = false, nil, nil

dragButton.MouseButton1Down:Connect(function()

if _G.BETA_KILLED or _G.GuiLockPosition then return end

dragging = true

local m = UserInputService:GetMouseLocation()

dragStartMouse = Vector2.new(m.X, m.Y)

dragStartPos = Main.Position

end)

addConn(UserInputService.InputEnded:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

dragging = false

dragStartMouse = nil

dragStartPos = nil

end

end))

addConn(RunService.RenderStepped:Connect(function()

if _G.BETA_KILLED then return end

if dragging and dragStartMouse and dragStartPos and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then

local m = UserInputService:GetMouseLocation()

local delta = Vector2.new(m.X, m.Y) - dragStartMouse

Main.Position = UDim2.new(

dragStartPos.X.Scale,

dragStartPos.X.Offset + delta.X,

dragStartPos.Y.Scale,

dragStartPos.Y.Offset + delta.Y

)

end

end))

makeTab("Favorites", 1)

makeTab("Combat", 2)

makeTab("Player", 3)

makeTab("Visuals", 4)

makeTab("Cheater Prevention", 5)

makeTab("Commands", 6)

makeTab("Own/Troll/Funny", 7)

makeTab("In Game Loaders", 8)

makeTab("Misc", 9)

return Root

end

Handlers.ESP_Enabled = function(v)

if Toggles.ESP then Toggles.ESP.Set(v, true) end

end

Handlers.ESP = function(enabled)

_G.ESP_Enabled = enabled

if _G.ESP_SCR then

if PlayerGui:FindFirstChild("B_ESP") then PlayerGui.B_ESP:Destroy() end

if PlayerGui:FindFirstChild("B_TRC") then PlayerGui.B_TRC:Destroy() end

if PlayerGui:FindFirstChild("B_ESP_BOX") then PlayerGui.B_ESP_BOX:Destroy() end

if PlayerGui:FindFirstChild("B_ESP_SKEL") then PlayerGui.B_ESP_SKEL:Destroy() end

if PlayerGui:FindFirstChild("B_ESP_ARROWS") then PlayerGui.B_ESP_ARROWS:Destroy() end

pcall(function() _G.ESP_SCR:Disconnect() end)

_G.ESP_SCR = nil

end

if not enabled then

notify("ESP Disabled")

return

end

notify("ESP Enabled")

local camera = workspace.CurrentCamera

local espConnections = {}

local espGui = Instance.new("ScreenGui")

espGui.Name = "B_ESP"

espGui.ResetOnSpawn = false

espGui.IgnoreGuiInset = true

espGui.Parent = PlayerGui

local tracerGui = Instance.new("ScreenGui")

tracerGui.Name = "B_TRC"

tracerGui.ResetOnSpawn = false

tracerGui.IgnoreGuiInset = true

tracerGui.Parent = PlayerGui

local boxGui = Instance.new("ScreenGui")

boxGui.Name = "B_ESP_BOX"

boxGui.ResetOnSpawn = false

boxGui.IgnoreGuiInset = true

boxGui.Parent = PlayerGui

local skelGui = Instance.new("ScreenGui")

skelGui.Name = "B_ESP_SKEL"

skelGui.ResetOnSpawn = false

skelGui.IgnoreGuiInset = true

skelGui.Parent = PlayerGui

local arrowGui = Instance.new("ScreenGui")

arrowGui.Name = "B_ESP_ARROWS"

arrowGui.ResetOnSpawn = false

arrowGui.IgnoreGuiInset = true

arrowGui.Parent = PlayerGui

local folder = Instance.new("Folder")

folder.Name = "Container"

folder.Parent = espGui

local function setup(plr)

if plr == LocalPlayer then return end

local function onChar(char)

local hrp = char:WaitForChild("HumanoidRootPart", 5)

if not hrp then return end

local h = Instance.new("Highlight")

h.FillTransparency = 0.55

h.OutlineTransparency = 0

h.Adornee = char

h.Parent = folder

local bg = Instance.new("BillboardGui")

bg.Size = UDim2.new(0, 130, 0, 52)

bg.Adornee = hrp

bg.AlwaysOnTop = true

bg.StudsOffset = Vector3.new(0, 3, 0)

bg.Parent = folder

local nameLabel = Instance.new("TextLabel")

nameLabel.Size = UDim2.new(1, 0, 0, 16)

nameLabel.BackgroundTransparency = 1

nameLabel.Text = plr.Name

nameLabel.Font = getFont()

nameLabel.TextSize = 13

nameLabel.Parent = bg

textObj(nameLabel)

local distLabel = Instance.new("TextLabel")

distLabel.Size = UDim2.new(1, 0, 0, 16)

distLabel.Position = UDim2.new(0, 0, 0, 16)

distLabel.BackgroundTransparency = 1

distLabel.Font = getFont()

distLabel.TextSize = 12

distLabel.TextColor3 = C.W

distLabel.TextStrokeTransparency = 0.25

distLabel.Parent = bg

textObj(distLabel)

local toolLabel = Instance.new("TextLabel")

toolLabel.Size = UDim2.new(1, 0, 0, 16)

toolLabel.Position = UDim2.new(0, 0, 0, 32)

toolLabel.BackgroundTransparency = 1

toolLabel.Font = getFont()

toolLabel.TextSize = 10

toolLabel.TextColor3 = C.SUB

toolLabel.Parent = bg

textObj(toolLabel)

local tracer = Instance.new("Frame")

tracer.BorderSizePixel = 0

tracer.AnchorPoint = Vector2.new(0.5, 0.5)

tracer.Visible = false

tracer.Parent = tracerGui

local boxFrames = {}

for i = 1, 4 do

local f = Instance.new("Frame")

f.BorderSizePixel = 0

f.Visible = false

f.Parent = boxGui

boxFrames[i] = f

end

local healthBack = Instance.new("Frame")

healthBack.BackgroundColor3 = Color3.fromRGB(20,20,20)

healthBack.BorderSizePixel = 0

healthBack.Visible = false

healthBack.Parent = boxGui

local healthFill = Instance.new("Frame")

healthFill.BackgroundColor3 = Color3.fromRGB(80,255,130)

healthFill.BorderSizePixel = 0

healthFill.Parent = healthBack

local skelLines = {}

for i = 1, 12 do

local f = Instance.new("Frame")

f.BorderSizePixel = 0

f.AnchorPoint = Vector2.new(0.5, 0.5)

f.Visible = false

f.Parent = skelGui

skelLines[i] = f

end

local arrow = Instance.new("TextLabel")

arrow.Size = UDim2.new(0, 28, 0, 28)

arrow.BackgroundTransparency = 1

arrow.Text = "▲"

arrow.Font = getFont()

arrow.TextSize = 24

arrow.Visible = false

arrow.Parent = arrowGui

textObj(arrow)

local function setListVisible(list, visible)

for _, item in ipairs(list) do item.Visible = visible end

end

local function partPos(part)

if not part or not part:IsA("BasePart") then return nil end

local ok, pos, vis = pcall(function()

return workspace.CurrentCamera:WorldToViewportPoint(part.Position)

end)

if not ok or not vis then return nil end

return Vector2.new(pos.X, pos.Y)

end

local conn

conn = RunService.RenderStepped:Connect(function()

if _G.BETA_KILLED then

pcall(function()

tracer:Destroy(); bg:Destroy(); h:Destroy(); arrow:Destroy(); healthBack:Destroy()

for _, f in ipairs(boxFrames) do f:Destroy() end

for _, f in ipairs(skelLines) do f:Destroy() end

conn:Disconnect()

end)

return

end

if not plr.Parent or not char.Parent or not hrp.Parent then

tracer:Destroy(); bg:Destroy(); h:Destroy(); arrow:Destroy(); healthBack:Destroy()

for _, f in ipairs(boxFrames) do f:Destroy() end

for _, f in ipairs(skelLines) do f:Destroy() end

conn:Disconnect()

return

end

local baseVisible = true

if not isAlive(LocalPlayer.Character) then baseVisible = false end

if shouldHideByTeam(plr) then baseVisible = false end

if _G.ESP_LockedOnly and _G.CL_T ~= char then baseVisible = false end

if _G.ESP_HideWhenGuiHidden and Main and not Main.Visible then baseVisible = false end

local dist = math.huge

if baseVisible then

dist = math.floor((hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)

if dist > (_G.ESP_DistanceLimit or 1000) then baseVisible = false end

end

local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)

local color = isWatched(plr) and getColor(_G.WatchColorPreset) or getESPColorForPlayer(plr)

local tracerColor = getTracerColor()

h.FillColor = color

h.OutlineColor = color

h.Enabled = baseVisible

nameLabel.TextColor3 = color

distLabel.TextColor3 = C.TX

toolLabel.TextColor3 = C.SUB

nameLabel.Visible = _G.ESP_Names_Enabled

distLabel.Visible = _G.ESP_Distance_Enabled

toolLabel.Visible = _G.ESP_ToolName

distLabel.Text = dist ~= math.huge and (dist .. " studs") or ""

toolLabel.Text = "Tool: " .. equippedToolName(char)

bg.Enabled = baseVisible and (_G.ESP_Names_Enabled or _G.ESP_Distance_Enabled or _G.ESP_ToolName)

tracer.Visible = baseVisible and _G.ESP_Tracers_Enabled and vis

if tracer.Visible then

updateLine(

tracer,

getTracerOrigin(camera),

Vector2.new(pos.X, pos.Y),

math.clamp(_G.TracerThickness or 1, 1, 8),

tracerColor,

math.clamp((_G.TracerTransparency or 0) / 100, 0, 0.95)

)

end

setListVisible(boxFrames, false)

healthBack.Visible = false

local head = char:FindFirstChild("Head")

local root = char:FindFirstChild("HumanoidRootPart")

local hum = char:FindFirstChild("Humanoid")

if baseVisible and head and root and (_G.ESP_Box_Enabled or _G.ESP_HealthBar) then

local headPos, headVis = workspace.CurrentCamera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))

local rootPos, rootVis = workspace.CurrentCamera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

if headVis or rootVis then

local height = math.clamp(math.abs(rootPos.Y - headPos.Y), 34, 450)

local width = math.clamp(height * 0.52, 16, 220)

local x = headPos.X - width / 2

local y = headPos.Y

local thick = math.clamp(_G.ESP_BoxThickness or 1, 1, 8)

if _G.ESP_Box_Enabled then

for _, f in ipairs(boxFrames) do

f.BackgroundColor3 = color

f.Visible = true

end

boxFrames[1].Size = UDim2.new(0, width, 0, thick)

boxFrames[1].Position = UDim2.new(0, x, 0, y)

boxFrames[2].Size = UDim2.new(0, width, 0, thick)

boxFrames[2].Position = UDim2.new(0, x, 0, y + height)

boxFrames[3].Size = UDim2.new(0, thick, 0, height)

boxFrames[3].Position = UDim2.new(0, x, 0, y)

boxFrames[4].Size = UDim2.new(0, thick, 0, height)

boxFrames[4].Position = UDim2.new(0, x + width, 0, y)

end

if _G.ESP_HealthBar and hum then

local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)

healthBack.Visible = true

healthBack.Size = UDim2.new(0, 4, 0, height)

healthBack.Position = UDim2.new(0, x - 8, 0, y)

healthFill.Size = UDim2.new(1, 0, pct, 0)

healthFill.Position = UDim2.new(0, 0, 1 - pct, 0)

end

end

end

setListVisible(skelLines, false)

if baseVisible and _G.ESP_Skeleton_Enabled and char and typeof(char) == "Instance" and char:IsA("Model") then

local ok = pcall(function()

local function child(name)

local part = char:FindFirstChild(name)

if part and part:IsA("BasePart") then

return part

end

return nil

end

local torso = child("UpperTorso") or child("Torso") or root

local parts = {

Head = child("Head"),

Torso = torso,

Root = root,

LA = child("LeftUpperArm") or child("Left Arm"),

RA = child("RightUpperArm") or child("Right Arm"),

LH = child("LeftHand") or child("LeftLowerArm") or child("Left Arm"),

RH = child("RightHand") or child("RightLowerArm") or child("Right Arm"),

LL = child("LeftUpperLeg") or child("Left Leg"),

RL = child("RightUpperLeg") or child("Right Leg"),

LF = child("LeftFoot") or child("LeftLowerLeg") or child("Left Leg"),

RF = child("RightFoot") or child("RightLowerLeg") or child("Right Leg")

}

local drawPairs = {

{"Head","Torso"},

{"Torso","Root"},

{"Torso","LA"},

{"Torso","RA"},

{"LA","LH"},

{"RA","RH"},

{"Root","LL"},

{"Root","RL"},

{"LL","LF"},

{"RL","RF"}

}

for i, pairData in ipairs(drawPairs) do

local a = partPos(parts[pairData[1]])

local b = partPos(parts[pairData[2]])

if a and b and skelLines[i] then

skelLines[i].Visible = true

updateLine(skelLines[i], a, b, 1, color, 0)

end

end

end)

if not ok then

setListVisible(skelLines, false)

end

end

arrow.Visible = false

if _G.ESP_OffscreenArrows and baseVisible then

local viewport = camera.ViewportSize

local center = Vector2.new(viewport.X / 2, viewport.Y / 2)

local screenPos = Vector2.new(pos.X, pos.Y)

local offscreen = not vis or pos.X < 0 or pos.X > viewport.X or pos.Y < 0 or pos.Y > viewport.Y

if offscreen then

local dir = screenPos - center

if pos.Z < 0 then dir = -dir end

if dir.Magnitude > 0 then

dir = dir.Unit

local margin = 28

local edgeX = math.clamp(center.X + dir.X * ((viewport.X / 2) - margin), margin, viewport.X - margin)

local edgeY = math.clamp(center.Y + dir.Y * ((viewport.Y / 2) - margin), margin, viewport.Y - margin)

arrow.Position = UDim2.new(0, edgeX - 14, 0, edgeY - 14)

arrow.Rotation = math.deg(math.atan2(dir.Y, dir.X)) + 90

arrow.TextColor3 = color

arrow.Visible = true

end

end

end

end)

table.insert(espConnections, conn)

end

table.insert(espConnections, plr.CharacterAdded:Connect(onChar))

if plr.Character then onChar(plr.Character) end

end

for _, plr in ipairs(Players:GetPlayers()) do setup(plr) end

table.insert(espConnections, Players.PlayerAdded:Connect(setup))

_G.ESP_SCR = {

Disconnect = function()

for _, c in ipairs(espConnections) do disconnect(c) end

table.clear(espConnections)

if espGui then espGui:Destroy() end

if tracerGui then tracerGui:Destroy() end

if boxGui then boxGui:Destroy() end

if skelGui then skelGui:Destroy() end

if arrowGui then arrowGui:Destroy() end

end

}

end

for _, n in ipairs({"ESP_Tracers_Enabled","ESP_Names_Enabled","ESP_Distance_Enabled","ESP_Box_Enabled","ESP_Skeleton_Enabled","ESP_TeamCheck","ESP_FriendColor","ESP_EnemyColor","ESP_Rainbow","ESP_OffscreenArrows","ESP_LockedOnly","ESP_HideWhenGuiHidden","ESP_ToolName","ESP_HealthBar"}) do

Handlers[n] = function(v)

_G[n] = v

notify((n:gsub("_", " ")) .. ": " .. (v and "On" or "Off"))

end

end

_G.BETA_CAMLOCK_BIND_NAME = "CustomCamlockInstance"

_G.BETA_CAMLOCK = _G.BETA_CAMLOCK or {}

function _G.BETA_CAMLOCK.GetMousePos()

local pos = UserInputService:GetMouseLocation()

return Vector2.new(pos.X, pos.Y)

end

function _G.BETA_CAMLOCK.GetPart(char)

if not char then return nil end

local wanted = tostring(_G.LockPart or "HumanoidRootPart")

if wanted == "Random" then

local parts = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso", "Torso"}

wanted = parts[math.random(1, #parts)]

end

return getPart(char, wanted)

or char:FindFirstChild("Head")

or char:FindFirstChild("UpperTorso")

or char:FindFirstChild("HumanoidRootPart")

or char:FindFirstChild("LowerTorso")

or char:FindFirstChild("Torso")

end

function _G.BETA_CAMLOCK.IsAlive(plr)

if not plr or not plr.Character then return false end

local hum = plr.Character:FindFirstChildOfClass("Humanoid")

local root = plr.Character:FindFirstChild("HumanoidRootPart")

if not hum or not root or hum.Health <= 0 then

return false

end

if (_G.Camlock_DeathCheck or _G.AutoUnlockDeath) and isKnocked(plr.Character) then

return false

end

return true

end

function _G.BETA_CAMLOCK.ScreenInfo(part)

local cam = workspace.CurrentCamera

if not cam or not part then

return nil, false, math.huge

end

local screenPos, onScreen = cam:WorldToViewportPoint(part.Position)

local point = Vector2.new(screenPos.X, screenPos.Y)

local distance = (point - _G.BETA_CAMLOCK.GetMousePos()).Magnitude

return point, onScreen, distance

end

function _G.BETA_CAMLOCK.FovPass(part)

if not _G.FOV_Enabled then

return true

end

local _, onScreen, distance = _G.BETA_CAMLOCK.ScreenInfo(part)

if not onScreen then

return false

end

return distance <= math.clamp(tonumber(_G.FOV_Radius) or 100, 5, 1000)

end

function _G.BETA_CAMLOCK.WallPass(plr, part)

if not _G.Camlock_WallCheck then

return true

end

return hasLineOfSightToPart(part, plr and plr.Character)

end

function _G.BETA_CAMLOCK.VisiblePass(part)

if not _G.Camlock_VisibleCheck then

return true

end

local _, onScreen = _G.BETA_CAMLOCK.ScreenInfo(part)

return onScreen == true

end

function _G.BETA_CAMLOCK.TeamPass(plr)

if not _G.Camlock_TeamCheck then

return true

end

return not isSameTeam(plr)

end

function _G.BETA_CAMLOCK.DistancePass(part)

if not _G.AutoUnlockDistance or not part or not isAlive(LocalPlayer.Character) then

return true

end

local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

if not myRoot then

return true

end

return (part.Position - myRoot.Position).Magnitude <= (tonumber(_G.AutoUnlockDistance) or 2000)

end

function _G.BETA_CAMLOCK.TargetValid(plr, useFov)

if not plr or plr == LocalPlayer then

return false

end

if not _G.BETA_CAMLOCK.IsAlive(plr) then

return false

end

if not _G.BETA_CAMLOCK.TeamPass(plr) then

return false

end

local part = _G.BETA_CAMLOCK.GetPart(plr.Character)

if not part then

return false

end

if not _G.BETA_CAMLOCK.VisiblePass(part) then

return false

end

if not _G.BETA_CAMLOCK.WallPass(plr, part) then

return false

end

if not _G.BETA_CAMLOCK.DistancePass(part) then

return false

end

if useFov and not _G.BETA_CAMLOCK.FovPass(part) then

return false

end

return true, part

end

function _G.BETA_CAMLOCK.AcquireTarget()

local bestPlayer = nil

local bestPart = nil

local bestDistance = math.huge

for _, plr in ipairs(Players:GetPlayers()) do

local ok, part = _G.BETA_CAMLOCK.TargetValid(plr, true)

if ok and part then

local _, onScreen, distance = _G.BETA_CAMLOCK.ScreenInfo(part)

if onScreen and distance < bestDistance then

bestPlayer = plr

bestPart = part

bestDistance = distance

end

end

end

return bestPlayer, bestPart

end

function _G.BETA_CAMLOCK.Alpha(dt)

local smooth = math.clamp(tonumber(_G.CL_Smoothness) or 1, 1, 100)

if smooth <= 1 then

return 1

end

dt = math.clamp(tonumber(dt) or (1 / 60), 1 / 240, 1 / 15)

return math.clamp(1 - math.exp(-(95 / smooth) * dt), 0.012, 1)

end

Handlers.Camlock = function(v)

RunService:UnbindFromRenderStep(_G.BETA_CAMLOCK_BIND_NAME)

_G.CL_T = nil

_G.BETA_CL_PLAYER = nil

_G.BETA_CL_LOCKED_PLAYER = nil

_G.BETA_CL_LOCK_ATTEMPTED = false

if not v then

notify("Camlock Disabled")

return

end

local pickedPlayer = _G.BETA_CAMLOCK.AcquireTarget()

_G.BETA_CL_PLAYER = pickedPlayer

_G.BETA_CL_LOCKED_PLAYER = pickedPlayer

_G.BETA_CL_LOCK_ATTEMPTED = true

if pickedPlayer then

notify("Camlock Locked: " .. pickedPlayer.Name)

else

notify("Camlock Enabled - No Target")

end

RunService:BindToRenderStep(_G.BETA_CAMLOCK_BIND_NAME, Enum.RenderPriority.Camera.Value + 50, function(dt)

if _G.BETA_KILLED or not _G.Camlock then

RunService:UnbindFromRenderStep(_G.BETA_CAMLOCK_BIND_NAME)

_G.CL_T = nil

_G.BETA_CL_PLAYER = nil

_G.BETA_CL_LOCKED_PLAYER = nil

_G.BETA_CL_LOCK_ATTEMPTED = false

return

end

local cam = workspace.CurrentCamera

if not cam then

return

end

local currentPlayer = _G.BETA_CL_LOCKED_PLAYER

if not currentPlayer then

_G.CL_T = nil

return

end

if not currentPlayer.Parent or currentPlayer == LocalPlayer or not currentPlayer.Character then

_G.CL_T = nil

return

end

if (_G.Camlock_DeathCheck or _G.AutoUnlockDeath) and not _G.BETA_CAMLOCK.IsAlive(currentPlayer) then

_G.CL_T = nil

return

end

if _G.Camlock_TeamCheck and not _G.BETA_CAMLOCK.TeamPass(currentPlayer) then

_G.CL_T = nil

return

end

local targetPart = _G.BETA_CAMLOCK.GetPart(currentPlayer.Character)

if not targetPart then

_G.CL_T = nil

return

end

if _G.AutoUnlockDistance and not _G.BETA_CAMLOCK.DistancePass(targetPart) then

_G.CL_T = nil

return

end

if _G.Camlock_VisibleCheck and not _G.BETA_CAMLOCK.VisiblePass(targetPart) then

_G.CL_T = nil

return

end

if _G.Camlock_WallCheck and not _G.BETA_CAMLOCK.WallPass(currentPlayer, targetPart) then

_G.CL_T = nil

return

end

_G.CL_T = currentPlayer.Character

_G.BETA_CL_PLAYER = currentPlayer

local origin = cam.CFrame.Position

local direction = targetPart.Position - origin

if direction.Magnitude <= 0.1 then

return

end

local goal = CFrame.lookAt(origin, targetPart.Position)

cam.CFrame = cam.CFrame:Lerp(goal, _G.BETA_CAMLOCK.Alpha(dt))

end)

end

Handlers.NormalWalkSpeed = function(v)

if v then

setToggle("WalkSpeedBoost", false, true)

notify("Game WalkSpeed")

task.defer(function()

if Toggles.NormalWalkSpeed then

Toggles.NormalWalkSpeed.Set(false, false)

end

end)

end

end

Handlers.LockedHighlight = function(v)

if _G.LH_CONN then _G.LH_CONN:Disconnect(); _G.LH_CONN = nil end

if _G.LH_FOLDER then _G.LH_FOLDER:Destroy(); _G.LH_FOLDER = nil end

if not v then return end

local folder = Instance.new("Folder")

folder.Name = "BETA_LockedHighlight"

folder.Parent = workspace

_G.LH_FOLDER = folder

local highlight = Instance.new("Highlight")

highlight.FillColor = Color3.fromRGB(255,0,0)

highlight.OutlineColor = Color3.fromRGB(255,60,60)

highlight.FillTransparency = 0.45

highlight.Enabled = false

highlight.Parent = folder

_G.LH_CONN = RunService.RenderStepped:Connect(function()

if _G.CL_T and isAlive(_G.CL_T) then

highlight.Adornee = _G.CL_T

highlight.Enabled = true

else

highlight.Enabled = false

highlight.Adornee = nil

end

end)

end

Handlers.LockedTracer = function(v)

if _G.LT_CONN then _G.LT_CONN:Disconnect(); _G.LT_CONN = nil end

if PlayerGui:FindFirstChild("B_LOCKED_TRC") then PlayerGui.B_LOCKED_TRC:Destroy() end

if not v then return end

local gui = Instance.new("ScreenGui")

gui.Name = "B_LOCKED_TRC"

gui.ResetOnSpawn = false

gui.IgnoreGuiInset = true

gui.Parent = PlayerGui

_G.BETA_FORCE_GUI_ON_TOP(gui)

local tracer = Instance.new("Frame")

tracer.BackgroundColor3 = Color3.fromRGB(255,0,0)

tracer.BorderSizePixel = 0

tracer.AnchorPoint = Vector2.new(0.5, 0.5)

tracer.Visible = false

tracer.Parent = gui

_G.LT_CONN = RunService.RenderStepped:Connect(function()

local cam = workspace.CurrentCamera

if not (_G.CL_T and isAlive(_G.CL_T)) then tracer.Visible = false return end

local part = getPart(_G.CL_T, _G.LockPart)

if not part then tracer.Visible = false return end

local pos, vis = cam:WorldToViewportPoint(part.Position)

if not vis then tracer.Visible = false return end

updateLine(tracer, getTracerOrigin(cam), Vector2.new(pos.X, pos.Y), 2, Color3.fromRGB(255,0,0), 0)

end)

end

Handlers.Fly = function(v)

if _G.FLY_CONN then

_G.FLY_CONN:Disconnect()

_G.FLY_CONN = nil

end

if not v then

if isAlive(LocalPlayer.Character) then

local hum = LocalPlayer.Character:FindFirstChild("Humanoid")

local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

if hum then

hum.PlatformStand = false

hum.AutoRotate = true

end

if hrp then

hrp.AssemblyLinearVelocity = Vector3.zero

hrp.AssemblyAngularVelocity = Vector3.zero

hrp.Velocity = Vector3.zero

end

end

notify("Fly Disabled")

return

end

if Toggles.FlyWalk and Toggles.FlyWalk.Get and Toggles.FlyWalk.Get() then

Toggles.FlyWalk.Set(false, true)

end

notify("Fly Enabled")

_G.FLY_CONN = RunService.RenderStepped:Connect(function(dt)

if _G.BETA_KILLED then return end

if not isAlive(LocalPlayer.Character) then return end

local char = LocalPlayer.Character

local hum = char:FindFirstChild("Humanoid")

local hrp = char:FindFirstChild("HumanoidRootPart")

local cam = workspace.CurrentCamera

if not hum or not hrp or not cam then return end

local direction = Vector3.zero

local camCF = cam.CFrame

if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += camCF.LookVector end

if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= camCF.LookVector end

if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += camCF.RightVector end

if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= camCF.RightVector end

if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.new(0, 1, 0) end

if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction -= Vector3.new(0, 1, 0) end

if direction.Magnitude > 0 then

direction = direction.Unit

end

local speed = math.clamp(_G.FlySpeed or 50, 1, 1000)

local method = _G.FlyMethod or "CFrame"

hum.PlatformStand = false

hum.AutoRotate = false

if method == "Velocity" then

hrp.AssemblyLinearVelocity = direction * speed

hrp.AssemblyAngularVelocity = Vector3.zero

elseif method == "Position" then

hrp.AssemblyLinearVelocity = Vector3.zero

hrp.AssemblyAngularVelocity = Vector3.zero

hrp.Position = hrp.Position + (direction * speed * dt)

elseif method == "Camera" then

hrp.AssemblyLinearVelocity = Vector3.zero

hrp.AssemblyAngularVelocity = Vector3.zero

local newPos = hrp.Position + (direction * speed * dt)

hrp.CFrame = CFrame.new(newPos, newPos + camCF.LookVector)

else

hrp.AssemblyLinearVelocity = Vector3.zero

hrp.AssemblyAngularVelocity = Vector3.zero

hrp.CFrame = hrp.CFrame + (direction * speed * dt)

end

end)

end

Handlers.FlyWalk = function(v)

if _G.FW_SCR then _G.FW_SCR:Disconnect(); _G.FW_SCR = nil end

if not v then

if isAlive(LocalPlayer.Character) then

LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero

end

notify("Fly Walk Disabled")

return

end

if Toggles.Fly and Toggles.Fly.Get and Toggles.Fly.Get() then

Toggles.Fly.Set(false, true)

end

notify("Fly Walk Enabled")

_G.FW_SCR = RunService.RenderStepped:Connect(function()

if isAlive(LocalPlayer.Character) then

local hrp = LocalPlayer.Character.HumanoidRootPart

local hum = LocalPlayer.Character.Humanoid

hrp.Velocity = hum.MoveDirection.Magnitude > 0 and Vector3.new(hum.MoveDirection.X * _G.FlySpeed, 0, hum.MoveDirection.Z * _G.FlySpeed) or Vector3.zero

end

end)

end

Handlers.Orbit = function(v)

if _G.OrbitConnection then _G.OrbitConnection:Disconnect(); _G.OrbitConnection = nil end

if not v then

_G.OrbitTarget = nil

_G.OrbitAngle = 0

notify("Orbit Disabled")

return

end

_G.OrbitTarget = getClosestPlayerToMouse()

notify(_G.OrbitTarget and ("Orbit Target: " .. _G.OrbitTarget.Name) or "No Orbit Target")

_G.OrbitConnection = RunService.RenderStepped:Connect(function(dt)

if not (_G.OrbitTarget and isAlive(_G.OrbitTarget.Character) and isAlive(LocalPlayer.Character)) then return end

local myRoot = LocalPlayer.Character.HumanoidRootPart

local targetRoot = _G.OrbitTarget.Character.HumanoidRootPart

_G.OrbitAngle += dt * _G.OrbitSpeed

local offset = Vector3.new(math.cos(_G.OrbitAngle) * _G.OrbitRadius, 0, math.sin(_G.OrbitAngle) * _G.OrbitRadius)

myRoot.CFrame = CFrame.new(targetRoot.Position + offset, targetRoot.Position)

myRoot.AssemblyLinearVelocity = Vector3.zero

myRoot.AssemblyAngularVelocity = Vector3.zero

end)

end

Handlers.ReturnByDeath = function(v)

if _G.RBD_CONNS then

for _, c in ipairs(_G.RBD_CONNS) do

disconnect(c)

end

end

_G.RBD_CONNS = {}

_G.ReturnByDeath = v

if not v then

_G.ReturnDeathCFrame = nil

_G.BETA_RBD_LAST_ALIVE_CFRAME = nil

_G.BETA_RBD_PENDING_CFRAME = nil

_G.BETA_RBD_RETURNING = false

notify("Return By Death Off")

return

end

local function getDelay()

local raw = tonumber(_G.ReturnDeathDelay) or 4

if raw <= 1 then

return math.clamp(raw, 0.05, 5)

end

return math.clamp(raw / 10, 0.05, 5)

end

local function getRoot(char)

return char and char:FindFirstChild("HumanoidRootPart")

end

local function getHum(char)

return char and char:FindFirstChildOfClass("Humanoid")

end

local function saveLastAlive(char)

if _G.BETA_RBD_RETURNING then return end

local root = getRoot(char)

local hum = getHum(char)

if root and hum and hum.Health > 0 then

_G.BETA_RBD_LAST_ALIVE_CFRAME = root.CFrame

end

end

local function captureDeathSpot(char)

local root = getRoot(char)

local saved = _G.BETA_RBD_LAST_ALIVE_CFRAME

if not saved and root then

saved = root.CFrame

end

if saved then

_G.ReturnDeathCFrame = saved

_G.BETA_RBD_PENDING_CFRAME = saved

end

end

local function restoreAfterRespawn(char)

local saved = _G.BETA_RBD_PENDING_CFRAME or _G.ReturnDeathCFrame or _G.BETA_RBD_LAST_ALIVE_CFRAME

if not saved or not _G.ReturnByDeath then

_G.BETA_RBD_RETURNING = false

return

end

_G.BETA_RBD_RETURNING = true

task.wait(getDelay())

local target = saved + Vector3.new(0, 3, 0)

local moved = false

for _ = 1, 45 do

if not _G.ReturnByDeath then

break

end

local root = getRoot(char)

local hum = getHum(char)

if root and root.Parent then

pcall(function()

root.CFrame = target

end)

pcall(function()

char:PivotTo(target)

end)

root.AssemblyLinearVelocity = Vector3.zero

root.AssemblyAngularVelocity = Vector3.zero

root.Velocity = Vector3.zero

root.RotVelocity = Vector3.zero

if hum then

hum.Sit = false

hum.PlatformStand = false

hum.AutoRotate = true

pcall(function()

hum:ChangeState(Enum.HumanoidStateType.Running)

end)

end

moved = true

if (root.Position - target.Position).Magnitude <= 8 then

break

end

end

task.wait(0.05)

end

if moved then

notify("Returned to death spot")

else

notify("Return By Death failed")

end

task.wait(0.2)

_G.BETA_RBD_PENDING_CFRAME = nil

_G.BETA_RBD_RETURNING = false

end

local function watch(char)

if not char then return end

local hum = char:WaitForChild("Humanoid", 10)

local root = char:WaitForChild("HumanoidRootPart", 10)

if not hum or not root then

return

end

saveLastAlive(char)

table.insert(_G.RBD_CONNS, hum.HealthChanged:Connect(function(health)

if health <= 0 and _G.ReturnByDeath then

captureDeathSpot(char)

elseif health > 0 and _G.ReturnByDeath then

saveLastAlive(char)

end

end))

table.insert(_G.RBD_CONNS, hum.Died:Connect(function()

if _G.ReturnByDeath then

captureDeathSpot(char)

end

end))

end

table.insert(_G.RBD_CONNS, RunService.Heartbeat:Connect(function()

if _G.ReturnByDeath and not _G.BETA_RBD_RETURNING and isAlive(LocalPlayer.Character) then

saveLastAlive(LocalPlayer.Character)

end

end))

table.insert(_G.RBD_CONNS, LocalPlayer.CharacterAdded:Connect(function(char)

if _G.ReturnByDeath then

_G.BETA_RBD_RETURNING = true

task.spawn(function()

restoreAfterRespawn(char)

watch(char)

end)

end

end))

if LocalPlayer.Character then

watch(LocalPlayer.Character)

end

notify("Return By Death On")

end

Handlers.AntiSit = function(v)

if _G.AS_CONNS then

for _, c in ipairs(_G.AS_CONNS) do disconnect(c) end

end

_G.AS_CONNS = {}

local function allow()

if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then

pcall(function() LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true) end)

end

end

if not v then allow() return end

local function protect(char)

local hum = char:WaitForChild("Humanoid", 5)

if not hum then return end

hum.Sit = false

pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false) end)

table.insert(_G.AS_CONNS, hum:GetPropertyChangedSignal("Sit"):Connect(function()

if hum.Sit then

hum.Sit = false

hum:ChangeState(Enum.HumanoidStateType.GettingUp)

notify("Anti-Sit Blocked")

end

end))

end

table.insert(_G.AS_CONNS, LocalPlayer.CharacterAdded:Connect(protect))

if LocalPlayer.Character then protect(LocalPlayer.Character) end

end

Handlers.InfiniteJump = function(v)

if _G.IJ_SCR then _G.IJ_SCR:Disconnect(); _G.IJ_SCR = nil end

if v then

_G.IJ_SCR = UserInputService.JumpRequest:Connect(function()

if isAlive(LocalPlayer.Character) then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end

end)

end

end

Handlers.AntiFling = function(v)

if _G.AF_SCR then _G.AF_SCR:Disconnect(); _G.AF_SCR = nil end

if v then

_G.AF_SCR = RunService.Stepped:Connect(function()

for _, plr in ipairs(Players:GetPlayers()) do

if plr ~= LocalPlayer and plr.Character then

for _, part in ipairs(plr.Character:GetDescendants()) do

if part:IsA("BasePart") then

part.CanCollide = false

part.Velocity = Vector3.zero

end

end

end

end

end)

end

end

_G.BETA_NoclipSavedCollisions = _G.BETA_NoclipSavedCollisions or {}

_G.BETA_NoclipSavedGroups = _G.BETA_NoclipSavedGroups or {}

_G.BETA_NoclipGroupName = "BETA_Noclip"

_G.BETA_NoclipReady = false

function _G.BETA_SetupNoclipGroup()

if _G.BETA_NoclipReady then return end

local PhysicsService = game:GetService("PhysicsService")

pcall(function()

PhysicsService:RegisterCollisionGroup(_G.BETA_NoclipGroupName)

end)

pcall(function()

PhysicsService:CreateCollisionGroup(_G.BETA_NoclipGroupName)

end)

pcall(function()

PhysicsService:CollisionGroupSetCollidable(_G.BETA_NoclipGroupName, "Default", false)

end)

pcall(function()

for _, group in ipairs(PhysicsService:GetRegisteredCollisionGroups()) do

PhysicsService:CollisionGroupSetCollidable(_G.BETA_NoclipGroupName, group.name or group.Name, false)

end

end)

pcall(function()

for _, group in ipairs(PhysicsService:GetCollisionGroups()) do

PhysicsService:CollisionGroupSetCollidable(_G.BETA_NoclipGroupName, group.name or group.Name, false)

end

end)

_G.BETA_NoclipReady = true

end

function _G.BETA_SaveNoclipPart(part)

if part and part:IsA("BasePart") then

if _G.BETA_NoclipSavedCollisions[part] == nil then

_G.BETA_NoclipSavedCollisions[part] = part.CanCollide

end

if _G.BETA_NoclipSavedGroups[part] == nil then

pcall(function()

_G.BETA_NoclipSavedGroups[part] = part.CollisionGroup

end)

end

end

end

function _G.BETA_ApplyNoclip()

local character = LocalPlayer.Character

if not character then return end

_G.BETA_SetupNoclipGroup()

local humanoid = character:FindFirstChildOfClass("Humanoid")

if humanoid then

humanoid.PlatformStand = false

humanoid.Sit = false

humanoid.AutoRotate = true

end

for _, part in ipairs(character:GetDescendants()) do

if part:IsA("BasePart") then

_G.BETA_SaveNoclipPart(part)

part.CanCollide = false

pcall(function()

part.CanTouch = false

end)

pcall(function()

part.CollisionGroup = _G.BETA_NoclipGroupName

end)

pcall(function()

game:GetService("PhysicsService"):SetPartCollisionGroup(part, _G.BETA_NoclipGroupName)

end)

end

end

end

function _G.BETA_RestoreNoclip()

for part, oldValue in pairs(_G.BETA_NoclipSavedCollisions) do

if part and part.Parent then

pcall(function()

part.CanCollide = oldValue

end)

pcall(function()

part.CanTouch = true

end)

local oldGroup = _G.BETA_NoclipSavedGroups[part]

if oldGroup then

pcall(function()

part.CollisionGroup = oldGroup

end)

pcall(function()

game:GetService("PhysicsService"):SetPartCollisionGroup(part, oldGroup)

end)

end

end

end

table.clear(_G.BETA_NoclipSavedCollisions)

table.clear(_G.BETA_NoclipSavedGroups)

local character = LocalPlayer.Character

local humanoid = character and character:FindFirstChildOfClass("Humanoid")

local root = character and character:FindFirstChild("HumanoidRootPart")

if humanoid then

humanoid.PlatformStand = false

humanoid.Sit = false

humanoid.AutoRotate = true

pcall(function()

humanoid:ChangeState(Enum.HumanoidStateType.Running)

end)

end

if root then

root.Anchored = false

root.AssemblyLinearVelocity = Vector3.zero

root.AssemblyAngularVelocity = Vector3.zero

root.Velocity = Vector3.zero

root.RotVelocity = Vector3.zero

end

end

Handlers.Noclip = function(v)

if _G.NC_SCR then

_G.NC_SCR:Disconnect()

_G.NC_SCR = nil

end

if _G.NC_HB then

_G.NC_HB:Disconnect()

_G.NC_HB = nil

end

if _G.NC_RS then

_G.NC_RS:Disconnect()

_G.NC_RS = nil

end

if _G.NC_CHAR then

_G.NC_CHAR:Disconnect()

_G.NC_CHAR = nil

end

if not v then

_G.BETA_RestoreNoclip()

return

end

table.clear(_G.BETA_NoclipSavedCollisions)

table.clear(_G.BETA_NoclipSavedGroups)

_G.BETA_ApplyNoclip()

_G.NC_SCR = RunService.Stepped:Connect(_G.BETA_ApplyNoclip)

_G.NC_HB = RunService.Heartbeat:Connect(_G.BETA_ApplyNoclip)

_G.NC_RS = RunService.RenderStepped:Connect(_G.BETA_ApplyNoclip)

_G.NC_CHAR = LocalPlayer.CharacterAdded:Connect(function()

task.wait(0.1)

_G.BETA_ApplyNoclip()

end)

end

Handlers.AntiAFK = function(v)

if _G.AFK_SCR then _G.AFK_SCR:Disconnect(); _G.AFK_SCR = nil end

if v then

_G.AFK_SCR = LocalPlayer.Idled:Connect(function()

game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)

end)

end

end

Handlers.Fullbright = function(v)

Lighting.Brightness = v and 2 or OriginalLighting.Brightness

Lighting.Ambient = v and Color3.new(1,1,1) or OriginalLighting.Ambient

Lighting.GlobalShadows = v and false or OriginalLighting.GlobalShadows

end

Handlers.UIBlur = function(v)

_G.UIBlur = v

if BlurEffect then BlurEffect.Enabled = v end

end

Handlers.Notifications = function(v) _G.Notifications = v end

Handlers.UISounds = function(v) _G.UISounds = v end

Handlers.Watermark = function(v) _G.Watermark = v end

Handlers.DamageFlash = function(v) _G.DamageFlash = v end

Handlers.HitMarkerEffect = function(v) _G.HitMarkerEffect = v end

Handlers.HitMarkerSound = function(v) _G.HitMarkerSound = v end

Handlers.LowHPAlertEnabled = function(v) _G.LowHPAlertEnabled = v end

Handlers.CrosshairEnabled = function(v) _G.CrosshairEnabled = v end

Handlers.CrosshairDot = function(v) _G.CrosshairDot = v end

Handlers.WorldMouseDot = function(v)

_G.WorldMouseDot = v

if v then createMouseDot() else removeMouseDot() end

end

Handlers.FOV_Enabled = function(v) _G.FOV_Enabled = v end

Handlers.FOV_Visible = function(v) _G.FOV_Visible = v end

Handlers.GuiLockPosition = function(v) _G.GuiLockPosition = v end

Handlers.AutoOpenLastTab = function(v) _G.AutoOpenLastTab = v end

Handlers.RoundedCorners = function(v) _G.RoundedCorners = v; refreshTheme() end

Handlers.Camlock_WallCheck = function(v) _G.Camlock_WallCheck = v end

Handlers.Camlock_TeamCheck = function(v) _G.Camlock_TeamCheck = v end

Handlers.Camlock_VisibleCheck = function(v) _G.Camlock_VisibleCheck = v end

Handlers.Camlock_DeathCheck = function(v) _G.Camlock_DeathCheck = v end

Handlers.AutoUnlockDeath = function(v) _G.AutoUnlockDeath = v end

Handlers.TeleportClick = function(v) _G.TeleportClick = v; notify("Teleport Click " .. (v and "On" or "Off")) end

Handlers.SwimAnywhere = function(v)

_G.SwimAnywhere = v

if not v and isAlive(LocalPlayer.Character) then

local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

if hum then

pcall(function()

hum:ChangeState(Enum.HumanoidStateType.Running)

end)

end

end

notify("Swim Anywhere " .. (v and "On" or "Off"))

end

Handlers.VelocityMeter = function(v) _G.VelocityMeter = v end

Handlers.DamageIndicators = function(v) _G.DamageIndicators = v end

Handlers.HitChams = function(v) _G.HitChams = v end

Handlers.KillFeed = function(v) _G.KillFeed = v end

Handlers.AmmoCounter = function(v) _G.AmmoCounter = v end

Handlers.ChamsOverlay = function(v) _G.ChamsOverlay = v end

Handlers.ReplayTrail = function(v)

_G.ReplayTrail = v

if not v and _G.BETA_TRAIL_FOLDER then

_G.BETA_TRAIL_FOLDER:Destroy()

_G.BETA_TRAIL_FOLDER = nil

_G.BETA_LAST_TRAIL = nil

end

end

Handlers.MiniMode = function(v)

_G.MiniMode = v

if Main and MiniBar then

Main.Visible = not v

MiniBar.Visible = v

end

end

Handlers.ChatUnlocker = function(v)

local c = PlayerGui:FindFirstChild("Chat")

if c and c:FindFirstChild("Frame") then

pcall(function()

c.Frame.ChatChannelParentFrame.Visible = v

c.Frame.ChatBarParentFrame.Visible = v

end)

end

end

Handlers.SuspiciousAimDetector = function(enabled)

if _G.SAD_CONN then _G.SAD_CONN:Disconnect(); _G.SAD_CONN = nil end

if _G.SAD_FOLDER then _G.SAD_FOLDER:Destroy(); _G.SAD_FOLDER = nil end

if SuspiciousAimLabel then SuspiciousAimLabel.Text = "Status: Idle" end

if not enabled then return end

local folder = Instance.new("Folder")

folder.Name = "BETA_SuspiciousAimDetector"

folder.Parent = workspace

_G.SAD_FOLDER = folder

local markers, suspicion, perfectFrames, lastDot = {}, {}, {}, {}

local function getMarker(plr)

if markers[plr] then return markers[plr] end

local h = Instance.new("Highlight")

h.Name = "SuspiciousAim_" .. plr.Name

h.FillColor = Color3.fromRGB(255,0,0)

h.OutlineColor = Color3.fromRGB(255,215,80)

h.FillTransparency = 0.55

h.Enabled = false

h.Parent = folder

markers[plr] = h

return h

end

local function bodyTargets()

local targets = {}

if not LocalPlayer.Character then return targets end

for _, name in ipairs({"Head","UpperTorso","LowerTorso","Torso","HumanoidRootPart"}) do

local part = LocalPlayer.Character:FindFirstChild(name)

if part and part:IsA("BasePart") then table.insert(targets, part) end

end

return targets

end

local function rayDistance(origin, dir, point)

local toPoint = point - origin

local along = toPoint:Dot(dir)

if along < 0 then return math.huge end

return (point - (origin + dir * along)).Magnitude

end

_G.SAD_CONN = RunService.RenderStepped:Connect(function(dt)

local targets = bodyTargets()

if #targets == 0 then

if SuspiciousAimLabel then SuspiciousAimLabel.Text = "Status: Waiting for character" end

return

end

local sensitivity = math.clamp(_G.SuspiciousAimSensitivity or 90, 80, 100)

local dotNeeded = sensitivity / 100

local flagScore = math.clamp(2.2 - (math.clamp(_G.SuspiciousAimTime or 8, 1, 20) * 0.06), 0.9, 2.2)

local top, topScore, topPart, topMiss = nil, 0, nil, nil

for _, plr in ipairs(Players:GetPlayers()) do

if plr ~= LocalPlayer and isAlive(plr.Character) then

local char = plr.Character

local head = char:FindFirstChild("Head")

local root = char:FindFirstChild("HumanoidRootPart")

local marker = getMarker(plr)

marker.Adornee = char

if head and root then

local origin = head.Position

local direction = head.CFrame.LookVector.Unit

local bestDot, bestMiss, bestName, bestDistance = -1, math.huge, "Body", math.huge

for _, part in ipairs(targets) do

local toPart = part.Position - origin

local dist = toPart.Magnitude

if dist > 2 and dist <= 600 then

local dot = direction:Dot(toPart.Unit)

local miss = rayDistance(origin, direction, part.Position)

if dot > bestDot then

bestDot, bestMiss, bestName, bestDistance = dot, miss, part.Name, dist

end

end

end

local closeNeed = math.clamp(bestDistance * 0.018, 0.35, 2.2)

local perfectNeed = math.clamp(bestDistance * 0.008, 0.18, 0.85)

local tooPerfect = bestDot >= dotNeeded and bestMiss <= closeNeed

local veryPerfect = bestDot >= math.clamp(dotNeeded + 0.025, 0, 0.999) and bestMiss <= perfectNeed

local stability = lastDot[plr] and math.abs(bestDot - lastDot[plr]) or 1

lastDot[plr] = bestDot

if tooPerfect then

perfectFrames[plr] = (perfectFrames[plr] or 0) + 1

local gain = dt * 1.8

if veryPerfect then gain += dt * 2.2 end

if stability <= 0.002 and perfectFrames[plr] >= 6 then gain += dt * 1.4 end

suspicion[plr] = math.clamp((suspicion[plr] or 0) + gain, 0, 5)

else

perfectFrames[plr] = 0

suspicion[plr] = math.max((suspicion[plr] or 0) - dt * 1.5, 0)

end

local score = suspicion[plr] or 0

marker.Enabled = score >= flagScore * 0.5

marker.FillColor = score >= flagScore and Color3.fromRGB(255,0,0) or Color3.fromRGB(255,170,0)

if score > topScore then

top, topScore, topPart, topMiss = plr, score, bestName, bestMiss

end

else

suspicion[plr] = 0

perfectFrames[plr] = 0

marker.Enabled = false

end

end

end

if SuspiciousAimLabel then

if top and topScore >= flagScore then

SuspiciousAimLabel.Text = "Likely suspicious: " .. top.Name .. " | " .. tostring(topPart) .. " | miss " .. string.format("%.2f", topMiss or 0)

SuspiciousAimLabel.TextColor3 = Color3.fromRGB(255,85,85)

elseif top and topScore >= flagScore * 0.5 then

SuspiciousAimLabel.Text = "Watching: " .. top.Name .. " | score " .. string.format("%.1f", topScore)

SuspiciousAimLabel.TextColor3 = Color3.fromRGB(255,190,85)

else

SuspiciousAimLabel.Text = "Status: Watching for perfect aim"

SuspiciousAimLabel.TextColor3 = C.SUB

end

end

end)

end

function addWatch(plr)

if not plr then notify("No player selected") return end

_G.WatchList[plr.UserId] = true

addEvidence("Added to watch list: " .. plr.Name)

notify("Watching: " .. plr.Name)

end

function removeWatch(plr)

if not plr then return end

_G.WatchList[plr.UserId] = nil

addEvidence("Removed from watch list: " .. plr.Name)

notify("Removed: " .. plr.Name)

end

function clearWatch()

_G.WatchList = {}

addEvidence("Cleared watch list")

notify("Watch List Cleared")

end

function watchListNames()

local names = {}

for _, plr in ipairs(Players:GetPlayers()) do

if isWatched(plr) then table.insert(names, plr.Name) end

end

return #names > 0 and table.concat(names, ", ") or "None"

end

function spectateWatched()

local cam = workspace.CurrentCamera

for _, plr in ipairs(Players:GetPlayers()) do

if isWatched(plr) and isAlive(plr.Character) then

cam.CameraSubject = plr.Character.Humanoid

notify("Spectating: " .. plr.Name)

return

end

end

notify("No watched player alive")

end

function stopPrisonToolTrack()

if _G.BETA_PRISON_TOOLTRACK_CONN then

pcall(function()

_G.BETA_PRISON_TOOLTRACK_CONN:Disconnect()

end)

_G.BETA_PRISON_TOOLTRACK_CONN = nil

end

_G.BETA_PRISON_TOOLTRACK_TARGET = nil

pcall(function()

LocalPlayer.CameraMode = _G.BETA_OLD_CAMERA_MODE or Enum.CameraMode.Classic

end)

notify("Kill tracking stopped")

end

function equipFirstToolForTrack()

local character = LocalPlayer.Character

local humanoid = character and character:FindFirstChildOfClass("Humanoid")

local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

if not humanoid then

return nil

end

local equipped = character and character:FindFirstChildOfClass("Tool")

if equipped then

return equipped

end

if backpack then

for _, item in ipairs(backpack:GetChildren()) do

if item:IsA("Tool") then

humanoid:EquipTool(item)

return item

end

end

end

return nil

end

function startPrisonToolTrack(query)

if not requirePrisonLifeCmds() then

return

end

stopPrisonToolTrack()

local target = findPlayerByPartial(query)

if not target or target == LocalPlayer then

notify("Player not found")

return

end

if not isAlive(target.Character) then

notify("Target is not alive")

return

end

_G.BETA_PRISON_TOOLTRACK_TARGET = target

_G.BETA_OLD_CAMERA_MODE = LocalPlayer.CameraMode

pcall(function()

LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson

end)

local lastEquip = 0

_G.BETA_PRISON_TOOLTRACK_CONN = RunService.RenderStepped:Connect(function()

if _G.BETA_KILLED then

stopPrisonToolTrack()

return

end

local trackTarget = _G.BETA_PRISON_TOOLTRACK_TARGET

if not trackTarget or not trackTarget.Parent then

stopPrisonToolTrack()

return

end

local targetChar = trackTarget.Character

local myChar = LocalPlayer.Character

if not myChar or not myChar:FindFirstChildOfClass("Humanoid") or myChar:FindFirstChildOfClass("Humanoid").Health <= 0 then

stopPrisonToolTrack()

return

end

if not targetChar or not targetChar:FindFirstChildOfClass("Humanoid") or targetChar:FindFirstChildOfClass("Humanoid").Health <= 0 then

stopPrisonToolTrack()

notify("Kill tracking stopped: target died")

return

end

if os.clock() - lastEquip >= 0.4 then

lastEquip = os.clock()

equipFirstToolForTrack()

end

local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local TextChatService = game:GetService("TextChatService")

local UserInputService = game:GetService("UserInputService")

local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer

local killConnection = nil

local currentTarget = nil

local autoclickConnection = nil

local isTyping = false

local oldCameraMode = LocalPlayer.CameraMode

local oldCameraMinZoom = LocalPlayer.CameraMinZoomDistance

local oldCameraMaxZoom = LocalPlayer.CameraMaxZoomDistance

local oldCameraType = nil

local oldCameraSubject = nil

local function notify(msg)

warn("[Kill Tracker] " .. tostring(msg))

end

local function findPlayerByPartial(query)

query = tostring(query or ""):lower()

if query == "" then

return nil

end

for _, plr in ipairs(Players:GetPlayers()) do

if plr.Name:lower() == query or plr.DisplayName:lower() == query then

return plr

end

end

for _, plr in ipairs(Players:GetPlayers()) do

local name = plr.Name:lower()

local display = plr.DisplayName:lower()

if name:find(query, 1, true) or display:find(query, 1, true) then

return plr

end

end

return nil

end

local function isAlive(character)

local hum = character and character:FindFirstChildOfClass("Humanoid")

return hum and hum.Health > 0

end

local function equipFirstTool()

local character = LocalPlayer.Character

local humanoid = character and character:FindFirstChildOfClass("Humanoid")

local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

if not humanoid or not character then

return nil

end

local equipped = character:FindFirstChildOfClass("Tool")

if equipped then

return equipped

end

if backpack then

for _, item in ipairs(backpack:GetChildren()) do

if item:IsA("Tool") then

humanoid:EquipTool(item)

return item

end

end

end

return nil

end

local function stopAutoclick()

if autoclickConnection then

autoclickConnection:Disconnect()

autoclickConnection = nil

end

end

local function startAutoclick()

stopAutoclick()

local lastClick = 0

local clickDelay = 0.125

autoclickConnection = RunService.Heartbeat:Connect(function()

local character = LocalPlayer.Character

local tool = character and character:FindFirstChildOfClass("Tool")

if tool and (os.clock() - lastClick >= clickDelay) and not isTyping then

lastClick = os.clock()

pcall(function()

if mouse1click then

mouse1click()

end

end)

pcall(function()

local VirtualMouse = LocalPlayer:GetMouse()

if VirtualMouse then

VirtualMouse:Click()

end

end)

pcall(function()

UserInputService:FireInputEvent(Enum.UserInputType.MouseButton1, Vector2.new(), 0)

end)

end

end)

end

local function restoreCamera()

local camera = workspace.CurrentCamera

local character = LocalPlayer.Character

local humanoid = character and character:FindFirstChildOfClass("Humanoid")

pcall(function()

LocalPlayer.CameraMode = oldCameraMode or Enum.CameraMode.Classic

LocalPlayer.CameraMinZoomDistance = oldCameraMinZoom or 0.5

LocalPlayer.CameraMaxZoomDistance = oldCameraMaxZoom or 128

end)

if camera then

pcall(function()

camera.CameraType = oldCameraType or Enum.CameraType.Custom

camera.CameraSubject = oldCameraSubject or humanoid

end)

end

task.delay(0.1, function()

pcall(function()

LocalPlayer.CameraMode = Enum.CameraMode.Classic

LocalPlayer.CameraMinZoomDistance = oldCameraMinZoom or 0.5

LocalPlayer.CameraMaxZoomDistance = oldCameraMaxZoom or 128

end)

if camera and humanoid then

pcall(function()

camera.CameraType = Enum.CameraType.Custom

camera.CameraSubject = humanoid

end)

end

end)

end

local function stopKillTrack()

if killConnection then

killConnection:Disconnect()

killConnection = nil

end

stopAutoclick()

currentTarget = nil

restoreCamera()

notify("Kill tracking stopped")

end

local function startKillTrack(targetName)

stopKillTrack()

local target = findPlayerByPartial(targetName)

if not target or target == LocalPlayer then

notify("Player not found")

return

end

if not isAlive(target.Character) then

notify("Target is not alive")

return

end

local camera = workspace.CurrentCamera

oldCameraMode = LocalPlayer.CameraMode

oldCameraMinZoom = LocalPlayer.CameraMinZoomDistance

oldCameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance

oldCameraType = camera and camera.CameraType or Enum.CameraType.Custom

oldCameraSubject = camera and camera.CameraSubject or nil

currentTarget = target

pcall(function()

LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson

LocalPlayer.CameraMinZoomDistance = 0.5

LocalPlayer.CameraMaxZoomDistance = 0.5

end)

startAutoclick()

local lastEquip = 0

killConnection = RunService.RenderStepped:Connect(function()

local cam = workspace.CurrentCamera

local myChar = LocalPlayer.Character

local targetChar = currentTarget and currentTarget.Character

if not currentTarget or not currentTarget.Parent then

stopKillTrack()

return

end

if not isAlive(myChar) then

stopKillTrack()

return

end

if not isAlive(targetChar) then

stopKillTrack()

notify("Target died")

return

end

if os.clock() - lastEquip >= 0.4 then

lastEquip = os.clock()

equipFirstTool()

end

local targetPart = targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("HumanoidRootPart")

if cam and targetPart then

cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetPart.Position)

end

end)

notify("Kill tracking " .. target.Name)

end

local function runCommand(message)

message = tostring(message or "")

if message:sub(1, 1) ~= "." then

return

end

local raw = message:sub(2)

local command, rest = raw:match("^(%S+)%s*(.*)$")

command = command and command:lower() or ""

rest = rest or ""

if command == "kill" then

if rest == "" then

notify("Usage: .kill player")

else

startKillTrack(rest)

end

return

end

if command == "unkill" then

stopKillTrack()

return

end

end

UserInputService.TextBoxFocused:Connect(function()

isTyping = true

end)

UserInputService.TextBoxFocusReleased:Connect(function()

isTyping = false

end)

pcall(function()

TextChatService.MessageInputFocusChanged:Connect(function(isFocused)

isTyping = isFocused

end)

end)

LocalPlayer.Chatted:Connect(runCommand)

pcall(function()

TextChatService.SendingMessage:Connect(function(message)

if message and message.Text then

runCommand(message.Text)

end

end)

end)

notify("Kill Tracker loaded. Commands: .kill player, .unkill")

local cam = workspace.CurrentCamera

local targetPart = targetChar:FindFirstChild("Head")

or targetChar:FindFirstChild("HumanoidRootPart")

or getPart(targetChar, _G.LockPart or "HumanoidRootPart")

if cam and targetPart then

cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetPart.Position)

end

end)

notify("Kill tracking " .. target.Name)

end

function stopSpectate()

if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then

workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid

notify("Spectate Off")

end

end

_G.BETA_OPEN_PRISON_LIFE_LOADER = function()

local existing = PlayerGui:FindFirstChild("BETA_PRISON_LIFE_LOADER")

if existing then

existing:Destroy()

end

local gui = Instance.new("ScreenGui")

gui.Name = "BETA_PRISON_LIFE_LOADER"

gui.ResetOnSpawn = false

gui.IgnoreGuiInset = true

gui.Parent = PlayerGui

_G.BETA_FORCE_GUI_ON_TOP(gui)

local function showMainGui(show)

if Main then

Main.Visible = show

end

if MiniBar then

MiniBar.Visible = false

end

end

showMainGui(false)

local prisonCommandConnections = {}

local function disconnectPrisonCommandConnections()

for _, conn in ipairs(prisonCommandConnections) do

pcall(function()

conn:Disconnect()

end)

end

for i = #prisonCommandConnections, 1, -1 do

prisonCommandConnections[i] = nil

end

end

local function runPrisonLifeCommand(message)

message = tostring(message or "")

if message:sub(1, 1) ~= "." then

return false

end

local raw = message:sub(2)

local command, rest = raw:match("^(%S+)%s*(.*)$")

command = command and command:lower() or ""

rest = rest or ""

if command == "kill" then

if rest == "" then

notify("Usage: .kill player")

else

startPrisonToolTrack(rest)

end

return true

end

if command == "unkill" then

stopPrisonToolTrack()

return true

end

local ACTIVE = true

local DEFAULT_CPS = 8

local REQUIRED_TOOL_NAME = "M9"

local REQUIRE_LINE_OF_SIGHT = true

local DAMAGE_INFO_WINDOW = 1.5

local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local Camera = workspace.CurrentCamera

local targetPlayer = nil

local lastClickTime = 0

local lastHealth = nil

local lastDamageTime = 0

local humanoidConnections = {}

local trackedTags = {}

local changedTimes = {}

local TAG_NAMES = {

"attacker",

"creator",

"creatorTag",

"hitBy",

"DamageTag",

"LastAttacker",

"lastAttacker",

"killer",

"Killer",

"lastHitBy",

"LastHitBy",

"damager",

"Damager",

}

local ATTRIBUTE_NAMES = {

"LastAttackerUserId",

"lastAttackerUserId",

"AttackerUserId",

"attackerUserId",

"KillerUserId",

"killerUserId",

"LastHitByUserId",

"lastHitByUserId",

"DamagerUserId",

"damagerUserId",

}

local TAG_LOOKUP = {}

for _, name in ipairs(TAG_NAMES) do

TAG_LOOKUP[name] = true

end

local function isAllowedTeam()

if LocalPlayer.Team and LocalPlayer.Team.Name == "Guards" then

return true

end

return false

end

local function isTyping()

return UserInputService:GetFocusedTextBox() ~= nil

end

local function clearConnections()

for _, connection in ipairs(humanoidConnections) do

if connection then

connection:Disconnect()

end

end

table.clear(humanoidConnections)

table.clear(trackedTags)

table.clear(changedTimes)

end

local function resetAutoProtect()

targetPlayer = nil

lastClickTime = 0

if LocalPlayer then

LocalPlayer.CameraMode = Enum.CameraMode.Classic

end

end

local function setAutoProtectEnabled(enabled)

ACTIVE = enabled and true or false

if not ACTIVE then

resetAutoProtect()

end

end

_G.AutoProtectSetEnabled = setAutoProtectEnabled

_G.AutoProtectGetEnabled = function()

return ACTIVE

end

_G.AutoProtectReset = function()

resetAutoProtect()

end

local function findPlayerByUserId(userId)

userId = tonumber(userId)

if not userId then return nil end

for _, player in ipairs(Players:GetPlayers()) do

if player.UserId == userId then

return player

end

end

return nil

end

local function findPlayerByExactName(name)

if typeof(name) ~= "string" then return nil end

for _, player in ipairs(Players:GetPlayers()) do

if player.Name == name then

return player

end

end

return nil

end

local function playerFromAnyValue(value)

if value == nil then

return nil

end

if typeof(value) == "number" then

return findPlayerByUserId(value)

end

if typeof(value) == "string" then

return findPlayerByUserId(value) or findPlayerByExactName(value)

end

if typeof(value) == "Instance" then

if value:IsA("Player") then

return value

end

if value:IsA("Model") then

return Players:GetPlayerFromCharacter(value)

end

if value:IsA("Humanoid") and value.Parent then

return Players:GetPlayerFromCharacter(value.Parent)

end

if value:IsA("BasePart") then

local model = value:FindFirstAncestorOfClass("Model")

if model then

return Players:GetPlayerFromCharacter(model)

end

end

end

return nil

end

local function isValidEnemy(player)

if not isAllowedTeam() then return false end

if not player then return false end

if player == LocalPlayer then return false end

if not player:IsA("Player") then return false end

return true

end

local function isAlive(player)

if not player then return false end

local character = player.Character

if not character then return false end

local humanoid = character:FindFirstChildOfClass("Humanoid")

if not humanoid then return false end

return humanoid.Health > 0

end

local function getTargetPart(character)

if not character then return nil end

return character:FindFirstChild("UpperTorso")

or character:FindFirstChild("Torso")

or character:FindFirstChild("HumanoidRootPart")

or character:FindFirstChild("Head")

end

local function getTagValue(tag)

if tag:IsA("ObjectValue") then

return tag.Value

end

if tag:IsA("IntValue") or tag:IsA("NumberValue") or tag:IsA("StringValue") then

return tag.Value

end

return nil

end

local function markChanged(key)

changedTimes[key] = os.clock()

end

local function isFreshDamageInfo(key)

local changedAt = changedTimes[key]

if not changedAt then return false end

local now = os.clock()

if lastDamageTime > 0 and math.abs(changedAt - lastDamageTime) <= DAMAGE_INFO_WINDOW then

return true

end

if lastDamageTime > 0 and now - lastDamageTime <= DAMAGE_INFO_WINDOW and now - changedAt <= DAMAGE_INFO_WINDOW then

return true

end

return false

end

local function setTarget(player)

if not isAllowedTeam() then return false end

if not isValidEnemy(player) then return false end

targetPlayer = player

return true

end

local function readFreshAttacker(humanoid)

if not isAllowedTeam() then return nil end

if not humanoid then return nil end

local newestPlayer = nil

local newestTime = -math.huge

for _, attributeName in ipairs(ATTRIBUTE_NAMES) do

if isFreshDamageInfo(attributeName) then

local player = playerFromAnyValue(humanoid:GetAttribute(attributeName))

local changedAt = changedTimes[attributeName] or 0

if isValidEnemy(player) and changedAt > newestTime then

newestPlayer = player

newestTime = changedAt

end

end

end

for _, tag in ipairs(humanoid:GetChildren()) do

if TAG_LOOKUP[tag.Name] and isFreshDamageInfo(tag) then

local player = playerFromAnyValue(getTagValue(tag))

local changedAt = changedTimes[tag] or 0

if isValidEnemy(player) and changedAt > newestTime then

newestPlayer = player

newestTime = changedAt

end

end

end

return newestPlayer

end

local function tryUpdateLastAttacker()

if not isAllowedTeam() then return false end

local character = LocalPlayer.Character

if not character then return false end

local humanoid = character:FindFirstChildOfClass("Humanoid")

if not humanoid then return false end

local attacker = readFreshAttacker(humanoid)

if attacker then

return setTarget(attacker)

end

return false

end

local function trackDamageTag(humanoid, tag)

if not isAllowedTeam() then return end

if not tag or not TAG_LOOKUP[tag.Name] then return end

if trackedTags[tag] then return end

trackedTags[tag] = true

table.insert(humanoidConnections, tag.Changed:Connect(function()

if not isAllowedTeam() then return end

markChanged(tag)

if lastDamageTime > 0 and os.clock() - lastDamageTime <= DAMAGE_INFO_WINDOW then

local player = playerFromAnyValue(getTagValue(tag))

if isValidEnemy(player) then

setTarget(player)

end

end

end))

end

local function hasLineOfSight(targetCharacter, targetPart)

if not REQUIRE_LINE_OF_SIGHT then

return true

end

local character = LocalPlayer.Character

if not character then return false end

local head = character:FindFirstChild("Head")

if not head or not targetPart then return false end

local origin = head.Position

local direction = targetPart.Position - origin

local raycastParams = RaycastParams.new()

raycastParams.FilterType = Enum.RaycastFilterType.Exclude

raycastParams.FilterDescendantsInstances = { character }

raycastParams.IgnoreWater = true

local result = workspace:Raycast(origin, direction, raycastParams)

if not result then

return true

end

return result.Instance:IsDescendantOf(targetCharacter)

end

local function equipM9Only()

local character = LocalPlayer.Character

if not character then return nil, DEFAULT_CPS end

local humanoid = character:FindFirstChildOfClass("Humanoid")

if not humanoid then return nil, DEFAULT_CPS end

local equippedTool = character:FindFirstChildOfClass("Tool")

if equippedTool and equippedTool.Name == REQUIRED_TOOL_NAME then

return equippedTool, DEFAULT_CPS

end

local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

if backpack then

local m9 = backpack:FindFirstChild(REQUIRED_TOOL_NAME)

if m9 then

humanoid:EquipTool(m9)

return m9, DEFAULT_CPS

end

end

return nil, DEFAULT_CPS

end

local function useTool(tool)

if not tool then return end

pcall(function()

tool:Activate()

end)

end

local function bindHumanoid(humanoid)

clearConnections()

resetAutoProtect()

lastHealth = humanoid.Health

lastDamageTime = 0

for _, child in ipairs(humanoid:GetChildren()) do

if TAG_LOOKUP[child.Name] then

trackDamageTag(humanoid, child)

end

end

table.insert(humanoidConnections, humanoid.HealthChanged:Connect(function(newHealth)

if not isAllowedTeam() then return end

if lastHealth and newHealth < lastHealth then

lastDamageTime = os.clock()

tryUpdateLastAttacker()

task.delay(0.03, function()

tryUpdateLastAttacker()

end)

task.delay(0.12, function()

tryUpdateLastAttacker()

end)

task.delay(0.25, function()

tryUpdateLastAttacker()

end)

task.delay(0.45, function()

tryUpdateLastAttacker()

end)

end

lastHealth = newHealth

end))

table.insert(humanoidConnections, humanoid.ChildAdded:Connect(function(child)

if not isAllowedTeam() then return end

if TAG_LOOKUP[child.Name] then

markChanged(child)

trackDamageTag(humanoid, child)

task.defer(function()

if not isAllowedTeam() then return end

if lastDamageTime > 0 and os.clock() - lastDamageTime <= DAMAGE_INFO_WINDOW then

local player = playerFromAnyValue(getTagValue(child))

if isValidEnemy(player) then

setTarget(player)

else

tryUpdateLastAttacker()

end

end

end)

end

end))

table.insert(humanoidConnections, humanoid.ChildRemoved:Connect(function(child)

trackedTags[child] = nil

changedTimes[child] = nil

end))

for _, attributeName in ipairs(ATTRIBUTE_NAMES) do

table.insert(humanoidConnections, humanoid:GetAttributeChangedSignal(attributeName):Connect(function()

if not isAllowedTeam() then return end

markChanged(attributeName)

if lastDamageTime > 0 and os.clock() - lastDamageTime <= DAMAGE_INFO_WINDOW then

local player = playerFromAnyValue(humanoid:GetAttribute(attributeName))

if isValidEnemy(player) then

setTarget(player)

else

tryUpdateLastAttacker()

end

end

end))

end

table.insert(humanoidConnections, humanoid.Died:Connect(function()

resetAutoProtect()

end))

end

local function onCharacterAdded(character)

resetAutoProtect()

local humanoid = character:WaitForChild("Humanoid", 5)

if humanoid then

bindHumanoid(humanoid)

end

end

if LocalPlayer.Character then

onCharacterAdded(LocalPlayer.Character)

end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

Players.PlayerRemoving:Connect(function(player)

if targetPlayer == player then

resetAutoProtect()

end

end)

LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()

if not isAllowedTeam() then

resetAutoProtect()

end

end)

RunService.RenderStepped:Connect(function()

if not isAllowedTeam() then

if targetPlayer then resetAutoProtect() end

return

end

if not ACTIVE or isTyping() then return end

Camera = workspace.CurrentCamera

if not Camera then return end

local character = LocalPlayer.Character

if not character then return end

local humanoid = character:FindFirstChildOfClass("Humanoid")

if not humanoid or humanoid.Health <= 0 then

resetAutoProtect()

return

end

if not targetPlayer then

return

end

if not isValidEnemy(targetPlayer) then

resetAutoProtect()

return

end

if not isAlive(targetPlayer) then

resetAutoProtect()

return

end

local targetCharacter = targetPlayer.Character

local targetPart = getTargetPart(targetCharacter)

if not targetPart then

LocalPlayer.CameraMode = Enum.CameraMode.Classic

return

end

if not hasLineOfSight(targetCharacter, targetPart) then

LocalPlayer.CameraMode = Enum.CameraMode.Classic

return

end

LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson

Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPart.Position)

local weapon, cps = equipM9Only()

if weapon then

local now = tick()

local interval = 1 / cps

if now - lastClickTime >= interval then

useTool(weapon)

lastClickTime = now

end

end

end)

return false

end

table.insert(prisonCommandConnections, LocalPlayer.Chatted:Connect(runPrisonLifeCommand))

pcall(function()

table.insert(prisonCommandConnections, TextChatService.SendingMessage:Connect(function(message)

if message and message.Text then

runPrisonLifeCommand(message.Text)

end

end))

end)

local frame = Instance.new("Frame")

frame.Name = "Main"

frame.Size = UDim2.new(0, 760, 0, 500)

frame.Position = UDim2.new(0.5, -380, 0.5, -250)

frame.BackgroundColor3 = C.M

frame.BorderSizePixel = 0

frame.Active = true

frame.Parent = gui

themeObj(frame, "Main")

stroke(frame, C.W, 1)

corner(frame, 2)

local top = Instance.new("Frame")

top.Name = "Top"

top.Size = UDim2.new(1, 0, 0, 34)

top.BackgroundColor3 = C.T

top.BorderSizePixel = 0

top.Active = true

top.Parent = frame

themeObj(top, "Top")

stroke(top, C.W, 1)

local title = Instance.new("TextLabel")

title.Size = UDim2.new(1, -150, 1, 0)

title.Position = UDim2.new(0, 14, 0, 0)

title.BackgroundTransparency = 1

title.Font = getFont()

title.Text = "PRISON LIFE CMDS"

title.TextSize = 15

title.TextColor3 = C.W

title.TextXAlignment = Enum.TextXAlignment.Left

title.Parent = top

themeObj(title, "AccentText")

textObj(title)

local kill = Instance.new("TextButton")

kill.Size = UDim2.new(0, 110, 0, 22)

kill.Position = UDim2.new(1, -124, 0, 6)

kill.BackgroundColor3 = C.RED2

kill.BorderSizePixel = 0

kill.Text = "Kill Script"

kill.Font = getFont()

kill.TextSize = 12

kill.TextColor3 = Color3.fromRGB(255, 222, 222)

kill.Parent = top

textObj(kill)

stroke(kill, C.RED, 1)

corner(kill, 4)

kill.MouseButton1Click:Connect(function()

disconnectPrisonCommandConnections()

stopPrisonToolTrack()

showMainGui(true)

gui:Destroy()

end)

gui.Destroying:Connect(function()

disconnectPrisonCommandConnections()

stopPrisonToolTrack()

showMainGui(true)

end)

local dragging = false

local dragStartMouse = nil

local dragStartPos = nil

top.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

dragging = true

dragStartMouse = UserInputService:GetMouseLocation()

dragStartPos = frame.Position

end

end)

UserInputService.InputEnded:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

dragging = false

dragStartMouse = nil

dragStartPos = nil

end

end)

local dragConn

dragConn = RunService.RenderStepped:Connect(function()

if not gui.Parent then

if dragConn then dragConn:Disconnect() end

return

end

if dragging and dragStartMouse and dragStartPos and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then

local m = UserInputService:GetMouseLocation()

local delta = Vector2.new(m.X, m.Y) - dragStartMouse

frame.Position = UDim2.new(

dragStartPos.X.Scale,

dragStartPos.X.Offset + delta.X,

dragStartPos.Y.Scale,

dragStartPos.Y.Offset + delta.Y

)

end

end)

local shiftConn

shiftConn = UserInputService.InputBegan:Connect(function(input, gpe)

if not gui.Parent then

if shiftConn then shiftConn:Disconnect() end

return

end

if gpe or UserInputService:GetFocusedTextBox() then

return

end

if input.KeyCode == Enum.KeyCode.RightShift then

frame.Visible = not frame.Visible

showMainGui(not frame.Visible)

end

end)

local side = Instance.new("Frame")

side.Name = "Side"

side.Size = UDim2.new(0, 180, 1, -34)

side.Position = UDim2.new(0, 0, 0, 34)

side.BackgroundColor3 = C.S

side.BorderSizePixel = 0

side.Parent = frame

themeObj(side, "Side")

stroke(side, C.W, 1)

local view = Instance.new("Frame")

view.Name = "View"

view.Size = UDim2.new(1, -180, 1, -34)

view.Position = UDim2.new(0, 180, 0, 34)

view.BackgroundColor3 = C.V

view.BorderSizePixel = 0

view.Parent = frame

themeObj(view, "View")

stroke(view, C.W, 1)

local sideHeader = Instance.new("TextLabel")

sideHeader.Size = UDim2.new(1, -20, 0, 25)

sideHeader.Position = UDim2.new(0, 10, 0, 8)

sideHeader.BackgroundTransparency = 1

sideHeader.Font = getFont()

sideHeader.Text = "MENU"

sideHeader.TextSize = 15

sideHeader.TextColor3 = C.W

sideHeader.TextXAlignment = Enum.TextXAlignment.Left

sideHeader.Parent = side

themeObj(sideHeader, "AccentText")

textObj(sideHeader)

local cmdButton = Instance.new("TextButton")

cmdButton.Size = UDim2.new(1, -20, 0, 27)

cmdButton.Position = UDim2.new(0, 10, 0, 40)

cmdButton.BackgroundColor3 = C.A2

cmdButton.BorderSizePixel = 0

cmdButton.Text = ""

cmdButton.Parent = side

themeObj(cmdButton, "Button2")

stroke(cmdButton, C.W, 1)

corner(cmdButton, 4)

local cmdBar = Instance.new("Frame")

cmdBar.Size = UDim2.new(0, 3, 1, 0)

cmdBar.BackgroundColor3 = C.W

cmdBar.BorderSizePixel = 0

cmdBar.Parent = cmdButton

themeObj(cmdBar, "Accent")

local cmdText = Instance.new("TextLabel")

cmdText.Size = UDim2.new(1, -14, 1, 0)

cmdText.Position = UDim2.new(0, 10, 0, 0)

cmdText.BackgroundTransparency = 1

cmdText.Font = getFont()

cmdText.Text = "Cmds"

cmdText.TextSize = 12

cmdText.TextColor3 = C.W

cmdText.TextXAlignment = Enum.TextXAlignment.Left

cmdText.Parent = cmdButton

themeObj(cmdText, "AccentText")

textObj(cmdText)

local page = Instance.new("ScrollingFrame")

page.Name = "Cmds"

page.Size = UDim2.new(1, -16, 1, -16)

page.Position = UDim2.new(0, 8, 0, 8)

page.BackgroundTransparency = 1

page.BorderSizePixel = 0

page.ScrollBarThickness = 6

page.CanvasSize = UDim2.new(0, 0, 0, 0)

page.AutomaticCanvasSize = Enum.AutomaticSize.Y

page.Parent = view

local layout = Instance.new("UIListLayout")

layout.SortOrder = Enum.SortOrder.LayoutOrder

layout.Padding = UDim.new(0, 8)

layout.Parent = page

local note = Instance.new("TextLabel")

note.Size = UDim2.new(1, -8, 0, 54)

note.BackgroundColor3 = C.CARD

note.BackgroundTransparency = 0.12

note.BorderSizePixel = 0

note.Font = getFont()

note.TextSize = 12

note.TextColor3 = C.TX

note.TextWrapped = true

note.TextXAlignment = Enum.TextXAlignment.Left

note.TextYAlignment = Enum.TextYAlignment.Center

note.LayoutOrder = 1

note.Text = "Prison Life admin/helper commands. Type these in chat with a dot before the command."

note.Parent = page

themeObj(note, "Card")

textObj(note)

stroke(note, C.W, 1)

corner(note, 5)

local pad = Instance.new("UIPadding")

pad.PaddingLeft = UDim.new(0, 10)

pad.PaddingRight = UDim.new(0, 10)

pad.Parent = note

local function addCmdRow(commandText, description, order)

local row = Instance.new("Frame")

row.Size = UDim2.new(1, -8, 0, 48)

row.BackgroundColor3 = C.P2

row.BorderSizePixel = 0

row.LayoutOrder = order

row.Parent = page

themeObj(row, "Button")

stroke(row, C.W, 1)

corner(row, 5)

local label = Instance.new("TextLabel")

label.Size = UDim2.new(1, -12, 1, -8)

label.Position = UDim2.new(0, 6, 0, 4)

label.BackgroundTransparency = 1

label.Font = getFont()

label.TextSize = 12

label.TextColor3 = C.TX

label.TextWrapped = true

label.TextXAlignment = Enum.TextXAlignment.Left

label.TextYAlignment = Enum.TextYAlignment.Top

label.Text = commandText .. "\n" .. description

label.Parent = row

themeObj(label, "Text")

textObj(label)

end

addCmdRow(".near player", "Teleports near a player without going inside them.", 2)

addCmdRow(".above player", "Teleports above/near a player so you can watch safely.", 3)

addCmdRow(".back", "Returns to where you were before .tpto, .near, .above, or map teleports.", 4)

addCmdRow(".fixchar", "Stops weird velocity, sitting, noclip, fly, spin/dash leftovers, and resets movement.", 5)

addCmdRow(".follow player", "Teleports near them instantly, turns AntiSit on, then follows with jumping pathfinding.", 6)

addCmdRow(".unfollow", "Stops following the current player.", 7)

addCmdRow(".tpcells", "Teleports to Cells if the map has a matching object/location.", 7)

addCmdRow(".tpyard", "Teleports to Yard if the map has a matching object/location.", 8)

addCmdRow(".tparmory", "Teleports to Armory if the map has a matching object/location.", 9)

addCmdRow(".tpcafe", "Teleports to Cafeteria if the map has a matching object/location.", 10)

addCmdRow(".tpcrimbase", "Teleports to Criminal Base if the map has a matching object/location.", 11)

addCmdRow(".tpprison", "Teleports to Prison/Jail if the map has a matching object/location.", 12)

addCmdRow(".setloc name", "Saves your current spot as a custom location.", 13)

addCmdRow(".gotoloc name", "Teleports to a saved custom location.", 14)

addCmdRow(".delloc name", "Deletes a saved custom location.", 15)

addCmdRow(".locations", "Lists saved custom locations.", 16)

addCmdRow(".copypos", "Prints your current Vector3 position to console.", 17)

addCmdRow(".kill player", "Prison Life-only command. Works only while this loader is open.", 18)

addCmdRow(".unkill", "Stops the Prison Life-only command handler action.", 19)

addCmdRow(".autoprotect", "Automatically protects yourself. Prison Life loader only.", 20)

addCmdRow(".unautoprotect", "Stops auto protection. Prison Life loader only.", 21)

notify("Prison Life Cmds Opened")

end

function buildOwnTrollFunnyBoard(parent)

local noteContent, noteFrame = card(parent, "Command Note", 1)

noteFrame.Size = UDim2.new(1, -8, 0, 58)

local noteLabel = Instance.new("TextLabel")

noteLabel.Size = UDim2.new(1, 0, 1, 0)

noteLabel.BackgroundTransparency = 1

noteLabel.Font = getFont()

noteLabel.TextSize = 14

noteLabel.TextColor3 = C.SUB

noteLabel.TextWrapped = true

noteLabel.TextXAlignment = Enum.TextXAlignment.Left

noteLabel.TextYAlignment = Enum.TextYAlignment.Top

noteLabel.Text = "fun/helper commands. say . before the command in chat."

noteLabel.Parent = noteContent

themeObj(noteLabel, "SubText")

textObj(noteLabel)

local searchContent, searchFrame = card(parent, "Command Search", 2)

searchFrame.Size = UDim2.new(1, -8, 0, 68)

local searchBox = Instance.new("TextBox")

searchBox.Size = UDim2.new(1, 0, 0, 30)

searchBox.Position = UDim2.new(0, 0, 0, 2)

searchBox.BackgroundColor3 = C.P2

searchBox.BorderSizePixel = 0

searchBox.ClearTextOnFocus = false

searchBox.PlaceholderText = "Search fun commands..."

searchBox.Text = ""

searchBox.Font = getFont()

searchBox.TextSize = 13

searchBox.TextColor3 = C.TX

searchBox.PlaceholderColor3 = C.SUB

searchBox.Parent = searchContent

themeObj(searchBox, "Button")

textObj(searchBox)

stroke(searchBox, nil, 1)

corner(searchBox, 5)

local listContent, listFrame = card(parent, "Command List", 3)

listFrame.Size = UDim2.new(1, -8, 0, 485)

local rows = {}

local function addFunRow(commandText, description, searchWords)

local row = Instance.new("Frame")

row.Size = UDim2.new(1, 0, 0, 48)

row.BackgroundColor3 = C.P2

row.BorderSizePixel = 0

row.Parent = listContent

themeObj(row, "Button")

stroke(row, nil, 1)

corner(row, 5)

local label = Instance.new("TextLabel")

label.Size = UDim2.new(1, -12, 1, -8)

label.Position = UDim2.new(0, 6, 0, 4)

label.BackgroundTransparency = 1

label.Font = getFont()

label.TextSize = 12

label.TextColor3 = C.TX

label.TextWrapped = true

label.TextXAlignment = Enum.TextXAlignment.Left

label.TextYAlignment = Enum.TextYAlignment.Top

label.Text = commandText .. "\n" .. description

label.Parent = row

themeObj(label, "Text")

textObj(label)

table.insert(rows, {

Row = row,

Search = string.lower(commandText .. " " .. description .. " " .. (searchWords or ""))

})

end

addFunRow(".follow [player]", "Teleports near them instantly, turns AntiSit on, then follows with jumping pathfinding. If they get too far, it instantly catches up.", "follow pathfinding jump antisIt troll fun")

addFunRow(".unfollow", "Stops following the current player.", "stop follow unfollow")

addFunRow(".talk [player]", "Reads that player\'s public chat and replies more naturally based on what they said.", "talk reply chat custom natural human")

addFunRow(".untalk", "Stops the auto friendly chat replies.", "stop talk untalk")

searchBox:GetPropertyChangedSignal("Text"):Connect(function()

local q = searchBox.Text:lower()

for _, item in ipairs(rows) do

local visible = q == "" or string.find(item.Search, q, 1, true) ~= nil

item.Row.Visible = visible

item.Row.Size = visible and UDim2.new(1, 0, 0, 48) or UDim2.new(1, 0, 0, 0)

end

end)

end

_G.BETA_OPEN_ARSENAL_LOADER = function()

local code = [==========[

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Camera = workspace.CurrentCamera

local RunService = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")

local GuiService = game:GetService("GuiService")

local TweenService = game:GetService("TweenService")

local GameName = "Arsenal"

local ArsenalCamlockStepName = "ArsenalCamlock_" .. tostring(LocalPlayer.UserId)

if _G.ArsenalStandaloneLoader then

_G.ArsenalStandaloneLoader:Destroy()

end

local DropLib = loadstring(game:HttpGet("https://gitlab.com/0x45.xyz/droplib/-/raw/master/drop-minified.lua"))()

if not DropLib then

warn("DropLib failed to load")

return

end

local gui = DropLib:Init({

PrimaryColor = Color3.fromRGB(30, 30, 30),

SecondaryColor = Color3.fromRGB(45, 45, 45),

AccentColor = Color3.fromRGB(255, 100, 100),

TextColor = Color3.new(1, 1, 1),

Font = Enum.Font.Gotham,

TextSize = 14

}, game.CoreGui)

local MainCategory = gui:CreateCategory("Arsenal, 32Dev_LOL on tt", UDim2.new(0, 100, 0, 100))

local TrollCategory = gui:CreateCategory("Arsenal32Dev_LOL on TikTok", UDim2.new(0, 540, 0, 100))

local PlayerBarCategory = gui:CreateCategory("Players", UDim2.new(0, 880, 0, 100))

local CamlockSection = MainCategory:CreateSection("Camlock")

local TriggerbotSection = MainCategory:CreateSection("Triggerbot")

local FlySection = MainCategory:CreateSection("Fly")

local VisualsSection = MainCategory:CreateSection("Visuals")

local SettingsSection = MainCategory:CreateSection("Settings")

local TrollCheatersSection = TrollCategory:CreateSection("Troll Cheaters")

local PlayerBarSection = PlayerBarCategory:CreateSection("Player List")

local Enabled = true

local FOV = 100

local Smoothing = 10

local LastCamlockTick = os.clock()

_G.ArsenalCamlockSmoothness = tonumber(_G.ArsenalCamlockSmoothness) or Smoothing

local TriggerbotEnabled = false

local AutoWinEnabled = false

local CamlockConfig = {

FOVEnabled = true,

WallCheck = false,

TeamCheck = true,

VisibleCheck = false,

DeathCheck = true,

LockPart = "Head"

}

local TrollSelectedPlayer = nil

local TrollSelectedPlayerName = "None"

local TrollSelectedButtonText = nil

local TrollSpectateEnabled = false

local TrollSpectateButtonText = nil

local TrollSpectateConnection = nil

local TrollLoopKillEnabled = false

local TrollLoopKillThreadRunning = false

local TrollLoopKillRunId = 0

local TrollOldCameraSubject = nil

local TrollOldCameraType = nil

_G.ArsenalTrollSelectedPlayer = nil

_G.ArsenalTrollSelectedPlayerName = "None"

local function updateTrollSelectedText()

local text = "Selected Player: " .. tostring(TrollSelectedPlayerName or "None")

if TrollSelectedButtonText then

pcall(function()

TrollSelectedButtonText.Text = text

end)

pcall(function()

TrollSelectedButtonText.Button.Text = text

end)

pcall(function()

TrollSelectedButtonText.TextLabel.Text = text

end)

end

local screen = gui and gui.ScreenGui

if screen then

for _, obj in ipairs(screen:GetDescendants()) do

if (obj:IsA("TextButton") or obj:IsA("TextLabel")) and tostring(obj.Text):find("Selected Player:", 1, true) then

obj.Text = text

end

end

end

end

local function setTrollSelectedPlayer(player)

if player and player.Parent == Players then

TrollSelectedPlayer = player

TrollSelectedPlayerName = player.Name

_G.ArsenalTrollSelectedPlayer = player

_G.ArsenalTrollSelectedPlayerName = player.Name

else

TrollSelectedPlayer = nil

TrollSelectedPlayerName = "None"

_G.ArsenalTrollSelectedPlayer = nil

_G.ArsenalTrollSelectedPlayerName = "None"

end

updateTrollSelectedText()

end

local function getTrollSelectedPlayer()

if TrollSelectedPlayer and TrollSelectedPlayer.Parent == Players then

return TrollSelectedPlayer

end

if TrollSelectedPlayerName and TrollSelectedPlayerName ~= "None" then

local player = Players:FindFirstChild(TrollSelectedPlayerName)

if player then

setTrollSelectedPlayer(player)

return player

end

end

setTrollSelectedPlayer(nil)

return nil

end

local function restoreLocalMovementAfterArsenal()

local character = LocalPlayer.Character

if not character then return end

local humanoid = character:FindFirstChildOfClass("Humanoid")

local root = character:FindFirstChild("HumanoidRootPart")

if humanoid then

humanoid.PlatformStand = false

humanoid.Sit = false

humanoid.AutoRotate = true

pcall(function()

humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)

humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)

humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)

end)

pcall(function()

humanoid:ChangeState(Enum.HumanoidStateType.Running)

end)

end

if root then

root.Anchored = false

root.AssemblyLinearVelocity = Vector3.zero

root.AssemblyAngularVelocity = Vector3.zero

root.Velocity = Vector3.zero

root.RotVelocity = Vector3.zero

end

for _, part in ipairs(character:GetDescendants()) do

if part:IsA("BasePart") then

part.CanCollide = true

end

end

end

local function updateTrollSpectateText()

local text = "Spectate Player: " .. (TrollSpectateEnabled and "ON" or "OFF")

if TrollSpectateButtonText then

pcall(function()

TrollSpectateButtonText.Text = text

end)

pcall(function()

TrollSpectateButtonText.Button.Text = text

end)

pcall(function()

TrollSpectateButtonText.TextLabel.Text = text

end)

end

local screen = gui and gui.ScreenGui

if screen then

for _, obj in ipairs(screen:GetDescendants()) do

if (obj:IsA("TextButton") or obj:IsA("TextLabel")) and tostring(obj.Text):find("Spectate Player:", 1, true) then

obj.Text = text

end

end

end

end

local function stopTrollSpectate()

TrollSpectateEnabled = false

_G.ArsenalTrollSpectate = false

if TrollSpectateConnection then

pcall(function()

TrollSpectateConnection:Disconnect()

end)

TrollSpectateConnection = nil

end

updateTrollSpectateText()

local cam = workspace.CurrentCamera

if cam then

pcall(function()

cam.CameraType = TrollOldCameraType or Enum.CameraType.Custom

end)

local myHumanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

if myHumanoid then

pcall(function()

cam.CameraSubject = myHumanoid

end)

elseif TrollOldCameraSubject then

pcall(function()

cam.CameraSubject = TrollOldCameraSubject

end)

end

end

TrollOldCameraSubject = nil

TrollOldCameraType = nil

end

local function startTrollSpectate()

local target = getTrollSelectedPlayer()

if not target then

print("Select a player first")

TrollSpectateEnabled = false

_G.ArsenalTrollSpectate = false

updateTrollSpectateText()

return

end

local cam = workspace.CurrentCamera

if cam and not TrollOldCameraSubject then

TrollOldCameraSubject = cam.CameraSubject

TrollOldCameraType = cam.CameraType

end

if TrollSpectateConnection then

pcall(function()

TrollSpectateConnection:Disconnect()

end)

TrollSpectateConnection = nil

end

TrollSpectateEnabled = true

_G.ArsenalTrollSpectate = true

updateTrollSpectateText()

TrollSpectateConnection = RunService.RenderStepped:Connect(function()

if not TrollSpectateEnabled or not _G.ArsenalTrollSpectate then

stopTrollSpectate()

return

end

local player = getTrollSelectedPlayer()

local character = player and player.Character

local humanoid = character and character:FindFirstChildOfClass("Humanoid")

local root = character and character:FindFirstChild("HumanoidRootPart")

local head = character and character:FindFirstChild("Head")

if not player or not humanoid or humanoid.Health <= 0 or not root then

stopTrollSpectate()

return

end

local camera = workspace.CurrentCamera

if camera then

local lookPoint = (head and head.Position or root.Position) + Vector3.new(0, 1.5, 0)

local cameraPosition = root.Position - (root.CFrame.LookVector * 12) + Vector3.new(0, 10, 0)

camera.CameraType = Enum.CameraType.Scriptable

camera.CFrame = CFrame.lookAt(cameraPosition, lookPoint)

end

end)

end

local function runTrollLoopOnSelectedPlayer(target, targetCharacter, targetHumanoid, targetRoot, myCharacter, myHumanoid, myRoot)

local myCamera = game:GetService("Workspace").CurrentCamera

local vim = game:GetService("VirtualInputManager")

local timeSpentOnTarget = 0

local maxTargetTime = 0.7

while targetHumanoid and targetHumanoid.Health > 0 and _G.ArsenalTrollLoopKill and targetCharacter.Parent ~= nil and timeSpentOnTarget < maxTargetTime do

if targetRoot and myRoot then

local backOffset = (targetRoot.CFrame.LookVector * -6) + Vector3.new(0, 1, 0)

local proposedPosition = targetRoot.Position + backOffset

local raycastParams = RaycastParams.new()

raycastParams.FilterDescendantsInstances = {myCharacter, targetCharacter}

raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local rayResult = game:GetService("Workspace"):Raycast(proposedPosition + Vector3.new(0, 2, 0), Vector3.new(0, -5, 0), raycastParams)

if rayResult then

proposedPosition = Vector3.new(proposedPosition.X, rayResult.Position.Y + 3, proposedPosition.Z)

end

myRoot.CFrame = CFrame.new(proposedPosition, targetRoot.Position)

if myCamera then

myCamera.CFrame = CFrame.new(myCamera.CFrame.Position, targetRoot.Position)

end

end

if myCamera then

local size = myCamera.ViewportSize

local screenCenter = Vector2.new(size.X / 2, size.Y / 2)

local centerRay = myCamera:ViewportPointToRay(screenCenter.X, screenCenter.Y)

local clickRaycastParams = RaycastParams.new()

clickRaycastParams.FilterDescendantsInstances = {myCharacter}

clickRaycastParams.FilterType = Enum.RaycastFilterType.Exclude

local hoverResult = game:GetService("Workspace"):Raycast(centerRay.Origin, centerRay.Direction * 15, clickRaycastParams)

local isMouseOverTarget = false

if hoverResult and hoverResult.Instance then

if hoverResult.Instance:IsDescendantOf(targetCharacter) then

isMouseOverTarget = true

end

end

if isMouseOverTarget then

vim:SendMouseButtonEvent(screenCenter.X, screenCenter.Y, 0, true, game, 0)

task.wait(0.01)

vim:SendMouseButtonEvent(screenCenter.X, screenCenter.Y, 0, false, game, 0)

end

end

local frameTime = 0.03

task.wait(frameTime)

timeSpentOnTarget = timeSpentOnTarget + frameTime

end

end

local function stopTrollLoopKill()

TrollLoopKillRunId += 1

TrollLoopKillEnabled = false

_G.ArsenalTrollLoopKill = false

end

local function startTrollLoopKill()

local firstTarget = getTrollSelectedPlayer()

if not firstTarget then

print("Select a player first")

stopTrollLoopKill()

return

end

TrollLoopKillRunId += 1

local thisRun = TrollLoopKillRunId

TrollLoopKillEnabled = true

_G.ArsenalTrollLoopKill = true

if TrollLoopKillThreadRunning then

return

end

TrollLoopKillThreadRunning = true

task.spawn(function()

while TrollLoopKillEnabled and _G.ArsenalTrollLoopKill and TrollLoopKillRunId == thisRun do

local target = getTrollSelectedPlayer()

if not target then

stopTrollLoopKill()

break

end

local targetCharacter = target.Character

local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")

local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")

local myCharacter = LocalPlayer.Character

local myHumanoid = myCharacter and myCharacter:FindFirstChildOfClass("Humanoid")

local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")

if targetCharacter and targetHumanoid and targetRoot and myCharacter and myHumanoid and myRoot and targetHumanoid.Health > 0 and myHumanoid.Health > 0 then

local ok, err = pcall(function()

runTrollLoopOnSelectedPlayer(target, targetCharacter, targetHumanoid, targetRoot, myCharacter, myHumanoid, myRoot)

end)

if not ok then

warn("Loop Kill logic error: " .. tostring(err))

stopTrollLoopKill()

break

end

end

if not TrollLoopKillEnabled or not _G.ArsenalTrollLoopKill or TrollLoopKillRunId ~= thisRun then

break

end

task.wait()

end

TrollLoopKillThreadRunning = false

if TrollLoopKillRunId == thisRun then

TrollLoopKillEnabled = false

_G.ArsenalTrollLoopKill = false

end

end)

end

local function startAutoWin()

while _G.ArsenalAutoWin do

local myCharacter = game:GetService("Players").LocalPlayer.Character

local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")

local myCamera = game:GetService("Workspace").CurrentCamera

if myRoot then

local opponents = {}

local myTeam = game:GetService("Players").LocalPlayer.Team

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do

if player ~= game:GetService("Players").LocalPlayer then

if not myTeam or player.Team ~= myTeam then

local char = player.Character

local hum = char and char:FindFirstChildOfClass("Humanoid")

local root = char and char:FindFirstChild("HumanoidRootPart")

if hum and hum.Health > 0 and root and root.Position.Y > -50 then

table.insert(opponents, player)

end

end

end

end

local targetPlayer = #opponents > 0 and opponents[math.random(1, #opponents)] or nil

if targetPlayer then

local targetChar = targetPlayer.Character

local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

local targetHumanoid = targetChar and targetChar:FindFirstChildOfClass("Humanoid")

local timeSpentOnTarget = 0

local maxTargetTime = 0.7

while targetHumanoid and targetHumanoid.Health > 0 and _G.ArsenalAutoWin and targetChar.Parent ~= nil and timeSpentOnTarget < maxTargetTime do

if targetRoot and myRoot then

local backOffset = (targetRoot.CFrame.LookVector * -6) + Vector3.new(0, 1, 0)

local proposedPosition = targetRoot.Position + backOffset

local raycastParams = RaycastParams.new()

raycastParams.FilterDescendantsInstances = {myCharacter, targetChar}

raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local rayResult = game:GetService("Workspace"):Raycast(proposedPosition + Vector3.new(0, 2, 0), Vector3.new(0, -5, 0), raycastParams)

if rayResult then

proposedPosition = Vector3.new(proposedPosition.X, rayResult.Position.Y + 3, proposedPosition.Z)

end

myRoot.CFrame = CFrame.new(proposedPosition, targetRoot.Position)

if myCamera then

myCamera.CFrame = CFrame.new(myCamera.CFrame.Position, targetRoot.Position)

end

end

local tool = myCharacter and myCharacter:FindFirstChildOfClass("Tool")

if tool then tool:Activate() end

local frameTime = 0.03

task.wait(frameTime)

timeSpentOnTarget = timeSpentOnTarget + frameTime

end

end

end

task.wait(0.05)

end

end

local function stopAutoWin()

end

local function startTriggerbot()

while _G.ArsenalTriggerbot do

local myCharacter = game:GetService("Players").LocalPlayer.Character

local myCamera = game:GetService("Workspace").CurrentCamera

local vim = game:GetService("VirtualInputManager")

if myCharacter and myCamera then

local size = myCamera.ViewportSize

local centerPosition = Vector2.new(size.X / 2, size.Y / 2)

local viewportRay = myCamera:ViewportPointToRay(centerPosition.X, centerPosition.Y)

local raycastParams = RaycastParams.new()

raycastParams.FilterDescendantsInstances = {myCharacter}

raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local result = game:GetService("Workspace"):Raycast(viewportRay.Origin, viewportRay.Direction * 600, raycastParams)

if result and result.Instance then

local characterModel = result.Instance:FindFirstAncestorOfClass("Model")

local targetedPlayer = characterModel and game:GetService("Players"):GetPlayerFromCharacter(characterModel)

if targetedPlayer and targetedPlayer ~= game:GetService("Players").LocalPlayer then

local myTeam = game:GetService("Players").LocalPlayer.Team

if not myTeam or targetedPlayer.Team ~= myTeam then

local humanoid = characterModel:FindFirstChildOfClass("Humanoid")

if humanoid and humanoid.Health > 0 then

vim:SendMouseButtonEvent(centerPosition.X, centerPosition.Y, 0, true, game, 0)

task.wait(0.01)

vim:SendMouseButtonEvent(centerPosition.X, centerPosition.Y, 0, false, game, 0)

task.wait(0.08)

end

end

end

end

end

task.wait(0.016)

end

end

local function stopTriggerbot()

end

local FlyEnabled = false

local FlySpeed = 50

local FlyConnection = nil

local FlyKeys = {

W = false,

A = false,

S = false,

D = false,

Space = false,

LeftControl = false,

LeftShift = false

}

local function stopCFrameFly()

FlyEnabled = false

_G.ArsenalFly = false

if FlyConnection then

pcall(function()

FlyConnection:Disconnect()

end)

FlyConnection = nil

end

for key in pairs(FlyKeys) do

FlyKeys[key] = false

end

local char = LocalPlayer.Character

local hum = char and char:FindFirstChildOfClass("Humanoid")

local root = char and char:FindFirstChild("HumanoidRootPart")

if hum then

hum.PlatformStand = false

hum.AutoRotate = true

end

if root then

root.Anchored = false

root.AssemblyLinearVelocity = Vector3.zero

root.AssemblyAngularVelocity = Vector3.zero

root.Velocity = Vector3.zero

root.RotVelocity = Vector3.zero

end

for _, part in ipairs(char:GetDescendants()) do

if part:IsA("BasePart") then

part.CanCollide = true

end

end

end

local function startCFrameFly()

stopCFrameFly()

FlyEnabled = true

_G.ArsenalFly = true

FlyConnection = RunService.RenderStepped:Connect(function(dt)

if not FlyEnabled then return end

local char = LocalPlayer.Character

local hum = char and char:FindFirstChildOfClass("Humanoid")

local root = char and char:FindFirstChild("HumanoidRootPart")

local cam = workspace.CurrentCamera

if not hum or not root or not cam then

return

end

hum.PlatformStand = true

hum.AutoRotate = false

local move = Vector3.zero

if FlyKeys.W then

move += cam.CFrame.LookVector

end

if FlyKeys.S then

move -= cam.CFrame.LookVector

end

if FlyKeys.D then

move += cam.CFrame.RightVector

end

if FlyKeys.A then

move -= cam.CFrame.RightVector

end

if FlyKeys.Space then

move += Vector3.new(0, 1, 0)

end

if FlyKeys.LeftControl or FlyKeys.LeftShift then

move -= Vector3.new(0, 1, 0)

end

if move.Magnitude > 0 then

move = move.Unit

end

root.AssemblyLinearVelocity = Vector3.zero

root.AssemblyAngularVelocity = Vector3.zero

root.CFrame = root.CFrame + (move * FlySpeed * dt)

end)

end

UserInputService.InputBegan:Connect(function(input, gameProcessed)

if gameProcessed then return end

if input.KeyCode == Enum.KeyCode.W then FlyKeys.W = true end

if input.KeyCode == Enum.KeyCode.A then FlyKeys.A = true end

if input.KeyCode == Enum.KeyCode.S then FlyKeys.S = true end

if input.KeyCode == Enum.KeyCode.D then FlyKeys.D = true end

if input.KeyCode == Enum.KeyCode.Space then FlyKeys.Space = true end

if input.KeyCode == Enum.KeyCode.LeftControl then FlyKeys.LeftControl = true end

if input.KeyCode == Enum.KeyCode.LeftShift then FlyKeys.LeftShift = true end

end)

UserInputService.InputEnded:Connect(function(input)

if input.KeyCode == Enum.KeyCode.W then FlyKeys.W = false end

if input.KeyCode == Enum.KeyCode.A then FlyKeys.A = false end

if input.KeyCode == Enum.KeyCode.S then FlyKeys.S = false end

if input.KeyCode == Enum.KeyCode.D then FlyKeys.D = false end

if input.KeyCode == Enum.KeyCode.Space then FlyKeys.Space = false end

if input.KeyCode == Enum.KeyCode.LeftControl then FlyKeys.LeftControl = false end

if input.KeyCode == Enum.KeyCode.LeftShift then FlyKeys.LeftShift = false end

end)

local WeaponRainbowEnabled = false

local WeaponRainbowState = {

Connections = {},

RainbowParts = {},

WeaponNames = {},

Running = false

}

local function stopWeaponRainbow()

WeaponRainbowState.Running = false

pcall(function()

RunService:UnbindFromRenderStep("SmoothWeaponRainbow")

end)

for _, connection in ipairs(WeaponRainbowState.Connections) do

pcall(function()

connection:Disconnect()

end)

end

table.clear(WeaponRainbowState.Connections)

table.clear(WeaponRainbowState.RainbowParts)

table.clear(WeaponRainbowState.WeaponNames)

end

local function startWeaponRainbow()

stopWeaponRainbow()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Workspace = game:GetService("Workspace")

local SPEED = 0.20

local UPDATE_RATE = 1 / 30

WeaponRainbowState.Running = true

local function addConnection(connection)

table.insert(WeaponRainbowState.Connections, connection)

end

local function cleanName(name)

return tostring(name or ""):gsub("%s*%(Clone%)$", "")

end

local function saveWeaponNames(folder)

if not folder then return end

for _, item in ipairs(folder:GetChildren()) do

WeaponRainbowState.WeaponNames[cleanName(item.Name)] = true

end

addConnection(folder.ChildAdded:Connect(function(item)

WeaponRainbowState.WeaponNames[cleanName(item.Name)] = true

end))

end

saveWeaponNames(ReplicatedStorage:FindFirstChild("Weapons"))

saveWeaponNames(ReplicatedStorage:FindFirstChild("Melees"))

saveWeaponNames(ReplicatedStorage:FindFirstChild("Viewmodels"))

local function isWeaponRelated(obj)

local current = obj

while current and current ~= game do

local name = cleanName(current.Name)

if WeaponRainbowState.WeaponNames[name] then

return true

end

if current:IsA("Tool") then

return true

end

if Workspace.CurrentCamera and current == Workspace.CurrentCamera then

return true

end

current = current.Parent

end

return false

end

local function setupPart(obj)

if not obj:IsA("BasePart") then return end

if WeaponRainbowState.RainbowParts[obj] then return end

if not isWeaponRelated(obj) then return end

WeaponRainbowState.RainbowParts[obj] = true

obj.Material = Enum.Material.Neon

obj.Reflectance = 0

if obj:IsA("MeshPart") then

pcall(function()

obj.TextureID = ""

end)

end

for _, child in ipairs(obj:GetDescendants()) do

if child:IsA("SurfaceAppearance") or child:IsA("Decal") or child:IsA("Texture") then

child:Destroy()

end

end

end

local function scan(root)

if not root then return end

setupPart(root)

for _, obj in ipairs(root:GetDescendants()) do

setupPart(obj)

end

end

local function watch(root)

if not root then return end

scan(root)

addConnection(root.DescendantAdded:Connect(function(obj)

task.wait()

setupPart(obj)

end))

end

local backpack = LocalPlayer:FindFirstChild("Backpack")

if backpack then

watch(backpack)

end

if LocalPlayer.Character then

watch(LocalPlayer.Character)

end

addConnection(LocalPlayer.CharacterAdded:Connect(function(character)

watch(character)

end))

local function watchCamera()

if Workspace.CurrentCamera then

watch(Workspace.CurrentCamera)

end

end

watchCamera()

addConnection(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchCamera))

local hue = 0

local timer = 0

addConnection(RunService.RenderStepped:Connect(function(dt)

if not WeaponRainbowState.Running then return end

timer += dt

hue = (hue + dt * SPEED) % 1

if timer < UPDATE_RATE then

return

end

timer = 0

local color = Color3.fromHSV(hue, 1, 1)

for part in pairs(WeaponRainbowState.RainbowParts) do

if part and part.Parent then

part.Color = color

else

WeaponRainbowState.RainbowParts[part] = nil

end

end

end))

end

local ShowFOVCircle = true

local ShowESP = true

local ESPColor = Color3.new(0, 1, 0)

if not Drawing then

return

end

local FOVCircle = Drawing.new("Circle")

FOVCircle.Visible = ShowFOVCircle

FOVCircle.Radius = FOV

FOVCircle.Color = Color3.new(1, 1, 1)

FOVCircle.Thickness = 2

FOVCircle.Filled = false

FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

local ESPDrawings = {}

local function getPlayersName()

for _, v in pairs(game:GetChildren()) do

if v.ClassName == "Players" then

return v.Name

end

end

end

local players = game[getPlayersName()]

local localPlayer = players.LocalPlayer

local function safePart(character, ...)

if not character then return nil end

for _, name in ipairs({...}) do

local part = character:FindFirstChild(name)

if part then

return part

end

end

return character:FindFirstChildWhichIsA("BasePart")

end

local function safeRemoveDrawing(obj)

if obj then

pcall(function()

obj:Remove()

end)

end

end

local function CreateESP(player)

if ESPDrawings[player] then return end

local drawings = {}

drawings.Spine = Drawing.new("Line")

drawings.LeftUpperArm = Drawing.new("Line")

drawings.LeftLowerArm = Drawing.new("Line")

drawings.RightUpperArm = Drawing.new("Line")

drawings.RightLowerArm = Drawing.new("Line")

drawings.LeftUpperLeg = Drawing.new("Line")

drawings.LeftLowerLeg = Drawing.new("Line")

drawings.RightUpperLeg = Drawing.new("Line")

drawings.RightLowerLeg = Drawing.new("Line")

drawings.DistanceText = Drawing.new("Text")

drawings.DistanceText.Text = "0m"

drawings.DistanceText.Size = 16

drawings.DistanceText.Color = Color3.new(1, 1, 1)

drawings.DistanceText.Center = true

drawings.DistanceText.Outline = true

drawings.DistanceText.OutlineColor = Color3.new(0, 0, 0)

drawings.DistanceText.Visible = false

for name, line in pairs(drawings) do

if name:find("Arm") or name:find("Leg") or name == "Spine" then

line.Visible = false

line.Color = ESPColor

line.Thickness = 2

end

end

ESPDrawings[player] = drawings

end

local function RemoveESP(player)

if not ESPDrawings[player] then return end

for _, drawing in pairs(ESPDrawings[player]) do

safeRemoveDrawing(drawing)

end

ESPDrawings[player] = nil

end

local function UpdateESP()

for player, drawings in pairs(ESPDrawings) do

if player ~= LocalPlayer and player.Character and safePart(player.Character, "Head", "HeadHB", "HumanoidRootPart") then

if player.Team ~= LocalPlayer.Team then

local character = player.Character

local head = safePart(character, "Head", "HeadHB", "HumanoidRootPart")

local torso = safePart(character, "Torso", "UpperTorso", "HumanoidRootPart")

local leftUpperArm = safePart(character, "Left Arm", "LeftUpperArm", "LeftLowerArm")

local leftLowerArm = safePart(character, "LeftLowerArm", "Left Arm", "LeftUpperArm")

local rightUpperArm = safePart(character, "Right Arm", "RightUpperArm", "RightLowerArm")

local rightLowerArm = safePart(character, "RightLowerArm", "Right Arm", "RightUpperArm")

local leftUpperLeg = safePart(character, "Left Leg", "LeftUpperLeg", "LeftLowerLeg")

local leftLowerLeg = safePart(character, "LeftLowerLeg", "Left Leg", "LeftUpperLeg")

local rightUpperLeg = safePart(character, "Right Leg", "RightUpperLeg", "RightLowerLeg")

local rightLowerLeg = safePart(character, "RightLowerLeg", "Right Leg", "RightUpperLeg")

if head and torso then

local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)

local torsoPos, torsoOnScreen = Camera:WorldToViewportPoint(torso.Position)

if headOnScreen and torsoOnScreen then

drawings.Spine.From = Vector2.new(headPos.X, headPos.Y)

drawings.Spine.To = Vector2.new(torsoPos.X, torsoPos.Y)

drawings.Spine.Visible = ShowESP

if leftUpperArm then

local leftUpperArmPos, leftUpperArmOnScreen = Camera:WorldToViewportPoint(leftUpperArm.Position)

if leftUpperArmOnScreen then

drawings.LeftUpperArm.From = Vector2.new(torsoPos.X, torsoPos.Y)

drawings.LeftUpperArm.To = Vector2.new(leftUpperArmPos.X, leftUpperArmPos.Y)

drawings.LeftUpperArm.Visible = ShowESP

if leftLowerArm and leftLowerArm ~= leftUpperArm then

local leftLowerArmPos, leftLowerArmOnScreen = Camera:WorldToViewportPoint(leftLowerArm.Position)

if leftLowerArmOnScreen then

drawings.LeftLowerArm.From = Vector2.new(leftUpperArmPos.X, leftUpperArmPos.Y)

drawings.LeftLowerArm.To = Vector2.new(leftLowerArmPos.X, leftLowerArmPos.Y)

drawings.LeftLowerArm.Visible = ShowESP

else

drawings.LeftLowerArm.Visible = false

end

else

drawings.LeftLowerArm.Visible = false

end

else

drawings.LeftUpperArm.Visible = false

drawings.LeftLowerArm.Visible = false

end

else

drawings.LeftUpperArm.Visible = false

drawings.LeftLowerArm.Visible = false

end

if rightUpperArm then

local rightUpperArmPos, rightUpperArmOnScreen = Camera:WorldToViewportPoint(rightUpperArm.Position)

if rightUpperArmOnScreen then

drawings.RightUpperArm.From = Vector2.new(torsoPos.X, torsoPos.Y)

drawings.RightUpperArm.To = Vector2.new(rightUpperArmPos.X, rightUpperArmPos.Y)

drawings.RightUpperArm.Visible = ShowESP

if rightLowerArm and rightLowerArm ~= rightUpperArm then

local rightLowerArmPos, rightLowerArmOnScreen = Camera:WorldToViewportPoint(rightLowerArm.Position)

if rightLowerArmOnScreen then

drawings.RightLowerArm.From = Vector2.new(rightUpperArmPos.X, rightUpperArmPos.Y)

drawings.RightLowerArm.To = Vector2.new(rightLowerArmPos.X, rightLowerArmPos.Y)

drawings.RightLowerArm.Visible = ShowESP

else

drawings.RightLowerArm.Visible = false

end

else

drawings.RightLowerArm.Visible = false

end

else

drawings.RightUpperArm.Visible = false

drawings.RightLowerArm.Visible = false

end

else

drawings.RightUpperArm.Visible = false

drawings.RightLowerArm.Visible = false

end

if leftUpperLeg then

local leftUpperLegPos, leftUpperLegOnScreen = Camera:WorldToViewportPoint(leftUpperLeg.Position)

if leftUpperLegOnScreen then

drawings.LeftUpperLeg.From = Vector2.new(torsoPos.X, torsoPos.Y)

drawings.LeftUpperLeg.To = Vector2.new(leftUpperLegPos.X, leftUpperLegPos.Y)

drawings.LeftUpperLeg.Visible = ShowESP

if leftLowerLeg and leftLowerLeg ~= leftUpperLeg then

local leftLowerLegPos, leftLowerLegOnScreen = Camera:WorldToViewportPoint(leftLowerLeg.Position)

if leftLowerLegOnScreen then

drawings.LeftLowerLeg.From = Vector2.new(leftUpperLegPos.X, leftUpperLegPos.Y)

drawings.LeftLowerLeg.To = Vector2.new(leftLowerLegPos.X, leftLowerLegPos.Y)

drawings.LeftLowerLeg.Visible = ShowESP

else

drawings.LeftLowerLeg.Visible = false

end

else

drawings.LeftLowerLeg.Visible = false

end

else

drawings.LeftUpperLeg.Visible = false

drawings.LeftLowerLeg.Visible = false

end

else

drawings.LeftUpperLeg.Visible = false

drawings.LeftLowerLeg.Visible = false

end

if rightUpperLeg then

local rightUpperLegPos, rightUpperLegOnScreen = Camera:WorldToViewportPoint(rightUpperLeg.Position)

if rightUpperLegOnScreen then

drawings.RightUpperLeg.From = Vector2.new(torsoPos.X, torsoPos.Y)

drawings.RightUpperLeg.To = Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y)

drawings.RightUpperLeg.Visible = ShowESP

if rightLowerLeg and rightLowerLeg ~= rightUpperLeg then

local rightLowerLegPos, rightLowerLegOnScreen = Camera:WorldToViewportPoint(rightLowerLeg.Position)

if rightLowerLegOnScreen then

drawings.RightLowerLeg.From = Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y)

drawings.RightLowerLeg.To = Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y)

drawings.RightLowerLeg.Visible = ShowESP

else

drawings.RightLowerLeg.Visible = false

end

else

drawings.RightLowerLeg.Visible = false

end

else

drawings.RightUpperLeg.Visible = false

drawings.RightLowerLeg.Visible = false

end

else

drawings.RightUpperLeg.Visible = false

drawings.RightLowerLeg.Visible = false

end

local distance = math.floor((head.Position - Camera.CFrame.Position).Magnitude)

drawings.DistanceText.Text = distance .. "m"

drawings.DistanceText.Position = Vector2.new(headPos.X, headPos.Y - 25)

drawings.DistanceText.Visible = ShowESP

else

for _, element in pairs(drawings) do

element.Visible = false

end

end

else

for _, element in pairs(drawings) do

element.Visible = false

end

end

else

for _, element in pairs(drawings) do

element.Visible = false

end

end

else

for _, element in pairs(drawings) do

element.Visible = false

end

end

end

end

local function setArsenalCamlockSmoothing(value)

Smoothing = math.clamp(tonumber(value) or tonumber(Smoothing) or 10, 1, 100)

_G.ArsenalCamlockSmoothness = Smoothing

return Smoothing

end

local function getArsenalCamlockSmoothing()

Smoothing = math.clamp(tonumber(_G.ArsenalCamlockSmoothness) or tonumber(Smoothing) or 10, 1, 100)

return Smoothing

end

local function getArsenalCamlockAlpha(dt)

local smooth = getArsenalCamlockSmoothing()

if smooth <= 1 then

return 1

end

dt = math.clamp(tonumber(dt) or (1 / 60), 1 / 240, 1 / 15)

local speed = 140 / smooth

return math.clamp(1 - math.exp(-speed * dt), 0.01, 1)

end

local function getCamlockPart(character)

if not character then return nil end

local wanted = CamlockConfig.LockPart or "Head"

if wanted == "Random" then

local options = {"Head", "HeadHB", "UpperTorso", "Torso", "HumanoidRootPart"}

wanted = options[math.random(1, #options)]

end

return safePart(character, wanted, "Head", "HeadHB", "UpperTorso", "Torso", "HumanoidRootPart")

end

local function isCamlockAlive(player)

local character = player and player.Character

local humanoid = character and character:FindFirstChildOfClass("Humanoid")

return character ~= nil and humanoid ~= nil and humanoid.Health > 0

end

local function isCamlockOnScreen(part)

local cam = workspace.CurrentCamera

if not cam or not part then return false end

local _, onScreen = cam:WorldToViewportPoint(part.Position)

return onScreen == true

end

local function IsPlayerVisible(player, targetPart)

local cam = workspace.CurrentCamera

if not cam or not player or not player.Character or not targetPart then

return false

end

local origin = cam.CFrame.Position

local direction = targetPart.Position - origin

if direction.Magnitude <= 0.1 then

return true

end

local params = RaycastParams.new()

params.FilterType = Enum.RaycastFilterType.Exclude

params.FilterDescendantsInstances = {LocalPlayer.Character}

params.IgnoreWater = true

local result = workspace:Raycast(origin, direction, params)

if not result then

return true

end

return result.Instance and result.Instance:IsDescendantOf(player.Character)

end

local function IsInFOVCircle(targetPart)

local cam = workspace.CurrentCamera

if not cam or not targetPart then return false end

if not CamlockConfig.FOVEnabled then

return true

end

local screenPoint, onScreen = cam:WorldToViewportPoint(targetPart.Position)

if not onScreen then

return false

end

local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude

return distance <= FOV

end

local function passesCamlockChecks(player, targetPart)

if not player or player == LocalPlayer or not targetPart then

return false

end

if CamlockConfig.DeathCheck and not isCamlockAlive(player) then

return false

end

if CamlockConfig.TeamCheck and LocalPlayer.Team ~= nil and player.Team == LocalPlayer.Team then

return false

end

if CamlockConfig.VisibleCheck and not isCamlockOnScreen(targetPart) then

return false

end

if CamlockConfig.WallCheck and not IsPlayerVisible(player, targetPart) then

return false

end

if not IsInFOVCircle(targetPart) then

return false

end

return true

end

local function GetClosestPlayerInFOV()

local cam = workspace.CurrentCamera

if not cam then return nil, nil end

pcall(function()

FOVCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

FOVCircle.Radius = FOV

FOVCircle.Visible = ShowFOVCircle

end)

local closestPlayer = nil

local closestPart = nil

local shortestDistance = math.huge

local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

for _, player in ipairs(Players:GetPlayers()) do

if player ~= LocalPlayer and player.Character then

local targetPart = getCamlockPart(player.Character)

if targetPart and passesCamlockChecks(player, targetPart) then

local screenPoint, onScreen = cam:WorldToViewportPoint(targetPart.Position)

if onScreen then

local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude

if distance < shortestDistance then

closestPlayer = player

closestPart = targetPart

shortestDistance = distance

end

end

end

end

end

return closestPlayer, closestPart

end

local function Camlock(dt)

if not Enabled then return end

local cam = workspace.CurrentCamera

if not cam then return end

local closestPlayer, target = GetClosestPlayerInFOV()

if not closestPlayer or not target then

return

end

local origin = cam.CFrame.Position

local direction = target.Position - origin

if direction.Magnitude <= 0.1 then

return

end

local goal = CFrame.new(origin, target.Position)

local alpha = getArsenalCamlockAlpha(dt)

cam.CFrame = cam.CFrame:Lerp(goal, alpha)

end

CamlockSection:CreateSwitch("Enable Camlock", function(value)

Enabled = value

print("Camlock " .. (value and "Enabled" or "Disabled"))

end, Enabled)

CamlockSection:CreateSwitch("FOV Enabled", function(value)

CamlockConfig.FOVEnabled = value

print("FOV Enabled " .. (value and "Enabled" or "Disabled"))

end, CamlockConfig.FOVEnabled)

CamlockSection:CreateSwitch("Wall Check", function(value)

CamlockConfig.WallCheck = value

print("Wall Check " .. (value and "Enabled" or "Disabled"))

end, CamlockConfig.WallCheck)

CamlockSection:CreateSwitch("Team Check", function(value)

CamlockConfig.TeamCheck = value

print("Team Check " .. (value and "Enabled" or "Disabled"))

end, CamlockConfig.TeamCheck)

CamlockSection:CreateSwitch("Visible Check", function(value)

CamlockConfig.VisibleCheck = value

print("Visible Check " .. (value and "Enabled" or "Disabled"))

end, CamlockConfig.VisibleCheck)

CamlockSection:CreateSwitch("Death Check", function(value)

CamlockConfig.DeathCheck = value

print("Death Check " .. (value and "Enabled" or "Disabled"))

end, CamlockConfig.DeathCheck)

CamlockSection:CreateSlider("FOV Size", function(value)

FOV = value

FOVCircle.Radius = value

print("FOV set to: " .. value)

end, 30, 500, 1, false, FOV)

CamlockSection:CreateSlider("Smoothness", function(value)

setArsenalCamlockSmoothing(value)

print("Smoothness set to: " .. tostring(Smoothing))

end, 1, 100, 1, false, Smoothing)

CamlockSection:CreateButton("Lock Part: Head", function()

local order = {"Head", "HeadHB", "UpperTorso", "HumanoidRootPart", "Random"}

local index = table.find(order, CamlockConfig.LockPart) or 1

index = (index % #order) + 1

CamlockConfig.LockPart = order[index]

print("Lock Part set to: " .. CamlockConfig.LockPart)

end)

TriggerbotSection:CreateSwitch("Enable Triggerbot", function(value)

TriggerbotEnabled = value

_G.ArsenalTriggerbot = value

if value then

startTriggerbot()

else

stopTriggerbot()

end

print("Triggerbot " .. (value and "Enabled" or "Disabled"))

end, TriggerbotEnabled)

FlySection:CreateSwitch("CFrame Fly", function(value)

FlyEnabled = value

_G.ArsenalFly = value

if value then

startCFrameFly()

else

stopCFrameFly()

end

print("CFrame Fly " .. (value and "Enabled" or "Disabled"))

end, FlyEnabled)

FlySection:CreateSlider("Fly Speed", function(value)

FlySpeed = value

_G.ArsenalFlySpeed = value

print("Fly Speed set to: " .. value)

end, 10, 250, 1, false, FlySpeed)

VisualsSection:CreateSwitch("Show FOV Circle", function(value)

ShowFOVCircle = value

FOVCircle.Visible = value

print("FOV Circle " .. (value and "Enabled" or "Disabled"))

end, ShowFOVCircle)

VisualsSection:CreateSwitch("Rainbow Weapons", function(value)

WeaponRainbowEnabled = value

_G.ArsenalRainbowWeapons = value

if value then

startWeaponRainbow()

else

stopWeaponRainbow()

end

print("Rainbow Weapons " .. (value and "Enabled" or "Disabled"))

end, WeaponRainbowEnabled)

VisualsSection:CreateSwitch("Show ESP Skeleton", function(value)

ShowESP = value

print("ESP Skeleton " .. (value and "Enabled" or "Disabled"))

end, ShowESP)

SettingsSection:CreateSlider("FOV Size", function(value)

FOV = value

FOVCircle.Radius = value

print("FOV set to: " .. value)

end, 50, 300, 1, false, FOV)

SettingsSection:CreateSlider("Smoothing", function(value)

setArsenalCamlockSmoothing(value)

print("Smoothing set to: " .. tostring(Smoothing))

end, 1, 100, 1, false, Smoothing)

SettingsSection:CreateColorPicker("ESP Color", function(value)

ESPColor = value

for _, drawings in pairs(ESPDrawings) do

if drawings.Spine then drawings.Spine.Color = value end

if drawings.LeftUpperArm then drawings.LeftUpperArm.Color = value end

if drawings.LeftLowerArm then drawings.LeftLowerArm.Color = value end

if drawings.RightUpperArm then drawings.RightUpperArm.Color = value end

if drawings.RightLowerArm then drawings.RightLowerArm.Color = value end

if drawings.LeftUpperLeg then drawings.LeftUpperLeg.Color = value end

if drawings.LeftLowerLeg then drawings.LeftLowerLeg.Color = value end

if drawings.RightUpperLeg then drawings.RightUpperLeg.Color = value end

if drawings.RightLowerLeg then drawings.RightLowerLeg.Color = value end

end

print("ESP Color changed to: " .. tostring(value))

end, false, ESPColor)

SettingsSection:CreateSwitch("Auto Win", function(value)

AutoWinEnabled = value

_G.ArsenalAutoWin = value

if value then

startAutoWin()

else

stopAutoWin()

end

print("Auto Win " .. (value and "Enabled" or "Disabled"))

end, AutoWinEnabled)

TrollSelectedButtonText = TrollCheatersSection:CreateButton("Selected Player: None", function()

updateTrollSelectedText()

end)

local PlayerBarButtons = {}

local PlayerBarConnections = {}

local function addPlayerBarConnection(connection)

if connection then

table.insert(PlayerBarConnections, connection)

end

return connection

end

local function isOppositeTeamPlayer(player)

if not player or player == LocalPlayer or player.Parent ~= Players then

return false

end

if LocalPlayer.Team then

return player.Team ~= LocalPlayer.Team

end

return true

end

local function destroyPlayerBarButton(player)

local obj = PlayerBarButtons[player]

PlayerBarButtons[player] = nil

local function destroyObj(value)

if typeof(value) == "Instance" then

pcall(function()

value:Destroy()

end)

elseif type(value) == "table" then

for _, child in pairs(value) do

destroyObj(child)

end

end

end

destroyObj(obj)

end

local function clearSelectedIfInvalid()

local selected = getTrollSelectedPlayer()

if selected and not isOppositeTeamPlayer(selected) then

setTrollSelectedPlayer(nil)

stopTrollSpectate()

stopTrollLoopKill()

end

end

local function addPlayerBarButton(player)

if not isOppositeTeamPlayer(player) or PlayerBarButtons[player] then

return

end

PlayerBarButtons[player] = PlayerBarSection:CreateButton(player.Name, function()

if isOppositeTeamPlayer(player) then

setTrollSelectedPlayer(player)

else

setTrollSelectedPlayer(nil)

destroyPlayerBarButton(player)

end

end)

end

local function refreshPlayerBar()

for player in pairs(PlayerBarButtons) do

if not isOppositeTeamPlayer(player) then

destroyPlayerBarButton(player)

end

end

for _, player in ipairs(Players:GetPlayers()) do

addPlayerBarButton(player)

end

clearSelectedIfInvalid()

end

for _, player in ipairs(Players:GetPlayers()) do

addPlayerBarButton(player)

if player ~= LocalPlayer then

addPlayerBarConnection(player:GetPropertyChangedSignal("Team"):Connect(refreshPlayerBar))

end

end

addPlayerBarConnection(LocalPlayer:GetPropertyChangedSignal("Team"):Connect(refreshPlayerBar))

addPlayerBarConnection(Players.PlayerAdded:Connect(function(player)

addPlayerBarConnection(player:GetPropertyChangedSignal("Team"):Connect(refreshPlayerBar))

refreshPlayerBar()

end))

addPlayerBarConnection(Players.PlayerRemoving:Connect(function(player)

if TrollSelectedPlayer == player then

setTrollSelectedPlayer(nil)

stopTrollSpectate()

stopTrollLoopKill()

end

destroyPlayerBarButton(player)

end))

refreshPlayerBar()

TrollCheatersSection:CreateSwitch("Spectate Player", function(value)

TrollSpectateEnabled = value

_G.ArsenalTrollSpectate = value

if value then

startTrollSpectate()

else

stopTrollSpectate()

end

updateTrollSpectateText()

print("Spectate Player " .. (TrollSpectateEnabled and "Enabled" or "Disabled"))

end, TrollSpectateEnabled)

TrollCheatersSection:CreateSwitch("Loop Kill", function(value)

if value then

startTrollLoopKill()

else

stopTrollLoopKill()

end

print("Loop Kill " .. (TrollLoopKillEnabled and "Enabled" or "Disabled"))

end, false)

task.defer(function()

updateTrollSelectedText()

updateTrollSpectateText()

end)

TrollCheatersSection:CreateButton("Kill Loader", function()

restoreLocalMovementAfterArsenal()

local loader = _G.ArsenalStandaloneLoader

if loader and loader.Destroy then

loader.Destroy()

end

end)

TrollCheatersSection:CreateButton("Reset Settings", function()

Enabled = true

FOV = 100

Smoothing = 10

ShowFOVCircle = true

ShowESP = true

ESPColor = Color3.new(0, 1, 0)

FOVCircle.Radius = FOV

FOVCircle.Visible = ShowFOVCircle

for _, drawings in pairs(ESPDrawings) do

for _, line in pairs(drawings) do

line.Color = ESPColor

end

end

print("Troll Cheaters settings reset to default")

end)

SettingsSection:CreateButton("Kill Loader", function()

local loader = _G.ArsenalStandaloneLoader

if loader and loader.Destroy then

loader.Destroy()

end

end)

SettingsSection:CreateButton("Reset Settings", function()

Enabled = true

FOV = 100

Smoothing = 10

ShowFOVCircle = true

ShowESP = true

ESPColor = Color3.new(0, 1, 0)

FOVCircle.Radius = FOV

FOVCircle.Visible = ShowFOVCircle

for _, drawings in pairs(ESPDrawings) do

for _, line in pairs(drawings) do

line.Color = ESPColor

end

end

print("Settings reset to default")

end)

_G.ArsenalStandaloneConnections = {}

local success, err = pcall(function()

table.insert(_G.ArsenalStandaloneConnections, RunService.RenderStepped:Connect(function()

FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

pcall(UpdateESP)

end))

pcall(function()

RunService:UnbindFromRenderStep(ArsenalCamlockStepName)

end)

RunService:BindToRenderStep(ArsenalCamlockStepName, Enum.RenderPriority.Camera.Value + 50, function(dt)

pcall(function()

Camlock(dt)

end)

end)

table.insert(_G.ArsenalStandaloneConnections, {

Disconnect = function()

pcall(function()

RunService:UnbindFromRenderStep(ArsenalCamlockStepName)

end)

end

})

end)

if not success then

warn("Error in RenderStepped connection: " .. err)

end

for _, player in pairs(Players:GetPlayers()) do

if player ~= LocalPlayer then

CreateESP(player)

end

end

table.insert(_G.ArsenalStandaloneConnections, Players.PlayerAdded:Connect(function(player)

CreateESP(player)

end))

table.insert(_G.ArsenalStandaloneConnections, Players.PlayerRemoving:Connect(function(player)

RemoveESP(player)

end))

_G.ArsenalStandaloneLoader = {

Destroy = function()

stopCFrameFly()

stopWeaponRainbow()

stopTrollSpectate()

stopTrollLoopKill()

pcall(function()

RunService:UnbindFromRenderStep(ArsenalCamlockStepName)

end)

restoreLocalMovementAfterArsenal()

if PlayerBarConnections then

for _, connection in ipairs(PlayerBarConnections) do

pcall(function()

connection:Disconnect()

end)

end

table.clear(PlayerBarConnections)

end

if PlayerBarButtons then

for player in pairs(PlayerBarButtons) do

destroyPlayerBarButton(player)

end

end

if FOVCircle then

safeRemoveDrawing(FOVCircle)

end

for player, drawings in pairs(ESPDrawings) do

RemoveESP(player)

end

if _G.ArsenalStandaloneConnections then

for _, connection in ipairs(_G.ArsenalStandaloneConnections) do

pcall(function()

connection:Disconnect()

end)

end

_G.ArsenalStandaloneConnections = nil

end

if gui then

pcall(function() gui:CleanUp() end)

pcall(function() gui:Hide() end)

if gui.ScreenGui then

gui.ScreenGui:Destroy()

end

end

for _, obj in pairs(game.CoreGui:GetChildren()) do

if obj.Name:find("DropLib") or obj.Name:find("Arsenal") then

obj:Destroy()

end

end

_G.ArsenalStandaloneLoader = nil

print("Arsenal Script and GUI destroyed")

end

}

]==========]

local runner, compileErr = loadstring(code)

if not runner then

notify("Arsenal compile error")

warn(compileErr)

return

end

local ok, runErr = pcall(runner)

if not ok then

notify("Arsenal run error")

warn(runErr)

return

end

notify("Arsenal loaded")

end

function makePagesAndControls()

local Favorites = page("Favorites")

local Combat = page("Combat")

local Player = page("Player")

local Visuals = page("Visuals")

local Misc = page("Misc")

local Prevent = page("Cheater Prevention")

local Commands = page("Commands")

_G.BETA_OwnTrollFunnyPage = page("Own/Troll/Funny")

_G.BETA_LoadersPage = page("In Game Loaders")

local f1 = card(Favorites, "Favorites", 1)

makeButton(f1, "Toggle ESP", 1, function() Toggles.ESP.Set(not Toggles.ESP.Get(), true) end)

makeButton(f1, "Toggle Camlock", 2, function() Toggles.Camlock.Set(not Toggles.Camlock.Get(), true) end)

makeButton(f1, "Save Position", 3, function()

if isAlive(LocalPlayer.Character) then

_G.SavedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame

notify("Position Saved")

end

end)

makeButton(f1, "Return Position", 4, function()

if isAlive(LocalPlayer.Character) and _G.SavedPosition then

LocalPlayer.Character.HumanoidRootPart.CFrame = _G.SavedPosition + Vector3.new(0, 3, 0)

notify("Returned")

end

end)

buildOwnTrollFunnyBoard(_G.BETA_OwnTrollFunnyPage)

local LoaderClickCode = {

["Prison Life"] = function()

loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/7190069da5cf5e79b2d88dc3e7e51a734971808011659b1f1197369703663f01/download"))()

print("32Dev_LOL im on tt with more scripts, i made all of this. enjoy :)")

end,

["Arsenal"] = function()

if _G.BETA_OPEN_ARSENAL_LOADER then

_G.BETA_OPEN_ARSENAL_LOADER()

else

notify("Arsenal loader missing")

end

end,

["Rivals"] = function()

repeat task.wait() until game:IsLoaded()

repeat task.wait() until game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Character

repeat task.wait() until not game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("LoadingScreen")

getgenv().autoload = autoloadEnabled

getgenv().silentload = silentloadEnabled

getgenv().SCRIPT_KEY = ""

loadstring(game:HttpGet("https://api.junkie-development.de/api/v1/luascripts/public/8be52e21a0145a401c446ca7ab2b5df9bd327ea80b0cf1d2fe99e442edd0f9c9/download"))()

loadstring(game:HttpGet("https://raw.githubusercontent.com/blackowl1231/Z3US/refs/heads/main/Games/Test.lua"))()

print("Z3US debugged by 32Dev_LOL")

end,

["Blade Ball"] = function()

loadstring(game:HttpGet("https://rblxscripts.net/raw/rise-for-blade-ball-auto-parry-ap-auto-spam-auto-abilities-a-7ac6682a"))()

end,

["Blox Fruits"] = function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/Kenniel123/BloxFruits/refs/heads/main/BloxFruits"))()

end,

["Doors"] = function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/Loader.luau"))()

end,

["Brookhaven"] = function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/TheDarkoneMarcillisePex/Other-Scripts/main/Brook%20Haven%20Gui"))()

end,

["Murder Mystery 2"] = function()

loadstring(game:HttpGet('https://raw.smokingscripts.org/vertex.lua'))()

end,

["BedWars"] = function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWRewrite/master/NewMainScript.lua", true))()

end,

["Da Hood"] = function()

loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/606b846e88998801018fae498b9b8a3c.lua"))()

end,

["Adopt Me"] = function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/kurixxx/ADOPTME/refs/heads/main/AUTOFARM"))()

end,

["Pet Simulator 99"] = function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/SlamminPig/6FootScripts/main/Scripts/PetSimulator99.lua"))()

end,

["The Strongest Battlegrounds"] = function()

loadstring(game:HttpGet("https://rawscripts.net/raw/The-Strongest-Battlegrounds-Phantasm-TSB-OP-228149"))()

end,

["Jujutsu Shenanigans"] = function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/cool5013/TBO/main/TBOscript"))()

end,

["Fisch"] = function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/TheDarkoneMarcillisePex/Other-Scripts/refs/heads/main/Fisch%20GUI"))()

end,

["Jailbreak"] = function()

loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/730854e5b6499ee91deb1080e8e12ae3.lua"))()

script_key = 'place key here - 32dev_lol' -- uncomment this line for paid (remove the '--')

loadstring(game:HttpGet('https://scripts.projectauto.xyz/AutoRobV6'))()

end,

["Tower of Hell"] = function()

loadstring(game:HttpGet("https://coolxplo.github.io/DP-HUB-coolxplo/Tower%20Of%20Hell.lua"))()

end,

["Natural Disaster Survival"] = function()

loadstring(game:HttpGet("https://pastebin.com/raw/knSiECa1"))()

end,

["Pls Donate"] = function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/CF-Trail/tzechco-PlsDonateAutofarmBackup/main/old.lua"))()

end,

["Anime Vanguards"] = function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/CHASEAAAA/vanguard/refs/heads/main/.lua",true))()

end,

["Dress To Impress"] = function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/hellohellohell012321/DTI-GUI-V2/main/dti_gui_v2.lua"))()

end,

["Build A Boat"] = function()

loadstring(game:HttpGet("https://rawscripts.net/raw/Build-A-Boat-For-Treasure-Ultimte-B3BFT-Script-28601"))()

end

}

local LoaderOrder = {

"Prison Life",

"Arsenal",

"Rivals",

"Blade Ball",

"Blox Fruits",

"Doors",

"Brookhaven",

"Murder Mystery 2",

"BedWars",

"Da Hood",

"Adopt Me",

"Pet Simulator 99",

"The Strongest Battlegrounds",

"Jujutsu Shenanigans",

"Fisch",

"Jailbreak",

"Tower of Hell",

"Natural Disaster Survival",

"Pls Donate",

"Anime Vanguards",

"Dress To Impress",

"Build A Boat"

}

local function runLoaderClickCode(loaderName)

local runner = LoaderClickCode[loaderName]

if type(runner) == "function" then

local ok, err = pcall(runner)

if not ok then

warn("Loader click code error for " .. tostring(loaderName) .. ": " .. tostring(err))

notify(tostring(loaderName) .. " code error")

end

return true

end

return false

end

local function buildLoadersSearch(parent)

local loadersContent, loadersFrame = card(parent, "Loaders", 1)

loadersFrame.Size = UDim2.new(1, -8, 0, 540)

local searchBox = Instance.new("TextBox")

searchBox.Size = UDim2.new(1, 0, 0, 30)

searchBox.BackgroundColor3 = C.P2

searchBox.BorderSizePixel = 0

searchBox.ClearTextOnFocus = false

searchBox.PlaceholderText = "Search loaders..."

searchBox.Text = ""

searchBox.Font = getFont()

searchBox.TextSize = 13

searchBox.TextColor3 = C.TX

searchBox.PlaceholderColor3 = C.SUB

searchBox.LayoutOrder = 1

searchBox.Parent = loadersContent

themeObj(searchBox, "Button")

textObj(searchBox)

stroke(searchBox, C.W, 1)

corner(searchBox, 6)

local list = Instance.new("ScrollingFrame")

list.Size = UDim2.new(1, 0, 0, 470)

list.BackgroundColor3 = C.P

list.BackgroundTransparency = 0.15

list.BorderSizePixel = 0

list.ScrollBarThickness = 5

list.ScrollBarImageColor3 = C.W

list.CanvasSize = UDim2.new(0, 0, 0, 0)

list.AutomaticCanvasSize = Enum.AutomaticSize.Y

list.LayoutOrder = 2

list.Parent = loadersContent

themeObj(list, "Button2")

stroke(list, C.W, 1)

corner(list, 6)

local listPad = Instance.new("UIPadding")

listPad.PaddingTop = UDim.new(0, 6)

listPad.PaddingBottom = UDim.new(0, 6)

listPad.PaddingLeft = UDim.new(0, 6)

listPad.PaddingRight = UDim.new(0, 6)

listPad.Parent = list

local listLayout = Instance.new("UIListLayout")

listLayout.Padding = UDim.new(0, 4)

listLayout.SortOrder = Enum.SortOrder.LayoutOrder

listLayout.Parent = list

local rows = {}

local function addLoaderRow(loaderName, order)

local row = Instance.new("TextButton")

row.Size = UDim2.new(1, -4, 0, 30)

row.BackgroundColor3 = C.P2

row.BorderSizePixel = 0

row.Text = loaderName

row.Font = getFont()

row.TextSize = 12

row.TextColor3 = C.TX

row.TextXAlignment = Enum.TextXAlignment.Left

row.LayoutOrder = order

row.Parent = list

themeObj(row, "Button")

textObj(row)

stroke(row, C.W, 1)

corner(row, 6)

local pad = Instance.new("UIPadding")

pad.PaddingLeft = UDim.new(0, 9)

pad.Parent = row

row.MouseEnter:Connect(function()

row.BackgroundColor3 = C.A2

row.TextColor3 = C.W

end)

row.MouseLeave:Connect(function()

row.BackgroundColor3 = C.P2

row.TextColor3 = C.TX

end)

row.MouseButton1Click:Connect(function()

if _G.BETA_KILLED then return end

playUISound()

print("[BETA GUI] Loader clicked: " .. tostring(loaderName))

local ran = runLoaderClickCode(loaderName)

if not ran then

notify(tostring(loaderName) .. " clicked")

end

end)

table.insert(rows, {

Row = row,

Search = string.lower(loaderName)

})

end

for index, loaderName in ipairs(LoaderOrder) do

addLoaderRow(loaderName, index)

end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()

local q = string.lower(searchBox.Text or "")

for _, item in ipairs(rows) do

local visible = q == "" or string.find(item.Search, q, 1, true) ~= nil

item.Row.Visible = visible

item.Row.Size = visible and UDim2.new(1, -4, 0, 30) or UDim2.new(1, -4, 0, 0)

end

end)

end

buildLoadersSearch(_G.BETA_LoadersPage)

local cTarget = card(Combat, "Target", 1)

makeToggle(cTarget, "Camlock", "Camlock", true, 1, "Locks camera toward closest player to mouse.")

makeSlider(cTarget, "Smoothness: ", "CL_Smoothness", 1, 100, 2, "Higher is smoother/slower.")

makeCycle(cTarget, "Lock Part", {"Head","UpperTorso","HumanoidRootPart","LowerTorso","Random"}, "LockPart", 3)

local cChecks = card(Combat, "Target Checks", 2)

makeToggle(cChecks, "Wall Check", "Camlock_WallCheck", false, 1, "Only picks targets with clear line of sight.", _G.Camlock_WallCheck)

makeToggle(cChecks, "Team Check", "Camlock_TeamCheck", false, 2, "Skips players on your team.", _G.Camlock_TeamCheck)

makeToggle(cChecks, "Visible Check", "Camlock_VisibleCheck", false, 3, "Only picks targets visible on screen.", _G.Camlock_VisibleCheck)

makeToggle(cChecks, "Death Check", "Camlock_DeathCheck", false, 4, "If locked target dies, camlock stops until you retoggle it.", _G.Camlock_DeathCheck)

local cPreset = card(Combat, "Combat Presets", 3)

makeButton(cPreset, "Legit Preset", 1, function() setPreset("Legit") end)

makeButton(cPreset, "Smooth Preset", 2, function() setPreset("Smooth") end)

makeButton(cPreset, "Fast Preset", 3, function() setPreset("Fast") end)

makeButton(cPreset, "Wide Preset", 4, function() setPreset("Wide") end)

local cFov = card(Combat, "Field Of View", 4)

makeToggle(cFov, "FOV Enabled", "FOV_Enabled", false, 1, "Limits lock selection to FOV.", _G.FOV_Enabled)

makeToggle(cFov, "FOV Visible", "FOV_Visible", false, 2, "Shows or hides FOV.", _G.FOV_Visible)

makeSlider(cFov, "FOV Size: ", "FOV_Radius", 30, 500, 3, "FOV size.")

makeCycle(cFov, "FOV Style", {"Circle","Square","Cross"}, "FOV_Style", 4)

local cLock = card(Combat, "Lock Feedback", 5)

makeToggle(cLock, "Locked Highlight", "LockedHighlight", false, 1, "Red highlight on locked target.")

makeToggle(cLock, "Locked Tracer", "LockedTracer", false, 2, "Red tracer to locked target.")

makeToggle(cLock, "Auto Unlock Death", "AutoUnlockDeath", false, 3, "Clears target when dead/knocked.", _G.AutoUnlockDeath)

makeSlider(cLock, "Unlock Dist: ", "AutoUnlockDistance", 50, 2000, 4, "Unlock if target gets too far.")

local cTargetInfo = card(Combat, "Target Info", 6)

TargetInfoLabel = Instance.new("TextLabel")

TargetInfoLabel.Size = UDim2.new(1, 0, 1, 0)

TargetInfoLabel.BackgroundTransparency = 1

TargetInfoLabel.Font = getFont()

TargetInfoLabel.TextSize = 10

TargetInfoLabel.TextColor3 = C.SUB

TargetInfoLabel.TextWrapped = true

TargetInfoLabel.TextXAlignment = Enum.TextXAlignment.Left

TargetInfoLabel.TextYAlignment = Enum.TextYAlignment.Top

TargetInfoLabel.Text = "No target."

TargetInfoLabel.Parent = cTargetInfo

themeObj(TargetInfoLabel, "SubText")

textObj(TargetInfoLabel)

local cExtra = card(Combat, "Extra", 6)

makeToggle(cExtra, "Infinite Jump", "InfiniteJump", true, 1, "Jump in air.")

makeToggle(cExtra, "Anti-Fling", "AntiFling", false, 2, "Disables other player collision.")

makeToggle(cExtra, "Noclip", "Noclip", true, 3, "Disables your collision.")

local cFeedback = card(Combat, "Combat Feedback", 8)

makeToggle(cFeedback, "Hit Marker Effect", "HitMarkerEffect", false, 1, "Shows a hit marker when your locked target loses health.", _G.HitMarkerEffect)

makeToggle(cFeedback, "Hit Marker Sound", "HitMarkerSound", false, 2, "Plays a small sound when your locked target loses health.", _G.HitMarkerSound)

makeToggle(cFeedback, "Damage Indicators", "DamageIndicators", false, 3, "Floating damage numbers for locked target damage.", _G.DamageIndicators)

makeToggle(cFeedback, "Hit Chams", "HitChams", false, 4, "Leaves a red ghost at the hit position for 1.5 seconds.", _G.HitChams)

makeToggle(cFeedback, "Kill Feed", "KillFeed", false, 4, "Local elimination feed.", _G.KillFeed)

makeToggle(cFeedback, "Ammo Counter", "AmmoCounter", false, 5, "Shows local equipped tool ammo if available.", _G.AmmoCounter)

local pMove = card(Player, "Movement", 1)

makeSlider(pMove, "WalkSpeed: ", "WalkSpeed", 1, 250, 1, "Walk speed value used when WalkSpeed Boost is on.")

makeToggle(pMove, "WalkSpeed Boost", "WalkSpeedBoost", true, 2, "Keybind/toggle that applies your WalkSpeed slider.")

makeSlider(pMove, "Jump Height: ", "JumpHeight", 20, 250, 3, "Controls your jump power/height.")

makeToggle(pMove, "Normal WalkSpeed", "NormalWalkSpeed", true, 4, "Turns off WalkSpeed Boost so your game controls speed again.")

makeButton(pMove, "Normal WalkSpeed Now", 5, function()

setToggle("WalkSpeedBoost", false, true)

notify("Game WalkSpeed")

end)

local pFly = card(Player, "Fly", 2)

makeToggle(pFly, "Fly", "Fly", true, 1, "Full fly movement with selectable movement method.", _G.Fly)

makeToggle(pFly, "Fly Walk", "FlyWalk", true, 2, "Flat velocity movement.")

makeSlider(pFly, "Fly Speed: ", "FlySpeed", 20, 500, 3, "Fly and Fly Walk speed.")

makeCycle(pFly, "Fly Method", {"CFrame","Position","Velocity","Camera"}, "FlyMethod", 4)

local pPlayer = card(Player, "Player", 3)

makeToggle(pPlayer, "Return By Death", "ReturnByDeath", false, 1, "Return where you died after respawn.")

makeSlider(pPlayer, "Return Delay: ", "ReturnDeathDelay", 1, 50, 2, "Respawn return delay / 10.")

makeToggle(pPlayer, "Anti-Sit", "AntiSit", false, 3, "Stops sitting.")

makeToggle(pPlayer, "Gravity Modifier", "GravityModifier", false, 6, "Changes local gravity while enabled.")

makeSlider(pPlayer, "Gravity: ", "GravityValue", 20, 196, 7, "Lower = floatier, 196 = default.")

makeToggle(pPlayer, "Teleport Click", "TeleportClick", true, 8, "Click the world to teleport while enabled.")

makeToggle(pPlayer, "Phase Dash", "PhaseDash", true, 9, "Keybind/toggle performs one dash forward.")

makeSlider(pPlayer, "Phase Dist: ", "PhaseDistance", 5, 120, 10, "Forward teleport distance.")

makeToggle(pPlayer, "Swim Anywhere", "SwimAnywhere", true, 11, "Forces swimming movement state.")

makeButton(pPlayer, "Reset Movement", 12, function()

setToggle("WalkSpeedBoost", false, true)

setSlider("JumpHeight", 50)

setSlider("FlySpeed", 50)

setToggle("GravityModifier", false, true)

setToggle("SwimAnywhere", false, true)

resetCharacterPhysics()

workspace.Gravity = OriginalWorkspaceGravity or 196.2

notify("Movement Reset")

end)

local pPos = card(Player, "Position Slots", 4)

for i = 1, 3 do

makeButton(pPos, "Save Slot " .. i, i * 2 - 1, function()

if isAlive(LocalPlayer.Character) then

SavedPositions[i] = LocalPlayer.Character.HumanoidRootPart.CFrame

notify("Saved Slot " .. i)

end

end)

makeButton(pPos, "Return Slot " .. i, i * 2, function()

if isAlive(LocalPlayer.Character) and SavedPositions[i] then

LocalPlayer.Character.HumanoidRootPart.CFrame = SavedPositions[i] + Vector3.new(0, 3, 0)

notify("Returned Slot " .. i)

else

notify("Slot " .. i .. " empty")

end

end)

end

local pAlert = card(Player, "Alerts", 5)

makeToggle(pAlert, "Low HP Alert", "LowHPAlertEnabled", false, 1, "Screen warning at low HP.", _G.LowHPAlertEnabled)

makeSlider(pAlert, "Low HP: ", "LowHPThreshold", 1, 100, 2, "Low HP threshold.")

makeToggle(pAlert, "Damage Flash", "DamageFlash", false, 3, "Screen flashes when damaged.", _G.DamageFlash)

makeToggle(pAlert, "Velocity Meter", "VelocityMeter", false, 4, "Shows velocity in character info.", _G.VelocityMeter)

local pInfo = card(Player, "Character Info", 6)

CharacterInfoLabel = Instance.new("TextLabel")

CharacterInfoLabel.Size = UDim2.new(1, 0, 1, 0)

CharacterInfoLabel.BackgroundTransparency = 1

CharacterInfoLabel.Font = getFont()

CharacterInfoLabel.TextSize = 10

CharacterInfoLabel.TextColor3 = C.SUB

CharacterInfoLabel.TextWrapped = true

CharacterInfoLabel.TextXAlignment = Enum.TextXAlignment.Left

CharacterInfoLabel.TextYAlignment = Enum.TextYAlignment.Top

CharacterInfoLabel.Text = "Waiting for character..."

CharacterInfoLabel.Parent = pInfo

themeObj(CharacterInfoLabel, "SubText")

textObj(CharacterInfoLabel)

local pOrbit = card(Player, "Orbit", 7)

makeToggle(pOrbit, "Orbit", "Orbit", true, 1, "Orbit closest player to mouse.")

makeSlider(pOrbit, "Orbit Radius: ", "OrbitRadius", 3, 50, 2, "Orbit distance.")

makeSlider(pOrbit, "Orbit Speed: ", "OrbitSpeed", 1, 25, 3, "Orbit speed.")

local vMain = card(Visuals, "ESP Main", 1)

makeToggle(vMain, "ESP", "ESP", false, 1, "Player ESP.", _G.ESP_Enabled)

makeToggle(vMain, "ESP Tracers", "ESP_Tracers_Enabled", false, 2, "Tracer lines.", _G.ESP_Tracers_Enabled)

makeToggle(vMain, "ESP Names", "ESP_Names_Enabled", false, 3, "Name labels.", _G.ESP_Names_Enabled)

makeToggle(vMain, "ESP Distance", "ESP_Distance_Enabled", false, 4, "Distance labels.", _G.ESP_Distance_Enabled)

local vExtra = card(Visuals, "ESP Extra", 2)

makeToggle(vExtra, "ESP Box", "ESP_Box_Enabled", false, 1, "2D box.", _G.ESP_Box_Enabled)

makeToggle(vExtra, "ESP Skeleton", "ESP_Skeleton_Enabled", false, 2, "Skeleton lines.", _G.ESP_Skeleton_Enabled)

makeToggle(vExtra, "Health Bar", "ESP_HealthBar", false, 3, "Health bar.", _G.ESP_HealthBar)

makeToggle(vExtra, "Tool Name", "ESP_ToolName", false, 4, "Equipped tool label.", _G.ESP_ToolName)

makeToggle(vExtra, "Chams Overlay", "ChamsOverlay", false, 5, "Solid colorful overlay on player models.", _G.ChamsOverlay)

local vFilters = card(Visuals, "ESP Filters", 3)

makeToggle(vFilters, "Team Check", "ESP_TeamCheck", false, 1, "Hide teammates.", _G.ESP_TeamCheck)

makeToggle(vFilters, "Friend Color", "ESP_FriendColor", false, 2, "Friend color.", _G.ESP_FriendColor)

makeToggle(vFilters, "Enemy Color", "ESP_EnemyColor", false, 3, "Enemy color.", _G.ESP_EnemyColor)

makeToggle(vFilters, "Locked Only", "ESP_LockedOnly", false, 4, "Only locked target.", _G.ESP_LockedOnly)

local vRules = card(Visuals, "ESP Rules", 4)

makeToggle(vRules, "Offscreen Arrows", "ESP_OffscreenArrows", false, 1, "Offscreen arrows.", _G.ESP_OffscreenArrows)

makeToggle(vRules, "Rainbow ESP", "ESP_Rainbow", false, 2, "Animated colors.", _G.ESP_Rainbow)

makeToggle(vRules, "Hide ESP With GUI", "ESP_HideWhenGuiHidden", false, 3, "Hide ESP if GUI hidden.", _G.ESP_HideWhenGuiHidden)

makeSlider(vRules, "Distance: ", "ESP_DistanceLimit", 50, 3000, 4, "Max ESP distance.")

local vBox = card(Visuals, "Box / Tracer", 5)

makeSlider(vBox, "Box Thick: ", "ESP_BoxThickness", 1, 8, 1, "Box thickness.")

makeSlider(vBox, "Tracer Thick: ", "TracerThickness", 1, 8, 2, "Tracer thickness.")

makeSlider(vBox, "Tracer Trans: ", "TracerTransparency", 0, 95, 3, "Tracer transparency.")

makeCycle(vBox, "Tracer Origin", {"Bottom","Center","Mouse"}, "TracerOrigin", 4)

local vColors = card(Visuals, "Colors", 6)

makeCycle(vColors, "ESP Color", {"Red","Gold","Blue","Purple","Green","White"}, "ESP_ColorPreset", 1)

makeCycle(vColors, "Enemy Color", {"Red","Gold","Blue","Purple","Green","White"}, "ESP_EnemyColorPreset", 2)

makeCycle(vColors, "Friend Color", {"Red","Gold","Blue","Purple","Green","White"}, "ESP_FriendColorPreset", 3)

makeCycle(vColors, "Tracer Color", {"Red","Gold","Blue","Purple","Green","White"}, "ESP_TracerColorPreset", 4)

local vCross = card(Visuals, "Crosshair / Mouse", 7)

makeToggle(vCross, "Self Crosshair", "CrosshairEnabled", false, 1, "Crosshair.", _G.CrosshairEnabled)

makeToggle(vCross, "Crosshair Dot", "CrosshairDot", false, 2, "Center dot.", _G.CrosshairDot)

makeToggle(vCross, "World Mouse Dot", "WorldMouseDot", false, 3, "World mouse dot.", _G.WorldMouseDot)

makeToggle(vCross, "Fullbright", "Fullbright", false, 4, "Bright map.")

local vCrossSet = card(Visuals, "Crosshair Settings", 8)

makeSlider(vCrossSet, "CH Size: ", "CrosshairSize", 4, 80, 1, "Crosshair line size.")

makeSlider(vCrossSet, "CH Gap: ", "CrosshairGap", 0, 30, 2, "Crosshair gap.")

makeCycle(vCrossSet, "CH Color", {"Red","Gold","Blue","Purple","Green","White"}, "CrosshairColorPreset", 3)

makeCycle(vCrossSet, "FOV Style", {"Circle","Square","Cross"}, "FOV_Style", 4)

local mConfig = card(Misc, "Config", 1)

makeButton(mConfig, "Save Config", 1, saveConfig)

makeButton(mConfig, "Load Config", 2, loadConfig)

makeButton(mConfig, "Config Reset", 3, resetConfig)

makeButton(mConfig, "Reset All Features", 4, function()

for name, toggle in pairs(Toggles) do toggle.Set(false, true) end

notify("All Features Off")

end)

local mTheme = card(Misc, "Theme / GUI", 2)

makeCycle(mTheme, "Theme", {"Dark Gold","Red","Purple","Blue"}, "ThemeName", 1, function() refreshTheme() end)

makeSlider(mTheme, "GUI Scale: ", "GUI_Scale", 75, 130, 2, "GUI size.")

makeSlider(mTheme, "Opacity: ", "UI_Opacity", 0, 80, 3, "GUI opacity.")

makeToggle(mTheme, "Rounded Corners", "RoundedCorners", false, 4, "Rounded UI.", _G.RoundedCorners)

makeToggle(mTheme, "RGB Rainbow Mode", "RGBRainbowMode", false, 5, "Continuously shifts GUI accent colors.", _G.RGBRainbowMode)

local mUi = card(Misc, "UI Options", 3)

makeToggle(mUi, "Mini Mode", "MiniMode", false, 1, "Collapses GUI.", _G.MiniMode)

makeToggle(mUi, "Watermark", "Watermark", false, 2, "FPS/Ping watermark.", _G.Watermark)

makeToggle(mUi, "Notifications", "Notifications", false, 3, "Popup notifications.", _G.Notifications)

makeToggle(mUi, "UI Sounds", "UISounds", false, 4, "UI click sounds.", _G.UISounds)

local mUi2 = card(Misc, "UI More", 4)

makeToggle(mUi2, "UI Blur", "UIBlur", false, 1, "Blur behind GUI.", _G.UIBlur)

makeToggle(mUi2, "Lock GUI Position", "GuiLockPosition", false, 2, "Prevents dragging.", _G.GuiLockPosition)

makeToggle(mUi2, "Auto Open Last Tab", "AutoOpenLastTab", false, 3, "After loading config, open last tab.", _G.AutoOpenLastTab)

makeCycle(mUi2, "Font", {"Code","Gotham","SourceSans","Arcade"}, "FontName", 4, function() refreshTheme() end)

local mServer = card(Misc, "Server", 5)

makeButton(mServer, "Rejoin Server", 1, function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)

makeButton(mServer, "Server Hop", 2, function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)

makeButton(mServer, "Copy JobId", 3, function()

if setclipboard then

setclipboard(game.JobId)

notify("JobId Copied")

else

notify("Clipboard unsupported")

end

end)

makeCycle(mServer, "Notif Position", {"TopRight","BottomRight","TopLeft","BottomLeft"}, "NotificationPosition", 4, function() setNotifPosition() end)

local mKeys = card(Misc, "Keybinds", 6)

makeButton(mKeys, "Set Panic Hide Key", 1, function()

CurrentWait = "__PANIC_HIDE__"

notify("Press panic hide key")

end)

makeButton(mKeys, "Reset Keybinds", 2, function()

table.clear(Binds)

for _, t in pairs(Toggles) do if t.KeyBtn then t.KeyBtn.Text = "None" end end

updateKeybindList()

notify("Keybinds Reset")

end)

makeButton(mKeys, "Export Keybinds", 3, function()

local text = KeybindLabel and KeybindLabel.Text or ""

if setclipboard then setclipboard(text); notify("Keybinds Copied") else notify("Clipboard unsupported") end

end)

KeybindLabel = Instance.new("TextLabel")

KeybindLabel.Size = UDim2.new(1, 0, 1, -78)

KeybindLabel.BackgroundTransparency = 1

KeybindLabel.Font = getFont()

KeybindLabel.TextSize = 10

KeybindLabel.TextColor3 = C.SUB

KeybindLabel.TextWrapped = true

KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

KeybindLabel.TextYAlignment = Enum.TextYAlignment.Top

KeybindLabel.Parent = mKeys

themeObj(KeybindLabel, "SubText")

textObj(KeybindLabel)

local pDetect = card(Prevent, "Suspicious Aim Detector", 1)

makeToggle(pDetect, "Suspicious Aim", "SuspiciousAimDetector", true, 1, "Local visual suspicious aim review.")

makeSlider(pDetect, "Sensitivity: ", "SuspiciousAimSensitivity", 80, 100, 2, "Aim detector strictness.")

makeSlider(pDetect, "Check Time: ", "SuspiciousAimTime", 1, 20, 3, "Detector timing.")

SuspiciousAimLabel = Instance.new("TextLabel")

SuspiciousAimLabel.Size = UDim2.new(1, 0, 0, 18)

SuspiciousAimLabel.BackgroundTransparency = 1

SuspiciousAimLabel.Font = getFont()

SuspiciousAimLabel.TextSize = 10

SuspiciousAimLabel.TextColor3 = C.SUB

SuspiciousAimLabel.TextXAlignment = Enum.TextXAlignment.Left

SuspiciousAimLabel.Text = "Status: Idle"

SuspiciousAimLabel.LayoutOrder = 4

SuspiciousAimLabel.Parent = pDetect

themeObj(SuspiciousAimLabel, "SubText")

textObj(SuspiciousAimLabel)

local pWatch = card(Prevent, "Watch Tools", 2)

makeButton(pWatch, "Manual Watch Player", 1, function() addWatch(getClosestPlayerToMouse()) end)

makeButton(pWatch, "Mark Closest Player", 2, function() addWatch(getClosestPlayerToCharacter()) end)

makeButton(pWatch, "Mark Player By Mouse", 3, function() addWatch(getClosestPlayerToMouse()) end)

makeButton(pWatch, "Clear Watch List", 4, clearWatch)

local pWatch2 = card(Prevent, "Watch Review", 3)

makeButton(pWatch2, "Spectate Watched Player", 1, spectateWatched)

makeButton(pWatch2, "Stop Spectate", 2, stopSpectate)

makeToggle(pWatch2, "Replay Trail", "ReplayTrail", false, 3, "Draws watched player position trail.", _G.ReplayTrail)

makeCycle(pWatch2, "Watch Color", {"Red","Gold","Blue","Purple","Green","White"}, "WatchColorPreset", 4)

local pWatchInfo = card(Prevent, "Watched Info", 4)

WatchInfoLabel = Instance.new("TextLabel")

WatchInfoLabel.Size = UDim2.new(1, 0, 1, 0)

WatchInfoLabel.BackgroundTransparency = 1

WatchInfoLabel.Font = getFont()

WatchInfoLabel.TextSize = 10

WatchInfoLabel.TextColor3 = C.SUB

WatchInfoLabel.TextWrapped = true

WatchInfoLabel.TextXAlignment = Enum.TextXAlignment.Left

WatchInfoLabel.TextYAlignment = Enum.TextYAlignment.Top

WatchInfoLabel.Text = "Watch List: None"

WatchInfoLabel.Parent = pWatchInfo

themeObj(WatchInfoLabel, "SubText")

textObj(WatchInfoLabel)

local pNotes = card(Prevent, "Suspect Notes", 5)

local notesBox = Instance.new("TextBox")

notesBox.Size = UDim2.new(1, 0, 1, 0)

notesBox.BackgroundColor3 = C.P2

notesBox.BorderSizePixel = 0

notesBox.ClearTextOnFocus = false

notesBox.MultiLine = true

notesBox.TextWrapped = true

notesBox.TextXAlignment = Enum.TextXAlignment.Left

notesBox.TextYAlignment = Enum.TextYAlignment.Top

notesBox.PlaceholderText = "Type notes here..."

notesBox.Text = ""

notesBox.Font = getFont()

notesBox.TextSize = 10

notesBox.TextColor3 = C.TX

notesBox.PlaceholderColor3 = C.SUB

notesBox.Parent = pNotes

themeObj(notesBox, "Button")

textObj(notesBox)

stroke(notesBox, nil, 1)

corner(notesBox, 5)

local pDamage = card(Prevent, "Damage Snapshot", 6)

makeButton(pDamage, "Last Damage Snapshot", 1, function()

LastDamageSnapshot = makeSnapshot("Manual Damage Review")

if DamageSnapshotLabel then DamageSnapshotLabel.Text = LastDamageSnapshot end

addEvidence("Manual damage review captured")

end)

makeButton(pDamage, "Nearby Player Snapshot", 2, function()

local snap = makeSnapshot("Nearby Snapshot")

if DamageSnapshotLabel then DamageSnapshotLabel.Text = snap end

addEvidence("Nearby snapshot captured")

end)

makeButton(pDamage, "Clear Evidence", 3, function()

table.clear(_G.EvidenceLog)

EvidenceText = ""

if EvidenceLabel then EvidenceLabel.Text = "No evidence recorded." end

notify("Evidence Cleared")

end)

DamageSnapshotLabel = Instance.new("TextLabel")

DamageSnapshotLabel.Size = UDim2.new(1, 0, 1, -74)

DamageSnapshotLabel.BackgroundTransparency = 1

DamageSnapshotLabel.Font = getFont()

DamageSnapshotLabel.TextSize = 9

DamageSnapshotLabel.TextColor3 = C.SUB

DamageSnapshotLabel.TextWrapped = true

DamageSnapshotLabel.TextXAlignment = Enum.TextXAlignment.Left

DamageSnapshotLabel.TextYAlignment = Enum.TextYAlignment.Top

DamageSnapshotLabel.Text = LastDamageSnapshot

DamageSnapshotLabel.Parent = pDamage

themeObj(DamageSnapshotLabel, "SubText")

textObj(DamageSnapshotLabel)

local pDeath = card(Prevent, "Death Snapshot", 7)

makeButton(pDeath, "Show Death Snapshot", 1, function()

if DeathSnapshotLabel then DeathSnapshotLabel.Text = DeathSnapshot end

addEvidence("Death snapshot opened")

end)

DeathSnapshotLabel = Instance.new("TextLabel")

DeathSnapshotLabel.Size = UDim2.new(1, 0, 1, -26)

DeathSnapshotLabel.BackgroundTransparency = 1

DeathSnapshotLabel.Font = getFont()

DeathSnapshotLabel.TextSize = 9

DeathSnapshotLabel.TextColor3 = C.SUB

DeathSnapshotLabel.TextWrapped = true

DeathSnapshotLabel.TextXAlignment = Enum.TextXAlignment.Left

DeathSnapshotLabel.TextYAlignment = Enum.TextYAlignment.Top

DeathSnapshotLabel.Text = DeathSnapshot

DeathSnapshotLabel.Parent = pDeath

themeObj(DeathSnapshotLabel, "SubText")

textObj(DeathSnapshotLabel)

local pEvidence = card(Prevent, "Evidence Logger", 8)

EvidenceLabel = Instance.new("TextLabel")

EvidenceLabel.Size = UDim2.new(1, 0, 1, 0)

EvidenceLabel.BackgroundTransparency = 1

EvidenceLabel.Font = getFont()

EvidenceLabel.TextSize = 9

EvidenceLabel.TextColor3 = C.SUB

EvidenceLabel.TextWrapped = true

EvidenceLabel.TextXAlignment = Enum.TextXAlignment.Left

EvidenceLabel.TextYAlignment = Enum.TextYAlignment.Top

EvidenceLabel.Text = "No evidence recorded."

EvidenceLabel.Parent = pEvidence

themeObj(EvidenceLabel, "SubText")

textObj(EvidenceLabel)

local cmdNote, cmdNoteFrame = card(Commands, "Command Note", 1)

cmdNoteFrame.Size = UDim2.new(1, -8, 0, 58)

local noteLabel = Instance.new("TextLabel")

noteLabel.Size = UDim2.new(1, 0, 1, 0)

noteLabel.BackgroundTransparency = 1

noteLabel.Font = getFont()

noteLabel.TextSize = 14

noteLabel.TextColor3 = C.SUB

noteLabel.TextWrapped = true

noteLabel.TextXAlignment = Enum.TextXAlignment.Left

noteLabel.TextYAlignment = Enum.TextYAlignment.Top

noteLabel.Text = "to use commands say . before any command you want in chat."

noteLabel.Parent = cmdNote

themeObj(noteLabel, "SubText")

textObj(noteLabel)

local cmdSearchCard, cmdSearchFrame = card(Commands, "Command Search", 2)

cmdSearchFrame.Size = UDim2.new(1, -8, 0, 68)

local commandSearch = Instance.new("TextBox")

commandSearch.Size = UDim2.new(1, 0, 0, 30)

commandSearch.Position = UDim2.new(0, 0, 0, 2)

commandSearch.BackgroundColor3 = C.P2

commandSearch.BorderSizePixel = 0

commandSearch.ClearTextOnFocus = false

commandSearch.PlaceholderText = "Search commands..."

commandSearch.Text = ""

commandSearch.Font = getFont()

commandSearch.TextSize = 13

commandSearch.TextColor3 = C.TX

commandSearch.PlaceholderColor3 = C.SUB

commandSearch.Parent = cmdSearchCard

themeObj(commandSearch, "Button")

textObj(commandSearch)

stroke(commandSearch, nil, 1)

corner(commandSearch, 5)

local commandListCard, commandListFrame = card(Commands, "Command List", 3)

commandListFrame.Size = UDim2.new(1, -8, 0, 485)

local commandRows = {}

local addCommandRow

addCommandRow = function(commandText, description, searchWords)

local row = Instance.new("Frame")

row.Size = UDim2.new(1, 0, 0, 48)

row.BackgroundColor3 = C.P2

row.BorderSizePixel = 0

row.Parent = commandListCard

themeObj(row, "Button")

stroke(row, nil, 1)

corner(row, 5)

local label = Instance.new("TextLabel")

label.Size = UDim2.new(1, -12, 1, -8)

label.Position = UDim2.new(0, 6, 0, 4)

label.BackgroundTransparency = 1

label.Font = getFont()

label.TextSize = 12

label.TextColor3 = C.TX

label.TextWrapped = true

label.TextXAlignment = Enum.TextXAlignment.Left

label.TextYAlignment = Enum.TextYAlignment.Top

label.Text = commandText .. "\n" .. description

label.Parent = row

themeObj(label, "Text")

textObj(label)

table.insert(commandRows, {

Row = row,

Search = string.lower(commandText .. " " .. description .. " " .. (searchWords or ""))

})

end

addCommandRow(".near [player]", "Teleports near a player without going inside them.", "near player teleport")

addCommandRow(".above [player]", "Teleports above/near a player so you can watch safely.", "above player teleport")

addCommandRow(".back", "Returns to where you were before .tpto/.near/.above/map teleports.", "back return previous position")

addCommandRow(".fixchar", "Stops velocity, sitting, noclip, fly, spin/dash leftovers, and resets movement.", "fix character reset movement")

addCommandRow(".tpto [player]", "Teleports you to a player. Partial username/display names work.", "teleport goto player")

addCommandRow(".freecam / .unfreecam", "Free camera mode. WASD/QE move, right-click to look.", "camera fly view")

addCommandRow(".view [player/all] / .unview", "Spectates one player or cycles all players.", "spectate watch player all")

addCommandRow(".showhitbox [player/all] / .unshowhitbox [player/all]", "Shows local red hitboxes for one player or all players.", "boxes hitbox visualize")

addCommandRow(".xray / .unxray", "Makes map parts transparent locally so you can inspect the map.", "transparent walls map")

addCommandRow(".cmds", "Opens this Commands tab.", "commands help")

addCommandRow(".logs", "Opens the Command Logs window.", "logs command history")

addCommandRow(".goto mouse / .return", "Teleports you to the mouse position and returns to the previous spot.", "teleport mouse return")

addCommandRow(".phasedash", "Instant forward dash using Phase Dist.", "phase dash")

addCommandRow(".teleclick / .unteleclick", "Turns click-to-teleport on or off.", "teleport click")

addCommandRow(".gravity number / .ungravity", "Enables local gravity modifier or restores default gravity.", "gravity modifier")

addCommandRow(".swim / .unswim", "Forces swimming state or disables it.", "swim anywhere")

commandSearch:GetPropertyChangedSignal("Text"):Connect(function()

local q = commandSearch.Text:lower()

for _, item in ipairs(commandRows) do

local visible = q == "" or string.find(item.Search, q, 1, true) ~= nil

item.Row.Visible = visible

item.Row.Size = visible and UDim2.new(1, 0, 0, 48) or UDim2.new(1, 0, 0, 0)

end

end)

updateKeybindList()

end

function killScript()

_G.BETA_KILLED = true

_G.BETA_GUI_RUNNING = false

_G.BETA_GUI_VERSION = nil

for _, toggle in pairs(Toggles) do

pcall(function() toggle.Set(false, true) end)

end

for _, name in ipairs({"ESP_SCR","CL_SCR","FW_SCR","FLY_CONN","OrbitConnection","SAD_CONN","LH_CONN","LT_CONN","IJ_SCR","TB_SCR","AF_SCR","NC_SCR","AFK_SCR","BETA_FOLLOW_CONN","BETA_TALK_CONN","BETA_PRISON_TOOLTRACK_CONN"}) do

local conn = _G[name]

if conn then

pcall(function() conn:Disconnect() end)

_G[name] = nil

end

end

if _G.SAD_FOLDER then _G.SAD_FOLDER:Destroy(); _G.SAD_FOLDER = nil end

if _G.LH_FOLDER then _G.LH_FOLDER:Destroy(); _G.LH_FOLDER = nil end

if _G.RBD_CONNS then for _, c in ipairs(_G.RBD_CONNS) do disconnect(c) end; table.clear(_G.RBD_CONNS) end

if _G.AS_CONNS then for _, c in ipairs(_G.AS_CONNS) do disconnect(c) end; table.clear(_G.AS_CONNS) end

for _, guiName in ipairs({"B_LOCKED_TRC","B_ESP","B_TRC","B_ESP_BOX","B_ESP_SKEL","B_ESP_ARROWS"}) do

if PlayerGui:FindFirstChild(guiName) then PlayerGui[guiName]:Destroy() end

end

if stopPrisonToolTrack then stopPrisonToolTrack() end

removeMouseDot()

if _G.BETA_TRAIL_FOLDER then _G.BETA_TRAIL_FOLDER:Destroy(); _G.BETA_TRAIL_FOLDER = nil end

if PlayerGui:FindFirstChild("BETA_PRISON_LIFE_LOADER") then PlayerGui.BETA_PRISON_LIFE_LOADER:Destroy() end

_G.BETA_LAST_TRAIL = nil

disconnectAll(Connections)

disconnectAll(SliderConnections)

resetCharacterPhysics()

resetLighting()

if Root then Root:Destroy() end

end

_G.BETA_KILL_CURRENT = killScript

buildUI()

makePagesAndControls()

refreshTheme()

setTab("Combat")

task.defer(function()

if setTab then setTab("Combat") end

end)

setNotifPosition()

applySettingsToUI(false)

prepareStartupGuiHidden()

task.delay(3.25, function()

if not _G.BETA_KILLED and Main and not Main.Visible then

showStartupGuiSmoothly()

end

end)

setupCommandListener()

addConn(RunService.RenderStepped:Connect(function(dt)

if _G.BETA_KILLED then return end

if Root and Root:FindFirstChild("Tooltip") and Root.Tooltip.Visible then

local m = UserInputService:GetMouseLocation()

Root.Tooltip.Position = UDim2.new(0, m.X + 15, 0, m.Y + 15)

end

if _G.MiniMode and Main and MiniBar then

Main.Visible = false

MiniBar.Visible = true

end

if BlurEffect then BlurEffect.Enabled = _G.UIBlur and Main and Main.Visible end

local mousePos = UserInputService:GetMouseLocation()

if FOVFrame and FOVCross then

local showFOV = _G.FOV_Visible == true

FOVFrame.Visible = showFOV and _G.FOV_Style ~= "Cross"

FOVCross.Visible = showFOV and _G.FOV_Style == "Cross"

if _G.FOV_Style == "Circle" then

FOVCorner.CornerRadius = UDim.new(1, 0)

else

FOVCorner.CornerRadius = UDim.new(0, 0)

end

local fovRadius = math.clamp(tonumber(_G.FOV_Radius) or 100, 5, 1000)

FOVFrame.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)

FOVFrame.Position = UDim2.new(0, mousePos.X - fovRadius, 0, mousePos.Y - fovRadius)

FOVCross.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)

FOVCross.Position = UDim2.new(0, mousePos.X - fovRadius, 0, mousePos.Y - fovRadius)

end

if Crosshair then

Crosshair.Visible = _G.CrosshairEnabled

local color = getColor(_G.CrosshairColorPreset)

local size = math.clamp(_G.CrosshairSize or 16, 4, 80)

local gap = math.clamp(_G.CrosshairGap or 5, 0, 30)

local thick = 2

CrossParts.Left.BackgroundColor3 = color

CrossParts.Right.BackgroundColor3 = color

CrossParts.Up.BackgroundColor3 = color

CrossParts.Down.BackgroundColor3 = color

CrossParts.Dot.BackgroundColor3 = color

CrossParts.Left.Size = UDim2.new(0, size, 0, thick)

CrossParts.Left.Position = UDim2.new(0.5, -gap - size, 0.5, -1)

CrossParts.Right.Size = UDim2.new(0, size, 0, thick)

CrossParts.Right.Position = UDim2.new(0.5, gap, 0.5, -1)

CrossParts.Up.Size = UDim2.new(0, thick, 0, size)

CrossParts.Up.Position = UDim2.new(0.5, -1, 0.5, -gap - size)

CrossParts.Down.Size = UDim2.new(0, thick, 0, size)

CrossParts.Down.Position = UDim2.new(0.5, -1, 0.5, gap)

CrossParts.Dot.Visible = _G.CrosshairDot

CrossParts.Dot.Position = UDim2.new(0.5, -2, 0.5, -2)

end

if _G.WorldMouseDot and not WorldMouseDotPart then createMouseDot() end

if not _G.WorldMouseDot and WorldMouseDotPart then removeMouseDot() end

if WorldMouseDotPart then

local cam = workspace.CurrentCamera

local m = UserInputService:GetMouseLocation()

local ray = cam:ViewportPointToRay(m.X, m.Y)

local params = RaycastParams.new()

params.FilterType = Enum.RaycastFilterType.Blacklist

local ignore = {WorldMouseDotPart}

if LocalPlayer.Character then table.insert(ignore, LocalPlayer.Character) end

params.FilterDescendantsInstances = ignore

local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)

if result then

WorldMouseDotPart.CFrame = CFrame.new(result.Position + result.Normal * 0.05)

WorldMouseDotPart.Color = C.W

WorldMouseDotPart.Transparency = 0.15

else

WorldMouseDotPart.Transparency = 1

end

end

if isAlive(LocalPlayer.Character) then

local hum = LocalPlayer.Character.Humanoid

local hrp = LocalPlayer.Character.HumanoidRootPart

if _G.WalkSpeedBoost then

hum.WalkSpeed = _G.WalkSpeed

end

if _G.JumpHeight ~= DEFAULTS.JumpHeight then

pcall(function()

hum.UseJumpPower = true

hum.JumpPower = _G.JumpHeight or 50

hum.JumpHeight = math.clamp((_G.JumpHeight or 50) / 7, 2, 30)

end)

end

if _G.GravityModifier then

workspace.Gravity = _G.GravityValue or 90

elseif math.abs(workspace.Gravity - (OriginalWorkspaceGravity or 196.2)) > 0.05 then

workspace.Gravity = OriginalWorkspaceGravity or 196.2

end

if _G.SwimAnywhere then

pcall(function()

hum:ChangeState(Enum.HumanoidStateType.Swimming)

end)

end

if LastHealth == nil then LastHealth = hum.Health end

if hum.Health < LastHealth then

flashDamage()

LastDamageSnapshot = makeSnapshot("Damage Taken: -" .. tostring(math.floor(LastHealth - hum.Health)))

if DamageSnapshotLabel then DamageSnapshotLabel.Text = LastDamageSnapshot end

addEvidence("Damage taken: -" .. tostring(math.floor(LastHealth - hum.Health)))

end

LastHealth = hum.Health

if LowHPOverlay then

LowHPOverlay.Visible = _G.LowHPAlertEnabled and hum.Health <= _G.LowHPThreshold

LowHPOverlay.Text = "LOW HP: " .. math.floor(hum.Health)

end

if CharacterInfoLabel then

local pos = hrp.Position

local vel = math.floor(hrp.AssemblyLinearVelocity.Magnitude)

local infoLines = {

"Health: " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth),

"State: " .. tostring(hum:GetState()):gsub("Enum.HumanoidStateType.", ""),

"Position: " .. math.floor(pos.X) .. ", " .. math.floor(pos.Y) .. ", " .. math.floor(pos.Z)

}

if _G.VelocityMeter then

table.insert(infoLines, 2, "Velocity: " .. vel)

end

CharacterInfoLabel.Text = table.concat(infoLines, "\n")

end

else

LastHealth = nil

if LowHPOverlay then LowHPOverlay.Visible = false end

if CharacterInfoLabel then CharacterInfoLabel.Text = "Waiting for character..." end

end

if TargetInfoLabel then

if _G.CL_T and _G.CL_T.Parent then

local hum = _G.CL_T:FindFirstChild("Humanoid")

local root = _G.CL_T:FindFirstChild("HumanoidRootPart")

local playerName = "Unknown"

for _, plr in ipairs(Players:GetPlayers()) do

if plr.Character == _G.CL_T then playerName = plr.Name break end

end

local distText = "N/A"

if root and isAlive(LocalPlayer.Character) then

distText = tostring(math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude))

end

local overlayText =

"TARGET: " .. playerName ..

" | HP: " .. (hum and math.floor(hum.Health) or 0) ..

" | DIST: " .. distText .. " studs" ..

" | TOOL: " .. equippedToolName(_G.CL_T) ..

" | KNOCKED: " .. (isKnocked(_G.CL_T) and "YES" or "NO")

TargetInfoLabel.Text =

"Target: " .. playerName ..

"\nHealth: " .. (hum and math.floor(hum.Health) or 0) ..

"\nDistance: " .. distText ..

"\nTool: " .. equippedToolName(_G.CL_T) ..

"\nKnocked: " .. (isKnocked(_G.CL_T) and "Yes" or "No")

if TargetInfoOverlay then

TargetInfoOverlay.Text = overlayText

TargetInfoOverlay.Visible = true

end

else

TargetInfoLabel.Text = "No target."

if TargetInfoOverlay then

TargetInfoOverlay.Visible = false

end

end

end

if WatermarkLabel then

WatermarkLabel.Visible = _G.Watermark

if _G.Watermark then

local fps = math.floor(1 / math.max(dt, 0.0001))

WatermarkLabel.Text = "BETA GUI | FPS: " .. fps .. " | Ping: " .. getPing() .. " | Players: " .. #Players:GetPlayers() .. " | JobId: " .. string.sub(game.JobId, 1, 8)

end

end

if _G.RGBRainbowMode and os.clock() - LastRainbowTick > 0.06 then

LastRainbowTick = os.clock()

applyRainbowAccent(rainbow())

end

if KillFeedFrame then

KillFeedFrame.Visible = _G.KillFeed

end

if AmmoCounterLabel then

AmmoCounterLabel.Visible = _G.AmmoCounter

if _G.AmmoCounter then

AmmoCounterLabel.Text = getAmmoText()

end

end

for _, plr in ipairs(Players:GetPlayers()) do

if plr ~= LocalPlayer and plr.Character then

local hum = plr.Character:FindFirstChildOfClass("Humanoid")

local oldHealth = PlayerHealthCache[plr]

if hum then

if oldHealth ~= nil and oldHealth > 0 and hum.Health <= 0 then

addKillFeedLine(plr.Name .. " eliminated")

end

PlayerHealthCache[plr] = hum.Health

end

local cham = plr.Character:FindFirstChild("BETA_CHAMS_LOCAL")

if _G.ChamsOverlay and isAlive(plr.Character) then

if not cham then

cham = Instance.new("Highlight")

cham.Name = "BETA_CHAMS_LOCAL"

cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

cham.FillTransparency = 0.25

cham.OutlineTransparency = 0.1

cham.Parent = plr.Character

end

local col = getESPColorForPlayer(plr)

cham.FillColor = col

cham.OutlineColor = col

cham.Enabled = true

elseif cham then

cham:Destroy()

end

end

end

if WatchInfoLabel then

local lines = {"Watch List: " .. watchListNames()}

for _, plr in ipairs(Players:GetPlayers()) do

if isWatched(plr) and plr.Character then

table.insert(lines, plr.Name .. " | Tool: " .. equippedToolName(plr.Character) .. " | Alive: " .. tostring(isAlive(plr.Character)))

end

end

WatchInfoLabel.Text = table.concat(lines, "\n")

end

if _G.ReplayTrail then

if not _G.BETA_TRAIL_FOLDER then

local folder = Instance.new("Folder")

folder.Name = "BETA_ReplayTrail"

folder.Parent = workspace

_G.BETA_TRAIL_FOLDER = folder

end

for _, plr in ipairs(Players:GetPlayers()) do

if isWatched(plr) and isAlive(plr.Character) then

local root = plr.Character:FindFirstChild("HumanoidRootPart")

if root and (not _G.BETA_LAST_TRAIL or not _G.BETA_LAST_TRAIL[plr.UserId] or (root.Position - _G.BETA_LAST_TRAIL[plr.UserId]).Magnitude > 3) then

_G.BETA_LAST_TRAIL = _G.BETA_LAST_TRAIL or {}

_G.BETA_LAST_TRAIL[plr.UserId] = root.Position

local dot = Instance.new("Part")

dot.Name = "Trail_" .. plr.Name

dot.Shape = Enum.PartType.Ball

dot.Size = Vector3.new(0.25, 0.25, 0.25)

dot.Anchored = true

dot.CanCollide = false

pcall(function() dot.CanQuery = false end)

dot.Material = Enum.Material.Neon

dot.Color = getColor(_G.WatchColorPreset)

dot.CFrame = CFrame.new(root.Position)

dot.Parent = _G.BETA_TRAIL_FOLDER

game:GetService("Debris"):AddItem(dot, 5)

end

end

end

elseif _G.BETA_TRAIL_FOLDER then

_G.BETA_TRAIL_FOLDER:Destroy()

_G.BETA_TRAIL_FOLDER = nil

_G.BETA_LAST_TRAIL = nil

end

end))

addConn(LocalPlayer.CharacterAdded:Connect(function(char)

LastHealth = nil

task.wait(0.6)

local hum = char:FindFirstChild("Humanoid")

if hum then

hum.Died:Connect(function()

DeathSnapshot = makeSnapshot("Death Snapshot")

if DeathSnapshotLabel then DeathSnapshotLabel.Text = DeathSnapshot end

addEvidence("Death snapshot captured")

end)

end

end))

if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then

LocalPlayer.Character.Humanoid.Died:Connect(function()

DeathSnapshot = makeSnapshot("Death Snapshot")

addEvidence("Death snapshot captured")

end)

end

addConn(UserInputService.InputBegan:Connect(function(input, gpe)

if _G.BETA_KILLED or gpe then return end

if input.UserInputType == Enum.UserInputType.MouseButton1 and _G.TeleportClick then

if not UserInputService:GetFocusedTextBox() then

teleportToMouse()

end

return

end

if input.KeyCode == Enum.KeyCode.RightShift then

if Main and not _G.MiniMode then Main.Visible = not Main.Visible end

end

if input.KeyCode == PanicKey then

if Main then Main.Visible = false end

if MiniBar then MiniBar.Visible = false end

notify("Panic Hide")

end

if CurrentWait and input.UserInputType == Enum.UserInputType.Keyboard then

if CurrentWait == "__PANIC_HIDE__" then

PanicKey = input.KeyCode

CurrentWait = nil

notify("Panic Key: " .. PanicKey.Name)

updateKeybindList()

return

end

Binds[CurrentWait] = input.KeyCode

if Toggles[CurrentWait] and Toggles[CurrentWait].KeyBtn then

Toggles[CurrentWait].KeyBtn.Text = input.KeyCode.Name

end

CurrentWait = nil

updateKeybindList()

elseif not CurrentWait then

for name, code in pairs(Binds) do

if input.KeyCode == code and Toggles[name] then

Toggles[name].Toggle()

end

end

end

end))

warn("[BETA GUI] Loaded main script")

announceUniversalGui()

task.defer(function()

local StarterGui = game:GetService("StarterGui")

for _ = 1, 20 do

local ok = pcall(function()

StarterGui:SetCore("SendNotification", {

Title = "Sakura HUB",

Text = "Right Shift to Hide UI",

Duration = 5

})

end)

if ok then

break

end

task.wait(0.25)

end

end)
