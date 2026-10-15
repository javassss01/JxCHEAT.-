-- Target: Roblox Universal / Mobile Runtimes (Delta)
-- Description: Part 1 - Floating JXCHEAT Toggle Button, Menu Containers & Skeletal ESP Engine

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local CFG = {
    ESPEnabled = true,
    TeamCheck = false,
    AutoHeadshot = true,
    FOV = 200,
    TracerOrigin = Vector2.new(Camera.ViewportSize.X / 2, 0),
    BoxColor = Color3.fromRGB(255, 40, 40),
    TracerColor = Color3.fromRGB(255, 30, 30),
}

if CoreGui:FindFirstChild("JXCheatGui") then
    CoreGui.JXCheatGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JXCheatGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Floating Toggle Button (JXCHEAT Badge Style)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "JXCheatButton"
ToggleButton.Size = UDim2.new(0, 75, 0, 75)
ToggleButton.Position = UDim2.new(0, 40, 0.4, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
ToggleButton.BorderSizePixel = 0
ToggleButton.TextColor3 = Color3.fromRGB(255, 100, 255)
ToggleButton.TextSize = 12
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "JX\nCHEAT"
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 12)
local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(200, 50, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleButton

local function create_menu(name, posX, posY)
    local Frame = Instance.new("Frame")
    Frame.Name = name
    Frame.Size = UDim2.new(0, 160, 0, 200)
    Frame.Position = UDim2.new(0, posX, 0, posY)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Frame.BorderColor3 = Color3.fromRGB(60, 60, 70)
    Frame.Visible = false -- Hidden by default, toggled via JXCHEAT floating button
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    TitleBar.Parent = Frame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.Position = UDim2.new(0, 8, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 13
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Text = name
    TitleLabel.Parent = TitleBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 22, 0, 22)
    CloseBtn.Position = UDim2.new(1, -25, 0, 4)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 12
    CloseBtn.Font = Enum.Font.SourceSansBold
    CloseBtn.Text = "X"
    CloseBtn.Parent = TitleBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

    local ContentContainer = Instance.new("ScrollingFrame")
    ContentContainer.Size = UDim2.new(1, 0, 1, -30)
    ContentContainer.Position = UDim2.new(0, 0, 0, 30)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.ScrollBarThickness = 2
    ContentContainer.Parent = Frame

    local UIList = Instance.new("UIListLayout")
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 5)
    UIList.Parent = ContentContainer

    CloseBtn.MouseButton1Click:Connect(function()
        Frame.Visible = false
    end)

    return Frame, ContentContainer
end

local ESPFrame, ESPContainer = create_menu("ESP Menu", 130, 90)
local HeadshotFrame, HeadshotContainer = create_menu("Headshot Menu", 300, 90)

-- Toggle Menu Visibility on JXCHEAT Button Click
local menuVisible = false
ToggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    ESPFrame.Visible = menuVisible
    HeadshotFrame.Visible = menuVisible
end)

local function add_toggle(parent, text, defaultState, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 32)
    Btn.Position = UDim2.new(0, 5, 0, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Btn.TextColor3 = defaultState and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 60, 60)
    Btn.TextSize = 12
    Btn.Font = Enum.Font.SourceSansSemibold
    Btn.Text = text .. (defaultState and ": ON" or ": OFF")
    Btn.Parent = parent

    local state = defaultState
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = text .. (state and ": ON" or ": OFF")
        Btn.TextColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 60, 60)
        callback(state)
    end)
end

add_toggle(ESPContainer, "ESP Master", CFG.ESPEnabled, function(v) CFG.ESPEnabled = v end)
add_toggle(ESPContainer, "Team Check", CFG.TeamCheck, function(v) CFG.TeamCheck = v end)
add_toggle(HeadshotContainer, "Auto Headshot", CFG.AutoHeadshot, function(v) CFG.AutoHeadshot = v end)

local drawings = {}

local function safe(fn)
    local ok, err = pcall(fn)
    if not ok then warn("[KEEL]", err) end
end

