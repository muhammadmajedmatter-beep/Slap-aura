-- ============================================================
-- 👑 SLAP AURA HUB | V63 ULTIMATE FINAL
-- Every Feature • Pro AI • Max Performance
-- ============================================================

if _G.SlapAuraAlreadyRunning then return end
_G.SlapAuraAlreadyRunning = true

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
pcall(function() LoadingGui.Parent = game:GetService("CoreGui") end)
if not LoadingGui.Parent then LoadingGui.Parent = PlayerGui end

local Backdrop = Instance.new("Frame", LoadingGui)
Backdrop.Size = UDim2.fromScale(1, 1)
Backdrop.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Backdrop.BorderSizePixel = 0
local bgG = Instance.new("UIGradient", Backdrop)
bgG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 15)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 10, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
})
bgG.Rotation = 45

local Logo = Instance.new("TextLabel", Backdrop)
Logo.Size = UDim2.new(1, 0, 0, 70)
Logo.Position = UDim2.fromScale(0, 0.4)
Logo.BackgroundTransparency = 1
Logo.Text = "👑 SLAP AURA"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 42
local LogoG = Instance.new("UIGradient", Logo)
LogoG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 180, 80)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 100, 255))
})

local VerLbl = Instance.new("TextLabel", Backdrop)
VerLbl.Size = UDim2.new(1, 0, 0, 25)
VerLbl.Position = UDim2.new(0, 0, 0.47, 5)
VerLbl.BackgroundTransparency = 1
VerLbl.Text = "V63 ULTIMATE FINAL"
VerLbl.TextColor3 = Color3.fromRGB(255, 200, 60)
VerLbl.Font = Enum.Font.GothamBold
VerLbl.TextSize = 16

local Status = Instance.new("TextLabel", Backdrop)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.52, 0)
Status.BackgroundTransparency = 1
Status.Text = "Booting up..."
Status.TextColor3 = Color3.fromRGB(160, 160, 175)
Status.Font = Enum.Font.Gotham
Status.TextSize = 14

for _, s in ipairs({"Loading Core...", "Loading UI...", "Loading AI...", "Ready!"}) do
    Status.Text = s
    task.wait(0.4)
end

TweenService:Create(Backdrop, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(Logo, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
TweenService:Create(VerLbl, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
TweenService:Create(Status, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
task.wait(0.6)
LoadingGui:Destroy()

-- ============================================================
-- 🛑 GHOST PROTOCOL V9
-- ============================================================
local CapturedRemote = nil
local RemoteFormat = "None"

if hookmetamethod and getrawmetatable then
    pcall(function()
        local mt = getrawmetatable(game)
        local oldIndex = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(t, k)
            if checkcaller() then return oldIndex(t, k) end
            if (k == "WalkSpeed" or k == "JumpPower") and t:IsA("Humanoid") and t.Parent == LocalPlayer.Character then
                return k == "WalkSpeed" and 16 or 50
            end
            if (k == "AssemblyLinearVelocity" or k == "Velocity") and t.Parent == LocalPlayer.Character then
                local v = oldIndex(t, k)
                if type(v) == "Vector3" and v.Magnitude > 35 then return v.Unit * 15 end
            end
            return oldIndex(t, k)
        end)
        setreadonly(mt, true)
    end)
    pcall(function()
        local mt = getrawmetatable(game)
        local old = mt.__newindex
        setreadonly(mt, false)
        mt.__newindex = newcclosure(function(t, k, v)
            if checkcaller() then return old(t, k, v) end
            if t:IsA("Humanoid") and t.Parent == LocalPlayer.Character then
                if k == "WalkSpeed" and v == 16 then return end
                if k == "JumpPower" and v == 50 then return end
            end
            return old(t, k, v)
        end)
        setreadonly(mt, true)
    end)
    local oldNC
    pcall(function()
        oldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if checkcaller() then return oldNC(self, ...) end
            local m = getnamecallmethod()
            if m == "Kick" and self == LocalPlayer then return end
            if m == "FireServer" then
                local rn = string.lower(self.Name)
                for _, bad in ipairs({"ban","kick","anticheat","detect","report","speedcheck","flag"}) do
                    if string.find(rn, bad) then return end
                end
                local args = {...}
                if #args > 0 then
                    if type(args[1]) == "table" and args[1]["victim"] then
                        if CapturedRemote ~= self then CapturedRemote = self; RemoteFormat = "Table" end
                    elseif typeof(args[1]) == "Instance" and args[1]:IsA("BasePart") then
                        if CapturedRemote ~= self then CapturedRemote = self; RemoteFormat = "Instance" end
                    end
                end
            end
            return oldNC(self, ...)
        end))
    end)
end

-- ============================================================
-- ⚙️ SETTINGS
-- ============================================================
local Settings = {
    AuraEnabled = true, Range = 15, AuraMaxHits = 5, HitPart = "Any",
    FlySpeed = 50, Noclip = false, Godmode = false, PremiumSpeed = 35, JumpPower = 50,
    ESP = false, ESPBox = false, ESPTracer = false, SilentAim = false, AutoAim = false,
    HitboxExpander = false, AutoAbility = false, AntiSlap = false, AutoClicker = false,
    InfiniteJump = false, FastAttack = false, AntiTeleport = false,
    AutoWalk = false, RainbowAura = false, CharSize = 1.0,
    AntiVoid = false, AntiFling = false, AntiRagdoll = false, AntiKnockback = false,
    AntiHoney = false, AntiIce = false, AntiMail = false, AntiMR = false,
    AntiMitten = false, AntiSquid = false, AntiAFK = false, AutoRejoin = false,
    AutoPlay = false, AutoPlaySpeed = 65, AutoPlayRange = 250,
    SafePos = Vector3.new(0, 100, 0)
}
local Connections = {}
local HitCount = 0
local SlapCount = 0

-- ============================================================
-- 🎯 HELPERS
-- ============================================================
local function GetTargetPart(char)
    if not char then return nil end
    if Settings.HitPart == "Head" then return char:FindFirstChild("Head")
    elseif Settings.HitPart == "HumanoidRootPart" then return char:FindFirstChild("HumanoidRootPart")
    else return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildOfClass("BasePart") end
end

local function GetClosestPlayer(range)
    range = range or 999
    local closest, dist = nil, range
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 then
                local d = (myRoot.Position - r.Position).Magnitude
                if d < dist then dist = d; closest = p end
            end
        end
    end
    return closest, dist
end

-- ============================================================
-- 🔔 NOTIFICATIONS
-- ============================================================
local function showNotification(title, text, isSuccess)
    local ng = Instance.new("ScreenGui")
    ng.Name = "SlapNotifs"; ng.ResetOnSpawn = false; ng.DisplayOrder = 99999
    pcall(function() ng.Parent = game:GetService("CoreGui") end)
    if not ng.Parent then ng.Parent = PlayerGui end
    local f = Instance.new("Frame", ng)
    f.Size = UDim2.fromOffset(300, 65)
    f.Position = UDim2.new(1, 20, 0, 20)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", f)
    s.Color = isSuccess and Color3.fromRGB(50, 220, 130) or Color3.fromRGB(255, 80, 80)
    s.Thickness = 1.5
    local i = Instance.new("TextLabel", f)
    i.Size = UDim2.fromOffset(32, 32); i.Position = UDim2.fromOffset(10, 17)
    i.BackgroundTransparency = 1; i.Text = isSuccess and "✅" or "⚠️"; i.TextSize = 22
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, -50, 0, 22); t.Position = UDim2.fromOffset(48, 10)
    t.BackgroundTransparency = 1; t.Text = title
    t.TextColor3 = Color3.fromRGB(255,255,255); t.Font = Enum.Font.GothamBold
    t.TextSize = 14; t.TextXAlignment = Enum.TextXAlignment.Left
    local d = Instance.new("TextLabel", f)
    d.Size = UDim2.new(1, -50, 0, 28); d.Position = UDim2.fromOffset(48, 32)
    d.BackgroundTransparency = 1; d.Text = text
    d.TextColor3 = Color3.fromRGB(160, 160, 170); d.Font = Enum.Font.Gotham
    d.TextSize = 12; d.TextWrapped = true; d.TextXAlignment = Enum.TextXAlignment.Left
    TweenService:Create(f, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -320, 0, 20)}):Play()
    task.delay(3, function()
        TweenService:Create(f, TweenInfo.new(0.3), {Position = UDim2.new(1, 20, 0, 20)}):Play()
        task.wait(0.3); ng:Destroy()
    end)
