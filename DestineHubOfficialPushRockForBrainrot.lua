local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()

local DestineHubTheme = {
    AccentColor = Color3.fromRGB(150, 50, 250),     -- Neon Purple Accent
    BackgroundColor = Color3.fromRGB(15, 15, 20),    -- Dark Main Background
    SidebarColor = Color3.fromRGB(25, 25, 35),       -- Marginally Lighter Sidebar
    TextColor = Color3.fromRGB(240, 240, 245),       -- Off-White Primary Text
    SecondaryText = Color3.fromRGB(140, 140, 160)   -- Muted Gray Subtitles
}

local Zone1 = workspace:WaitForChild("Zones"):WaitForChild("Zone1")
local Zone2 = workspace:WaitForChild("Zones"):WaitForChild("Zone2")
local Zone3 = workspace:WaitForChild("Zones"):WaitForChild("Zone3")
local Zone4 = workspace:WaitForChild("Zones"):WaitForChild("Zone4")
local Zone5 = workspace:WaitForChild("Zones"):WaitForChild("Zone5")
local Zone6 = workspace:WaitForChild("Zones"):WaitForChild("Zone6")
local Zone7 = workspace:WaitForChild("Zones"):WaitForChild("Zone7")
local Zone8 = workspace:WaitForChild("Zones"):WaitForChild("Zone8")
local Zone9 = workspace:WaitForChild("Zones"):WaitForChild("Zone9")

-- Map string names to the corresponding folder variables
local ZoneMapping = {
    ["Zone 1"] = Zone1, ["Zone 2"] = Zone2, ["Zone 3"] = Zone3,
    ["Zone 4"] = Zone4, ["Zone 5"] = Zone5, ["Zone 6"] = Zone6,
    ["Zone 7"] = Zone7, ["Zone 8"] = Zone8, ["Zone 9"] = Zone9
}

local Window = Luna:CreateWindow({
	Name = "Destine Hub | Push Rocks For Brainrots!", 
	Subtitle = "Main Branch", 
	LogoID = 82795327169782, 
	LoadingEnabled = true, 
	LoadingTitle = "Destine Hub Offial Script", 
	LoadingSubtitle = "Destine Hub!",
	ConfigSettings = {
		RootFolder = "DestineHub", 
		ConfigFolder = "UniversalFarm" 
	},

	-- [[ Key System Integration ]]
	KeySystem = false, 
	KeySettings = {
		Title = "Destine Hub Access",
		Subtitle = "Key Validation",
		Note = "Please obtain your key string from our community platform.",
		SaveInRoot = true, 
		SaveKey = true, 
		Key = {"DestineKey2026", "DestineFreeAccess"}, -- Valid authorization passphrases
		SecondAction = {
			Enabled = true,
			Type = "Link", 
			Parameter = "" -- Links to discord.gg/destinehub automatically
		}
	}
})

-- [[ Injecting Theme Modifications ]]
-- Overrides Luna default colors cleanly before rendering any core windows
if Window.SetThemeColor then
    pcall(function()
        Window:SetThemeColor("Accent", DestineHubTheme.AccentColor)
        Window:SetThemeColor("Background", DestineHubTheme.BackgroundColor)
        Window:SetThemeColor("Sidebar", DestineHubTheme.SidebarColor)
        Window:SetThemeColor("Text", DestineHubTheme.TextColor)
        Window:SetThemeColor("SecondaryText", DestineHubTheme.SecondaryText)
    end)
end

-- [[ Dashboard Tab ]]
local DashboardTab = Window:CreateTab({
	Name = "Dashboard",
	Icon = "dashboard", 
	ImageSource = "Material",
	ShowTitle = true
})

-- [[ Welcome Section ]]
local WelcomeLabel = DashboardTab:CreateLabel({
	Text = "Welcome to Destine Hub, " .. game.Players.LocalPlayer.Name .. "!",
	Style = 1
})

local Paragraph = DashboardTab:CreateParagraph({
	Title = "Script Status: Updated",
	Text = "Thank you for using Destine Hub. Everything is running smoothly. Check back here for future announcements and changelogs."
})

DashboardTab:CreateSection("System Information")

-- [[ Executor Detection ]]
local ExecutorLabel = DashboardTab:CreateLabel({
	Text = "Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown Executor"),
	Style = 2
})

