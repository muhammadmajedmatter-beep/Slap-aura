-- ============================================================
-- 👑 SLAP BATTLES V63 | AUTO-GLOVE DETECTION | By Majed
-- Includes: Auto-Detect Gloves, Anti-Ban Shield, Instant Capture,
-- Smart Farms, ESP, Silent Aim, UI Images
-- ============================================================

if _G.SlapV63Running then warn("[V63] Already running"); return end
_G.SlapV63Running = true

-- ═══ Services ═══
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ═══ Config & Images ═══
local Config = {
    HubName = "Slap Battles",
    Version = "V63 Auto-Detect",
    Author = "Majed",
    LogoImage = "rbxassetid://137832913582842",
    BackgroundImage = "rbxassetid://137832913582842",
    HandImage = "rbxassetid://89325943414546",
    DiscordInvite = "https://discord.gg/yourinvite",
}

-- ═══ Loading Screen ═══
local LG = Instance.new("ScreenGui")
LG.Name = "V63Load"; LG.DisplayOrder = 999999; LG.IgnoreGuiInset = true
pcall(function() LG.Parent = game:GetService("CoreGui") end)
if not LG.Parent then LG.Parent = PlayerGui end

local bg = Instance.new("Frame", LG)
bg.Size = UDim2.fromScale(1,1); bg.BackgroundColor3 = Color3.fromRGB(10,10,15); bg.BorderSizePixel = 0

local lbl = Instance.new("TextLabel", bg)
lbl.Size = UDim2.new(1,0,0,60); lbl.Position = UDim2.fromScale(0,0.4); lbl.BackgroundTransparency = 1
lbl.Text = "👑 SLAP BATTLES V63"; lbl.TextColor3 = Color3.fromRGB(255,140,0)
lbl.Font = Enum.Font.GothamBlack; lbl.TextSize = 32

local st = Instance.new("TextLabel", bg)
st.Size = UDim2.new(1,0,0,30); st.Position = UDim2.new(0,0,0.5,10); st.BackgroundTransparency = 1
st.Text = "Loading Auto-Detection Modules..."; st.TextColor3 = Color3.fromRGB(180,180,195)
st.Font = Enum.Font.Gotham; st.TextSize = 14

for _, s in ipairs({"Injecting Ghost Protocol...", "Loading Leaderstats Reader...", "Building Smart Classifier...", "Ready!"}) do
    st.Text = s; task.wait(0.35)
end
TweenService:Create(bg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
TweenService:Create(lbl, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
TweenService:Create(st, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
task.wait(0.5); LG:Destroy()

-- ═══ Settings ═══
local Settings = {
    AuraEnabled = true, Range = 15, AuraMaxHits = 5, HitPart = "HumanoidRootPart",
    IgnoreFriends = true, PremSpeed = 35, FlySpeed = 60, JumpPower = 50,
    GodMode = false, InvisibleGod = false, Noclip = false, InfiniteJump = false,
    ESP = false, AutoAim = false, Hitbox = false, ZeroG = false,
    AntiVoid = false, AntiFling = false, AntiRagdoll = false, AntiKnockback = false,
    AntiHoney = false, AntiIce = false, AntiMail = false, AntiMR = false,
    AntiMitten = false, AntiSquid = false, AntiZaHando = false, AntiPortal = false,
    AntiBob = false, AntiCubeOfDeath = false, AntiMegarock = false, AntiTaser = false,
    AntiAFK = false, AutoRejoin = false, SlappleFarm = false, GloveFarm = false,
    AutoClick = false, AntiBan = true, SafePos = Vector3.new(0,100,0),
}
local Connections = {}
local HitCount, LastHit, HitsSec, CurSec = 0, 0, 0, math.floor(tick())
local isFlying = false
local CapturedRemote, RemoteFormat = nil, "None"
local Friends = {}

-- ═══ Notifications ═══
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "V63Notifs"; NotifGui.ResetOnSpawn = false; NotifGui.DisplayOrder = 99999
pcall(function() NotifGui.Parent = game:GetService("CoreGui") end)
if not NotifGui.Parent then NotifGui.Parent = PlayerGui end
local NotifStack = Instance.new("Frame", NotifGui)
NotifStack.Size = UDim2.new(0,300,0,400); NotifStack.Position = UDim2.new(1,-310,0,20)
NotifStack.BackgroundTransparency = 1
local NotifLayout = Instance.new("UIListLayout", NotifStack)
NotifLayout.Padding = UDim.new(0,8); NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local function Notify(title, text, ok)
    local f = Instance.new("Frame", NotifStack)
    f.Size = UDim2.fromOffset(300,60); f.BackgroundColor3 = Color3.fromRGB(20,20,25); f.BorderSizePixel = 0
    local c = Instance.new("UICorner", f); c.CornerRadius = UDim.new(0,8)
    local s = Instance.new("UIStroke", f); s.Color = ok and Color3.fromRGB(50,220,130) or Color3.fromRGB(255,80,80); s.Thickness = 1.5
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1,-20,0,20); t.Position = UDim2.fromOffset(10,8)
    t.BackgroundTransparency = 1; t.Text = title; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.GothamBold
    t.TextSize = 13; t.TextXAlignment = Enum.TextXAlignment.Left
    local d = Instance.new("TextLabel", f); d.Size = UDim2.new(1,-20,0,28); d.Position = UDim2.fromOffset(10,28)
    d.BackgroundTransparency = 1; d.Text = text; d.TextColor3 = Color3.fromRGB(160,160,170); d.Font = Enum.Font.Gotham
    d.TextSize = 11; d.TextWrapped = true; d.TextXAlignment = Enum.TextXAlignment.Left
    task.delay(3, function()
        TweenService:Create(f, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(t, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(d, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.35); f:Destroy()
    end)
end

-- ═══ ANTI-BAN SHIELD ═══
local BanShield = { Enabled = true, BlockedRemotes = {}, DisabledScripts = 0, HooksActive = false }

local function HookKickProtection()
    pcall(function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if checkcaller() then return oldNamecall(self, ...) end
            local method = getnamecallmethod()
            local name = string.lower(self.Name)
            if method == "Kick" and self == LocalPlayer then
                warn("[Shield] 🛑 Kick attempt BLOCKED")
                return
            end
            if method == "FireServer" then
                local blockedKeywords = {"ban", "kick", "anticheat", "detect", "report", "flag", "speedcheck", "teleportcheck", "admin", "moderate", "permanent", "exile", "terminate"}
                for _, kw in ipairs(blockedKeywords) do
                    if string.find(name, kw) then
                        warn("[Shield] 🛑 Blocked remote:", self:GetFullName())
                        BanShield.BlockedRemotes[self:GetFullName()] = true
                        return
                    end
                end
            end
            return oldNamecall(self, ...)
        end))
        BanShield.HooksActive = true
    end)
end

local function DisableLocalAntiCheat()
    local count = 0
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("Script") then
            local name = string.lower(obj.Name)
            for _, kw in ipairs({"anti", "cheat", "detect", "guard", "security", "check", "monitor"}) do
                if string.find(name, kw) then
                    pcall(function() obj.Disabled = true; count = count + 1 end)
                    break
                end
            end
        end
    end
    BanShield.DisabledScripts = count
end

local function TamperAntiCheatSettings()
    pcall(function()
        for _, v in ipairs(getgc(true)) do
            if type(v) == "table" then
                local keys = {"kickReason", "maxSpeed", "maxJumpPower", "canSeat", "canFly", "allowRootAnchor", "canNoclip", "allowGyro", "walkSpeedLimit", "jumpPowerLimit"}
                local isAC = false
                for _, k in ipairs(keys) do if rawget(v, k) ~= nil then isAC = true break end end
                if isAC then
                    for _, k in ipairs(keys) do pcall(function() v[k] = math.huge end) end
                end
            end
        end
    end)
end

local function ActivateShield()
    HookKickProtection()
    DisableLocalAntiCheat()
    TamperAntiCheatSettings()
    print("[Shield] ✅ Anti-Ban Shield Active | Scripts Disabled: "..BanShield.DisabledScripts)
end
ActivateShield()

-- ═══════════════════════════════════════════════════════════
-- 🧤 V63: AUTO GLOVE DETECTION (لا يحتاج تحديث يومي)
-- ═══════════════════════════════════════════════════════════
-- 1) يقرأ من leaderstats.Glove (الأدق)
-- 2) يرجع للأداة في الـ Character
-- 3) يصنف أي قفاز جديد تلقائياً عبر كلمات مفتاحية