end

-- ============================================================
-- 🎨 GLOVE DATA
-- ============================================================
local GloveDanger = {
    ["killstreak"]="EXTREME",["god's hand"]="EXTREME",["gods hand"]="EXTREME",["error"]="EXTREME",
    ["reaper"]="EXTREME",["thanos"]="EXTREME",["overkill"]="EXTREME",["megarock"]="EXTREME",
    ["berserk"]="EXTREME",["hallow jack"]="EXTREME",["detonator"]="EXTREME",["bob"]="EXTREME",
    ["mitten"]="HIGH",["leash"]="HIGH",["fish"]="HIGH",["grab"]="HIGH",["pull"]="HIGH",
    ["lure"]="HIGH",["phase"]="HIGH",["wormhole"]="HIGH",["blackhole"]="HIGH",
    ["rattlebones"]="HIGH",["home run"]="HIGH",["jet"]="HIGH",["baller"]="HIGH",
    ["za hando"]="HIGH",["recycler"]="HIGH",["bomb"]="HIGH",["sparky"]="HIGH",
    ["conductor"]="HIGH",["tinkerer"]="HIGH",["rhythm"]="HIGH",["track"]="HIGH",
    ["ice"]="MEDIUM",["snowball"]="MEDIUM",["mr"]="MEDIUM",["mail"]="MEDIUM",
    ["squid"]="MEDIUM",["honey"]="MEDIUM",["cloud"]="MEDIUM",["kinetic"]="MEDIUM",
    ["slapple"]="MEDIUM",["moon"]="MEDIUM"
}
local DangerColors = {
    EXTREME={Fill=Color3.fromRGB(255,30,30),Text="🔴 EXTREME"},
    HIGH={Fill=Color3.fromRGB(255,140,0),Text="🟠 HIGH"},
    MEDIUM={Fill=Color3.fromRGB(255,220,50),Text="🟡 MEDIUM"},
    SAFE={Fill=Color3.fromRGB(80,220,130),Text="🟢 SAFE"},
    NONE={Fill=Color3.fromRGB(150,150,150),Text="⚪ NONE"}
}
local function GetPlayerGlove(plr)
    if not plr.Character then return nil, "NONE" end
    local tool = plr.Character:FindFirstChildOfClass("Tool")
    if not tool then return nil, "NONE" end
    local n = string.lower(tool.Name)
    return tool.Name, (GloveDanger[n] or "SAFE")
end

-- ============================================================
-- 👁️ ESP PRO (Highlight + Box + Tracer + Health + Glove)
-- ============================================================
local espData = {}
local espConns = {}
local function RemoveESP(plr)
    if espData[plr.Name] then
        pcall(function()
            local d = espData[plr.Name]
            if d.Highlight then d.Highlight:Destroy() end
            if d.Billboard then d.Billboard:Destroy() end
            if d.Box and d.Box.Remove then d.Box:Remove() end
            if d.Tracer and d.Tracer.Remove then d.Tracer:Remove() end
        end)
        espData[plr.Name] = nil
    end
