-- ============================================================
-- 👑 SLAP AURA HUB | V59 | ABSOLUTE OMEGA ULTIMATE FINAL
-- Loading + Anti-Cheat + Full Anti Tab + All Features
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ============================================================
-- 🎬 0. LOADING SCREEN
-- ============================================================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "SlapAuraLoading"; LoadingGui.ResetOnSpawn = false
LoadingGui.DisplayOrder = 999999; LoadingGui.IgnoreGuiInset = true
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() LoadingGui.Parent = game:GetService("CoreGui") end)
if not LoadingGui.Parent then LoadingGui.Parent = PlayerGui end

local Backdrop = Instance.new("Frame")
Backdrop.Size = UDim2.fromScale(1, 1); Backdrop.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Backdrop.BorderSizePixel = 0; Backdrop.ZIndex = 1; Backdrop.Parent = LoadingGui

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 15)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 10, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
})
Gradient.Rotation = 45; Gradient.Parent = Backdrop

local Container = Instance.new("Frame")
Container.Size = UDim2.fromOffset(420, 260); Container.Position = UDim2.new(0.5, 0, 0.6, 0)
Container.AnchorPoint = Vector2.new(0.5, 0.5); Container.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Container.BackgroundTransparency = 1; Container.BorderSizePixel = 0; Container.ZIndex = 2; Container.Parent = LoadingGui

local ContainerCorner = Instance.new("UICorner"); ContainerCorner.CornerRadius = UDim.new(0, 14); ContainerCorner.Parent = Container
local ContainerStroke = Instance.new("UIStroke"); ContainerStroke.Color = Color3.fromRGB(255, 140, 0); ContainerStroke.Thickness = 1.5; ContainerStroke.Transparency = 1; ContainerStroke.Parent = Container

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 50); Logo.Position = UDim2.fromOffset(0, 25); Logo.BackgroundTransparency = 1
Logo.Text = "👑 SLAP AURA HUB"; Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBlack; Logo.TextSize = 28; Logo.ZIndex = 3; Logo.Parent = Container

local LogoGradient = Instance.new("UIGradient")
LogoGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 180, 80)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 140, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 120))
})
LogoGradient.Parent = Logo

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(1, 0, 0, 20); Version.Position = UDim2.fromOffset(0, 75)
Version.BackgroundTransparency = 1; Version.Text = "V59  •  Absolute Omega Ultimate Final"
Version.TextColor3 = Color3.fromRGB(160, 160, 175); Version.Font = Enum.Font.Gotham
Version.TextSize = 13; Version.ZIndex = 3; Version.Parent = Container

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(1, -80, 0, 8); BarBg.Position = UDim2.new(0.5, 0, 0, 135)
BarBg.AnchorPoint = Vector2.new(0.5, 0); BarBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
BarBg.BorderSizePixel = 0; BarBg.ZIndex = 3; BarBg.Parent = Container
local BarBgCorner = Instance.new("UICorner"); BarBgCorner.CornerRadius = UDim.new(1, 0); BarBgCorner.Parent = BarBg

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.fromScale(0, 1); BarFill.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
BarFill.BorderSizePixel = 0; BarFill.ZIndex = 4; BarFill.Parent = BarBg
local BarFillCorner = Instance.new("UICorner"); BarFillCorner.CornerRadius = UDim.new(1, 0); BarFillCorner.Parent = BarFill
local BarFillGradient = Instance.new("UIGradient")
BarFillGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 90, 60))
})
BarFillGradient.Parent = BarFill

local Percent = Instance.new("TextLabel")
Percent.Size = UDim2.new(1, 0, 0, 20); Percent.Position = UDim2.new(0, 0, 0, 155)
Percent.BackgroundTransparency = 1; Percent.Text = "0%"; Percent.TextColor3 = Color3.fromRGB(255, 140, 0)
Percent.Font = Enum.Font.GothamBold; Percent.TextSize = 14; Percent.ZIndex = 3; Percent.Parent = Container

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -40, 0, 40); Status.Position = UDim2.new(0, 20, 1, -55)
Status.BackgroundTransparency = 1; Status.Text = "Initializing..."
Status.TextColor3 = Color3.fromRGB(180, 180, 195); Status.Font = Enum.Font.Gotham
Status.TextSize = 12; Status.TextWrapped = true; Status.ZIndex = 3; Status.Parent = Container

TweenService:Create(Container, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 0.1
}):Play()
TweenService:Create(ContainerStroke, TweenInfo.new(0.6), {Transparency = 0.3}):Play()