local GloveDanger = {
    -- EXTREME (kill/instakill gloves)
    ["killstreak"]="EXTREME", ["god's hand"]="EXTREME", ["gods hand"]="EXTREME",
    ["error"]="EXTREME", ["reaper"]="EXTREME", ["thanos"]="EXTREME",
    ["overkill"]="EXTREME", ["megarock"]="EXTREME", ["berserk"]="EXTREME",
    ["detonator"]="EXTREME", ["bob"]="EXTREME", ["hallow jack"]="EXTREME",
    ["admin"]="EXTREME", ["moderator"]="EXTREME", ["god"]="EXTREME",
    -- HIGH (heavy hitters)
    ["mitten"]="HIGH", ["leash"]="HIGH", ["fish"]="HIGH", ["grab"]="HIGH",
    ["pull"]="HIGH", ["lure"]="HIGH", ["phase"]="HIGH", ["wormhole"]="HIGH",
    ["blackhole"]="HIGH", ["bomb"]="HIGH", ["home run"]="HIGH",
    ["jet"]="HIGH", ["baller"]="HIGH", ["za hando"]="HIGH", ["recycler"]="HIGH",
    ["sparky"]="HIGH", ["conductor"]="HIGH", ["tinkerer"]="HIGH", ["rhythm"]="HIGH",
    ["track"]="HIGH", ["rattlebones"]="HIGH",
    -- MEDIUM (annoying effects)
    ["ice"]="MEDIUM", ["snowball"]="MEDIUM", ["mr"]="MEDIUM", ["mail"]="MEDIUM",
    ["squid"]="MEDIUM", ["honey"]="MEDIUM", ["cloud"]="MEDIUM", ["kinetic"]="MEDIUM",
    ["slapple"]="MEDIUM", ["moon"]="MEDIUM",
}

-- كلمات مفتاحية لتصنيف أي قفاز جديد (حتى لو مش في الجدول)
local KeywordDanger = {
    EXTREME = {"kill","death","god","error","reaper","void","thanos","admin","mod","oblivion","apocalypse","supreme","eternal","infinity","universe","nuke","annihilat"},
    HIGH = {"bomb","explode","grab","pull","freeze","ice","fire","flame","burn","shock","taze","zap","blast","crush","smash","destroy","mega","ultra","hyper","berserk","rage"},
    MEDIUM = {"honey","mail","letter","squid","ink","mirror","mr","slow","sticky","poison","block","shield","cloud","wind","push","snow","leaf","moon"},
}

local function ClassifyDanger(name)
    if not name then return "NONE" end
    local lower = string.lower(name)
    -- 1) مباشر من الجدول
    if GloveDanger[lower] then return GloveDanger[lower] end
    -- 2) تصنيف تلقائي بالكلمات المفتاحية
    for danger, kws in pairs(KeywordDanger) do
        for _, kw in ipairs(kws) do
            if string.find(lower, kw) then return danger end
        end
    end
    return "SAFE"
end

-- الدالة الرئيسية: قراءة القفاز من مصادر متعددة
local function GetGloveName(player)
    if not player then return nil, "NONE" end
    -- المصدر 1: leaderstats (الأدق والأحدث فوراً)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local gloveVal = leaderstats:FindFirstChild("Glove")
        if gloveVal and gloveVal:IsA("StringValue") and gloveVal.Value ~= "" then
            return gloveVal.Value, ClassifyDanger(gloveVal.Value)
        end
    end
    -- المصدر 2: الأداة في الـ Character
    if player.Character then
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then
            return tool.Name, ClassifyDanger(tool.Name)
        end
    end
    return nil, "NONE"