local function get_root(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
end

local function get_head(char)
    return char and char:FindFirstChild("Head")
end

local function create_esp(plr)
    safe(function()
        if drawings[plr] then return end
        
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = CFG.BoxColor
        box.Thickness = 1.5
        box.Filled = false

        local healthBg = Drawing.new("Line")
        healthBg.Visible = false
        healthBg.Color = Color3.fromRGB(40, 40, 40)
        healthBg.Thickness = 2.5

        local healthBar = Drawing.new("Line")
        healthBar.Visible = false
        healthBar.Color = Color3.fromRGB(0, 255, 100)
        healthBar.Thickness = 1.5

        local bones = {"Head", "UpperTorso", "LeftUpperArm", "RightUpperArm"}
        local boneTracers = {}
        for _, bone in ipairs(bones) do
            local line = Drawing.new("Line")
            line.Visible = false
            line.Color = CFG.TracerColor
            line.Thickness = 1
            boneTracers[bone] = line
        end

        drawings[plr] = {
            box = box,
            healthBg = healthBg,
            healthBar = healthBar,
            boneTracers = boneTracers,
            bones = bones
        }
    end)
end

local function remove_esp(plr)
    safe(function()
        local d = drawings[plr]
        if d then
            d.box:Remove()
            d.healthBg:Remove()
            d.healthBar:Remove()
            for _, line in pairs(d.boneTracers) do line:Remove() end
            drawings[plr] = nil
        end
    end)
end

local function world_to_screen(pos)
    local screen, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(screen.X, screen.Y), onScreen, screen.Z
end

RunService.Heartbeat:Connect(function()
    if not CFG.ESPEnabled then
        for _, d in pairs(drawings) do
            d.box.Visible = false
            d.healthBg.Visible = false
            d.healthBar.Visible = false
            for _, line in pairs(d.boneTracers) do line.Visible = false end
        end
        return
    end

    CFG.TracerOrigin = Vector2.new(Camera.ViewportSize.X / 2, 0)

    for plr, d in pairs(drawings) do
        safe(function()
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = get_root(char)
            local head = get_head(char)

            if not char or not hum or hum.Health <= 0 or not root or not head or (CFG.TeamCheck and plr.Team == LocalPlayer.Team) then
                d.box.Visible = false
                d.healthBg.Visible = false
                d.healthBar.Visible = false
                for _, line in pairs(d.boneTracers) do line.Visible = false end
                return
            end

            local topPos = (head.CFrame * CFrame.new(0, 0.8, 0)).Position
            local botPos = (root.CFrame * CFrame.new(0, -2.8, 0)).Position
            local top, _, topDepth = world_to_screen(topPos)
            local bot, _, botDepth = world_to_screen(botPos)

            if topDepth < 0 and botDepth < 0 then
                d.box.Visible = false
                d.healthBg.Visible = false
                d.healthBar.Visible = false
                for _, line in pairs(d.boneTracers) do line.Visible = false end
                return
            end

            local height = math.abs(top.Y - bot.Y)
            local width = height * 0.55

            d.box.Size = Vector2.new(width, height)
            d.box.Position = Vector2.new(top.X - width / 2, top.Y)
            d.box.Visible = true

            local currentMaxHealth = hum.MaxHealth > 0 and hum.MaxHealth or 100
            local healthPct = math.clamp(hum.Health / currentMaxHealth, 0, 1)

            local barX = top.X - width / 2 - 6
            d.healthBg.From = Vector2.new(barX, bot.Y)
            d.healthBg.To = Vector2.new(barX, top.Y)
            d.healthBg.Visible = true

            local healthHeight = height * healthPct
            d.healthBar.From = Vector2.new(barX, bot.Y)
            d.healthBar.To = Vector2.new(barX, bot.Y - healthHeight)
            d.healthBar.Visible = true

            for _, boneName in ipairs(d.bones) do
                local bonePart = char:FindFirstChild(boneName)
                local line = d.boneTracers[boneName]
                if bonePart and line then
                    local screenPos, _, depth = world_to_screen(bonePart.Position)
                    if depth > 0 then
                        line.From = CFG.TracerOrigin
                        line.To = screenPos
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end
        end)
    end
end)
-- Target: Roblox Universal / Mobile Runtimes (Delta)
-- Description: Part 2 - Auto-Headshot Hook & Player Lifecycle Management

local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function get_closest_head()
    local closest, shortestDist = nil, CFG.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local isEnemy = not CFG.TeamCheck or (plr.Team ~= LocalPlayer.Team)
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local head = get_head(plr.Character)
            
            if isEnemy and hum and hum.Health > 0 and head then
                local screenPos, _, depth = world_to_screen(head.Position)
                if depth > 0 then
                    local dist = (screenPos - center).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closest = head
                    end
                end
            end
        end
    end
    return closest
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if CFG.AutoHeadshot and (method == "FireServer" or method == "InvokeServer") then
        local target = get_closest_head()
        if target then
            for i, arg in ipairs(args) do
                local t = typeof(arg)
                if t == "Instance" and arg:IsA("BasePart") then
                    args[i] = target
                elseif t == "Vector3" then
                    args[i] = target.Position
                elseif t == "CFrame" then
                    args[i] = target.CFrame
                elseif t == "table" then
                    for k, v in pairs(arg) do
                        if typeof(v) == "Instance" and v:IsA("BasePart") then
                            arg[k] = target
                        elseif typeof(v) == "Vector3" then
                            arg[k] = target.Position
                        elseif typeof(v) == "CFrame" then
                            arg[k] = target.CFrame
                        end
                    end
                end
            end
            return oldNamecall(self, unpack(args))
        end
    end
    
    return oldNamecall(self, ...)
end))

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        create_esp(p)
        p.CharacterAdded:Connect(function() create_esp(p) end)
    end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        create_esp(p)
        p.CharacterAdded:Connect(function() create_esp(p) end)
    end
end)

Players.PlayerRemoving:Connect(remove_esp)

print("[KEEL] JXCHEAT Hub Loaded Successfully")
