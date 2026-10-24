-- ============================================================
-- 🔐 SLAP AURA | Ultimate Premium Key System (Owner Key + UI)
-- ============================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ================= [1] الإعدادات =================
local KeySystem = {
    LinkvertiseURL = "https://direct-link.net/10307604/kQmsbPuU0YF4",   
    VerifyAPI      = "https://muhammadmajedmatter--5e403a30ceda11f18f921607ee4eb77e.web.val.run", 
    ScriptURL      = "https://raw.githubusercontent.com/muhammadmajedmatter-beep/Slap-aura/main/Script.lua?v=1", 
    Duration       = 7 * 24 * 60 * 60,
    SaveFile       = "SlapAura_CloudKey.json",
    HWID           = tostring(LocalPlayer.UserId),
    DeveloperName  = "Muhammad Majed",
    OwnerKey       = "MAJED-OWNER-2025" -- 👈 مفتاح الأونر الخاص بك
}

local COLORS = {
    Bg1     = Color3.fromRGB(15, 15, 20),
    Bg2     = Color3.fromRGB(25, 25, 32),
    Card    = Color3.fromRGB(35, 35, 45),
    Surface = Color3.fromRGB(45, 45, 55),
    Stroke  = Color3.fromRGB(60, 60, 70),
    Accent1 = Color3.fromRGB(255, 140, 0),
    Accent2 = Color3.fromRGB(160, 70, 220),
    Success = Color3.fromRGB(50, 220, 130),
    Error   = Color3.fromRGB(255, 80, 80),
    Text    = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(160, 160, 170),
}

-- ================= [2] التشفير والحفظ =================
local function encrypt(s) local r = "" for i = 1, #s do r = r .. string.char((string.byte(s, i) + 13) % 256) end return r end
local function decrypt(s) local r = "" for i = 1, #s do r = r .. string.char((string.byte(s, i) - 13) % 256) end return r end
local function saveData(t) if writefile then pcall(writefile, KeySystem.SaveFile, encrypt(HttpService:JSONEncode(t))) end end
local function loadData()
    if isfile and isfile(KeySystem.SaveFile) then
        local ok, d = pcall(function() return HttpService:JSONDecode(decrypt(readfile(KeySystem.SaveFile))) end)
        if ok and d then return d end
    end
end

-- ================= [3] التحقق عبر السيرفر أو مفتاح الأونر =================
local function verifyKeyOnline(inputKey)
    -- 1. لو المفتاح هو مفتاح الأونر، هيعدي على طول
    if inputKey == KeySystem.OwnerKey then
        return true
    end

    -- 2. التحقق العادي من السيرفر
    local success, result = pcall(function()
        local url = KeySystem.VerifyAPI .. "/?userId=" .. LocalPlayer.UserId
        return game:HttpGet(url)
    end)
    if success and result then
        return (inputKey == result:gsub("%s+", ""))
    end
    return false
end

local function checkLocalSession()
    local saved = loadData()
    if saved and saved.hwid == KeySystem.HWID and os.time() < saved.expires then 
        if saved.key == KeySystem.OwnerKey then return true end
        if verifyKeyOnline(saved.key) then return true end
    end
    return false
end