end

print("[V63] ✅ Auto Glove Detection Loaded (leaderstats → Tool → Keyword classifier)")

-- ═══ INSTANT REMOTE CAPTURE ═══
local CaptureHUD

local function CreateCaptureHUD()
    local g = Instance.new("ScreenGui")
    g.Name = "V63CaptureHUD"; g.DisplayOrder = 99997; g.ResetOnSpawn = false
    pcall(function() g.Parent = game:GetService("CoreGui") end)
    if not g.Parent then g.Parent = PlayerGui end
    local f = Instance.new("Frame", g)
    f.Size = UDim2.fromOffset(340, 44); f.Position = UDim2.new(0, 20, 0, 20)
    f.BackgroundColor3 = Color3.fromRGB(15,15,20); f.BackgroundTransparency = 0.15; f.BorderSizePixel = 0
    local c = Instance.new("UICorner", f); c.CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", f); s.Color = Color3.fromRGB(255,140,0); s.Thickness = 2
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1,-10,1,0); t.Position = UDim2.new(0,5,0,0)
    t.BackgroundTransparency = 1; t.Text = "⏳ Hunting remote..."
    t.TextColor3 = Color3.fromRGB(255,255,255); t.Font = Enum.Font.GothamBold; t.TextSize = 13
    CaptureHUD = { gui = g, frame = f, text = t, stroke = s }
end
CreateCaptureHUD()

local function UpdateCaptureHUD(status, color)
    if not CaptureHUD then return end
    CaptureHUD.text.Text = status
    if color then CaptureHUD.stroke.Color = color end
end

local function ScanRemotes()
    local keywords = {"slap","hit","punch","attack","glove","melee","swing","combat","damage","ability","weapon"}
    local candidates, seen = {}, {}
    local function check(c)
        if not c then return end
        for _, v in ipairs(c:GetDescendants()) do
            if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and not seen[v] then
                seen[v] = true
                local nm = string.lower(v.Name); local score = 0
                for _, kw in ipairs(keywords) do
                    if string.find(nm, kw) then score = score + 10 end
                end
                if score > 0 then table.insert(candidates, {remote=v, score=score, name=v.Name}) end
            end
        end
    end
    check(game:GetService("ReplicatedStorage"))
    check(LocalPlayer:FindFirstChild("PlayerScripts"))
    check(LocalPlayer:FindFirstChild("Backpack"))
    if LocalPlayer.Character then check(LocalPlayer.Character) end
    table.sort(candidates, function(a,b) return a.score > b.score end)
    return candidates
end

local initialCandidates = ScanRemotes()
print("[V63] 🔍 Scanned "..#initialCandidates.." candidates on load")
for i = 1, math.min(5, #initialCandidates) do
    print(string.format("  [%d] %s (score: %d)", i, initialCandidates[i].name, initialCandidates[i].score))
end

local CaptureLocked = false
local function LockCapture(remote, fmt, source)
    if CaptureLocked then return end
    CapturedRemote = remote; RemoteFormat = fmt; CaptureLocked = true
    print("[V63] 🎯 CAPTURED via "..source..":", remote:GetFullName(), "| Format:", fmt)
    UpdateCaptureHUD("✅ CAPTURED: "..remote.Name, Color3.fromRGB(50,220,130))
    pcall(function() Notify("Capture", "✅ "..remote.Name, true) end)
end

pcall(function()
    local oldNC
    oldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        if checkcaller() then return oldNC(self, ...) end
        local m = getnamecallmethod()
        if m == "FireServer" then
            local nm = string.lower(self.Name)
            for _, b in ipairs({"ban","kick","anticheat","report","flag","detect"}) do
                if string.find(nm, b) then return end
            end
            if not CaptureLocked then
                local args = {...}
                if #args > 0 then
                    local a1 = args[1]
                    local isInst = typeof(a1) == "Instance" and (a1:IsA("BasePart") or a1:IsA("Model") or a1:IsA("Humanoid"))
                    local isTbl = type(a1) == "table" and (a1.victim or a1.target or a1.player or a1.humanoid or a1.plr)
                    if isInst or isTbl then
                        LockCapture(self, isInst and typeof(a1) or "table", "Namecall")
                    end
                end
            end
        elseif m == "Kick" and self == LocalPlayer then return end
        return oldNC(self, ...)
    end))
end)

local hookedTools = {}
local function HookTool(tool)
    if not tool or hookedTools[tool] then return end
    hookedTools[tool] = true
    tool.Activated:Connect(function()
        task.wait(0.005)
        if CaptureLocked then return end
        local cs = ScanRemotes()
        if #cs > 0 then LockCapture(cs[1].remote, "Instance", "ToolActivated") end
    end)
end
local function AttachChar(char)
    if not char then return end
    for _, c in ipairs(char:GetChildren()) do if c:IsA("Tool") then HookTool(c) end end
    char.ChildAdded:Connect(function(c) if c:IsA("Tool") then HookTool(c) end end)
end
local function AttachBP(bp)
    if not bp then return end
    for _, c in ipairs(bp:GetChildren()) do if c:IsA("Tool") then HookTool(c) end end
    bp.ChildAdded:Connect(function(c) if c:IsA("Tool") then HookTool(c) end end)
end
LocalPlayer.CharacterAdded:Connect(AttachChar)
LocalPlayer.ChildAdded:Connect(function(c) if c.Name == "Backpack" then AttachBP(c) end end)
if LocalPlayer.Character then AttachChar(LocalPlayer.Character) end
if LocalPlayer:FindFirstChild("Backpack") then AttachBP(LocalPlayer:FindFirstChild("Backpack")) end

task.spawn(function()
    while _G.SlapV63Running do
        task.wait(2)
        if not CaptureLocked and #initialCandidates > 0 then
            UpdateCaptureHUD("⏳ Punch once → top: "..initialCandidates[1].name, Color3.fromRGB(255,200,50))
        end
    end
end)

