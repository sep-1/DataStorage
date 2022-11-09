local desctables = {
	effectsdesctable = {
	
	}, 
	petsdesctable = {
	
	}, 
	radiosdesctable = {
		["Classic Radio"] = {description = "Just your average radio, gets the job done.", price = 155}, 
		["Old Radio"] = {description = "An average radio, but with less quality.", price = 50}
	},
	trailsdesctable = {
		["Rainbow Trail"] = {description = "A rainbow trail.", price = 125 }
	}
}
local DS = game:GetService("DataStoreService")
function EquipRadio(radio, player)
	local char
	repeat wait() until player.Character
	char = player.Character
	local radio = game.ServerStorage.Radiolist:FindFirstChild(radio):Clone()
	if char:FindFirstChild("Radio") then
		char.Radio:Destroy()		
	end
	radio.Name = "Radio"				
	radio.Parent = char
end
function EquipTrail(trail, player)
	local trail = game.ServerStorage.Traillist:FindFirstChild(trail):Clone()
	local char 
	repeat wait() until player.Character
	char = player.Character
	if char:FindFirstChild("Trail") == nil then
		trail.Parent = char.Head
		trail.Attachment0 = attachment0
		trail.Attachment1 = attachment1
		trail.Name = "Trail"
	else
		char:FindFirstChild("Trail"):Destroy() 
	end
end
function EquipPet(pet, player)
		if player.Character:FindFirstChild("Pet") == nil then
				local pet = game.ServerStorage.Petlist:FindFirstChild(pet):Clone()
			pet.CanCollide = false
			pet.Name = "Pet"
			pet.Parent = player.Character
		end
	local BP = Instance.new("BodyPosition",pet)
	local BG = Instance.new("BodyGyro", pet)
	BG.D = 50
	BG.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
	while player.Character.HumanoidRootPart do
		wait()
		BP.Position = player.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.CFrame.lookVector * 3 + player.Character.HumanoidRootPart.CFrame.rightVector * 2 + Vector3.new(0,2,0)
		BG.CFrame = CFrame.new(pet.Position, player.Character.HumanoidRootPart.Position + player.Character.HumanoidRootPart.CFrame.lookVector * 10 + player.Character.HumanoidRootPart.CFrame.upVector * 2)--CFrame == CFrame.new() * CFrame.Angles(math.rad(0,math.rad(90),0)) * CFrame.new(0,0,0))
	end
end
game.Players.PlayerAdded:Connect(function(player)
	local musicevent = game.ReplicatedStorage.MusicPlayEvent
   	musicevent:FireClient(player)
	local scope = player.UserId
	local PlayerData = DS:GetDataStore("PlayerData", scope)
	local equippedinv = PlayerData:GetAsync("equippedinv")
	game.ReplicatedStorage.RE:FireClient(player, desctables, equippedinv)
	local leaderstats = Instance.new("Model", player)
	leaderstats.Name = "leaderstats"
	local money = Instance.new("IntValue", leaderstats)
	money.Name = "Money"
	local firsttimedata = PlayerData:GetAsync("firsttimedata")
	if not firsttimedata then
		local baseinventorytable = {
			Radios = {},
			Effects = {},
			Trails = {},
			Pets = {}	
		}
		PlayerData:SetAsync("firsttimedata", true)
		PlayerData:SetAsync("plrinventory", baseinventorytable)
		PlayerData:SetAsync("equippedinv", baseinventorytable)
	end
	player.CharacterAdded:Connect(function(character)
		local musicevent = game.ReplicatedStorage.MusicPlayEvent
   		musicevent:FireClient(player)
		attachment0 = Instance.new("Attachment", character.Head)
		attachment0.Name = "TrailAttachment0" 
		attachment1 = Instance.new("Attachment", character.HumanoidRootPart)
		attachment1.Name = "TrailAttachment1" 
		
		character.Humanoid.DisplayDistanceType = "None"
		local nametag = game.ServerStorage.NameGUI:Clone()
		nametag.PlayerToHideFrom = player
		if player.Name == "AsssassinGod" then
			local devtag = game.ServerStorage.DeveloperTag:Clone()
			devtag.Parent = character.Head
			devtag.PlayerToHideFrom = player
		elseif player.Name == "pie303" then
			local devtag = game.ServerStorage.DeveloperTag:Clone()
			devtag.PlayerToHideFrom = player
			devtag.TextLabel.TextColor3 = Color3.new(0, 50, 152)
			devtag.TextLabel.TextStrokeColor3 = Color3.new(255, 158, 39)
			devtag.Parent = character.Head		
		end
		if player.Name == "ExplodingTNTpls" then
			local mousetag = game.ServerStorage.MouseTag:Clone()
			mousetag.Parent = character.Head
			mousetag.PlayerToHideFrom = player
		end
		if player.Name == "MustacheSheepYT" then
			local sheeptag = game.ServerStorage.PInkSheepTag:Clone()
			sheeptag.Parent = character.Head
			sheeptag.PlayerToHideFrom = player
		end
		nametag.TextLabel.Text = player.Name
		nametag.Parent = character.Head
	end) 
	local scope = player.UserId
    local PlayerData = DS:GetDataStore("PlayerData", scope)
	local equippedDS = PlayerData:GetAsync("equippedinv")
	print(equippedDS)
	for a,f  in pairs(equippedDS) do
		print(f)
		print(a)
		if f.Name ~= nil and a == "Radios" then
			EquipRadio(f.Name, player)
		elseif f.Name ~= nil and a == "Effects" then
			--EquipEffect(f[1], player)
		elseif f.Name ~= nil and a == "Trails" then
			EquipTrail(f[1], player)
		elseif f.Name ~= nil and a == "Pets" then
			EquipPet(f[1], player)
		end	
	end 
end)
game.ReplicatedStorage.BoomboxPlayEvent.OnServerEvent:Connect(function(player, musicid,textboxtext)
	local radio = player.Character:FindFirstChild("Radio")
	repeat wait() until radio 
	if radio then
		local sound = radio.Handle.Sound	
		if textboxtext:sub(1,13) ~= "rbxassetid://" then
			print("helloah")
			sound.SoundId = musicid .. textboxtext 
			sound:Play()
		end
	end
end)

