--[[
============================================================
👑 SLAP AURA HUB | V59 | Ultimate Final (Complete)
============================================================
Features:
- Loading Screen
- Ghost Protocol V9 (Crash-Fixed)
- ESP PRO (Glove Detection + Danger Levels)
- Auto Avoid
- Any-Part Aura
- Candy Farm V5 (Manual Control)
- Floating Button
- Server Hopper (Integrated into GUI)
- All Antis
============================================================
]]

if _G.SlapAuraAlreadyRunning then
    warn("[Slap Aura] Script already running!")
    return
end
_G.SlapAuraAlreadyRunning = true
_G.CandyFarmReady = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ============================================================
-- 🎬 LOADING SCREEN
-- ============================================================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "SlapAuraLoading"
LoadingGui.ResetOnSpawn = false
LoadingGui.DisplayOrder = 999999
LoadingGui.IgnoreGuiInset = true
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() LoadingGui.Parent = game:GetService("CoreGui") end)
if not LoadingGui.Parent then LoadingGui.Parent = PlayerGui end

local Backdrop = Instance.new("Frame")
Backdrop.Size = UDim2.fromScale(1, 1)
Backdrop.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Backdrop.BorderSizePixel = 0
Backdrop.Parent = LoadingGui

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 15)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 10, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
})
Gradient.Rotation = 45
Gradient.Parent = Backdrop

local Container = Instance.new("Frame")
Container.Size = UDim2.fromOffset(420, 260)
Container.Position = UDim2.new(0.5, 0, 0.6, 0)
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.Parent = LoadingGui

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 14)
ContainerCorner.Parent = Container

local ContainerStroke = Instance.new("UIStroke")
ContainerStroke.Color = Color3.fromRGB(255, 140, 0)
ContainerStroke.Thickness = 1.5
ContainerStroke.Transparency = 1
ContainerStroke.Parent = Container

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 50)
Logo.Position = UDim2.fromOffset(0, 25)
Logo.BackgroundTransparency = 1
Logo.Text = "👑 SLAP AURA HUB"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 28
Logo.Parent = Container

local LogoGradient = Instance.new("UIGradient")
LogoGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 180, 80)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 140, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 120))
})
LogoGradient.Parent = Logo

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(1, 0, 0, 20)
Version.Position = UDim2.fromOffset(0, 75)
Version.BackgroundTransparency = 1
Version.Text = "V59 • Ultimate Final"
Version.TextColor3 = Color3.fromRGB(160, 160, 175)
Version.Font = Enum.Font.Gotham
Version.TextSize = 13
Version.Parent = Container

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(1, -80, 0, 8)
BarBg.Position = UDim2.new(0.5, 0, 0, 135)
BarBg.AnchorPoint = Vector2.new(0.5, 0)
BarBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
BarBg.BorderSizePixel = 0
BarBg.Parent = Container

local BarBgCorner = Instance.new("UICorner")
BarBgCorner.CornerRadius = UDim.new(1, 0)
BarBgCorner.Parent = BarBg

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.fromScale(0, 1)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBg

local BarFillCorner = Instance.new("UICorner")
BarFillCorner.CornerRadius = UDim.new(1, 0)
BarFillCorner.Parent = BarFill

local Percent = Instance.new("TextLabel")
Percent.Size = UDim2.new(1, 0, 0, 20)
Percent.Position = UDim2.new(0, 0, 0, 155)
Percent.BackgroundTransparency = 1
Percent.Text = "0%"
Percent.TextColor3 = Color3.fromRGB(255, 140, 0)
Percent.Font = Enum.Font.GothamBold
Percent.TextSize = 14
Percent.Parent = Container

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -40, 0, 40)
Status.Position = UDim2.new(0, 20, 1, -55)
Status.BackgroundTransparency = 1
Status.Text = "Initializing..."
Status.TextColor3 = Color3.fromRGB(180, 180, 195)
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.TextWrapped = true
Status.Parent = Container

TweenService:Create(Container, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundTransparency = 0.1
}):Play()
TweenService:Create(ContainerStroke, TweenInfo.new(0.6), {Transparency = 0.3}):Play()

local loadSteps = {
    {p = 15, text = "Loading Core Modules..."},
    {p = 35, text = "Applying Ghost Protocol..."},
    {p = 55, text = "Building HUD..."},
    {p = 75, text = "Loading WindUI..."},
    {p = 90, text = "Preparing Features..."},
    {p = 100, text = "Ready! Punch once with glove"}
}

for _, step in ipairs(loadSteps) do
    Status.Text = step.text
    TweenService:Create(BarFill, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
        Size = UDim2.fromScale(step.p / 100, 1)
    }):Play()
    Percent.Text = step.p .. "%"
    task.wait(0.3)
end
task.wait(0.4)
TweenService:Create(Container, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
    Position = UDim2.new(0.5, 0, 0.4, 0),
    BackgroundTransparency = 1
}):Play()
TweenService:Create(ContainerStroke, TweenInfo.new(0.45), {Transparency = 1}):Play()
TweenService:Create(Backdrop, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
    BackgroundTransparency = 1
}):Play()
task.wait(0.7)
LoadingGui:Destroy()

-- ============================================================
-- 🛑 GHOST PROTOCOL V9 (Crash-Fixed)
-- ============================================================
local CapturedRemote = nil
local RemoteFormat = "None"

local hasHooks = pcall(function()
    return hookmetamethod and getrawmetatable and setreadonly and newcclosure
end)

if hasHooks then
    pcall(function()
        local mt = getrawmetatable(game)
        local oldIndex = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(t, k)
            if checkcaller and checkcaller() then return oldIndex(t, k) end
            if typeof(t) == "Instance" and t.ClassName == "Humanoid" and t.Parent == LocalPlayer.Character then
                if k == "WalkSpeed" then return 16 end
                if k == "JumpPower" then return 50 end
            end
            if typeof(t) == "Instance" and t.Parent == LocalPlayer.Character and (k == "AssemblyLinearVelocity" or k == "Velocity") then
                local ok, realVel = pcall(function() return oldIndex(t, k) end)
                if ok and typeof(realVel) == "Vector3" and realVel.Magnitude > 35 then
                    return realVel.Unit * 15
                end
            end
            return oldIndex(t, k)
        end)
        setreadonly(mt, true)
    end)

    local oldNamecall
    pcall(function()
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if checkcaller and checkcaller() then return oldNamecall(self, ...) end
            local method = getnamecallmethod()
            if method == "Kick" and self == LocalPlayer then return end
            if method == "FireServer" then
                local ok, remoteName = pcall(function() return string.lower(self.Name) end)
                if ok and remoteName then
                    local badRemotes = {"ban", "kick", "anticheat", "detect", "report", "speedcheck", "flag"}
                    for _, bad in ipairs(badRemotes) do
                        if string.find(remoteName, bad) then return end
                    end
                end
                local args = {...}
                if #args > 0 then
                    pcall(function()
                        if type(args[1]) == "table" and args[1]["victim"] then
                            if CapturedRemote ~= self then CapturedRemote = self; RemoteFormat = "Table" end
                        elseif typeof(args[1]) == "Instance" and (args[1].Name == "Head" or args[1].Name == "HumanoidRootPart" or args[1]:IsA("BasePart")) then
                            if CapturedRemote ~= self then CapturedRemote = self; RemoteFormat = "Instance" end
                        end
                    end)
                end
            end
            return oldNamecall(self, ...)
        end))
    end)
