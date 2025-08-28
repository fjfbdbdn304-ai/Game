local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield', true))()
local Window = Rayfield:CreateWindow({
    Name = "Murders vs Sheriffs Duels",
    LoadingTitle = "Legitbtw",
    LoadingSubtitle = "by gamb1t_psi",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- Speed Hack System
local speedHackEnabled = false
local defaultWalkSpeed = 16
local customWalkSpeed = 25

local function updateSpeed()
    if game.Players.LocalPlayer.Character then
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            if speedHackEnabled then
                humanoid.WalkSpeed = customWalkSpeed
            else
                humanoid.WalkSpeed = defaultWalkSpeed
            end
        end
    end
end

local SpeedToggle = MainTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Callback = function(Value)
        speedHackEnabled = Value
        updateSpeed()
    end,
})

local SpeedSlider = MainTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 25,
    Callback = function(Value)
        customWalkSpeed = Value
        if speedHackEnabled then
            updateSpeed()
        end
    end,
})

-- Hitbox System
local hitboxSize = 5
local hitboxEnabled = false
local originalSizes = {}

local function expandHitboxes()
    if not hitboxEnabled then return end
    
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                if not originalSizes[player] then
                    originalSizes[player] = {
                        Head = player.Character:FindFirstChild("Head") and player.Character.Head.Size,
                        Torso = player.Character:FindFirstChild("Torso") and player.Character.Torso.Size,
                        HumanoidRootPart = rootPart.Size
                    }
                end
                
                if player.Character:FindFirstChild("Head") then
                    player.Character.Head.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    player.Character.Head.CanCollide = false
                end
                
                if player.Character:FindFirstChild("Torso") then
                    player.Character.Torso.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    player.Character.Torso.CanCollide = false
                end
                
                rootPart.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                rootPart.CanCollide = false
            end
        end
    end
end

local function restoreHitboxes()
    for player, sizes in pairs(originalSizes) do
        if player.Character then
            if player.Character:FindFirstChild("Head") and sizes.Head then
                player.Character.Head.Size = sizes.Head
                player.Character.Head.CanCollide = true
            end
            
            if player.Character:FindFirstChild("Torso") and sizes.Torso then
                player.Character.Torso.Size = sizes.Torso
                player.Character.Torso.CanCollide = true
            end
            
            if player.Character:FindFirstChild("HumanoidRootPart") and sizes.HumanoidRootPart then
                player.Character.HumanoidRootPart.Size = sizes.HumanoidRootPart
                player.Character.HumanoidRootPart.CanCollide = true
            end
        end
        originalSizes[player] = nil
    end
end

local HitboxToggle = MainTab:CreateToggle({
    Name = "Hitbox Expansion",
    CurrentValue = false,
    Callback = function(Value)
        hitboxEnabled = Value
        if Value then
            expandHitboxes()
        else
            restoreHitboxes()
        end
    end,
})

local HitboxSizeSlider = MainTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(Value)
        hitboxSize = Value
        if hitboxEnabled then
            expandHitboxes()
        end
    end,
})

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

-- Chams System
local ChamsEnabled = false
local playerHighlights = {}

local function applyChams(player)
    if player ~= game.Players.LocalPlayer and player.Character then
        if playerHighlights[player] then
            playerHighlights[player]:Destroy()
        end
        
        local highlight = Instance.new("Highlight")
        highlight.Parent = game.CoreGui
        highlight.Adornee = player.Character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        playerHighlights[player] = highlight
        
        player.CharacterAdded:Connect(function(char)
            if ChamsEnabled then
                task.wait(1)
                applyChams(player)
            end
        end)
    end
end

local ChamsToggle = VisualsTab:CreateToggle({
    Name = "Wallhack (Chams)",
    CurrentValue = false,
    Callback = function(Value)
        ChamsEnabled = Value
        if Value then
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    applyChams(player)
                end
            end
        else
            for player, highlight in pairs(playerHighlights) do
                if highlight then
                    highlight:Destroy()
                end
            end
            playerHighlights = {}
        end
    end,
})