-- [[ Discord Invite Button ]]
local DiscordButton = DashboardTab:CreateButton({
	Name = "Copy Discord Link",
	Description = "Copies our community link to your clipboard",
	Callback = function()
		if setclipboard then
			setclipboard("https://discord.gg")
			Luna:Notification({
				Title = "Destine Hub",
				Content = "Discord link copied to clipboard!",
				Icon = "content_copy",
				ImageSource = "Material"
			})
		end
	end
})

-- [[ More Dashboard Content ]]

-- [[ Visual Divider & Section ]]
DashboardTab:CreateSection("Account & Game Stats")
DashboardTab:CreateDivider()

-- [[ Account Age Info ]]
local AccountAgeLabel = DashboardTab:CreateLabel({
	Text = "Account Age: " .. game.Players.LocalPlayer.AccountAge .. " days",
	Style = 2
})

-- [[ Server Info Paragraph ]]
local ServerParagraph = DashboardTab:CreateParagraph({
	Title = "Server Details",
	Text = "Game ID: " .. game.GameId .. "\nPlace ID: " .. game.PlaceId .. "\nJob ID: " .. game.JobId
})

-- [[ Server Rejoin & Hop Controls ]]
DashboardTab:CreateSection("Server Utilities")

local RejoinButton = DashboardTab:CreateButton({
	Name = "Rejoin Server",
	Description = "Instantly reconnects you to this exact server instance",
	Callback = function()
		local TeleportService = game:GetService("TeleportService")
		local Players = game:GetService("Players")
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
	end
})

local ServerHopButton = DashboardTab:CreateButton({
	Name = "Server Hop",
	Description = "Finds and teleports you to a completely different public server",
	Callback = function()
		local HttpService = game:GetService("HttpService")
		local TeleportService = game:GetService("TeleportService")
		local Places = game:GetService("Players")
		
		local function Hop()
			local ServerList = HttpService:JSONDecode(game:HttpGet("https://roblox.com" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
			for _, server in pairs(ServerList.data) do
				if server.playing < server.maxPlayers and server.id ~= game.JobId then
					TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Places.LocalPlayer)
					break
				end
			end
		end
		pcall(Hop)
	end
})

-- [[ Script Unload Control ]]
DashboardTab:CreateSection("Danger Zone")

local DestroyButton = DashboardTab:CreateButton({
	Name = "Unload Destine Hub",
	Description = "Completely closes the UI interface and stops scripts",
	Callback = function()
		-- Triggers Luna's internal cleanup if available, or force destroys the core UI CoreGui folder
		local CoreGui = game:GetService("CoreGui")
		local UI = CoreGui:FindFirstChild("Luna") or CoreGui:FindFirstChild("LunaInterfaceSuite")
		if UI then 
			UI:Destroy() 
		end
	end
})

-- [[ Farm Tab ]]
local FarmTab = Window:CreateTab({
	Name = "Farm Tab",
	Icon = "gavel", 
	ImageSource = "Material",
	ShowTitle = true
})

-- [[ Configuration States ]]
getgenv().DestineFarm = {
    Active = false,
    SelectedZone = "Zone 1",
    SelectedMutation = "Gold",
    SelectedMethod = "Tween",
    TweenSpeed = 50
}

-- [[ Core Movement & Interaction Logic ]]
local TweenService = game:GetService("TweenService")

local function moveToTarget(hrp, targetPart)
    if getgenv().DestineFarm.SelectedMethod == "Teleport" then
        hrp.CFrame = targetPart.CFrame
        task.wait(0.1)
    elseif getgenv().DestineFarm.SelectedMethod == "Tween" then
        -- Lower speed value creates a faster tween calculation matching your slider max
        local distance = (hrp.Position - targetPart.Position).Magnitude
        local duration = distance / math.max(getgenv().DestineFarm.TweenSpeed, 1)
        
        local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetPart.CFrame})
        tween:Play()
        
        -- Wait for tween completion or loop cancellation
        local elapsed = 0
        while tween.PlaybackState == Enum.PlaybackState.Playing and getgenv().DestineFarm.Active do
            task.wait()
        end
    end
end

