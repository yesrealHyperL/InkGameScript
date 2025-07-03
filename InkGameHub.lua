
print("Loading the script, please wait...")

-- Configuration Table
local Config = {
    KeylessFile = "InkGameHub_Keyless.json",
    DiscordInvite = "KDvgEJrn8D",
    Key = "HyperL0.1",
    Images = {
        Info        = 4483361375,
        Player      = 4483361309,
        Misc        = 4483361480,
        Exploits    = 4483361502,
        Protections = 4483361568,
        FPS         = 4483361550,
        Coordinates = 4483361613
    }
}

-- Keyless Mode System
local HttpService = game:GetService("HttpService")
local isKeyless = false

if isfile(Config.KeylessFile) then
    local data = readfile(Config.KeylessFile)
    local decoded = HttpService:JSONDecode(data)
    if decoded and decoded.Keyless then
        isKeyless = true
    end
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Ink Game Hub | by HyperL",
    LoadingTitle = "Ink Game Hub",
    LoadingSubtitle = "The Final Fixed Script",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "InkGameHub"
    },
    Discord = {
        Enabled = true,
        Invite = Config.DiscordInvite,
        RememberJoins = true
    },
    KeySystem = not isKeyless,
    KeySettings = {
        Title = "Ink Game Key",
        Subtitle = "Key System",
        Note = "Join the Discord Server to get the key",
        FileName = "InkKey",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = Config.Key
    }
})

-- Info Tab
local InfoTab = Window:CreateTab("Info", Config.Images.Info)
InfoTab:CreateButton({ Name = "📓 Copy Discord Link", Callback = function()
    setclipboard("https://discord.gg/"..Config.DiscordInvite)
    Rayfield:Notify({ Title = "Copied!", Content = "Discord link copied.", Duration = 3 })
end })
InfoTab:CreateButton({ Name = "♻️ Server Hop", Callback = function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end })
InfoTab:CreateButton({ Name = "🔄 Rejoin", Callback = function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
end })

-- Player Tab
local PlayerTab = Window:CreateTab("Player", Config.Images.Player)
PlayerTab:CreateSlider({
    Name = "🚶 WalkSpeed",
    Range = {1, 600}, Increment = 1, CurrentValue = 16,
    Callback = function(val) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val end
})
PlayerTab:CreateSlider({
    Name = "✨ JumpPower",
    Range = {50, 250}, Increment = 1, CurrentValue = 50,
    Callback = function(val) game.Players.LocalPlayer.Character.Humanoid.JumpPower = val end
})

-- Fixed Noclip
local noclipEnabled = false
PlayerTab:CreateToggle({
    Name = "👻 Noclip",
    CurrentValue = false,
    Callback = function(state)
        noclipEnabled = state
        if not state then
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
})
game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Noclip hotkey: N
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.N then
        noclipEnabled = not noclipEnabled
        Rayfield:Notify({
            Title = "Noclip",
            Content = noclipEnabled and "Enabled" or "Disabled",
            Duration = 2
        })
    end
end)

PlayerTab:CreateToggle({
    Name = "🛡️ GodMode",
    CurrentValue = false,
    Callback = function(v) getgenv().GodMode = v end
})
game:GetService("RunService").Stepped:Connect(function()
    if getgenv().GodMode then
        local h = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.Health = h.MaxHealth end
    end
end)

-- Misc Tab
local MiscTab = Window:CreateTab("Misc", Config.Images.Misc)
local function tpTo(name)
    local target = workspace:FindFirstChild(name)
    if target then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame
    else
        Rayfield:Notify({ Title = "Error", Content = name .. " not found.", Duration = 3 })
    end
end

MiscTab:CreateButton({ Name = "TP to Finish Line", Callback = function() tpTo("FinishLine") end })
MiscTab:CreateButton({ Name = "TP to Spawn", Callback = function() tpTo("SpawnLocation") end })
MiscTab:CreateButton({ Name = "TP to Guard Room", Callback = function() tpTo("GuardRoom") end })
MiscTab:CreateButton({ Name = "TP to Glass Bridge", Callback = function() tpTo("Glass") end })