local loadSteps = {
    {p = 10, text = "Loading Core Modules..."},
    {p = 25, text = "Bypassing Anti-Cheat (Ghost V9)..."},
    {p = 45, text = "Injecting Remote Hooks..."},
    {p = 60, text = "Building HUD..."},
    {p = 75, text = "Loading WindUI Framework..."},
    {p = 90, text = "Preparing Anti Systems..."},
    {p = 100, text = "Ready! Launching..."}
}

local function runLoadingScreen()
    for _, step in ipairs(loadSteps) do
        Status.Text = step.text
        TweenService:Create(BarFill, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(step.p / 100, 1)
        }):Play()
        Percent.Text = step.p .. "%"
        task.wait(0.3 + math.random() * 0.1)
    end
    task.wait(0.3)
    TweenService:Create(Container, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, 0.4, 0), BackgroundTransparency = 1
    }):Play()
    TweenService:Create(ContainerStroke, TweenInfo.new(0.45), {Transparency = 1}):Play()
    TweenService:Create(Backdrop, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.7)
    LoadingGui:Destroy()
end
runLoadingScreen()
print("🚀 [Slap Aura] V59 Ultimate Final Booting...")

-- ============================================================
-- 🛑 1. GHOST PROTOCOL V9
-- ============================================================
local CapturedRemote = nil
local RemoteFormat = "None"

pcall(function()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    local oldNewIndex = mt.__newindex
    setreadonly(mt, false)

    mt.__index = newcclosure(function(t, k)
        if (k == "WalkSpeed" or k == "JumpPower") and t:IsA("Humanoid") and t.Parent == LocalPlayer.Character then
            return k == "WalkSpeed" and 16 or 50
        end
        if (k == "AssemblyLinearVelocity" or k == "Velocity") and t.Parent == LocalPlayer.Character then
            local realVel = oldIndex(t, k)
            if type(realVel) == "Vector3" and realVel.Magnitude > 35 then
                return realVel.Unit * 15
            end
        end
        return oldIndex(t, k)
    end)

    mt.__newindex = newcclosure(function(t, k, v)
        if (k == "WalkSpeed" or k == "JumpPower") and t:IsA("Humanoid") and t.Parent == LocalPlayer.Character then
            return
        end
        return oldNewIndex(t, k, v)
    end)
    setreadonly(mt, true)
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" and self == LocalPlayer then return end

    if method == "FireServer" then
        local remoteName = string.lower(self.Name)
        local badRemotes = {"ban", "kick", "admingui", "walkspeedchanged", "anticheat", "detect", "report", "speedcheck", "flag"}
        for _, bad in ipairs(badRemotes) do
            if string.find(remoteName, bad) then return end
        end
        local args = {...}
        if #args > 0 then
            if type(args[1]) == "table" and args[1]["victim"] then
                if CapturedRemote ~= self then CapturedRemote = self; RemoteFormat = "Table" end
            elseif typeof(args[1]) == "Instance" and (args[1].Name == "Head" or args[1].Name == "HumanoidRootPart") then
                if CapturedRemote ~= self then CapturedRemote = self; RemoteFormat = "Instance" end
            end
        end
    end
    return oldNamecall(self, ...)
end)

-- ============================================================
-- ⚙️ 2. الإعدادات
-- ============================================================
local Settings = {
    AuraEnabled = true, Range = 15, AuraMaxHits = 5,
    FlySpeed = 50, Noclip = false, Godmode = true,
    PremiumSpeed = 35, ESP = false, AutoAim = false,
    HitboxExpander = false, GravityControl = false, FPSBooster = false,
    CandyFarm = false, ServerHopper = false,
    AntiVoid = false, AntiFling = false, AntiRagdoll = false,
    AntiKnockback = false, AntiSlap = false, AntiHoney = false,
    AntiIce = false, AntiMail = false, AntiMR = false,
    AntiMitten = false, AntiSquid = false, AntiAFK = false,
    AutoRejoin = false, SafePos = Vector3.new(0, 100, 0)
}
local HitCount = 0
local Connections = {}