local function runFarmLoop()
    if getgenv().DestineFarm.Running then return end
    getgenv().DestineFarm.Running = true

    task.spawn(function()
        while getgenv().DestineFarm.Active do
            pcall(function()
                local player = game.Players.LocalPlayer
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")

                local targetFolder = ZoneMapping[getgenv().DestineFarm.SelectedZone]

                if not (hrp and targetFolder) then
                    return
                end

                local selected = getgenv().DestineFarm.SelectedMutation

                for _, item in ipairs(targetFolder:GetChildren()) do
                    if not getgenv().DestineFarm.Active then
                        break
                    end

                    local mutation = item:GetAttribute("mutation")

                    local valid = false
                    if selected == "None" then
                        valid = (mutation == nil or mutation == "" or mutation == "None")
                    else
                        valid = mutation == selected
                    end

                    if valid then
                        local prompt =
                            item:FindFirstChildOfClass("ProximityPrompt")
                            or item:FindFirstChildWhichIsA("ProximityPrompt", true)

                        local targetPart =
                            item:IsA("BasePart") and item
                            or item:FindFirstChildWhichIsA("BasePart", true)

                        if targetPart and prompt then
                            moveToTarget(hrp, targetPart)

                            task.wait(0.1)

                            if fireproximityprompt then
                                pcall(function()
                                    fireproximityprompt(prompt)
                                end)
                            end

                            task.wait(0.2)
                        end
                    end
                end
            end)

            task.wait(0.1)
        end

        getgenv().DestineFarm.Running = false
    end)
end

-- [[ Dropdown 1: Zone Selection ]]
local ZoneDropdown = FarmTab:CreateDropdown({
	Name = "Select Zone",
	Description = "Choose target workspace hunting sector",
	Options = {"Zone 1", "Zone 2", "Zone 3", "Zone 4", "Zone 5", "Zone 6", "Zone 7", "Zone 8", "Zone 9"},
	CurrentOption = {"Zone 1"},
	MultipleOptions = false,
	Callback = function(Options)
		getgenv().DestineFarm.SelectedZone = typeof(Options) == "table" and Options[1] or Options
	end
}, "ZoneDropdown")

-- [[ Dropdown 2: Mutation Prioritization ]]
local MutationDropdown = FarmTab:CreateDropdown({
	Name = "Select Mutation",
	Description = "Prioritizes this mutation type inside the zone folder",
	Options = {"None", "Gold", "Diamond", "Galaxy", "Rainbow"},
	CurrentOption = {"None"},
	MultipleOptions = false,
	Callback = function(Options)
		getgenv().DestineFarm.SelectedMutation = typeof(Options) == "table" and Options[1] or Options
	end
}, "MutationDropdown")

-- [[ Dropdown 3: Movement Methods ]]
local MethodDropdown = FarmTab:CreateDropdown({
	Name = "Farming Method",
	Description = "Toggle between linear tweening and absolute CFrame shifts",
	Options = {"Tween", "Teleport"},
	CurrentOption = {"Tween"},
	MultipleOptions = false,
	Callback = function(Options)
		getgenv().DestineFarm.SelectedMethod = typeof(Options) == "table" and Options[1] or Options
	end
}, "MethodDropdown")

-- [[ Slider: Tween Velocity ]]
local SpeedSlider = FarmTab:CreateSlider({
	Name = "Farm Speed (Tween Only)",
	Range = {10, 100},
	Increment = 5,
	CurrentValue = 50,
	Callback = function(Value)
		getgenv().DestineFarm.TweenSpeed = Value
	end
}, "SpeedSlider")

-- [[ Toggle: Master Activation State ]]
local FarmToggle = FarmTab:CreateToggle({
	Name = "Autofarm Selected Brainrot",
	Description = "Begins scanning selected zones and automatically harvesting contents",
	CurrentValue = false,
	Callback = function(Value)
		getgenv().DestineFarm.Active = Value
        if Value then
            runFarmLoop()
        end
	end
}, "FarmToggle")

-- [[ Notification State ]]
getgenv().DestineFarm.MutationNotifier = false

-- [[ Shared Detection Scanner Logic ]]
local function scanItemForNotification(item, zoneName)
    if not getgenv().DestineFarm.MutationNotifier then return end
    
    -- Checks if item matches the dropdown selection
    local currentMutation = item:GetAttribute("mutation")
    if currentMutation == getgenv().DestineFarm.SelectedMutation then
        Luna:Notification({
            Title = "✨ Mutation Detected!",
            Content = string.format("A [%s] item has spawned in %s!", currentMutation, zoneName),
            Icon = "notifications_active",
            ImageSource = "Material"
        })
    end
end

-- [[ Bind Event Listeners to Zones ]]
local function initializeZoneWatchers()
    for zoneName, folder in pairs(ZoneMapping) do
        if folder then
            -- Scan existing assets when toggle flipped
            folder.ChildAdded:Connect(function(child)
                task.wait(0.1) -- Small yield to let data attributes load cleanly
                scanItemForNotification(child, zoneName)
                
                -- Watch if an already spawned item changes attributes later
                child:GetAttributeChangedSignal("mutation"):Connect(function()
                    scanItemForNotification(child, zoneName)
                end)
            end)
        end
    end