end

-- ============================================================
-- ⚙️ SETTINGS
-- ============================================================
local Settings = {
    AuraEnabled = true, Range = 15, AuraMaxHits = 5, HitPart = "Any",
    FlySpeed = 50, Noclip = false, Godmode = false,
    PremiumSpeed = 35, ESP = false, AutoAim = false,
    HitboxExpander = false, GravityControl = false,
    CandyFarm = false, ServerHopper = false,
    AntiVoid = false, AntiFling = false, AntiRagdoll = false,
    AntiKnockback = false, AntiHoney = false, AntiIce = false,
    AntiMail = false, AntiMR = false, AntiMitten = false, AntiSquid = false,
    AntiAFK = false, AutoRejoin = false, SafePos = Vector3.new(0, 100, 0)
}
local Connections = {}
local HitCount = 0

local function GetTargetPart(char)
    if not char then return nil end
    if Settings.HitPart == "Head" then return char:FindFirstChild("Head")
    elseif Settings.HitPart == "HumanoidRootPart" then return char:FindFirstChild("HumanoidRootPart")
    else
        return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
            or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            or char:FindFirstChildOfClass("BasePart")
    end
end

-- ============================================================
-- 🔔 HUD & NOTIFICATIONS
-- ============================================================
local HUD = Instance.new("ScreenGui")
HUD.Name = "SlapAuraHUD"; HUD.ResetOnSpawn = false; HUD.DisplayOrder = 9998; HUD.Parent = PlayerGui
local HUDFrame = Instance.new("Frame"); HUDFrame.Size = UDim2.new(0, 220, 0, 40); HUDFrame.Position = UDim2.new(0, 20, 0.1, 0); HUDFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); HUDFrame.BackgroundTransparency = 0.2; HUDFrame.BorderSizePixel = 0; HUDFrame.Parent = HUD
local HUDCorner = Instance.new("UICorner"); HUDCorner.CornerRadius = UDim.new(0, 6); HUDCorner.Parent = HUDFrame
local HUDStroke = Instance.new("UIStroke"); HUDStroke.Color = Color3.fromRGB(255, 140, 0); HUDStroke.Thickness = 1.5; HUDStroke.Parent = HUDFrame
local HUDText = Instance.new("TextLabel"); HUDText.Size = UDim2.new(1, -10, 1, 0); HUDText.Position = UDim2.new(0, 5, 0, 0); HUDText.BackgroundTransparency = 1; HUDText.Text = "🎃 Slap Aura: WAITING"; HUDText.TextColor3 = Color3.fromRGB(255, 255, 255); HUDText.Font = Enum.Font.GothamBold; HUDText.TextSize = 14; HUDText.Parent = HUDFrame

local function showNotification(title, text, isSuccess)
    local notifGui = Instance.new("ScreenGui"); notifGui.Name = "SlapNotifs"; notifGui.ResetOnSpawn = false; notifGui.DisplayOrder = 99999
    pcall(function() notifGui.Parent = game:GetService("CoreGui") end)
    if not notifGui.Parent then notifGui.Parent = PlayerGui end
    local frame = Instance.new("Frame"); frame.Size = UDim2.fromOffset(280, 60); frame.Position = UDim2.new(1, 20, 0, 20); frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); frame.BorderSizePixel = 0; frame.Parent = notifGui
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 8); corner.Parent = frame
    local stroke = Instance.new("UIStroke"); stroke.Color = isSuccess and Color3.fromRGB(50, 220, 130) or Color3.fromRGB(255, 80, 80); stroke.Thickness = 1.5; stroke.Parent = frame
    local icon = Instance.new("TextLabel"); icon.Size = UDim2.fromOffset(30, 30); icon.Position = UDim2.fromOffset(10, 15); icon.BackgroundTransparency = 1; icon.Text = isSuccess and "✅" or "⚠️"; icon.TextSize = 20; icon.Parent = frame
    local titleLbl = Instance.new("TextLabel"); titleLbl.Size = UDim2.new(1, -50, 0, 20); titleLbl.Position = UDim2.fromOffset(45, 10); titleLbl.BackgroundTransparency = 1; titleLbl.Text = title; titleLbl.TextColor3 = Color3.fromRGB(255,255,255); titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 14; titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.Parent = frame
    local descLbl = Instance.new("TextLabel"); descLbl.Size = UDim2.new(1, -50, 0, 25); descLbl.Position = UDim2.fromOffset(45, 30); descLbl.BackgroundTransparency = 1; descLbl.Text = text; descLbl.TextColor3 = Color3.fromRGB(160, 160, 170); descLbl.Font = Enum.Font.Gotham; descLbl.TextSize = 12; descLbl.TextWrapped = true; descLbl.TextXAlignment = Enum.TextXAlignment.Left; descLbl.Parent = frame
    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -300, 0, 20)}):Play()
    task.delay(3, function()
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0, 20)}):Play()
        task.wait(0.3); notifGui:Destroy()
    end)
end

-- ============================================================
-- 💎 ENGINES
-- ============================================================
function ToggleSpeed(state)
    if Connections.Speed then Connections.Speed:Disconnect() end
    if state then
        Connections.Speed = RunService.Heartbeat:Connect(function()
            local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = Settings.PremiumSpeed end
        end)
        showNotification("Speed", "Premium Speed On", true)
    else
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16 end
        showNotification("Speed", "Off", false)
    end
end