game.ReplicatedStorage.RemoteEvent.OnServerEvent:Connect(function(player, Brickcolorvalue)
	local part = Instance.new("Part", game.Workspace)
	part.BrickColor = Brickcolorvalue
	part.Position = player.Character.Head.Position
end)

game.ReplicatedStorage.PurchaseEvent.OnServerInvoke = function(player, item, category, rawcategory)
	local scope = player.UserId
	local PlayerData = DS:GetDataStore("PlayerData", scope)
	local plrinventory = PlayerData:GetAsync("plrinventory")
	local equippedinv = PlayerData:GetAsync("equippedinv")
	if desctables[category][item] and plrinventory[rawcategory][item] == nil then
		local rawcategories = {"Radios", "Effects", "Trails", "Pets"}
		if desctables[category][item]["price"] <= player.leaderstats.Money.Value then
			if rawcategory == rawcategories[1] then
				PlayerData:UpdateAsync("equippedinv", function(oldtable)
					local categorytable = oldtable[rawcategory]
					if categorytable ~= {} then
						categorytable = {}
					end 
					oldtable[rawcategory]["Name"] = item 
					return oldtable
				end)
				EquipRadio(item, player)
				PlayerData:UpdateAsync("plrinventory", function(oldtable)
					local categorytable = oldtable[rawcategory]
					table.insert(categorytable, item)
					return oldtable
				end)
				player.leaderstats.Money.Value = player.leaderstats.Money.Value - desctables[category][item]["price"]
				return true
			elseif rawcategory == rawcategories[2] then
				player.leaderstats.Money.Value = player.leaderstats.Money.Value - desctables[category][item]["price"]
				return true
			elseif rawcategory == rawcategories[3] then
				EquipTrail(item, player)
				player.leaderstats.Money.Value = player.leaderstats.Money.Value - desctables[category][item]["price"]
				return true			
			elseif rawcategory == rawcategories[4] then
				player.leaderstats.Money.Value = player.leaderstats.Money.Value - desctables[category][item]["price"]
				return true
			end
		else
			return false 
		end
	end
end

game.ReplicatedStorage.RF.OnServerInvoke = function(player)
	local scope = player.UserId
	local PlayerData = DS:GetDataStore("PlayerData", scope)
	local plrinventory = PlayerData:GetAsync("plrinventory")
	local equippedinv = PlayerData:GetAsync("equippedinv")
	return plrinventory , equippedinv   
end

game.ReplicatedStorage.RE3.OnServerEvent:Connect(function(player, item, category)
	local scope = player.userId
	local PlayerData = DS:GetDataStore("PlayerData", scope)
	local function Equipintoinv()
		PlayerData:UpdateAsync("equippedinv", function(oldtable)
			local categorytable = oldtable[category]
			oldtable[category]["Name"] = item 						
			return oldtable
		end)
	end
	if category == "Radios" then
		Equipintoinv()
		EquipRadio(item, player)
	elseif category == "Effects" then
		Equipintoinv()
	elseif category == "Pets" then
		Equipintoinv()
		EquipPet(item, player)
	elseif category == "Trails" then
		Equipintoinv()
		EquipTrail(item, player)
	end
end) 
