-- Получаем сервисы
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

-- Получаем LocalPlayer
local PLAYER = Players.LocalPlayer
local CC = workspace.CurrentCamera

-- Создаем ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScriptControlUI"
ScreenGui.Parent = PLAYER.PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true

-- Создаем главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.02, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.ClipsDescendants = true

-- Добавляем закругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- Перетаскивание UI
local dragging = false
local dragStart = nil
local startPos = nil

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Уведомление
local Notification = Instance.new("TextLabel")
Notification.Size = UDim2.new(0, 200, 0, 30)
Notification.Position = UDim2.new(0.5, -100, 0.1, 0)
Notification.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
Notification.TextColor3 = Color3.fromRGB(200, 150, 255)
Notification.TextSize = 16
Notification.Text = ""
Notification.Parent = ScreenGui
Notification.Visible = false

local NotificationCorner = Instance.new("UICorner")
NotificationCorner.CornerRadius = UDim.new(0, 10)
NotificationCorner.Parent = Notification

-- Функция для показа уведомления
local function showNotification(text, duration)
    Notification.Text = text
    Notification.Visible = true
    wait(duration)
    Notification.Visible = false
end

-- Заголовок "be a pro"
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(20, 10, 40)
TitleLabel.Text = "be a pro"
TitleLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleLabel

-- Добавляем "Made by Hermitage"
local MadeByLabel = Instance.new("TextLabel")
MadeByLabel.Size = UDim2.new(1, 0, 0, 20)
MadeByLabel.Position = UDim2.new(0, 0, 0.9, 0)
MadeByLabel.BackgroundTransparency = 1
MadeByLabel.Text = "Made by Hermitage"
MadeByLabel.TextColor3 = Color3.fromRGB(150, 100, 200)
MadeByLabel.TextSize = 12
MadeByLabel.Font = Enum.Font.SourceSansBold
MadeByLabel.Parent = MainFrame

-- Создаем фрейм для вкладок (слева)
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(0.3, 0, 0.85, 0)
TabsFrame.Position = UDim2.new(0, 0, 0.15, 0)
TabsFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 40)
TabsFrame.Parent = MainFrame

local TabsCorner = Instance.new("UICorner")
TabsCorner.CornerRadius = UDim.new(0, 10)
TabsCorner.Parent = TabsFrame

-- Создаем фрейм для содержимого (справа)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0.65, 0, 0.85, 0)
ContentFrame.Position = UDim2.new(0.35, 0, 0.15, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentFrame

-- Функция для создания вкладки
local function createTab(name, positionY, callback)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.Position = UDim2.new(0, 0, 0, positionY)
    tabButton.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(200, 150, 255)
    tabButton.TextSize = 18
    tabButton.Font = Enum.Font.SourceSansBold
    tabButton.Parent = TabsFrame

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = tabButton

    tabButton.MouseButton1Click:Connect(function()
        for _, child in pairs(TabsFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
            end
        end
        tabButton.BackgroundColor3 = Color3.fromRGB(70, 50, 90)
        callback()
    end)

    return tabButton
end

-- Функция для создания кнопки переключения
local function createToggleButton(name, positionY, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.Position = UDim2.new(0, 0, 0, positionY)
    frame.BackgroundTransparency = 1
    frame.Parent = ContentFrame
    frame.Visible = false

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 150, 255)
    label.TextSize = 18
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.3, 0, 0.7, 0)
    button.Position = UDim2.new(0.7, 0, 0.15, 0)
    button.Text = "OFF"
    button.TextColor3 = Color3.fromRGB(255, 100, 100)
    button.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
    button.TextSize = 16
    button.Font = Enum.Font.SourceSansBold
    button.Parent = frame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = button

    local isEnabled = false
    button.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        button.Text = isEnabled and "ON" or "OFF"
        button.TextColor3 = isEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        callback(isEnabled)
    end)

    return frame
end

-- Переменные состояния
local autodiveEnabled = false
local chatSpyEnabled = false
local tiltEnabled = false
local autoRecEnabled = false

-- Marker для Autodive и Autorec
local Marker = Instance.new("Part")
Marker.Name = "Marker"
Marker.Size = Vector3.new(2, 2, 2)
Marker.Shape = Enum.PartType.Ball
Marker.BrickColor = BrickColor.new("Bright violet")
Marker.CanCollide = false
Marker.Anchored = true
Marker.Parent = workspace
Marker.Transparency = 1
Marker.Material = Enum.Material.Neon

