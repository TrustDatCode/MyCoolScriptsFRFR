local dataStore = game:GetService("DataStoreService")
local cookieSave = dataStore:GetDataStore("cookieSave")
local StrengthSave = dataStore:GetDataStore("Strengthsave")
local SpeedSave = dataStore:GetDataStore("SpeedSave")
local cpsSave = dataStore:GetDataStore("cpsSave")
local CpsAmountSave = dataStore:GetDataStore("CpsAmountSave")
local GemsSave = dataStore:GetDataStore("GemSave")

game.Players.PlayerAdded:Connect(function(plr)
	local hiddenstats = Instance.new("Folder", plr)   --<-- hiddenstats folder so the stats can be saved without showing on the leaderboard
	hiddenstats.Name = "hiddenstats"

	local leaderstats = Instance.new("Folder", plr) --<-- for the cookies  amount to shw on robloxes leaderboard and so i can save them and 
	leaderstats.Name = "leaderstats"
	
	local gems = Instance.new("IntValue", leaderstats)
	gems.Name = "Gems"
	gems.Value = 0
	
	local cookies = Instance.new("IntValue", leaderstats) --<--cookies for the currency of this game for all the upgades 
	cookies.Name = "Cookies"
	cookies.Value = 0
	
	local StrengthUpgrades = Instance.new("IntValue", hiddenstats) -- <-- strength value to save the amount of upgrades and put into hidden stats so its not a value on the roblox leaderboard
	StrengthUpgrades.Name = "StrengthUpgrades"
	StrengthUpgrades.Value = 0
	
	local SpeedUpgrade = Instance.new("IntValue", hiddenstats)
	SpeedUpgrade.Name = "SU" --<-- Short version of speedupgrades
	SpeedUpgrade.Value = 0
	
	local LuckUpgrade = Instance.new("IntValue", hiddenstats) --<-- not done YET idk what its going to do
	LuckUpgrade.Name = "LU"
	LuckUpgrade.Value = 0
	
	local cpsUpgrade = Instance.new("IntValue", hiddenstats)
	cpsUpgrade.Name = "CpsUpgrade"
	cpsUpgrade.Value = 0
	
	local CpsAmount = Instance.new("IntValue", hiddenstats)
	CpsAmount.Name = "CpsAmount"
	CpsAmount.Value = 0
	
	local success, LoadGemSave = pcall(function()
		return GemsSave:GetAsync(plr.UserId)
	end)
	
	local success, LoadCpsAmount = pcall(function()
		return CpsAmountSave:GetAsync(plr.UserId)
	end)
	if success then
		CpsAmount.Value = LoadCpsAmount or 0 
	end
	
	local success, loadStrength = pcall(function()		--<-- all for loading data when joining
		return StrengthSave:GetAsync(plr.UserId)
	end)
	
	if success then
	StrengthUpgrades.Value = loadStrength or 0 --<--- or 0 is if you dont have any data it will give you 0 or if you havent got any of the upgrades it will give you 0
		print("succesfully loaded data")
	else 
		warn("could not load data")
	end
	
	local Succes, loadCookies = pcall(function()
		return cookieSave:GetAsync(plr.UserId) --67!!!!!!!--
	end)
	
	if Succes then
		cookies.Value = loadCookies or 0 --<--- or 0 is if you dont have any data it will give you 0 or if its the first time playing you will have 0
		print("succesfully loaded data")
	else 
		warn("could not load data")
	end	

	local succes, loadSpeed = pcall(function()
		return SpeedSave:GetAsync(plr.UserId)
	end)
	
	task.spawn(function()
	while true do 
		task.wait(1)
		leaderstats.Cookies.Value += CpsAmount.Value
		end
	end)	
	task.spawn(function()
		while true do
			task.wait(1)
			gems.Value += 1
		end
	end)
end)--<-- all for loading data when joining	

