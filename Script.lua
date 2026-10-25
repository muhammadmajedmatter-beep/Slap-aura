-- ============================================================
-- 🥊 Slap Aura Hub | V49.5 | Halloween Edition + Candy Farm
-- ============================================================
print("🚀 [Slap Aura] بدء التشغيل...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- 🛑 1. درع الحماية + الالتقاط الفوري
local CapturedRemote = nil
local RemoteFormat = "None"
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" then
        if self.Name == "Ban" or self.Name == "AdminGUI" or self.Name == "Kick" or self.Name == "WalkSpeedChanged" or self.Name == "AntiCheat" or self.Name == "Detect" or self.Name == "Report" or self.Name == "SpeedCheck" then
            return 
        end
        local args = {...}
        if #args > 0 then
            if type(args[1]) == "table" and args[1]["victim"] then
                if CapturedRemote ~= self then
                    CapturedRemote = self
                    RemoteFormat = "Table"
                end
            elseif typeof(args[1]) == "Instance" and (args[1].Name == "Head" or args[1].Name == "HumanoidRootPart") then
                if CapturedRemote ~= self then
                    CapturedRemote = self
                    RemoteFormat = "Instance"
                end
            end
        end
    elseif method == "Kick" and self == LocalPlayer then
        return
    end
    return oldNamecall(self, ...)
end)

-- المتغيرات
local CurrentGloveIcon = "rbxassetid://15315284749"
local StatusLabel = nil
local MainWindow = nil
local HitCount = 0
local isFlying = false
local flyConnection = nil
local espHighlights = {}
local autoFarmRunning = false
local autoFarmConnection = nil
local CandyFarmConnection = nil
local Settings = { 
    AuraEnabled = true, Range = 10, MaxHitsPerSecond = 3, 
    FlySpeed = 50, Noclip = false, AntiVoid = false, 
    Godmode = true, AntiRagdoll = true, AntiKnockback = true, 
    WalkSpeed = 16, JumpPower = 50, 
    Fullbright = false, ESP = false, CandyFarm = false
}

-- ================= نظام الإشعارات المخصص =================
local function showNotification(title, text, isSuccess)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "SlapAuraNotifs"; notifGui.ResetOnSpawn = false; notifGui.DisplayOrder = 99999
    pcall(function() notifGui.Parent = game:GetService("CoreGui") end)
    if not notifGui.Parent then notifGui.Parent = PlayerGui end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(280, 60); frame.Position = UDim2.new(1, 20, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); frame.BorderSizePixel = 0; frame.Parent = notifGui
    
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 8); corner.Parent = frame
    local stroke = Instance.new("UIStroke"); stroke.Color = isSuccess and Color3.fromRGB(50, 220, 130) or Color3.fromRGB(255, 140, 0); stroke.Thickness = 1.5; stroke.Parent = frame
    
    local icon = Instance.new("TextLabel"); icon.Size = UDim2.fromOffset(30, 30); icon.Position = UDim2.fromOffset(10, 15); icon.BackgroundTransparency = 1; icon.Text = isSuccess and "✅" or "🎃"; icon.TextSize = 20; icon.Parent = frame
    local titleLbl = Instance.new("TextLabel"); titleLbl.Size = UDim2.new(1, -50, 0, 20); titleLbl.Position = UDim2.fromOffset(45, 10); titleLbl.BackgroundTransparency = 1; titleLbl.Text = title; titleLbl.TextColor3 = Color3.fromRGB(255,255,255); titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 14; titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.Parent = frame
    local descLbl = Instance.new("TextLabel"); descLbl.Size = UDim2.new(1, -50, 0, 25); descLbl.Position = UDim2.fromOffset(45, 30); descLbl.BackgroundTransparency = 1; descLbl.Text = text; descLbl.TextColor3 = Color3.fromRGB(160, 160, 170); descLbl.Font = Enum.Font.Gotham; descLbl.TextSize = 12; descLbl.TextWrapped = true; descLbl.TextXAlignment = Enum.TextXAlignment.Left; descLbl.Parent = frame

    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -300, 0, 20)}):Play()
    task.delay(3, function()
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0, 20)}):Play()
        task.wait(0.3); notifGui:Destroy()
    end)
end
-- =========================================================