local isFlying = false
function ToggleFly(state)
    isFlying = state
    if Connections.Fly then Connections.Fly:Disconnect() end
    if state then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if root and hum then
            hum:ChangeState(Enum.HumanoidStateType.Physics)
            local bv = Instance.new("BodyVelocity", root); bv.Name = "FlyBV"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge); bv.Velocity = Vector3.new(0,0,0)
            local bg = Instance.new("BodyGyro", root); bg.Name = "FlyBG"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bg.P = 5000; bg.D = 50
            Connections.Fly = RunService.RenderStepped:Connect(function()
                if not isFlying or not root or not hum then return end
                local vel = hum.MoveDirection * Settings.FlySpeed
                if Camera.CFrame.LookVector.Y > 0.4 then vel = vel + Vector3.new(0, Settings.FlySpeed, 0) elseif Camera.CFrame.LookVector.Y < -0.4 then vel = vel - Vector3.new(0, Settings.FlySpeed, 0) end
                bv.Velocity = vel; bg.CFrame = Camera.CFrame
            end)
            showNotification("Fly", "On", true)
        end
    else
        local char = LocalPlayer.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
            if root then local bv = root:FindFirstChild("FlyBV"); local bg = root:FindFirstChild("FlyBG"); if bv then bv:Destroy() end; if bg then bg:Destroy() end end
        end
        showNotification("Fly", "Off", false)
    end
end

function ToggleGravity(state)
    if Connections.Gravity then Connections.Gravity:Disconnect() end
    if state then
        Connections.Gravity = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0.01, 0.01, 0, 0) end
        end)
        showNotification("Gravity", "On", true)
    else
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CustomPhysicalProperties = nil end
        showNotification("Gravity", "Off", false)
    end
end

function ToggleAutoAim(state)
    if Connections.Aim then Connections.Aim:Disconnect() end
    if state then
        Connections.Aim = RunService.RenderStepped:Connect(function()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local closest, dist = nil, 200
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local r = p.Character:FindFirstChild("HumanoidRootPart")
                        if r and (root.Position - r.Position).Magnitude < dist then dist = (root.Position - r.Position).Magnitude; closest = r end
                    end
                end
                if closest then Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position) end
            end
        end)
        showNotification("Auto Aim", "On", true)
    end
end

function ToggleHitbox(state)
    if Connections.Hitbox then Connections.Hitbox:Disconnect() end
    if state then
        Connections.Hitbox = RunService.Heartbeat:Connect(function()
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then tool.Handle.Size = Vector3.new(5, 5, 5); tool.Handle.Transparency = 0.5 end
        end)
        showNotification("Hitbox", "On", true)
    end
end

function ToggleNoclip(state)
    Settings.Noclip = state
    if Connections.Noclip then Connections.Noclip:Disconnect() end
    if state then
        Connections.Noclip = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                end
            end
        end)
        showNotification("Noclip", "On", true)
    else
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
        showNotification("Noclip", "Off", false)
    end
end

function ToggleGodmode(state)
    Settings.Godmode = state
    if Connections.Godmode then Connections.Godmode:Disconnect() end
    if state then
        Connections.Godmode = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.MaxHealth = math.huge; hum.Health = math.huge end
            end
        end)
        showNotification("Godmode", "On", true)
    else
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.MaxHealth = 100; hum.Health = 100 end
        end
        showNotification("Godmode", "Off", false)
    end
end

-- ============================================================
-- 🚀 SERVER HOPPER (Integrated)
-- ============================================================
local function FetchServers()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local response = nil
    local method = "None"
    
    if syn and syn.request then
        local ok, res = pcall(function() return syn.request({Url = url, Method = "GET"}) end)
        if ok and res and res.Body and res.Body ~= "" then response = res.Body; method = "syn.request" end
    end
    if not response and request then
        local ok, res = pcall(function() return request({Url = url, Method = "GET"}) end)
        if ok and res and res.Body and res.Body ~= "" then response = res.Body; method = "request" end
    end
    if not response and http_request then
        local ok, res = pcall(function() return http_request({Url = url, Method = "GET"}) end)
        if ok and res and res.Body and res.Body ~= "" then response = res.Body; method = "http_request" end
    end
    if not response then
        local ok, res = pcall(function() return game:HttpGet(url) end)
        if ok and res and res ~= "" then response = res; method = "HttpGet" end
    end
    
    return response, method
end

local function HopToNewServer()
    showNotification("Hopper", "Searching...", true)
    task.spawn(function()
        local response, method = FetchServers()
        if not response then
            showNotification("Hopper", "❌ Fetch failed", false)
            return
        end
        print("[Hopper] Method:", method)
        
        local ok, data = pcall(function() return HttpService:JSONDecode(response) end)
        if not ok or not data or not data.data then
            showNotification("Hopper", "❌ Invalid data", false)
            return
        end
        
        local validServers = {}
        for _, server in ipairs(data.data) do
            if server.playing < (server.maxPlayers * 0.95) and server.id ~= game.JobId then
                table.insert(validServers, server)
            end
        end
        
        if #validServers == 0 then
            showNotification("Hopper", "❌ No servers", false)
            return
        end
        
        local chosen = validServers[math.random(1, #validServers)]
        showNotification("Hopper", "✅ Joining " .. chosen.playing .. "/" .. chosen.maxPlayers, true)
        print("[Hopper] Joining:", chosen.id)
        task.wait(1)
        
        local tpOk = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, chosen.id, LocalPlayer)
        end)
        
        if not tpOk then
            showNotification("Hopper", "⚠️ Trying basic...", false)
            task.wait(1)
            pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
        end
    end)
end

local function QuickTeleport()
    showNotification("Hopper", "Quick teleport...", true)
    task.wait(0.5)
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end

local function RejoinSame()
    showNotification("Hopper", "Rejoining...", true)
    task.wait(0.5)
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
end

-- ============================================================
-- 🍬 CANDY FARM V5
-- ============================================================
local CandyFarm = {
    Running = false, Collected = 0, Thread = nil, Monitor = nil,
    CharConn = nil, DeathConn = nil, LastCount = 0, FolderFound = false,
    FolderName = "", ActiveRunID = 0, LastToggleTime = 0, UI_Toggle = nil,
}

local function FindCandyFolder()
    local folder = workspace:FindFirstChild("CandyCorns")
    if folder then CandyFarm.FolderFound = true; CandyFarm.FolderName = "CandyCorns"; return folder end
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Folder") then
            local n = string.lower(obj.Name)
            if string.find(n, "candy") or string.find(n, "corn") or string.find(n, "sweet") then
                CandyFarm.FolderFound = true; CandyFarm.FolderName = obj.Name; return obj
            end
        end
    end
    CandyFarm.FolderFound = false; return nil
end

