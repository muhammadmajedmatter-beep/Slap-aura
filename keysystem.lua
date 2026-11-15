-- ============================================================
-- 🔐 SLAP AURA | Premium Key System (Tiger Edition) - Standalone
-- ============================================================
if _G.SlapAuraKeySystemRunning then return end
_G.SlapAuraKeySystemRunning = true

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ================= [1] الإعدادات =================
local KeySystem = {
    LinkvertiseURL = "https://link-target.net/10307604/ikbTu3tbVOrU",   
    VerifyAPI      = "https://muhammadmajed54.val.run/", 
    -- ⚠️ تأكد أن هذا الرابط يوجه لملف السكربت الأساسي (Script.lua)
    ScriptURL      = "https://raw.githubusercontent.com/muhammadmajedmatter-beep/Slap-aura/main/Script.lua", 
    Duration       = 86400,
    SaveFile       = "SlapAura_CloudKey.json",
    DeveloperName  = "Muhammad Majed",
    OwnerKey       = "MAJED-OWNER-2025",
    DiscordInvite  = "https://discord.gg/gzuxzqj3t" 
}

-- ================= [2] HWID =================
local function getRealHWID()
    local success, hwid = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
    if success and hwid and hwid ~= "" then return hwid end
    return gethwid and gethwid() or tostring(LocalPlayer.UserId)
end
local HWID = getRealHWID()
local sessionId = HttpService:GenerateGUID(false) 

-- ================= [3] Colors =================
local C = {
    Bg = Color3.fromRGB(8, 8, 14), BgGrad1 = Color3.fromRGB(20, 5, 40), BgGrad2 = Color3.fromRGB(5, 25, 45),
    Card = Color3.fromRGB(15, 15, 25), CardGlass = Color3.fromRGB(255, 255, 255), Surface = Color3.fromRGB(30, 30, 45),
    Accent1 = Color3.fromRGB(0, 240, 255), Accent2 = Color3.fromRGB(168, 85, 247), Accent3 = Color3.fromRGB(236, 72, 153),
    Success = Color3.fromRGB(16, 185, 129), Error = Color3.fromRGB(239, 68, 68), Warning = Color3.fromRGB(251, 191, 36),
    Text = Color3.fromRGB(255, 255, 255), TextDim = Color3.fromRGB(148, 163, 184), Discord = Color3.fromRGB(88, 101, 242)
}

-- ================= [4] Storage =================
local function encrypt(s) local r = "" for i = 1, #s do r = r .. string.char((string.byte(s, i) + 13) % 256) end return r end
local function decrypt(s) local r = "" for i = 1, #s do r = r .. string.char((string.byte(s, i) - 13) % 256) end return r end
local function saveData(t) if writefile then pcall(writefile, KeySystem.SaveFile, encrypt(HttpService:JSONEncode(t))) end end
local function loadData()
    if isfile and isfile(KeySystem.SaveFile) then
        local ok, d = pcall(function() return HttpService:JSONDecode(decrypt(readfile(KeySystem.SaveFile))) end)
        if ok and d then return d end
    end
end

-- ================= [5] Server Functions =================
local function verifyKeyOnline(inputKey)
    if inputKey == KeySystem.OwnerKey then 
        _G.SlapAura_Tier = "lifetime"
        _G.SlapAura_Features = { basicAutoFarm = true, speedHack = true, teleport = true, noclip = true, fly = true, esp = true }
        return true, os.time() + KeySystem.Duration 
    end
    local url = KeySystem.VerifyAPI .. "validate?key=" .. HttpService:UrlEncode(inputKey) .. "&hwid=" .. HWID .. "&userid=" .. tostring(LocalPlayer.UserId) .. "&session=" .. sessionId
    local success, response = pcall(function()
        if syn and syn.request then return syn.request({Url = url, Method = "GET"}).Body
        elseif request then return request({Url = url, Method = "GET"}).Body
        else return game:HttpGet(url) end
    end)
    if not success then return false, "فشل الاتصال بالسيرفر." end
    local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(response) end)
    if decodeSuccess and data then
        if data.success == true then 
            _G.SlapAura_Tier = data.tier or "free"
            _G.SlapAura_Features = data.features or {}
            return true, data.expires_at and math.floor(data.expires_at / 1000) or (os.time() + KeySystem.Duration)
        elseif data.message == "BANNED" then
            return false, "BANNED", data.reason or "Bypass", data.expires or 0
        else
            return false, data.message
        end
    end
    return false, "رد السيرفر غير مفهوم."
end

