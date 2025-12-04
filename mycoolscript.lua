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
	local successGemsL, LoadGemSave = pcall(function()
		return GemsSave:GetAsync(plr.UserId)
	end)
	local successCPSl, LoadCpsAmount = pcall(function()
		return CpsAmountSave:GetAsync(plr.UserId)
	end)
	if successCPSl then
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
	local SuccesCOOKIESl, loadCookies = pcall(function()
		return cookieSave:GetAsync(plr.UserId) --67!!!!!!!--
	end)
	if SuccesCOOKIESl then
		cookies.Value = loadCookies or 0 --<--- or 0 is if you dont have any data it will give you 0 or if its the first time playing you will have 0
		print("succesfully loaded data")
	else 
		warn("could not load data")
	end	
	local succesSPEEDl, loadSpeed = pcall(function()
		return SpeedSave:GetAsync(plr.UserId)
	end)
	task.spawn(function() --<-- for the Whiletrueloop So if you have cps upgtades the rest of the script runs
		while true do 
			task.wait(1)
			leaderstats.Cookies.Value += CpsAmount.Value --<-- waits 1 sec and give you the amount of cookies that your cpsamount is 
		end
	end)	
end)--<-- all for loading data when joining	
game.Players.PlayerRemoving:Connect(function(plr)
	local OKSAVEGEMS, saveGems = pcall(function()
		return GemsSave:SetAsync(plr.UserId, plr.leaderstats.Gems.Value)
	end)
	local successSTREBGTHl, saveStrength = pcall(function()
		return StrengthSave:SetAsync(plr.UserId, plr.hiddenstats.StrengthUpgrades.Value)
	end)
	local succes, saveCookies = pcall(function()
		return cookieSave:SetAsync(plr.UserId, plr.leaderstats.Cookies.Value)
	end)
	local succesSpeed, savespeed = pcall(function()
		return SpeedSave:SetAsync(plr.UserId, plr.hiddenstats.SU.Value)
	end)
	local successCPS, saveCps = pcall(function()
		return cpsSave:SetAsync(plr.UserId, plr.hiddenstats.CpsUpgrade.Value)
	end)
	local successCPSAMOUNT, SaveCpsAmount = pcall(function()
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
CPSEvent.OnServerInvoke = function(plr, cpsPrice) --<-- this "catches" the remote func called when the Cps upgrade button is pressed 
	local leaderstats = plr.leaderstats --<-- locates the leaderstats folder
	local cookies = leaderstats.Cookies --<-- locates the cookies value	
	local hiddenstats = plr:WaitForChild("hiddenstats") --<-- ok all local "smth" = "smth2"  ists just localting smth and giving it a name so you dont have to do "game.workspace.smth2"	
	local cps = hiddenstats:WaitForChild("CpsUpgrade")
	local cpsAmount = hiddenstats:WaitForChild("CpsAmount")
	if cookies.Value >= cpsPrice then --<
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
		local hiddenstats = plr:WaitForChild("hiddenstats")--<
		local SU = hiddenstats.SU--<
		if SU.Value == 10 then--< 
			warn(plr.Name.."has reached max upgrade limit")
			return false, SpeedPrice
		elseif SU.Value <= 9 then
			SU.Value += 1
		end--< from here up to the local hidden starts  is here to check if the player has maxed out the upgrades or not
		cookies.Value = cookies.Value - SpeedPrice --<-- if you get past the check it will take the price away from the players cookies
		local newSpeed = speed + 2.3--<-
		local AddedPrice = SpeedPrice *2--<-
		return true, AddedPrice, newSpeed--<-
	else 
		return false, SpeedPrice, speed
	end--<- for the remote funtion to change the players speed
end--<-- all for handling buying the speed upgrade wich give you more speed per upgrade
local CEF = game.ReplicatedStorage.Others.cookieExchangesFunc--<-- this down to "3" is for cookies to gems so you can b uy gem upgrades
local CEF = game.ReplicatedStorage.Others.cookieExchangesFunc
CEF.OnServerInvoke = function(plr)
	local leaderstats = plr.leaderstats
	local gems = leaderstats.Gems
	local cookies = leaderstats.Cookies
	if cookies.Value >= 10000 then
		cookies.Value -= 10000
		gems.Value = gems.Value + 10
		return true
	elseif cookies.Value <= 9999 then
		return false
	end
end--3--
local GBF = game.ReplicatedStorage.Others.GemBuyfunc--<this down to "2"iw all for gems to a upgrade
GBF.OnServerInvoke = function(plr)
	local leaderstats = plr.leaderstats
	local gems = leaderstats.Gems
	local cookies = leaderstats.Cookies
	if gems.Value >= 40 then
		gems.Value -= 40
		return true
	elseif gems.Value <= 39 then
		return false
	end
end--2--
task.spawn(function()--<-- this down to 1 is for auto savinf bc i had crashed and dont feel like setting my cookies than spam cliking to get all the upgrades just to test
	while true do
		task.wait(60) 
		for _, plr in pairs(game.Players:GetPlayers()) do
			pcall(function()
				cookieSave:SetAsync(plr.UserId, plr.leaderstats.Cookies.Value)
				StrengthSave:SetAsync(plr.UserId, plr.hiddenstats.StrengthUpgrades.Value)
				SpeedSave:SetAsync(plr.UserId, plr.hiddenstats.SU.Value)
				cpsSave:SetAsync(plr.UserId, plr.hiddenstats.CpsUpgrade.Value)
				CpsAmountSave:SetAsync(plr.UserId, plr.hiddenstats.CpsAmount.Value)
				GemsSave:SetAsync(plr.UserId, plr.leaderstats.Gems.Value)
			end)
		end
	end
end)--1--
local MCG = game.ReplicatedStorage.Others.MobilCookiesGiver--<-- this down is all for a mobil cookie giving button bc im lazy frfr
MCG.OnServerEvent:Connect(function(plr)
	local leaderstats = plr.leaderstats
	local cookies = leaderstats.Cookies
	cookies.Value += 1
end)