local function GetCandyList()
    local candies = {}
    local folder = FindCandyFolder()
    if folder then
        for _, item in ipairs(folder:GetChildren()) do
            if item:IsA("BasePart") then table.insert(candies, item) end
        end
    else
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                local n = string.lower(obj.Name)
                if string.find(n, "candy") or string.find(n, "corn") or string.find(n, "sweet") then
                    if not (LocalPlayer.Character and obj:IsDescendantOf(LocalPlayer.Character)) then
                        table.insert(candies, obj)
                    end
                end
            end
        end
    end
    return candies
end

local ToggleCandyFarm

function ToggleCandyFarm(state)
    if not _G.CandyFarmReady then return end
    state = state and true or false
    if tick() - CandyFarm.LastToggleTime < 1 then return end
    CandyFarm.LastToggleTime = tick()
    if CandyFarm.Running == state then return end

    CandyFarm.Running = state
    Settings.CandyFarm = state
    CandyFarm.ActiveRunID = CandyFarm.ActiveRunID + 1
    local currentRunID = CandyFarm.ActiveRunID

    if CandyFarm.Monitor then pcall(function() CandyFarm.Monitor:Disconnect() end); CandyFarm.Monitor = nil end
    if CandyFarm.CharConn then pcall(function() CandyFarm.CharConn:Disconnect() end); CandyFarm.CharConn = nil end
    if CandyFarm.DeathConn then pcall(function() CandyFarm.DeathConn:Disconnect() end); CandyFarm.DeathConn = nil end

    if _G.UpdateFloatButton then _G.UpdateFloatButton(state) end
    if CandyFarm.UI_Toggle and CandyFarm.UI_Toggle.Set then pcall(function() CandyFarm.UI_Toggle:Set(state) end) end

    if not state then showNotification("Farm", "Stopped", false); return end

    CandyFarm.Collected = 0
    showNotification("Farm", "Started", true)

    local function attachCharWatcher(char)
        if not char then return end
        if CandyFarm.DeathConn then pcall(function() CandyFarm.DeathConn:Disconnect() end) end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            CandyFarm.DeathConn = hum.Died:Connect(function()
                if CandyFarm.Running then showNotification("Farm", "⚠️ Died! Continues after respawn", false) end
            end)
        end
    end

    attachCharWatcher(LocalPlayer.Character)
    CandyFarm.CharConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
        if CandyFarm.Running then attachCharWatcher(newChar); showNotification("Farm", "Respawned!", true) end
    end)

    CandyFarm.Monitor = workspace.DescendantAdded:Connect(function(obj)
        if CandyFarm.ActiveRunID ~= currentRunID or not CandyFarm.Running then return end
        pcall(function()
            if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                local n = string.lower(obj.Name)
                if string.find(n, "candy") or string.find(n, "corn") or string.find(n, "sweet") then
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp and obj:IsDescendantOf(workspace) then
                        obj.CFrame = hrp.CFrame
                        CandyFarm.Collected = CandyFarm.Collected + 1
                    end
                end
            end
        end)
    end)

    CandyFarm.Thread = task.spawn(function()
        while true do
            if not CandyFarm.Running or CandyFarm.ActiveRunID ~= currentRunID then break end
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local candies = GetCandyList()
                CandyFarm.LastCount = #candies
                for _, candy in ipairs(candies) do
                    if not CandyFarm.Running or CandyFarm.ActiveRunID ~= currentRunID then break end
                    if candy and candy.Parent then
                        candy.CFrame = hrp.CFrame
                        CandyFarm.Collected = CandyFarm.Collected + 1
                        task.wait(0.02)
                    end
                end
            end)
            task.wait(0.3)
        end
    end)
end

-- ============================================================
-- 🍬 FLOATING BUTTON
-- ============================================================
local FloatGui = Instance.new("ScreenGui")
FloatGui.Name = "CandyFarmFloat"; FloatGui.ResetOnSpawn = false; FloatGui.DisplayOrder = 99999; FloatGui.Parent = PlayerGui

local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.fromOffset(60, 60); FloatBtn.Position = UDim2.new(0, 20, 0.5, -30)
FloatBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0); FloatBtn.Text = "🍬"
FloatBtn.TextSize = 28; FloatBtn.Font = Enum.Font.GothamBold; FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatBtn.BorderSizePixel = 0; FloatBtn.AutoButtonColor = false; FloatBtn.Active = false; FloatBtn.Parent = FloatGui

local FloatCorner = Instance.new("UICorner"); FloatCorner.CornerRadius = UDim.new(1, 0); FloatCorner.Parent = FloatBtn
local FloatStroke = Instance.new("UIStroke"); FloatStroke.Color = Color3.fromRGB(255, 200, 60); FloatStroke.Thickness = 2; FloatStroke.Parent = FloatBtn
local FloatLabel = Instance.new("TextLabel"); FloatLabel.Size = UDim2.new(1, 0, 0, 15); FloatLabel.Position = UDim2.new(0, 0, 1, 2)
FloatLabel.BackgroundTransparency = 1; FloatLabel.Text = "FARM"; FloatLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatLabel.Font = Enum.Font.GothamBold; FloatLabel.TextSize = 10; FloatLabel.Parent = FloatBtn

_G.UpdateFloatButton = function(state)
    if state then
        TweenService:Create(FloatBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 220, 130)}):Play()
        TweenService:Create(FloatStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(100, 255, 180)}):Play()
        FloatLabel.Text = "ON"
    else
        TweenService:Create(FloatBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 140, 0)}):Play()
        TweenService:Create(FloatStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 200, 60)}):Play()
        FloatLabel.Text = "FARM"
    end
end

local dragStartPos, btnStartPos, isDragging, touchConsumed = nil, nil, false, false

FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStartPos = input.Position; btnStartPos = FloatBtn.Position
        isDragging = false; touchConsumed = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragStartPos and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartPos
        if delta.Magnitude > 8 then
            isDragging = true
            FloatBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if dragStartPos and not isDragging and not touchConsumed then
            touchConsumed = true
            if _G.CandyFarmReady then ToggleCandyFarm(not CandyFarm.Running) end
        end
        dragStartPos = nil; isDragging = false
    end
end)