-- ================= [4] نظام الإشعارات =================
local function showNotification(title, text, isSuccess)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "SlapAuraNotifs"; notifGui.ResetOnSpawn = false; notifGui.DisplayOrder = 99999
    pcall(function() notifGui.Parent = game:GetService("CoreGui") end)
    if not notifGui.Parent then notifGui.Parent = PlayerGui end

    local frame = Instance.new("Frame"); frame.Size = UDim2.fromOffset(280, 60); frame.Position = UDim2.new(1, 20, 0, 20); frame.BackgroundColor3 = COLORS.Card; frame.BorderSizePixel = 0; frame.Parent = notifGui
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 8); corner.Parent = frame
    local stroke = Instance.new("UIStroke"); stroke.Color = isSuccess and COLORS.Success or COLORS.Accent1; stroke.Thickness = 1.5; stroke.Transparency = 0.3; stroke.Parent = frame
    
    local icon = Instance.new("TextLabel"); icon.Size = UDim2.fromOffset(30, 30); icon.Position = UDim2.fromOffset(10, 15); icon.BackgroundTransparency = 1; icon.Text = isSuccess and "✅" or "🎃"; icon.TextSize = 20; icon.Parent = frame
    local titleLbl = Instance.new("TextLabel"); titleLbl.Size = UDim2.new(1, -50, 0, 20); titleLbl.Position = UDim2.fromOffset(45, 10); titleLbl.BackgroundTransparency = 1; titleLbl.Text = title; titleLbl.TextColor3 = COLORS.Text; titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 14; titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.Parent = frame
    local descLbl = Instance.new("TextLabel"); descLbl.Size = UDim2.new(1, -50, 0, 25); descLbl.Position = UDim2.fromOffset(45, 30); descLbl.BackgroundTransparency = 1; descLbl.Text = text; descLbl.TextColor3 = COLORS.TextDim; descLbl.Font = Enum.Font.Gotham; descLbl.TextSize = 12; descLbl.TextWrapped = true; descLbl.TextXAlignment = Enum.TextXAlignment.Left; descLbl.Parent = frame

    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -300, 0, 20)}):Play()
    task.delay(3, function()
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0, 20)}):Play()
        task.wait(0.3); notifGui:Destroy()
    end)
end

-- ================= [5] واجهة المفتاح =================
local isVerified = false