-- ============================================================
-- 🔔 3. HUD
-- ============================================================
local HUD = Instance.new("ScreenGui")
HUD.Name = "SlapAuraHUD"; HUD.ResetOnSpawn = false; HUD.DisplayOrder = 9998; HUD.Parent = PlayerGui
local HUDFrame = Instance.new("Frame"); HUDFrame.Size = UDim2.new(0, 220, 0, 40); HUDFrame.Position = UDim2.new(0, 20, 0.1, 0); HUDFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); HUDFrame.BackgroundTransparency = 0.2; HUDFrame.BorderSizePixel = 0; HUDFrame.Parent = HUD
local HUDCorner = Instance.new("UICorner"); HUDCorner.CornerRadius = UDim.new(0, 6); HUDCorner.Parent = HUDFrame
local HUDStroke = Instance.new("UIStroke"); HUDStroke.Color = Color3.fromRGB(255, 140, 0); HUDStroke.Thickness = 1.5; HUDStroke.Parent = HUDFrame
local HUDText = Instance.new("TextLabel"); HUDText.Size = UDim2.new(1, -10, 1, 0); HUDText.Position = UDim2.new(0, 5, 0, 0); HUDText.BackgroundTransparency = 1; HUDText.Text = "🎃 Slap Aura: WAITING"; HUDText.TextColor3 = Color3.fromRGB(255, 255, 255); HUDText.Font = Enum.Font.GothamBold; HUDText.TextSize = 14; HUDText.Parent = HUDFrame

-- ============================================================
-- 🔔 4. الإشعارات
-- ============================================================
local function showNotification(title, text, isSuccess)
    local notifGui = Instance.new("ScreenGui"); notifGui.Name = "SlapNotifs"; notifGui.ResetOnSpawn = false; notifGui.DisplayOrder = 99999; pcall(function() notifGui.Parent = game:GetService("CoreGui") end); if not notifGui.Parent then notifGui.Parent = PlayerGui end
    local frame = Instance.new("Frame"); frame.Size = UDim2.fromOffset(280, 60); frame.Position = UDim2.new(1, 20, 0, 20); frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); frame.BorderSizePixel = 0; frame.Parent = notifGui
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 8); corner.Parent = frame
    local stroke = Instance.new("UIStroke"); stroke.Color = isSuccess and Color3.fromRGB(50, 220, 130) or Color3.fromRGB(255, 80, 80); stroke.Thickness = 1.5; stroke.Parent = frame
    local icon = Instance.new("TextLabel"); icon.Size = UDim2.fromOffset(30, 30); icon.Position = UDim2.fromOffset(10, 15); icon.BackgroundTransparency = 1; icon.Text = isSuccess and "✅" or "⚠️"; icon.TextSize = 20; icon.Parent = frame
    local titleLbl = Instance.new("TextLabel"); titleLbl.Size = UDim2.new(1, -50, 0, 20); titleLbl.Position = UDim2.fromOffset(45, 10); titleLbl.BackgroundTransparency = 1; titleLbl.Text = title; titleLbl.TextColor3 = Color3.fromRGB(255,255,255); titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 14; titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.Parent = frame
    local descLbl = Instance.new("TextLabel"); descLbl.Size = UDim2.new(1, -50, 0, 25); descLbl.Position = UDim2.fromOffset(45, 30); descLbl.BackgroundTransparency = 1; descLbl.Text = text; descLbl.TextColor3 = Color3.fromRGB(160, 160, 170); descLbl.Font = Enum.Font.Gotham; descLbl.TextSize = 12; descLbl.TextWrapped = true; descLbl.TextXAlignment = Enum.TextXAlignment.Left; descLbl.Parent = frame
    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -300, 0, 20)}):Play()
    task.delay(3, function() TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0, 20)}):Play(); task.wait(0.3); notifGui:Destroy() end)
end

-- ============================================================
-- 💎 5. المحركات الأساسية
-- ============================================================
function ToggleSpeed(state)
    if Connections.Speed then Connections.Speed:Disconnect() end
    if state then
        Connections.Speed = RunService.Heartbeat:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Settings.PremiumSpeed end
        end)
        showNotification("Speed", "Premium Speed On", true)
    else
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
        showNotification("Speed", "Premium Speed Off", false)
    end
end

local isFlying = false
function ToggleFly(state)
    isFlying = state
    if Connections.Fly then Connections.Fly:Disconnect() end
    if state then
        local char = LocalPlayer.Character; local root = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChildOfClass("Humanoid")
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
            showNotification("Fly", "Fly On", true)
        end
    else
        local char = LocalPlayer.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
            if root then local bv = root:FindFirstChild("FlyBV"); local bg = root:FindFirstChild("FlyBG"); if bv then bv:Destroy() end; if bg then bg:Destroy() end end
        end
        showNotification("Fly", "Fly Off", false)
    end
end

function ToggleGravity(state)
    if Connections.Gravity then Connections.Gravity:Disconnect() end
    if state then
        Connections.Gravity = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0.01, 0.01, 0, 0) end
        end)
        showNotification("Physics", "Zero Gravity On", true)
    else
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CustomPhysicalProperties = nil end
        showNotification("Physics", "Zero Gravity Off", false)
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
        showNotification("Combat", "Auto Aim On", true)
    end