-- ============================================================
-- 👁️ ESP PRO
-- ============================================================
local GloveDanger = {
    ["killstreak"] = "EXTREME", ["god's hand"] = "EXTREME", ["gods hand"] = "EXTREME",
    ["error"] = "EXTREME", ["reaper"] = "EXTREME", ["thanos"] = "EXTREME",
    ["overkill"] = "EXTREME", ["megarock"] = "EXTREME", ["berserk"] = "EXTREME",
    ["hallow jack"] = "EXTREME", ["detonator"] = "EXTREME", ["bob"] = "EXTREME",
    ["mitten"] = "HIGH", ["leash"] = "HIGH", ["fish"] = "HIGH", ["grab"] = "HIGH",
    ["pull"] = "HIGH", ["lure"] = "HIGH", ["phase"] = "HIGH", ["wormhole"] = "HIGH",
    ["blackhole"] = "HIGH", ["rattlebones"] = "HIGH", ["home run"] = "HIGH",
    ["jet"] = "HIGH", ["baller"] = "HIGH", ["za hando"] = "HIGH", ["recycler"] = "HIGH",
    ["bomb"] = "HIGH", ["sparky"] = "HIGH", ["conductor"] = "HIGH", ["tinkerer"] = "HIGH",
    ["rhythm"] = "HIGH", ["track"] = "HIGH",
    ["ice"] = "MEDIUM", ["snowball"] = "MEDIUM", ["mr"] = "MEDIUM", ["mail"] = "MEDIUM",
    ["squid"] = "MEDIUM", ["honey"] = "MEDIUM", ["cloud"] = "MEDIUM", ["kinetic"] = "MEDIUM",
    ["slapple"] = "MEDIUM", ["moon"] = "MEDIUM",
}

local DangerColors = {
    EXTREME = {Fill = Color3.fromRGB(255, 30, 30), Text = "🔴 EXTREME"},
    HIGH = {Fill = Color3.fromRGB(255, 140, 0), Text = "🟠 HIGH"},
    MEDIUM = {Fill = Color3.fromRGB(255, 220, 50), Text = "🟡 MEDIUM"},
    SAFE = {Fill = Color3.fromRGB(80, 220, 130), Text = "🟢 SAFE"},
    NONE = {Fill = Color3.fromRGB(150, 150, 150), Text = "⚪ NONE"},
}

local function GetPlayerGlove(plr)
    if not plr.Character then return nil, "NONE" end
    local tool = plr.Character:FindFirstChildOfClass("Tool")
    if not tool then return nil, "NONE" end
    return tool.Name, (GloveDanger[string.lower(tool.Name)] or "SAFE")
end

local AutoAvoidSettings = { Enabled = false, Distance = 30, SafeDistance = 60, OnlyExtreme = true, LastAvoidTime = 0 }

local function AutoAvoidCheck(myRoot)
    if not AutoAvoidSettings.Enabled or not myRoot then return end
    if tick() - AutoAvoidSettings.LastAvoidTime < 2 then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            if tRoot then
                local gloveName, danger = GetPlayerGlove(plr)
                local shouldAvoid = (danger == "EXTREME") or (danger == "HIGH" and not AutoAvoidSettings.OnlyExtreme)
                if shouldAvoid then
                    local dist = (myRoot.Position - tRoot.Position).Magnitude
                    if dist < AutoAvoidSettings.Distance then
                        local direction = (myRoot.Position - tRoot.Position).Unit
                        local newPos = myRoot.Position + direction * AutoAvoidSettings.SafeDistance
                        pcall(function()
                            myRoot.CFrame = CFrame.new(newPos + Vector3.new(0, 10, 0))
                            AutoAvoidSettings.LastAvoidTime = tick()
                            showNotification("Auto Avoid", "⚠️ Escaped ("..(gloveName or "?")..")", true)
                        end)
                        return
                    end
                end
            end
        end
    end
end

local activeESP = {}
local espConnections = {}

local function removeESPFromPlayer(plr)
    if activeESP[plr.Name] then
        pcall(function()
            if activeESP[plr.Name].Highlight then activeESP[plr.Name].Highlight:Destroy() end
            if activeESP[plr.Name].Billboard then activeESP[plr.Name].Billboard:Destroy() end
        end)
        activeESP[plr.Name] = nil
    end
end

local function applyESPToPlayer(plr)
    if plr == LocalPlayer or not Settings.ESP then return end
    if not plr.Character then return end
    local head = plr.Character:FindFirstChild("Head")
    if not head then return end
    removeESPFromPlayer(plr)
    local hl = Instance.new("Highlight", plr.Character)
    hl.FillColor = Color3.fromRGB(255, 140, 0); hl.FillTransparency = 0.5; hl.OutlineColor = Color3.fromRGB(255, 140, 0)
    local bb = Instance.new("BillboardGui", head); bb.Size = UDim2.new(0, 220, 0, 70); bb.StudsOffset = Vector3.new(0, 2.5, 0); bb.AlwaysOnTop = true
    local txt = Instance.new("TextLabel", bb); txt.Size = UDim2.new(1, 0, 1, 0); txt.BackgroundTransparency = 1; txt.TextColor3 = Color3.fromRGB(255, 255, 255); txt.TextStrokeTransparency = 0; txt.Font = Enum.Font.GothamBold; txt.TextSize = 13; txt.RichText = true
    activeESP[plr.Name] = {Highlight = hl, Billboard = bb, Text = txt}
end

function ToggleESP(state)
    Settings.ESP = state
    for _, conn in pairs(espConnections) do pcall(function() conn:Disconnect() end) end
    espConnections = {}
    if Connections.ESP then Connections.ESP:Disconnect() end
    if state then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                applyESPToPlayer(plr)
                local charConn = plr.CharacterAdded:Connect(function() task.wait(0.5); if Settings.ESP then applyESPToPlayer(plr) end end)
                table.insert(espConnections, charConn)
            end
        end
        local addedConn = Players.PlayerAdded:Connect(function(plr)
            if plr == LocalPlayer then return end
            plr.CharacterAdded:Connect(function() task.wait(0.5); if Settings.ESP then applyESPToPlayer(plr) end end)
            if plr.Character then applyESPToPlayer(plr) end
        end)
        table.insert(espConnections, addedConn)
        local removedConn = Players.PlayerRemoving:Connect(function(plr) removeESPFromPlayer(plr) end)
        table.insert(espConnections, removedConn)
        Connections.ESP = RunService.Heartbeat:Connect(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local data = activeESP[plr.Name]
                    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if data and myRoot and data.Text then
                        local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                        if tRoot then
                            local dist = math.floor((myRoot.Position - tRoot.Position).Magnitude)
                            local gloveName, danger = GetPlayerGlove(plr)
                            local colorInfo = DangerColors[danger] or DangerColors.SAFE
                            local gloveDisplay = gloveName and ("["..gloveName.."]") or "[None]"
                            data.Text.Text = string.format('%s\n%s\n%d studs', plr.DisplayName, colorInfo.Text.." "..gloveDisplay, dist)
                            data.Highlight.FillColor = colorInfo.Fill
                            data.Highlight.OutlineColor = colorInfo.Fill
                            data.Highlight.FillTransparency = (danger == "EXTREME") and 0.3 or 0.5
                        end
                    end
                end
            end
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then AutoAvoidCheck(myRoot) end
        end)
        showNotification("ESP", "On", true)
    else
        for _, data in pairs(activeESP) do
            pcall(function()
                if data.Highlight then data.Highlight:Destroy() end
                if data.Billboard then data.Billboard:Destroy() end
            end)
        end
        activeESP = {}
        showNotification("ESP", "Off", false)
    end