local function resetHWIDOnline(inputKey)
    local url = KeySystem.VerifyAPI .. "reset?key=" .. HttpService:UrlEncode(inputKey)
    local success, response = pcall(function()
        if syn and syn.request then return syn.request({Url = url, Method = "GET"}).Body
        elseif request then return request({Url = url, Method = "GET"}).Body
        else return game:HttpGet(url) end
    end)
    if success and response then
        local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(response) end)
        if decodeSuccess and data and data.success == true then return true end
    end
    return false
end

function ShowBanScreen(reason, expiresAt)
    local banGui = Instance.new("ScreenGui")
    banGui.Name = "SlapAuraBan"; banGui.ResetOnSpawn = false; banGui.DisplayOrder = 999999
    pcall(function() banGui.Parent = game:GetService("CoreGui") end); if not banGui.Parent then banGui.Parent = PlayerGui end
    local bg = Instance.new("Frame", banGui); bg.Size = UDim2.fromScale(1, 1); bg.BackgroundColor3 = C.Bg
    local box = Instance.new("Frame", banGui); box.Size = UDim2.fromOffset(500, 300); box.Position = UDim2.fromScale(0.5, 0.5); box.AnchorPoint = Vector2.new(0.5, 0.5); box.BackgroundColor3 = C.Card; box.BackgroundTransparency = 0.1
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 18)
    local stroke = Instance.new("UIStroke", box); stroke.Color = C.Error; stroke.Thickness = 2
    local title = Instance.new("TextLabel", box); title.Size = UDim2.new(1, 0, 0, 40); title.Position = UDim2.fromOffset(0, 90); title.BackgroundTransparency = 1; title.Text = "ACCESS DENIED"; title.TextColor3 = C.Error; title.Font = Enum.Font.GothamBlack; title.TextSize = 26
    local reasonLbl = Instance.new("TextLabel", box); reasonLbl.Size = UDim2.new(1, -60, 0, 60); reasonLbl.Position = UDim2.fromOffset(30, 135); reasonLbl.BackgroundTransparency = 1; reasonLbl.Text = "Banned.\nReason: " .. tostring(reason); reasonLbl.TextColor3 = C.TextDim; reasonLbl.Font = Enum.Font.GothamMedium; reasonLbl.TextSize = 14; reasonLbl.TextWrapped = true
    local btn = Instance.new("TextButton", box); btn.Size = UDim2.fromOffset(200, 42); btn.Position = UDim2.new(0.5, -100, 1, -65); btn.BackgroundColor3 = C.Error; btn.Text = "Exit Game"; btn.TextColor3 = C.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 15
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(function() LocalPlayer:Kick("Banned: " .. tostring(reason)) end)
end

local function startHeartbeat(key)
    if key == KeySystem.OwnerKey then return end
    task.spawn(function()
        while task.wait(30) do
            local url = KeySystem.VerifyAPI .. "heartbeat?key=" .. HttpService:UrlEncode(key) .. "&hwid=" .. HWID .. "&userid=" .. tostring(LocalPlayer.UserId)
            local success, response = pcall(function()
                if syn and syn.request then return syn.request({Url = url, Method = "GET"}).Body
                elseif request then return request({Url = url, Method = "GET"}).Body
                else return game:HttpGet(url) end
            end)
            if success and response then
                local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(response) end)
                if decodeSuccess and data and data.banned == true then ShowBanScreen(data.reason or "Trap Key", data.expires or 0) break end
            end
        end
    end)
end

local function checkLocalSession()
    local saved = loadData()
    if saved and saved.hwid == HWID and os.time() < saved.expires then 
        if saved.key == KeySystem.OwnerKey then 
            _G.SlapAura_Tier = "lifetime"; _G.SlapAura_Features = { basicAutoFarm = true, speedHack = true, teleport = true, noclip = true, fly = true, esp = true }
            _G.SlapAura_CurrentKey = saved.key; startHeartbeat(saved.key); return true 
        end
        local isValid = verifyKeyOnline(saved.key)
        if isValid then _G.SlapAura_CurrentKey = saved.key; startHeartbeat(saved.key); return true end
    end
    return false
end