end

function ToggleHitbox(state)
    if Connections.Hitbox then Connections.Hitbox:Disconnect() end
    if state then
        Connections.Hitbox = RunService.Heartbeat:Connect(function()
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then tool.Handle.Size = Vector3.new(5, 5, 5); tool.Handle.Transparency = 0.5 end
        end)
        showNotification("Combat", "Hitbox Expander On", true)
    end
end

function ToggleFPS(state)
    if state then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then pcall(function() v.Enabled = false end) end
        end
        showNotification("Perf", "FPS Boosted", true)
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
        showNotification("Noclip", "Noclip On", true)
    else
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
        showNotification("Noclip", "Noclip Off", false)
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
        showNotification("Godmode", "Godmode On", true)
    else
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.MaxHealth = 100; hum.Health = 100 end
        end
        showNotification("Godmode", "Godmode Off", false)
    end
end

-- ============================================================
-- 🍬 6. CANDY FARM + HOPPER
-- ============================================================
local function ToggleCandyFarm(state)
    Settings.CandyFarm = state
    if Connections.Candy then Connections.Candy:Disconnect() end
    if state then
        showNotification("Farm", "Corn Farm Started", true)
        Connections.Candy = task.spawn(function()
            while Settings.CandyFarm do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local foundCorn = false
                if hrp then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if not Settings.CandyFarm then break end
                        local name = string.lower(obj.Name)
                        if obj:IsA("BasePart") and (string.find(name, "corn") or string.find(name, "candy")) then
                            foundCorn = true
                            pcall(function()
                                local tween = TweenService:Create(hrp, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CFrame = CFrame.new(obj.Position)})
                                tween:Play(); tween.Completed:Wait()
                                firetouchinterest(hrp, obj, 0); task.wait(0.01); firetouchinterest(hrp, obj, 1)
                            end)
                            task.wait(0.1)
                        end
                    end
                end
                if not foundCorn then
                    if Settings.ServerHopper then
                        showNotification("Hopper", "Server Cleared! Hopping...", true)
                        task.wait(2)
                        if Settings.CandyFarm then
                            pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end)
                            break
                        end
                    else task.wait(3) end
                end
            end
        end)
    else showNotification("Farm", "Corn Farm Stopped", false) end
end

-- ============================================================
-- 👁️ 7. ESP
-- ============================================================
local activeESP = {}
function ToggleESP(state)
    Settings.ESP = state
    if Connections.ESP then Connections.ESP:Disconnect() end
    if state then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    local hl = Instance.new("Highlight", plr.Character); hl.FillColor = Color3.fromRGB(255, 140, 0); hl.FillTransparency = 0.5
                    local bb = Instance.new("BillboardGui", head); bb.Size = UDim2.new(0, 200, 0, 50); bb.StudsOffset = Vector3.new(0, 2.5, 0); bb.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bb); txt.Size = UDim2.new(1, 0, 1, 0); txt.BackgroundTransparency = 1; txt.TextColor3 = Color3.fromRGB(255, 255, 255); txt.TextStrokeTransparency = 0; txt.Font = Enum.Font.GothamBold; txt.TextSize = 14; txt.RichText = true
                    activeESP[plr.Name] = {Highlight = hl, Billboard = bb}
                end
            end
        end
        Connections.ESP = RunService.Heartbeat:Connect(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local data = activeESP[plr.Name]; local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if data and myRoot then
                        local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                        if tRoot then
                            local dist = math.floor((myRoot.Position - tRoot.Position).Magnitude)
                            local glove = plr.Character:FindFirstChildOfClass("Tool")
                            local text = data.Billboard:FindFirstChild("TextLabel")
                            if text then text.Text = string.format('%s\n[%s]\n%d studs', plr.DisplayName, glove and glove.Name or "None", dist) end
                        end
                    end
                end
            end
        end)
    else
        for _, v in pairs(activeESP) do if v.Highlight then v.Highlight:Destroy() end; if v.Billboard then v.Billboard:Destroy() end end
        activeESP = {}
    end
end