end

-- ============================================================
-- 🥊 AURA
-- ============================================================
local lastHit, hits, sec = 0, 0, math.floor(tick())
if Connections.Aura then Connections.Aura:Disconnect() end
Connections.Aura = RunService.Stepped:Connect(function()
    if not Settings.AuraEnabled or not CapturedRemote then return end
    local char = LocalPlayer.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local cSec = math.floor(tick()); if cSec ~= sec then sec = cSec; hits = 0 end
    if hits >= Settings.AuraMaxHits then return end
    if tick() - lastHit < (1 / Settings.AuraMaxHits) then return end
    local closest, dist = nil, Settings.Range
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 and (root.Position - r.Position).Magnitude <= dist then
                dist = (root.Position - r.Position).Magnitude; closest = p
            end
        end
    end
    if closest and closest.Character then
        local targetPart = GetTargetPart(closest.Character)
        if targetPart then
            pcall(function()
                if RemoteFormat == "Table" then CapturedRemote:FireServer({["victim"] = targetPart, ["attacker"] = LocalPlayer})
                else CapturedRemote:FireServer(targetPart) end
                hits = hits + 1; lastHit = tick(); HitCount = HitCount + 1
                HUDText.Text = "🎃 Slap Aura: ACTIVE ("..HitCount..")"
            end)
        end
    end
end)

-- ============================================================
-- 🛡️ ANTI ENGINE
-- ============================================================
function ToggleAntiVoid(state)
    Settings.AntiVoid = state
    if Connections.AntiVoid then Connections.AntiVoid:Disconnect() end
    if state then
        Connections.AntiVoid = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character; if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Position.Y < -50 then pcall(function() hrp.CFrame = CFrame.new(Settings.SafePos) end) end
        end)
        showNotification("Anti Void", "On", true)
    else showNotification("Anti Void", "Off", false) end
end

function ToggleAntiFling(state)
    Settings.AntiFling = state
    if Connections.AntiFling then Connections.AntiFling:Disconnect() end
    if state then
        Connections.AntiFling = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character; if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.AssemblyLinearVelocity.Magnitude > 200 then hrp.AssemblyLinearVelocity = Vector3.zero end
        end)
        showNotification("Anti Fling", "On", true)
    else showNotification("Anti Fling", "Off", false) end
end

function ToggleAntiRagdoll(state)
    Settings.AntiRagdoll = state
    if Connections.AntiRagdoll then Connections.AntiRagdoll:Disconnect() end
    if state then
        Connections.AntiRagdoll = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character; if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and (hum.PlatformStand or hum:GetState() == Enum.HumanoidStateType.Physics) then
                hum.PlatformStand = false; hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
        showNotification("Anti Ragdoll", "On", true)
    else showNotification("Anti Ragdoll", "Off", false) end
end

function ToggleAntiKnockback(state)
    Settings.AntiKnockback = state
    if Connections.AntiKB then Connections.AntiKB:Disconnect() end
    if state then
        Connections.AntiKB = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character; if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vel = hrp.AssemblyLinearVelocity
                if Vector3.new(vel.X, 0, vel.Z).Magnitude > 100 then hrp.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0) end
            end
        end)
        showNotification("Anti Knockback", "On", true)
    else showNotification("Anti Knockback", "Off", false) end
end

function ToggleAntiHoney(state)
    Settings.AntiHoney = state
    if Connections.AntiHoney then Connections.AntiHoney:Disconnect() end
    if state then
        Connections.AntiHoney = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character; if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed < 16 and hum.WalkSpeed > 0 then hum.WalkSpeed = 16 end
            for _, v in ipairs(char:GetDescendants()) do
                local n = string.lower(v.Name)
                if (v:IsA("ObjectValue") or v:IsA("BoolValue") or v:IsA("Highlight")) and (string.find(n, "honey") or string.find(n, "slow")) then
                    pcall(function() v:Destroy() end)
                end
            end
        end)
        showNotification("Anti Honey", "On", true)
    else showNotification("Anti Honey", "Off", false) end
end

function ToggleAntiIce(state)
    Settings.AntiIce = state
    if Connections.AntiIce then Connections.AntiIce:Disconnect() end
    if state then
        Connections.AntiIce = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character; if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed < 16 and hum.WalkSpeed > 0 then hum.WalkSpeed = 16 end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Anchored then hrp.Anchored = false end
            for _, v in ipairs(char:GetDescendants()) do
                local n = string.lower(v.Name)
                if (v:IsA("Highlight") or v:IsA("ParticleEmitter") or v:IsA("ObjectValue")) and (string.find(n, "ice") or string.find(n, "freeze") or string.find(n, "frozen")) then
                    pcall(function() v:Destroy() end)
                end
            end
        end)
        showNotification("Anti Ice", "On", true)
    else showNotification("Anti Ice", "Off", false) end
end

function ToggleAntiMail(state)
    Settings.AntiMail = state
    if Connections.AntiMail then Connections.AntiMail:Disconnect() end
    if state then
        Connections.AntiMail = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character; if not char then return end
            for _, v in ipairs(char:GetDescendants()) do
                local n = string.lower(v.Name)
                if (v:IsA("Highlight") or v:IsA("BillboardGui") or v:IsA("ParticleEmitter") or v:IsA("Sound")) and (string.find(n, "mail") or string.find(n, "letter")) then
                    pcall(function() v:Destroy() end)
                end
            end
        end)
        showNotification("Anti Mail", "On", true)
    else showNotification("Anti Mail", "Off", false) end
end

