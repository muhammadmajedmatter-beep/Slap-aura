-- ============================================================
-- 🥊 Slap Aura Hub | V49.5 | Notifications & Pro Edition
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

-- ============================================================
-- 🛑 1. درع الحماية والتمويه (Ghost Protocol)
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
        local badRemotes = {"ban", "kick", "admingui", "walkspeedchanged", "anticheat", "detect", "report", "speedcheck"}
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

-- المتغيرات
local CurrentGloveIcon = "rbxassetid://15315284749"
local StatusLabel = nil
local MainWindow = nil
local HitCount = 0
local isFlying = false
local flyConnection = nil
local autoFarmRunning = false
local autoFarmConnection = nil
local isCandyFarming = false
local isHopping = false
local isSpeedEnabled = false
local SpeedConnection = nil

local Settings = { 
    AuraEnabled = true, Range = 10, MaxHitsPerSecond = 3, 
    FlySpeed = 50, Noclip = false, AntiVoid = false, 
    Godmode = true, AntiRagdoll = true, AntiKnockback = true, 
    WalkSpeed = 16, JumpPower = 50, 
    Fullbright = false, ESP = false, CandyFarm = false,
    PremiumSpeed = 35, AuraMaxHits = 5, AntiBlind = true
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
-- 🔔 2. شاشة الـ HUD
-- ============================================================
local HUD = Instance.new("ScreenGui")
HUD.Name = "SlapAuraHUD"; HUD.ResetOnSpawn = false; HUD.DisplayOrder = 9998; HUD.Parent = PlayerGui
local HUDFrame = Instance.new("Frame"); HUDFrame.Size = UDim2.new(0, 220, 0, 40); HUDFrame.Position = UDim2.new(0, 20, 0.1, 0); HUDFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); HUDFrame.BackgroundTransparency = 0.2; HUDFrame.BorderSizePixel = 0; HUDFrame.Parent = HUD
local HUDCorner = Instance.new("UICorner"); HUDCorner.CornerRadius = UDim.new(0, 6); HUDCorner.Parent = HUDFrame
local HUDStroke = Instance.new("UIStroke"); HUDStroke.Color = Color3.fromRGB(255, 140, 0); HUDStroke.Thickness = 1.5; HUDStroke.Parent = HUDFrame
local HUDText = Instance.new("TextLabel"); HUDText.Size = UDim2.new(1, -10, 1, 0); HUDText.Position = UDim2.new(0, 5, 0, 0); HUDText.BackgroundTransparency = 1; HUDText.Text = "🎃 Slap Aura: WAITING"; HUDText.TextColor3 = Color3.fromRGB(255, 255, 255); HUDText.Font = Enum.Font.GothamBold; HUDText.TextSize = 14; HUDText.Parent = HUDFrame

-- ============================================================
-- 🧤 3. قراءة القفاز + دالة الـ Refresh
-- ============================================================
local function onGloveEquipped(tool)
    if tool and tool:IsA("Tool") then
        local icon = "rbxassetid://15315284749"
        if tool.TextureId and tool.TextureId ~= "" then icon = tool.TextureId
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
LocalPlayer.CharacterAdded:Connect(function(char) char.ChildAdded:Connect(function(child) if child:IsA("Tool") then onGloveEquipped(child) end end) end)

local function RefreshGlove()
    CapturedRemote = nil; RemoteFormat = "None"; HitCount = 0
    HUDText.Text = "🎃 Slap Aura: WAITING"
    HUDStroke.Color = Color3.fromRGB(255, 140, 0)
    if StatusLabel then StatusLabel.Text = "⏳ Waiting for Calibration..." end
    showNotification("System", "تم تصفير الريموت بنجاح! اضرب بالقفاز.", true)
end