-- ================= [6] Tiger UI =================
local function createPremiumUI(callback)
    local gui = Instance.new("ScreenGui"); gui.Name = "SlapAuraKeySystem"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true; gui.DisplayOrder = 99999; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() gui.Parent = game:GetService("CoreGui") end); if not gui.Parent then gui.Parent = PlayerGui end
    local blur = Instance.new("BlurEffect"); blur.Size = 0; blur.Parent = Lighting; TweenService:Create(blur, TweenInfo.new(0.6), {Size = 28}):Play()
    local bg = Instance.new("Frame", gui); bg.Size = UDim2.fromScale(1, 1); bg.BackgroundColor3 = C.Bg; bg.BackgroundTransparency = 1
    local bgGrad = Instance.new("UIGradient", bg); bgGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, C.BgGrad1), ColorSequenceKeypoint.new(0.5, C.Bg), ColorSequenceKeypoint.new(1, C.BgGrad2)}); bgGrad.Rotation = 135
    TweenService:Create(bg, TweenInfo.new(0.4), {BackgroundTransparency = 0.15}):Play()

    local windowFrame = Instance.new("Frame", gui); windowFrame.AnchorPoint = Vector2.new(0.5, 0.5); windowFrame.Position = UDim2.fromScale(0.5, 0.55); windowFrame.Size = UDim2.fromOffset(580, 400); windowFrame.BackgroundColor3 = C.Card; windowFrame.BackgroundTransparency = 1; windowFrame.BorderSizePixel = 0
    local winScale = Instance.new("UIScale", windowFrame); winScale.Scale = 0.85; TweenService:Create(winScale, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Scale = 1}):Play(); TweenService:Create(windowFrame, TweenInfo.new(0.5), {Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0.1}):Play()
    Instance.new("UICorner", windowFrame).CornerRadius = UDim.new(0, 20)

    local winStroke = Instance.new("UIStroke", windowFrame); winStroke.Thickness = 1.5; local strokeGrad = Instance.new("UIGradient", winStroke); strokeGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, C.Accent1), ColorSequenceKeypoint.new(0.33, C.Accent2), ColorSequenceKeypoint.new(0.66, C.Accent3), ColorSequenceKeypoint.new(1, C.Accent1)})
    task.spawn(function() while winStroke.Parent do strokeGrad.Rotation = (strokeGrad.Rotation + 1) % 360 task.wait(0.03) end end)

    local leftPanel = Instance.new("Frame", windowFrame); leftPanel.Size = UDim2.fromOffset(220, 400); leftPanel.BackgroundColor3 = C.Surface; leftPanel.BackgroundTransparency = 0.4; leftPanel.BorderSizePixel = 0
    Instance.new("UICorner", leftPanel).CornerRadius = UDim.new(0, 20)
    
    local ring = Instance.new("Frame", leftPanel); ring.Size = UDim2.fromOffset(110, 110); ring.Position = UDim2.new(0.5, -55, 0, 30); ring.BackgroundTransparency = 1; Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
    local ringStroke = Instance.new("UIStroke", ring); ringStroke.Thickness = 3; local rGrad = Instance.new("UIGradient", ringStroke); rGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, C.Accent1), ColorSequenceKeypoint.new(0.5, C.Accent2), ColorSequenceKeypoint.new(1, C.Accent3)})
    task.spawn(function() while ringStroke.Parent do rGrad.Rotation = (rGrad.Rotation + 3) % 360 task.wait(0.03) end end)
    local avatar = Instance.new("ImageLabel", ring); avatar.Size = UDim2.new(1, -10, 1, -10); avatar.Position = UDim2.fromOffset(5, 5); avatar.BackgroundTransparency = 1; avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"; Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

    local nameLbl = Instance.new("TextLabel", leftPanel); nameLbl.Size = UDim2.new(1, -20, 0, 28); nameLbl.Position = UDim2.fromOffset(10, 155); nameLbl.BackgroundTransparency = 1; nameLbl.Text = LocalPlayer.DisplayName; nameLbl.TextColor3 = C.Text; nameLbl.Font = Enum.Font.GothamBlack; nameLbl.TextSize = 20
    local userLbl = Instance.new("TextLabel", leftPanel); userLbl.Size = UDim2.new(1, -20, 0, 20); userLbl.Position = UDim2.fromOffset(10, 185); userLbl.BackgroundTransparency = 1; userLbl.Text = "@" .. LocalPlayer.Name; userLbl.TextColor3 = C.Accent1; userLbl.Font = Enum.Font.GothamBold; userLbl.TextSize = 13

    local rightPanel = Instance.new("Frame", windowFrame); rightPanel.Size = UDim2.fromOffset(360, 400); rightPanel.Position = UDim2.fromOffset(220, 0); rightPanel.BackgroundTransparency = 1
    local headerLbl = Instance.new("TextLabel", rightPanel); headerLbl.Size = UDim2.new(1, -60, 0, 30); headerLbl.Position = UDim2.fromOffset(30, 30); headerLbl.BackgroundTransparency = 1; headerLbl.Text = "🔐 AUTHENTICATION"; headerLbl.TextColor3 = C.Text; headerLbl.Font = Enum.Font.GothamBlack; headerLbl.TextSize = 20; headerLbl.TextXAlignment = Enum.TextXAlignment.Left

    local keyContainer = Instance.new("Frame", rightPanel); keyContainer.Size = UDim2.new(1, -60, 0, 50); keyContainer.Position = UDim2.fromOffset(30, 100); keyContainer.BackgroundColor3 = C.Bg; keyContainer.BorderSizePixel = 0; Instance.new("UICorner", keyContainer).CornerRadius = UDim.new(0, 10)
    local keyStroke = Instance.new("UIStroke", keyContainer); keyStroke.Color = C.Surface; keyStroke.Thickness = 1.5
    local keyBox = Instance.new("TextBox", keyContainer); keyBox.Size = UDim2.new(1, -20, 1, 0); keyBox.Position = UDim2.fromOffset(10, 0); keyBox.BackgroundTransparency = 1; keyBox.PlaceholderText = "Paste your key here..."; keyBox.Text = ""; keyBox.TextColor3 = C.Text; keyBox.Font = Enum.Font.Code; keyBox.TextSize = 14; keyBox.TextXAlignment = Enum.TextXAlignment.Left; keyBox.ClearTextOnFocus = false

    local verifyBtn = Instance.new("TextButton", rightPanel); verifyBtn.Size = UDim2.new(0.5, -40, 0, 46); verifyBtn.Position = UDim2.new(0.5, 10, 0, 165); verifyBtn.BackgroundColor3 = C.Accent1; verifyBtn.Text = "Verify ✨"; verifyBtn.TextColor3 = C.Bg; verifyBtn.Font = Enum.Font.GothamBold; verifyBtn.TextSize = 14; verifyBtn.AutoButtonColor = false
    Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 10)
    local vGrad = Instance.new("UIGradient", verifyBtn); vGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, C.Accent1), ColorSequenceKeypoint.new(1, C.Accent2)}); vGrad.Rotation = 45

    local getBtn = Instance.new("TextButton", rightPanel); getBtn.Size = UDim2.new(0.5, -40, 0, 46); getBtn.Position = UDim2.fromOffset(30, 165); getBtn.BackgroundColor3 = C.Surface; getBtn.Text = "🔗 Get Key"; getBtn.TextColor3 = C.Text; getBtn.Font = Enum.Font.GothamBold; getBtn.TextSize = 13; getBtn.AutoButtonColor = false
    Instance.new("UICorner", getBtn).CornerRadius = UDim.new(0, 10)

    getBtn.MouseButton1Click:Connect(function()
        if setclipboard then pcall(setclipboard, KeySystem.LinkvertiseURL) end
        getBtn.Text = "✅ Copied!"; task.wait(1.5); getBtn.Text = "🔗 Get Key"
    end)

    verifyBtn.MouseButton1Click:Connect(function()
        local k = keyBox.Text:gsub("%s+", "")
        if k == "" then return end
        verifyBtn.Text = "⏳ Verifying..."; verifyBtn.Active = false
        local isValid, errorMsg, banReason, banExpires = verifyKeyOnline(k)
        if isValid then
            _G.SlapAura_CurrentKey = k
            local expiryTime = errorMsg; if expiryTime == true then expiryTime = os.time() + KeySystem.Duration end
            saveData({key = k, expires = expiryTime, hwid = HWID})
            verifyBtn.Text = "✅ Success!"; verifyBtn.BackgroundColor3 = C.Success; task.wait(0.9)
            TweenService:Create(blur, TweenInfo.new(0.5), {Size = 0}):Play(); TweenService:Create(winScale, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Scale = 0}):Play()
            task.wait(0.5); gui:Destroy(); startHeartbeat(k); callback()
        else
            if errorMsg == "BANNED" then gui:Destroy(); ShowBanScreen(banReason, banExpires); return end
            verifyBtn.Text = "❌ Error"; verifyBtn.BackgroundColor3 = C.Error; task.wait(2)
            verifyBtn.Text = "Verify ✨"; verifyBtn.BackgroundColor3 = C.Accent1; verifyBtn.Active = true
        end
    end)
end

local function LoadMainScript()
    local success, err = pcall(function()
        local code = game:HttpGet(KeySystem.ScriptURL)
        local func = loadstring(code)
        if func then func() else error("Failed to load script string") end
    end)
    if not success then warn("❌ Error Loading Script: " .. tostring(err)) end
end

if checkLocalSession() then LoadMainScript() else createPremiumUI(LoadMainScript) end