-- ============================================================
-- 🥊 8. AURA (Auto Slap)
-- ============================================================
local lastHit, hits, sec = 0, 0, math.floor(tick())
if Connections.Aura then Connections.Aura:Disconnect() end
Connections.Aura = RunService.Stepped:Connect(function()
    if not Settings.AuraEnabled or not CapturedRemote then return end
    local char = LocalPlayer.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); local tool = char:FindFirstChildOfClass("Tool")
    if not root or not tool then return end
    local cSec = math.floor(tick()); if cSec ~= sec then sec = cSec; hits = 0 end
    if hits >= Settings.AuraMaxHits then return end
    if tick() - lastHit < (1 / Settings.AuraMaxHits) then return end

    local closest, dist = nil, Settings.Range
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart"); local h = p.Character:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 and (root.Position - r.Position).Magnitude <= dist then
                dist = (root.Position - r.Position).Magnitude; closest = p
            end
        end
    end
    if closest and closest.Character:FindFirstChild("Head") then
        pcall(function()
            if RemoteFormat == "Table" then CapturedRemote:FireServer({["victim"] = closest.Character.Head, ["attacker"] = LocalPlayer})
            else CapturedRemote:FireServer(closest.Character.Head) end
            hits = hits + 1; lastHit = tick(); HitCount = HitCount + 1
            HUDText.Text = "🎃 Slap Aura: ACTIVE ("..HitCount.." Hits)"
        end)
    end
end)

-- ============================================================
-- 🛡️ 9. ANTI ENGINE (كل الـ Antis)
-- ============================================================

-- 🕳️ Anti Void
function ToggleAntiVoid(state)
    Settings.AntiVoid = state
    if Connections.AntiVoid then Connections.AntiVoid:Disconnect() end
    if state then
        Connections.AntiVoid = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Position.Y < -50 then
                pcall(function()
                    hrp.CFrame = CFrame.new(Settings.SafePos)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                end)
            end
        end)
        showNotification("Anti Void", "Void Protection On", true)
    else
        showNotification("Anti Void", "Off", false)
    end
end

-- 🌀 Anti Fling
function ToggleAntiFling(state)
    Settings.AntiFling = state
    if Connections.AntiFling then Connections.AntiFling:Disconnect() end
    if state then
        Connections.AntiFling = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vel = hrp.AssemblyLinearVelocity
                if vel.Magnitude > 200 then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end)
        showNotification("Anti Fling", "Fling Protection On", true)
    else
        showNotification("Anti Fling", "Off", false)
    end
end

-- 💀 Anti Ragdoll
function ToggleAntiRagdoll(state)
    Settings.AntiRagdoll = state
    if Connections.AntiRagdoll then Connections.AntiRagdoll:Disconnect() end
    if state then
        Connections.AntiRagdoll = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.PlatformStand or hum:GetState() == Enum.HumanoidStateType.Physics or hum:GetState() == Enum.HumanoidStateType.FallingDown then
                    hum.PlatformStand = false
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end)
        showNotification("Anti Ragdoll", "Ragdoll Protection On", true)
    else
        showNotification("Anti Ragdoll", "Off", false)
    end
end

-- 💥 Anti Knockback
function ToggleAntiKnockback(state)
    Settings.AntiKnockback = state
    if Connections.AntiKB then Connections.AntiKB:Disconnect() end
    if state then
        Connections.AntiKB = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vel = hrp.AssemblyLinearVelocity
                local horizontalVel = Vector3.new(vel.X, 0, vel.Z)
                if horizontalVel.Magnitude > 100 then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0)
                end
            end
        end)
        showNotification("Anti Knockback", "Knockback Nullified", true)
    else
        showNotification("Anti Knockback", "Off", false)
    end
end

-- 👋 Anti Slap
function ToggleAntiSlap(state)
    Settings.AntiSlap = state
    if Connections.AntiSlap then Connections.AntiSlap:Disconnect() end
    if state then
        Connections.AntiSlap = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:FindFirstChildOfClass("Attachment") == nil then
                -- لا شيء، مجرد حماية من force
            end
            -- منع الـ slap force
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.Health < hum.MaxHealth and Settings.Godmode then
                    hum.Health = hum.MaxHealth
                end
            end
        end)
        showNotification("Anti Slap", "Slap Protection On", true)
    else
        showNotification("Anti Slap", "Off", false)
    end
end

-- 🍯 Anti Honey
function ToggleAntiHoney(state)
    Settings.AntiHoney = state
    if Connections.AntiHoney then Connections.AntiHoney:Disconnect() end
    if state then
        Connections.AntiHoney = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            if hum.WalkSpeed < 16 and hum.WalkSpeed > 0 then
                hum.WalkSpeed = 16
            end
            for _, v in ipairs(char:GetDescendants()) do
                local n = string.lower(v.Name)
                if (v:IsA("ObjectValue") or v:IsA("BoolValue") or v:IsA("Highlight") or v:IsA("NumberValue")) then
                    if string.find(n, "honey") or string.find(n, "slow") or string.find(n, "sticky") then
                        pcall(function() v:Destroy() end)
                    end
                end
            end
        end)
        showNotification("Anti Honey", "🍯 Honey Removed", true)
    else
        showNotification("Anti Honey", "Off", false)
    end