end
local function CreateESP(plr)
    if plr == LocalPlayer or not plr.Character then return end
    RemoveESP(plr)
    local char = plr.Character
    local head = char:FindFirstChild("Head")
    if not head then return end
    local hl = Instance.new("Highlight", char)
    hl.FillColor = Color3.fromRGB(255, 140, 0); hl.FillTransparency = 0.5
    hl.OutlineColor = Color3.fromRGB(255, 140, 0)
    local bb = Instance.new("BillboardGui", head)
    bb.Size = UDim2.new(0, 220, 0, 80); bb.StudsOffset = Vector3.new(0, 2.5, 0); bb.AlwaysOnTop = true
    local txt = Instance.new("TextLabel", bb)
    txt.Size = UDim2.new(1, 0, 1, 0); txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(255, 255, 255); txt.TextStrokeTransparency = 0
    txt.Font = Enum.Font.GothamBold; txt.TextSize = 13
    local box, tracer
    if Drawing then
        box = Drawing.new("Square"); box.Thickness = 1.5; box.Filled = false; box.Visible = false
        tracer = Drawing.new("Line"); tracer.Thickness = 1; tracer.Visible = false
    end
    espData[plr.Name] = {Highlight=hl, Billboard=bb, Text=txt, Box=box, Tracer=tracer}
end
function ToggleESP(state)
    Settings.ESP = state
    for _, c in pairs(espConns) do pcall(function() c:Disconnect() end) end
    espConns = {}
    if Connections.ESP then Connections.ESP:Disconnect() end
    if state then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                CreateESP(plr)
                table.insert(espConns, plr.CharacterAdded:Connect(function()
                    task.wait(0.5); if Settings.ESP then CreateESP(plr) end
                end))
            end
        end
        table.insert(espConns, Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                task.wait(0.5); if Settings.ESP then CreateESP(plr) end
            end)
        end))
        table.insert(espConns, Players.PlayerRemoving:Connect(RemoveESP))
        Connections.ESP = RunService.RenderStepped:Connect(function()
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            for name, data in pairs(espData) do
                local plr = Players:FindFirstChild(name)
                if plr and plr.Character and data.Text then
                    local head = plr.Character:FindFirstChild("Head")
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if head and hrp and hum then
                        local dist = myRoot and math.floor((myRoot.Position - hrp.Position).Magnitude) or 0
                        local glove, danger = GetPlayerGlove(plr)
                        local ci = DangerColors[danger] or DangerColors.SAFE
                        local hp = math.floor(hum.Health/hum.MaxHealth*100)
                        data.Text.Text = string.format("%s\n%s [%s]\n%d HP • %d studs", plr.DisplayName, ci.Text, glove or "None", hp, dist)
                        data.Highlight.FillColor = ci.Fill
                        data.Highlight.OutlineColor = ci.Fill
                        data.Highlight.FillTransparency = (danger=="EXTREME") and 0.3 or 0.5
                        if data.Box and Settings.ESPBox then
                            local sp, on = Camera:WorldToViewportPoint(hrp.Position)
                            if on then
                                local sc = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                                local bs = Vector2.new(math.floor(hrp.Size.X*(100/sc)*3), math.floor(hrp.Size.Y*(100/sc)*3))
                                data.Box.Size = bs
                                data.Box.Position = Vector2.new(math.floor(sp.X - bs.X/2), math.floor(sp.Y - bs.Y/2))
                                data.Box.Color = ci.Fill
                                data.Box.Visible = true
                            else data.Box.Visible = false end
                        elseif data.Box then data.Box.Visible = false end
                        if data.Tracer and Settings.ESPTracer then
                            local tp = Camera:WorldToViewportPoint(hrp.Position)
                            data.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                            data.Tracer.To = Vector2.new(tp.X, tp.Y)
                            data.Tracer.Color = ci.Fill
                            data.Tracer.Visible = true
                        elseif data.Tracer then data.Tracer.Visible = false end
                    end
                end
            end
        end)
        showNotification("ESP", "ON", true)
    else
        for _, plr in ipairs(Players:GetPlayers()) do RemoveESP(plr) end
        espData = {}
        showNotification("ESP", "OFF", false)
    end
end

-- ============================================================
-- 🎯 SILENT AIM
-- ============================================================
function ToggleSilentAim(state)
    Settings.SilentAim = state
    if state and hookmetamethod then
        pcall(function()
            local mt = getrawmetatable(game)
            local old = mt.__index
            setreadonly(mt, false)
            mt.__index = newcclosure(function(t, k)
                if checkcaller() then return old(t, k) end
                if k == "Hit" and t:IsA("Mouse") and Settings.SilentAim then
                    local tgt = GetClosestPlayer(500)
                    if tgt and tgt.Character then
                        local head = tgt.Character:FindFirstChild("Head")
                        if head then return CFrame.new(head.Position) end
                    end
                end
                return old(t, k)
            end)
            setreadonly(mt, true)
        end)
        showNotification("Silent Aim", "ON", true)
    else showNotification("Silent Aim", "OFF", false) end
end

-- ============================================================
-- 💎 MOVEMENT & COMBAT
-- ============================================================
function ToggleSpeed(s)
    if Connections.Speed then Connections.Speed:Disconnect() end
    if s then
        Connections.Speed = RunService.Heartbeat:Connect(function()
            local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = Settings.PremiumSpeed end
        end)
        showNotification("Speed", "ON", true)
    else
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16 end
        showNotification("Speed", "OFF", false)
    end
end