task.delay(8, function()
    if not CaptureLocked then
        UpdateCaptureHUD("⚠️ PUNCH ONCE with your glove NOW!", Color3.fromRGB(255,80,80))
        pcall(function() Notify("Capture","⚠️ اضرب مرة واحدة بالقفاز!",false) end)
    end
end)

-- ═══ Ghost Protocol ═══
pcall(function()
    local mt = getrawmetatable(game); local oldIdx = mt.__index
    setreadonly(mt, false)
    mt.__index = newcclosure(function(t, k)
        if checkcaller() then return oldIdx(t,k) end
        if (k=="WalkSpeed" or k=="JumpPower") and t:IsA("Humanoid") and t.Parent==LocalPlayer.Character then
            return k=="WalkSpeed" and 16 or 50
        end
        return oldIdx(t,k)
    end)
    setreadonly(mt, true)
end)

-- ═══ Helpers ═══
local function GetChar(p)
    if p and p.Character then
        local h = p.Character:FindFirstChildOfClass("Humanoid")
        local r = p.Character:FindFirstChild("HumanoidRootPart")
        if h and r and h.Health > 0 then return p.Character, h, r end
    end
    return nil
end
local function GetTargetPart(char)
    if not char then return nil end
    if Settings.HitPart == "Head" then return char:FindFirstChild("Head") end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
end
local function IsFriend(p)
    if not Settings.IgnoreFriends then return false end
    return Friends[p.UserId] or p:IsFriendsWith(LocalPlayer.UserId)
end

-- ═══ Movement ═══
local function ToggleSpeed(s)
    if Connections.Speed then Connections.Speed:Disconnect() end
    if s then
        Connections.Speed = RunService.Heartbeat:Connect(function()
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = Settings.PremSpeed end
        end)
    else
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16 end
    end
end
local function ToggleFly(s)
    isFlying = s
    if Connections.Fly then Connections.Fly:Disconnect() end
    local c = LocalPlayer.Character
    if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    local h = c:FindFirstChildOfClass("Humanoid")
    if s and r and h then
        h:ChangeState(Enum.HumanoidStateType.Physics)
        local bv = Instance.new("BodyVelocity", r); bv.Name="V63FlyBV"; bv.MaxForce=Vector3.new(1e6,1e6,1e6); bv.Velocity=Vector3.zero
        local bg2 = Instance.new("BodyGyro", r); bg2.Name="V63FlyBG"; bg2.MaxTorque=Vector3.new(1e6,1e6,1e6); bg2.P=9000; bg2.D=50
        Connections.Fly = RunService.RenderStepped:Connect(function()
            if not isFlying or not r or not h then return end
            local d = h.MoveDirection * Settings.FlySpeed
            local look = Camera.CFrame.LookVector
            if look.Y > 0.4 then d = d + Vector3.new(0, Settings.FlySpeed, 0)
            elseif look.Y < -0.4 then d = d - Vector3.new(0, Settings.FlySpeed, 0) end
            bv.Velocity = d; bg2.CFrame = Camera.CFrame
        end)
    else
        if r then local bv = r:FindFirstChild("V63FlyBV"); if bv then bv:Destroy() end
                   local bg2 = r:FindFirstChild("V63FlyBG"); if bg2 then bg2:Destroy() end end
        if h then h:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end
local function ToggleNoclip(s)
    if Connections.Noclip then Connections.Noclip:Disconnect() end
    if s then
        Connections.Noclip = RunService.Stepped:Connect(function()
            local c = LocalPlayer.Character
            if c then for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end end
        end)
    end
end
local function ToggleGodMode(s)
    if Connections.God then Connections.God:Disconnect() end
    if s then
        Connections.God = RunService.Heartbeat:Connect(function()
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h then h.MaxHealth = math.huge; h.Health = math.huge end
            if Settings.InvisibleGod and c then
                for _, p in ipairs(c:GetDescendants()) do
                    if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = 1 end
                end
            end
        end)
    end
