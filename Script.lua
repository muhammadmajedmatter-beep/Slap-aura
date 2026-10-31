-- ============================================================
-- 👑 SLAP AURA HUB | V59 | The Absolute Omega (Restored & Safe)
-- ============================================================
print("🚀 [Slap Aura] Booting V59 Absolute Omega...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ============================================================
-- 🛑 1. GHOST PROTOCOL V9 (Anti-Cheat Bypass & Spoofing)
-- ============================================================
local CapturedRemote = nil
local RemoteFormat = "None"

pcall(function()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    local oldNewIndex = mt.__newindex
    setreadonly(mt, false)

    mt.__index = newcclosure(function(t, k)
        -- تمويه السرعة والجامب
        if (k == "WalkSpeed" or k == "JumpPower") and t:IsA("Humanoid") and t.Parent == LocalPlayer.Character then
            return k == "WalkSpeed" and 16 or 50
        end
        -- تمويه السرعة الفيزيائية (عشان الطيران والكاندي فارم)
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
-- ⚙️ 2. الإعدادات والمتغيرات
-- ============================================================
local Settings = { 
    AuraEnabled = true, Range = 15, AuraMaxHits = 5, 
    FlySpeed = 50, Noclip = false, Godmode = true, 
    PremiumSpeed = 35, ESP = false, AutoAim = false, 
    HitboxExpander = false, GravityControl = false, FPSBooster = false,
    CandyFarm = false, ServerHopper = false
}
local HitCount = 0
local Connections = {}

-- ============================================================
-- 🔔 3. شاشة الـ HUD (رجعت تاني)
-- ============================================================
local HUD = Instance.new("ScreenGui")
HUD.Name = "SlapAuraHUD"; HUD.ResetOnSpawn = false; HUD.DisplayOrder = 9998; HUD.Parent = PlayerGui
local HUDFrame = Instance.new("Frame"); HUDFrame.Size = UDim2.new(0, 220, 0, 40); HUDFrame.Position = UDim2.new(0, 20, 0.1, 0); HUDFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); HUDFrame.BackgroundTransparency = 0.2; HUDFrame.BorderSizePixel = 0; HUDFrame.Parent = HUD
local HUDCorner = Instance.new("UICorner"); HUDCorner.CornerRadius = UDim.new(0, 6); HUDCorner.Parent = HUDFrame
local HUDStroke = Instance.new("UIStroke"); HUDStroke.Color = Color3.fromRGB(255, 140, 0); HUDStroke.Thickness = 1.5; HUDStroke.Parent = HUDFrame
local HUDText = Instance.new("TextLabel"); HUDText.Size = UDim2.new(1, -10, 1, 0); HUDText.Position = UDim2.new(0, 5, 0, 0); HUDText.BackgroundTransparency = 1; HUDText.Text = "🎃 Slap Aura: WAITING"; HUDText.TextColor3 = Color3.fromRGB(255, 255, 255); HUDText.Font = Enum.Font.GothamBold; HUDText.TextSize = 14; HUDText.Parent = HUDFrame

-- ============================================================
-- 🔔 4. نظام الإشعارات
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
-- 💎 5. المحركات (كل ميزة معزولة)
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

-- ============================================================
-- 🍬 6. كاندي كورن فارم + سيرفر هوبر (المحرك الآمن)
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
                        -- بندور على كلمة corn أو candy
                        if obj:IsA("BasePart") and (string.find(name, "corn") or string.find(name, "candy")) then
                            foundCorn = true
                            pcall(function()
                                -- الطيران للحلوى بسرعة آمنة (Tween) 0.2 ثانية
                                local tween = TweenService:Create(hrp, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CFrame = CFrame.new(obj.Position)})
                                tween:Play()
                                tween.Completed:Wait()
                                
                                -- لمس الحلوى عشان تختفي
                                firetouchinterest(hrp, obj, 0)
                                task.wait(0.01)
                                firetouchinterest(hrp, obj, 1)
                            end)
                            task.wait(0.1) -- تأخير بين كل حلوى
                        end
                    end
                end
                
                -- لو ملقاش حلوى تانية، ينتقل لسيرفر جديد (لو الهوبر شغال)
                if not foundCorn then
                    if Settings.ServerHopper then
                        showNotification("Hopper", "Server Cleared! Hopping...", true)
                        task.wait(2)
                        if Settings.CandyFarm then
                            pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end)
                            break
                        end
                    else
                        task.wait(3) -- استنى شوية يمكن حلوى جديدة تنزل
                    end
                end
            end
        end)
    else
        showNotification("Farm", "Corn Farm Stopped", false)
    end