local function createSupremeUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "SlapAuraSupremeKey"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true; gui.DisplayOrder = 99999; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = PlayerGui end

    local blur = Instance.new("BlurEffect"); blur.Size = 0; blur.Parent = Lighting
    TweenService:Create(blur, TweenInfo.new(0.5), {Size = 24}):Play()

    local backdrop = Instance.new("Frame"); backdrop.Size = UDim2.fromScale(1, 1); backdrop.BackgroundColor3 = Color3.new(0, 0, 0); backdrop.BackgroundTransparency = 1; backdrop.BorderSizePixel = 0; backdrop.Parent = gui
    TweenService:Create(backdrop, TweenInfo.new(0.4), {BackgroundTransparency = 0.6}):Play()

    local window = Instance.new("Frame"); window.AnchorPoint = Vector2.new(0.5, 0.5); window.Position = UDim2.fromScale(0.5, 0.5); window.Size = UDim2.fromOffset(540, 320); window.BackgroundColor3 = COLORS.Bg1; window.BorderSizePixel = 0; window.Parent = gui
    local uiScale = Instance.new("UIScale"); uiScale.Scale = 0.8; uiScale.Parent = window
    TweenService:Create(uiScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()

    local winCorner = Instance.new("UICorner"); winCorner.CornerRadius = UDim.new(0, 14); winCorner.Parent = window
    local bgGradient = Instance.new("UIGradient"); bgGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, COLORS.Bg1), ColorSequenceKeypoint.new(1, COLORS.Bg2)}); bgGradient.Rotation = 45; bgGradient.Parent = window
    local winStroke = Instance.new("UIStroke"); winStroke.Color = COLORS.Stroke; winStroke.Thickness = 2; winStroke.Transparency = 0.1; winStroke.Parent = window
    local winGrad = Instance.new("UIGradient"); winGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, COLORS.Accent1), ColorSequenceKeypoint.new(0.5, COLORS.Accent2), ColorSequenceKeypoint.new(1, COLORS.Accent1)}); winGrad.Parent = winStroke

    task.spawn(function()
        local r = 0
        while window.Parent do r = (r + 1) % 360 winGrad.Rotation = r task.wait(0.03) end
    end)

    -- الجزء الشمال
    local sidebar = Instance.new("Frame"); sidebar.Size = UDim2.fromOffset(210, 320); sidebar.BackgroundColor3 = COLORS.Surface; sidebar.BackgroundTransparency = 0.5; sidebar.BorderSizePixel = 0; sidebar.Parent = window
    local sideCorner = Instance.new("UICorner"); sideCorner.CornerRadius = UDim.new(0, 14); sideCorner.Parent = sidebar

    local ringFrame = Instance.new("Frame"); ringFrame.Size = UDim2.fromOffset(90, 90); ringFrame.Position = UDim2.fromOffset(60, 30); ringFrame.BackgroundColor3 = COLORS.Surface; ringFrame.Parent = sidebar
    local ringCorner = Instance.new("UICorner"); ringCorner.CornerRadius = UDim.new(1, 0); ringCorner.Parent = ringFrame
    local ringStroke = Instance.new("UIStroke"); ringStroke.Color = COLORS.Accent1; ringStroke.Thickness = 3; ringStroke.Parent = ringFrame
    local ringGrad = Instance.new("UIGradient"); ringGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, COLORS.Accent1), ColorSequenceKeypoint.new(1, COLORS.Accent2)}); ringGrad.Parent = ringStroke

    task.spawn(function()
        local r = 0
        while ringFrame.Parent do r = (r - 2) % 360 ringGrad.Rotation = r task.wait(0.03) end
    end)

    local avatarImg = Instance.new("ImageLabel"); avatarImg.Size = UDim2.new(1, -6, 1, -6); avatarImg.Position = UDim2.fromOffset(3, 3); avatarImg.BackgroundTransparency = 1; avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"; avatarImg.Parent = ringFrame
    local imgCorner = Instance.new("UICorner"); imgCorner.CornerRadius = UDim.new(1, 0); imgCorner.Parent = avatarImg

    local welcomeText = Instance.new("TextLabel"); welcomeText.Size = UDim2.new(1, -20, 0, 20); welcomeText.Position = UDim2.fromOffset(10, 135); welcomeText.BackgroundTransparency = 1; welcomeText.Text = "Welcome back,"; welcomeText.TextColor3 = COLORS.TextDim; welcomeText.Font = Enum.Font.Gotham; welcomeText.TextSize = 13; welcomeText.Parent = sidebar
    local nameText = Instance.new("TextLabel"); nameText.Size = UDim2.new(1, -20, 0, 25); nameText.Position = UDim2.fromOffset(10, 155); nameText.BackgroundTransparency = 1; nameText.Text = LocalPlayer.DisplayName; nameText.TextColor3 = COLORS.Text; nameText.Font = Enum.Font.GothamBlack; nameText.TextSize = 20; nameText.TextTruncate = Enum.TextTruncate.AtEnd; nameText.Parent = sidebar
    local userText = Instance.new("TextLabel"); userText.Size = UDim2.new(1, -20, 0, 20); userText.Position = UDim2.fromOffset(10, 180); userText.BackgroundTransparency = 1; userText.Text = "@" .. LocalPlayer.Name; userText.TextColor3 = COLORS.Accent1; userText.Font = Enum.Font.GothamMedium; userText.TextSize = 12; userText.TextTruncate = Enum.TextTruncate.AtEnd; userText.Parent = sidebar

    local devBadge = Instance.new("Frame"); devBadge.Size = UDim2.fromOffset(170, 26); devBadge.Position = UDim2.fromOffset(20, 270); devBadge.BackgroundColor3 = COLORS.Bg1; devBadge.Parent = sidebar
    local devCorner = Instance.new("UICorner"); devCorner.CornerRadius = UDim.new(0, 6); devCorner.Parent = devBadge
    local devStroke = Instance.new("UIStroke"); devStroke.Color = COLORS.Accent2; devStroke.Thickness = 1; devStroke.Parent = devBadge
    local devText = Instance.new("TextLabel"); devText.Size = UDim2.new(1, 0, 1, 0); devText.BackgroundTransparency = 1; devText.Text = "⚡ Dev: " .. KeySystem.DeveloperName; devText.TextColor3 = COLORS.TextDim; devText.Font = Enum.Font.GothamBold; devText.TextSize = 11; devText.Parent = devBadge

    -- الجزء اليمين
    local rightPanel = Instance.new("Frame"); rightPanel.Size = UDim2.fromOffset(330, 320); rightPanel.Position = UDim2.fromOffset(210, 0); rightPanel.BackgroundTransparency = 1; rightPanel.Parent = window

    local header = Instance.new("Frame"); header.Size = UDim2.new(1, 0, 0, 50); header.BackgroundTransparency = 1; header.Parent = rightPanel
    local title = Instance.new("TextLabel"); title.Size = UDim2.new(1, -50, 1, 0); title.Position = UDim2.fromOffset(20, 0); title.BackgroundTransparency = 1; title.Text = "Cloud Auth"; title.TextColor3 = COLORS.Text; title.Font = Enum.Font.GothamBlack; title.TextSize = 18; title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = header

    local closeBtn = Instance.new("TextButton"); closeBtn.Size = UDim2.fromOffset(28, 28); closeBtn.Position = UDim2.new(1, -45, 0, 11); closeBtn.BackgroundColor3 = COLORS.Surface; closeBtn.Text = "X"; closeBtn.TextColor3 = COLORS.TextDim; closeBtn.Font = Enum.Font.SourceSansBold; closeBtn.TextSize = 18; closeBtn.AutoButtonColor = false; closeBtn.Parent = header
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(1, 0); cc.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(function() TweenService:Create(blur, TweenInfo.new(0.3), {Size = 0}):Play() gui:Destroy() end)

    local instructions = Instance.new("TextLabel"); instructions.Size = UDim2.new(1, -40, 0, 60); instructions.Position = UDim2.fromOffset(20, 60); instructions.BackgroundTransparency = 1; instructions.Text = "Please authenticate to access Slap Aura.\n1. Click 'Get Key' to open the link.\n2. Paste your key in the field below."; instructions.TextColor3 = COLORS.TextDim; instructions.Font = Enum.Font.Gotham; instructions.TextSize = 12; instructions.TextWrapped = true; instructions.TextXAlignment = Enum.TextXAlignment.Left; instructions.Parent = rightPanel

    local keyBox = Instance.new("TextBox"); keyBox.Size = UDim2.new(1, -40, 0, 45); keyBox.Position = UDim2.fromOffset(20, 140); keyBox.BackgroundColor3 = COLORS.Bg1; keyBox.PlaceholderText = "Paste your key here..."; keyBox.Text = ""; keyBox.TextColor3 = COLORS.Text; keyBox.PlaceholderColor3 = COLORS.TextDim; keyBox.Font = Enum.Font.GothamMedium; keyBox.TextSize = 14; keyBox.ClearTextOnFocus = false; keyBox.Parent = rightPanel
    local kbc = Instance.new("UICorner"); kbc.CornerRadius = UDim.new(0, 8); kbc.Parent = keyBox
    local kbs = Instance.new("UIStroke"); kbs.Color = COLORS.Stroke; kbs.Thickness = 1.5; kbs.Parent = keyBox
    
    keyBox.Focused:Connect(function() TweenService:Create(kbs, TweenInfo.new(0.2), {Color = COLORS.Accent1, Thickness = 2}):Play() end)
    keyBox.FocusLost:Connect(function() TweenService:Create(kbs, TweenInfo.new(0.2), {Color = COLORS.Stroke, Thickness = 1.5}):Play() end)

    local getBtn = Instance.new("TextButton"); getBtn.Size = UDim2.new(0.4, -20, 0, 45); getBtn.Position = UDim2.fromOffset(20, 205); getBtn.BackgroundColor3 = COLORS.Surface; getBtn.Text = "🔗 Get Key"; getBtn.TextColor3 = COLORS.Text; getBtn.Font = Enum.Font.GothamBold; getBtn.TextSize = 13; getBtn.AutoButtonColor = false; getBtn.Parent = rightPanel
    local gbc = Instance.new("UICorner"); gbc.CornerRadius = UDim.new(0, 8); gbc.Parent = getBtn
    local gbs = Instance.new("UIStroke"); gbs.Color = COLORS.Stroke; gbs.Parent = getBtn

    getBtn.MouseEnter:Connect(function() TweenService:Create(gbs, TweenInfo.new(0.2), {Color = COLORS.Accent1}):Play() end)
    getBtn.MouseLeave:Connect(function() TweenService:Create(gbs, TweenInfo.new(0.2), {Color = COLORS.Stroke}):Play() end)
    
    local verifyBtn = Instance.new("TextButton"); verifyBtn.Size = UDim2.new(0.6, -20, 0, 45); verifyBtn.Position = UDim2.new(0.4, 10, 0, 205); verifyBtn.BackgroundColor3 = COLORS.Accent1; verifyBtn.Text = "Verify & Continue"; verifyBtn.TextColor3 = COLORS.Text; verifyBtn.Font = Enum.Font.GothamBold; verifyBtn.TextSize = 14; verifyBtn.AutoButtonColor = false; verifyBtn.Parent = rightPanel
    local vbc = Instance.new("UICorner"); vbc.CornerRadius = UDim.new(0, 8); vbc.Parent = verifyBtn
    local vbg = Instance.new("UIGradient"); vbg.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, COLORS.Accent1), ColorSequenceKeypoint.new(1, COLORS.Accent2)}); vbg.Parent = verifyBtn

    -- Draggable
    local dragging, dragInput, dragStart, startPos
    header.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = window.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
    header.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

    -- المنطق
    local isCooldown = false
    getBtn.MouseButton1Click:Connect(function()
        if isCooldown then return end
        isCooldown = true
        
        if setclipboard then 
            local uniqueLink = KeySystem.LinkvertiseURL .. "?userId=" .. LocalPlayer.UserId
            pcall(setclipboard, uniqueLink) 
        end
        
        for i = 15, 1, -1 do
            getBtn.Text = "Wait " .. i .. "s"
            getBtn.TextColor3 = COLORS.TextDim
            task.wait(1)
        end
        
        getBtn.Text = "✅ Copied!"
        getBtn.TextColor3 = COLORS.Success
        task.wait(2)
        
        getBtn.Text = "🔗 Get Key"
        getBtn.TextColor3 = COLORS.Text
        isCooldown = false
    end)

    verifyBtn.MouseButton1Click:Connect(function()
        local k = keyBox.Text:gsub("%s+", "")
        if k == "" then kbs.Color = COLORS.Error; task.wait(0.5); kbs.Color = COLORS.Stroke; return end
        
        verifyBtn.Text = "⏳ Checking..."; verifyBtn.Active = false; vbg.Enabled = false
        
        if verifyKeyOnline(k) then
            saveData({key = k, expires = os.time() + KeySystem.Duration, hwid = KeySystem.HWID})
            isVerified = true
            
            verifyBtn.Text = "✅ Success"; verifyBtn.BackgroundColor3 = COLORS.Success
            task.wait(0.8)
            TweenService:Create(blur, TweenInfo.new(0.4), {Size = 0}):Play()
            TweenService:Create(uiScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0}):Play()
            task.wait(0.4); gui:Destroy()
        else
            verifyBtn.Text = "❌ Invalid Key"; verifyBtn.BackgroundColor3 = COLORS.Error
            task.wait(2); verifyBtn.Text = "Verify & Continue"; verifyBtn.BackgroundColor3 = COLORS.Accent1; vbg.Enabled = true; verifyBtn.Active = true
        end
    end)
end

-- ================= [6] التشغيل =================
if checkLocalSession() then
    isVerified = true
    showNotification("Slap Aura", "تم استرجاع المفتاح المحفوظ بنجاح!", true)
else
    createSupremeUI()
    while not isVerified do task.wait(0.1) end
    showNotification("Slap Aura", "تم التفعيل! جاري تشغيل السكربت...", true)
end

-- ⏳ تأخير بسيط لديلتا موبايل
task.wait(1.5) 

-- ================= [7] تحميل السكربت الأساسي =================
local success, err = pcall(function()
    if not isVerified then return end
    local code = game:HttpGet(KeySystem.ScriptURL)
    local func = loadstring(code)
    if func then func() else error("Failed to load script string") end
end)

if not success then
    showNotification("Error", "فشل تحميل السكربت، تأكد من الرابط.", false)
    warn("❌ Error: " .. tostring(err))
end