-- ============================================================
-- 🔔 2. شاشة الـ HUD
-- ============================================================
local HUD = Instance.new("ScreenGui")
HUD.Name = "SlapAuraHUD"
HUD.ResetOnSpawn = false
HUD.DisplayOrder = 9998
HUD.Parent = PlayerGui

local HUDFrame = Instance.new("Frame")
HUDFrame.Size = UDim2.new(0, 220, 0, 40)
HUDFrame.Position = UDim2.new(0, 20, 0.1, 0)
HUDFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
HUDFrame.BackgroundTransparency = 0.2
HUDFrame.BorderSizePixel = 0
HUDFrame.Parent = HUD

local HUDCorner = Instance.new("UICorner")
HUDCorner.CornerRadius = UDim.new(0, 6)
HUDCorner.Parent = HUDFrame

local HUDStroke = Instance.new("UIStroke")
HUDStroke.Color = Color3.fromRGB(255, 140, 0)
HUDStroke.Thickness = 1.5
HUDStroke.Parent = HUDFrame

local HUDText = Instance.new("TextLabel")
HUDText.Size = UDim2.new(1, -10, 1, 0)
HUDText.Position = UDim2.new(0, 5, 0, 0)
HUDText.BackgroundTransparency = 1
HUDText.Text = "🎃 Slap Aura: WAITING"
HUDText.TextColor3 = Color3.fromRGB(255, 255, 255)
HUDText.Font = Enum.Font.GothamBold
HUDText.TextSize = 14
HUDText.Parent = HUDFrame

-- ============================================================
-- 🧤 3. قراءة القفاز + دالة الـ Refresh
-- ============================================================
local function onGloveEquipped(tool)
    if tool and tool:IsA("Tool") then
        local icon = "rbxassetid://15315284749"
        if tool.TextureId and tool.TextureId ~= "" then 
            icon = tool.TextureId
        else
            local handle = tool:FindFirstChild("Handle")
            if handle then
                local texture = handle:FindFirstChildOfClass("Texture") or handle:FindFirstChildOfClass("Decal")
                if texture then icon = texture.Texture end
            end
        end
        CurrentGloveIcon = icon
    end
end

if LocalPlayer.Character then
    local existingTool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if existingTool then onGloveEquipped(existingTool) end
end
LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(child) 
        if child:IsA("Tool") then onGloveEquipped(child) end 
    end)
end)

local function RefreshGlove()
    CapturedRemote = nil
    RemoteFormat = "None"
    HitCount = 0
    HUDText.Text = "🎃 Slap Aura: WAITING"
    HUDStroke.Color = Color3.fromRGB(255, 140, 0)
    if StatusLabel then 
        StatusLabel.Text = "⏳ Waiting for Calibration..." 
    end
    print("🔄 تم تصفير الريموت. اضرب بالقفاز الجديد!")
end

-- ============================================================
-- 🎬 4. شاشة التحميل
-- ============================================================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "SlapAuraLoader"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.DisplayOrder = 9999
LoadingGui.Parent = PlayerGui

local Backdrop = Instance.new("Frame")
Backdrop.Size = UDim2.new(1, 0, 1, 0)
Backdrop.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Backdrop.BackgroundTransparency = 0.1
Backdrop.Parent = LoadingGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 180)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = LoadingGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 140, 0)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "🎃 SLAP AURA"
Title.TextColor3 = Color3.fromRGB(255, 140, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 28
Title.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 0, 0, 65)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Halloween Edition..."
SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextSize = 14
SubTitle.Parent = MainFrame

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0, 280, 0, 8)
BarBg.Position = UDim2.new(0.5, -140, 0, 115)
BarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
BarBg.BorderSizePixel = 0
BarBg.Parent = MainFrame

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = BarBg

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBg

local BarFillCorner = Instance.new("UICorner")
BarFillCorner.CornerRadius = UDim.new(1, 0)
BarFillCorner.Parent = BarFill

