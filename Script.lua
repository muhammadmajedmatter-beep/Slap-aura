-- ============================================================
-- 👑 SLAP AURA HUB | V55 | The Absolute God Edition
-- ============================================================
print("🚀 [Slap Aura] Booting Absolute God Engine...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ============================================================
-- 🛡️ 1. GHOST PROTOCOL (Anti-Cheat Bypass)
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
        if k == "AssemblyLinearVelocity" and t.Parent == LocalPlayer.Character then
            local realVel = oldIndex(t, k)
            if realVel.Magnitude > 40 then
                return Vector3.new(realVel.X / 2, realVel.Y / 2, realVel.Z / 2)
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
-- ⚙️ 2. الإعدادات الشاملة (Settings)
-- ============================================================
local Settings = { 
    AuraEnabled = true, Range = 15, MaxHitsPerSecond = 3, 
    FlySpeed = 50, Noclip = false, AntiVoid = false, 
    Godmode = true, AntiRagdoll = true, AntiKnockback = true, 
    WalkSpeed = 16, JumpPower = 50, 
    Fullbright = false, ESP = false, CandyFarm = false,
    PremiumSpeed = 35, AuraMaxHits = 6, 
    AntiBlind = true, AntiIce = true, AntiHoney = true,
    AntiFling = true, AuraRagdollCheck = true,
    AutoEquip = false, InstantAbility = false,
    HitboxExpander = false, RemoveCooldown = false,
    InfiniteJump = false, SmartAntiVoid = false,
    FOVCheck = false, LookAt = false,
    AutoDodge = false, AutoFarmPlayers = false,
    IgnoredGloves = {"Counter", "Reverse", "Overkill", "Error", "God's Hand", "Killstreak"}
}

local CurrentGloveIcon = "rbxassetid://15315284749"

-- ============================================================
-- 🔔 3. نظام الإشعارات (Notifications System)
-- ============================================================
local function showNotification(title, text, isSuccess)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "SlapAuraNotifs"; notifGui.ResetOnSpawn = false; notifGui.DisplayOrder = 99999
    pcall(function() notifGui.Parent = game:GetService("CoreGui") end)
    if not notifGui.Parent then notifGui.Parent = PlayerGui end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(280, 60); frame.Position = UDim2.new(1, 20, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); frame.BorderSizePixel = 0; frame.Parent = notifGui
    
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
-- 💎 4. المحركات الأساسية (Core Engines)
-- ============================================================
-- السرعة الآمنة
local isSpeedEnabled = false
local SpeedConnection = nil
function TogglePremiumSpeed(state)
    isSpeedEnabled = state
    if state then
        if SpeedConnection then SpeedConnection:Disconnect() end
        SpeedConnection = RunService.Heartbeat:Connect(function()
            if not isSpeedEnabled then return end
            local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if myHum then myHum.WalkSpeed = Settings.PremiumSpeed end
        end)
        showNotification("Speed", "Premium Physics Speed Enabled", true)
    else
        if SpeedConnection then SpeedConnection:Disconnect(); SpeedConnection = nil end
        local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if myHum then myHum.WalkSpeed = 16 end
        showNotification("Speed", "Premium Physics Speed Disabled", false)
    end
end

-- كاندي فارم آمن
local isCandyFarming = false
function TogglePremiumCandyFarm(state)
    isCandyFarming = state
    if state then
        showNotification("Farm", "Safe Candy Farm Enabled", true)
        task.spawn(function()
            while isCandyFarming do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if not isCandyFarming then break end
                        local name = string.lower(obj.Name)
                        if obj:IsA("BasePart") and (string.find(name, "corn") or string.find(name, "candy")) then
                            if (hrp.Position - obj.Position).Magnitude < 35 then
                                pcall(function()
                                    firetouchinterest(hrp, obj, 0)
                                    task.wait(0.01)
                                    firetouchinterest(hrp, obj, 1)
                                end)
                                task.wait(0.05) 
                            end
                        end
                    end
                end
                task.wait(0.1) 
            end
        end)
    else
        showNotification("Farm", "Safe Candy Farm Disabled", false)
    end
end

-- سيرفر هوبر
local isHopping = false
function ToggleServerHopper(state)
    isHopping = state
    if state then
        showNotification("Hopper", "Server Hopper Enabled", true)
        task.spawn(function()
            while isHopping do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local foundCandy = false
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if not isHopping then break end
                        local name = string.lower(obj.Name)
                        if obj:IsA("BasePart") and (string.find(name, "corn") or string.find(name, "candy")) then
                            foundCandy = true
                            pcall(function()
                                local tween = TweenService:Create(hrp, TweenInfo.new(0.15), {CFrame = CFrame.new(obj.Position)})
                                tween:Play(); tween.Completed:Wait()
                                firetouchinterest(hrp, obj, 0); task.wait(0.01); firetouchinterest(hrp, obj, 1)
                            end)
                            task.wait(0.1)
                        end
                    end
                    if not foundCandy then
                        task.wait(2)
                        if isHopping then
                            pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end)
                            break
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    else
        showNotification("Hopper", "Server Hopper Disabled", false)
    end
end

-- دالة التصفير
local function RefreshGlove()
    CapturedRemote = nil; RemoteFormat = "None"
    showNotification("System", "Glove Remote Reset! Slap someone.", true)
end

-- ============================================================
-- 👁️ 5. محرك الـ ESP الاحترافي (Advanced ESP)
-- ============================================================
local activeESP = {}
local function createESP(plr)
    if plr == LocalPlayer or not plr.Character then return end
    local char = plr.Character
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    local highlight = Instance.new("Highlight"); highlight.Name = "SlapESP"; highlight.Adornee = char; highlight.FillColor = Color3.fromRGB(255, 140, 0); highlight.FillTransparency = 0.5; highlight.OutlineColor = Color3.fromRGB(255, 255, 255); highlight.Parent = char
    local billboard = Instance.new("BillboardGui"); billboard.Name = "SlapESPText"; billboard.Adornee = head; billboard.Size = UDim2.new(0, 200, 0, 50); billboard.StudsOffset = Vector3.new(0, 2.5, 0); billboard.AlwaysOnTop = true; billboard.Parent = head
    local textLabel = Instance.new("TextLabel"); textLabel.Name = "ESPText"; textLabel.Size = UDim2.new(1, 0, 1, 0); textLabel.BackgroundTransparency = 1; textLabel.TextColor3 = Color3.fromRGB(255, 255, 255); textLabel.TextStrokeTransparency = 0; textLabel.Font = Enum.Font.GothamBold; textLabel.TextSize = 14; textLabel.RichText = true; textLabel.Parent = billboard

    activeESP[plr.Name] = {Highlight = highlight, Billboard = billboard, Warned = false}
end

local function removeESP(plr)
    if activeESP[plr.Name] then
        if activeESP[plr.Name].Highlight then activeESP[plr.Name].Highlight:Destroy() end
        if activeESP[plr.Name].Billboard then activeESP[plr.Name].Billboard:Destroy() end
        activeESP[plr.Name] = nil
    end
end

local function enableESP()
    showNotification("ESP", "Advanced ESP Enabled", true)
    for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer then createESP(plr) end end
    task.spawn(function()
        while Settings.ESP do
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if not activeESP[plr.Name] then createESP(plr) end
                    local espData = activeESP[plr.Name]
                    local myChar = LocalPlayer.Character
                    if espData and myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                        if tRoot then
                            local dist = math.floor((myChar.HumanoidRootPart.Position - tRoot.Position).Magnitude)
                            local tool = plr.Character:FindFirstChildOfClass("Tool")
                            local gloveName = tool and tool.Name or "None"
                            local nameColor = "#FFFFFF"
                            local isDanger = false
                            
                            for _, bad in ipairs(Settings.IgnoredGloves) do
                                if string.find(string.lower(gloveName), string.lower(bad)) then 
                                    nameColor = "#FF3333" 
                                    isDanger = true
                                    break 
                                end
                            end
                            
                            -- إشعار لو اللاعب ماسك قفاز خطير
                            if isDanger and not espData.Warned then 
                                showNotification("⚠️ DANGER", plr.DisplayName .. " is holding " .. gloveName .. "!", false)
                                espData.Warned = true 
                            elseif not isDanger then 
                                espData.Warned = false 
                            end

                            local text = espData.Billboard:FindFirstChild("ESPText")
                            if text then
                                text.Text = string.format('<font color="%s">%s</font>\n<font color="#FF8C00">[%s]</font>\n<font color="#AAAAAA">%d studs</font>', nameColor, plr.DisplayName, gloveName, dist)
                            end
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

local function disableESP()
    showNotification("ESP", "Advanced ESP Disabled", false)
    for name, _ in pairs(activeESP) do local p = Players:FindFirstChild(name); if p then removeESP(p) end end
    activeESP = {}
end

-- ============================================================
-- 🥊 6. محرك القتال (Combat Engine)
-- ============================================================
local function isIgnored(glove)
    for _, bad in ipairs(Settings.IgnoredGloves) do
        if string.find(string.lower(glove), string.lower(bad)) then return true end
    end
    return false
end

local lastHitTime, hitsThisSecond, currentSecond = 0, 0, math.floor(tick())

RunService.Stepped:Connect(function()
    if Settings.AntiVoid and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and root.Position.Y < -40 then root.CFrame = CFrame.new(0, 50, 0) end
    end
    if Settings.Noclip and LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end

    if Settings.AutoDodge and LocalPlayer.Character then
        local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                    if tRoot and (myRoot.Position - tRoot.Position).Magnitude < 12 then
                        myRoot.CFrame = myRoot.CFrame + (myRoot.CFrame.LookVector * -15) + Vector3.new(0, 5, 0)
                    end
                end
            end
        end
    end

    if not Settings.AuraEnabled or not CapturedRemote then return end
    local myChar = LocalPlayer.Character; if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart"); local myTool = myChar:FindFirstChildOfClass("Tool")
    if not myRoot or not myTool then return end

    local sec = math.floor(tick()); if sec ~= currentSecond then currentSecond = sec; hitsThisSecond = 0 end
    if hitsThisSecond >= Settings.AuraMaxHits then return end
    if tick() - lastHitTime < (1 / Settings.AuraMaxHits) then return end

    local closestPlayer, shortestDist = nil, Settings.Range
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local tool = plr.Character:FindFirstChildOfClass("Tool")
            local gloveName = tool and tool.Name or "None"
            
            if not isIgnored(gloveName) then
                local r = plr.Character:FindFirstChild("HumanoidRootPart"); local h = plr.Character:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 then
                    local isRagdolled = plr.Character:FindFirstChild("Ragdolled") and plr.Character.Ragdolled.Value
                    if not (Settings.AuraRagdollCheck and isRagdolled) then
                        local d = (myRoot.Position - r.Position).Magnitude
                        if d <= shortestDist then shortestDist = d; closestPlayer = plr end
                    end
                end
            end
        end
    end

    if closestPlayer and closestPlayer.Character:FindFirstChild("Head") then
        pcall(function()
            if RemoteFormat == "Table" then CapturedRemote:FireServer({["victim"] = closestPlayer.Character.Head, ["attacker"] = LocalPlayer})
            elseif RemoteFormat == "Instance" then CapturedRemote:FireServer(closestPlayer.Character.Head) end
            hitsThisSecond = hitsThisSecond + 1; lastHitTime = tick()
        end)
    end
end)

-- ============================================================
-- 💡 7. الحمايات المتقدمة (Advanced Antis)
-- ============================================================
pcall(function()
    local mt = getrawmetatable(game); local oldIndex = mt.__index; setreadonly(mt, false)
    mt.__index = newcclosure(function(t, k)
        if k == "Health" and t == LocalPlayer.Character and t:FindFirstChild("Humanoid") then return math.huge end
        return oldIndex(t, k)
    end)
    setreadonly(mt, true)
end)

local function setupProtections(char)
    local myHum = char:WaitForChild("Humanoid")
    pcall(function()
        myHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        myHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        myHum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    end)
end
if LocalPlayer.Character then setupProtections(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(setupProtections)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Auto Ability & Cooldown
task.spawn(function()
    while task.wait(0.1) do
        if LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                if Settings.AutoAbility then
                    pcall(function()
                        if tool:FindFirstChild("Activated") then tool.Activated:Fire() end
                        if tool:FindFirstChild("Remote") then tool.Remote:FireServer() end
                    end)
                end
                if Settings.RemoveCooldown then
                    pcall(function() if tool:FindFirstChild("Cooldown") then tool.Cooldown.Value = 0 end end)
                end
            end
        end
    end
end)

-- Hitbox Expander
task.spawn(function()
    while task.wait(1) do
        if Settings.HitboxExpander and LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                pcall(function()
                    tool.Handle.Size = Vector3.new(10, 10, 10)
                    tool.Handle.Transparency = 0.5
                end)
            end
        end
    end
end)

-- Advanced Protections Loop
RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    local myHum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHum or not myRoot then return end

    if Settings.Godmode then myHum.MaxHealth = math.huge; myHum.Health = math.huge end
    if Settings.AntiRagdoll then if myHum.PlatformStand then myHum.PlatformStand = false end end
    if Settings.AntiFling or Settings.AntiKnockback then
        local vel = myRoot.AssemblyLinearVelocity
        if Vector3.new(vel.X, 0, vel.Z).Magnitude > 45 then myRoot.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0) end
    end
    if Settings.AntiVoid and not Settings.SmartAntiVoid then
        if myRoot.Position.Y < -40 then myRoot.CFrame = CFrame.new(0, 50, 0) end
    end
    if not isFlying and not isSpeedEnabled then myHum.WalkSpeed = Settings.WalkSpeed; myHum.JumpPower = Settings.JumpPower end
end)

-- ============================================================
-- 🎨 8. الواجهة المدمجة (WindUI - God Tier)
-- ============================================================
function LoadMainGUI()
    local success, err = pcall(function()
        local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
        
        WindUI:AddTheme({
            Name = "GodTier", Accent = WindUI:Gradient({ ["0"] = { Color = Color3.fromHex("#FF0000"), Transparency = 0 }, ["100"] = { Color = Color3.fromHex("#000000"), Transparency = 0 } }, { Rotation = 45 }),
            Dialog = Color3.fromHex("#1A1A1A"), Outline = Color3.fromHex("#FF0000"), Text = Color3.fromHex("#FFFFFF"), Placeholder = Color3.fromHex("#A0A0A0"), Background = Color3.fromHex("#0D0D0D"), Button = Color3.fromHex("#2A0000"), Icon = Color3.fromHex("#FF0000")
        })
        
        MainWindow = WindUI:CreateWindow({ Title = "Slap Aura | V55", Icon = "skull", Author = "Muhammad Majed", Folder = "SlapAuraV55", Size = UDim2.fromOffset(600, 480), Transparent = true, Theme = "GodTier" })

        -- Combat Tab
        local CombatTab = MainWindow:Tab({ Title = "Combat", Icon = "crosshair" })
        CombatTab:Button({ Title = "🔄 Refresh / Re-learn Glove", Callback = RefreshGlove })
        CombatTab:Toggle({Title = "Enable Auto Slap", Value = true, Callback = function(state) Settings.AuraEnabled = state; showNotification("Combat", state and "Auto Slap Enabled" or "Auto Slap Disabled", state) end})
        CombatTab:Slider({Title = "Range", Step = 1, Value = { Min = 1, Max = 50, Default = 15 }, Callback = function(value) Settings.Range = value end})
        CombatTab:Slider({Title = "Hit Speed", Step = 1, Value = { Min = 1, Max = 10, Default = 6 }, Callback = function(value) Settings.AuraMaxHits = value end})
        CombatTab:Toggle({Title = "Auto Dodge", Value = false, Callback = function(state) Settings.AutoDodge = state; showNotification("Combat", state and "Auto Dodge Enabled" or "Auto Dodge Disabled", state) end})
        CombatTab:Toggle({Title = "Auto Ability", Value = false, Callback = function(state) Settings.AutoAbility = state; showNotification("Combat", state and "Auto Ability Enabled" or "Auto Ability Disabled", state) end})
        CombatTab:Toggle({Title = "Hitbox Expander", Value = false, Callback = function(state) Settings.HitboxExpander = state; showNotification("Combat", state and "Hitbox Expander Enabled" or "Hitbox Expander Disabled", state) end})
        CombatTab:Toggle({Title = "Remove Slap Cooldown", Value = false, Callback = function(state) Settings.RemoveCooldown = state; showNotification("Combat", state and "Cooldown Remover Enabled" or "Cooldown Remover Disabled", state) end})
        CombatTab:Input({ Title = "Ignored Gloves", Value = table.concat(Settings.IgnoredGloves, ", "), Callback = function(text) 
            Settings.IgnoredGloves = {}
            for word in string.gmatch(text, '([^,]+)') do table.insert(Settings.IgnoredGloves, word:gsub("^%s*(.-)%s*$", "%1")) end
            showNotification("Combat", "Ignored Gloves Updated", true)
        end })

        -- Movement Tab
        local MoveTab = MainWindow:Tab({ Title = "Movement", Icon = "wind" })
        MoveTab:Toggle({ Title = "Fly", Value = false, Callback = function(state) if state then startFly() else stopFly() end; showNotification("Movement", state and "Fly Enabled" or "Fly Disabled", state) end })
        MoveTab:Slider({ Title = "Fly Speed", Step = 10, Value = { Min = 20, Max = 200, Default = 50 }, Callback = function(value) Settings.FlySpeed = value end })
        MoveTab:Toggle({ Title = "Noclip", Value = false, Callback = function(state) Settings.Noclip = state; showNotification("Movement", state and "Noclip Enabled" or "Noclip Disabled", state) end })
        MoveTab:Toggle({ Title = "Infinite Jump", Value = false, Callback = function(state) Settings.InfiniteJump = state; showNotification("Movement", state and "Infinite Jump Enabled" or "Infinite Jump Disabled", state) end })
        MoveTab:Toggle({ Title = "Premium Speed", Value = false, Callback = function(state) TogglePremiumSpeed(state) end })
        MoveTab:Slider({ Title = "Speed Value", Step = 1, Value = { Min = 20, Max = 100, Default = 35 }, Callback = function(value) Settings.PremiumSpeed = value end })

        -- Visuals Tab
        local VisualsTab = MainWindow:Tab({ Title = "Visuals", Icon = "eye" })
        VisualsTab:Toggle({ Title = "Fullbright", Value = false, Callback = function(state) Settings.Fullbright = state; if state then Lighting.Ambient = Color3.fromRGB(255,255,255); Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255) else Lighting.Ambient = Color3.fromRGB(70,70,70); Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128) end; showNotification("Visuals", state and "Fullbright Enabled" or "Fullbright Disabled", state) end })
        VisualsTab:Toggle({ Title = "Advanced ESP", Value = false, Callback = function(state) Settings.ESP = state; if state then enableESP() else disableESP() end end })

        -- Antis Tab
        local AntisTab = MainWindow:Tab({ Title = "Antis", Icon = "shield" })
        AntisTab:Toggle({ Title = "Godmode", Value = true, Callback = function(state) Settings.Godmode = state; showNotification("Antis", state and "Godmode Enabled" or "Godmode Disabled", state) end })
        AntisTab:Toggle({ Title = "Anti-Void", Value = true, Callback = function(state) Settings.AntiVoid = state; showNotification("Antis", state and "Anti-Void Enabled" or "Anti-Void Disabled", state) end })
        AntisTab:Toggle({ Title = "Anti-Fling / Knockback", Value = true, Callback = function(state) Settings.AntiFling = state; Settings.AntiKnockback = state; showNotification("Antis", state and "Anti-Fling Enabled" or "Anti-Fling Disabled", state) end })
        AntisTab:Toggle({ Title = "Anti-Blind / Ice / Honey", Value = true, Callback = function(state) Settings.AntiBlind = state; Settings.AntiIce = state; Settings.AntiHoney = state; showNotification("Antis", state and "Anti-Effects Enabled" or "Anti-Effects Disabled", state) end })

        -- Farms Tab
        local FarmsTab = MainWindow:Tab({ Title = "Farms", Icon = "tractor" })
        FarmsTab:Toggle({ Title = "Auto Candy Farm (Safe)", Value = false, Callback = function(state) TogglePremiumCandyFarm(state) end })
        FarmsTab:Toggle({ Title = "Auto Server Hopper", Value = false, Callback = function(state) ToggleServerHopper(state) end })
    end)
    if not success then warn("❌ UI Error: " .. tostring(err)) end
end

-- تشغيل الواجهة
task.wait(1)
LoadMainGUI()