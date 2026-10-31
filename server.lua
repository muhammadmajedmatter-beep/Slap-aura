--[[
============================================================
🚀 STANDALONE SERVER HOPPER | Delta-Safe | Crash-Proof
============================================================
Features:
- Multi-method server fetching (syn.request / request / http_request / HttpGet)
- Auto server selection (avoids full servers)
- Draggable GUI with status updates
- Quick Teleport (random server)
- Rejoin Same Server
- Fully crash-proof (every call wrapped in pcall)
============================================================
]]

if _G.ServerHopRunning then
    warn("[Server Hopper] Already running!")
    return
end
_G.ServerHopRunning = true

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- 🎨 GUI CREATION
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ServerHopGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(320, 320)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 140, 0)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 14)
TitleBarCorner.Parent = TitleBar

local TitleBarCover = Instance.new("Frame")
TitleBarCover.Size = UDim2.new(1, 0, 0, 20)
TitleBarCover.Position = UDim2.new(0, 0, 1, -20)
TitleBarCover.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBarCover.BorderSizePixel = 0
TitleBarCover.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)
Title.BackgroundTransparency = 1
Title.Text = "🚀 Server Hopper"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(30, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -30, 0, 40)
StatusLabel.Position = UDim2.fromOffset(15, 55)
StatusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
StatusLabel.BackgroundTransparency = 0.3
StatusLabel.Text = "✅ Ready"
StatusLabel.TextColor3 = Color3.fromRGB(80, 220, 130)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = StatusLabel

-- Info Label
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -30, 0, 50)
InfoLabel.Position = UDim2.fromOffset(15, 105)
InfoLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
InfoLabel.BackgroundTransparency = 0.3
InfoLabel.Text = "Place ID: " .. tostring(game.PlaceId) .. "\nJob ID: " .. string.sub(game.JobId, 1, 12) .. "..."
InfoLabel.TextColor3 = Color3.fromRGB(160, 160, 175)
InfoLabel.Font = Enum.Font.Code
InfoLabel.TextSize = 11
InfoLabel.TextWrapped = true
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.Parent = MainFrame

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 6)
InfoCorner.Parent = InfoLabel

-- Find Server Button
local HopBtn = Instance.new("TextButton")
HopBtn.Size = UDim2.new(1, -30, 0, 50)
HopBtn.Position = UDim2.fromOffset(15, 165)
HopBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
HopBtn.Text = "🔍 Find & Join New Server"
HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBtn.Font = Enum.Font.GothamBold
HopBtn.TextSize = 14
HopBtn.BorderSizePixel = 0
HopBtn.AutoButtonColor = false
HopBtn.Parent = MainFrame

local HopCorner = Instance.new("UICorner")
HopCorner.CornerRadius = UDim.new(0, 8)
HopCorner.Parent = HopBtn

-- Quick Teleport Button
local QuickBtn = Instance.new("TextButton")
QuickBtn.Size = UDim2.new(1, -30, 0, 40)
QuickBtn.Position = UDim2.fromOffset(15, 225)
QuickBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 220)
QuickBtn.Text = "⚡ Quick Teleport (Random)"
QuickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
QuickBtn.Font = Enum.Font.GothamBold
QuickBtn.TextSize = 13
QuickBtn.BorderSizePixel = 0
QuickBtn.AutoButtonColor = false
QuickBtn.Parent = MainFrame

local QuickCorner = Instance.new("UICorner")
QuickCorner.CornerRadius = UDim.new(0, 8)
QuickCorner.Parent = QuickBtn

-- Rejoin Button
local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Size = UDim2.new(1, -30, 0, 35)
RejoinBtn.Position = UDim2.fromOffset(15, 275)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 220)
RejoinBtn.Text = "🔄 Rejoin Same Server"
RejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.TextSize = 12
RejoinBtn.BorderSizePixel = 0
RejoinBtn.AutoButtonColor = false
RejoinBtn.Parent = MainFrame

local RejoinCorner = Instance.new("UICorner")
RejoinCorner.CornerRadius = UDim.new(0, 8)
RejoinCorner.Parent = RejoinBtn

-- ============================================================
-- 🎯 HELPER FUNCTIONS
-- ============================================================
local function SetStatus(text, isSuccess)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = isSuccess and Color3.fromRGB(80, 220, 130) or Color3.fromRGB(255, 180, 80)
end

