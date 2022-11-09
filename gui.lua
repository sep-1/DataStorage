local MainShop = script.Parent
local ShopBox = MainShop.Frame
local categories = ShopBox.Categories
local mainframe = categories.MainShop
local descbox = MainShop.ShopOverlay
local errorframe = MainShop.ErrorFrame
local desctables 
game.ReplicatedStorage.RE.OnClientEvent:Connect(function(dtables)
	desctables = dtables
end)

repeat wait() until desctables
local deftweentime = 0.25

function maincategoriestootherframe(newframe)
	local newframe = categories:FindFirstChild(newframe.Name)
	local sizevalue = UDim2.new(1,0,0.85,0)
	mainframe:TweenSize(UDim2.new(0,0,0,0),"In","Linear",deftweentime)
	wait(deftweentime)
	newframe:TweenSize(sizevalue,"Out", "Linear" ,deftweentime)
end
function BackorSwitchFrame(newframe)
	local t = categories:GetChildren()
	
	for n,z in pairs(t) do 
		local frame = z

		if frame:IsA("Frame") or frame:IsA("ScrollingFrame") and frame.Size ~= UDim2.new(0,0,0,0) and frame.Name ~= "MainShop" then--and frame.Visible then
			frame:TweenSize(UDim2.new(0,0,0,0),"In","Linear",deftweentime)
            wait(deftweentime)
            break
    	end
	end
	if descbox.Size ~= UDim2.new(0,0,0,0) then
		descbox:TweenSize(UDim2.new(0,0,0,0),"In","Linear",deftweentime)
	end
	local sizevalue = UDim2.new(1,0,0.85,0)
	newframe:TweenSize(sizevalue, "Out", "Linear",deftweentime)
end
function ChangeButtonProps(text, backgroundcolour, textcolour)
	if backgroundcolour == nil then
		backgroundcolour = Color3.fromRGB(83, 181, 255)
	end
	if textcolour == nil then
		textcolour = Color3.fromRGB(255,255,255)
	end
	for _,v in pairs(descbox.Buybutton.RoundedBG:GetChildren()) do
        	if v:IsA("Frame") then
				v.BackgroundColor3 = backgroundcolour
			elseif v:IsA("ImageLabel") then
				v.ImageColor3 = backgroundcolour
		end
	end
	descbox.Buybutton.Text = text
	descbox.Buybutton.TextColor3 = textcolour
end

function setdescription(itemname, category)
    descbox.RawCategoryValue.Value = category
	local rawcategory = category
    local category = category:lower() .. "desctable"
    descbox.description.Text = desctables[category][itemname]["description"]
    descbox.cost.Text = "Cost: " .. desctables[category][itemname]["price"]
    descbox.title.Text = itemname
    descbox.CategoryValue.Value = category
	local plrinventory, equippedinv = game.ReplicatedStorage.RF:InvokeServer()
	if plrinventory[rawcategory][itemname] == nil and descbox.Buybutton.Text ~= "Buy" then
		ChangeButtonProps("Buy", Color3.fromRGB(255,255,255), Color3.fromRGB(255,0,0))
	end
	for index, item in ipairs(plrinventory[rawcategory]) do
		wait()
		if equippedinv[rawcategory]["Name"] ~= itemname and plrinventory[rawcategory][index] == itemname then -- when item is owned but not equipped
			ChangeButtonProps("Equip")
			descbox.OwnedValue.Value = true
		elseif equippedinv[rawcategory]["Name"] == itemname and plrinventory[rawcategory][index] == itemname then -- when item is owned and equipped
			ChangeButtonProps("Equipped")
			descbox.OwnedValue.Value = true
		end
	end
end

function Buy(item, category, rawcategory)
	local RS = game:GetService("ReplicatedStorage")
	local purchased = RS.PurchaseEvent:InvokeServer(item, category, rawcategory)
	if purchased then
		ChangeButtonProps("Equipped")
	elseif not purchased then
		errorframe.ErrorMessage.Text = "You do not have enough money to buy the " .. item
		errorframe.Visible = true
	end
end
descbox.Buybutton.MouseButton1Click:Connect(function()
	local itemname = descbox.title.Text
	local category = descbox.CategoryValue.Value
	local rawcategory = descbox.RawCategoryValue.Value
	local owned = descbox.OwnedValue.Value
	if not owned then
		Buy(itemname, category, rawcategory)
	elseif owned then
		game.ReplicatedStorage.RE3:FireServer(itemname, rawcategory)
		ChangeButtonProps("Equipped")
	end
end)
for i,v in pairs(mainframe:GetChildren()) do
	if v:IsA("TextButton") then
		v.MouseButton1Click:Connect(function()
			maincategoriestootherframe(v)
		end)
	end
end
for b,v in pairs(categories:GetChildren()) do
	if v:FindFirstChild("UIGridLayout") and v.Name ~= "MainShop" then
		local z = v:FindFirstChild("UIGridLayout")
		for i,n in pairs(v:GetChildren()) do
			if n:IsA("TextButton") then
				n.MouseButton1Click:Connect(function()
					BackorSwitchFrame(descbox)
					setdescription(n.Name, v.Name)
				end)
			end
		end
	end
end

local shopbutton = MainShop.ShopButton
local db = false
shopbutton.MouseButton1Click:Connect(function()
	local shopbox = MainShop.Frame
	if not db then
		game.StarterGui:SetCore("TopbarEnabled", false)
		shopbox:TweenSize(UDim2.new(1,0,1.11,0), "Out", "Linear", 0.25) 
		db = true
	elseif db then
		game.StarterGui:SetCore("TopbarEnabled", true)
		shopbox:TweenSize(UDim2.new(0,0,0,0), "Out", "Linear", 0.25) 		
		db = false
	end
end)

local back = ShopBox.Back
back.MouseButton1Click:Connect(function()
	BackorSwitchFrame(mainframe)
end)
local profpic = ShopBox.profilepic
local p = game.Players.LocalPlayer
profpic.Image = "https://www.roblox.com/bust-thumbnail/image?userId=" .. p.UserId .. "&width=420&height=420&format=png"
errorframe.Exit.MouseButton1Click:Connect(function()
	errorframe.Visible = false
end)
while true do
	wait()
	
	if mainframe.Size ~= UDim2.new(0,0,0,0) then
		back.Visible = false
	else
		back.Visible = true
	end
end

	
	