end

-- Run initialization thread once in background
task.spawn(initializeZoneWatchers)

-- [[ UI Control Toggle ]]
local NotifierToggle = FarmTab:CreateToggle({
	Name = "Mutation Spawn Notifier",
	Description = "Alerts your screen instantly if your chosen mutation spawns anywhere",
	CurrentValue = false,
	Callback = function(Value)
		getgenv().DestineFarm.MutationNotifier = Value
        if Value then
            -- Fast initial sweep of current items when turned on
            for zoneName, folder in pairs(ZoneMapping) do
                if folder then
                    for _, item in ipairs(folder:GetChildren()) do
                        scanItemForNotification(item, zoneName)
                    end
                end
            end
        end
	end
}, "MutationNotifierToggle")

-- [[ ScreenGui Setup for Left Corner UI ]]
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Remove old UI if exists
local old = CoreGui:FindFirstChild("DestineQuickAction")
if old then
    old:Destroy()
end

-- Main GUI
local QuickGui = Instance.new("ScreenGui")
QuickGui.Name = "DestineQuickAction"
QuickGui.ResetOnSpawn = false
QuickGui.Parent = CoreGui
QuickGui.Enabled = true

-- Panel
local SlidePanel = Instance.new("Frame")
SlidePanel.Size = UDim2.new(0, 150, 0, 55)
SlidePanel.Position = UDim2.new(0, -170, 1, -90) -- hidden bottom-left
SlidePanel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
SlidePanel.BorderSizePixel = 0
SlidePanel.Parent = QuickGui

Instance.new("UICorner", SlidePanel).CornerRadius = UDim.new(0, 8)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(150, 50, 250)
Stroke.Thickness = 1.5
Stroke.Parent = SlidePanel

-- Button
local StealButton = Instance.new("TextButton")
StealButton.Size = UDim2.new(1, -10, 1, -10)
StealButton.Position = UDim2.new(0, 5, 0, 5)
StealButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
StealButton.Text = "Instant Steal"
StealButton.TextColor3 = Color3.fromRGB(240, 240, 245)
StealButton.TextSize = 14
StealButton.Font = Enum.Font.SourceSansBold
StealButton.Parent = SlidePanel

Instance.new("UICorner", StealButton).CornerRadius = UDim.new(0, 6)

-- Action
StealButton.MouseButton1Click:Connect(function()
    local char = Players.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if hrp then
        hrp.CFrame = CFrame.new(31, 14, -0)

        if Luna then
            Luna:Notification({
                Title = "Destine Hub",
                Content = "Teleported successfully!",
                Icon = "bolt",
                ImageSource = "Material"
            })
        end
    end
end)

-- Animation system
local function showPanel()
    TweenService:Create(SlidePanel, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 20, 1, -90)
    }):Play()
end

local function hidePanel()
    local tween = TweenService:Create(SlidePanel, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = UDim2.new(0, -170, 1, -90)
    })

    tween:Play()
end

-- Toggle state
getgenv().DestineFarm = getgenv().DestineFarm or {}
getgenv().DestineFarm.QuickActionUI = false

local function setPanel(state)
    if state then
        QuickGui.Enabled = true
        showPanel()
    else
        hidePanel()
        task.delay(0.3, function()
            if not getgenv().DestineFarm.QuickActionUI then
                QuickGui.Enabled = false
            end
        end)
    end
end

-- Toggle from your UI
local QuickUIToggle = FarmTab:CreateToggle({
	Name = "Show Quick Action Panel",
	CurrentValue = false,
	Callback = function(v)
		getgenv().DestineFarm.QuickActionUI = v
		setPanel(v)
	end
})

-- [[ Shop & Progression Tab ]]
local ShopTab = Window:CreateTab({
	Name = "Shop & Upgrades",
	Icon = "shopping_cart", 
	ImageSource = "Material",
	ShowTitle = true
})

