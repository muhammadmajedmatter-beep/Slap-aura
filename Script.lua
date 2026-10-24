-- ============================================================
-- 🥊 Slap Aura Hub | V49.5 | Halloween Edition + Refresh
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
        if self.Name == "Ban" or self.Name == "AdminGUI" or self.Name == "Kick" or self.Name == "WalkSpeedChanged" then
            return 
        end
        local args = {...}
        if #args > 0 then
            if type(args[1]) == "table" and args[1]["victim"] then
                if CapturedRemote ~= self then
                    CapturedRemote = self
                    RemoteFormat = "Table"
                    print("✅ تم التقاط الريموت (Table)")
                end
            elseif typeof(args[1]) == "Instance" and (args[1].Name == "Head" or args[1].Name == "HumanoidRootPart") then
                if CapturedRemote ~= self then
                    CapturedRemote = self
                    RemoteFormat = "Instance"
                    print("✅ تم التقاط الريموت (Instance)")
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

local Settings = { 
    AuraEnabled = true, Range = 10, MaxHitsPerSecond = 3, 
    FlySpeed = 50, Noclip = false, AntiVoid = false, 
    Godmode = true, AntiRagdoll = true, WalkSpeed = 16, JumpPower = 50, 
    Fullbright = false, ESP = false 
}

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
HUDStroke.Color = Color3.fromRGB(255, 140, 0) -- برتقالي هالوين
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

-- 💡 دالة الـ Refresh (تمت إضافتها هنا)
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
-- 🎬 4. شاشة التحميل (خفيفة وسريعة)
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
MainFrame.Size = UDim2.new(0, 360, 0, 180) -- حجم صغير وخفيف
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = LoadingGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 140, 0) -- برتقالي هالوين
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

-- أنيميشن شريط التحميل (2.5 ثانية فقط)
local loadTween = TweenService:Create(BarFill, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
loadTween:Play()

loadTween.Completed:Connect(function()
    task.wait(0.2)
    -- تأثير الخروج السريع
    local fadeOut = TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    local fadeStroke = TweenService:Create(MainStroke, TweenInfo.new(0.3), {Transparency = 1})
    local fadeBack = TweenService:Create(Backdrop, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    fadeOut:Play()
    fadeStroke:Play()
    fadeBack:Play()
    
    task.wait(0.3)
    LoadingGui:Destroy()
    LoadMainGUI() -- فتح الواجهة
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
            hl.FillColor = Color3.fromRGB(255, 140, 0) -- برتقالي
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
-- 💡 6. حلقة الحمايات
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    local myHum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHum or not myRoot then return end

    if Settings.Godmode then
        if myHum.Health < myHum.MaxHealth then myHum.Health = myHum.MaxHealth end
    end
    if Settings.AntiRagdoll then
        if myHum.PlatformStand then myHum.PlatformStand = false end
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
        if root and root.Position.Y < -50 then root.CFrame = CFrame.new(0, 50, 0) end
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
-- 🎨 8. واجهة WindUI (مع ثيم Halloween)
-- ============================================================
function LoadMainGUI()
    local success, err = pcall(function()
        local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
        
        -- إنشاء ثيم Halloween مخصص
        WindUI:AddTheme({
            Name = "Halloween",
            Accent = WindUI:Gradient({
                ["0"] = { Color = Color3.fromHex("#FF8C00"), Transparency = 0 }, -- برتقالي
                ["100"] = { Color = Color3.fromHex("#800080"), Transparency = 0 }, -- بنفسجي
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
            Icon = "ghost", -- أيقونة شبح
            Author = "Premium Dev", 
            Folder = "SlapAuraHalloween", 
            Size = UDim2.fromOffset(580, 460), 
            Transparent = true, 
            Theme = "Halloween" -- تطبيق الثيم
        })

        local CombatTab = MainWindow:Tab({ Title = "Combat", Icon = "crosshair" })
        StatusLabel = CombatTab:Paragraph({Title = "Status", Desc = "⏳ Waiting for Calibration... Slap a player ONCE.", Image = "info"})
        
        -- 💡 زرار الريفريش تمت إضافته هنا
        CombatTab:Button({
            Title = "🔄 Refresh / Re-learn Glove", 
            Desc = "دوس هنا لو غيرت القفاز", 
            Callback = RefreshGlove
        })
        
        CombatTab:Toggle({Title = "Enable Auto Slap", Value = true, Callback = function(state) Settings.AuraEnabled = state end})
        CombatTab:Slider({Title = "Range", Step = 1, Value = { Min = 1, Max = 50, Default = 10 }, Callback = function(value) Settings.Range = value end})
        CombatTab:Slider({Title = "Speed", Step = 1, Value = { Min = 1, Max = 4, Default = 3 }, Callback = function(value) Settings.MaxHitsPerSecond = value end})

        local UtilityTab = MainWindow:Tab({ Title = "Utility", Icon = "settings" })
        UtilityTab:Toggle({ Title = "Fly (Mobile)", Value = false, Callback = function(state) if state then startFly() else stopFly() end end })
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

        local FarmsTab = MainWindow:Tab({ Title = "Farms", Icon = "tractor" })
        FarmsTab:Toggle({ Title = "Slap AutoFarm", Desc = "يضرب ويلم فلوس تلقائياً", Value = false, Callback = function(state) toggleAutoFarm(state) end })
FarmsTab:Toggle({ 
    Title = "Auto Collect Candy", 
    Desc = "ينتقل لكل الكاندي في السيرفر ويلمها تلقائياً", 
    Value = false, 
    Callback = function(state) 
        Settings.CandyFarm = state 
        if state then
            task.spawn(function()
                while Settings.CandyFarm do
                    task.wait(0.5) 
                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        local root = myChar.HumanoidRootPart
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if not Settings.CandyFarm then break end 
                            if obj:IsA("BasePart") and (string.find(string.lower(obj.Name), "candy") or string.find(string.lower(obj.Name), "sweet")) then
                                root.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                                task.wait(0.15) 
                            end
                        end
                    end
                end
            end)
        end
    end 
})
        print("✅ [Slap Aura] الواجهة اشتغلت بنجاح.")
    end)
    if not success then warn("❌ خطأ في الواجهة: " .. tostring(err)) end
end 