local MARKER_RADIUS = 18
local MARKER_RADIUS_AUTOREC = 20
local lastMoveTime = 0
local MOVE_COOLDOWN = 0.1

local function PHYSICS_STUFF(velocity, position)
    local acceleration = -workspace.Gravity
    local timeToLand = (-velocity.y - math.sqrt(velocity.y * velocity.y - 4 * 0.5 * acceleration * position.y)) / (2 * 0.5 * acceleration)
    local horizontalVelocity = Vector3.new(velocity.x, 0, velocity.z)
    local landingPosition = position + horizontalVelocity * timeToLand + Vector3.new(0, -position.y, 0)
    return landingPosition
end

local function moveToMarker(targetPosition)
    local character = PLAYER.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            humanoid.WalkSpeed = 16
            humanoid.WalkToPoint = targetPosition
        end
    end
end

-- Открытие/закрытие UI по F1
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F1 and not gameProcessed then
        MainFrame.Visible = not MainFrame.Visible
        showNotification(MainFrame.Visible and "UI Opened" or "UI Closed", 1)
    end
end)

-- Ждём, пока мяч появится в игре (для Autodive), с таймаутом
local ballFound = false
local waitTime = 0
local maxWaitTime = 5
while not ballFound and waitTime < maxWaitTime do
    if workspace:FindFirstChild("Ball") then
        ballFound = true
        break
    end
    wait(0.1)
    waitTime = waitTime + 0.1
end

-- AutoRec логика (движение к мячу)
RunService:BindToRenderStep("AutoRec", Enum.RenderPriority.Camera.Value, function()
    if autoRecEnabled then
        for _, ballModel in ipairs(workspace:GetChildren()) do
            if ballModel:IsA("Model") and ballModel.Name == "Ball" then
                local ball = ballModel:FindFirstChild("BallPart")
                if ball then
                    local initialVelocity = ballModel.Velocity
                    local landingPosition = PHYSICS_STUFF(initialVelocity.Value, ball.Position)
                    Marker.CFrame = CFrame.new(landingPosition)

                    local playerPosition = PLAYER.Character and PLAYER.Character.PrimaryPart and PLAYER.Character.PrimaryPart.Position
                    if playerPosition and (landingPosition - playerPosition).Magnitude <= MARKER_RADIUS_AUTOREC then
                        if tick() - lastMoveTime >= MOVE_COOLDOWN then
                            moveToMarker(landingPosition)
                            lastMoveTime = tick()
                        end
                    end
                end
            end
        end
    end
end)

-- Autodive логика (фиксация камеры с управлением через UI и L.Ctrl)
local cameraLockEnabled = false

RunService:BindToRenderStep("VisualizeLandingPosition", Enum.RenderPriority.Camera.Value, function()
    for _, ballModel in ipairs(workspace:GetChildren()) do
        if ballModel:IsA("Model") and ballModel.Name == "Ball" then
            local ball = ballModel:FindFirstChild("BallPart")
            if ball then
                local initialVelocity = ballModel.Velocity
                local landingPosition = PHYSICS_STUFF(initialVelocity.Value, ball.Position)
                Marker.CFrame = CFrame.new(landingPosition)

                local playerPosition = PLAYER.Character and PLAYER.Character.PrimaryPart and PLAYER.Character.PrimaryPart.Position
                if playerPosition and (landingPosition - playerPosition).Magnitude <= MARKER_RADIUS then
                    if cameraLockEnabled and autodiveEnabled then
                        CC.CFrame = CFrame.new(CC.CFrame.p, landingPosition)
                    end
                end
            end
        end
    end
end)

-- Обработка ЗАЖАТИЯ L.Ctrl
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.LeftControl and not gameProcessed then
        cameraLockEnabled = true
    end
end)

-- Обработка ОТПУСКАНИЯ L.Ctrl
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        cameraLockEnabled = false
    end
end)

-- ChatSpy логика
local spyOnMyself = true
local public = false
local publicItalics = true
local privateProperties = {
    Color = Color3.fromRGB(0, 255, 255),
    Font = Enum.Font.SourceSansBold,
    TextSize = 18
}
local saymsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
local getmsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")