-- ============================================================
-- 🎬 4. شاشة التحميل
-- ============================================================
local LoadingGui = Instance.new("ScreenGui"); LoadingGui.Name = "SlapAuraLoader"; LoadingGui.ResetOnSpawn = false; LoadingGui.IgnoreGuiInset = true; LoadingGui.DisplayOrder = 9999; LoadingGui.Parent = PlayerGui
local Backdrop = Instance.new("Frame"); Backdrop.Size = UDim2.new(1, 0, 1, 0); Backdrop.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Backdrop.BackgroundTransparency = 0.1; Backdrop.Parent = LoadingGui
local MainFrame = Instance.new("Frame"); MainFrame.Size = UDim2.new(0, 360, 0, 180); MainFrame.Position = UDim2.new(0.5, -180, 0.5, -90); MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); MainFrame.BorderSizePixel = 0; MainFrame.Parent = LoadingGui
local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 12); MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke"); MainStroke.Color = Color3.fromRGB(255, 140, 0); MainStroke.Thickness = 2; MainStroke.Parent = MainFrame
local Title = Instance.new("TextLabel"); Title.Size = UDim2.new(1, 0, 0, 40); Title.Position = UDim2.new(0, 0, 0, 25); Title.BackgroundTransparency = 1; Title.Text = "🎃 SLAP AURA"; Title.TextColor3 = Color3.fromRGB(255, 140, 0); Title.Font = Enum.Font.GothamBlack; Title.TextSize = 28; Title.Parent = MainFrame
local SubTitle = Instance.new("TextLabel"); SubTitle.Size = UDim2.new(1, 0, 0, 20); SubTitle.Position = UDim2.new(0, 0, 0, 65); SubTitle.BackgroundTransparency = 1; SubTitle.Text = "Halloween Edition..."; SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180); SubTitle.Font = Enum.Font.GothamMedium; SubTitle.TextSize = 14; SubTitle.Parent = MainFrame
local BarBg = Instance.new("Frame"); BarBg.Size = UDim2.new(0, 280, 0, 8); BarBg.Position = UDim2.new(0.5, -140, 0, 115); BarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40); BarBg.BorderSizePixel = 0; BarBg.Parent = MainFrame
local BarCorner = Instance.new("UICorner"); BarCorner.CornerRadius = UDim.new(1, 0); BarCorner.Parent = BarBg
local BarFill = Instance.new("Frame"); BarFill.Size = UDim2.new(0, 0, 1, 0); BarFill.BackgroundColor3 = Color3.fromRGB(255, 140, 0); BarFill.BorderSizePixel = 0; BarFill.Parent = BarBg
local BarFillCorner = Instance.new("UICorner"); BarFillCorner.CornerRadius = UDim.new(1, 0); BarFillCorner.Parent = BarFill
local loadTween = TweenService:Create(BarFill, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
loadTween:Play()

loadTween.Completed:Connect(function()
    task.wait(0.2)
    local fadeOut = TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    local fadeStroke = TweenService:Create(MainStroke, TweenInfo.new(0.3), {Transparency = 1})
    local fadeBack = TweenService:Create(Backdrop, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    fadeOut:Play(); fadeStroke:Play(); fadeBack:Play()
    task.wait(0.3); LoadingGui:Destroy(); LoadMainGUI() 
end)

-- ============================================================
-- 🚀 5. دوال المزايا الأساسية
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

    local bv = Instance.new("BodyVelocity"); bv.Name = "SlapFlyBV"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge); bv.Velocity = Vector3.new(0, 0, 0); bv.Parent = myRoot
    local bg = Instance.new("BodyGyro"); bg.Name = "SlapFlyBG"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bg.D = 50; bg.P = 5000; bg.CFrame = myRoot.CFrame; bg.Parent = myRoot

    flyConnection = RunService.RenderStepped:Connect(function()
        if not isFlying or not myRoot or not myHum then return end
        local moveDir = myHum.MoveDirection
        local velocity = Vector3.new(0, 0, 0)
        if moveDir.Magnitude > 0 then velocity = moveDir * Settings.FlySpeed end
        local camLook = Camera.CFrame.LookVector
        if camLook.Y > 0.4 then velocity = velocity + Vector3.new(0, Settings.FlySpeed, 0) elseif camLook.Y < -0.4 then velocity = velocity - Vector3.new(0, Settings.FlySpeed, 0) end
        bv.Velocity = velocity; bg.CFrame = Camera.CFrame
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
        if myRoot then local bv = myRoot:FindFirstChild("SlapFlyBV"); local bg = myRoot:FindFirstChild("SlapFlyBG"); if bv then bv:Destroy() end; if bg then bg:Destroy() end end
    end
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
                    local tRoot = plr.Character:FindFirstChild("HumanoidRootPart"); local tHum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if tRoot and tHum and tHum.Health > 0 then
                        if (myRoot.Position - tRoot.Position).Magnitude < 20 then myRoot.CFrame = CFrame.new(tRoot.Position + Vector3.new(0, 5, 0)) end
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
-- 💎 6. المحركات الآمنة
-- ============================================================
function TogglePremiumSpeed(state)
    isSpeedEnabled = state
    if state then
        if SpeedConnection then SpeedConnection:Disconnect() end
        SpeedConnection = RunService.Heartbeat:Connect(function()
            if not isSpeedEnabled then return end
            local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if myHum then myHum.WalkSpeed = Settings.PremiumSpeed end
        end)
    else
        if SpeedConnection then SpeedConnection:Disconnect(); SpeedConnection = nil end
        local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if myHum then myHum.WalkSpeed = 16 end
    end
end

function TogglePremiumCandyFarm(state)
    isCandyFarming = state
    if state then
        task.spawn(function()
            while isCandyFarming do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if not isCandyFarming then break end
                        local name = string.lower(obj.Name)
                        if obj:IsA("BasePart") and (string.find(name, "corn") or string.find(name, "candy")) then
                            if (hrp.Position - obj.Position).Magnitude < 30 then
                                pcall(function()
                                    firetouchinterest(hrp, obj, 0)
                                    task.wait(0.01)
                                    firetouchinterest(hrp, obj, 1)
                                end)
                                task.wait(0.1) 
                            end
                        end
                    end
                end
                task.wait(0.2) 
            end
        end)
    end
end

function ToggleServerHopper(state)
    isHopping = state
    if state then
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
                                local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Linear)
                                local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(obj.Position)})
                                tween:Play(); tween.Completed:Wait()
                                firetouchinterest(hrp, obj, 0); task.wait(0.01); firetouchinterest(hrp, obj, 1)
                            end)
                            task.wait(0.1)
                        end
                    end
                    if not foundCandy then
                        showNotification("Hopper", "تم جمع كل الحلوى! جاري الانتقال...", true)
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
    end