local FOVSlider = VisualsTab:CreateSlider({
    Name = "FOV Distance",
    Range = {70, 120},
    Increment = 1,
    CurrentValue = 70,
    Callback = function(Value)
        game.Workspace.CurrentCamera.FieldOfView = Value
    end,
})

-- Evening Sky button
VisualsTab:CreateButton({
    Name = "Evening Sky",
    Callback = function()
        local lighting = game:GetService("Lighting")
        local workspace = game:GetService("Workspace")
        
        -- Останавливаем и удаляем звуки летнего неба, если они есть
        if workspace:FindFirstChild("SummerBirds") then
            workspace.SummerBirds:Stop()
            workspace.SummerBirds:Destroy()
        end
        
        if workspace:FindFirstChild("SummerBreeze") then
            workspace.SummerBreeze:Stop()
            workspace.SummerBreeze:Destroy()
        end
        
        if workspace:FindFirstChild("SummerCicadas") then
            workspace.SummerCicadas:Stop()
            workspace.SummerCicadas:Destroy()
        end
        
        -- Добавляем вечерние звуки птиц
        if not workspace:FindFirstChild("EveningBirds") then
            local eveningBirds = Instance.new("Sound")
            eveningBirds.Name = "EveningBirds"
            eveningBirds.SoundId = "rbxassetid://1844574589"  -- Вечерние птицы
            eveningBirds.Volume = 0.5
            eveningBirds.Looped = true
            eveningBirds.Parent = workspace
            eveningBirds:Play()
        end
        
        for _, obj in pairs(lighting:GetChildren()) do
            if obj:IsA("Sky") then
                obj:Destroy()
            end
        end
        
        local sky = Instance.new("Sky")
        sky.Parent = lighting
        
        lighting.Ambient = Color3.fromRGB(102, 102, 153)
        lighting.OutdoorAmbient = Color3.fromRGB(102, 102, 153)
        lighting.Brightness = 0.5
        lighting.ClockTime = 18
        lighting.GeographicLatitude = 30
        
        if lighting:FindFirstChild("Atmosphere") then
            lighting.Atmosphere:Destroy()
        end
        
        local atmosphere = Instance.new("Atmosphere")
        atmosphere.Parent = lighting
        atmosphere.Density = 0.3
        atmosphere.Offset = 0.25
        atmosphere.Color = Color3.fromRGB(198, 160, 128)
        atmosphere.Decay = Color3.fromRGB(108, 88, 75)
        atmosphere.Glare = 0
        atmosphere.Haze = 0
        
        if lighting:FindFirstChild("Bloom") then
            lighting.Bloom:Destroy()
        end
        
        local bloom = Instance.new("BloomEffect")
        bloom.Parent = lighting
        bloom.Intensity = 0.3
        bloom.Size = 24
        bloom.Threshold = 1
        
        if lighting:FindFirstChild("Moon") then
            lighting.Moon:Destroy()
        end
        
        Rayfield:Notify({
            Title = "Evening Sky Applied",
            Content = "Skybox changed to beautiful evening sky with evening birds sounds",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

-- Summer Sky button с улучшенными эффектами
VisualsTab:CreateButton({
    Name = "Summer Sky",
    Callback = function()
        local lighting = game:GetService("Lighting")
        local workspace = game:GetService("Workspace")
        
        -- Очищаем предыдущие эффекты
        for _, obj in pairs(lighting:GetChildren()) do
            if obj:IsA("Sky") then
                obj:Destroy()
            end
        end
        
        -- Устанавливаем летнее небо
        local sky = Instance.new("Sky")
        sky.SkyboxBk = "rbxassetid://6444884785"  -- Яркое голубое небо
        sky.SkyboxDn = "rbxassetid://6444884785"
        sky.SkyboxFt = "rbxassetid://6444884785"
        sky.SkyboxLf = "rbxassetid://6444884785"
        sky.SkyboxRt = "rbxassetid://6444884785"
        sky.SkyboxUp = "rbxassetid://6444885605"  -- Светлые облака
        sky.Parent = lighting
        
        lighting.Ambient = Color3.fromRGB(140, 180, 220)
        lighting.OutdoorAmbient = Color3.fromRGB(140, 180, 220)
        lighting.Brightness = 1.5
        lighting.ClockTime = 14  -- День
        lighting.GeographicLatitude = 30
        lighting.FogColor = Color3.fromRGB(180, 210, 240)
        lighting.FogEnd = 1500
        lighting.FogStart = 5
        lighting.GlobalShadows = true
        lighting.ShadowSoftness = 0.3
        
        -- Настраиваем атмосферу для летнего времени
        if lighting:FindFirstChild("Atmosphere") then
            lighting.Atmosphere:Destroy()
        end
        
        local atmosphere = Instance.new("Atmosphere")
        atmosphere.Parent = lighting
        atmosphere.Density = 0.2
        atmosphere.Offset = 0.15
        atmosphere.Color = Color3.fromRGB(200, 220, 240)
        atmosphere.Decay = Color3.fromRGB(140, 180, 220)
        atmosphere.Glare = 0.6
        atmosphere.Haze = 0.1
        
        -- Добавляем яркое свечение
        if lighting:FindFirstChild("Bloom") then
            lighting.Bloom:Destroy()
        end
        
        local bloom = Instance.new("BloomEffect")
        bloom.Parent = lighting
        bloom.Intensity = 0.6
        bloom.Size = 38
        bloom.Threshold = 0.7
        
        -- Добавляем эффект солнечных лучей
        if lighting:FindFirstChild("SunRays") then
            lighting.SunRays:Destroy()
        end
        
        local sunRays = Instance.new("SunRaysEffect")
        sunRays.Parent = lighting
        sunRays.Intensity = 0.1
        sunRays.Spread = 0.7
        
        -- Добавляем эффект глубины резкости
        if lighting:FindFirstChild("DepthOfField") then
            lighting.DepthOfField:Destroy()
        end
        
        local dof = Instance.new("DepthOfFieldEffect")
        dof.Parent = lighting
        dof.FarIntensity = 0.1
        dof.FocusDistance = 0.05
        dof.InFocusRadius = 30
        dof.NearIntensity = 0.7
        
        -- Удаляем старые эффекты
        if workspace:FindFirstChild("CloudEffect") then
            workspace.CloudEffect:Destroy()
        end
        
        if workspace:FindFirstChild("Butterflies") then
            workspace.Butterflies:Destroy()
        end
        
        if workspace:FindFirstChild("SunEffect") then
            workspace.SunEffect:Destroy()
        end
        
        if workspace:FindFirstChild("SummerBirds") then
            workspace.SummerBirds:Destroy()
        end
        
        if workspace:FindFirstChild("SummerBreeze") then
            workspace.SummerBreeze:Destroy()
        end
        
        -- Создаем солнце
        local sun = Instance.new("Part")
        sun.Name = "SunEffect"
        sun.Parent = workspace
        sun.Size = Vector3.new(15, 15, 15)
        sun.Position = Vector3.new(0, 150, 0)
        sun.Anchored = true
        sun.CanCollide = false
        sun.Transparency = 1
        
        local sunLight = Instance.new("PointLight")
        sunLight.Parent = sun
        sunLight.Brightness = 2
        sunLight.Range = 500
        sunLight.Color = Color3.fromRGB(255, 230, 150)
        
        local sunGlow = Instance.new("ParticleEmitter")
        sunGlow.Parent = sun
        sunGlow.Texture = "rbxassetid://242098003"
        sunGlow.Size = NumberSequence.new(20)
        sunGlow.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        })
        sunGlow.Lifetime = NumberRange.new(10)
        sunGlow.Rate = 5
        sunGlow.Speed = NumberRange.new(0)
        sunGlow.Rotation = NumberRange.new(0, 360)
        sunGlow.LightEmission = 1
        sunGlow.Color = ColorSequence.new(Color3.fromRGB(255, 220, 100))
        
        -- Добавляем легкие облака
        local clouds = Instance.new("Part")
        clouds.Name = "CloudEffect"
        clouds.Parent = workspace
        clouds.Size = Vector3.new(400, 1, 400)
        clouds.Position = Vector3.new(0, 100, 0)
        clouds.Anchored = true
        clouds.CanCollide = false
        clouds.Transparency = 1
        
        local cloudParticles = Instance.new("ParticleEmitter")
        cloudParticles.Parent = clouds
        cloudParticles.Texture = "rbxassetid://2418122635"  -- Текстура облаков
        cloudParticles.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 20),
            NumberSequenceKeypoint.new(1, 35)
        })
        cloudParticles.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(0.5, 0.1),
            NumberSequenceKeypoint.new(1, 0.3)
        })
        cloudParticles.Lifetime = NumberRange.new(60, 80)
        cloudParticles.Rate = 8
        cloudParticles.Speed = NumberRange.new(2, 4)
        cloudParticles.VelocitySpread = 250
        cloudParticles.Rotation = NumberRange.new(0, 360)
        cloudParticles.RotSpeed = NumberRange.new(-0.5, 0.5)
        cloudParticles.LightEmission = 0.9
        cloudParticles.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        cloudParticles.Acceleration = Vector3.new(-2, 0, 0)
        cloudParticles.LockedToPart = false
        
        -- Добавляем бабочки
        local butterflies = Instance.new("Part")
        butterflies.Name = "Butterflies"
        butterflies.Parent = workspace
        butterflies.Size = Vector3.new(200, 50, 200)
        butterflies.Position = Vector3.new(0, 10, 0)
        butterflies.Anchored = true
        butterflies.CanCollide = false
        butterflies.Transparency = 1
        
        local butterflyParticles = Instance.new("ParticleEmitter")
        butterflyParticles.Parent = butterflies
        butterflyParticles.Texture = "rbxassetid://216385127"  -- Текстура бабочки
        butterflyParticles.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2),
            NumberSequenceKeypoint.new(1, 4)
        })
        butterflyParticles.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        butterflyParticles.Lifetime = NumberRange.new(15, 25)
        butterflyParticles.Rate = 10
        butterflyParticles.Speed = NumberRange.new(3, 6)
        butterflyParticles.VelocitySpread = 100
        butterflyParticles.Rotation = NumberRange.new(0, 360)
        butterflyParticles.RotSpeed = NumberRange.new(-10, 10)
        butterflyParticles.LightEmission = 0.5
        butterflyParticles.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 100)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 150, 200)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 200, 255))
        })
        butterflyParticles.Acceleration = Vector3.new(0, 1, 0)
        butterflyParticles.LockedToPart = false
        
        -- Добавляем эффект теплого солнца
        if lighting:FindFirstChild("SunEffect") then
            lighting.SunEffect:Destroy()
        end
        
        local sunEffect = Instance.new("ColorCorrectionEffect")
        sunEffect.Name = "SunEffect"
        sunEffect.Parent = lighting
        sunEffect.Brightness = 0.15
        sunEffect.Contrast = 0.25
        sunEffect.Saturation = 0.2
        sunEffect.TintColor = Color3.fromRGB(255, 245, 225)
        
        -- Добавляем эффект легкой дымки
        if lighting:FindFirstChild("LightScatter") then
            lighting.LightScatter:Destroy()
        end
        
        local scatter = Instance.new("BlurEffect")
        scatter.Name = "LightScatter"
        scatter.Parent = lighting
        scatter.Size = 2
        
        if workspace:FindFirstChild("EveningBirds") then
            workspace.EveningBirds:Stop()
            workspace.EveningBirds:Destroy()
        end
        
        -- Добавляем звуки природы
        if not workspace:FindFirstChild("SummerBirds") then
            local birdsSound = Instance.new("Sound")
            birdsSound.Name = "SummerBirds"
            birdsSound.SoundId = "rbxassetid://9119383684"  -- Звук птиц
            birdsSound.Volume = 0.5
            birdsSound.Looped = true
            birdsSound.Parent = workspace
            birdsSound:Play()
        end
        
        -- Добавляем звук легкого ветерка
        if not workspace:FindFirstChild("SummerBreeze") then
            local breezeSound = Instance.new("Sound")
            breezeSound.Name = "SummerBreeze"
            breezeSound.SoundId = "rbxassetid://9119650569"  -- Звук легкого ветра
            breezeSound.Volume = 0.3
            breezeSound.Looped = true
            breezeSound.Parent = workspace
            breezeSound:Play()
        end
        
        -- Добавляем цикады
        if not workspace:FindFirstChild("SummerCicadas") then
            local cicadasSound = Instance.new("Sound")
            cicadasSound.Name = "SummerCicadas"
            cicadasSound.SoundId = "rbxassetid://0"  -- Звук цикад
            cicadasSound.Volume = 0.4
            cicadasSound.Looped = true
            cicadasSound.Parent = workspace
            cicadasSound:Play()
        end
        
        Rayfield:Notify({
            Title = "Summer Sky Applied",
            Content = "Skybox changed to beautiful summer sky with enhanced effects",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

-- Sounds Tab
local SoundsTab = Window:CreateTab("Sounds", 4483362458)

local activeSoundReplacements = {}

local function applySoundReplacements()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Sound") then
            if obj.Name == "Fire" and activeSoundReplacements.Fire then
                obj.SoundId = "rbxassetid://" .. activeSoundReplacements.Fire
            elseif obj.Name == "Reload" and activeSoundReplacements.Reload then
                obj.SoundId = "rbxassetid://" .. activeSoundReplacements.Reload
            elseif (obj.Name == "Jump" or obj.Name == "Jumping") and activeSoundReplacements.Jump then
                obj.SoundId = "rbxassetid://" .. activeSoundReplacements.Jump
            elseif obj.Name == "Kill" and activeSoundReplacements.Kill then
                obj.SoundId = "rbxassetid://" .. activeSoundReplacements.Kill
            elseif obj.Name == "Gun_Pullout" and activeSoundReplacements.Gun_Pullout then
                obj.SoundId = "rbxassetid://" .. activeSoundReplacements.Gun_Pullout
            end
        end
    end
    
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("Sound") then
                    if part.Name == "Fire" and activeSoundReplacements.Fire then
                        part.SoundId = "rbxassetid://" .. activeSoundReplacements.Fire
                    elseif part.Name == "Reload" and activeSoundReplacements.Reload then
                        part.SoundId = "rbxassetid://" .. activeSoundReplacements.Reload
                    elseif (part.Name == "Jump" or part.Name == "Jumping") and activeSoundReplacements.Jump then
                        part.SoundId = "rbxassetid://" .. activeSoundReplacements.Jump
                    elseif part.Name == "Kill" and activeSoundReplacements.Kill then
                        part.SoundId = "rbxassetid://" .. activeSoundReplacements.Kill
                    elseif part.Name == "Gun_Pullout" and activeSoundReplacements.Gun_Pullout then
                        part.SoundId = "rbxassetid://" .. activeSoundReplacements.Gun_Pullout
                    end
                end
            end
        end
    end
end

local function onDescendantAdded(descendant)
    if descendant:IsA("Sound") then
        if descendant.Name == "Fire" and activeSoundReplacements.Fire then
            descendant.SoundId = "rbxassetid://" .. activeSoundReplacements.Fire
        elseif descendant.Name == "Reload" and activeSoundReplacements.Reload then
            descendant.SoundId = "rbxassetid://" .. activeSoundReplacements.Reload
        elseif (descendant.Name == "Jump" or descendant.Name == "Jumping") and activeSoundReplacements.Jump then
            descendant.SoundId = "rbxassetid://" .. activeSoundReplacements.Jump
        elseif descendant.Name == "Kill" and activeSoundReplacements.Kill then
            descendant.SoundId = "rbxassetid://" .. activeSoundReplacements.Kill
        elseif descendant.Name == "Gun_Pullout" and activeSoundReplacements.Gun_Pullout then
            descendant.SoundId = "rbxassetid://" .. activeSoundReplacements.Gun_Pullout
        end
    end
end

workspace.DescendantAdded:Connect(onDescendantAdded)

-- Fire Sound Section
SoundsTab:CreateSection("Fire Sound")

SoundsTab:CreateButton({
    Name = "Deagle Fire",
    Callback = function()
        activeSoundReplacements.Fire = "102707642152567"
        activeSoundReplacements.Reload = "5697965006"
        activeSoundReplacements.Gun_Pullout = "114665923495116"
        applySoundReplacements()
        Rayfield:Notify({
            Title = "Deagle Sound Applied",
            Content = "Fire, Reload and Gun Pullout sounds replaced permanently",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

SoundsTab:CreateButton({
    Name = "Bow Sound",
    Callback = function()
        activeSoundReplacements.Fire = "609348009"
        activeSoundReplacements.Reload = "609348868"
        activeSoundReplacements.Kill = "135478009117226"
        applySoundReplacements()
        Rayfield:Notify({
            Title = "Bow Sound Applied",
            Content = "Fire, Reload and Kill sounds replaced permanently",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

SoundsTab:CreateButton({
    Name = "Scout Fire",
    Callback = function()
        activeSoundReplacements.Fire = "2476571739"
        activeSoundReplacements.Gun_Pullout = "131210597030574"
        activeSoundReplacements.Reload = "95228555371464"
        applySoundReplacements()
        Rayfield:Notify({
            Title = "Scout Sound Applied",
            Content = "Fire, Gun Pullout and Reload sounds replaced permanently",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

-- Jump Sound Section
SoundsTab:CreateSection("Jump Sound")

SoundsTab:CreateButton({
    Name = "Mario Jump",
    Callback = function()
        activeSoundReplacements.Jump = "6678636911"
        applySoundReplacements()
        Rayfield:Notify({
            Title = "Mario Jump Applied",
            Content = "Jump/Jumping sound replaced with Mario jump permanently",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

-- Trolling Tab
local TrollingTab = Window:CreateTab("Trolling", 4483362458)

-- Spin System
local spinning = false
local spinSpeed = 10

local function spinCharacter()
    if spinning and game.Players.LocalPlayer.Character then
        local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        end
    end
end

local SpinToggle = TrollingTab:CreateToggle({
    Name = "Spin",
    CurrentValue = false,
    Callback = function(Value)
        spinning = Value
    end,
})

local SpinSpeedSlider = TrollingTab:CreateSlider({
    Name = "Spin Speed",
    Range = {1, 100},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(Value)
        spinSpeed = Value
    end,
})

-- TP Tool System
local TPToolButton = TrollingTab:CreateButton({
    Name = "TP Tool",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.Name = "TP Tool"
        tool.RequiresHandle = false
        tool.Parent = game.Players.LocalPlayer.Backpack
        
        tool.Activated:Connect(function()
            local character = game.Players.LocalPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            local mouse = game.Players.LocalPlayer:GetMouse()
            
            if humanoidRootPart and mouse then
                humanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end)
        
        Rayfield:Notify({
            Title = "TP Tool Given",
            Content = "Tool added to inventory. Use for teleportation",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

-- Rainbow Gun System
local rainbowGunEnabled = false
local rainbowSpeed = 10
local rainbowHue = 0

local function updateRainbowGun()
    if not rainbowGunEnabled then return end
    
    rainbowHue = (rainbowHue + rainbowSpeed / 360) % 1
    
    local character = game.Players.LocalPlayer.Character
    if character then
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                local handle = tool.Handle
                
                -- Создаем или обновляем свечение
                local glow = handle:FindFirstChild("RainbowGlow")
                if not glow then
                    glow = Instance.new("SurfaceLight")
                    glow.Name = "RainbowGlow"
                    glow.Parent = handle
                    glow.Range = 15
                    glow.Brightness = 2
                    glow.Angle = 180
                end
                
                -- Применяем радужный цвет
                local color = Color3.fromHSV(rainbowHue, 1, 1)
                glow.Color = color
                
                -- Изменяем цвет инструмента
                if tool:FindFirstChild("Mesh") then
                    tool.Mesh.VertexColor = Vector3.new(color.r, color.g, color.b)
                end
            end
        end
    end
end

local RainbowToggle = TrollingTab:CreateToggle({
    Name = "Rainbow Gun",
    CurrentValue = false,
    Callback = function(Value)
        rainbowGunEnabled = Value
        if not Value then
            -- Удаляем свечение при отключении
            local character = game.Players.LocalPlayer.Character
            if character then
                for _, tool in ipairs(character:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                        local glow = tool.Handle:FindFirstChild("RainbowGlow")
                        if glow then
                            glow:Destroy()
                        end
                    end
                end
            end
        end
    end,
})

local RainbowSpeedSlider = TrollingTab:CreateSlider({
    Name = "Rainbow Speed",
    Range = {1, 50},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(Value)
        rainbowSpeed = Value
    end,
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Config System
local configsFolder = "mvsh_configs/"
local selectedConfig = ""

-- Create folder if it doesn't exist
if not isfolder then
    Rayfield:Notify({
        Title = "File System Error",
        Content = "File system functions are not available",
        Duration = 5,
        Image = 4483362458
    })
else
    if not isfolder(configsFolder) then
        makefolder(configsFolder)
    end
end

-- Function to get list of configs
local function getConfigList()
    local configs = {}
    if isfolder and isfolder(configsFolder) then
        local success, files = pcall(function()
            return listfiles(configsFolder)
        end)
        
        if success then
            for _, file in ipairs(files) do
                if string.sub(file, -5) == ".json" then
                    local name = string.match(file, ".+\\(.+)%.json")
                    table.insert(configs, name)
                end
            end
        end
    end
    return configs
end

-- Config name input
local configNameInput = SettingsTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        selectedConfig = Text
    end,
})

-- Config dropdown
local configDropdown = SettingsTab:CreateDropdown({
    Name = "Saved Configs",
    Options = getConfigList(),
    CurrentOption = "Select Config",
    Callback = function(Option)
        selectedConfig = Option
        configNameInput:Set(Option)
    end,
})

-- Save config function
local function saveConfig(name)
    if name == "" then
        Rayfield:Notify({
            Title = "Save Error",
            Content = "Please enter a config name",
            Duration = 3,
            Image = 4483362458
        })
        return
    end
    
    local config = {
        speedHackEnabled = speedHackEnabled,
        customWalkSpeed = customWalkSpeed,
        hitboxEnabled = hitboxEnabled,
        hitboxSize = hitboxSize,
        ChamsEnabled = ChamsEnabled,
        FOV = game.Workspace.CurrentCamera.FieldOfView,
        spinning = spinning,
        spinSpeed = spinSpeed,
        rainbowGunEnabled = rainbowGunEnabled,
        rainbowSpeed = rainbowSpeed,
        soundReplacements = activeSoundReplacements
    }
    
    local json = game:GetService("HttpService"):JSONEncode(config)
    local fileName = configsFolder .. name .. ".json"
    
    if writefile then
        local success, err = pcall(function()
            writefile(fileName, json)
        end)
        
        if success then
            -- Update dropdown options
            local newOptions = getConfigList()
            configDropdown:SetOptions(newOptions)
            
            Rayfield:Notify({
                Title = "Config Saved",
                Content = "Configuration '" .. name .. "' has been saved successfully",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Save Error",
                Content = "Failed to save config: " .. tostring(err),
                Duration = 3,
                Image = 4483362458
            })
        end
    else
        Rayfield:Notify({
            Title = "Save Error",
            Content = "Writefile function is not available",
            Duration = 3,
            Image = 4483362458
        })
    end
end

-- Load config function
local function loadConfig(name)
    if name == "" then
        Rayfield:Notify({
            Title = "Load Error",
            Content = "Please select a config to load",
            Duration = 3,
            Image = 4483362458
        })
        return
    end
    
    local fileName = configsFolder .. name .. ".json"
    
    if readfile then
        local success, err = pcall(function()
            local json = readfile(fileName)
            local config = game:GetService("HttpService"):JSONDecode(json)
            
            -- Apply settings
            speedHackEnabled = config.speedHackEnabled or false
            customWalkSpeed = config.customWalkSpeed or 25
            hitboxEnabled = config.hitboxEnabled or false
            hitboxSize = config.hitboxSize or 5
            ChamsEnabled = config.ChamsEnabled or false
            spinning = config.spinning or false
            spinSpeed = config.spinSpeed or 10
            rainbowGunEnabled = config.rainbowGunEnabled or false
            rainbowSpeed = config.rainbowSpeed or 10
            activeSoundReplacements = config.soundReplacements or {}
            
            -- Update UI elements
            SpeedToggle:Set(speedHackEnabled)
            SpeedSlider:Set(customWalkSpeed)
            HitboxToggle:Set(hitboxEnabled)
            HitboxSizeSlider:Set(hitboxSize)
            ChamsToggle:Set(ChamsEnabled)
            FOVSlider:Set(config.FOV or 70)
            SpinToggle:Set(spinning)
            SpinSpeedSlider:Set(spinSpeed)
            RainbowToggle:Set(rainbowGunEnabled)
            RainbowSpeedSlider:Set(rainbowSpeed)
            
            -- Apply changes
            updateSpeed()
            if hitboxEnabled then
                expandHitboxes()
            else
                restoreHitboxes()
            end
            
            if ChamsEnabled then
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer then
                        applyChams(player)
                    end
                end
            else
                for player, highlight in pairs(playerHighlights) do
                    if highlight then
                        highlight:Destroy()
                    end
                end
                playerHighlights = {}
            end
            
            applySoundReplacements()
            game.Workspace.CurrentCamera.FieldOfView = config.FOV or 70
            
            Rayfield:Notify({
                Title = "Config Loaded",
                Content = "Configuration '" .. name .. "' has been loaded successfully",
                Duration = 3,
                Image = 4483362458
            })
        end)
        
        if not success then
            Rayfield:Notify({
                Title = "Load Error",
                Content = "Failed to load config: " .. tostring(err),
                Duration = 3,
                Image = 4483362458
            })
        end
    else
        Rayfield:Notify({
            Title = "Load Error",
            Content = "Readfile function is not available",
            Duration = 3,
            Image = 4483362458
        })
    end
end

-- Save Config Button
SettingsTab:CreateButton({
    Name = "Save Config",
    Callback = function()
        saveConfig(selectedConfig)
    end,
})

-- Load Config Button
SettingsTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        loadConfig(selectedConfig)
    end,
})

-- Reset Config Button
SettingsTab:CreateButton({
    Name = "Reset Config",
    Callback = function()
        speedHackEnabled = false
        customWalkSpeed = 25
        hitboxEnabled = false
        hitboxSize = 5
        ChamsEnabled = false
        spinning = false
        spinSpeed = 10
        rainbowGunEnabled = false
        rainbowSpeed = 10
        activeSoundReplacements = {}
        
        -- Update UI elements
        SpeedToggle:Set(speedHackEnabled)
        SpeedSlider:Set(customWalkSpeed)
        HitboxToggle:Set(hitboxEnabled)
        HitboxSizeSlider:Set(hitboxSize)
        ChamsToggle:Set(ChamsEnabled)
        FOVSlider:Set(70)
        SpinToggle:Set(spinning)
        SpinSpeedSlider:Set(spinSpeed)
        RainbowToggle:Set(rainbowGunEnabled)
        RainbowSpeedSlider:Set(rainbowSpeed)
        
        -- Apply changes
        updateSpeed()
        restoreHitboxes()
        
        for player, highlight in pairs(playerHighlights) do
            if highlight then
                highlight:Destroy()
            end
        end
        playerHighlights = {}
        
        game.Workspace.CurrentCamera.FieldOfView = 70
        
        Rayfield:Notify({
            Title = "Config Reset",
            Content = "All settings have been reset to default",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

-- Обработчики игроков
game.Players.PlayerAdded:Connect(function(player)
    if hitboxEnabled then
        expandHitboxes()
    end
    if ChamsEnabled and player ~= game.Players.LocalPlayer then
        applyChams(player)
    end
    
    player.CharacterAdded:Connect(function(character)
        character.DescendantAdded:Connect(onDescendantAdded)
        if hitboxEnabled then
            expandHitboxes()
        end
    end)
end)

game.Players.PlayerRemoving:Connect(function(player)
    if originalSizes[player] then
        originalSizes[player] = nil
    end
end)

-- Основной цикл
game:GetService("RunService").RenderStepped:Connect(function()
    if hitboxEnabled then
        expandHitboxes()
    end
    spinCharacter()
    updateRainbowGun()
    
    if speedHackEnabled then
        updateSpeed()
    end
end)

-- Уведомление о успешной загрузке
Rayfield:Notify({
    Title = "Legitbtw uploaded ",
    Content = "Menu successfully activated !",
    Duration = 3,
    Image = 4483362458
})