function ToggleAntiMR(state)
    Settings.AntiMR = state
    if Connections.AntiMR then Connections.AntiMR:Disconnect() end
    if state then
        Connections.AntiMR = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character; if not char then return end
            for _, v in ipairs(char:GetDescendants()) do
                local n = string.lower(v.Name)
                if (v:IsA("Highlight") or v:IsA("ParticleEmitter") or v:IsA("ObjectValue")) and (string.find(n, "mirror") or string.find(n, "mr")) then
                    pcall(function() v:Destroy() end)
                end
            end
        end)
        showNotification("Anti MR", "On", true)
    else showNotification("Anti MR", "Off", false) end
end

function ToggleAntiMitten(state)
    Settings.AntiMitten = state
    if Connections.AntiMitten then Connections.AntiMitten:Disconnect() end
    if state then
        Connections.AntiMitten = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character; if not char then return end
            for _, v in ipairs(char:GetDescendants()) do
                local n = string.lower(v.Name)
                if (v:IsA("Highlight") or v:IsA("BillboardGui") or v:IsA("ParticleEmitter")) and (string.find(n, "mitten") or string.find(n, "glove")) then
                    pcall(function() v:Destroy() end)
                end
            end
        end)
        showNotification("Anti Mitten", "On", true)
    else showNotification("Anti Mitten", "Off", false) end
end

function ToggleAntiSquid(state)
    Settings.AntiSquid = state
    if Connections.AntiSquid then Connections.AntiSquid:Disconnect() end
    if state then
        Connections.AntiSquid = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character; if not char then return end
            for _, v in ipairs(char:GetDescendants()) do
                local n = string.lower(v.Name)
                if (v:IsA("Highlight") or v:IsA("ParticleEmitter") or v:IsA("BillboardGui") or v:IsA("ObjectValue")) and (string.find(n, "squid") or string.find(n, "ink")) then
                    pcall(function() v:Destroy() end)
                end
            end
        end)
        showNotification("Anti Squid", "On", true)
    else showNotification("Anti Squid", "Off", false) end
end

function ToggleAntiAFK(state)
    Settings.AntiAFK = state
    if Connections.AntiAFK then Connections.AntiAFK:Disconnect() end
    if state then
        Connections.AntiAFK = task.spawn(function()
            while Settings.AntiAFK do
                pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
                task.wait(60)
            end
        end)
        showNotification("Anti AFK", "On", true)
    else showNotification("Anti AFK", "Off", false) end
end

function ToggleAutoRejoin(state)
    Settings.AutoRejoin = state
    if state then
        pcall(function()
            LocalPlayer.OnTeleport:Connect(function(s)
                if s == Enum.TeleportState.Started and Settings.AutoRejoin then
                    task.wait(3); TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end
            end)
        end)
        showNotification("Auto Rejoin", "On", true)
    else showNotification("Auto Rejoin", "Off", false) end
end