local function onChatted(p, msg)
    if chatSpyEnabled then
        if p == PLAYER and msg:lower():sub(1, 4) == "/spy" then return end
        if spyOnMyself or p ~= PLAYER then
            msg = msg:gsub("[\n\r]", ''):gsub("\t", ' '):gsub("[ ]+", ' ')
            local hidden = true
            local conn = getmsg.OnClientEvent:Connect(function(packet, channel)
                if packet.SpeakerUserId == p.UserId and packet.Message == msg:sub(#msg - #packet.Message + 1) then
                    hidden = false
                end
            end)
            wait(1)
            conn:Disconnect()
            if hidden then
                if public then
                    saymsg:FireServer((publicItalics and "/me " or '') .. "{SPY} [" .. p.Name .. "]: " .. msg, "All")
                else
                    privateProperties.Text = "{SPY} [" .. p.Name .. "]: " .. msg
                    StarterGui:SetCore("ChatMakeSystemMessage", privateProperties)
                end
            end
        end
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    p.Chatted:Connect(function(msg) onChatted(p, msg) end)
end
Players.PlayerAdded:Connect(function(p)
    p.Chatted:Connect(function(msg) onChatted(p, msg) end)
end)

-- TiltScript логика
local function applyTilt(enabled)
    if enabled and PLAYER.Character and PLAYER.Character:FindFirstChild("HumanoidRootPart") then
        local tilt = PLAYER.Character.HumanoidRootPart:FindFirstChild("Tilt")
        if tilt then
            tilt.P = 5200
        end
    end
end

-- Создаем кнопки в категории Cheats
local AutoRecButton = createToggleButton("AUTOREC", 10, function(state)
    autoRecEnabled = state
    if not state and PLAYER.Character and PLAYER.Character:FindFirstChild("Humanoid") then
        PLAYER.Character.Humanoid.WalkToPoint = PLAYER.Character.HumanoidRootPart.Position
    end
end)

local AutoDiveButton = createToggleButton("AUTODIVE", 50, function(state)
    autodiveEnabled = state
end)

local ChatLogsButton = createToggleButton("CHATLOGS", 90, function(state)
    chatSpyEnabled = state
    privateProperties.Text = "{SPY " .. (state and "EN" or "DIS") .. "ABLED}"
    StarterGui:SetCore("ChatMakeSystemMessage", privateProperties)
end)

local TiltScriptButton = createToggleButton("TILTSCRIPT", 130, function(state)
    tiltEnabled = state
    applyTilt(state)
end)

-- Создаем содержимое для вкладки INFO
local InfoContent = Instance.new("Frame")
InfoContent.Size = UDim2.new(1, 0, 1, 0)
InfoContent.Position = UDim2.new(0, 0, 0, 0)
InfoContent.BackgroundTransparency = 1
InfoContent.Parent = ContentFrame
InfoContent.Visible = false

local ContactLabel = Instance.new("TextLabel")
ContactLabel.Size = UDim2.new(1, 0, 0, 30)
ContactLabel.Position = UDim2.new(0, 0, 0, 20)
ContactLabel.BackgroundTransparency = 1
ContactLabel.Text = "DISCORD: @truthautodive"
ContactLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
ContactLabel.TextSize = 17
ContactLabel.Font = Enum.Font.SourceSansBold
ContactLabel.Parent = InfoContent

-- Функция для скрытия всего содержимого
local function hideAllContent()
    AutoRecButton.Visible = false
    AutoDiveButton.Visible = false
    ChatLogsButton.Visible = false
    TiltScriptButton.Visible = false
    InfoContent.Visible = false
end

-- Создаем вкладки
createTab("Cheats", 0, function()
    hideAllContent()
    AutoRecButton.Visible = true
    AutoDiveButton.Visible = true
    ChatLogsButton.Visible = true
    TiltScriptButton.Visible = true
end)

createTab("INFO", 40, function()
    hideAllContent()
    InfoContent.Visible = true
end)

-- По умолчанию показываем Cheats
hideAllContent()
AutoRecButton.Visible = true
AutoDiveButton.Visible = true
ChatLogsButton.Visible = true
TiltScriptButton.Visible = true