-- TP Tool
MiscTab:CreateButton({
    Name = "🧭 TP Tool",
    Callback = function()
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "TP Tool"
        tool.Activated:Connect(function()
            if mouse.Hit then
                player.Character:MoveTo(mouse.Hit.p)
            end
        end)
        tool.Parent = player.Backpack
        Rayfield:Notify({ Title = "TP Tool Equipped", Content = "Click anywhere to teleport.", Duration = 3 })
    end
})

-- Keyless Toggle in Misc Tab
MiscTab:CreateToggle({
    Name = "🔓 Enable Keyless Mode",
    CurrentValue = isKeyless,
    Callback = function(value)
        local encoded = HttpService:JSONEncode({ Keyless = value })
        writefile(Config.KeylessFile, encoded)
        Rayfield:Notify({
            Title = "Keyless Mode",
            Content = "Keyless mode has been " .. (value and "enabled." or "disabled.") .. " Please re-execute the script.",
            Duration = 6
        })
    end
})

-- Exploits Tab
local ExploitTab = Window:CreateTab("Exploits", Config.Images.Exploits)
local spinning = false
local spinSpeed = 10
ExploitTab:CreateToggle({ Name = "♻️ Spin", CurrentValue = false, Callback = function(v) spinning = v end })
ExploitTab:CreateInput({ Name = "🌀 Spin Speed", PlaceholderText = "Number", Callback = function(t) spinSpeed = tonumber(t) or 10 end })

game:GetService("RunService").Heartbeat:Connect(function()
    if spinning then
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        end
    end
end)

-- Keyless Toggle in Exploits Tab
ExploitTab:CreateToggle({
    Name = "🔓 Keyless Mode (Restart Needed)",
    CurrentValue = isKeyless,
    Callback = function(value)
        local encoded = HttpService:JSONEncode({ Keyless = value })
        writefile(Config.KeylessFile, encoded)
        Rayfield:Notify({
            Title = "Keyless Mode",
            Content = "Saved. Please re-run script to apply.",
            Duration = 6
        })
    end
})

-- Protections Tab
ProtTab:CreateToggle({
    Name = "🛡️ Anti-Kick",
    CurrentValue = false,
    Callback = function(state)
        if state then
            local mt = getrawmetatable(game)
            local old
            setreadonly(mt, false)

            old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if tostring(method) == "Kick" and self == game.Players.LocalPlayer then
                    warn("Blocked Kick Attempt!")
                    return nil
                end
                return old(self, ...)
            end))

            setreadonly(mt, true)
        end
    end
})
ProtTab:CreateToggle({ Name = "🔁 Auto Respawn", CurrentValue = false, Callback = function(state)
    getgenv().autoRespawn = state
end })
game.Players.LocalPlayer.CharacterRemoving:Connect(function()
    if getgenv().autoRespawn then repeat wait() until game.Players.LocalPlayer.Character end
end)
ProtTab:CreateToggle({ Name = "🛑 Anti-AFK", CurrentValue = false, Callback = function(val)
    if val then
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
end })

-- FPS Boost Tab
local FPSTab = Window:CreateTab("FPS Boost", Config.Images.FPS)
FPSTab:CreateButton({ Name = "🚀 Max FPS Mode", Callback = function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.Reflectance = 0 end
        if v:IsA("Decal") then v.Transparency = 1 end
    end
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").FogEnd = 9e9
end })

-- Coordinates Tab
local CoordsTab = Window:CreateTab("Coordinates", Config.Images.Coordinates)
CoordsTab:CreateButton({ Name = "📍 Show Coordinates", Callback = function()
    local pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    local screenGui = Instance.new("ScreenGui", game.CoreGui)
    local label = Instance.new("TextLabel", screenGui)
    label.Text = string.format("X: %.1f\nY: %.1f\nZ: %.1f", pos.X, pos.Y, pos.Z)
    label.Size = UDim2.new(0, 250, 0, 60)
    label.Position = UDim2.new(0.5, -125, 0.1, 0)
    label.BackgroundTransparency = 0.3
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    wait(10)
    screenGui:Destroy()
end })