function ToggleJump(s)
    if Connections.Jump then Connections.Jump:Disconnect() end
    if s then
        Connections.Jump = RunService.Heartbeat:Connect(function()
            local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.JumpPower = Settings.JumpPower; h.UseJumpPower = true end
        end)
        showNotification("Jump", "ON", true)
    else
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.JumpPower = 50 end
        showNotification("Jump", "OFF", false)
    end
end

function ToggleInfiniteJump(s)
    Settings.InfiniteJump = s
    if Connections.InfJump then Connections.InfJump:Disconnect() end
    if s then
        Connections.InfJump = UserInputService.JumpRequest:Connect(function()
            if Settings.InfiniteJump then
                local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
        showNotification("Inf Jump", "ON", true)
    else showNotification("Inf Jump", "OFF", false) end
end

local isFlying = false
function ToggleFly(s)
    isFlying = s
    if Connections.Fly then Connections.Fly:Disconnect() end
    if s then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if root and hum then
            hum:ChangeState(Enum.HumanoidStateType.Physics)
            local bv = Instance.new("BodyVelocity", root); bv.Name = "FlyBV"
            bv.MaxForce = Vector3.new(1e5,1e5,1e5); bv.Velocity = Vector3.new(0,0,0)
            local bg = Instance.new("BodyGyro", root); bg.Name = "FlyBG"
            bg.MaxTorque = Vector3.new(1e5,1e5,1e5); bg.P = 5000; bg.D = 50
            Connections.Fly = RunService.RenderStepped:Connect(function()
                if not isFlying or not root or not hum then return end
                local vel = hum.MoveDirection * Settings.FlySpeed
                if Camera.CFrame.LookVector.Y > 0.4 then vel = vel + Vector3.new(0, Settings.FlySpeed, 0)
                elseif Camera.CFrame.LookVector.Y < -0.4 then vel = vel - Vector3.new(0, Settings.FlySpeed, 0) end
                bv.Velocity = vel; bg.CFrame = Camera.CFrame
            end)
            showNotification("Fly", "ON", true)
        end
    else
        local char = LocalPlayer.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
            if root then
                local bv = root:FindFirstChild("FlyBV"); local bg = root:FindFirstChild("FlyBG")
                if bv then bv:Destroy() end; if bg then bg:Destroy() end
            end
        end
        showNotification("Fly", "OFF", false)
    end
end

function ToggleGodmode(s)
    Settings.Godmode = s
    if Connections.Godmode then Connections.Godmode:Disconnect() end
    if s then
        Connections.Godmode = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.MaxHealth = math.huge; hum.Health = math.huge end
            end
        end)
        showNotification("Godmode", "ON", true)
    else
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.MaxHealth = 100; hum.Health = 100 end
        end
        showNotification("Godmode", "OFF", false)
    end
end

function ToggleNoclip(s)
    Settings.Noclip = s
    if Connections.Noclip then Connections.Noclip:Disconnect() end
    if s then
        Connections.Noclip = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                end
            end
        end)
        showNotification("Noclip", "ON", true)
    else
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
        showNotification("Noclip", "OFF", false)
    end
end

function ToggleAutoAim(s)
    Settings.AutoAim = s
    if Connections.Aim then Connections.Aim:Disconnect() end
    if s then
        Connections.Aim = RunService.RenderStepped:Connect(function()
            local tgt = GetClosestPlayer(500)
            if tgt and tgt.Character then
                local r = tgt.Character:FindFirstChild("HumanoidRootPart")
                if r then Camera.CFrame = CFrame.new(Camera.CFrame.Position, r.Position) end
            end
        end)
        showNotification("Auto Aim", "ON", true)
    else showNotification("Auto Aim", "OFF", false) end
end

function ToggleHitbox(s)
    if Connections.Hitbox then Connections.Hitbox:Disconnect() end
    if s then
        Connections.Hitbox = RunService.Heartbeat:Connect(function()
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                tool.Handle.Size = Vector3.new(5,5,5); tool.Handle.Transparency = 0.5
            end
        end)
        showNotification("Hitbox", "ON", true)
    end
end

function ToggleAutoClicker(s)
    Settings.AutoClicker = s
    if Connections.AC then task.cancel(Connections.AC) end
    if s then
        Connections.AC = task.spawn(function()
            while Settings.AutoClicker do
                pcall(function()
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end)
                task.wait(0.05)
            end
        end)
        showNotification("Auto Clicker", "ON", true)
    else showNotification("Auto Clicker", "OFF", false) end
end

function ToggleFastAttack(s)
    Settings.FastAttack = s
    if Connections.FA then Connections.FA:Disconnect() end
    if s then
        Connections.FA = RunService.Heartbeat:Connect(function()
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                local cd = tool:FindFirstChild("Cooldown") or tool:FindFirstChild("AttackCooldown")
                if cd then pcall(function() cd.Value = 0 end) end
            end
        end)
        showNotification("Fast Attack", "ON", true)
    else showNotification("Fast Attack", "OFF", false) end
end

function ToggleAutoAbility(s)
    Settings.AutoAbility = s
    if Connections.AA then task.cancel(Connections.AA) end
    if s then
        Connections.AA = task.spawn(function()
            while Settings.AutoAbility do
                pcall(function()
                    local vim = game:GetService("VirtualInputManager")
                    if vim then
                        vim:SendKeyEvent(true, "R", false, game)
                        task.wait(0.05)
                        vim:SendKeyEvent(false, "R", false, game)
                    end
                end)
                task.wait(0.3)
            end
        end)
        showNotification("Auto Ability", "ON", true)
    else showNotification("Auto Ability", "OFF", false) end
end