end

-- 🧊 Anti Ice
function ToggleAntiIce(state)
    Settings.AntiIce = state
    if Connections.AntiIce then Connections.AntiIce:Disconnect() end
    if state then
        Connections.AntiIce = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hum.WalkSpeed < 16 and hum.WalkSpeed > 0 then
                hum.WalkSpeed = 16
            end
            if hrp and hrp.Anchored then
                hrp.Anchored = false
            end
            for _, v in ipairs(char:GetDescendants()) do
                local n = string.lower(v.Name)
                if v:IsA("Highlight") or v:IsA("ParticleEmitter") or v:IsA("ObjectValue") then
                    if string.find(n, "ice") or string.find(n, "freeze") or string.find(n, "frozen") then
                        pcall(function() v:Destroy() end)
                    end
                end
            end
        end)
        showNotification("Anti Ice", "🧊 Ice Removed", true)
    else
        showNotification("Anti Ice", "Off", false)
    end
end

-- 📬 Anti Mail
function ToggleAntiMail(state)
    Settings.AntiMail = state
    if Connections.AntiMail then Connections.AntiMail:Disconnect() end
    if state then
        Connections.AntiMail = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _, v in ipairs(char:GetDescendants()) do
                local n = string.lower(v.Name)
                if v:IsA("Highlight") or v:IsA("BillboardGui") or v:IsA("ParticleEmitter") or v:IsA("Sound") then
                    if string.find(n, "mail") or string.find(n, "letter") then
                        pcall(function() v:Destroy() end)
                    end
                end
            end
            if Camera then
                for _, v in ipairs(Camera:GetChildren()) do
                    if v:IsA("BlurEffect") then
                        local n = string.lower(v.Name)
                        if string.find(n, "mail") or string.find(n, "letter") then pcall(function() v:Destroy() end) end
                    end
                end
            end
        end)
        showNotification("Anti Mail", "📬 Mail Removed", true)
    else
        showNotification("Anti Mail", "Off", false)
    end
end

-- 🎭 Anti MR (Mirror)
function ToggleAntiMR(state)
    Settings.AntiMR = state
    if Connections.AntiMR then Connections.AntiMR:Disconnect() end
    if state then
        Connections.AntiMR = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _, v in ipairs(char:GetDescendants()) do
                local n = string.lower(v.Name)
                if v:IsA("Highlight") or v:IsA("ParticleEmitter") or v:IsA("ObjectValue") then
                    if string.find(n, "mirror") or string.find(n, "mr") then
                        pcall(function() v:Destroy() end)
                    end
                end
            end
            if Camera then
                for _, v in ipairs(Camera:GetChildren()) do
                    if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then
                        local n = string.lower(v.Name)
                        if string.find(n, "mirror") or string.find(n, "mr") then pcall(function() v:Destroy() end) end
                    end
                end
            end
        end)
        showNotification("Anti MR", "🎭 MR Removed", true)
    else
        showNotification("Anti MR", "Off", false)
    end
end

-- 🧤 Anti Mitten
function ToggleAntiMitten(state)
    Settings.AntiMitten = state
    if Connections.AntiMitten then Connections.AntiMitten:Disconnect() end
    if state then
        Connections.AntiMitten = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _, v in ipairs(char:GetDescendants()) do
                local n = string.lower(v.Name)
                if v:IsA("Highlight") or v:IsA("BillboardGui") or v:IsA("ParticleEmitter") then
                    if string.find(n, "mitten") or string.find(n, "glove") then
                        pcall(function() v:Destroy() end)
                    end
                end
            end
        end)
        showNotification("Anti Mitten", "🧤 Mitten Removed", true)
    else
        showNotification("Anti Mitten", "Off", false)
    end
end

-- 🦑 Anti Squid
function ToggleAntiSquid(state)
    Settings.AntiSquid = state
    if Connections.AntiSquid then Connections.AntiSquid:Disconnect() end
    if state then
        Connections.AntiSquid = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _, v in ipairs(char:GetDescendants()) do
                local n = string.lower(v.Name)
                if v:IsA("Highlight") or v:IsA("ParticleEmitter") or v:IsA("BillboardGui") or v:IsA("ObjectValue") then
                    if string.find(n, "squid") or string.find(n, "ink") then
                        pcall(function() v:Destroy() end)
                    end
                end
            end
            if Camera then
                for _, v in ipairs(Camera:GetChildren()) do
                    if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then
                        local n = string.lower(v.Name)
                        if string.find(n, "squid") or string.find(n, "ink") then pcall(function() v:Destroy() end) end
                    end
                end
            end
        end)
        showNotification("Anti Squid", "🦑 Squid Removed", true)
    else
        showNotification("Anti Squid", "Off", false)
    end