end

-- ============================================================
-- 👁️ 7. الـ ESP
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
-- 🥊 8. الأورا (Auto Slap)
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
            hits = hits + 1; lastHit = tick()
            HitCount = HitCount + 1
            HUDText.Text = "🎃 Slap Aura: ACTIVE ("..HitCount.." Hits)"
        end)
    end
end)

-- ============================================================
-- 🎨 9. الواجهة (WindUI) + الزرار العايم
-- ============================================================
function LoadMainGUI()
    local success, err = pcall(function()
        local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
        local Window = WindUI:CreateWindow({ Title = "Slap Aura | V59", Icon = "shield", Author = "Majed", Folder = "SlapAuraV59", Size = UDim2.fromOffset(580, 460), Transparent = true, Theme = "Dark" })

        local CombatTab = Window:Tab({ Title = "Combat", Icon = "crosshair" })
        CombatTab:Button({ Title = "🔄 Refresh Glove", Callback = function() CapturedRemote = nil; RemoteFormat = "None"; showNotification("System", "Glove Reset", true) end })
        CombatTab:Toggle({Title = "Enable Auto Slap", Value = true, Callback = function(state) Settings.AuraEnabled = state; showNotification("Combat", state and "Aura On" or "Aura Off", state) end})
        CombatTab:Slider({Title = "Hit Speed", Step = 1, Value = { Min = 1, Max = 8, Default = 5 }, Callback = function(value) Settings.AuraMaxHits = value end})
        CombatTab:Toggle({Title = "Instant Kill (Hitbox)", Value = false, Callback = function(state) ToggleHitbox(state) end})
        CombatTab:Toggle({Title = "Auto Aim", Value = false, Callback = function(state) ToggleAutoAim(state) end})

        local MoveTab = Window:Tab({ Title = "Movement", Icon = "wind" })
        MoveTab:Toggle({ Title = "Fly", Value = false, Callback = function(state) ToggleFly(state) end })
        MoveTab:Slider({ Title = "Fly Speed", Step = 10, Value = { Min = 20, Max = 100, Default = 50 }, Callback = function(value) Settings.FlySpeed = value end })
        MoveTab:Toggle({ Title = "Premium Speed", Value = false, Callback = function(state) ToggleSpeed(state) end })
        MoveTab:Slider({ Title = "Speed Value", Step = 1, Value = { Min = 20, Max = 50, Default = 35 }, Callback = function(value) Settings.PremiumSpeed = value end })
        MoveTab:Toggle({ Title = "Zero Gravity", Value = false, Callback = function(state) ToggleGravity(state) end })

        local VisualsTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
        VisualsTab:Toggle({ Title = "Advanced ESP", Value = false, Callback = function(state) ToggleESP(state) end })
        VisualsTab:Toggle({ Title = "FPS Booster", Value = false, Callback = function(state) ToggleFPS(state) end })

        local FarmsTab = Window:Tab({ Title = "Farms", Icon = "tractor" })
        FarmsTab:Toggle({ Title = "Auto Candy Farm (Corn)", Value = false, Callback = function(state) ToggleCandyFarm(state) end })
        FarmsTab:Toggle({ Title = "Auto Server Hopper", Value = false, Callback = function(state) Settings.ServerHopper = state; showNotification("Farm", state and "Hopper On" or "Hopper Off", state) end })
    end)
    if not success then warn("❌ UI Error: " .. tostring(err)) end
end

-- الزرار العايم (عشان تشغل الكاندي بضغطة واحدة)
local floatGui = Instance.new("ScreenGui")
floatGui.Name = "SlapFloatBtn"; floatGui.ResetOnSpawn = false; floatGui.Parent = PlayerGui
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.fromOffset(100, 40); floatBtn.Position = UDim2.new(1, -120, 0, 20)
floatBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0); floatBtn.Text = "Candy: OFF"; floatBtn.TextColor3 = Color3.fromRGB(255,255,255); floatBtn.Font = Enum.Font.GothamBold; floatBtn.TextSize = 12
floatBtn.Parent = floatGui; floatBtn.Active = true; floatBtn.Draggable = true
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0, 8)

floatBtn.MouseButton1Click:Connect(function()
    Settings.CandyFarm = not Settings.CandyFarm
    if Settings.CandyFarm then
        floatBtn.Text = "Candy: ON"
        ToggleCandyFarm(true)
    else
        floatBtn.Text = "Candy: OFF"
        ToggleCandyFarm(false)
    end
end)

task.wait(1)
LoadMainGUI()