function ToggleAntiSlap(s)
    Settings.AntiSlap = s
    if Connections.AS then Connections.AS:Disconnect() end
    if s then
        Connections.AS = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.PlatformStand then
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.AssemblyLinearVelocity.Magnitude > 150 then
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
            end
        end)
        showNotification("Anti-Slap", "ON", true)
    else showNotification("Anti-Slap", "OFF", false) end
end

function ToggleAntiTeleport(s)
    Settings.AntiTeleport = s
    if Connections.ATP then Connections.ATP:Disconnect() end
    if s then
        Connections.ATP = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Position.Y < -50 then hrp.CFrame = CFrame.new(Settings.SafePos) end
        end)
        showNotification("Anti TP", "ON", true)
    else showNotification("Anti TP", "OFF", false) end
end

function ToggleRainbow(s)
    Settings.RainbowAura = s
    if Connections.RB then task.cancel(Connections.RB) end
    if s then
        Connections.RB = task.spawn(function()
            local h = 0
            while Settings.RainbowAura do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        h = (h + 0.02) % 1
                        local c = Color3.fromHSV(h, 1, 1)
                        for _, p in ipairs(char:GetDescendants()) do
                            if p:IsA("BasePart") then p.Color = c end
                        end
                    end
                end)
                task.wait(0.05)
            end
        end)
        showNotification("Rainbow", "ON", true)
    else showNotification("Rainbow", "OFF", false) end
end

function SetCharSize(size)
    Settings.CharSize = size
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, n in ipairs({"BodyHeightScale","BodyWidthScale","BodyDepthScale","HeadScale"}) do
            local v = hum:FindFirstChild(n) or Instance.new("NumberValue", hum)
            v.Name = n; v.Value = size
        end
    end
end

-- ============================================================
-- 🛡️ ANTIS
-- ============================================================
function ToggleAntiVoid(s)
    Settings.AntiVoid = s
    if Connections.AV then Connections.AV:Disconnect() end
    if s then
        Connections.AV = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Position.Y < -50 then pcall(function() hrp.CFrame = CFrame.new(Settings.SafePos) end) end
        end)
        showNotification("Anti Void", "ON", true)
    else showNotification("Anti Void", "OFF", false) end
end

function ToggleAntiFling(s)
    Settings.AntiFling = s
    if Connections.AFL then Connections.AFL:Disconnect() end
    if s then
        Connections.AFL = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.AssemblyLinearVelocity.Magnitude > 200 then hrp.AssemblyLinearVelocity = Vector3.zero end
        end)
        showNotification("Anti Fling", "ON", true)
    else showNotification("Anti Fling", "OFF", false) end
end

function ToggleAntiRagdoll(s)
    Settings.AntiRagdoll = s
    if Connections.AR then Connections.AR:Disconnect() end
    if s then
        Connections.AR = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and (hum.PlatformStand or hum:GetState() == Enum.HumanoidStateType.Physics) then
                hum.PlatformStand = false; hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
        showNotification("Anti Ragdoll", "ON", true)
    else showNotification("Anti Ragdoll", "OFF", false) end
end

function ToggleAntiKnockback(s)
    Settings.AntiKnockback = s
    if Connections.AKB then Connections.AKB:Disconnect() end
    if s then
        Connections.AKB = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local v = hrp.AssemblyLinearVelocity
                if Vector3.new(v.X, 0, v.Z).Magnitude > 100 then hrp.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0) end
            end
        end)
        showNotification("Anti KB", "ON", true)
    else showNotification("Anti KB", "OFF", false) end
end

function ToggleAntiHoney(s)
    Settings.AntiHoney = s
    if Connections.AH then Connections.AH:Disconnect() end
    if s then
        Connections.AH = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed < 16 and hum.WalkSpeed > 0 then hum.WalkSpeed = 16 end
        end)
        showNotification("Anti Honey", "ON", true)
    else showNotification("Anti Honey", "OFF", false) end
end

function ToggleAntiIce(s)
    Settings.AntiIce = s
    if Connections.AI then Connections.AI:Disconnect() end
    if s then
        Connections.AI = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed < 16 and hum.WalkSpeed > 0 then hum.WalkSpeed = 16 end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Anchored then hrp.Anchored = false end
        end)
        showNotification("Anti Ice", "ON", true)
    else showNotification("Anti Ice", "OFF", false) end
end

function ToggleAntiAFK(s)
    Settings.AntiAFK = s
    if Connections.AAFK then task.cancel(Connections.AAFK) end
    if s then
        Connections.AAFK = task.spawn(function()
            while Settings.AntiAFK do
                pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
                task.wait(60)
            end
        end)
        showNotification("Anti AFK", "ON", true)
    else showNotification("Anti AFK", "OFF", false) end
end

function ToggleAutoRejoin(s)
    Settings.AutoRejoin = s
    if s then
        pcall(function()
            LocalPlayer.OnTeleport:Connect(function(st)
                if st == Enum.TeleportState.Started and Settings.AutoRejoin then
                    task.wait(3); TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end
            end)
        end)
        showNotification("Auto Rejoin", "ON", true)
    else showNotification("Auto Rejoin", "OFF", false) end
end

-- ============================================================
-- 🧠 SMART AI AUTO PLAY V3
-- ============================================================
local AI = {
    Running = false, Thread = nil, State = "SCAN",
    Memory = {}, Target = nil, TargetPrediction = Vector3.new(0,0,0),
    LastAbilityTime = 0, LastJumpTime = 0, LastDodgeTime = 0,
    LastPos = Vector3.new(0,0,0), StuckCounter = 0, DodgeDir = 1,
    TotalKills = 0
}