-- [[ Global State Management ]]
getgenv().DestineShop = {
    AutoBuy1 = false,
    AutoBuy10 = false,
    AutoCarry = false,
    AutoSell = false,
    AutoRebirth = false
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")

-- Cache target remote pathways safely
local buySoloEvent = Events:WaitForChild("buySoloEvent")
local buyCarryEvent = Events:WaitForChild("buyCarryEvent")
local sellAllCharactersEvent = Events:WaitForChild("sellAllCharactersEvent")
local doRebirthEvent = Events:WaitForChild("doRebirthEvent")

-- [[ Background Automation Processes ]]
task.spawn(function()
    while task.wait(0.5) do
        -- 1. Auto Buy Solo x1
        if getgenv().DestineShop.AutoBuy1 then
            pcall(function() buySoloEvent:FireServer(1) end)
        end
        -- 2. Auto Buy Solo x10
        if getgenv().DestineShop.AutoBuy10 then
            pcall(function() buySoloEvent:FireServer(10) end)
        end
        -- 3. Auto Buy Carry
        if getgenv().DestineShop.AutoCarry then
            pcall(function() buyCarryEvent:FireServer() end)
        end
        -- 4. Auto Sell All Characters
        if getgenv().DestineShop.AutoSell then
            pcall(function() sellAllCharactersEvent:FireServer() end)
        end
        -- 5. Auto Rebirth
        if getgenv().DestineShop.AutoRebirth then
            pcall(function() doRebirthEvent:FireServer() end)
        end
    end
end)

-- [[ UI Section Layouts with Fixed Callbacks ]]

-- SECTION 1: Single Purchases
ShopTab:CreateSection("Buy Solo x1 Management")

local Toggle1 = ShopTab:CreateToggle({
	Name = "Auto Buy Solo x1",
	Description = "Loops the single solo purchase script sequence continuously",
	CurrentValue = false,
	Callback = function(State) 
		getgenv().DestineShop.AutoBuy1 = State 
	end
}, "AutoBuy1Toggle")

local Button1 = ShopTab:CreateButton({
	Name = "Manual Buy Solo x1",
	Description = "Fires the solo purchase event string exactly one time",
	Callback = function() 
		pcall(function() buySoloEvent:FireServer(1) end) 
	end
})


-- SECTION 2: Bulk Purchases
ShopTab:CreateSection("Buy Solo x10 Bulk")

local Toggle2 = ShopTab:CreateToggle({
	Name = "Auto Buy Solo x10",
	Description = "Loops the bulk x10 solo purchase network script sequence",
	CurrentValue = false,
	Callback = function(State) 
		getgenv().DestineShop.AutoBuy10 = State 
	end
}, "AutoBuy10Toggle")

local Button2 = ShopTab:CreateButton({
	Name = "Manual Buy Solo x10",
	Description = "Fires the bulk x10 solo purchase event exactly one time",
	Callback = function() 
		pcall(function() buySoloEvent:FireServer(10) end) 
	end
})


-- SECTION 3: Carry Services
ShopTab:CreateSection("Carry Purchases")

local Toggle3 = ShopTab:CreateToggle({
	Name = "Auto Buy Carry",
	Description = "Loops the companion carry purchase protocol automatically",
	CurrentValue = false,
	Callback = function(State) 
		getgenv().DestineShop.AutoCarry = State 
	end
}, "AutoCarryToggle")

local Button3 = ShopTab:CreateButton({
	Name = "Manual Buy Carry",
	Description = "Fires the companion carry upgrade event exactly one time",
	Callback = function() 
		pcall(function() buyCarryEvent:FireServer() end) 
	end
})


-- SECTION 4: Liquidate Characters
ShopTab:CreateSection("Inventory Liquidator")

local Toggle4 = ShopTab:CreateToggle({
	Name = "Auto Sell All Characters",
	Description = "Loops the complete full character inventory clearance function",
	CurrentValue = false,
	Callback = function(State) 
		getgenv().DestineShop.AutoSell = State 
	end
}, "AutoSellToggle")

local Button4 = ShopTab:CreateButton({
	Name = "Manual Sell All",
	Description = "Fires the absolute full asset liquidation clear single event",
	Callback = function() 
		pcall(function() sellAllCharactersEvent:FireServer() end) 
	end
})


-- SECTION 5: Prestige System
ShopTab:CreateSection("Progression & Prestige")

local Toggle5 = ShopTab:CreateToggle({
	Name = "Auto Rebirth",
	Description = "Loops character profile reset mechanics to claim stats automatically",
	CurrentValue = false,
	Callback = function(State) 
		getgenv().DestineShop.AutoRebirth = State 
	end
}, "AutoRebirthToggle")

local Button5 = ShopTab:CreateButton({
	Name = "Manual Rebirth Now",
	Description = "Triggers a single prestige profile roll call check on your player data",
	Callback = function() 
		pcall(function() doRebirthEvent:FireServer() end) 
	end
})