local function ResetButtons()
    HopBtn.Text = "🔍 Find & Join New Server"
    HopBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    QuickBtn.Text = "⚡ Quick Teleport (Random)"
    QuickBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 220)
    RejoinBtn.Text = "🔄 Rejoin Same Server"
    RejoinBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 220)
end

local function FetchServers()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local response = nil
    local method = "None"
    
    -- Method 1: syn.request
    if syn and syn.request then
        local ok, res = pcall(function()
            return syn.request({Url = url, Method = "GET"})
        end)
        if ok and res and res.Body and res.Body ~= "" then
            response = res.Body
            method = "syn.request"
        end
    end
    
    -- Method 2: request
    if not response and request then
        local ok, res = pcall(function()
            return request({Url = url, Method = "GET"})
        end)
        if ok and res and res.Body and res.Body ~= "" then
            response = res.Body
            method = "request"
        end
    end
    
    -- Method 3: http_request
    if not response and http_request then
        local ok, res = pcall(function()
            return http_request({Url = url, Method = "GET"})
        end)
        if ok and res and res.Body and res.Body ~= "" then
            response = res.Body
            method = "http_request"
        end
    end
    
    -- Method 4: game:HttpGet
    if not response then
        local ok, res = pcall(function()
            return game:HttpGet(url)
        end)
        if ok and res and res ~= "" then
            response = res
            method = "HttpGet"
        end
    end
    
    return response, method
end

-- ============================================================
-- 🚀 HOP LOGIC
-- ============================================================
local function HopToNewServer()
    SetStatus("⏳ Fetching server list...", false)
    HopBtn.Text = "⏳ Searching..."
    HopBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    task.spawn(function()
        local response, method = FetchServers()
        
        if not response then
            SetStatus("❌ Failed to fetch servers\nExecutor may block HTTP", false)
            ResetButtons()
            return
        end
        
        print("[Server Hopper] Fetched via:", method)
        
        local ok, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        
        if not ok or not data or not data.data then
            SetStatus("❌ Invalid server data", false)
            ResetButtons()
            return
        end
        
        local validServers = {}
        for _, server in ipairs(data.data) do
            if server.playing < (server.maxPlayers * 0.95) and server.id ~= game.JobId then
                table.insert(validServers, server)
            end
        end
        
        if #validServers == 0 then
            SetStatus("❌ No available servers found", false)
            ResetButtons()
            return
        end
        
        local chosen = validServers[math.random(1, #validServers)]
        SetStatus("✅ Found! Joining... (" .. chosen.playing .. "/" .. chosen.maxPlayers .. ")", true)
        HopBtn.Text = "⏳ Teleporting..."
        print("[Server Hopper] Joining:", chosen.id, "| Players:", chosen.playing .. "/" .. chosen.maxPlayers)
        
        task.wait(1)
        
        local tpOk = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, chosen.id, LocalPlayer)
        end)
        
        if not tpOk then
            SetStatus("⚠️ TeleportToPlaceInstance blocked\nTrying basic teleport...", false)
            task.wait(1)
            pcall(function()
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end)
        end
    end)
end

local function QuickTeleport()
    SetStatus("⚡ Quick teleporting...", true)
    QuickBtn.Text = "⏳ Teleporting..."
    QuickBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    task.wait(0.5)
    
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end

local function RejoinSame()
    SetStatus("🔄 Rejoining same server...", true)
    RejoinBtn.Text = "⏳ Rejoining..."
    RejoinBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    task.wait(0.5)
    
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end

-- ============================================================
-- 🔌 CONNECTIONS
-- ============================================================
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    _G.ServerHopRunning = false
end)

HopBtn.MouseButton1Click:Connect(HopToNewServer)
QuickBtn.MouseButton1Click:Connect(QuickTeleport)
RejoinBtn.MouseButton1Click:Connect(RejoinSame)

-- ============================================================
-- 📊 CONSOLE INFO
-- ============================================================
print("═══════════════════════════════════════════")
print("🚀 [Server Hopper] Loaded Successfully!")
print("📌 Place ID:", game.PlaceId)
print("📌 Job ID:", game.JobId)
print("📌 Players:", #Players:GetPlayers() .. "/" .. Players.MaxPlayers)
print("📌 syn.request:", type(syn and syn.request))
print("📌 request:", type(request))
print("📌 http_request:", type(http_request))
print("═══════════════════════════════════════════")