local function UpdateMemory(plr, event)
    local n = plr.Name
    if not AI.Memory[n] then
        AI.Memory[n] = {kills=0, deaths=0, hits_taken=0, threat=0, last_seen=tick()}
    end
    local m = AI.Memory[n]
    if event == "kill" then m.kills = m.kills + 1
    elseif event == "death" then m.deaths = m.deaths + 1
    elseif event == "hit_taken" then m.hits_taken = m.hits_taken + 1
    end
    m.last_seen = tick()
    m.threat = (m.kills * 20) - (m.deaths * 10) + (m.hits_taken * 2)
    if m.threat < 0 then m.threat = 0 end
end

local function PredictPosition(plr, t)
    t = t or 0.3
    if not plr.Character then return nil end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    return hrp.Position + (hrp.AssemblyLinearVelocity * t)
end

local function GetBestTarget()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local candidates = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 then
                local d = (myRoot.Position - r.Position).Magnitude
                if d <= Settings.AutoPlayRange then
                    local _, danger = GetPlayerGlove(p)
                    local mem = AI.Memory[p.Name] or {threat=0}
                    local score = 100 - (d * 0.8) + ((1 - h.Health/h.MaxHealth) * 60) + (mem.threat or 0)
                    if danger == "EXTREME" then score = score + 60
                    elseif danger == "HIGH" then score = score + 35
                    elseif danger == "SAFE" then score = score + 25 end
                    if r.CFrame.LookVector:Dot((myRoot.Position - r.Position).Unit) > 0.5 then score = score + 30 end
                    table.insert(candidates, {player=p, score=score})
                end
            end
        end
    end
    if #candidates == 0 then return nil end
    table.sort(candidates, function(a,b) return a.score > b.score end)
    return candidates[1].player
end

local function ShouldRetreat(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if hum.Health / hum.MaxHealth < 0.3 then return true end
    return false
end

local function ExecuteAbility()
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        if vim then
            vim:SendKeyEvent(true, "R", false, game)
            task.wait(0.05)
            vim:SendKeyEvent(false, "R", false, game)
        end
    end)
    AI.LastAbilityTime = tick()
end

local function DodgeJump()
    if tick() - AI.LastJumpTime < 1.2 then return end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping); AI.LastJumpTime = tick() end
    end
end

function ToggleAutoPlay(state)
    Settings.AutoPlay = state
    AI.Running = state
    if AI.Thread then pcall(function() task.cancel(AI.Thread) end); AI.Thread = nil end
    if not state then
        showNotification("AI", "OFF", false)
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum:Move(Vector3.zero, false) end
            end
        end)
        return
    end
    showNotification("Smart AI", "🤖 ON", true)
    AI.Thread = task.spawn(function()
        task.wait(0.5)
        local scanT, flipT = 0, 0
        while AI.Running do
            task.wait(0.05)
            scanT = scanT + 0.05
            flipT = flipT + 0.05
            local char = LocalPlayer.Character
            if not char then continue end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local myRoot = char:FindFirstChild("HumanoidRootPart")
            if not hum or not myRoot then continue end
            hum.WalkSpeed = Settings.AutoPlaySpeed
            if flipT >= 1.5 then flipT = 0; AI.DodgeDir = AI.DodgeDir * -1 end

            local retreat = ShouldRetreat(char)
            if retreat then
                AI.State = "RETREAT"
                local tgt = GetClosestPlayer(50)
                if tgt and tgt.Character then
                    local tr = tgt.Character:FindFirstChild("HumanoidRootPart")
                    if tr then
                        local away = (myRoot.Position - tr.Position).Unit
                        hum:Move(Vector3.new(away.X, 0, away.Z), false)
                    end
                end
            else
                if scanT >= 1.2 then
                    scanT = 0
                    AI.Target = GetBestTarget()
                end
                local target = AI.Target
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    AI.State = "ATTACK"
                    local tr = target.Character:FindFirstChild("HumanoidRootPart")
                    local dist = (myRoot.Position - tr.Position).Magnitude
                    local dir = (tr.Position - myRoot.Position).Unit
                    local flat = Vector3.new(dir.X, 0, dir.Z)

                    if dist > Settings.Range * 0.7 then
                        hum:Move(flat, false)
                        if (myRoot.Position - AI.LastPos).Magnitude < 0.3 then
                            AI.StuckCounter = AI.StuckCounter + 1
                            if AI.StuckCounter > 8 then DodgeJump(); AI.StuckCounter = 0 end
                        else AI.StuckCounter = 0 end
                        AI.LastPos = myRoot.Position
                    else
                        local perp = Vector3.new(-flat.Z, 0, flat.X) * AI.DodgeDir
                        hum:Move(perp * 0.6 + flat * 0.3, false)
                        if tick() - AI.LastAbilityTime > 3 and dist < 20 then ExecuteAbility() end
                    end
                else
                    AI.State = "SCAN"
                    local ang = (tick() * 2) % (math.pi * 2)
                    hum:Move(Vector3.new(math.cos(ang), 0, math.sin(ang)), false)
                end
            end

            -- Death check
            for name, mem in pairs(AI.Memory) do
                local p = Players:FindFirstChild(name)
                if p and p.Character then
                    local h = p.Character:FindFirstChildOfClass("Humanoid")
                    if h and h.Health <= 0 and not mem._cd then
                        mem.deaths = mem.deaths + 1; mem._cd = true
                        AI.TotalKills = AI.TotalKills + 1
                    elseif h and h.Health > 0 then mem._cd = false end
                end
            end
        end
    end)
end