end

-- ============================================================
-- 👁️ 7. محرك الـ ESP الاحترافي + تحذيرات
-- ============================================================
local activeESP = {}
local espConnections = {}

local function createESP(plr)
    if plr == LocalPlayer or not plr.Character then return end
    if activeESP[plr.Name] then return end

    local char = plr.Character
    local head = char:FindFirstChild("Head")
    if not head then return end

    local highlight = Instance.new("Highlight"); highlight.Name = "SlapAuraESP_Highlight"; highlight.Adornee = char; highlight.FillColor = Color3.fromRGB(255, 140, 0); highlight.FillTransparency = 0.5; highlight.OutlineColor = Color3.fromRGB(255, 255, 255); highlight.OutlineTransparency = 0; highlight.Parent = char

    local billboard = Instance.new("BillboardGui"); billboard.Name = "SlapAuraESP_Text"; billboard.Adornee = head; billboard.Size = UDim2.new(0, 200, 0, 50); billboard.StudsOffset = Vector3.new(0, 2.5, 0); billboard.AlwaysOnTop = true; billboard.Parent = head

    local textLabel = Instance.new("TextLabel"); textLabel.Name = "ESPText"; textLabel.Size = UDim2.new(1, 0, 1, 0); textLabel.BackgroundTransparency = 1; textLabel.TextColor3 = Color3.fromRGB(255, 255, 255); textLabel.TextStrokeTransparency = 0; textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); textLabel.Font = Enum.Font.GothamBold; textLabel.TextSize = 14; textLabel.RichText = true; textLabel.Parent = billboard

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
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            createESP(plr)
            if not espConnections[plr.Name] then
                espConnections[plr.Name] = plr.CharacterAdded:Connect(function()
                    task.wait(1)
                    if Settings.ESP then createESP(plr) end
                end)
            end
        end
    end

    task.spawn(function()
        while Settings.ESP do
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local espData = activeESP[plr.Name]
                    local myChar = LocalPlayer.Character
                    
                    if espData and espData.Billboard and myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        local head = plr.Character:FindFirstChild("Head")
                        local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                        
                        if head and tRoot then
                            local dist = math.floor((myChar.HumanoidRootPart.Position - tRoot.Position).Magnitude)
                            local tool = plr.Character:FindFirstChildOfClass("Tool")
                            local gloveName = tool and tool.Name or "None"
                            
                            local nameColor = "#FFFFFF"
                            local dangerousGloves = {"Error", "God's Hand", "Overkill", "Reaper", "Mitten", "Squid"}
                            local isDanger = false
                            for _, badGlove in ipairs(dangerousGloves) do
                                if string.find(string.lower(gloveName), string.lower(badGlove)) then
                                    nameColor = "#FF3333"
                                    isDanger = true
                                    break
                                end
                            end

                            -- إشعار التحذير لو ماسك قفاز خطير
                            if isDanger and not espData.Warned then
                                showNotification("⚠️ DANGER", plr.DisplayName .. " is holding " .. gloveName .. "!", false)
                                espData.Warned = true
                            elseif not isDanger then
                                espData.Warned = false -- تصفير التحذير لو غير القفاز
                            end

                            local text = espData.Billboard:FindFirstChild("ESPText")
                            if text then
                                text.Text = string.format(
                                    '<font color="%s">%s</font>\n<font color="#FF8C00">[%s]</font>\n<font color="#AAAAAA">%d studs</font>',
                                    nameColor, plr.DisplayName, gloveName, dist
                                )
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
    for plrName, _ in pairs(activeESP) do
        local plr = Players:FindFirstChild(plrName)
        if plr then removeESP(plr) end
    end
    for _, conn in pairs(espConnections) do
        if conn then conn:Disconnect() end
    end
    espConnections = {}
    activeESP = {}
end

-- ============================================================
-- 💡 8. حلقة الحمايات
-- ============================================================
pcall(function()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    setreadonly(mt, false)
    mt.__index = newcclosure(function(t, k)
        if k == "Health" and t == LocalPlayer.Character and t:FindFirstChild("Humanoid") then return math.huge end
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

task.spawn(function()
    while task.wait(1) do
        if Settings.AntiBlind then
            pcall(function()
                local blur = Lighting:FindFirstChildOfClass("BlurEffect"); local color = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
                if blur then blur:Destroy() end; if color then color:Destroy() end
            end)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    local myHum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHum or not myRoot then return end

    if Settings.Godmode then myHum.MaxHealth = 10000; if myHum.Health < myHum.MaxHealth then myHum.Health = myHum.MaxHealth end end
    if Settings.AntiRagdoll then if myHum.PlatformStand then myHum.PlatformStand = false end end
    if Settings.AntiKnockback then
        local vel = myRoot.AssemblyLinearVelocity
        if Vector3.new(vel.X, 0, vel.Z).Magnitude > 45 then myRoot.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0) end
    end
    if Settings.AntiVoid then if myRoot.Position.Y < -40 then myRoot.CFrame = CFrame.new(0, 50, 0) end end
    if not isFlying and not isSpeedEnabled then myHum.WalkSpeed = Settings.WalkSpeed; myHum.JumpPower = Settings.JumpPower end
end)

-- ============================================================
-- 🥊 9. حلقة الأورا
-- ============================================================
local lastHitTime, hitsThisSecond, currentSecond = 0, 0, math.floor(tick())
RunService.Stepped:Connect(function()
    if Settings.AntiVoid and LocalPlayer.Character then local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if root and root.Position.Y < -40 then root.CFrame = CFrame.new(0, 50, 0) end end
    if Settings.Noclip and LocalPlayer.Character then for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end

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
            local r = plr.Character:FindFirstChild("HumanoidRootPart"); local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 then
                local d = (myRoot.Position - r.Position).Magnitude
                if d <= shortestDist then shortestDist = d; closestPlayer = plr end
            end
        end
    end

    if closestPlayer and closestPlayer.Character:FindFirstChild("Head") then
        pcall(function()
            if RemoteFormat == "Table" then CapturedRemote:FireServer({["victim"] = closestPlayer.Character.Head, ["attacker"] = LocalPlayer, ["icon"] = CurrentGloveIcon})
            elseif RemoteFormat == "Instance" then CapturedRemote:FireServer(closestPlayer.Character.Head) end
            HitCount = HitCount + 1; hitsThisSecond = hitsThisSecond + 1; HUDText.Text = "🎃 Slap Aura: ACTIVE ("..HitCount.." Hits)"; lastHitTime = tick()
        end)
    end
end)

-- ============================================================
-- 🎨 10. واجهة WindUI (مع الإشعارات)
-- ============================================================
function LoadMainGUI()
    local success, err = pcall(function()
        local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
        
        WindUI:AddTheme({
            Name = "Halloween", Accent = WindUI:Gradient({ ["0"] = { Color = Color3.fromHex("#FF8C00"), Transparency = 0 }, ["100"] = { Color = Color3.fromHex("#800080"), Transparency = 0 } }, { Rotation = 45 }),
            Dialog = Color3.fromHex("#1A1A1A"), Outline = Color3.fromHex("#FF8C00"), Text = Color3.fromHex("#FFFFFF"), Placeholder = Color3.fromHex("#A0A0A0"), Background = Color3.fromHex("#0D0D0D"), Button = Color3.fromHex("#2A1A00"), Icon = Color3.fromHex("#FF8C00")
        })
        
        MainWindow = WindUI:CreateWindow({ Title = "Slap Aura | V49.5", Icon = "ghost", Author = "Muhammad Majed", Folder = "SlapAuraV49", Size = UDim2.fromOffset(580, 460), Transparent = true, Theme = "Halloween" })

        local CombatTab = MainWindow:Tab({ Title = "Combat", Icon = "crosshair" })
        StatusLabel = CombatTab:Paragraph({Title = "Status", Desc = "⏳ Waiting for Calibration... Slap a player ONCE.", Image = "info"})
        CombatTab:Button({ Title = "🔄 Refresh / Re-learn Glove", Desc = "دوس هنا لو غيرت القفاز", Callback = RefreshGlove })
        CombatTab:Toggle({Title = "Enable Auto Slap", Value = true, Callback = function(state) Settings.AuraEnabled = state; showNotification("Combat", state and "Aura Enabled" or "Aura Disabled", state) end})
        CombatTab:Slider({Title = "Range", Step = 1, Value = { Min = 1, Max = 50, Default = 10 }, Callback = function(value) Settings.Range = value end})
        CombatTab:Slider({Title = "Speed (Safe)", Step = 1, Value = { Min = 1, Max = 8, Default = 5 }, Callback = function(value) Settings.AuraMaxHits = value end})

        local UtilityTab = MainWindow:Tab({ Title = "Utility", Icon = "settings" })
        UtilityTab:Toggle({ Title = "Fly", Value = false, Callback = function(state) if state then startFly() else stopFly() end; showNotification("Utility", state and "Fly Enabled" or "Fly Disabled", state) end })
        UtilityTab:Slider({ Title = "Fly Speed", Step = 10, Value = { Min = 20, Max = 200, Default = 50 }, Callback = function(value) Settings.FlySpeed = value end })
        UtilityTab:Toggle({ Title = "Noclip", Value = false, Callback = function(state) Settings.Noclip = state; showNotification("Utility", state and "Noclip Enabled" or "Noclip Disabled", state) end })
        UtilityTab:Slider({ Title = "WalkSpeed", Step = 1, Value = { Min = 16, Max = 100, Default = 16 }, Callback = function(value) Settings.WalkSpeed = value end })
        UtilityTab:Slider({ Title = "JumpPower", Step = 1, Value = { Min = 50, Max = 200, Default = 50 }, Callback = function(value) Settings.JumpPower = value end })
        UtilityTab:Toggle({ Title = "Premium Speed (No Ban)", Value = false, Callback = function(state) TogglePremiumSpeed(state); showNotification("Speed", state and "Premium Speed Enabled" or "Premium Speed Disabled", state) end })
        UtilityTab:Slider({ Title = "Premium Speed Value", Step = 1, Value = { Min = 20, Max = 100, Default = 35 }, Callback = function(value) Settings.PremiumSpeed = value end })

        local VisualsTab = MainWindow:Tab({ Title = "Visuals", Icon = "eye" })
        VisualsTab:Toggle({ Title = "Fullbright", Value = false, Callback = function(state) Settings.Fullbright = state; if state then Lighting.Ambient = Color3.fromRGB(255,255,255); Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255) else Lighting.Ambient = Color3.fromRGB(70,70,70); Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128) end; showNotification("Visuals", state and "Fullbright Enabled" or "Fullbright Disabled", state) end })
        VisualsTab:Toggle({ Title = "Advanced Player ESP", Value = false, Callback = function(state) Settings.ESP = state; if state then enableESP() else disableESP() end; showNotification("ESP", state and "ESP Enabled" or "ESP Disabled", state) end })

        local AntisTab = MainWindow:Tab({ Title = "Antis", Icon = "shield" })
        AntisTab:Toggle({ Title = "Anti-Void", Value = false, Callback = function(state) Settings.AntiVoid = state; showNotification("Antis", state and "Anti-Void Enabled" or "Anti-Void Disabled", state) end })
        AntisTab:Toggle({ Title = "Godmode (Anti-Overkill)", Value = true, Callback = function(state) Settings.Godmode = state; showNotification("Antis", state and "Godmode Enabled" or "Godmode Disabled", state) end })
        AntisTab:Toggle({ Title = "Anti-Ragdoll", Value = true, Callback = function(state) Settings.AntiRagdoll = state; showNotification("Antis", state and "Anti-Ragdoll Enabled" or "Anti-Ragdoll Disabled", state) end })
        AntisTab:Toggle({ Title = "Anti-Knockback", Desc = "منع الطيران عند الضربة", Value = true, Callback = function(state) Settings.AntiKnockback = state; showNotification("Antis", state and "Anti-Knockback Enabled" or "Anti-Knockback Disabled", state) end })
        AntisTab:Toggle({ Title = "Anti-Blind", Value = true, Callback = function(state) Settings.AntiBlind = state; showNotification("Antis", state and "Anti-Blind Enabled" or "Anti-Blind Disabled", state) end })

        local FarmsTab = MainWindow:Tab({ Title = "Farms", Icon = "tractor" })
        FarmsTab:Toggle({ Title = "Slap AutoFarm", Desc = "يضرب ويلم فلوس تلقائياً", Value = false, Callback = function(state) toggleAutoFarm(state); showNotification("Farm", state and "AutoFarm Enabled" or "AutoFarm Disabled", state) end })
        FarmsTab:Toggle({ Title = "Auto Candy Farm (Safe)", Desc = "جمع الحلوى بأمان (واقف مكانك)", Value = false, Callback = function(state) TogglePremiumCandyFarm(state); showNotification("Candy", state and "Safe Candy Farm Enabled" or "Safe Candy Farm Disabled", state) end })
        FarmsTab:Toggle({ Title = "Auto Server Hopper", Desc = "ينقلك لسيرفر جديد ويجمع كل الحلوى", Value = false, Callback = function(state) ToggleServerHopper(state); showNotification("Hopper", state and "Server Hopper Enabled" or "Server Hopper Disabled", state) end })
    end)
    if not success then warn("❌ خطأ في الواجهة: " .. tostring(err)) end
end