-- ============================================================
-- 🎨 GUI
-- ============================================================
function LoadMainGUI()
    local success, err = pcall(function()
        local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
        local Window = WindUI:CreateWindow({ Title = "Slap Aura | V59 Ultimate", Icon = "shield", Author = "Majed", Folder = "SlapAuraV59", Size = UDim2.fromOffset(600, 540), Transparent = true, Theme = "Dark" })

        -- Combat
        local CombatTab = Window:Tab({ Title = "Combat", Icon = "crosshair" })
        CombatTab:Button({ Title = "🔄 Refresh Glove", Callback = function() CapturedRemote = nil; RemoteFormat = "None"; showNotification("System", "Reset", true) end })
        CombatTab:Toggle({ Title = "Auto Slap", Value = true, Callback = function(s)
            Settings.AuraEnabled = s
            if s and not CapturedRemote then showNotification("Aura", "⚠️ Punch once with glove", false) end
        end })
        CombatTab:Slider({ Title = "Aura Range", Value = { Min = 5, Max = 50, Default = 15 }, Callback = function(v) Settings.Range = v end })
        CombatTab:Slider({ Title = "Aura Max Hits/sec", Value = { Min = 1, Max = 20, Default = 5 }, Callback = function(v) Settings.AuraMaxHits = v end })
        CombatTab:Dropdown({ Title = "🎯 Hit Target Part", Values = {"Any", "Head", "HumanoidRootPart"}, Default = "Any", Callback = function(o) Settings.HitPart = o; showNotification("Aura", "Target: "..o, true) end })
        CombatTab:Toggle({ Title = "Auto Aim", Value = false, Callback = function(s) ToggleAutoAim(s) end })
        CombatTab:Toggle({ Title = "Hitbox", Value = false, Callback = function(s) ToggleHitbox(s) end })
        CombatTab:Toggle({ Title = "Godmode", Value = false, Callback = function(s) ToggleGodmode(s) end })

        -- Movement
        local MoveTab = Window:Tab({ Title = "Movement", Icon = "wind" })
        MoveTab:Toggle({ Title = "Premium Speed", Value = false, Callback = function(s) ToggleSpeed(s) end })
        MoveTab:Slider({ Title = "Speed Value", Value = { Min = 16, Max = 100, Default = 35 }, Callback = function(v) Settings.PremiumSpeed = v end })
        MoveTab:Toggle({ Title = "Fly", Value = false, Callback = function(s) ToggleFly(s) end })
        MoveTab:Slider({ Title = "Fly Speed", Value = { Min = 20, Max = 200, Default = 50 }, Callback = function(v) Settings.FlySpeed = v end })
        MoveTab:Toggle({ Title = "Zero Gravity", Value = false, Callback = function(s) ToggleGravity(s) end })
        MoveTab:Toggle({ Title = "Noclip", Value = false, Callback = function(s) ToggleNoclip(s) end })

        -- Farm
        local FarmTab = Window:Tab({ Title = "Farm", Icon = "leaf" })
        local farmToggle = FarmTab:Toggle({ Title = "🍬 Candy Farm V5", Value = false, Callback = function(s)
            if not _G.CandyFarmReady then return end
            if CandyFarm.Running ~= s then ToggleCandyFarm(s) end
        end })
        CandyFarm.UI_Toggle = farmToggle
        FarmTab:Toggle({ Title = "Auto Server Hop (When Empty)", Value = false, Callback = function(s) Settings.ServerHopper = s end })
        FarmTab:Paragraph({ Title = "Candy Stats", Desc = "Collected: 0 | Folder: None" })

        -- 🚀 Server Hopper Section (NEW)
        FarmTab:Section({ Title = "🚀 Server Hopper" })
        FarmTab:Button({ Title = "🔍 Find & Join New Server", Callback = function() HopToNewServer() end })
        FarmTab:Button({ Title = "⚡ Quick Teleport (Random)", Callback = function() QuickTeleport() end })
        FarmTab:Button({ Title = "🔄 Rejoin Same Server", Callback = function() RejoinSame() end })

        -- Visuals
        local VisTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
        VisTab:Toggle({ Title = "👁️ Player ESP (Glove Detection)", Value = false, Callback = function(s) ToggleESP(s) end })
        VisTab:Section({ Title = "🛡️ Auto Avoid" })
        VisTab:Toggle({ Title = "Enable Auto Avoid", Value = false, Callback = function(s)
            AutoAvoidSettings.Enabled = s
            showNotification("Auto Avoid", s and "ON" or "OFF", s)
        end })
        VisTab:Toggle({ Title = "Only EXTREME Gloves", Value = true, Callback = function(s) AutoAvoidSettings.OnlyExtreme = s end })
        VisTab:Slider({ Title = "Avoid Distance (studs)", Value = { Min = 10, Max = 100, Default = 30 }, Callback = function(v) AutoAvoidSettings.Distance = v end })
        VisTab:Slider({ Title = "Teleport Away Distance", Value = { Min = 30, Max = 200, Default = 60 }, Callback = function(v) AutoAvoidSettings.SafeDistance = v end })

        -- Anti
        local AntiTab = Window:Tab({ Title = "Anti", Icon = "shield" })
        AntiTab:Section({ Title = "Game Mechanics" })
        AntiTab:Toggle({ Title = "Anti Void", Value = false, Callback = function(s) ToggleAntiVoid(s) end })
        AntiTab:Toggle({ Title = "Anti Fling", Value = false, Callback = function(s) ToggleAntiFling(s) end })
        AntiTab:Toggle({ Title = "Anti Ragdoll", Value = false, Callback = function(s) ToggleAntiRagdoll(s) end })
        AntiTab:Toggle({ Title = "Anti Knockback", Value = false, Callback = function(s) ToggleAntiKnockback(s) end })
        AntiTab:Section({ Title = "Glove Effects" })
        AntiTab:Toggle({ Title = "🍯 Anti Honey", Value = false, Callback = function(s) ToggleAntiHoney(s) end })
        AntiTab:Toggle({ Title = "🧊 Anti Ice", Value = false, Callback = function(s) ToggleAntiIce(s) end })
        AntiTab:Toggle({ Title = "📬 Anti Mail", Value = false, Callback = function(s) ToggleAntiMail(s) end })
        AntiTab:Toggle({ Title = "🎭 Anti MR", Value = false, Callback = function(s) ToggleAntiMR(s) end })
        AntiTab:Toggle({ Title = "🧤 Anti Mitten", Value = false, Callback = function(s) ToggleAntiMitten(s) end })
        AntiTab:Toggle({ Title = "🦑 Anti Squid", Value = false, Callback = function(s) ToggleAntiSquid(s) end })
        AntiTab:Section({ Title = "System" })
        AntiTab:Toggle({ Title = "Anti AFK", Value = false, Callback = function(s) ToggleAntiAFK(s) end })
        AntiTab:Toggle({ Title = "Auto Rejoin", Value = false, Callback = function(s) ToggleAutoRejoin(s) end })

        -- Settings
        local SetTab = Window:Tab({ Title = "Settings", Icon = "settings" })
        SetTab:Button({ Title = "🔔 Test Notification", Callback = function() showNotification("Test", "Working!", true) end })
        SetTab:Button({ Title = "📍 Set Safe Pos", Callback = function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                Settings.SafePos = char.HumanoidRootPart.Position
                showNotification("Safe Pos", "Updated!", true)
            end
        end })
        SetTab:Button({ Title = "⏱️ Teleport Status", Callback = function()
            print("========== SERVER INFO ==========")
            print("PlaceId:", game.PlaceId)
            print("JobId:", game.JobId)
            print("Players:", #Players:GetPlayers())
            print("syn.request:", type(syn and syn.request))
            print("request:", type(request))
            print("http_request:", type(http_request))
            print("=================================")
            showNotification("Info", "Check F9 Console", true)
        end })
        SetTab:Button({ Title = "🔍 Scan for Candy", Callback = function()
            local candies = GetCandyList()
            if #candies == 0 then showNotification("Scan", "No Candy", false)
            else
                local names = {}
                for i = 1, math.min(#candies, 5) do table.insert(names, candies[i].Name) end
                showNotification("Scan", "Found "..#candies..": "..table.concat(names, ", "), true)
            end
        end })
        SetTab:Button({ Title = "📁 List Workspace Folders", Callback = function()
            local folders = {}
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("Folder") then table.insert(folders, obj.Name) end
            end
            if #folders == 0 then showNotification("Folders", "None", false)
            else showNotification("Folders", table.concat(folders, ", "), true); print("Folders:", folders) end
        end })
        SetTab:Button({ Title = "📊 Candy Farm Status", Callback = function()
            local msg = "Running: "..tostring(CandyFarm.Running).." | Collected: "..CandyFarm.Collected.." | Folder: "..(CandyFarm.FolderFound and CandyFarm.FolderName or "None").." | Found: "..CandyFarm.LastCount
            showNotification("Status", msg, CandyFarm.Collected > 0)
        end })
        SetTab:Button({ Title = "❌ Unload", Callback = function()
            CandyFarm.Running = false
            CandyFarm.ActiveRunID = CandyFarm.ActiveRunID + 1
            if CandyFarm.Monitor then pcall(function() CandyFarm.Monitor:Disconnect() end) end
            for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
            for _, c in pairs(espConnections) do pcall(function() c:Disconnect() end) end
            _G.SlapAuraAlreadyRunning = false
            _G.CandyFarmReady = false
            HUD:Destroy(); FloatGui:Destroy(); Window:Destroy()
        end })

        task.spawn(function()
            while task.wait(1) do
                if CandyFarm.Running then
                    pcall(function()
                        FarmTab:SetDesc("Candy Stats", string.format("Collected: %d | Folder: %s | Found: %d", CandyFarm.Collected, CandyFarm.FolderFound and CandyFarm.FolderName or "None", CandyFarm.LastCount))
                    end)
                end
            end
        end)
    end)
    if not success then
        warn("[Slap Aura] GUI Error: " .. tostring(err))
        showNotification("GUI Error", "WindUI Failed", false)
    else
        showNotification("Slap Aura", "V59 Ready!", true)
    end
end

LoadMainGUI()

task.delay(3, function()
    _G.CandyFarmReady = true
    print("✅ [Slap Aura] Candy Farm ready")
end)

print("✅ [Slap Aura] V59 Ultimate Final Ready!")
print("🚀 Server Hopper integrated in Farm tab")