local loadTween = TweenService:Create(BarFill, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
loadTween:Play()

loadTween.Completed:Connect(function()
    task.wait(0.2)
    local fadeOut = TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    local fadeStroke = TweenService:Create(MainStroke, TweenInfo.new(0.3), {Transparency = 1})
    local fadeBack = TweenService:Create(Backdrop, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    fadeOut:Play()
    fadeStroke:Play()
    fadeBack:Play()
    
    task.wait(0.3)
    LoadingGui:Destroy()
    LoadMainGUI() 
end)

-- ============================================================
-- 🚀 5. دوال المزايا
-- ============================================================
local function startFly()
    if isFlying then return end
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    if not myRoot or not myHum then return end

    isFlying = true
    myHum:ChangeState(Enum.HumanoidStateType.Physics)

    local bv = Instance.new("BodyVelocity")
    bv.Name = "SlapFlyBV"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = myRoot

    local bg = Instance.new("BodyGyro")
    bg.Name = "SlapFlyBG"
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.D = 50
    bg.P = 5000
    bg.CFrame = myRoot.CFrame
    bg.Parent = myRoot

    flyConnection = RunService.RenderStepped:Connect(function()
        if not isFlying or not myRoot or not myHum then return end
        
        local moveDir = myHum.MoveDirection
        local velocity = Vector3.new(0, 0, 0)

        if moveDir.Magnitude > 0 then
            velocity = moveDir * Settings.FlySpeed
        end

        local camLook = Camera.CFrame.LookVector
        if camLook.Y > 0.4 then
            velocity = velocity + Vector3.new(0, Settings.FlySpeed, 0)
        elseif camLook.Y < -0.4 then
            velocity = velocity - Vector3.new(0, Settings.FlySpeed, 0)
        end

        bv.Velocity = velocity
        bg.CFrame = Camera.CFrame
    end)
end

local function stopFly()
    if not isFlying then return end
    isFlying = false
    if flyConnection then flyConnection:Disconnect() end
    local myChar = LocalPlayer.Character
    if myChar then
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        local myHum = myChar:FindFirstChildOfClass("Humanoid")
        if myHum then myHum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        if myRoot then
            local bv = myRoot:FindFirstChild("SlapFlyBV")
            local bg = myRoot:FindFirstChild("SlapFlyBG")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end
end

local function enableESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hl = Instance.new("Highlight")
            hl.Name = "SlapAuraESP"
            hl.FillColor = Color3.fromRGB(255, 140, 0)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.Parent = plr.Character
            table.insert(espHighlights, hl)
        end
    end
end

local function disableESP()
    for _, hl in ipairs(espHighlights) do 
        if hl and hl.Parent then hl:Destroy() end 
    end
    espHighlights = {}
end

local function toggleAutoFarm(state)
    Settings.AutoFarm = state
    if state then
        autoFarmRunning = true
        autoFarmConnection = RunService.Heartbeat:Connect(function()
            if not autoFarmRunning or not LocalPlayer.Character then return end
            local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                    local tHum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if tRoot and tHum and tHum.Health > 0 then
                        if (myRoot.Position - tRoot.Position).Magnitude < 20 then
                            myRoot.CFrame = CFrame.new(tRoot.Position + Vector3.new(0, 5, 0))
                        end
                    end
                end
            end
        end)
    else
        autoFarmRunning = false
        if autoFarmConnection then autoFarmConnection:Disconnect() end
    end
end

-- ============================================================
-- 💡 6. حلقة الحمايات (God Tier Antis - Physics Fix)
-- ============================================================
pcall(function()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    setreadonly(mt, false)
    mt.__index = newcclosure(function(t, k)
        if k == "Health" and t == LocalPlayer.Character and t:FindFirstChild("Humanoid") then
            return math.huge
        end
        return oldIndex(t, k)
    end)
    setreadonly(mt, true)
end)

local function setupCharacterProtections(char)
    local myHum = char:WaitForChild("Humanoid")
    pcall(function()
        myHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        myHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        myHum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    end)
end

if LocalPlayer.Character then setupCharacterProtections(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(setupCharacterProtections)

RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    local myHum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHum or not myRoot then return end

    if Settings.Godmode then
        myHum.MaxHealth = 10000
        if myHum.Health < myHum.MaxHealth then myHum.Health = myHum.MaxHealth end
    end
    
    if Settings.AntiRagdoll then
        if myHum.PlatformStand then myHum.PlatformStand = false end
    end

    if Settings.AntiKnockback then
        local vel = myRoot.AssemblyLinearVelocity
        local horizontalSpeed = Vector3.new(vel.X, 0, vel.Z).Magnitude
        if horizontalSpeed > 45 then
            myRoot.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0)
        end
    end

    if Settings.AntiVoid then
        if myRoot.Position.Y < -40 then myRoot.CFrame = CFrame.new(0, 50, 0) end
    end

    if not isFlying then
        myHum.WalkSpeed = Settings.WalkSpeed
        myHum.JumpPower = Settings.JumpPower
    end
end)

-- ============================================================
-- 🥊 7. حلقة الأورا
-- ============================================================
local lastHitTime, hitsThisSecond, currentSecond = 0, 0, math.floor(tick())

RunService.Stepped:Connect(function()
    if Settings.AntiVoid and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and root.Position.Y < -40 then root.CFrame = CFrame.new(0, 50, 0) end
    end
    if Settings.Noclip and LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do 
            if p:IsA("BasePart") then p.CanCollide = false end 
        end
    end

    if not Settings.AuraEnabled or not CapturedRemote then return end
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local myTool = myChar:FindFirstChildOfClass("Tool")
    if not myRoot or not myTool then return end

    local sec = math.floor(tick())
    if sec ~= currentSecond then currentSecond = sec; hitsThisSecond = 0 end
    if hitsThisSecond >= Settings.MaxHitsPerSecond then return end
    if tick() - lastHitTime < (1 / Settings.MaxHitsPerSecond) then return end

    local closestPlayer, shortestDist = nil, Settings.Range
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local r = plr.Character:FindFirstChild("HumanoidRootPart")
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 then
                local d = (myRoot.Position - r.Position).Magnitude
                if d <= shortestDist then shortestDist = d; closestPlayer = plr end
            end
        end
    end

    if closestPlayer and closestPlayer.Character:FindFirstChild("Head") then
        if RemoteFormat == "Table" then
            CapturedRemote:FireServer({["victim"] = closestPlayer.Character.Head, ["attacker"] = LocalPlayer, ["icon"] = CurrentGloveIcon})
        elseif RemoteFormat == "Instance" then
            CapturedRemote:FireServer(closestPlayer.Character.Head)
        end
        HitCount = HitCount + 1
        hitsThisSecond = hitsThisSecond + 1
        HUDText.Text = "🎃 Slap Aura: ACTIVE ("..HitCount.." Hits)"
        lastHitTime = tick()
    end
end)

-- ============================================================
-- 🎨 8. واجهة WindUI
-- ============================================================
function LoadMainGUI()
    local success, err = pcall(function()
        local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
        
        WindUI:AddTheme({
            Name = "Halloween",
            Accent = WindUI:Gradient({
                ["0"] = { Color = Color3.fromHex("#FF8C00"), Transparency = 0 },
                ["100"] = { Color = Color3.fromHex("#800080"), Transparency = 0 },
            }, { Rotation = 45 }),
            Dialog = Color3.fromHex("#1A1A1A"),
            Outline = Color3.fromHex("#FF8C00"),
            Text = Color3.fromHex("#FFFFFF"),
            Placeholder = Color3.fromHex("#A0A0A0"),
            Background = Color3.fromHex("#0D0D0D"),
            Button = Color3.fromHex("#2A1A00"),
            Icon = Color3.fromHex("#FF8C00")
        })
        
        MainWindow = WindUI:CreateWindow({
            Title = "Slap Aura | Halloween", 
            Icon = "ghost",
            Author = "Muhammad Majed", 
            Folder = "SlapAuraHalloween", 
            Size = UDim2.fromOffset(580, 460), 
            Transparent = true, 
            Theme = "Halloween"
        })

        local CombatTab = MainWindow:Tab({ Title = "Combat", Icon = "crosshair" })
        StatusLabel = CombatTab:Paragraph({Title = "Status", Desc = "⏳ Waiting for Calibration... Slap a player ONCE.", Image = "info"})
        
        CombatTab:Button({ Title = "🔄 Refresh / Re-learn Glove", Desc = "دوس هنا لو غيرت القفاز", Callback = RefreshGlove })
        CombatTab:Toggle({Title = "Enable Auto Slap", Value = true, Callback = function(state) Settings.AuraEnabled = state end})
        CombatTab:Slider({Title = "Range", Step = 1, Value = { Min = 1, Max = 50, Default = 10 }, Callback = function(value) Settings.Range = value end})
        CombatTab:Slider({Title = "Speed", Step = 1, Value = { Min = 1, Max = 4, Default = 3 }, Callback = function(value) Settings.MaxHitsPerSecond = value end})

        local UtilityTab = MainWindow:Tab({ Title = "Utility", Icon = "settings" })
        UtilityTab:Toggle({ Title = "Fly", Value = false, Callback = function(state) if state then startFly() else stopFly() end end })
        UtilityTab:Slider({ Title = "Fly Speed", Step = 10, Value = { Min = 20, Max = 200, Default = 50 }, Callback = function(value) Settings.FlySpeed = value end })
        UtilityTab:Toggle({ Title = "Noclip", Value = false, Callback = function(state) Settings.Noclip = state end })
        UtilityTab:Slider({ Title = "WalkSpeed", Step = 1, Value = { Min = 16, Max = 100, Default = 16 }, Callback = function(value) Settings.WalkSpeed = value end })
        UtilityTab:Slider({ Title = "JumpPower", Step = 1, Value = { Min = 50, Max = 200, Default = 50 }, Callback = function(value) Settings.JumpPower = value end })

        local VisualsTab = MainWindow:Tab({ Title = "Visuals", Icon = "eye" })
        VisualsTab:Toggle({ Title = "Fullbright", Value = false, Callback = function(state) Settings.Fullbright = state; if state then Lighting.Ambient = Color3.fromRGB(255,255,255); Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255) else Lighting.Ambient = Color3.fromRGB(70,70,70); Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128) end end })
        VisualsTab:Toggle({ Title = "Player ESP", Value = false, Callback = function(state) if state then enableESP() else disableESP() end end })

        local AntisTab = MainWindow:Tab({ Title = "Antis", Icon = "shield" })
        AntisTab:Toggle({ Title = "Anti-Void", Value = false, Callback = function(state) Settings.AntiVoid = state end })
        AntisTab:Toggle({ Title = "Godmode (Anti-Overkill)", Value = true, Callback = function(state) Settings.Godmode = state end })
        AntisTab:Toggle({ Title = "Anti-Ragdoll", Value = true, Callback = function(state) Settings.AntiRagdoll = state end })
        AntisTab:Toggle({ Title = "Anti-Knockback", Desc = "منع الطيران عند الضربة", Value = true, Callback = function(state) Settings.AntiKnockback = state end })

        local FarmsTab = MainWindow:Tab({ Title = "Farms", Icon = "tractor" })
        FarmsTab:Toggle({ Title = "Slap AutoFarm", Desc = "يضرب ويلم فلوس تلقائياً", Value = false, Callback = function(state) toggleAutoFarm(state) end })
        
        FarmsTab:Toggle({ 
            Title = "Auto Candy Farm (Ultra Speed)", 
            Desc = "أسرع طريقة لجمع الكاندي", 
            Value = false, 
            Callback = function(state) 
                Settings.CandyFarm = state 
                if state then
                    task.spawn(function()
                        local tweenInfo = TweenInfo.new(0.03, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                        while Settings.CandyFarm do
                            local myChar = LocalPlayer.Character
                            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                local hrp = myChar.HumanoidRootPart
                                local folder = workspace:FindFirstChild("CandyCorns") or workspace:FindFirstChild("Candy") or workspace:FindFirstChild("HalloweenCandy")
                                if folder then
                                    for i = 1, #folder:GetChildren() do
                                        if not Settings.CandyFarm then break end
                                        local candy = folder:GetChildren()[i]
                                        if candy:IsA("BasePart") then
                                            local tween = TweenService:Create(hrp, tweenInfo, {CFrame = candy.CFrame})
                                            tween:Play()
                                            tween.Completed:Wait() 
                                        end
                                    end
                                else
                                    for _, obj in pairs(workspace:GetDescendants()) do
                                        if not Settings.CandyFarm then break end
                                        local nameCheck = string.lower(obj.Name)
                                        if obj:IsA("BasePart") and (string.find(nameCheck, "candy") or string.find(nameCheck, "corn")) then
                                            local tween = TweenService:Create(hrp, tweenInfo, {CFrame = obj.CFrame})
                                            tween:Play()
                                            tween.Completed:Wait()
                                        end
                                    end
                                end
                            end
                            task.wait(0.1) 
                        end
                    end)
                end
            end 
        })
    end)
    if not success then warn("❌ خطأ في الواجهة: " .. tostring(err)) end
end