
print("Loading the script, please wait...")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "🦑Ink Game Hub | by HyperL",
    LoadingTitle = "Ink Game Script",
    LoadingSubtitle = "Loading...",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "InkGameHub",
        FileName = "InkHubConfig"
    },
    Discord = {
        Enabled = true,
        Invite = "KDvgEJrn8D",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "Key Required",
        Subtitle = "Enter the Key",
        Note = "Get the key in Discord (discord.gg/KDvgEJrn8D)",
        FileName = "InkGameKey",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = "HyperL0.1"
    }
})

-- Info Tab
local InfoTab = Window:CreateTab("Info", 4483362458)
InfoTab:CreateButton({
    Name = "📓Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/KDvgEJrn8D")
        Rayfield:Notify({ Title = "Copied!", Content = "Discord link copied.", Duration = 3 })
    end
})
InfoTab:CreateButton({
    Name = "♻️Server Hop",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
})
InfoTab:CreateButton({
    Name = "↺ Rejoin",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end
})

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateSlider({
    Name = "🚶WalkSpeed",
    Range = {1, 600},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(val)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
})
PlayerTab:CreateSlider({
    Name = "✨JumpPower",
    Range = {50, 250},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(val)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = val
    end
})
local noclip = false
PlayerTab:CreateToggle({
    Name = "🚀Noclip (Toggle N)",
    CurrentValue = false,
    Callback = function(v) noclip = v end
})
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.N and noclip then
        for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
PlayerTab:CreateToggle({
    Name = "🛡️GodMode",
    CurrentValue = false,
    Callback = function(v) getgenv().GodMode = v end
})
game:GetService("RunService").Stepped:Connect(function()
    if getgenv().GodMode then
        local h = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.Health = h.MaxHealth end
    end
end)
PlayerTab:CreateButton({
    Name = "🚨Boost (5s)",
    Callback = function()
        local h = game.Players.LocalPlayer.Character.Humanoid
        local s = h.WalkSpeed
        h.WalkSpeed = 100
        wait(5)
        h.WalkSpeed = s
    end
})

-- Misc Tab
local MiscTab = Window:CreateTab("Misc", 4483362458)
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

-- Exploits Tab
local ExploitTab = Window:CreateTab("Exploits", 4483362458)
local spinning = false
local spinSpeed = 10
ExploitTab:CreateToggle({ Name = "♻️Spin", CurrentValue = false, Callback = function(v) spinning = v end })
ExploitTab:CreateInput({ Name = "🌀Spin Speed", PlaceholderText = "Number", Callback = function(t) spinSpeed = tonumber(t) or 10 end })
game:GetService("RunService").Heartbeat:Connect(function()
    if spinning then
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        end
    end
end)
ExploitTab:CreateButton({
    Name = "🔫Give Gun",
    Callback = function()
        local gun = game:GetService("ReplicatedStorage"):FindFirstChild("Gun")
        if gun then gun:Clone().Parent = game.Players.LocalPlayer.Backpack end
    end
})
ExploitTab:CreateToggle({
    Name = "❤️Auto-Heal",
    CurrentValue = false,
    Callback = function(v) getgenv().AutoHeal = v end
})
game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().AutoHeal then
        local h = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h and h.Health < h.MaxHealth then h.Health = h.Health + 2 end
    end
end)
ExploitTab:CreateSlider({ Name = "🌌Gravity", Range = {0, 196}, Increment = 1, CurrentValue = 196, Callback = function(v) workspace.Gravity = v end })
ExploitTab:CreateButton({ Name = "👽Invisible", Callback = function() for _,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then v.Transparency=1 end end end })
ExploitTab:CreateButton({ Name = "💥Destroy All Doors", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and v.Name:lower():find("door") then v:Destroy() end end end })

-- UI Tab
local UITab = Window:CreateTab("UI", 4483362458)
UITab:CreateButton({
    Name = "🎨Change UI Color",
    Callback = function()
        local colors = {
            Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0)
        }
        Window:ChangeBackgroundColor(colors[math.random(1, #colors)])
    end
})