end
local function ToggleInfiniteJump(s)
    if Connections.IJump then Connections.IJump:Disconnect() end
    if s then
        Connections.IJump = UserInputService.JumpRequest:Connect(function()
            local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end

-- ═══ Anti-* Engine ═══
local AntiKeywords = {
    AntiHoney = {"honey","slow","sticky"},
    AntiIce = {"ice","freeze","frozen","snow"},
    AntiMail = {"mail","letter","envelope"},
    AntiMR = {"mirror","reflection"},
    AntiMitten = {"mitten","glove","sock"},
    AntiSquid = {"squid","ink","octopus"},
    AntiZaHando = {"zahando","erase","void"},
    AntiPortal = {"portal","wormhole"},
    AntiBob = {"bob","explosion"},
    AntiCubeOfDeath = {"cube","deathcube","killcube"},
}
local function AntiEffectScan()
    for key, keywords in pairs(AntiKeywords) do
        if Settings[key] then
            local c = LocalPlayer.Character
            if c then
                for _, v in ipairs(c:GetDescendants()) do
                    local nm = string.lower(v.Name)
                    for _, kw in ipairs(keywords) do
                        if string.find(nm, kw) then
                            if v:IsA("Highlight") or v:IsA("BillboardGui") or v:IsA("ParticleEmitter")
                                or v:IsA("Sound") or v:IsA("ObjectValue") or v:IsA("Folder") then
                                pcall(function() v:Destroy() end)
                            end
                        end
                    end
                end
                local h = c:FindFirstChildOfClass("Humanoid")
                if h and h.WalkSpeed < 16 and h.WalkSpeed > 0 then h.WalkSpeed = 16 end
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.Anchored then hrp.Anchored = false end
            end
        end
    end
end
RunService.Heartbeat:Connect(AntiEffectScan)

local function ToggleAntiVoid(s)
    if Connections.AVoid then Connections.AVoid:Disconnect() end
    if s then
        Connections.AVoid = RunService.Heartbeat:Connect(function()
            local c = LocalPlayer.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Position.Y < -50 then
                pcall(function() hrp.CFrame = CFrame.new(Settings.SafePos) end)
            end
        end)
    end
end
local function ToggleAntiFling(s)
    if Connections.AFling then Connections.AFling:Disconnect() end
    if s then
        Connections.AFling = RunService.Heartbeat:Connect(function()
            local c = LocalPlayer.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.AssemblyLinearVelocity.Magnitude > 200 then
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end)
    end
end
local function ToggleAntiRagdoll(s)
    if Connections.ARag then Connections.ARag:Disconnect() end
    if s then
        Connections.ARag = RunService.Heartbeat:Connect(function()
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h and (h.PlatformStand or h:GetState() == Enum.HumanoidStateType.Physics) then
                h.PlatformStand = false; h:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    end
end
local function ToggleAntiKnockback(s)
    if Connections.AKB then Connections.AKB:Disconnect() end
    if s then
        Connections.AKB = RunService.Heartbeat:Connect(function()
            local c = LocalPlayer.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if hrp then
                local v = hrp.AssemblyLinearVelocity
                if Vector3.new(v.X,0,v.Z).Magnitude > 100 then hrp.AssemblyLinearVelocity = Vector3.new(0,v.Y,0) end
            end
        end)
    end
end
local function ToggleAntiMegarock(s)
    if Connections.AMega then Connections.AMega:Disconnect() end
    if s then
        Connections.AMega = RunService.Heartbeat:Connect(function()
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h and h.Health < h.MaxHealth * 0.3 then
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = CFrame.new(Settings.SafePos) end
            end
        end)
    end
end
local function ToggleAntiTaser(s)
    if Connections.ATaser then Connections.ATaser:Disconnect() end
    if s then
        Connections.ATaser = RunService.Heartbeat:Connect(function()
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h and h.PlatformStand then
                h.PlatformStand = false; h:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    end
end
local function ToggleAntiAFK(s)
    Settings.AntiAFK = s
    if Connections.AAFK then pcall(function() Connections.AAFK:Disconnect() end) end
    if s then
        Connections.AAFK = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end

-- ═══ FARMS ═══
local SmartFarm = { Enabled = false, Positions = {}, LastScan = 0 }
local function ScanForSlapples()
    local positions = {}
    local keywords = {"slapple","candy","corn"}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local nm = string.lower(obj.Name)
            for _, kw in ipairs(keywords) do
                if string.find(nm, kw) then
                    local pos
                    if obj:IsA("BasePart") then pos = obj.Position
                    elseif obj:IsA("Model") and obj.PrimaryPart then pos = obj.PrimaryPart.Position end
                    if pos then table.insert(positions, pos) end
                    break
                end
            end
        end
    end
    return positions
end
local function ToggleSmartFarm(s)
    SmartFarm.Enabled = s
    if Connections.SmartFarm then pcall(function() Connections.SmartFarm:Disconnect() end) end
    if s then
        Connections.SmartFarm = task.spawn(function()
            while SmartFarm.Enabled do
                if tick() - SmartFarm.LastScan > 3 then
                    SmartFarm.Positions = ScanForSlapples()
                    SmartFarm.LastScan = tick()
                    if #SmartFarm.Positions > 0 then
                        UpdateCaptureHUD("🌾 "..#SmartFarm.Positions.." slapples found", Color3.fromRGB(50,220,130))
                    end
                end
                local c = LocalPlayer.Character
                local hrp = c and c:FindFirstChild("HumanoidRootPart")
                if hrp and #SmartFarm.Positions > 0 then
                    local near, nd = nil, math.huge
                    for _, p in ipairs(SmartFarm.Positions) do
                        local d = (hrp.Position - p).Magnitude
                        if d < nd then nd = d; near = p end
                    end
                    if near then hrp.CFrame = CFrame.new(near + Vector3.new(0,3,0)) end
                end
                task.wait(1.2)
            end
        end)
        Notify("Smart Farm", "Auto-detecting slapples...", true)
    end
end

-- ═══ SILENT AIM ═══
local SilentAim = { Enabled = false, Range = 200, TargetPart = "Head" }
local function GetSATarget()
    local c = LocalPlayer.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local best, bd = nil, SilentAim.Range
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not IsFriend(p) and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 then
                local d = (root.Position - r.Position).Magnitude
                if d < bd then
                    bd = d
                    best = p.Character:FindFirstChild(SilentAim.TargetPart)
                        or p.Character:FindFirstChild("HumanoidRootPart")
                end
            end
        end
    end
    return best
end
local function ToggleSilentAim(s)
    SilentAim.Enabled = s
    if Connections.SAim then Connections.SAim:Disconnect() end
    if s then
        Connections.SAim = RunService.RenderStepped:Connect(function()
            if not SilentAim.Enabled then return end
            local target = GetSATarget()
            if target then
                pcall(function()
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                end)
            end
        end)
    end
end

-- ═══ AURA ═══
if Connections.Aura then Connections.Aura:Disconnect() end
Connections.Aura = RunService.Heartbeat:Connect(function()
    if not Settings.AuraEnabled or not CapturedRemote then return end
    local c = LocalPlayer.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local cs = math.floor(tick())
    if cs ~= CurSec then CurSec = cs; HitsSec = 0 end
    if HitsSec >= Settings.AuraMaxHits then return end
    if tick() - LastHit < (1/Settings.AuraMaxHits) then return end

    local closest, dist = nil, Settings.Range
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not IsFriend(p) and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 then
                local d = (root.Position-r.Position).Magnitude
                if d < dist then dist=d; closest=p end
            end
        end
    end
    if closest then
        local tp = GetTargetPart(closest.Character)
        if tp then
            pcall(function()
                if RemoteFormat == "table" then
                    CapturedRemote:FireServer({victim=tp, attacker=LocalPlayer})
                else
                    CapturedRemote:FireServer(tp)
                end
                HitsSec=HitsSec+1; LastHit=tick(); HitCount=HitCount+1
            end)
        end
    end
end)

-- ═══ ESP with AUTO GLOVE DETECTION ═══
local DColors = {
    EXTREME = {Fill=Color3.fromRGB(255,30,30), Txt="🔴 EXTREME"},
    HIGH = {Fill=Color3.fromRGB(255,140,0), Txt="🟠 HIGH"},
    MEDIUM = {Fill=Color3.fromRGB(255,220,50), Txt="🟡 MEDIUM"},
    SAFE = {Fill=Color3.fromRGB(80,220,130), Txt="🟢 SAFE"},
    NONE = {Fill=Color3.fromRGB(150,150,150), Txt="⚪ NONE"},
}

local espData = {}
local function ApplyESP(p)
    if p == LocalPlayer or not p.Character then return end
    local head = p.Character:FindFirstChild("Head")
    if not head then return end
    if espData[p.Name] then espData[p.Name].hl:Destroy(); espData[p.Name].bb:Destroy() end
    local hl = Instance.new("Highlight", p.Character)
    hl.FillColor = Color3.fromRGB(255,140,0); hl.FillTransparency = 0.5; hl.OutlineColor = Color3.fromRGB(255,140,0)
    local bb = Instance.new("BillboardGui", head)
    bb.Size = UDim2.fromOffset(220,70); bb.StudsOffset = Vector3.new(0,2.5,0); bb.AlwaysOnTop = true
    local txt = Instance.new("TextLabel", bb)
    txt.Size = UDim2.fromScale(1,1); txt.BackgroundTransparency = 1; txt.TextColor3 = Color3.new(1,1,1)
    txt.TextStrokeTransparency = 0; txt.Font = Enum.Font.GothamBold; txt.TextSize = 13
    espData[p.Name] = {hl=hl, bb=bb, txt=txt}
end
local function RemoveESP(p)
    if espData[p.Name] then
        pcall(function() espData[p.Name].hl:Destroy(); espData[p.Name].bb:Destroy() end)
        espData[p.Name] = nil
    end
end
local function ToggleESP(s)
    Settings.ESP = s
    if Connections.ESP then Connections.ESP:Disconnect() end
    if Connections.ESPAdd then Connections.ESPAdd:Disconnect() end
    if Connections.ESPRem then Connections.ESPRem:Disconnect() end
    if s then
        for _, p in ipairs(Players:GetPlayers()) do ApplyESP(p) end
        Connections.ESPAdd = Players.PlayerAdded:Connect(function(p)
            task.wait(1); if Settings.ESP then ApplyESP(p) end
            p.CharacterAdded:Connect(function() task.wait(1); if Settings.ESP then ApplyESP(p) end end)
        end)
        Connections.ESPRem = Players.PlayerRemoving:Connect(RemoveESP)
        Connections.ESP = RunService.Heartbeat:Connect(function()
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            for _, p in ipairs(Players:GetPlayers()) do
                local d = espData[p.Name]
                if d and p ~= LocalPlayer and myRoot then
                    local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if r then
                        local dist = math.floor((myRoot.Position-r.Position).Magnitude)
                        -- 🧤 هنا بنستخدم GetGloveName التلقائي
                        local gloveName, danger = GetGloveName(p)
                        local cd = DColors[danger] or DColors.SAFE
                        d.txt.Text = string.format("%s\n%s %s\n%d studs",
                            p.DisplayName, cd.Txt,
                            gloveName and ("["..gloveName.."]") or "[None]",
                            dist)
                        d.hl.FillColor = cd.Fill; d.hl.OutlineColor = cd.Fill
                        d.hl.FillTransparency = (danger=="EXTREME") and 0.3 or 0.5
                    end
                end
            end
        end)
    else
        for _, p in ipairs(Players:GetPlayers()) do RemoveESP(p) end
    end
end

-- ═══ KEYBINDS ═══
local Keymap = {
    [Enum.KeyCode.M] = function() Settings.AuraEnabled = not Settings.AuraEnabled; Notify("Keybind", "Aura: "..tostring(Settings.AuraEnabled), true) end,
    [Enum.KeyCode.X] = function() Settings.ESP = not Settings.ESP; ToggleESP(Settings.ESP); Notify("Keybind", "ESP: "..tostring(Settings.ESP), true) end,
    [Enum.KeyCode.T] = function() ToggleFly(not isFlying); Notify("Keybind", "Fly: "..tostring(isFlying), true) end,
    [Enum.KeyCode.G] = function() Settings.GodMode = not Settings.GodMode; ToggleGodMode(Settings.GodMode); Notify("Keybind", "God: "..tostring(Settings.GodMode), true) end,
    [Enum.KeyCode.N] = function() Settings.Noclip = not Settings.Noclip; ToggleNoclip(Settings.Noclip); Notify("Keybind", "Noclip: "..tostring(Settings.Noclip), true) end,
}
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    local fn = Keymap[input.KeyCode]
    if fn then fn() end
end)

-- ═══ WINDUI INTERFACE ═══
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = Config.HubName .. " | " .. Config.Version,
    Icon = "shield",
    Author = Config.Author,
    Folder = "SlapV63",
    Size = UDim2.fromOffset(640, 580),
    Transparent = true,
    Theme = "Dark",
    Background = Config.BackgroundImage,
    BackgroundImageTransparency = 0.4,
})

-- ═══ Combat ═══
local CT = Window:Tab({Title="Combat", Icon="crosshair"})
CT:Button({Title="🔄 Refresh Glove Capture", Callback=function() CapturedRemote=nil; RemoteFormat="None"; CaptureLocked=false; UpdateCaptureHUD("⏳ Hunting remote...", Color3.fromRGB(255,140,0)); Notify("System","Glove Reset",true) end})
CT:Toggle({Title="Auto Slap", Value=true, Callback=function(s) Settings.AuraEnabled=s end})
CT:Slider({Title="Aura Range", Value=15, Min=5, Max=50, Callback=function(v) Settings.Range=v end})
CT:Slider({Title="Aura Hits/sec", Value=5, Min=1, Max=20, Callback=function(v) Settings.AuraMaxHits=v end})
CT:Dropdown({Title="🎯 Hit Part", Values={"HumanoidRootPart","Head","Any"}, Default="HumanoidRootPart",
    Callback=function(o) Settings.HitPart=o end})
CT:Toggle({Title="Ignore Friends", Value=true, Callback=function(s) Settings.IgnoreFriends=s end})
CT:Toggle({Title="God Mode", Value=false, Callback=function(s) Settings.GodMode=s; ToggleGodMode(s) end})
CT:Toggle({Title="Invisible God Mode", Value=false, Callback=function(s) Settings.InvisibleGod=s; ToggleGodMode(Settings.GodMode) end})
CT:Toggle({Title="Auto Aim", Value=false, Callback=function(s)
    if Connections.Aim then Connections.Aim:Disconnect() end
    if s then
        Connections.Aim = RunService.RenderStepped:Connect(function()
            local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if r then
                local cl, dd = nil, 200
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local tr = p.Character:FindFirstChild("HumanoidRootPart")
                        if tr and (r.Position-tr.Position).Magnitude < dd then
                            dd = (r.Position-tr.Position).Magnitude; cl = tr
                        end
                    end
                end
                if cl then Camera.CFrame = CFrame.new(Camera.CFrame.Position, cl.Position) end
            end
        end)
    end
end})

-- ═══ Movement ═══
local MT = Window:Tab({Title="Movement", Icon="wind"})
MT:Toggle({Title="Speed", Value=false, Callback=function(s) ToggleSpeed(s) end})
MT:Slider({Title="Speed Value", Value=35, Min=16, Max=100, Callback=function(v) Settings.PremSpeed=v end})
MT:Toggle({Title="Fly", Value=false, Callback=function(s) ToggleFly(s) end})
MT:Slider({Title="Fly Speed", Value=60, Min=20, Max=200, Callback=function(v) Settings.FlySpeed=v end})
MT:Toggle({Title="Infinite Jump", Value=false, Callback=function(s) ToggleInfiniteJump(s) end})
MT:Toggle({Title="Jump Power Boost", Value=false, Callback=function(s)
    if Connections.Jump then Connections.Jump:Disconnect() end
    if s then Connections.Jump = RunService.Heartbeat:Connect(function()
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.JumpPower = Settings.JumpPower end
    end) end
end})
MT:Slider({Title="Jump Power", Value=50, Min=50, Max=300, Callback=function(v) Settings.JumpPower=v end})
MT:Toggle({Title="Noclip", Value=false, Callback=function(s) Settings.Noclip=s; ToggleNoclip(s) end})
MT:Toggle({Title="Zero Gravity", Value=false, Callback=function(s)
    if Connections.ZG then Connections.ZG:Disconnect() end
    if s then Connections.ZG = RunService.Heartbeat:Connect(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CustomPhysicalProperties = PhysicalProperties.new(0.01,0.01,0.01,0,0) end
    end) end
end})

-- ═══ Visuals ═══
local VT = Window:Tab({Title="Visuals", Icon="eye"})
VT:Toggle({Title="ESP + Auto Glove Detection", Value=false, Callback=function(s) ToggleESP(s) end})
VT:Toggle({Title="Hitbox Expander", Value=false, Callback=function(s)
    if Connections.HB then Connections.HB:Disconnect() end
    if s then Connections.HB = RunService.Heartbeat:Connect(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Size = Vector3.new(5,5,5); hrp.Transparency = 0.7; hrp.CanCollide = false end
            end
        end
    end) end
end})
VT:Toggle({Title="🎯 Silent Aim", Value=false, Callback=function(s) ToggleSilentAim(s) end})
VT:Slider({Title="Silent Aim Range", Value=200, Min=50, Max=500, Callback=function(v) SilentAim.Range=v end})

-- ═══ Anti ═══
local AT = Window:Tab({Title="Anti", Icon="shield"})
AT:Toggle({Title="Anti Void", Value=false, Callback=function(s) Settings.AntiVoid=s; ToggleAntiVoid(s) end})
AT:Button({Title="📍 Set Safe Pos", Callback=function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then Settings.SafePos=hrp.Position; Notify("SafePos","Updated!",true) end
end})
AT:Toggle({Title="Anti Fling", Value=false, Callback=function(s) ToggleAntiFling(s) end})
AT:Toggle({Title="Anti Ragdoll", Value=false, Callback=function(s) ToggleAntiRagdoll(s) end})
AT:Toggle({Title="Anti Knockback", Value=false, Callback=function(s) ToggleAntiKnockback(s) end})
AT:Toggle({Title="Anti Megarock", Value=false, Callback=function(s) ToggleAntiMegarock(s) end})
AT:Toggle({Title="Anti Taser", Value=false, Callback=function(s) ToggleAntiTaser(s) end})
AT:Toggle({Title="Anti Honey", Value=false, Callback=function(s) Settings.AntiHoney=s end})
AT:Toggle({Title="Anti Ice", Value=false, Callback=function(s) Settings.AntiIce=s end})
AT:Toggle({Title="Anti Mail", Value=false, Callback=function(s) Settings.AntiMail=s end})
AT:Toggle({Title="Anti MR", Value=false, Callback=function(s) Settings.AntiMR=s end})
AT:Toggle({Title="Anti Mitten", Value=false, Callback=function(s) Settings.AntiMitten=s end})
AT:Toggle({Title="Anti Squid", Value=false, Callback=function(s) Settings.AntiSquid=s end})
AT:Toggle({Title="Anti Za Hando", Value=false, Callback=function(s) Settings.AntiZaHando=s end})
AT:Toggle({Title="Anti Portal", Value=false, Callback=function(s) Settings.AntiPortal=s end})
AT:Toggle({Title="Anti Bob", Value=false, Callback=function(s) Settings.AntiBob=s end})
AT:Toggle({Title="Anti Cube of Death", Value=false, Callback=function(s) Settings.AntiCubeOfDeath=s end})
AT:Toggle({Title="Anti AFK", Value=false, Callback=function(s) ToggleAntiAFK(s) end})

-- ═══ Farms ═══
local FT = Window:Tab({Title="Farms", Icon="dollar-sign"})
FT:Toggle({Title="🌾 Smart Farm (Auto-Detect)", Value=false, Callback=function(s) ToggleSmartFarm(s) end})
FT:Toggle({Title="Auto Click", Value=false, Callback=function(s)
    Settings.AutoClick = s
    if Connections.Click then Connections.Click:Disconnect() end
    if s then Connections.Click = task.spawn(function()
        while Settings.AutoClick do
            pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new(0,0)) end)
            task.wait(0.5)
        end
    end) end
end})
FT:Button({Title="📌 Add Current Pos to Slapple", Callback=function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then table.insert(SmartFarm.Positions, hrp.Position); Notify("Farm","Saved Slapple #"..#SmartFarm.Positions,true) end
end})
FT:Button({Title="🗑️ Clear Coords", Callback=function()
    SmartFarm.Positions = {}; Notify("Farm","Cleared",true)
end})

-- ═══ Troll ═══
local TT = Window:Tab({Title="Troll", Icon="zap"})
TT:Button({Title="🌀 Fling Closest Player", Callback=function()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local cl, dd = nil, 999
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            if r and (myRoot.Position-r.Position).Magnitude < dd then
                dd=(myRoot.Position-r.Position).Magnitude; cl=p
            end
        end
    end
    if cl then
        local hrp = cl.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, part in ipairs(cl.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    local bv = Instance.new("BodyAngularVelocity", part)
                    bv.AngularVelocity = Vector3.new(9999,9999,9999)
                    bv.MaxTorque = Vector3.new(1e6,1e6,1e6)
                    task.delay(2, function() bv:Destroy() end)
                end
            end
            Notify("Troll","Flinged "..cl.Name,true)
        end
    else Notify("Troll","No target",false) end
end})
TT:Button({Title="💥 Mass Fling All", Callback=function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, part in ipairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local bv = Instance.new("BodyAngularVelocity", part)
                        bv.AngularVelocity = Vector3.new(9999,9999,9999)
                        bv.MaxTorque = Vector3.new(1e6,1e6,1e6)
                        task.delay(2, function() bv:Destroy() end)
                    end
                end
            end
        end
    end
    Notify("Troll","Mass fling attempted",true)
end})

-- ═══ Badges ═══
local BT = Window:Tab({Title="Badges", Icon="award"})
BT:Paragraph({
    Title = "🏅 Auto Badge Helper",
    Desc = "محاولة الضغط على أزرار الواجهة لفتح الشارات",
    Image = Config.HandImage,
    ImageSize = 50,
})
BT:Button({Title="🎯 Click All GuiButtons", Callback=function()
    local count = 0
    for _, v in ipairs(PlayerGui:GetDescendants()) do
        if v:IsA("GuiButton") then
            pcall(function() v.MouseButton1Click:Fire(); count = count + 1 end)
        end
    end
    Notify("Badges", "Clicked "..count.." buttons", true)
end})
BT:Button({Title="📋 Log All GuiButton Names", Callback=function()
    print("=== GUI BUTTONS ===")
    for _, v in ipairs(PlayerGui:GetDescendants()) do
        if v:IsA("GuiButton") then print(v:GetFullName()) end
    end
    Notify("Badges","Logged to console (F9)",true)
end})

-- ═══ Glove Detector Tab (جديد) ═══
local GDT = Window:Tab({Title="Gloves", Icon="hand"})
GDT:Paragraph({
    Title="🧤 Auto Glove Detection",
    Desc="السكربت يقرأ القفاز من leaderstats.Glove تلقائياً. أي قفاز جديد يُصنّف عبر الكلمات المفتاحية."
})
GDT:Button({Title="🔍 Scan All Players Gloves", Callback=function()
    print("=== CURRENT GLOVES ===")
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local glove, danger = GetGloveName(p)
            print(string.format("%s → %s [%s]", p.DisplayName, glove or "None", danger))
        end
    end
    Notify("Gloves","Scanned! Check F9 console",true)
end})
GDT:Button({Title="🔄 Test My Glove Detection", Callback=function()
    local glove, danger = GetGloveName(LocalPlayer)
    Notify("My Glove", (glove or "None").." → "..danger, true)
end})

-- ═══ Teleport ═══
local TPT = Window:Tab({Title="Teleport", Icon="map-pin"})
TPT:Button({Title="🏠 Spawn", Callback=function()
    local s = workspace:FindFirstChildOfClass("SpawnLocation")
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if s and hrp then hrp.CFrame = s.CFrame + Vector3.new(0,3,0); Notify("TP","Spawn",true) end
end})
TPT:Button({Title="☁️ Sky (y=500)", Callback=function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(0,500,0); Notify("TP","Sky",true) end
end})
TPT:Button({Title="📍 Save Pos", Callback=function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then Settings.SafePos = hrp.Position; Notify("TP","Saved",true) end
end})

-- ═══ Servers ═══
local ST = Window:Tab({Title="Servers", Icon="server"})
ST:Paragraph({Title="🌐 Server Hop", Desc="Uses Vynix Server Hopper (external)"})
ST:Button({Title="🚀 Execute Hopper", Callback=function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Vynix-Scripts/main/ServerHopper.lua"))()
    end)
    Notify("Hopper","Executed",true)
end})

-- ═══ Settings ═══
local SET = Window:Tab({Title="Settings", Icon="settings"})
SET:Paragraph({
    Title="⌨️ Keybinds",
    Desc="M=Aura | X=ESP | T=Fly | G=God | N=Noclip",
    Image = Config.LogoImage,
    ImageSize = 40,
})
SET:Button({Title="🔔 Test Notification", Callback=function() Notify("Test","Working!",true) end})
SET:Button({Title="❌ Unload Hub", Callback=function()
    for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
    _G.SlapV63Running = false
    if CaptureHUD and CaptureHUD.gui then CaptureHUD.gui:Destroy() end
    NotifGui:Destroy(); Window:Destroy()
end})

Notify("Slap V63", "Auto-Detect Loaded! Press M/X/T/G/N", true)
print("✅ [Slap V63] Loaded — Auto Glove Detection + Anti-Ban + All Features")