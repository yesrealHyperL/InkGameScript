print ("Loading the script, please wait...")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
local Window = Rayfield:CreateWindow({ ... })

-- Create the Window with Key System and Custom Discord
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
        Invite = "KDvgEJrn8D", -- ✅ Your Discord Invite Code (no "https://")
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "Key Required",
        Subtitle = "Please enter the key",
        Note = "Key is in Discord Server (discord.gg/KDvgEJrn8D)",
        FileName = "InkGameKey",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = "HyperL0.1"
    }
})

local InfoTab = Window:CreateTab("Info", 4483362458) -- Replace with your own image IDs

InfoTab:CreateButton({
   Name = "📓Copy Discord Link",
   Callback = function()
      setclipboard("https://discord.gg/KDvgEJrn8D")
      Rayfield:Notify({
         Title = "Copied!",
         Content = "Discord link copied to clipboard.",
         Duration = 3
      })
   end
})

InfoTab:CreateButton({
   Name = "♻️Server Hop",
   Callback = function()
      local TeleportService = game:GetService("TeleportService")
      local PlaceID = game.PlaceId
      TeleportService:Teleport(PlaceID)
   end
})

InfoTab:CreateButton({
   Name = "Rejoin",
   Callback = function()
      game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
   end
})

local PlayerTab = Window:CreateTab("Player", 4483362458)

PlayerTab:CreateSlider({
   Name = "🚶‍♂️WalkSpeed",
   Range = {1, 600},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end
})

PlayerTab:CreateSlider({
   Name = "✨JumpPower",
   Range = {50, 250},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end
})

local noclip = false
PlayerTab:CreateToggle({
   Name = "🚀Noclip (Press N)",
   CurrentValue = false,
   Callback = function(Value) noclip = Value end
})

game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
   if input.KeyCode == Enum.KeyCode.N and noclip then
      for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
         if v:IsA("BasePart") then
            v.CanCollide = false
         end
      end
   end
end)

PlayerTab:CreateToggle({
   Name = "🛡️GodMode",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().GodMode = Value
   end
})

game:GetService("RunService").Stepped:Connect(function()
   if getgenv().GodMode then
      local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
      if hum then hum.Health = hum.MaxHealth end
   end
end)

PlayerTab:CreateButton({
   Name = "💨Boost (5s)",
   Callback = function()
      local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
      if hum then
         local oldSpeed = hum.WalkSpeed
         hum.WalkSpeed = 100
         wait(5)
         hum.WalkSpeed = oldSpeed
      end
   end
})

local MiscTab = Window:CreateTab("Misc", 4483362458) -- Replace icon ID if needed

-- 1. TP to Finish Line
MiscTab:CreateButton({
   Name = "TP to Finish Line",
   Callback = function()
      local finish = workspace:FindFirstChild("FinishLine") or workspace:FindFirstChild("End")
      if finish then
         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = finish.CFrame
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "Finish line not found.",
            Duration = 3
         })
      end
   end
})

-- 2. TP to Spawn
MiscTab:CreateButton({
   Name = "TP to Spawn",
   Callback = function()
      local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Lobby")
      if spawn then
         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = spawn.CFrame
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "Spawn not found.",
            Duration = 3
         })
      end
   end
})

-- 3. TP to Guard Room
MiscTab:CreateButton({
   Name = "TP to Guard Room",
   Callback = function()
      local guard = workspace:FindFirstChild("GuardRoom")
      if guard then
         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = guard.CFrame
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "Guard room not found.",
            Duration = 3
         })
      end
   end
})

-- 4. TP to Glass Bridge 
MiscTab:CreateButton({
   Name = "TP to Glass Bridge",
   Callback = function()
      local glass = workspace:FindFirstChild("GlassBridge") or workspace:FindFirstChild("Glass")
      if glass then
         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = glass.CFrame
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "Glass bridge not found.",
            Duration = 3
         })
      end
   end
})

local ExploitTab = Window:CreateTab("Exploits", 4483362458)

-- Spin Toggle
local spinning = false
local spinSpeed = 10

ExploitTab:CreateToggle({
   Name = "♻️Spin",
   CurrentValue = false,
   Callback = function(val) spinning = val end
})

ExploitTab:CreateInput({
   Name = "🌪️Spin Speed",
   PlaceholderText = "Number",
   Callback = function(text) spinSpeed = tonumber(text) or 10 end
})

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
      if gun then
         gun:Clone().Parent = game.Players.LocalPlayer.Backpack
      end
   end
})

ExploitTab:CreateToggle({
   Name = "❤️Auto-Heal",
   CurrentValue = false,
   Callback = function(val) getgenv().AutoHeal = val end
})

game:GetService("RunService").RenderStepped:Connect(function()
   if getgenv().AutoHeal then
      local h = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
      if h and h.Health < h.MaxHealth then h.Health = h.Health + 2 end
   end
end)

ExploitsTab:CreateSlider({
   Name = "🌌Gravity Modifier",
   Range = {0, 196},
   Increment = 1,
   CurrentValue = 196,
   Callback = function(Value)
      workspace.Gravity = Value
   end
})

-- ✅ 5. Invisible Character
ExploitsTab:CreateButton({
   Name = "👻Invisible",
   Callback = function()
      for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
         if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = 1
         end
      end
   end
})

-- ✅ 6. Destroy All Doors
ExploitsTab:CreateButton({
   Name = "💥Destroy All Doors",
   Callback = function()
      for _, obj in pairs(workspace:GetDescendants()) do
         if obj:IsA("BasePart") and obj.Name:lower():find("door") then
            obj:Destroy()
         end
      end
   end
})

local UITab = Window:CreateTab("UI", 4483362458)

UITab:CreateButton({
   Name = "🎨Change UI Color",
   Callback = function()
      local colors = {
         Color3.fromRGB(255, 0, 0),
         Color3.fromRGB(0, 255, 0),
         Color3.fromRGB(0, 0, 255),
         Color3.fromRGB(255, 255, 0)
      }
      Window:ChangeBackgroundColor(colors[math.random(1, #colors)])
   end
})