-- ============================================================
-- 🥊 MAIN AURA LOOP
-- ============================================================
local lastHit, hits, sec = 0, 0, math.floor(tick())
if Connections.Aura then Connections.Aura:Disconnect() end
Connections.Aura = RunService.Stepped:Connect(function()
    if not Settings.AuraEnabled then return end
    if not CapturedRemote then return end
    local char = LocalPlayer.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local cS = math.floor(tick()); if cS ~= sec then sec = cS; hits = 0 end
    if hits >= Settings.AuraMaxHits then return end
    if tick() - lastHit < (1/Settings.AuraMaxHits) then return end
    local closest, dist = GetClosestPlayer(Settings.Range)
    if closest and closest.Character then
        local tp = GetTargetPart(closest.Character)
        if tp then
            pcall(function()
                if RemoteFormat == "Table" then
                    CapturedRemote:FireServer({["victim"]=tp, ["attacker"]=LocalPlayer})
                else
                    CapturedRemote:FireServer(tp)
                end
                hits = hits + 1; lastHit = tick(); HitCount = HitCount + 1; SlapCount = SlapCount + 1
            end)
        end
    end
end)

-- ============================================================
-- 🎨 MAIN GUI
-- ============================================================
function LoadMainGUI()
    local ok, err = pcall(function()
        local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
        local Window = WindUI:CreateWindow({
            Title = "Slap Aura | V63 ULTIMATE",
            Icon = "shield", Author = "Majed",
            Folder = "SlapAuraV63", Size = UDim2.fromOffset(650, 550),
            Transparent = true, Theme = "Dark"
        })

        -- Combat
        local C = Window:Tab({ Title = "Combat", Icon = "crosshair" })
        C:Button({Title="🔄 Refresh Glove", Callback=function() CapturedRemote=nil; RemoteFormat="None"; showNotification("System","Reset",true) end})
        C:Toggle({Title="⚔️ Auto Slap", Value=true, Callback=function(s) Settings.AuraEnabled=s; if s and not CapturedRemote then showNotification("Aura","Punch once",false) end end})
        C:Slider({Title="Range", Value={Min=5,Max=50,Default=15}, Callback=function(v) Settings.Range=v end})
        C:Slider({Title="Hits/Sec", Value={Min=1,Max=20,Default=5}, Callback=function(v) Settings.AuraMaxHits=v end})
        C:Dropdown({Title="Hit Part", Values={"Any","Head","HumanoidRootPart"}, Default="Any", Callback=function(o) Settings.HitPart=o end})
        C:Toggle({Title="🎯 Auto Aim", Value=false, Callback=ToggleAutoAim})
        C:Toggle({Title="🎯 Silent Aim", Value=false, Callback=ToggleSilentAim})
        C:Toggle({Title="📦 Hitbox", Value=false, Callback=ToggleHitbox})
        C:Toggle({Title="🛡️ Godmode", Value=false, Callback=ToggleGodmode})
        C:Toggle({Title="⚡ Auto Ability", Value=false, Callback=ToggleAutoAbility})
        C:Toggle({Title="🚫 Anti-Slap", Value=false, Callback=ToggleAntiSlap})
        C:Toggle({Title="🖱️ Auto Clicker", Value=false, Callback=ToggleAutoClicker})
        C:Toggle({Title="⚡ Fast Attack", Value=false, Callback=ToggleFastAttack})

        -- Movement
        local M = Window:Tab({ Title = "Movement", Icon = "wind" })
        M:Toggle({Title="💨 Speed", Value=false, Callback=ToggleSpeed})
        M:Slider({Title="Speed", Value={Min=16,Max=100,Default=35}, Callback=function(v) Settings.PremiumSpeed=v end})
        M:Toggle({Title="🦘 Jump Boost", Value=false, Callback=ToggleJump})
        M:Slider({Title="Jump Power", Value={Min=50,Max=500,Default=100}, Callback=function(v) Settings.JumpPower=v end})
        M:Toggle({Title="♾️ Infinite Jump", Value=false, Callback=ToggleInfiniteJump})
        M:Toggle({Title="🕊️ Fly", Value=false, Callback=ToggleFly})
        M:Slider({Title="Fly Speed", Value={Min=20,Max=200,Default=50}, Callback=function(v) Settings.FlySpeed=v end})
        M:Toggle({Title="👻 Noclip", Value=false, Callback=ToggleNoclip})
        M:Toggle({Title="🚫 Anti Teleport", Value=false, Callback=ToggleAntiTeleport})

        -- Visuals
        local V = Window:Tab({ Title = "Visuals", Icon = "eye" })
        V:Toggle({Title="👁️ Player ESP", Value=false, Callback=ToggleESP})
        V:Toggle({Title="📦 ESP Box", Value=false, Callback=function(s) Settings.ESPBox=s end})
        V:Toggle({Title="📏 ESP Tracer", Value=false, Callback=function(s) Settings.ESPTracer=s end})
        V:Toggle({Title="🌈 Rainbow Aura", Value=false, Callback=ToggleRainbow})
        V:Slider({Title="Char Size", Value={Min=0.5,Max=3,Default=1}, Callback=SetCharSize})

        -- Anti
        local A = Window:Tab({ Title = "Anti", Icon = "shield" })
        A:Toggle({Title="Anti Void", Value=false, Callback=ToggleAntiVoid})
        A:Toggle({Title="Anti Fling", Value=false, Callback=ToggleAntiFling})
        A:Toggle({Title="Anti Ragdoll", Value=false, Callback=ToggleAntiRagdoll})
        A:Toggle({Title="Anti Knockback", Value=false, Callback=ToggleAntiKnockback})
        A:Toggle({Title="🍯 Anti Honey", Value=false, Callback=ToggleAntiHoney})
        A:Toggle({Title="🧊 Anti Ice", Value=false, Callback=ToggleAntiIce})
        A:Toggle({Title="Anti AFK", Value=false, Callback=ToggleAntiAFK})
        A:Toggle({Title="Auto Rejoin", Value=false, Callback=ToggleAutoRejoin})

        -- Smart AI
        local B = Window:Tab({ Title = "Smart AI", Icon = "brain" })
        B:Section({ Title = "🧠 Smart AI V3" })
        B:Toggle({Title="🧠 Enable Smart AI", Value=false, Callback=ToggleAutoPlay})
        B:Slider({Title="AI Speed", Value={Min=16,Max=100,Default=65}, Callback=function(v) Settings.AutoPlaySpeed=v end})
        B:Slider({Title="Scan Range", Value={Min=50,Max=500,Default=250}, Callback=function(v) Settings.AutoPlayRange=v end})
        local AILbl = B:Paragraph({Title="AI Status", Desc="State: SCAN | Kills: 0"})
        task.spawn(function()
            while true do
                task.wait(0.5)
                if Settings.AutoPlay then
                    pcall(function()
                        B:SetDesc("AI Status", "State: "..AI.State.." | Kills: "..AI.TotalKills)
                    end)
                end
            end
        end)

        -- Teleport
        local T = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
        T:Section({ Title = "🎯 Player TP" })
        local pBtns = {}
        local function RefreshPlayers()
            for _, b in ipairs(pBtns) do pcall(function() b:Destroy() end) end
            pBtns = {}
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local b = T:Button({Title="👤 "..plr.DisplayName, Callback=function()
                        local myR = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local tR = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                        if myR and tR then myR.CFrame = tR.CFrame + Vector3.new(0,3,0); showNotification("TP", plr.DisplayName, true)
                        else showNotification("TP","Unavailable",false) end
                    end})
                    table.insert(pBtns, b)
                end
            end
        end
        T:Button({Title="🔄 Refresh", Callback=RefreshPlayers})
        task.delay(2, RefreshPlayers)

        -- Servers
        local S = Window:Tab({ Title = "Servers", Icon = "server" })
        S:Section({ Title = "🌐 Server Finder" })
        local loaded = false
        local function LoadServers()
            if loaded then return end
            local key = _G.SlapAura_CurrentKey
            if not key then S:Paragraph({Title="No Key", Desc="Login first"}) return end
            local url = "https://muhammadmajed54.val.run/api/finder/servers?key=" .. key
            local ok2, res = pcall(function() return game:HttpGet(url) end)
            if ok2 and res then
                local data = HttpService:JSONDecode(res)
                if data.success and data.servers and #data.servers > 0 then
                    for i, sv in ipairs(data.servers) do
                        if i > 15 then break end
                        local ic = "🟢"
                        if sv.players >= 10 then ic="🟡" end
                        if sv.players >= 15 then ic="🟠" end
                        if sv.players >= 20 then ic="🔴" end
                        S:Button({Title=ic.." "..sv.jobId:sub(1,8).." | "..sv.players.."/"..sv.maxPlayers, Callback=function()
                            showNotification("Finder","Connecting...",true)
                            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, sv.jobId, LocalPlayer) end)
                        end})
                    end
                    loaded = true
                else S:Paragraph({Title="No Servers", Desc="Try later"}) end
            end
        end
        task.delay(3, LoadServers)

        -- Settings
        local St = Window:Tab({ Title = "Settings", Icon = "settings" })
        St:Button({Title="🔔 Test", Callback=function() showNotification("Test","OK",true) end})
        St:Button({Title="📍 Set Safe Pos", Callback=function()
            local c = LocalPlayer.Character
            if c and c:FindFirstChild("HumanoidRootPart") then
                Settings.SafePos = c.HumanoidRootPart.Position
                showNotification("Safe Pos","Updated",true)
            end
        end})
        St:Button({Title="📋 Copy JobId", Callback=function()
            if setclipboard then pcall(setclipboard, game.JobId) end
            showNotification("Server","Copied",true)
        end})
        St:Button({Title="❌ Unload", Callback=function()
            for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
            for _, c in pairs(espConns) do pcall(function() c:Disconnect() end) end
            _G.SlapAuraAlreadyRunning = false
            Window:Destroy()
        end})
    end)
    if not ok then warn("[Slap Aura] GUI Error: "..tostring(err)) end
