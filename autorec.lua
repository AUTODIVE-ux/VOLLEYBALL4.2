-- Ждём, пока мяч появится в игре
repeat wait() until workspace:FindFirstChild("Ball")

-- Получаем сервисы
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Получаем LocalPlayer и его камеру
local PLAYER = Players.LocalPlayer
local CC = workspace.CurrentCamera

-- Создаём маркер (невидимый)
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

-- Радиус, в пределах которого маркер считается "рядом" с персонажем
local MARKER_RADIUS = 20

-- Создаём UI для текстового сообщения
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PLAYER.PlayerGui

local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = ScreenGui
TextLabel.Text = "Autodive: OFF"
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Position = UDim2.new(0.8, 0, 0.9, 0)
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextSize = 20
TextLabel.BackgroundTransparency = 1
TextLabel.TextStrokeTransparency = 0.5
TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)

-- Функция для расчёта позиции падения мяча
local function PHYSICS_STUFF(velocity, position)
    local acceleration = -workspace.Gravity
    local timeToLand = (-velocity.y - math.sqrt(velocity.y * velocity.y - 4 * 0.5 * acceleration * position.y)) / (2 * 0.5 * acceleration)
    local horizontalVelocity = Vector3.new(velocity.x, 0, velocity.z)
    local landingPosition = position + horizontalVelocity * timeToLand + Vector3.new(0, -position.y, 0)
    return landingPosition
end

-- Функция для плавного перемещения персонажа к маркеру
local function moveToMarker(targetPosition)
    local character = PLAYER.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            -- Устанавливаем точку назначения для естественного движения
            humanoid.WalkSpeed = 16 -- Стандартная скорость ходьбы (можно настроить)
            humanoid.WalkToPoint = targetPosition
        end
    end
end

-- Переменная для включения/выключения Autodive
local autodiveEnabled = false
local lastMoveTime = 0 -- Для предотвращения спама движений
local MOVE_COOLDOWN = 0.1 -- Задержка в секундах между обновлениями движения

-- Основной цикл
RunService:BindToRenderStep("VisualizeLandingPosition", Enum.RenderPriority.Camera.Value, function()
    for _, ballModel in ipairs(workspace:GetChildren()) do
        if ballModel:IsA("Model") and ballModel.Name == "Ball" then
            local ball = ballModel:FindFirstChild("BallPart")
            if ball then
                local initialVelocity = ballModel.Velocity
                local landingPosition = PHYSICS_STUFF(initialVelocity.Value, ball.Position)
                Marker.CFrame = CFrame.new(landingPosition)

                local playerPosition = PLAYER.Character and PLAYER.Character.PrimaryPart and PLAYER.Character.PrimaryPart.Position
                if playerPosition and (landingPosition - playerPosition).Magnitude <= MARKER_RADIUS and autodiveEnabled then
                    -- Проверяем задержку, чтобы движение не обновлялось слишком часто
                    if tick() - lastMoveTime >= MOVE_COOLDOWN then
                        moveToMarker(landingPosition)
                        lastMoveTime = tick()
                    end
                end
            end
        end
    end
end)

-- Обработка нажатия L.Ctrl
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Four and not gameProcessed then
        autodiveEnabled = not autodiveEnabled
        TextLabel.Text = autodiveEnabled and "Autodive: ON" or "Autodive: OFF"
        
        -- Останавливаем движение при выключении Autodive
        if not autodiveEnabled and PLAYER.Character and PLAYER.Character:FindFirstChild("Humanoid") then
            PLAYER.Character.Humanoid.WalkToPoint = PLAYER.Character.HumanoidRootPart.Position
        end
    end
end)