end

-- 😴 Anti AFK
function ToggleAntiAFK(state)
    Settings.AntiAFK = state
    if Connections.AntiAFK then Connections.AntiAFK:Disconnect() end
    if state then
        Connections.AntiAFK = task.spawn(function()
            while Settings.AntiAFK do
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
                task.wait(60)
            end
        end)
        showNotification("Anti AFK", "AFK Protection On", true)
    else
        showNotification("Anti AFK", "Off", false)
    end
end

-- 🔄 Auto Rejoin
function ToggleAutoRejoin(state)
    Settings.AutoRejoin = state
    if state then
        pcall(function()
            LocalPlayer.OnTeleport:Connect(function(s)
                if s == Enum.TeleportState.Started and Settings.AutoRejoin then
                    task.wait(3)
                    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
                end
            end)
        end)
        showNotification("Auto Rejoin", "Auto Rejoin On", true)
    else
        showNotification("Auto Rejoin", "Off", false)
    end
end

-- ============================================================
-- 🎨 10. الواجهة (WindUI)
-- ============================================================
function LoadMainGUI()
    local success, err = pcall(function()
        local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
        local Window = WindUI:CreateWindow({ Title = "Slap Aura | V59 Ultimate Final", Icon = "shield", Author = "Majed", Folder = "SlapAuraV59", Size = UDim2.fromOffset(600, 500), Transparent = true, Theme = "Dark" })

        -- ⚔️ Combat
        local CombatTab = Window:Tab({ Title = "Combat", Icon = "crosshair" })
        CombatTab:Button({ Title = "🔄 Refresh Glove", Callback = function() CapturedRemote = nil; RemoteFormat = "None"; showNotification("System", "Glove Reset", true) end })
        CombatTab:Toggle({ Title = "Enable Auto Slap", Value = true, Callback = function(s) Settings.AuraEnabled = s end })
        CombatTab:Slider({ Title = "Aura Range", Value = { Min = 5, Max = 50, Default = 15 }, Callback = function(v) Settings.Range = v end })
        CombatTab:Slider({ Title = "Aura Max Hits/sec", Value = { Min = 1, Max = 20, Default = 5 }, Callback = function(v) Settings.AuraMaxHits = v end })
        CombatTab:Toggle({ Title = "Auto Aim", Value = false, Callback = function(s) ToggleAutoAim(s) end })
        CombatTab:Toggle({ Title = "Hitbox Expander", Value = false, Callback = function(s) ToggleHitbox(s) end })
        CombatTab:Toggle({ Title = "🛡️ Godmode", Value = false, Callback = function(s) ToggleGodmode(s) end })

        -- 💨 Movement
        local MoveTab = Window:Tab({ Title = "Movement", Icon = "wind" })
        MoveTab:Toggle({ Title = "Premium Speed", Value = false, Callback = function(s) ToggleSpeed(s) end })
        MoveTab:Slider({ Title = "Speed Value", Value = { Min = 16, Max = 100, Default = 35 }, Callback = function(v) Settings.PremiumSpeed = v end })
        MoveTab:Toggle({ Title = "Fly", Value = false, Callback = function(s) ToggleFly(s) end })
        MoveTab:Slider({ Title = "Fly Speed", Value = { Min = 20, Max = 200, Default = 50 }, Callback = function(v) Settings.FlySpeed = v end })
        MoveTab:Toggle({ Title = "Zero Gravity", Value = false, Callback = function(s) ToggleGravity(s) end })
        MoveTab:Toggle({ Title = "🚪 Noclip", Value = false, Callback = function(s) ToggleNoclip(s) end })

        -- 🍬 Farm
        local FarmTab = Window:Tab({ Title = "Farm", Icon = "leaf" })
        FarmTab:Toggle({ Title = "Candy Corn Farm", Value = false, Callback = function(s) ToggleCandyFarm(s) end })
        FarmTab:Toggle({ Title = "Server Hopper", Value = false, Callback = function(s) Settings.ServerHopper = s end })

        -- 👁️ Visuals
        local VisTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
        VisTab:Toggle({ Title = "Player ESP", Value = false, Callback = function(s) ToggleESP(s) end })
        VisTab:Toggle({ Title = "FPS Booster", Value = false, Callback = function(s) ToggleFPS(s) end })

        -- 🛡️ ANTI TAB
        local AntiTab = Window:Tab({ Title = "Anti", Icon = "shield" })

        AntiTab:Section({ Title = "🎮 Game Mechanics" })
        AntiTab:Toggle({ Title = "🕳️ Anti Void", Value = false, Callback = function(s) ToggleAntiVoid(s) end })
        AntiTab:Toggle({ Title = "🌀 Anti Fling", Value = false, Callback = function(s) ToggleAntiFling(s) end })
        AntiTab:Toggle({ Title = "💀 Anti Ragdoll", Value = false, Callback = function(s) ToggleAntiRagdoll(s) end })
        AntiTab:Toggle({ Title = "💥 Anti Knockback", Value = false, Callback = function(s) ToggleAntiKnockback(s) end })
        AntiTab:Toggle({ Title = "👋 Anti Slap", Value = false, Callback = function(s) ToggleAntiSlap(s) end })

        AntiTab:Section({ Title = "🧊 Glove Effects" })
        AntiTab:Toggle({ Title = "🍯 Anti Honey", Value = false, Callback = function(s) ToggleAntiHoney(s) end })
        AntiTab:Toggle({ Title = "🧊 Anti Ice", Value = false, Callback = function(s) ToggleAntiIce(s) end })
        AntiTab:Toggle({ Title = "📬 Anti Mail", Value = false, Callback = function(s) ToggleAntiMail(s) end })
        AntiTab:Toggle({ Title = "🎭 Anti MR", Value = false, Callback = function(s) ToggleAntiMR(s) end })
        AntiTab:Toggle({ Title = "🧤 Anti Mitten", Value = false, Callback = function(s) ToggleAntiMitten(s) end })
        AntiTab:Toggle({ Title = "🦑 Anti Squid", Value = false, Callback = function(s) ToggleAntiSquid(s) end })

        AntiTab:Section({ Title = "⚙️ System Protection" })
        AntiTab:Toggle({ Title = "😴 Anti AFK", Value = false, Callback = function(s) ToggleAntiAFK(s) end })
        AntiTab:Toggle({ Title = "🔄 Auto Rejoin", Value = false, Callback = function(s) ToggleAutoRejoin(s) end })

        AntiTab:Section({ Title = "🔍 Info" })
        AntiTab:Paragraph({ Title = "Ghost Protocol V9", Desc = "Hooks: __index / __newindex / __namecall\nAnti-Kick: ALWAYS ON\nBad Remotes: BLOCKED" })
        AntiTab:Button({ Title = "🛡️ Toggle All Anti", Callback = function()
            for _, name in ipairs({"AntiVoid","AntiFling","AntiRagdoll","AntiKnockback","AntiSlap","AntiHoney","AntiIce","AntiMail","AntiMR","AntiMitten","AntiSquid"}) do
                if Settings[name] ~= nil then
                    Settings[name] = true
                    if name == "AntiVoid" then ToggleAntiVoid(true) end
                    if name == "AntiFling" then ToggleAntiFling(true) end
                    if name == "AntiRagdoll" then ToggleAntiRagdoll(true) end
                    if name == "AntiKnockback" then ToggleAntiKnockback(true) end
                    if name == "AntiSlap" then ToggleAntiSlap(true) end
                    if name == "AntiHoney" then ToggleAntiHoney(true) end
                    if name == "AntiIce" then ToggleAntiIce(true) end
                    if name == "AntiMail" then ToggleAntiMail(true) end
                    if name == "AntiMR" then ToggleAntiMR(true) end
                    if name == "AntiMitten" then ToggleAntiMitten(true) end
                    if name == "AntiSquid" then ToggleAntiSquid(true) end
                end
            end
            showNotification("Anti", "ALL Antis Enabled 🛡️", true)
        end })

        -- ⚙️ Settings
        local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })
        SettingsTab:Button({ Title = "🔔 Test Notification", Callback = function() showNotification("Test", "Notifications working!", true) end })
        SettingsTab:Button({ Title = "📍 Set Safe Pos", Callback = function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                Settings.SafePos = char.HumanoidRootPart.Position
                showNotification("Safe Pos", "Updated!", true)
            end
        end })
        SettingsTab:Button({ Title = "❌ Unload Script", Callback = function()
            for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
            HUD:Destroy(); Window:Destroy()
        end })
    end)

    if not success then
        warn("[Slap Aura] GUI Load Failed: " .. tostring(err))
        showNotification("GUI Error", "WindUI failed to load", false)
    else
        showNotification("Slap Aura", "V59 Ultimate Final Loaded! 🎃", true)
    end
end

LoadMainGUI()
print("✅ [Slap Aura] V59 Ultimate Final Ready!")