game.Players.PlayerRemoving:Connect(function(plr)
	local success, saveGems = pcall(function()
		return GemsSave:SetAsync(plr.UserId, plr.leaderstats.Gems.Value)
	end)
	local success, saveStrength = pcall(function()
		return StrengthSave:SetAsync(plr.UserId, plr.hiddenstats.StrengthUpgrades.Value)
	end)
	if success then
		print("saved")
	else
		warn("could not save")
	end
	
	local succes, saveCookies = pcall(function()
		return cookieSave:SetAsync(plr.UserId, plr.leaderstats.Cookies.Value)
	end)
	
	if succes then
		print("saved")
	else
		warn("could not save")
	end
	
	local succes, savespeed = print(function()
		return SpeedSave:SetAsync(plr.UserId, plr.hiddenstats.SU.Value)
	end)
	local success, saveCps = pcall(function()
		return cpsSave:SetAsync(plr.UserId, plr.hiddenstats.CpsUpgrade.Value)
	end)
	local success, SaveCpsAmount = pcall(function()
		return CpsAmountSave:SetAsync(plr.UserId, plr.hiddenstats.CpsAmount.Value)
	end)
end) --<--- all for saving data when leaving

local strengthEventF = game.ReplicatedStorage.Upgrades.StrenghtEventFunc
local StrengthBind = game.ReplicatedStorage.Upgrades.StrengthBind
strengthEventF.OnServerInvoke = function(plr, StrongUpgPrice)
	local leaderstats = plr.leaderstats
	local cookies = leaderstats.Cookies
	local ps = false
	if cookies.Value >= StrongUpgPrice then
		local hiddenstats = plr:WaitForChild("hiddenstats")
		local StrengthUpgrades = hiddenstats.StrengthUpgrades
		if StrengthUpgrades.Value == 10 then
			
			warn(plr.Name.."has reached max upgrade limit")
			return false, StrongUpgPrice
		elseif StrengthUpgrades.Value <= 9 then
			StrengthUpgrades.Value += 1
		end
		
		cookies.Value = cookies.Value - StrongUpgPrice
		StrengthBind:Fire(plr)

		local AddedPrice = StrongUpgPrice *1.6
		return true, AddedPrice
	else 
		return false, StrongUpgPrice
		end
end--  <--- all for handling buying the strength upgrade wich give you more cookies per click 

local CPSEvent = game.ReplicatedStorage.Upgrades["CPS/CookiePerSec"]

CPSEvent.OnServerInvoke = function(plr, cpsPrice)
	local leaderstats = plr.leaderstats
	local cookies = leaderstats.Cookies
	local hiddenstats = plr:WaitForChild("hiddenstats")
	local cps = hiddenstats:WaitForChild("CpsUpgrade")
	local cpsAmount = hiddenstats:WaitForChild("CpsAmount")

	if cookies.Value >= cpsPrice then
		if cps.Value >= 32 then
			warn("has reached max CPS upgrade limit")
			return false, cpsPrice
		end
		
		cps.Value += 1
		cpsAmount.Value += 2
		cookies.Value -= cpsPrice

		local newPrice = cpsPrice * 1.5
		return true, newPrice
	else
		warn("cannot afford CPS upgrade")
		return false, cpsPrice
	end
end

		

local SpeedEventF = game.ReplicatedStorage.Upgrades.SpeedEventFunc
local SpeedBind = game.ReplicatedStorage.Upgrades.SpeedBind
SpeedEventF.OnServerInvoke = function(plr, SpeedPrice, speed)
	local leaderstats = plr.leaderstats
	local cookies = leaderstats.Cookies
	local ps = false
	if cookies.Value >= SpeedPrice then
		local hiddenstats = plr:WaitForChild("hiddenstats")
		local SU = hiddenstats.SU
		if SU.Value == 10 then

			warn(plr.Name.."has reached max upgrade limit")
			return false, SpeedPrice
		elseif SU.Value <= 9 then
			SU.Value += 1
		end

		cookies.Value = cookies.Value - SpeedPrice
		
		local newSpeed = speed + 2.3
		local AddedPrice = SpeedPrice *2
		return true, AddedPrice, newSpeed

	else 
		return false, SpeedPrice, speed
	end
end

local GBF = game.ReplicatedStorage.Others.GemBuyfunc
GBF.OnServerInvoke = function(plr)
	local leaderstats = plr.leaderstats
	local gems = leaderstats.Gems
	if gems.Value >= 50 then
		gems.Value -= 50
		return true
	elseif gems.Value <= 49 then
		return false
	end
end