end

LoadMainGUI()

-- ============================================================
-- 🔍 FINDER SCANNER
-- ============================================================
task.spawn(function()
    local URL = "https://muhammadmajed54.val.run/finder/ingest"
    local KEY = "slap_aura_finder_secret_2026_xyz"
    local function Send()
        pcall(function()
            local gloves, rare = {}, {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p and p.Character then
                    local g = nil
                    local tool = p.Character:FindFirstChildOfClass("Tool")
                    if tool then g = tool.Name end
                    if g then
                        local d = GloveDanger[string.lower(g)] or "SAFE"
                        table.insert(gloves, {name=g, danger=d})
                        if d == "EXTREME" or d == "HIGH" then table.insert(rare, {name=g, danger=d}) end
                    end
                end
            end
            local body = HttpService:JSONEncode({
                apiKey=KEY, jobId=game.JobId, placeId=game.PlaceId,
                players=#Players:GetPlayers(), maxPlayers=Players.MaxPlayers,
                gloves=gloves, rareGloves=rare, timestamp=os.time()*1000
            })
            local req = (syn and syn.request) or (http and http.request) or http_request or request
            if req then req({Url=URL, Method="POST", Headers={["Content-Type"]="application/json"}, Body=body})
            else HttpService:PostAsync(URL, body, Enum.HttpContentType.ApplicationJson) end
        end)
    end
    task.wait(15)
    while true do Send(); task.wait(20) end
end)

print("✅ Slap Aura V63 ULTIMATE Loaded")