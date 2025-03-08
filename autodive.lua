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
Marker.Transparency = 1  -- Полностю прозрачный
Marker.Material = Enum.Material.Neon

-- Переменная для включения/выключения фиксации камеры
local cameraLockEnabled = false

-- Радиус, в пределах которого маркер считается "рядом" с персонажем
local MARKER_RADIUS = 20

-- Функция для расчёта позиции падения мяча
local function PHYSICS_STUFF(velocity, position)
    local acceleration = -workspace.Gravity
    local timeToLand = (-velocity.y - math.sqrt(velocity.y * velocity.y - 4 * 0.5 * acceleration * position.y)) / (2 * 0.5 * acceleration)
    local horizontalVelocity = Vector3.new(velocity.x, 0, velocity.z)
    local landingPosition = position + horizontalVelocity * timeToLand + Vector3.new(0, -position.y, 0)
    return landingPosition
end

-- Основной цикл
RunService:BindToRenderStep("VisualizeLandingPosition", Enum.RenderPriority.Camera.Value, function()
    -- Поиск мяча
    for _, ballModel in ipairs(workspace:GetChildren()) do
        if ballModel:IsA("Model") and ballModel.Name == "Ball" then
            local ball = ballModel:FindFirstChild("BallPart")
            if ball then
                -- Рассчитываем позицию падения
                local initialVelocity = ballModel.Velocity
                local landingPosition = PHYSICS_STUFF(initialVelocity.Value, ball.Position)
                Marker.CFrame = CFrame.new(landingPosition)

                -- Проверяем, находится ли маркер рядом с персонажем
                local playerPosition = PLAYER.Character and PLAYER.Character.PrimaryPart and PLAYER.Character.PrimaryPart.Position
                if playerPosition and (landingPosition - playerPosition).Magnitude <= MARKER_RADIUS then
                    -- Фиксация камеры на маркере, если включена
                    if cameraLockEnabled then
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
        cameraLockEnabled = true  -- Включаем фиксацию камеры
    end
end)

-- Обработка ОТПУСКАНИЯ L.Ctrl
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        cameraLockEnabled = false  -- Выключаем фиксацию камеры
    end
end)
