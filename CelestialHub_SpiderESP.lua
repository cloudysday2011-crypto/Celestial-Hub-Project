-- ====================================================================
-- CELESTIAL FRAMEWORK [MOBILE V19.18.16 - FLING ENGINE STABILITY + CACHE]
-- + ANTI FLING QUANTUM MASTER INTEGRATION
-- + OTI (OBJECT THREAT INTELLIGENCE) — SEPARADO DE QMA
-- + QMA REFORGED / COIN FARM TWO-TARGET MICRO-BATCH
-- + MULTI GAME MODE (MM2 / MURDER DUELS / SPIDER) + TEAM ESP + SMART AIMBOT
-- + LOBBY/MATCH DETECTION + SELF ESP + DEFERRED UI LOADING
-- + QMA ADAPTIVE BATCH SCHEDULER & PERFORMANCE OPTIMIZATIONS
-- ====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

if not _G.Celestial then
	_G.Celestial = {}
end

if _G.Celestial.CrosshairCleanup then
	pcall(_G.Celestial.CrosshairCleanup)
	_G.Celestial.CrosshairCleanup = nil
end
_G.Celestial.CrosshairRefreshUI = nil

-- ====================================================================
-- GLOBAL CLEANUP / OLD CONNECTIONS
-- ====================================================================

if _G.Celestial.SpiderESP and _G.Celestial.SpiderESP.Cleanup then
	pcall(_G.Celestial.SpiderESP.Cleanup)
end
_G.Celestial.SpiderESP = nil

if _G.Celestial.ConnectionPerformanceWidgets then
	pcall(function() _G.Celestial.ConnectionPerformanceWidgets:Disconnect() end)
	_G.Celestial.ConnectionPerformanceWidgets = nil
end
if _G.Celestial.ConnectionPerformanceDescendantAdded then
	pcall(function() _G.Celestial.ConnectionPerformanceDescendantAdded:Disconnect() end)
	_G.Celestial.ConnectionPerformanceDescendantAdded = nil
end
if _G.Celestial.RestoreFPSOptimizations then
	pcall(function() _G.Celestial.RestoreFPSOptimizations() end)
	_G.Celestial.RestoreFPSOptimizations = nil
end

if _G.Celestial.ConnectionFly then _G.Celestial.ConnectionFly:Disconnect() end
if _G.Celestial.ConnectionAntiFling then _G.Celestial.ConnectionAntiFling:Disconnect() end
if _G.Celestial.ClearQMAPlayerIsolation then pcall(_G.Celestial.ClearQMAPlayerIsolation) end
if _G.Celestial.ClearQMPlayerPassThrough then pcall(_G.Celestial.ClearQMPlayerPassThrough) end
if _G.Celestial.ConnectionRoleScanner then _G.Celestial.ConnectionRoleScanner:Disconnect() end
if _G.Celestial.ConnectionGhostESP then _G.Celestial.ConnectionGhostESP:Disconnect() end
if _G.Celestial.GhostESPProxy then
	pcall(function() _G.Celestial.GhostESPProxy:Destroy() end)
	_G.Celestial.GhostESPProxy = nil
end
if _G.Celestial.ConnectionRespawn then _G.Celestial.ConnectionRespawn:Disconnect() end
if _G.Celestial.ConnectionBubbleAnim then _G.Celestial.ConnectionBubbleAnim:Cancel() end
if _G.Celestial.ConnectionPowerDetector then _G.Celestial.ConnectionPowerDetector:Disconnect() end
if _G.Celestial.ConnectionTrapESP then _G.Celestial.ConnectionTrapESP:Disconnect() end
if _G.Celestial.ConnectionTrapDescendant then _G.Celestial.ConnectionTrapDescendant:Disconnect() end
if _G.Celestial.ConnectionTrapRemoving then _G.Celestial.ConnectionTrapRemoving:Disconnect() end
if _G.Celestial.ConnectionBombBoost then _G.Celestial.ConnectionBombBoost:Disconnect() end
if _G.Celestial.ConnectionNoClip then _G.Celestial.ConnectionNoClip:Disconnect() end
if _G.Celestial.ConnectionPhysModifiers then _G.Celestial.ConnectionPhysModifiers:Disconnect() end
if _G.Celestial.PowerWatchConnections then
	for _, connection in pairs(_G.Celestial.PowerWatchConnections) do
		pcall(function() connection:Disconnect() end)
	end
	_G.Celestial.PowerWatchConnections = nil
end
if _G.Celestial.PowerChangedEvent then
	pcall(function() _G.Celestial.PowerChangedEvent:Destroy() end)
	_G.Celestial.PowerChangedEvent = nil
end
if _G.Celestial.ConnectionRoundTimer then pcall(function() _G.Celestial.ConnectionRoundTimer:Disconnect() end) end
if _G.Celestial.FlingConnection then pcall(function() _G.Celestial.FlingConnection:Disconnect() end) end
if _G.Celestial.FlingCameraConnection then
	pcall(function() _G.Celestial.FlingCameraConnection:Disconnect() end)
	_G.Celestial.FlingCameraConnection = nil
end
if _G.Celestial.FlingCameraState then
	pcall(function()
		local cam = Workspace.CurrentCamera
		local state = _G.Celestial.FlingCameraState
		if cam and state then
			if state.CameraType then cam.CameraType = state.CameraType end
			if state.CameraSubject and state.CameraSubject.Parent then cam.CameraSubject = state.CameraSubject end
			if state.CFrame then cam.CFrame = state.CFrame end
			if state.Focus then cam.Focus = state.Focus end
		end
	end)
	_G.Celestial.FlingCameraState = nil
end
if _G.Celestial.FlingRestoreConnection then pcall(function() _G.Celestial.FlingRestoreConnection:Disconnect() end) end
if _G.Celestial.FlingMotor then
	pcall(function() _G.Celestial.FlingMotor.Enabled = false; _G.Celestial.FlingMotor:Destroy() end)
	_G.Celestial.FlingMotor = nil
end
if _G.Celestial.FlingForce then
	pcall(function() _G.Celestial.FlingForce.Enabled = false; _G.Celestial.FlingForce:Destroy() end)
	_G.Celestial.FlingForce = nil
end
if _G.Celestial.FlingAttachment then
	pcall(function() _G.Celestial.FlingAttachment:Destroy() end)
	_G.Celestial.FlingAttachment = nil
end
if _G.Celestial.FlingForceAttachment then
	pcall(function() _G.Celestial.FlingForceAttachment:Destroy() end)
	_G.Celestial.FlingForceAttachment = nil
end
if _G.Celestial.FlingResetThread then pcall(function() task.cancel(_G.Celestial.FlingResetThread) end) end
if _G.Celestial.GameDetectionConnection then pcall(function() _G.Celestial.GameDetectionConnection:Disconnect() end) end
if _G.Celestial.ScanGui then pcall(function() _G.Celestial.ScanGui:Destroy() end) end
if _G.Celestial.SelfHighlight then pcall(function() _G.Celestial.SelfHighlight:Destroy() end) end

if _G.Celestial.ConnectionOTI then
	pcall(function() _G.Celestial.ConnectionOTI:Disconnect() end)
	_G.Celestial.ConnectionOTI = nil
end

if _G.Celestial.ConnectionFarm then
	pcall(function() task.cancel(_G.Celestial.ConnectionFarm) end)
	_G.Celestial.ConnectionFarm = nil
end

if _G.AntiFlingUltra then
	pcall(function()
		if _G.AntiFlingUltra.Connection then _G.AntiFlingUltra.Connection:Disconnect() end
	end)
	pcall(function()
		if _G.AntiFlingUltra.CharacterConnection then _G.AntiFlingUltra.CharacterConnection:Disconnect() end
	end)
	_G.AntiFlingUltra.Connection = nil
	_G.AntiFlingUltra.CharacterConnection = nil
	pcall(function()
		if _G.AntiFlingUltra.Gui then _G.AntiFlingUltra.Gui:Destroy() end
	end)
	_G.AntiFlingUltra.Gui = nil
end

local successCore, existingGui = pcall(function()
	return CoreGui:FindFirstChild("CelestialMobileHubV19")
end)
if successCore and existingGui then existingGui:Destroy() end

local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
if playerGui then
	local oldPgui = playerGui:FindFirstChild("CelestialMobileHubV19")
	if oldPgui then oldPgui:Destroy() end
end

local existingESP = CoreGui:FindFirstChild("CelestialESP")
if existingESP then existingESP:Destroy() end

_G.Celestial.ESPFolder = Instance.new("Folder")
_G.Celestial.ESPFolder.Name = "CelestialESP"
pcall(function()
	_G.Celestial.ESPFolder.Parent = gethui() or CoreGui
end)

_G.Celestial.HitboxSuppressedPlayer = nil

-- ====================================================================
-- GAME MODE DETECTION
-- ====================================================================

_G.Celestial.GameMode = "UNKNOWN"

local MM2_WEAPON_KEYWORDS = {
	"knife", "dagger", "blade", "cutter", "sword", "shiv", "scaler",
	"gun", "revolver", "pistol", "blaster", "sheriff", "peacemaker",
	"coin", "bag"
}

local DUELS_WEAPON_KEYWORDS = {
	"knife", "revolver", "gun", "pistol", "blade", "dagger",
	"karambit", "saber", "deagle", "blaster", "luger", "stiletto",
	"kunai", "katana", "crossbow"
}

-- Public Spider item labels are used as tolerant hints, not claimed internal instance paths.
-- Runtime names are normalized and corroborated with other signals before the game is selected.
local SPIDER_GAME_PLACE_ID = 5118969548
local SPIDER_ITEM_ALIASES = {
	{Kind = "Red Key", Aliases = {"redkey", "keyred"}},
	{Kind = "Blue Key", Aliases = {"bluekey", "keyblue"}},
	{Kind = "Green Key", Aliases = {"greenkey", "keygreen"}},
	{Kind = "Orange Key", Aliases = {"orangekey", "keyorange"}},
	{Kind = "Yellow Key", Aliases = {"yellowkey", "keyyellow"}},
	{Kind = "Purple Key", Aliases = {"purplekey", "keypurple"}},
	{Kind = "Crowbar", Aliases = {"crowbar"}},
	{Kind = "Battery", Aliases = {"battery"}},
	{Kind = "Wrench", Aliases = {"wrench"}},
	{Kind = "Bug Spray", Aliases = {"bugspray", "spiderspray", "sprayspider"}},
}
local SPIDER_ITEM_NAME_SUFFIXES = {
	tool = true, item = true, model = true, pickup = true, drop = true,
	prop = true, object = true, part = true, handle = true, mesh = true,
	world = true, weapon = true, entity = true,
}

local function NormalizeSpiderName(value)
	return tostring(value or ""):lower():gsub("[^%w]", "")
end

local function SpiderItemKindFromName(name)
	local normalized = NormalizeSpiderName(name)
	if normalized == "" then return nil end
	for _, definition in ipairs(SPIDER_ITEM_ALIASES) do
		for _, alias in ipairs(definition.Aliases) do
			if normalized == alias then return definition.Kind end
			if normalized:sub(1, #alias) == alias then
				local suffix = normalized:sub(#alias + 1)
				local suffixWithoutDigits = suffix:gsub("%d+$", "")
				if suffix == "" or SPIDER_ITEM_NAME_SUFFIXES[suffixWithoutDigits] then
					return definition.Kind
				end
			end
		end
	end
	return nil
end

local function IsSpiderNamedModel(name)
	local normalized = NormalizeSpiderName(name)
	return normalized == "spider" or normalized == "thespider"
		or normalized == "spiderbot" or normalized == "spidernpc"
		or normalized == "spidercharacter" or normalized == "spiderentity"
end

local SpiderDetectionCache = {At = 0, Result = false}
local function ScanSpiderGameSignals(forceRefresh)
	local now = tick()
	if not forceRefresh and SpiderDetectionCache.At > 0 and now - SpiderDetectionCache.At < 1.0 then
		return SpiderDetectionCache.Result
	end
	local function FinishSpiderSignalScan(result)
		SpiderDetectionCache.At = tick()
		SpiderDetectionCache.Result = result
		return result
	end
	local isKnownPlace = game.PlaceId == SPIDER_GAME_PLACE_ID
	local maxPlayers = nil
	pcall(function() maxPlayers = tonumber(Players.MaxPlayers) end)
	local capacitySignal = maxPlayers ~= nil and maxPlayers > 0 and maxPlayers <= 6
	local gameTitleSpider = false
	pcall(function() gameTitleSpider = NormalizeSpiderName(game.Name):find("spider", 1, true) ~= nil end)

	local seenItems = {}
	local spiderNamedModel = false
	local environmentMarkers = {}
	for _, object in ipairs(Workspace:GetDescendants()) do
		local kind = SpiderItemKindFromName(object.Name)
		if kind then seenItems[kind] = true end
		if object:IsA("Model") and IsSpiderNamedModel(object.Name) then
			spiderNamedModel = true
		end
		local normalized = NormalizeSpiderName(object.Name)
		if normalized == "cabin" or normalized == "bunker" or normalized == "shed" then
			environmentMarkers[normalized] = true
		end
	end
	local itemKindCount = 0
	for _ in pairs(seenItems) do itemKindCount += 1 end
	local environmentCount = 0
	for _ in pairs(environmentMarkers) do environmentCount += 1 end

	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	local spiderGuiSignal, mm2GuiSignal, duelsGuiSignal = false, false, false
	if playerGui then
		mm2GuiSignal = playerGui:FindFirstChild("MainGUI") ~= nil
		duelsGuiSignal = playerGui:FindFirstChild("DuelGUI") ~= nil or playerGui:FindFirstChild("DuelHUD") ~= nil
		for _, object in ipairs(playerGui:GetDescendants()) do
			if object:IsA("TextLabel") or object:IsA("TextButton") then
				local text = NormalizeSpiderName(object.Text)
				if text:find("spider", 1, true) then spiderGuiSignal = true; break end
			end
		end
	end

	local structuralSignal = itemKindCount >= 2 or spiderNamedModel or spiderGuiSignal or environmentCount >= 2
	if isKnownPlace and (capacitySignal or structuralSignal or (gameTitleSpider and itemKindCount >= 1))
		and not mm2GuiSignal and not duelsGuiSignal then
		return FinishSpiderSignalScan(true)
	end
	if not isKnownPlace and capacitySignal and itemKindCount >= 3
		and (spiderNamedModel or spiderGuiSignal or environmentCount >= 2)
		and not mm2GuiSignal and not duelsGuiSignal then
		return FinishSpiderSignalScan(true)
	end
	if gameTitleSpider and capacitySignal and (spiderNamedModel or itemKindCount >= 1)
		and not mm2GuiSignal and not duelsGuiSignal then
		return FinishSpiderSignalScan(true)
	end
	return FinishSpiderSignalScan(false)
end

local function ScanGameMode(forceSpiderRefresh)
	if ScanSpiderGameSignals(forceSpiderRefresh) then return "SPIDER" end
	local scoreMM2 = 0
	local scoreDuels = 0

	local mapNames = {"Normal", "Map", "Round", "CoinContainer", "Arena", "DuelArena", "DuelsMap"}
	for _, name in ipairs(mapNames) do
		if Workspace:FindFirstChild(name) then
			if name == "CoinContainer" or name == "Normal" then scoreMM2 += 15
			else scoreDuels += 10 end
		end
	end

	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	if pg then
		if pg:FindFirstChild("MainGUI") then scoreMM2 += 25 end
		if pg:FindFirstChild("DuelGUI") or pg:FindFirstChild("DuelHUD") then scoreDuels += 25 end
	end

	local mm2KnifeFound, mm2GunFound = false, false
	local duelsKnifeFound, duelsGunFound = false, false

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character then
			local containers = {plr.Character, plr:FindFirstChild("Backpack")}
			for _, container in ipairs(containers) do
				if container then
					for _, item in ipairs(container:GetChildren()) do
						if item:IsA("Tool") then
							local lowerName = string.lower(item.Name)
							for _, kw in ipairs(MM2_WEAPON_KEYWORDS) do
								if lowerName:find(kw, 1, true) then
									if kw == "knife" or kw == "dagger" or kw == "blade" then mm2KnifeFound = true
									elseif kw == "gun" or kw == "revolver" or kw == "pistol" then mm2GunFound = true end
								end
							end
							for _, kw in ipairs(DUELS_WEAPON_KEYWORDS) do
								if lowerName:find(kw, 1, true) then
									if kw == "knife" or kw == "dagger" or kw == "blade" or kw == "karambit" or kw == "saber" then duelsKnifeFound = true
									elseif kw == "revolver" or kw == "gun" or kw == "pistol" or kw == "deagle" then duelsGunFound = true end
								end
							end
						end
					end
				end
			end
		end
	end

	if mm2KnifeFound then scoreMM2 += 20 end
	if mm2GunFound then scoreMM2 += 10 end
	if duelsKnifeFound then scoreDuels += 20 end
	if duelsGunFound then scoreDuels += 10 end

	if Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("RevolverDrop") then scoreMM2 += 30 end
	if Workspace:FindFirstChild("DuelPads") or Workspace:FindFirstChild("QueuePad") then scoreDuels += 30 end

	if scoreMM2 > scoreDuels then return "MM2"
	elseif scoreDuels > scoreMM2 then return "DUELS"
	else
		if pg and pg:FindFirstChild("MainGUI") then return "MM2" end
		return "DUELS"
	end
end

local function SetCelestialGameMode(newMode)
	if not newMode then return end
	local previousMode = _G.Celestial.GameMode
	if previousMode == "SPIDER" and newMode ~= "SPIDER" then
		local spiderESP = _G.Celestial.SpiderESP
		if spiderESP and spiderESP.Cleanup then pcall(spiderESP.Cleanup) end
		if _G.Celestial.Highlights then
			for player, highlight in pairs(_G.Celestial.Highlights) do
				if highlight then pcall(function() highlight:Destroy() end) end
				_G.Celestial.Highlights[player] = nil
			end
		end
		if _G.Celestial.SelfHighlight then
			pcall(function() _G.Celestial.SelfHighlight:Destroy() end)
			_G.Celestial.SelfHighlight = nil
		end
	end
	_G.Celestial.GameMode = newMode
end

-- ====================================================================
-- DUELS LOBBY / MATCH DETECTION
-- ====================================================================

local DuelsMatchState = {
	InMatch = false, CurrentMap = nil, LastCheck = 0, LastCharPosition = nil,
	LastTeleportTime = 0, VoteGuiSeen = false, TeamByPlayer = {},
}

local function IsDuelsGreenTeamMarker(plr)
	if not plr or not plr.Character then return false end
	local character = plr.Character
	local function IsGreen(c)
		if typeof(c) ~= "Color3" then return false end
		return c.G > 0.35 and c.G > c.R * 1.18 and c.G > c.B * 1.10
	end
	local function NameSuggestsTeamMarker(obj)
		local n = string.lower(obj.Name or "")
		return n:find("team", 1, true) or n:find("teammate", 1, true) or n:find("ally", 1, true)
			or n:find("friendly", 1, true) or n:find("friend", 1, true) or n:find("indicator", 1, true)
			or n:find("marker", 1, true) or n:find("triangle", 1, true)
	end
	for _, obj in ipairs(character:GetDescendants()) do
		if obj:IsA("BillboardGui") then
			if NameSuggestsTeamMarker(obj) then
				for _, visual in ipairs(obj:GetDescendants()) do
					if visual:IsA("ImageLabel") or visual:IsA("ImageButton") then
						if IsGreen(visual.ImageColor3) then return true end
					elseif visual:IsA("TextLabel") or visual:IsA("TextButton") then
						if IsGreen(visual.TextColor3) then return true end
					elseif visual:IsA("Frame") then
						if IsGreen(visual.BackgroundColor3) then return true end
					elseif visual:IsA("UIStroke") then
						if IsGreen(visual.Color) then return true end
					end
				end
			end
			for _, visual in ipairs(obj:GetDescendants()) do
				if visual:IsA("ImageLabel") or visual:IsA("ImageButton") then
					if IsGreen(visual.ImageColor3) then return true end
				elseif visual:IsA("TextLabel") or visual:IsA("TextButton") then
					if IsGreen(visual.TextColor3) then return true end
				elseif visual:IsA("UIStroke") then
					if IsGreen(visual.Color) then return true end
				end
			end
		end
	end
	return false
end

local function HasAnyDuelsTeamMarker()
	for _, plr in ipairs(Players:GetPlayers()) do
		if IsDuelsGreenTeamMarker(plr) then return true end
	end
	return false
end

local function RefreshDuelsTeamAssignments()
	if not DuelsMatchState.InMatch then return end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local hasGreenMarker = IsDuelsGreenTeamMarker(plr)
			local previous = DuelsMatchState.TeamByPlayer[plr]
			if hasGreenMarker then DuelsMatchState.TeamByPlayer[plr] = "SELF"
			elseif previous == nil then DuelsMatchState.TeamByPlayer[plr] = "ENEMY" end
		end
	end
end

local function GetDuelsTeamKey(plr)
	if not plr then return nil end
	if plr.Team then
		local teamName = string.lower(tostring(plr.Team.Name))
		local teamColor = ""
		pcall(function() teamColor = string.lower(tostring(plr.Team.TeamColor.Name)) end)
		return "TEAM:" .. teamName .. ":" .. teamColor
	end
	local attributeNames = {"Team","TeamName","TeamId","TeamID","DuelTeam","DuelTeamName","DuelTeamId","DuelTeamID","Side","SideName","Faction"}
	for _, container in ipairs({plr, plr.Character}) do
		if container then
			for _, attributeName in ipairs(attributeNames) do
				local ok, value = pcall(function() return container:GetAttribute(attributeName) end)
				if ok and value ~= nil then return "ATTR:" .. attributeName .. ":" .. tostring(value) end
			end
			for _, childName in ipairs(attributeNames) do
				local child = container:FindFirstChild(childName)
				if child and (child:IsA("StringValue") or child:IsA("IntValue") or child:IsA("NumberValue") or child:IsA("ObjectValue")) then
					local value = child.Value
					if typeof(value) == "Instance" then value = value.Name end
					return "VALUE:" .. childName .. ":" .. string.lower(tostring(value))
				end
			end
		end
	end
	return nil
end

local function AreDuelsTeamsKnown()
	local myTeam = GetDuelsTeamKey(LocalPlayer)
	if not myTeam then return false end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local theirTeam = GetDuelsTeamKey(plr)
			if theirTeam and theirTeam ~= myTeam then return true end
		end
	end
	return false
end

local function CheckDuelsMatchState()
	local now = tick()
	if now - DuelsMatchState.LastCheck < 0.5 then return end
	DuelsMatchState.LastCheck = now
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root and DuelsMatchState.LastCharPosition then
		local delta = (root.Position - DuelsMatchState.LastCharPosition).Magnitude
		if delta > 120 then
			DuelsMatchState.InMatch = true
			DuelsMatchState.LastTeleportTime = now
		end
	end
	if root then DuelsMatchState.LastCharPosition = root.Position end
	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	local voteGuiDetected = false
	if pg then
		for _, gui in ipairs(pg:GetChildren()) do
			if gui:IsA("ScreenGui") and gui.Enabled then
				local nl = string.lower(gui.Name)
				if nl:find("vote", 1, true) or nl:find("mapselect", 1, true)
					or nl:find("mapvote", 1, true) or nl:find("duelvote", 1, true) then
					voteGuiDetected = true; break
				end
			end
		end
	end
	if voteGuiDetected then
		DuelsMatchState.VoteGuiSeen = true
		DuelsMatchState.InMatch = false
		DuelsMatchState.TeamByPlayer = {}
	end
	local greenTeamMarkerDetected = HasAnyDuelsTeamMarker()
	if greenTeamMarkerDetected then
		DuelsMatchState.InMatch = true
		DuelsMatchState.VoteGuiSeen = false
	end
	local foundArenaMap = false
	local function IsArenaName(name)
		local nl = string.lower(name)
		return nl:find("arena", 1, true) or nl:find("duelmap", 1, true) or nl:find("battleground", 1, true)
			or nl:find("selectedmap", 1, true) or nl:find("matchmap", 1, true)
	end
	for _, obj in ipairs(Workspace:GetChildren()) do
		if (obj:IsA("Model") or obj:IsA("Folder")) and IsArenaName(obj.Name) then
			foundArenaMap = true; DuelsMatchState.CurrentMap = obj.Name; break
		end
	end
	if not foundArenaMap then
		for _, obj in ipairs(Workspace:GetDescendants()) do
			if (obj:IsA("Model") or obj:IsA("Folder")) and IsArenaName(obj.Name) then
				foundArenaMap = true; DuelsMatchState.CurrentMap = obj.Name; break
			end
		end
	end
	if foundArenaMap then
		DuelsMatchState.InMatch = true; DuelsMatchState.VoteGuiSeen = false
	elseif greenTeamMarkerDetected then
		DuelsMatchState.InMatch = true; DuelsMatchState.VoteGuiSeen = false
	elseif AreDuelsTeamsKnown() then
		DuelsMatchState.InMatch = true; DuelsMatchState.VoteGuiSeen = false
	elseif not voteGuiDetected then
		if now - (DuelsMatchState.LastTeleportTime or 0) > 3 then
			DuelsMatchState.InMatch = false
			DuelsMatchState.VoteGuiSeen = false
			DuelsMatchState.TeamByPlayer = {}
		end
	end
end

-- ====================================================================
-- SCANNING GUI
-- ====================================================================

local function ShowScanningGui()
	local scanGui = Instance.new("ScreenGui")
	scanGui.Name = "CelestialScanGui"
	scanGui.ResetOnSpawn = false
	scanGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	scanGui.IgnoreGuiInset = true
	scanGui.Parent = CoreGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "ScanningFrame"
	mainFrame.Size = UDim2.new(0, 300, 0, 192)
	mainFrame.Position = UDim2.new(0.5, -150, 0.5, -96)
	mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	mainFrame.BackgroundTransparency = 0.25
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = scanGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 16)
	corner.Parent = mainFrame

	local image = Instance.new("ImageLabel")
	image.Name = "ScanImage"
	image.Size = UDim2.new(0, 140, 0, 140)
	image.Position = UDim2.new(0.5, -70, 0, 10)
	image.BackgroundTransparency = 1
	image.Image = "rbxassetid://91431616848054"
	image.ScaleType = Enum.ScaleType.Fit
	image.Parent = mainFrame

	local text = Instance.new("TextLabel")
	text.Name = "ScanText"
	text.Size = UDim2.new(1, -20, 0, 25)
	text.Position = UDim2.new(0, 10, 1, -32)
	text.BackgroundTransparency = 1
	text.Text = "Loading Celestial Hub..."
	text.TextColor3 = Color3.fromRGB(255, 255, 255)
	text.Font = Enum.Font.GothamBold
	text.TextSize = 18
	text.Parent = mainFrame

	_G.Celestial.ScanGui = scanGui

	task.spawn(function()
		while scanGui.Parent do
			task.wait(0.02)
			image.Rotation = (image.Rotation + 5) % 360
		end
	end)
	return scanGui
end

-- ====================================================================
-- STATE
-- ====================================================================

_G.Celestial.State = {
	ESPEnabled = true, ShowOwnESP = false, DangerometerActive = false, PowerDetectorActive = true,
	TrapESPEnabled = false, FlingActive = false,

	AntiFlingActive = true, QuantumAutoDefense = true,
	AntiFlingThreatDistance = 12, AntiFlingThreatLinearVelocity = 120, AntiFlingThreatAngularVelocity = 600,
	AntiFlingSelfLinearVelocity = 160, AntiFlingSelfAngularVelocity = 1200, AntiFlingScanInterval = 0.045,

	AntiFlingAngularEscalationThreshold = 180, AntiFlingVelocityAccelerationThreshold = 70,
	AntiFlingEscalationWindow = 0.45, AntiFlingResidualVerticalVelocity = 80,
	AntiFlingResidualHorizontalVelocity = 80, AntiFlingResidualDisplacement = 4,
	AntiFlingSpinThreshold = 450, AntiFlingSustainedSpinTime = 0.35,
	AntiFlingOrbitDistance = 5.5, AntiFlingOrbitSpeedThreshold = 35,
	AntiFlingThreatConfidenceThreshold = 55, AntiFlingCriticalConfidenceThreshold = 82,
	AntiFlingProtectionHoldTime = 0.35, AntiFlingProtectionReleaseTime = 0.75,
	AntiFlingCriticalProtectionTime = 0.80, AntiFlingMaxSelfCorrectionPerSecond = 30,

	AntiFlingObservedSpeedSuspicion = 25, AntiFlingObservedSpeedCritical = 40,
	AntiFlingPeerSpeedMultiplier = 1.50, AntiFlingSpeedConfirmTime = 0.28,
	AntiFlingSpeedWindow = 0.75, AntiFlingFlyAirTime = 1.35, AntiFlingFlyHoverTime = 0.65,
	AntiFlingFlyHorizontalSpeed = 10, AntiFlingTeleportDistance = 24,
	AntiFlingTeleportSpeed = 75, AntiFlingFlingerSpeedThreshold = 27, AntiFlingFlingerPairDistance = 8,

	AntiFlingNetworkAdaptive = true, AntiFlingRemoteJitterThreshold = 0.055,
	AntiFlingLagGraceMax = 0.65, AntiFlingTeleportConfirmScore = 72,
	AntiFlingExtremeAngularVelocity = 2200, AntiFlingExtremeAngularHold = 0.16,
	AntiFlingDangerIsolationHold = 1.25,

	OTIActive = true, OTIObjectSpeedThreshold = 95, OTIObjectAccelerationThreshold = 85,
	OTIObjectAngularThreshold = 520, OTIThreatDistance = 12, OTISustainedTime = 0.75,
	OTIThreatConfidenceThreshold = 68, OTICriticalThreshold = 88,
	OTITrackingRadius = 75, OTIFullTrackingRadius = 36, OTIMaxObjectsPerTick = 18,
	OTIPoolRefreshInterval = 0.75, OTIDormantTime = 2.0, OTIDormantScanInterval = 0.8,
	OTIDormantSpeedThreshold = 3,

	AimbotActive = false, AimbotSmoothness = 22, AimbotStrength = 5, SuperStableActive = false,
	MurderAimbotActive = false, MurderStabAimbotActive = false,
	StabSmoothness = 50, StabPredictionStrength = 5,
	NoClipActive = false, FlyActive = false, InfiniteJumpActive = false, WallJumpActive = false,
	BombBoostActive = false, ShowTimerActive = true, FPSCounterEnabled = false,
	PingDisplayEnabled = false, FPSBoostActive = false, DisableParticles = false,
	DisableTrails = false, DisableShadows = false, DisableTextures = false,
	DisableEffects = false, ReduceRenderEffects = false, FarmEnabled = false, TweenSpeed = 95,
	FlingMurdererOnScreen = false, FlingSheriffOnScreen = false, FlingStableMode = false,
	FlingAutoResetOptimize = false, FlingCacheBytes = 0, FlingCompletedCount = 0,
	WalkSpeed = 16, JumpPower = 50, FlySpeed = 50, BoostPower = 300,
	TargetPlayer = nil, SelectedFlingTarget = nil,
	CrosshairEnabled = false, CrosshairAssetId = "", CrosshairRotationEnabled = false,
	CrosshairSizeModifier = 0, CrosshairAnimationSpeed = 5,
	MurdererName = "", AimbotMurdererName = "", SheriffName = "", HeroName = "",
	OriginalSheriff = nil, HasGunBeenDropped = false,
	UIVisible = true, WindowMode = "Normal",
	LastUISize = UDim2.new(0, 480, 0, 270), TargetModalWasOpen = false
}

local State = _G.Celestial.State

do
local CHCrosshair = {}
_G.Celestial.CrosshairAPI = CHCrosshair
local CH_CROSSHAIR_MM2_PLACE_ID = 142823291
CHCrosshair.MM2PlaceId = CH_CROSSHAIR_MM2_PLACE_ID
local CH_CROSSHAIR_PRESET_IDS = {
	"5998624778", "158554297", "11716159644", "97501758672412",
	"6480864782", "10973237327", "11759198682", "11390723044",
	"11836160908", "118873987665413", "98669564339365",
}
CHCrosshair.PresetIds = CH_CROSSHAIR_PRESET_IDS

local CHCrosshairConnections = {}
local CHCrosshairMobileImageConnections = setmetatable({}, { __mode = "k" })
local CHCrosshairOriginalMobileImages = setmetatable({}, { __mode = "k" })
local CHCrosshairWritingMobileImage = setmetatable({}, { __mode = "k" })
local CHCrosshairWatchedRoots = setmetatable({}, { __mode = "k" })
local CHCrosshairOriginalObjectSizes = setmetatable({}, { __mode = "k" })
local CHCrosshairOriginalObjectPositions = setmetatable({}, { __mode = "k" })
local CHCrosshairOriginalObjectAnchors = setmetatable({}, { __mode = "k" })
local CHCrosshairOriginalObjectRotations = setmetatable({}, { __mode = "k" })
local CHCrosshairOriginalRotations = setmetatable({}, { __mode = "k" })
local CHCrosshairRotationOriginalAnchors = setmetatable({}, { __mode = "k" })
local CHCrosshairRotationOriginalPositions = setmetatable({}, { __mode = "k" })
local CHCrosshairRotationTweens = setmetatable({}, { __mode = "k" })
local CHCrosshairRotationDurations = setmetatable({}, { __mode = "k" })
local CHCrosshairControllerSnapshots = setmetatable({}, { __mode = "k" })
local CHCrosshairCreatedCursorValues = setmetatable({}, { __mode = "k" })
local CHCrosshairOriginalMouseIcon = nil
local CHCrosshairLastMouseIcon = nil
local CHCrosshairIsCleaningUp = false

local function CHCrosshairKeepConnection(connection)
	if connection then table.insert(CHCrosshairConnections, connection) end
	return connection
end

local function CHCrosshairGetAssetId()
	local raw = tostring(State.CrosshairAssetId or ""):gsub("%s+", "")
	return raw:match("^%d+$")
end
CHCrosshair.GetAssetId = CHCrosshairGetAssetId

local function CHCrosshairDesiredUri()
	local assetId = CHCrosshairGetAssetId()
	if game.PlaceId == CH_CROSSHAIR_MM2_PLACE_ID and State.CrosshairEnabled and assetId then
		return "rbxassetid://" .. assetId
	end
	return nil
end

local function CHCrosshairGetRotationDuration()
	local speed = math.clamp(tonumber(State.CrosshairAnimationSpeed) or 5, 1, 10)
	return 7.0 / speed
end

local function CHCrosshairFindMouseLockController()
	local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
	if not playerScripts then return nil end
	local playerModule = playerScripts:FindFirstChild("PlayerModule")
	if not playerModule then return nil end
	local cameraModule = playerModule:FindFirstChild("CameraModule")
	if cameraModule then
		local direct = cameraModule:FindFirstChild("MouseLockController")
		if direct and direct:IsA("ModuleScript") then return direct end
	end
	for _, object in ipairs(playerModule:GetDescendants()) do
		if object.Name == "MouseLockController" and object:IsA("ModuleScript") then
			return object
		end
	end
	return nil
end

local function CHCrosshairSetClassicCursor()
	local desiredUri = CHCrosshairDesiredUri()
	local controller = CHCrosshairFindMouseLockController()
	if controller then
		local cursorValue = controller:FindFirstChild("CursorImage")
		local snapshot = CHCrosshairControllerSnapshots[controller]
		if desiredUri then
			if not snapshot then
				snapshot = {
					Existed = cursorValue ~= nil and cursorValue:IsA("StringValue"),
					Value = cursorValue and cursorValue:IsA("StringValue") and cursorValue.Value or nil,
				}
				CHCrosshairControllerSnapshots[controller] = snapshot
			end
			if cursorValue and not cursorValue:IsA("StringValue") then
				cursorValue = nil
			else
				if not cursorValue then
					cursorValue = Instance.new("StringValue")
					cursorValue.Name = "CursorImage"
					cursorValue.Parent = controller
					CHCrosshairCreatedCursorValues[controller] = cursorValue
				end
				cursorValue.Value = desiredUri
			end
		elseif snapshot then
			cursorValue = controller:FindFirstChild("CursorImage")
			if snapshot.Existed and cursorValue and cursorValue:IsA("StringValue") then
				cursorValue.Value = snapshot.Value or ""
			else
				local createdValue = CHCrosshairCreatedCursorValues[controller]
				if createdValue and createdValue.Parent == controller then createdValue:Destroy() end
				CHCrosshairCreatedCursorValues[controller] = nil
			end
			CHCrosshairControllerSnapshots[controller] = nil
		end
	end
	local mouse = nil
	pcall(function() mouse = LocalPlayer:GetMouse() end)
	if mouse then
		if desiredUri and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
			if CHCrosshairOriginalMouseIcon == nil then
				CHCrosshairOriginalMouseIcon = mouse.Icon
			end
			mouse.Icon = desiredUri
			CHCrosshairLastMouseIcon = desiredUri
		elseif not desiredUri and CHCrosshairOriginalMouseIcon ~= nil then
			if CHCrosshairLastMouseIcon == nil or mouse.Icon == CHCrosshairLastMouseIcon then
				mouse.Icon = CHCrosshairOriginalMouseIcon
			end
			CHCrosshairOriginalMouseIcon = nil
			CHCrosshairLastMouseIcon = nil
		end
	end
	return controller ~= nil
end

local function CHCrosshairLooksLikeShiftLockImage(imageUri)
	if type(imageUri) ~= "string" then return false end
	local normalized = string.lower(imageUri)
	return string.find(normalized, "mouselock", 1, true) ~= nil
		or string.find(normalized, "shiftlock", 1, true) ~= nil
end

local function CHCrosshairIsShiftLockNamedObject(object)
	if not object then return false end
	local name = string.lower(object.Name or "")
	return string.find(name, "shiftlock", 1, true) ~= nil
		or string.find(name, "mouselock", 1, true) ~= nil
		or name == "mouse_lock_label"
end

local function CHCrosshairAssignMobileImage(object, imageUri)
	if not object or not object.Parent then return end
	CHCrosshairWritingMobileImage[object] = true
	object.Image = imageUri
	CHCrosshairWritingMobileImage[object] = nil
end

local function CHCrosshairApplyObjectSizeModifier(object)
	if not object or not object.Parent then return end
	local baseSize = CHCrosshairOriginalObjectSizes[object]
	if not baseSize then return end
	local factor = CHCrosshairDesiredUri() and (1 + math.clamp(tonumber(State.CrosshairSizeModifier) or 0, 0, 35) / 100) or 1
	local oldAbs = object.AbsoluteSize
	local oldPosition = object.Position
	local anchor = object.AnchorPoint
	local targetSize = UDim2.new(
		baseSize.X.Scale * factor, math.floor(baseSize.X.Offset * factor + 0.5),
		baseSize.Y.Scale * factor, math.floor(baseSize.Y.Offset * factor + 0.5)
	)
	object.Size = targetSize
	local newAbs = object.AbsoluteSize
	local correctionX = (anchor.X - 0.5) * (newAbs.X - oldAbs.X)
	local correctionY = (anchor.Y - 0.5) * (newAbs.Y - oldAbs.Y)
	object.Position = UDim2.new(
		oldPosition.X.Scale, oldPosition.X.Offset + correctionX,
		oldPosition.Y.Scale, oldPosition.Y.Offset + correctionY
	)
end

local function CHCrosshairApplyAllObjectSizeModifiers()
	for object in pairs(CHCrosshairOriginalMobileImages) do
		if object and object.Parent then CHCrosshairApplyObjectSizeModifier(object) end
	end
end

local function CHCrosshairSetObjectRotationAnimation(object, shouldRun)
	if not object or not object.Parent then return false end
	if not (object:IsA("ImageButton") or object:IsA("ImageLabel")) then return false end
	if CHCrosshairOriginalMobileImages[object] == nil then return false end
	local tween = CHCrosshairRotationTweens[object]
	local newDuration = CHCrosshairGetRotationDuration()
	if shouldRun then
		if tween and tween.PlaybackState == Enum.PlaybackState.Playing
			and CHCrosshairRotationDurations[object] == newDuration then
			return true
		end
		if tween then
			pcall(function() tween:Cancel() end)
			CHCrosshairRotationTweens[object] = nil
		end
		if CHCrosshairOriginalRotations[object] == nil then
			CHCrosshairOriginalRotations[object] = object.Rotation
			local oldAnchor = object.AnchorPoint
			local oldPosition = object.Position
			local absoluteSize = object.AbsoluteSize
			local centerAnchor = Vector2.new(0.5, 0.5)
			CHCrosshairRotationOriginalAnchors[object] = oldAnchor
			CHCrosshairRotationOriginalPositions[object] = oldPosition
			object.AnchorPoint = centerAnchor
			object.Position = UDim2.new(
				oldPosition.X.Scale,
				oldPosition.X.Offset + (centerAnchor.X - oldAnchor.X) * absoluteSize.X,
				oldPosition.Y.Scale,
				oldPosition.Y.Offset + (centerAnchor.Y - oldAnchor.Y) * absoluteSize.Y
			)
		end
		local baseRotation = CHCrosshairOriginalRotations[object]
		object.Rotation = baseRotation
		local newTween = TweenService:Create(
			object,
			TweenInfo.new(newDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false, 0),
			{ Rotation = baseRotation + 360 }
		)
		CHCrosshairRotationTweens[object] = newTween
		CHCrosshairRotationDurations[object] = newDuration
		newTween:Play()
		return true
	end
	if tween then
		pcall(function() tween:Cancel() end)
		CHCrosshairRotationTweens[object] = nil
	end
	CHCrosshairRotationDurations[object] = nil
	if CHCrosshairOriginalRotations[object] ~= nil then
		pcall(function()
			object.Rotation = CHCrosshairOriginalRotations[object]
			if CHCrosshairRotationOriginalAnchors[object] ~= nil then
				object.AnchorPoint = CHCrosshairRotationOriginalAnchors[object]
				object.Position = CHCrosshairRotationOriginalPositions[object]
			end
		end)
		CHCrosshairOriginalRotations[object] = nil
		CHCrosshairRotationOriginalAnchors[object] = nil
		CHCrosshairRotationOriginalPositions[object] = nil
	end
	return false
end

local function CHCrosshairUpdateRotationTargets()
	local shouldRun = CHCrosshairDesiredUri() ~= nil and State.CrosshairRotationEnabled == true
	for object in pairs(CHCrosshairOriginalMobileImages) do
		if object and object.Parent then
			CHCrosshairSetObjectRotationAnimation(object, shouldRun)
		end
	end
end

local function CHCrosshairRegisterShiftLockImage(object)
	if not (object:IsA("ImageButton") or object:IsA("ImageLabel")) then return end
	local imageMatches = CHCrosshairLooksLikeShiftLockImage(object.Image)
	local nameMatches = CHCrosshairIsShiftLockNamedObject(object)
	if not imageMatches and not nameMatches and CHCrosshairOriginalMobileImages[object] == nil then return end
	if CHCrosshairOriginalMobileImages[object] == nil and (imageMatches or nameMatches) then
		CHCrosshairOriginalMobileImages[object] = object.Image
		CHCrosshairOriginalObjectSizes[object] = object.Size
		CHCrosshairOriginalObjectPositions[object] = object.Position
		CHCrosshairOriginalObjectAnchors[object] = object.AnchorPoint
		CHCrosshairOriginalObjectRotations[object] = object.Rotation
	end
	if not CHCrosshairMobileImageConnections[object] then
		CHCrosshairMobileImageConnections[object] = object:GetPropertyChangedSignal("Image"):Connect(function()
			if CHCrosshairIsCleaningUp or CHCrosshairWritingMobileImage[object] then return end
			local currentImage = object.Image
			local replacementUri = CHCrosshairDesiredUri()
			if CHCrosshairLooksLikeShiftLockImage(currentImage) then
				CHCrosshairOriginalMobileImages[object] = currentImage
				if replacementUri then CHCrosshairAssignMobileImage(object, replacementUri) end
			elseif CHCrosshairIsShiftLockNamedObject(object) then
				if currentImage ~= nil and currentImage ~= "" and currentImage ~= replacementUri then
					CHCrosshairOriginalMobileImages[object] = currentImage
				end
				if replacementUri then CHCrosshairAssignMobileImage(object, replacementUri) end
			end
			CHCrosshairApplyObjectSizeModifier(object)
			CHCrosshairSetObjectRotationAnimation(object, replacementUri ~= nil and State.CrosshairRotationEnabled == true)
		end)
	end
	local replacementUri = CHCrosshairDesiredUri()
	if replacementUri then CHCrosshairAssignMobileImage(object, replacementUri) end
	CHCrosshairApplyObjectSizeModifier(object)
	CHCrosshairSetObjectRotationAnimation(object, replacementUri ~= nil and State.CrosshairRotationEnabled == true)
end

local function CHCrosshairScanRoot(root)
	if not root then return 0 end
	local ok, descendants = pcall(function() return root:GetDescendants() end)
	if not ok or not descendants then return 0 end
	local found = 0
	for _, object in ipairs(descendants) do
		CHCrosshairRegisterShiftLockImage(object)
		if CHCrosshairOriginalMobileImages[object] ~= nil then found = found + 1 end
	end
	if not CHCrosshairWatchedRoots[root] then
		CHCrosshairWatchedRoots[root] = true
		local success, connection = pcall(function()
			return root.DescendantAdded:Connect(function(object)
				task.defer(function()
					if not CHCrosshairIsCleaningUp then CHCrosshairRegisterShiftLockImage(object) end
				end)
			end)
		end)
		if success and connection then CHCrosshairKeepConnection(connection) end
	end
	return found
end

local function CHCrosshairApplyExposedShiftLockImages()
	local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local playerGuiCount = CHCrosshairScanRoot(playerGui)
	local coreGuiCount = 0
	local ok, coreGui = pcall(function() return game:GetService("CoreGui") end)
	if ok and coreGui then coreGuiCount = CHCrosshairScanRoot(coreGui) end
	local replacementUri = CHCrosshairDesiredUri()
	for object, originalImage in pairs(CHCrosshairOriginalMobileImages) do
		if object and object.Parent then
			if replacementUri then CHCrosshairAssignMobileImage(object, replacementUri)
			else CHCrosshairAssignMobileImage(object, originalImage) end
		end
	end
	return playerGuiCount + coreGuiCount
end

local function CHCrosshairApplyAll()
	if CHCrosshairIsCleaningUp or game.PlaceId ~= CH_CROSSHAIR_MM2_PLACE_ID then return end
	CHCrosshairSetClassicCursor()
	local exposedCount = CHCrosshairApplyExposedShiftLockImages()
	CHCrosshairUpdateRotationTargets()
	CHCrosshairApplyAllObjectSizeModifiers()
	local refreshUI = _G.Celestial.CrosshairRefreshUI
	if refreshUI then pcall(refreshUI, exposedCount) end
end
CHCrosshair.ApplyAll = CHCrosshairApplyAll

local function CHCrosshairCleanup()
	if CHCrosshairIsCleaningUp then return end
	CHCrosshairIsCleaningUp = true
	State.CrosshairEnabled = false
	State.CrosshairRotationEnabled = false
	State.CrosshairSizeModifier = 0
	State.CrosshairAnimationSpeed = 5
	for object in pairs(CHCrosshairOriginalMobileImages) do
		if object and object.Parent then
			pcall(function() CHCrosshairSetObjectRotationAnimation(object, false) end)
		end
	end
	pcall(CHCrosshairSetClassicCursor)
	for object, originalImage in pairs(CHCrosshairOriginalMobileImages) do
		if object and object.Parent then
			pcall(function()
				CHCrosshairAssignMobileImage(object, originalImage)
				if CHCrosshairOriginalObjectSizes[object] then object.Size = CHCrosshairOriginalObjectSizes[object] end
				if CHCrosshairOriginalObjectAnchors[object] then object.AnchorPoint = CHCrosshairOriginalObjectAnchors[object] end
				if CHCrosshairOriginalObjectPositions[object] then object.Position = CHCrosshairOriginalObjectPositions[object] end
				if CHCrosshairOriginalObjectRotations[object] ~= nil then object.Rotation = CHCrosshairOriginalObjectRotations[object] end
			end)
		end
	end
	for _, connection in ipairs(CHCrosshairConnections) do pcall(function() connection:Disconnect() end) end
	for _, connection in pairs(CHCrosshairMobileImageConnections) do pcall(function() connection:Disconnect() end) end
	_G.Celestial.CrosshairRefreshUI = nil
	if _G.Celestial.CrosshairCleanup == CHCrosshairCleanup then _G.Celestial.CrosshairCleanup = nil end
end

_G.Celestial.CrosshairCleanup = CHCrosshairCleanup
CHCrosshairKeepConnection(UserInputService:GetPropertyChangedSignal("MouseBehavior"):Connect(function()
	if CHCrosshairDesiredUri() then
		task.defer(function()
			if not CHCrosshairIsCleaningUp and CHCrosshairDesiredUri() then CHCrosshairSetClassicCursor() end
		end)
	end
end))
end

local COLOR_MURDERER = Color3.fromRGB(255, 20, 20)
local COLOR_SHERIFF  = Color3.fromRGB(20, 165, 255)
local COLOR_HERO     = Color3.fromRGB(255, 225, 0)
local COLOR_INNOCENT = Color3.fromRGB(0, 255, 105)
local COLOR_GHOST    = Color3.fromRGB(225, 225, 225)
local COLOR_TEAM_SELF = Color3.fromRGB(255, 100, 50)
local COLOR_TEAM_ENEMY = Color3.fromRGB(160, 0, 255)
local COLOR_LOBBY_WHITE = Color3.fromRGB(255, 255, 255)

-- ====================================================================
-- HELPERS
-- ====================================================================

local function GetCharacter(plr)
	plr = plr or LocalPlayer
	return plr.Character
end

local function GetRoot(plr)
	local char = GetCharacter(plr)
	return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid(plr)
	local char = GetCharacter(plr)
	return char and char:FindFirstChildOfClass("Humanoid")
end

local function AbsoluteClearESP()
	if _G.Celestial.Highlights then
		for _, hl in pairs(_G.Celestial.Highlights) do
			if hl then hl.Adornee = nil end
		end
	end
	if _G.Celestial.TrapESPObjects then
		for obj, hl in pairs(_G.Celestial.TrapESPObjects) do
			if hl then pcall(function() hl:Destroy() end) end
			_G.Celestial.TrapESPObjects[obj] = nil
		end
	end
	if _G.Celestial.ESPFolder then
		_G.Celestial.ESPFolder:ClearAllChildren()
	end
end

local function GetPlayerTeam(plr)
	if _G.Celestial.GameMode == "MM2" then
		if plr.Name == State.MurdererName then return "MURDERER" end
		if plr.Name == State.SheriffName then return "SHERIFF" end
		if plr.Name == State.HeroName then return "HERO" end
		return "INNOCENT"
	else
		local team = plr.Team
		if team then
			if team.Name == "Murderer" or team.Name == "Murderers" then return "MURDERER" end
			if team.Name == "Sheriff" or team.Name == "Sheriffs" then return "SHERIFF" end
			return team.Name
		end
		return "UNKNOWN"
	end
end

local function IsSameTeam(plr)
	if not plr or plr == LocalPlayer then return true end
	if _G.Celestial.GameMode == "MM2" then
		local myRole = GetPlayerTeam(LocalPlayer)
		local theirRole = GetPlayerTeam(plr)
		if myRole == "MURDERER" then return theirRole == "MURDERER"
		elseif theirRole == "MURDERER" then return false end
		return true
	else
		return plr.Team == LocalPlayer.Team
	end
end

-- ====================================================================
-- QMA (FIXED: local player hitbox / self-aware fling AI / no jitter)
-- ====================================================================

local AntiFlingQuantum = {
	ProtectedPlayers = {},
	SuspiciousPlayers = {},
	DangerousPlayers = {},
	ThreatStates = {},
	PlayerHistory = {},
	AnimationConnections = {},
	PlayerConnections = {},
	CharacterCache = {},
	RecentlyFlungByMe = {},
	FlungObjectVictims = {},
	LastScan = 0,
	LastHeavyAnalysis = 0,
	BaseScanInterval = 0.08,
	ThreatScanInterval = 0.035,
	HeavyScanInterval = 0.12,
	PerformanceMode = "Normal",
	CriticalMode = false,
	LastLocalPosition = nil,
	LastLocalVelocity = Vector3.zero,
	LastLocalAngularVelocity = Vector3.zero,
	LastDeathState = nil,
	DefenseTriggered = false,
	DefenseCooldown = 0,
	SelfCorrectionWindow = 0,
	SelfCorrectionCount = 0,
	LastHardDefense = 0,
	WorldRelocationUntil = 0,
	PlayerIsolation = {Active = false, Until = 0, Character = nil, Parts = {}, Threats = {}, LastReason = ""},
	CollisionGroupsReady = false,
	PersistentSeparation = {Active = false, OriginalGroups = {}},
	LastPassThroughCheck = 0,
	FlingAttemptEvidence = {},
	SelfActionContext = {
		LastJumpAt = 0,
		LastFlyToggle = 0,
		LastTeleportAt = 0,
		FlyActive = false,
		NoClipActive = false,
		ExpectedMaxVertical = 100,
		ExpectedMaxHorizontal = 50,
		JumpGraceUntil = 0,
	},
}

_G.Celestial.AntiFlingUltra = AntiFlingQuantum
_G.Celestial.AntiFlingQuantumMaster = AntiFlingQuantum

local function GetQuantumThreatDistance() return tonumber(State.AntiFlingThreatDistance) or 12 end
local function GetQuantumThreatLinear() return tonumber(State.AntiFlingThreatLinearVelocity) or 120 end
local function GetQuantumThreatAngular() return tonumber(State.AntiFlingThreatAngularVelocity) or 600 end
local function GetQuantumSelfLinear() return tonumber(State.AntiFlingSelfLinearVelocity) or 160 end
local function GetQuantumSelfAngular() return tonumber(State.AntiFlingSelfAngularVelocity) or 1200 end
local function GetAngularEscalationThreshold() return tonumber(State.AntiFlingAngularEscalationThreshold) or 180 end
local function GetVelocityAccelerationThreshold() return tonumber(State.AntiFlingVelocityAccelerationThreshold) or 70 end
local function GetEscalationWindow() return tonumber(State.AntiFlingEscalationWindow) or 0.45 end
local function GetResidualVerticalVelocity() return tonumber(State.AntiFlingResidualVerticalVelocity) or 80 end
local function GetResidualHorizontalVelocity() return tonumber(State.AntiFlingResidualHorizontalVelocity) or 80 end
local function GetResidualDisplacement() return tonumber(State.AntiFlingResidualDisplacement) or 4 end
local function GetSpinThreshold() return tonumber(State.AntiFlingSpinThreshold) or 450 end
local function GetSustainedSpinTime() return tonumber(State.AntiFlingSustainedSpinTime) or 0.35 end
local function GetOrbitDistance() return tonumber(State.AntiFlingOrbitDistance) or 5.5 end
local function GetOrbitSpeedThreshold() return tonumber(State.AntiFlingOrbitSpeedThreshold) or 35 end
local function GetThreatConfidenceThreshold() return tonumber(State.AntiFlingThreatConfidenceThreshold) or 55 end
local function GetCriticalConfidenceThreshold() return tonumber(State.AntiFlingCriticalConfidenceThreshold) or 82 end
local function GetProtectionHoldTime() return tonumber(State.AntiFlingProtectionHoldTime) or 0.35 end
local function GetProtectionReleaseTime() return tonumber(State.AntiFlingProtectionReleaseTime) or 0.75 end
local function GetCriticalProtectionTime() return tonumber(State.AntiFlingCriticalProtectionTime) or 0.80 end
local function GetMaxSelfCorrectionPerSecond() return tonumber(State.AntiFlingMaxSelfCorrectionPerSecond) or 8 end
function AntiFlingQuantum.GetObservedSpeedSuspicion() return tonumber(State.AntiFlingObservedSpeedSuspicion) or 25 end
function AntiFlingQuantum.GetObservedSpeedCritical() return tonumber(State.AntiFlingObservedSpeedCritical) or 40 end
function AntiFlingQuantum.GetPeerSpeedMultiplier() return tonumber(State.AntiFlingPeerSpeedMultiplier) or 1.50 end
function AntiFlingQuantum.GetSpeedConfirmTime() return tonumber(State.AntiFlingSpeedConfirmTime) or 0.28 end
function AntiFlingQuantum.GetSpeedWindow() return tonumber(State.AntiFlingSpeedWindow) or 0.75 end
function AntiFlingQuantum.GetFlyAirTime() return tonumber(State.AntiFlingFlyAirTime) or 1.35 end
function AntiFlingQuantum.GetFlyHoverTime() return tonumber(State.AntiFlingFlyHoverTime) or 0.65 end
function AntiFlingQuantum.GetFlyHorizontalSpeed() return tonumber(State.AntiFlingFlyHorizontalSpeed) or 10 end
function AntiFlingQuantum.GetTeleportDistance() return tonumber(State.AntiFlingTeleportDistance) or 24 end
function AntiFlingQuantum.GetTeleportSpeed() return tonumber(State.AntiFlingTeleportSpeed) or 75 end
function AntiFlingQuantum.GetFlingerSpeedThreshold() return tonumber(State.AntiFlingFlingerSpeedThreshold) or 27 end
function AntiFlingQuantum.GetFlingerPairDistance() return tonumber(State.AntiFlingFlingerPairDistance) or 8 end
function AntiFlingQuantum.GetRemoteJitterThreshold() return tonumber(State.AntiFlingRemoteJitterThreshold) or 0.055 end
function AntiFlingQuantum.GetLagGraceMax() return tonumber(State.AntiFlingLagGraceMax) or 0.65 end
function AntiFlingQuantum.GetTeleportConfirmScore() return tonumber(State.AntiFlingTeleportConfirmScore) or 72 end
function AntiFlingQuantum.GetExtremeAngularVelocity() return tonumber(State.AntiFlingExtremeAngularVelocity) or 2200 end
function AntiFlingQuantum.GetExtremeAngularHold() return tonumber(State.AntiFlingExtremeAngularHold) or 0.16 end
function AntiFlingQuantum.GetDangerIsolationHold() return tonumber(State.AntiFlingDangerIsolationHold) or 1.25 end

function AntiFlingQuantum.RefreshSelfActionContext(now)
	local ctx = AntiFlingQuantum.SelfActionContext
	ctx.FlyActive = State.FlyActive == true
	ctx.NoClipActive = State.NoClipActive == true
	local jumpPower = tonumber(State.JumpPower) or 50
	local walkSpeed = tonumber(State.WalkSpeed) or 16
	local flySpeed = tonumber(State.FlySpeed) or 50
	ctx.ExpectedMaxVertical = math.max(jumpPower * 1.75, 120)
	ctx.ExpectedMaxHorizontal = math.max(walkSpeed * 2.5, flySpeed * 1.6, 60)
end

local function SafeMagnitude(v)
	if typeof(v) ~= "Vector3" then return 0 end
	if v.X ~= v.X or v.Y ~= v.Y or v.Z ~= v.Z then return math.huge end
	return v.Magnitude
end

local function SafeVector(v)
	if typeof(v) ~= "Vector3" then return Vector3.zero end
	if v.X ~= v.X or v.Y ~= v.Y or v.Z ~= v.Z then return Vector3.zero end
	return v
end

local function SafeDistance(a, b)
	if not a or not b then return math.huge end
	return (a.Position - b.Position).Magnitude
end

local function GetHistory(player)
	local history = AntiFlingQuantum.PlayerHistory[player]
	if history then return history end
	history = {
		Samples = {}, LastSample = nil, LastPosition = nil,
		LastVelocity = Vector3.zero, LastAngularVelocity = Vector3.zero,
		SpinStart = nil, OrbitStart = nil, EscalationStart = nil,
		RelocationUntil = 0, CharacterBornAt = tick(),
		PreviousAngular = 0, PreviousLinear = 0, HighestAngular = 0, HighestLinear = 0,
		ThreatConfidence = 0, LastThreatTime = 0, LastProtectedTime = 0, LastCriticalTime = 0,
		ResidualDetected = false, AnimationSuspicious = false, SustainedSpin = false, Orbiting = false,
		AnimationCount = 0, LastAnimationTime = 0, LastPos = nil,
		LastObservedAt = 0, LastObservedPosition = nil,
		ObservedHorizontalSpeed = 0, ObservedVerticalSpeed = 0, ObservedSpeed = 0,
		PreviousObservedSpeed = 0, ObservedAcceleration = 0,
		PeerSpeedBaseline = 16, SpeedRatio = 1, SpeedScore = 0,
		SpeedAnomalyStart = 0, SpeedAnomalyStreak = 0, SpeedAnomaly = false, SpeedCritical = false,
		AirStart = nil, HoverStart = nil, AirborneTravel = 0, FlyScore = 0, FlyingAnomaly = false,
		TeleportSuspected = false, LastSpeedSignalAt = 0, LastJumpAt = 0, JumpGraceUntil = 0,
		AerialDeviceUntil = 0, LastAerialDeviceScan = 0, WorldRelocationUntil = 0,
		NetworkExpectedDt = 0.08, NetworkJitter = 0, NetworkTolerance = 1, NetworkUnstable = false,
		NetworkLagGraceUntil = 0, NetworkGoodStreak = 0, NetworkBadStreak = 0,
		LastLocalPingMs = 0, LastRemoteSampleGap = 0,
		TeleportEvidence = 0, TeleportCandidateCount = 0, LastTeleportCandidateAt = 0, TeleportConfirmed = false,
		ExtremeSpinStart = nil, ExtremeSpinEvidence = 0, ExtremeSpinConfirmed = false,
		IndependentEvidenceCount = 0, DangerHoldUntil = 0,
		OTI_Score = 0, OTI_SuspicionStart = nil, OTI_ConfirmedSuspicious = false,
		OTI_DangerousFlag = false, OTI_LastScoreUpdate = 0, OTI_Objects = {},
	}
	AntiFlingQuantum.PlayerHistory[player] = history
	return history
end

function AntiFlingQuantum.Median(values)
	if #values == 0 then return nil end
	table.sort(values)
	local middle = (#values + 1) / 2
	if middle % 1 == 0 then return values[middle] end
	return (values[math.floor(middle)] + values[math.ceil(middle)]) / 2
end

function AntiFlingQuantum.IsQMAExcludedByLegitimatePower(player)
	if not player then return true end
	if _G.Celestial.GameMode ~= "MM2" then return false end
	if State.MurdererName == player.Name then return true end
	local role = GetPlayerTeam(player)
	if role == "MURDERER" then return true end
	local detector = _G.Celestial.PowerDetector
	if detector and (detector.CurrentPlayer == player or detector.GhostESPPlayer == player) then
		if detector.GhostESPPlayer == player and detector.GhostActive then return true end
		local power = detector.CurrentPower
		if power == "Haste" or power == "Sprint" or power == "Ghost" then return true end
	end
	return false
end

function AntiFlingQuantum.IsQMAAnalyzableTarget(player)
	if not player or player == LocalPlayer then return false end
	if AntiFlingQuantum.IsQMAExcludedByLegitimatePower(player) then return false end
	if _G.Celestial.GameMode == "MM2" then
		local role = GetPlayerTeam(player)
		return role == "INNOCENT" or role == "SHERIFF" or role == "HERO"
	end
	return true
end

function AntiFlingQuantum.GetMovementState(humanoid)
	if not humanoid then return "Unknown" end
	local ok, state = pcall(function() return humanoid:GetState() end)
	if not ok or not state then return "Unknown" end
	return tostring(state):gsub("Enum.HumanoidStateType.", "")
end

local function RestorePlayerCollision(player)
	local data = AntiFlingQuantum.ProtectedPlayers[player]
	if not data then return end
	if data.Parts then
		for part, originalState in pairs(data.Parts) do
			if part and part.Parent then
				pcall(function() part.CanCollide = originalState end)
			end
		end
	end
	AntiFlingQuantum.ProtectedPlayers[player] = nil
end

local function ClearAllProtection()
	for player in pairs(AntiFlingQuantum.ProtectedPlayers) do
		RestorePlayerCollision(player)
	end
	table.clear(AntiFlingQuantum.ProtectedPlayers)
	if _G.Celestial.ClearQMAPlayerIsolation then pcall(_G.Celestial.ClearQMAPlayerIsolation) end
	if _G.Celestial.ClearQMPlayerPassThrough then pcall(_G.Celestial.ClearQMPlayerPassThrough) end
end

_G.Celestial.AntiFlingClearAllProtection = ClearAllProtection
local AntiFlingClearAllProtection = ClearAllProtection

local function DisconnectAnimationConnection(player)
	local connection = AntiFlingQuantum.AnimationConnections[player]
	if connection then pcall(function() connection:Disconnect() end) end
	AntiFlingQuantum.AnimationConnections[player] = nil
end

local function AttachAnimationMonitor(player, character)
	DisconnectAnimationConnection(player)
	if not character then return end
	local animator = character:FindFirstChildOfClass("Animator")
	if not animator then
		local hum = character:FindFirstChildOfClass("Humanoid")
		animator = hum and hum:FindFirstChildOfClass("Animator")
	end
	if not animator then return end
	local history = GetHistory(player)
	AntiFlingQuantum.AnimationConnections[player] =
		animator.AnimationPlayed:Connect(function(track)
			history.AnimationCount += 1
			history.LastAnimationTime = tick()
		end)
end

local function AttachPlayer(player)
	if not player or player == LocalPlayer then return end
	local existing = AntiFlingQuantum.PlayerConnections[player]
	if existing then pcall(function() existing:Disconnect() end) end
	AntiFlingQuantum.PlayerConnections[player] =
		player.CharacterAdded:Connect(function(character)
			AntiFlingQuantum.CharacterCache[player] = character
			local history = GetHistory(player)
			table.clear(history.Samples)
			history.SpinStart = nil
			history.OrbitStart = nil
			history.EscalationStart = nil
			history.SustainedSpin = false
			history.Orbiting = false
			history.ThreatConfidence = 0
			history.LastPos = nil
			history.PreviousAngular = 0
			history.PreviousLinear = 0
			history.LastObservedAt = 0
			history.LastObservedPosition = nil
			history.ObservedHorizontalSpeed = 0
			history.SpeedScore = 0
			history.SpeedAnomalyStart = 0
			history.SpeedAnomalyStreak = 0
			history.SpeedAnomaly = false
			history.SpeedCritical = false
			history.AirStart = nil
			history.HoverStart = nil
			history.AirborneTravel = 0
			history.FlyingAnomaly = false
			history.TeleportSuspected = false
			history.LastSpeedSignalAt = 0
			history.LastJumpAt = 0
			history.JumpGraceUntil = 0
			history.RelocationUntil = tick() + 1.25
			history.CharacterBornAt = tick()
			history.TeleportEvidence = 0
			history.TeleportCandidateCount = 0
			history.TeleportConfirmed = false
			history.ExtremeSpinStart = nil
			history.ExtremeSpinEvidence = 0
			history.ExtremeSpinConfirmed = false
			history.IndependentEvidenceCount = 0
			history.DangerHoldUntil = 0
			task.defer(function()
				local hum = character:FindFirstChildOfClass("Humanoid")
				local animator = hum and hum:FindFirstChildOfClass("Animator")
				if animator then AttachAnimationMonitor(player, character) end
			end)
		end)
	if player.Character then
		AntiFlingQuantum.CharacterCache[player] = player.Character
		task.defer(function() AttachAnimationMonitor(player, player.Character) end)
	end
end

local function DetachPlayer(player)
	DisconnectAnimationConnection(player)
	local connection = AntiFlingQuantum.PlayerConnections[player]
	if connection then pcall(function() connection:Disconnect() end) end
	AntiFlingQuantum.PlayerConnections[player] = nil
	RestorePlayerCollision(player)
	AntiFlingQuantum.SuspiciousPlayers[player] = nil
	AntiFlingQuantum.DangerousPlayers[player] = nil
	AntiFlingQuantum.ThreatStates[player] = nil
	AntiFlingQuantum.PlayerHistory[player] = nil
	AntiFlingQuantum.CharacterCache[player] = nil
	AntiFlingQuantum.RecentlyFlungByMe[player] = nil
	AntiFlingQuantum.FlungObjectVictims[player] = nil
	AntiFlingQuantum.FlingAttemptEvidence[player] = nil
	if _G.Celestial.OTI and _G.Celestial.OTI.TrackedObjects then
		for obj, data in pairs(_G.Celestial.OTI.TrackedObjects) do
			if data.Owner == player then _G.Celestial.OTI.TrackedObjects[obj] = nil end
		end
	end
	if _G.Celestial.OTI and _G.Celestial.OTI.PlayerOTI then
		_G.Celestial.OTI.PlayerOTI[player] = nil
	end
end

for _, player in ipairs(Players:GetPlayers()) do AttachPlayer(player) end
AntiFlingQuantum.PlayerAddedConnection = Players.PlayerAdded:Connect(function(player) AttachPlayer(player) end)
AntiFlingQuantum.PlayerRemovingConnection = Players.PlayerRemoving:Connect(function(player) DetachPlayer(player) end)

function AntiFlingQuantum.DetectWorldRelocation(allPlayers, now)
	if now < (AntiFlingQuantum.WorldRelocationUntil or 0) then return true end
	local candidates = {}
	local maxPlayers = #allPlayers
	if maxPlayers < 2 then return false end
	for _, player in ipairs(allPlayers) do
		if player ~= LocalPlayer and AntiFlingQuantum.IsQMAAnalyzableTarget(player) then
			local history = AntiFlingQuantum.PlayerHistory[player]
			local character = player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if history and root and history.LastObservedPosition and history.LastObservedAt > 0 then
				local sampleDt = now - history.LastObservedAt
				if sampleDt >= 0.025 and sampleDt <= 0.40
					and (now - (history.CharacterBornAt or now)) > 1.25 then
					local delta = root.Position - history.LastObservedPosition
					local distance = delta.Magnitude
					local velocity = SafeMagnitude(SafeVector(root.AssemblyLinearVelocity))
					local teleportDistance = math.max(AntiFlingQuantum.GetTeleportDistance(), 24)
					local teleportSpeed = math.max(AntiFlingQuantum.GetTeleportSpeed(), 75)
					if distance >= teleportDistance
						and (distance / math.max(sampleDt, 0.025)) >= teleportSpeed
						and velocity < 40 then
						table.insert(candidates, {Player = player, Delta = delta, Distance = distance})
					end
				end
			end
		end
	end
	if #candidates < 2 then return false end
	local coherent = 0
	local reference = candidates[1].Delta
	local referenceUnit = reference.Magnitude > 0 and reference.Unit or Vector3.zero
	for _, candidate in ipairs(candidates) do
		local delta = candidate.Delta
		local deltaUnit = delta.Magnitude > 0 and delta.Unit or Vector3.zero
		local directionMatch = referenceUnit:Dot(deltaUnit) >= 0.72
		local magnitudeRatio = candidate.Distance / math.max(reference.Magnitude, 0.01)
		if directionMatch and magnitudeRatio >= 0.35 and magnitudeRatio <= 2.85 then coherent += 1 end
	end
	local required
	if maxPlayers >= 5 then required = math.max(3, math.ceil(maxPlayers * 0.45))
	else required = 2 end
	if coherent >= required then
		local untilTime = now + 1.35
		AntiFlingQuantum.WorldRelocationUntil = untilTime
		for _, player in ipairs(allPlayers) do
			if player ~= LocalPlayer and AntiFlingQuantum.IsQMAAnalyzableTarget(player) then
				local history = AntiFlingQuantum.PlayerHistory[player]
				if history then
					history.RelocationUntil = math.max(history.RelocationUntil or 0, untilTime)
					history.WorldRelocationUntil = untilTime
					history.TeleportSuspected = false
				end
			end
		end
		return true
	end
	return false
end

function AntiFlingQuantum.IsLegitimateAerialContext(player, character, humanoid, movementState, now, history)
	if not humanoid or not history then return false end
	if movementState == "Jumping" then
		history.LastJumpAt = now
		history.JumpGraceUntil = math.max(history.JumpGraceUntil or 0, now + 1.00)
		return true
	end
	if (history.JumpGraceUntil or 0) > now then return true end
	if character and now - (history.LastAerialDeviceScan or 0) >= 0.50 then
		history.LastAerialDeviceScan = now
		local foundAerialDevice = false
		local containers = {character, player:FindFirstChild("Backpack")}
		for _, container in ipairs(containers) do
			if container then
				for _, obj in ipairs(container:GetDescendants()) do
					local n = string.lower(obj.Name or "")
					if n:find("balloon", 1, true) or n:find("parachute", 1, true)
						or n:find("glider", 1, true) or n:find("hangglider", 1, true)
						or n:find("float", 1, true) or n:find("umbrella", 1, true)
						or n:find("jetpack", 1, true) then
						foundAerialDevice = true; break
					end
				end
			end
			if foundAerialDevice then break end
		end
		if foundAerialDevice then history.AerialDeviceUntil = now + 1.50 end
	end
	if (history.AerialDeviceUntil or 0) > now then return true end
	return movementState == "Freefall" and (now - (history.LastJumpAt or 0)) <= 1.15
end

function AntiFlingQuantum.UpdateNetworkProfile(history, sampleDt, now)
	if not history or sampleDt <= 0 then return 1, true, false, 0 end
	local expected = tonumber(State.AntiFlingScanInterval) or AntiFlingQuantum.BaseScanInterval or 0.08
	expected = math.clamp(expected, 0.045, 0.16)
	history.NetworkExpectedDt = history.NetworkExpectedDt > 0 and history.NetworkExpectedDt or expected
	if sampleDt >= 0.035 and sampleDt <= 0.22 then
		history.NetworkExpectedDt = history.NetworkExpectedDt * 0.90 + sampleDt * 0.10
	end
	local cadenceError = math.abs(sampleDt - history.NetworkExpectedDt)
	history.NetworkJitter = (history.NetworkJitter or 0) * 0.82 + cadenceError * 0.18
	local pingMs = 0
	pcall(function()
		local seconds = LocalPlayer:GetNetworkPing()
		if type(seconds) == "number" and seconds >= 0 then pingMs = seconds * 1000 end
	end)
	pingMs = math.clamp(pingMs, 0, 500)
	history.LastLocalPingMs = pingMs
	history.LastRemoteSampleGap = sampleDt
	local gapBurst = sampleDt >= math.max(0.22, history.NetworkExpectedDt * 2.45)
	local jitterBad = history.NetworkJitter >= AntiFlingQuantum.GetRemoteJitterThreshold()
	local pingStress = pingMs >= 220
	local unstable = gapBurst or jitterBad
	if unstable then
		history.NetworkBadStreak = math.min((history.NetworkBadStreak or 0) + 1, 20)
		history.NetworkGoodStreak = math.max((history.NetworkGoodStreak or 0) - 1, 0)
		local grace = math.clamp((pingMs * 0.0012) + (history.NetworkJitter * 2.4) + (gapBurst and 0.12 or 0), 0, AntiFlingQuantum.GetLagGraceMax())
		history.NetworkLagGraceUntil = math.max(history.NetworkLagGraceUntil or 0, now + grace)
	else
		history.NetworkGoodStreak = math.min((history.NetworkGoodStreak or 0) + 1, 20)
		history.NetworkBadStreak = math.max((history.NetworkBadStreak or 0) - 1, 0)
	end
	local pingScale = math.clamp((math.max(pingMs, 80) - 80) / 260, 0, 1)
	local jitterScale = math.clamp(history.NetworkJitter / 0.085, 0, 1)
	local tolerance = 1 + (pingScale * 0.38) + (jitterScale * 0.34) + (gapBurst and 0.16 or 0)
	history.NetworkTolerance = math.clamp(tolerance, 1, 1.90)
	history.NetworkUnstable = unstable
	return history.NetworkTolerance, not unstable, pingStress, pingMs
end

local function AnalyzePlayer(player, myRoot, now, dt, allPlayers, shared)
	local character = player.Character
	if not character or not character.Parent then return { Valid = false } end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local targetRoot = character:FindFirstChild("HumanoidRootPart")
	if not humanoid or humanoid.Health <= 0 or not targetRoot then return { Valid = false } end

	local history = GetHistory(player)
	local distance = SafeDistance(targetRoot, myRoot)
	local linearVector = SafeVector(targetRoot.AssemblyLinearVelocity)
	local angularVector = SafeVector(targetRoot.AssemblyAngularVelocity)
	local linearSpeed = SafeMagnitude(linearVector)
	local angularSpeed = SafeMagnitude(angularVector)
	local characterAge = now - (history.CharacterBornAt or now)
	local relocationGrace = now < (history.RelocationUntil or 0)
	local movementState = AntiFlingQuantum.GetMovementState(humanoid)
	local specialMovement = movementState == "Seated" or movementState == "Climbing"
		or movementState == "Swimming" or movementState == "GettingUp"
		or movementState == "FallingDown" or movementState == "PlatformStanding"
	local legitimateAerialContext = AntiFlingQuantum.IsLegitimateAerialContext(
		player, character, humanoid, movementState, now, history
	)

	local observedHorizontalSpeed = 0
	local observedVerticalSpeed = 0
	local observedSpeed = 0
	local motionAlignment = 0
	local controlledMotion = false
	local sampleDt = 0
	if history.LastObservedPosition and history.LastObservedAt > 0 then
		sampleDt = now - history.LastObservedAt
		if sampleDt >= 0.025 and sampleDt <= 0.50 then
			local delta = targetRoot.Position - history.LastObservedPosition
			local horizontalDelta = Vector3.new(delta.X, 0, delta.Z)
			observedHorizontalSpeed = horizontalDelta.Magnitude / sampleDt
			observedVerticalSpeed = delta.Y / sampleDt
			observedSpeed = delta.Magnitude / sampleDt
			local moveDirection = humanoid.MoveDirection
			if horizontalDelta.Magnitude > 0.25 and moveDirection.Magnitude >= 0.15 then
				motionAlignment = horizontalDelta.Unit:Dot(moveDirection.Unit)
				controlledMotion = motionAlignment >= 0.35
			end
		end
	end

	local previousObserved = history.ObservedHorizontalSpeed or 0
	local observedAcceleration = 0
	if sampleDt > 0 then
		observedAcceleration = math.abs(observedHorizontalSpeed - previousObserved) / sampleDt
	end

	local networkTolerance, networkStable, pingStress = AntiFlingQuantum.UpdateNetworkProfile(history, sampleDt, now)
	local lagGraceActive = now < (history.NetworkLagGraceUntil or 0)
	local peerBaseline = shared.MedianPeerSpeed
	local speedRatio = observedHorizontalSpeed / math.max(peerBaseline, 10)
	history.PeerSpeedBaseline = peerBaseline
	history.SpeedRatio = speedRatio

	local adaptiveSuspicion = AntiFlingQuantum.GetObservedSpeedSuspicion() * networkTolerance
	local adaptiveCritical = AntiFlingQuantum.GetObservedSpeedCritical() * networkTolerance
	local absoluteSuspicion = observedHorizontalSpeed >= adaptiveSuspicion
	local relativeSuspicion = observedHorizontalSpeed >= peerBaseline * AntiFlingQuantum.GetPeerSpeedMultiplier() * math.max(1, networkTolerance * 0.82)
	local severeSpeed = observedHorizontalSpeed >= adaptiveCritical
	local cleanMotionHistory = (history.NetworkGoodStreak or 0) >= 2
	local speedSignal = AntiFlingQuantum.IsQMAAnalyzableTarget(player)
		and controlledMotion
		and ((absoluteSuspicion and relativeSuspicion) or severeSpeed)
		and (networkStable or cleanMotionHistory)
	local extremeUncontrolled = severeSpeed
		and observedHorizontalSpeed >= (AntiFlingQuantum.GetObservedSpeedCritical() * 1.65)
		and angularSpeed < 900
		and (networkStable or (history.SpeedAnomalyStreak or 0) >= 3)
	if extremeUncontrolled then speedSignal = true end

	if AntiFlingQuantum.IsQMAAnalyzableTarget(player) and not relocationGrace and not specialMovement and sampleDt > 0 then
		if speedSignal then
			history.SpeedAnomalyStart = history.SpeedAnomalyStart > 0 and history.SpeedAnomalyStart or now
			history.SpeedAnomalyStreak = math.min((history.SpeedAnomalyStreak or 0) + 1, 20)
			history.LastSpeedSignalAt = now
		else
			history.SpeedAnomalyStreak = math.max((history.SpeedAnomalyStreak or 0) - 1, 0)
			if history.SpeedAnomalyStart > 0 and now - history.SpeedAnomalyStart > AntiFlingQuantum.GetSpeedWindow() then
				history.SpeedAnomalyStart = 0
			end
		end
	else
		history.SpeedAnomalyStreak = math.max((history.SpeedAnomalyStreak or 0) - 1, 0)
	end

	local sustainedSpeed = history.SpeedAnomalyStart > 0
		and (now - history.SpeedAnomalyStart >= AntiFlingQuantum.GetSpeedConfirmTime())
		and (history.SpeedAnomalyStreak >= 3)
	history.SpeedAnomaly = sustainedSpeed
	history.SpeedCritical = AntiFlingQuantum.IsQMAAnalyzableTarget(player)
		and not relocationGrace and not specialMovement and severeSpeed

	local displacement = 0
	if history.LastPos then displacement = (targetRoot.Position - history.LastPos).Magnitude end
	history.LastPos = targetRoot.Position

	local adaptiveTeleportDistance = math.max(AntiFlingQuantum.GetTeleportDistance(), 24) * math.min(networkTolerance, 1.55)
	local adaptiveTeleportSpeed = math.max(AntiFlingQuantum.GetTeleportSpeed(), 75) * math.min(networkTolerance, 1.45)
	local teleportCandidate = AntiFlingQuantum.IsQMAAnalyzableTarget(player)
		and characterAge > 1.25
		and networkStable
		and sampleDt >= 0.035 and sampleDt <= 0.20
		and displacement >= adaptiveTeleportDistance
		and (displacement / math.max(sampleDt, 0.035)) >= adaptiveTeleportSpeed
		and linearSpeed <= math.max(32, observedHorizontalSpeed * 0.42)

	if teleportCandidate then
		history.TeleportCandidateCount = math.min((history.TeleportCandidateCount or 0) + 1, 6)
		if history.LastTeleportCandidateAt > 0 and now - history.LastTeleportCandidateAt <= 1.10 then
			history.TeleportEvidence = math.min((history.TeleportEvidence or 0) + 38, 100)
		else
			history.TeleportEvidence = math.min((history.TeleportEvidence or 0) + 24, 100)
		end
		history.LastTeleportCandidateAt = now
	else
		history.TeleportEvidence = math.max((history.TeleportEvidence or 0) - (networkStable and 5 or 2), 0)
		history.TeleportCandidateCount = math.max((history.TeleportCandidateCount or 0) - 1, 0)
	end

	local teleportCorroborated = teleportCandidate
		and ((history.TeleportEvidence or 0) >= AntiFlingQuantum.GetTeleportConfirmScore())
		and ((history.TeleportCandidateCount or 0) >= 2 or speedSignal or angularSpeed >= GetQuantumThreatAngular())
	history.TeleportConfirmed = teleportCorroborated
	local teleportDetected = teleportCorroborated
	if teleportDetected then history.LastSpeedSignalAt = now end
	history.TeleportSuspected = teleportDetected

	local grounded = false
	pcall(function() grounded = humanoid.FloorMaterial ~= Enum.Material.Air end)
	if grounded then history.LastGroundedTime = now end

	local flying = false
	local hoverDetected = false
	if not grounded and characterAge > 1.5
		and AntiFlingQuantum.IsQMAAnalyzableTarget(player)
		and not specialMovement and not legitimateAerialContext then
		history.AirStart = history.AirStart or now
		history.AirborneTravel = (history.AirborneTravel or 0) + math.max(observedHorizontalSpeed * math.max(sampleDt, 0), 0)
		local nearVerticalRest = math.abs(observedVerticalSpeed) <= 4
		if nearVerticalRest and observedHorizontalSpeed >= AntiFlingQuantum.GetFlyHorizontalSpeed() then
			history.HoverStart = history.HoverStart or now
		else
			history.HoverStart = nil
		end
		local airTime = now - (history.AirStart or now)
		local hoverTime = history.HoverStart and (now - history.HoverStart) or 0
		local minimumAirTime = AntiFlingQuantum.GetFlyAirTime()
		local minimumAirborneTravel = 14
		if _G.Celestial.GameMode ~= "MM2" then
			minimumAirTime = math.max(minimumAirTime, 2.25)
			minimumAirborneTravel = 20
		end
		if airTime >= minimumAirTime and (history.AirborneTravel or 0) >= minimumAirborneTravel then
			history.FlyingAnomaly = true
		end
		if hoverTime >= AntiFlingQuantum.GetFlyHoverTime() then hoverDetected = true end
		local physicsThrown = linearSpeed >= 85 or angularSpeed >= 450
		if physicsThrown then
			history.FlyingAnomaly = false
			if history.FlyScore then history.FlyScore = math.max(history.FlyScore - 10, 0) end
			hoverDetected = false
		end
		if history.FlyingAnomaly then history.FlyScore = math.max(history.FlyScore or 0, 60) end
		if hoverDetected then history.FlyScore = math.max(history.FlyScore or 0, 78) end
	else
		history.AirStart = nil
		history.HoverStart = nil
		history.AirborneTravel = 0
		history.FlyScore = math.max((history.FlyScore or 0) - 8, 0)
		history.FlyingAnomaly = false
	end

	local previousAngular = history.PreviousAngular
	local previousLinear = history.PreviousLinear
	local angularDelta = math.abs(angularSpeed - previousAngular)
	local linearDelta = math.abs(linearSpeed - previousLinear)
	local highAngular = angularSpeed >= math.max(GetSpinThreshold(), GetQuantumThreatAngular() * 0.65)
	local highLinear = linearSpeed >= GetQuantumThreatLinear()
	local severeLinear = linearSpeed >= math.max(180, GetQuantumThreatLinear() * 1.35)

	local escalating = false
	if not relocationGrace then
		escalating = (angularDelta >= GetAngularEscalationThreshold() and angularSpeed > 240)
			or (linearDelta >= GetVelocityAccelerationThreshold() and linearSpeed > 85)
			or (observedAcceleration >= 110 and observedHorizontalSpeed >= 24)
	end
	if escalating then
		history.EscalationStart = history.EscalationStart or now
	elseif history.EscalationStart and now - history.EscalationStart > GetEscalationWindow() then
		history.EscalationStart = nil
	end
	local sustainedEscalation = history.EscalationStart ~= nil
		and (now - history.EscalationStart) >= 0.20

	if highAngular and not relocationGrace then
		history.SpinStart = history.SpinStart or now
	else
		history.SpinStart = nil
		history.SustainedSpin = false
	end
	if history.SpinStart and now - history.SpinStart >= GetSustainedSpinTime() then history.SustainedSpin = true end

	local extremeAngularThreshold = math.max(AntiFlingQuantum.GetExtremeAngularVelocity(), GetQuantumThreatAngular() * 2.25)
	local absurdSpin = angularSpeed >= extremeAngularThreshold * 2.40
	local extremeSpinSample = (networkStable and angularSpeed >= extremeAngularThreshold)
		or (absurdSpin and previousAngular >= extremeAngularThreshold)
	if not relocationGrace and AntiFlingQuantum.IsQMAAnalyzableTarget(player) and extremeSpinSample then
		history.ExtremeSpinStart = history.ExtremeSpinStart or now
		history.ExtremeSpinEvidence = math.min((history.ExtremeSpinEvidence or 0) + (absurdSpin and 32 or 24), 100)
	else
		history.ExtremeSpinEvidence = math.max((history.ExtremeSpinEvidence or 0) - (networkStable and 6 or 2), 0)
		if not history.ExtremeSpinStart or (now - history.ExtremeSpinStart) > 0.80 then history.ExtremeSpinStart = nil end
	end
	history.ExtremeSpinConfirmed = (history.ExtremeSpinStart ~= nil)
		and (now - history.ExtremeSpinStart >= AntiFlingQuantum.GetExtremeAngularHold())
		and (history.ExtremeSpinEvidence >= 48)

	if not relocationGrace and distance <= GetOrbitDistance() * 1.35
		and linearSpeed >= math.max(GetOrbitSpeedThreshold(), 42)
		and angularSpeed >= GetSpinThreshold() * 0.55 then
		history.OrbitStart = history.OrbitStart or now
	else
		history.OrbitStart = nil
		history.Orbiting = false
	end
	if history.OrbitStart and now - history.OrbitStart >= 0.20 then history.Orbiting = true end

	flying = history.FlyingAnomaly or hoverDetected

	local globalPhysicsNoise = shared.GlobalPhysicsNoise

	local confidence = 0
	if not relocationGrace then
		if distance <= GetQuantumThreatDistance() then confidence += 18
		elseif distance <= GetQuantumThreatDistance() * 1.5 then confidence += 6 end
		if highLinear then
			confidence += 22
			if highAngular or sustainedEscalation then confidence += 18 end
		elseif linearSpeed >= GetQuantumThreatLinear() * 0.75 and (highAngular or sustainedEscalation) then
			confidence += 12
		end
		if angularSpeed >= GetQuantumThreatAngular() then confidence += 24
		elseif angularSpeed >= GetQuantumThreatAngular() * 0.72 then confidence += 8 end
		if history.SustainedSpin then confidence += 18 end
		if history.Orbiting then confidence += 22 end
		if sustainedEscalation then confidence += 14 end
		if flying then confidence += 28 end
		if hoverDetected then confidence += 18 end
		if history.TeleportSuspected then confidence += 30 end
		if sustainedSpeed then confidence += 28 end
		if history.SpeedCritical then confidence += 22 end
		if history.ExtremeSpinConfirmed then confidence += 34 end
		if globalPhysicsNoise then confidence = math.max(confidence - 24, 0) end
		if lagGraceActive then confidence = math.max(confidence - 12, 0) end
		if severeLinear and (highAngular or history.Orbiting or sustainedEscalation) then confidence += 12 end
	end

	if not AntiFlingQuantum.IsQMAAnalyzableTarget(player) then
		confidence = math.min(confidence, 18)
		history.SpeedAnomaly = false
		history.SpeedCritical = false
		history.FlyingAnomaly = false
		history.TeleportSuspected = false
	end

	confidence = math.clamp(confidence, 0, 100)
	local state = "Normal"
	if confidence >= GetCriticalConfidenceThreshold() and not relocationGrace
		and (history.SustainedSpin or history.Orbiting or severeLinear or sustainedEscalation
			or sustainedSpeed or history.SpeedCritical or history.ExtremeSpinConfirmed
			or flying or history.TeleportConfirmed) then
		state = "Critical"
	elseif confidence >= GetThreatConfidenceThreshold() and not relocationGrace then
		state = "Threat"
	elseif confidence >= 35 and not relocationGrace then
		state = "Suspicious"
	end

	local speedScore = 0
	if speedSignal then speedScore += 32 end
	if sustainedSpeed then speedScore += 28 end
	if severeSpeed and controlledMotion then speedScore += 24 end
	if history.TeleportConfirmed then speedScore += 30 end
	if history.ExtremeSpinConfirmed then speedScore += 30 end
	if flying then speedScore += 22 end
	if lagGraceActive then speedScore = math.max(speedScore - 18, 0) end
	history.SpeedScore = math.clamp(speedScore, 0, 100)
	history.IndependentEvidenceCount = 0
	if sustainedSpeed then history.IndependentEvidenceCount += 1 end
	if history.SpeedCritical then history.IndependentEvidenceCount += 1 end
	if history.ExtremeSpinConfirmed then history.IndependentEvidenceCount += 1 end
	if history.TeleportConfirmed then history.IndependentEvidenceCount += 1 end
	if flying then history.IndependentEvidenceCount += 1 end

	history.LastObservedAt = now
	history.LastObservedPosition = targetRoot.Position
	history.PreviousObservedSpeed = history.ObservedHorizontalSpeed or 0
	history.ObservedHorizontalSpeed = observedHorizontalSpeed
	history.ObservedVerticalSpeed = observedVerticalSpeed
	history.ObservedSpeed = observedSpeed
	history.ObservedAcceleration = observedAcceleration
	history.PreviousAngular = angularSpeed
	history.PreviousLinear = linearSpeed
	history.HighestAngular = math.max(history.HighestAngular, angularSpeed)
	history.HighestLinear = math.max(history.HighestLinear, linearSpeed)
	history.ThreatConfidence = confidence
	if state ~= "Normal" then history.LastThreatTime = now end

	return {
		Valid = true, Distance = distance, LinearSpeed = linearSpeed, AngularSpeed = angularSpeed,
		AngularDelta = angularDelta, LinearDelta = linearDelta, Escalating = sustainedEscalation,
		ObservedHorizontalSpeed = observedHorizontalSpeed, ObservedVerticalSpeed = observedVerticalSpeed,
		ObservedSpeed = observedSpeed, ObservedAcceleration = observedAcceleration,
		MotionAlignment = motionAlignment, ControlledMotion = controlledMotion,
		PeerSpeedBaseline = peerBaseline, SpeedRatio = speedRatio, SpeedAnomaly = sustainedSpeed,
		SpeedCritical = history.SpeedCritical, SpeedScore = history.SpeedScore,
		SustainedSpin = history.SustainedSpin, Orbiting = history.Orbiting,
		ExtremeSpinConfirmed = history.ExtremeSpinConfirmed,
		IndependentEvidenceCount = history.IndependentEvidenceCount,
		NetworkStable = networkStable, NetworkUnstable = history.NetworkUnstable,
		NetworkTolerance = networkTolerance, LocalPingMs = history.LastLocalPingMs,
		NetworkJitter = history.NetworkJitter, LagGrace = lagGraceActive,
		GlobalPhysicsNoise = globalPhysicsNoise,
		AnimationSuspicious = false, Confidence = confidence, State = state,
		TeleportDetected = teleportDetected, TeleportCandidate = teleportCandidate, RelocationGrace = relocationGrace, Flying = flying,
		Hovering = hoverDetected, MovementState = movementState,
	}
end

local function DetectResidualMotion(root, now)
	if not root or not root.Parent then return false, 0 end
	local ctx = AntiFlingQuantum.SelfActionContext
	AntiFlingQuantum.RefreshSelfActionContext(now)
	if ctx.FlyActive or ctx.NoClipActive then
		AntiFlingQuantum.LastLocalPosition = root.Position
		AntiFlingQuantum.LastLocalVelocity = SafeVector(root.AssemblyLinearVelocity)
		return false, 0
	end
	local hum = GetHumanoid()
	if hum then
		local state = AntiFlingQuantum.GetMovementState(hum)
		if state == "Jumping" then
			AntiFlingQuantum.LastLocalPosition = root.Position
			AntiFlingQuantum.LastLocalVelocity = SafeVector(root.AssemblyLinearVelocity)
			return false, 0
		end
		if state == "Freefall" and (now - (ctx.LastJumpAt or 0)) < 1.5 then
			AntiFlingQuantum.LastLocalPosition = root.Position
			AntiFlingQuantum.LastLocalVelocity = SafeVector(root.AssemblyLinearVelocity)
			return false, 0
		end
	end
	local currentPosition = root.Position
	local currentVelocity = SafeVector(root.AssemblyLinearVelocity)
	local previousPosition = AntiFlingQuantum.LastLocalPosition
	local previousVelocity = AntiFlingQuantum.LastLocalVelocity
	local displacement = 0
	if previousPosition then displacement = (currentPosition - previousPosition).Magnitude end
	local verticalSpeed = math.abs(currentVelocity.Y)
	local horizontalSpeed = Vector3.new(currentVelocity.X, 0, currentVelocity.Z).Magnitude
	local velocityDelta = (currentVelocity - previousVelocity).Magnitude
	local verticalThreshold = math.max(GetResidualVerticalVelocity(), ctx.ExpectedMaxVertical * 1.15)
	local horizontalThreshold = math.max(GetResidualHorizontalVelocity(), ctx.ExpectedMaxHorizontal * 1.15)
	local residual = false
	local score = 0
	if verticalSpeed >= verticalThreshold then score += 30 end
	if horizontalSpeed >= horizontalThreshold then score += 25 end
	if displacement >= GetResidualDisplacement() then score += 20 end
	if velocityDelta >= 45 then score += 20 end
	if score >= 55 then residual = true end
	AntiFlingQuantum.LastLocalPosition = currentPosition
	AntiFlingQuantum.LastLocalVelocity = currentVelocity
	return residual, score
end

local function CanApplySelfCorrection(now)
	if now - AntiFlingQuantum.SelfCorrectionWindow >= 1 then
		AntiFlingQuantum.SelfCorrectionWindow = now
		AntiFlingQuantum.SelfCorrectionCount = 0
	end
	if AntiFlingQuantum.SelfCorrectionCount >= GetMaxSelfCorrectionPerSecond() then return false end
	AntiFlingQuantum.SelfCorrectionCount += 1
	return true
end

local function StabilizeLocalCharacter(root, criticalThreat, force)
	if not root or not root.Parent then return end
	local ctx = AntiFlingQuantum.SelfActionContext
	local now = tick()
	AntiFlingQuantum.RefreshSelfActionContext(now)
	local linear = SafeVector(root.AssemblyLinearVelocity)
	local angular = SafeVector(root.AssemblyAngularVelocity)
	if ctx.FlyActive or ctx.NoClipActive then
		if angular.Magnitude > 500 then
			pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
		end
		return
	end
	local hum = GetHumanoid()
	local movementState = hum and AntiFlingQuantum.GetMovementState(hum) or "Unknown"
	if movementState == "Jumping" then
		if angular.Magnitude > math.max(800, GetQuantumSelfAngular()) then
			pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
		end
		return
	end
	if movementState == "Freefall" and (now - (ctx.LastJumpAt or 0)) < 1.5 then
		if math.abs(linear.Y) > ctx.ExpectedMaxVertical * 2.5 then
			pcall(function() root.AssemblyLinearVelocity = Vector3.new(linear.X, math.sign(linear.Y) * ctx.ExpectedMaxVertical * 2.5, linear.Z) end)
		end
		if angular.Magnitude > math.max(800, GetQuantumSelfAngular()) then
			pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
		end
		return
	end
	if not force and not CanApplySelfCorrection(now) then return end
	if force then
		if now - (AntiFlingQuantum.LastHardDefense or 0) < 0.025 then return end
		AntiFlingQuantum.LastHardDefense = now
	end
	local linearSpeed = linear.Magnitude
	local angularSpeed = angular.Magnitude
	local hardAngular = criticalThreat and 700 or 900
	local hardLinear = criticalThreat and 130 or 160
	hardLinear = math.max(hardLinear, ctx.ExpectedMaxHorizontal * 1.35)
	if angularSpeed >= math.max(GetQuantumSelfAngular() * 0.75, hardAngular) or (force and angularSpeed >= 800) then
		pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
	end
	if linearSpeed >= hardLinear or (force and linearSpeed >= 160) then
		local horizontal = Vector3.new(linear.X, 0, linear.Z)
		local horizontalMagnitude = horizontal.Magnitude
		local horizontalLimit = criticalThreat and 30 or 40
		if force then horizontalLimit = math.min(horizontalLimit, 34) end
		horizontalLimit = math.max(horizontalLimit, ctx.ExpectedMaxHorizontal * 1.05)
		local safeHorizontal = horizontal
		if horizontalMagnitude > horizontalLimit and horizontalMagnitude > 0 then safeHorizontal = horizontal.Unit * horizontalLimit end
		local yLimit = math.max(criticalThreat and 22 or 30, ctx.ExpectedMaxVertical * 1.1)
		local safeY = math.clamp(linear.Y, -yLimit, yLimit)
		pcall(function() root.AssemblyLinearVelocity = Vector3.new(safeHorizontal.X, safeY, safeHorizontal.Z) end)
	end
end

function AntiFlingQuantum.SetupQMAIsolationGroups()
	if AntiFlingQuantum.CollisionGroupsReady then return true end
	local physicsService = game:GetService("PhysicsService")
	local otherGroup = "QMA_PlayerOther"
	pcall(function() physicsService:RegisterCollisionGroup(otherGroup) end)
	pcall(function()
		local ok, groups = pcall(function() return physicsService:GetRegisteredCollisionGroups() end)
		if ok and type(groups) == "table" then
			for _, group in ipairs(groups) do
				if group.name ~= otherGroup then
					pcall(function() physicsService:CollisionGroupSetCollidable(group.name, otherGroup, false) end)
				end
			end
		end
	end)
	pcall(function() physicsService:CollisionGroupSetCollidable("Default", otherGroup, false) end)
	AntiFlingQuantum.CollisionGroupsReady = true
	return true
end

function AntiFlingQuantum.ApplyLocalPlayerIsolation(allPlayers, untilTime, reason)
	local data = AntiFlingQuantum.PlayerIsolation
	data.Active = true
	data.Until = math.max(data.Until or 0, untilTime or (tick() + AntiFlingQuantum.GetDangerIsolationHold()))
	data.Character = LocalPlayer.Character
	data.LastReason = reason or data.LastReason or "QMA Threat"
end

function AntiFlingQuantum.ClearLocalPlayerIsolation()
	local data = AntiFlingQuantum.PlayerIsolation
	if not data then return end
	for part, original in pairs(data.Parts or {}) do
		if part and part.Parent then
			pcall(function()
				if original.CanTouch ~= nil then part.CanTouch = original.CanTouch end
			end)
		end
	end
	table.clear(data.Parts or {})
	table.clear(data.Threats or {})
	data.Active = false
	data.Until = 0
	data.Character = nil
	data.LastReason = ""
end

function AntiFlingQuantum.UpdateLocalPlayerIsolation(allPlayers, shouldIsolate, now, reason)
	local data = AntiFlingQuantum.PlayerIsolation
	if not shouldIsolate and data and data.Active and now < (data.Until or 0) then
		shouldIsolate = true
	end
	if shouldIsolate then
		AntiFlingQuantum.ApplyLocalPlayerIsolation(allPlayers, math.max(data.Until or 0, now + AntiFlingQuantum.GetDangerIsolationHold()), reason)
	elseif data and data.Active then
		AntiFlingQuantum.ClearLocalPlayerIsolation()
	end
end

_G.Celestial.ClearQMAPlayerIsolation = AntiFlingQuantum.ClearLocalPlayerIsolation

function AntiFlingQuantum.EnsurePlayerPassThrough(allPlayers, now)
	if not AntiFlingQuantum.SetupQMAIsolationGroups() then return end
	local psep = AntiFlingQuantum.PersistentSeparation
	if not psep.OriginalGroups then psep.OriginalGroups = {} end
	psep.Active = true

	local localChar = LocalPlayer.Character
	if localChar then
		for _, obj in ipairs(localChar:GetDescendants()) do
			if obj:IsA("BasePart") and obj.CollisionGroup == "QMA_SelfSafe" then
				pcall(function() obj.CollisionGroup = "Default" end)
			end
		end
	end

	for _, plr in ipairs(allPlayers or Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			for _, obj in ipairs(plr.Character:GetDescendants()) do
				if obj:IsA("BasePart") and obj.CollisionGroup ~= "QMA_PlayerOther" then
					if psep.OriginalGroups[obj] == nil then
						psep.OriginalGroups[obj] = obj.CollisionGroup
					end
					pcall(function() obj.CollisionGroup = "QMA_PlayerOther" end)
				end
			end
		end
	end
end

function AntiFlingQuantum.ClearPlayerPassThrough()
	local psep = AntiFlingQuantum.PersistentSeparation
	if not psep or not psep.Active then return end
	for part, original in pairs(psep.OriginalGroups or {}) do
		if part and part.Parent then
			pcall(function() part.CollisionGroup = original end)
		end
	end
	psep.OriginalGroups = {}
	psep.Active = false
end

_G.Celestial.ClearQMPlayerPassThrough = AntiFlingQuantum.ClearPlayerPassThrough

local function CleanupInvalidPlayers()
	for player, data in pairs(AntiFlingQuantum.ProtectedPlayers) do
		if not player or not player.Parent or not data or not data.Character or not data.Character.Parent
			or player.Character ~= data.Character then
			RestorePlayerCollision(player)
		end
	end
	for player in pairs(AntiFlingQuantum.SuspiciousPlayers) do
		if not player or not player.Parent then AntiFlingQuantum.SuspiciousPlayers[player] = nil end
	end
	for player in pairs(AntiFlingQuantum.DangerousPlayers) do
		if not player or not player.Parent then
			AntiFlingQuantum.DangerousPlayers[player] = nil
			AntiFlingQuantum.ThreatStates[player] = nil
			AntiFlingQuantum.PlayerHistory[player] = nil
		end
	end
	for player in pairs(AntiFlingQuantum.ThreatStates) do
		if not player or not player.Parent then AntiFlingQuantum.ThreatStates[player] = nil end
	end
end

local function MarkAsFlungByMe(targetPlayer, duration)
	if not targetPlayer then return end
	duration = duration or 6.0
	AntiFlingQuantum.RecentlyFlungByMe[targetPlayer] = tick() + duration
end

local function DetectFlingerVictimPair(spinningPlayer, allPlayers, now)
	local spinningRoot = GetRoot(spinningPlayer)
	if not spinningRoot then return nil end
	local spinningPos = spinningRoot.Position
	local spinningHistory = GetHistory(spinningPlayer)
	if not spinningHistory then return nil end
	local bestCulprit = nil
	local bestDist = math.min(AntiFlingQuantum.GetFlingerPairDistance(), 6)
	for _, other in ipairs(allPlayers) do
		if other ~= spinningPlayer and other ~= LocalPlayer and AntiFlingQuantum.IsQMAAnalyzableTarget(other) then
			local otherRoot = GetRoot(other)
			local otherHum = GetHumanoid(other)
			if otherRoot and otherHum and otherHum.Health > 0 then
				local d = (otherRoot.Position - spinningPos).Magnitude
				if d < bestDist then
					local otherAngular = SafeMagnitude(otherRoot.AssemblyAngularVelocity)
					local otherHistory = GetHistory(other)
					local otherScore = otherHistory.SpeedScore or 0
					local severeAngular = otherAngular >= 500
					local severeMovement = otherHistory.SpeedAnomaly or otherHistory.SpeedCritical or otherHistory.TeleportSuspected
					local veryHighScore = otherScore >= 75
					local signalCount = 0
					if severeAngular then signalCount += 1 end
					if severeMovement then signalCount += 1 end
					if veryHighScore then signalCount += 1 end
					if otherAngular < 5000 and signalCount >= 2 then
						bestDist = d
						bestCulprit = other
					end
				end
			end
		end
	end
	return bestCulprit, bestDist
end

local function ShowDefenseNotification()
	local notifGui = Instance.new("ScreenGui")
	notifGui.Name = "QuantumDefenseNotification"
	notifGui.ResetOnSpawn = false
	notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function()
		if gethui then notifGui.Parent = gethui()
		else notifGui.Parent = CoreGui end
	end)
	if not notifGui.Parent then notifGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0, 540, 0, 270)
	container.Position = UDim2.new(0.5, -270, 0.5, -135)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	container.Parent = notifGui
	local block1 = Instance.new("Frame")
	block1.Size = UDim2.new(1, 0, 1, 0)
	block1.BackgroundTransparency = 1
	block1.Parent = container
	local image1 = Instance.new("ImageLabel")
	image1.Size = UDim2.new(1, 0, 1, 0)
	image1.BackgroundTransparency = 1
	image1.Image = "rbxassetid://95284808234739"
	image1.ImageTransparency = 0.2
	image1.ScaleType = Enum.ScaleType.Fit
	image1.Parent = block1
	local block2 = Instance.new("Frame")
	block2.Size = UDim2.new(1, 0, 1, 0)
	block2.Position = UDim2.new(0, 0, 1, 0)
	block2.BackgroundTransparency = 1
	block2.Visible = false
	block2.Parent = container
	local image2 = Instance.new("ImageLabel")
	image2.Size = UDim2.new(1, 0, 1, 0)
	image2.BackgroundTransparency = 1
	image2.Image = "rbxassetid://113725479079832"
	image2.ImageTransparency = 0.2
	image2.ScaleType = Enum.ScaleType.Fit
	image2.Parent = block2
	local function startBlinking()
		local blinkState = false
		local blinkTimer = task.spawn(function()
			while container.Parent do
				task.wait(0.5)
				blinkState = not blinkState
				local newTrans = blinkState and 0.2 or 0.8
				if block1.Visible then image1.ImageTransparency = newTrans
				elseif block2.Visible then image2.ImageTransparency = newTrans end
			end
		end)
		return blinkTimer
	end
	local tweenInfo1 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweenInfoFade = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	block1.Visible = true
	block2.Visible = false
	local blinkTimer = startBlinking()
	task.delay(2, function()
		local tween1 = TweenService:Create(block1, tweenInfo1, { Position = UDim2.new(0, 0, 1, 0) })
		tween1:Play()
		block2.Visible = true
		block2.Position = UDim2.new(0, 0, 1, 0)
		local tween2 = TweenService:Create(block2, tweenInfo1, { Position = UDim2.new(0, 0, 0, 0) })
		tween2:Play()
		task.delay(2, function()
			task.cancel(blinkTimer)
			local fadeTween1 = TweenService:Create(block2, tweenInfoFade, { BackgroundTransparency = 1 })
			local fadeTween2 = TweenService:Create(block2, tweenInfoFade, { BackgroundTransparency = 1 })
			fadeTween1:Play()
			fadeTween2:Play()
			local fadeContainer = TweenService:Create(container, tweenInfoFade, { BackgroundTransparency = 1 })
			fadeContainer:Play()
			task.delay(0.8, function() notifGui:Destroy() end)
		end)
	end)
end

local function UpdateAntiFlingToggle()
	local btn = _G.Celestial.ToggleButtons and _G.Celestial.ToggleButtons["QM Anti-Fling"]
	if btn then
		local active = State.AntiFlingActive
		btn.Text = ""
		btn.BackgroundColor3 = active and Color3.fromRGB(75, 210, 115) or Color3.fromRGB(145, 145, 145)
		local knob = btn:FindFirstChild("ToggleKnob")
		if knob then
			knob.Position = active and UDim2.new(1, -24, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
		end
	end
end

-- ====================================================================
-- QMA ADAPTIVE BATCH SCHEDULER
-- ====================================================================

local QMAScheduler = {
	Queue = {},
	Index = 1,
	BatchSize = 2,
	NextBatchTime = 0,
	TimePerBatch = 1.0,
	LastPlayerCount = 0,
}

function QMAScheduler.RebuildQueue(allPlayers)
	table.clear(QMAScheduler.Queue)
	for _, plr in ipairs(allPlayers) do
		if plr ~= LocalPlayer then
			table.insert(QMAScheduler.Queue, plr)
		end
	end
	local N = #QMAScheduler.Queue
	if N > 0 then
		QMAScheduler.BatchSize = math.max(2, math.ceil(N / 6))
		local cycleTime = math.max(0.55 * N, 1.0)
		local numBatches = math.ceil(N / QMAScheduler.BatchSize)
		QMAScheduler.TimePerBatch = cycleTime / numBatches
	else
		QMAScheduler.BatchSize = 2
		QMAScheduler.TimePerBatch = 1.0
	end
	QMAScheduler.Index = 1
	QMAScheduler.NextBatchTime = tick()
	QMAScheduler.LastPlayerCount = N
end

function QMAScheduler.GetSharedData(allPlayers, now)
	local shared = {
		Now = now,
		GlobalPhysicsNoise = false,
		PeerSpeeds = {},
		MedianPeerSpeed = 16
	}
	
	local movingPeers, peerCount = 0, 0
	local speeds = {}
	for _, other in ipairs(allPlayers) do
		if other ~= LocalPlayer and AntiFlingQuantum.IsQMAAnalyzableTarget(other) then
			local history = AntiFlingQuantum.PlayerHistory[other]
			if history and history.LastObservedAt > 0 and now - history.LastObservedAt <= AntiFlingQuantum.GetSpeedWindow() then
				peerCount += 1
				local speed = tonumber(history.ObservedHorizontalSpeed) or 0
				local score = tonumber(history.SpeedScore) or 0
				if speed > 0 and speed <= AntiFlingQuantum.GetObservedSpeedCritical() and score < 55 then
					table.insert(speeds, speed)
				end
				
				local ohv = tonumber(history.PreviousAngular) or 0
				if speed >= 45 or ohv >= 350 then
					movingPeers += 1
				end
			end
		end
	end
	
	if peerCount >= 3 and movingPeers / peerCount >= 0.50 then
		shared.GlobalPhysicsNoise = true
	end
	
	local median = AntiFlingQuantum.Median(speeds)
	if median and median >= 4 then
		shared.MedianPeerSpeed = math.clamp(median, 10, 24)
	else
		shared.MedianPeerSpeed = 16
	end
	
	return shared
end

local function AntiFlingQuantumFastTick(now)
	local myRoot = GetRoot()
	local myHumanoid = GetHumanoid()
	if not myRoot or not myHumanoid or myHumanoid.Health <= 0 then
		ClearAllProtection()
		AntiFlingQuantum.CriticalMode = false
		return
	end

	AntiFlingQuantum.RefreshSelfActionContext(now)
	local residualDetected, residualScore = DetectResidualMotion(myRoot, now)
	
	local emergencyIsolation = false
	local isolationReason = ""
	local criticalDetected = false
	
	for player, analysis in pairs(AntiFlingQuantum.ThreatStates) do
		if player and player.Parent and analysis.Valid then
			local distance = SafeDistance(GetRoot(player), myRoot)
			if analysis.State == "Critical" and distance <= 15 then
				emergencyIsolation = true
				isolationReason = "Critical Proximity Threat"
			end
			if analysis.State == "Critical" then
				criticalDetected = true
			end
		end
	end
	
	AntiFlingQuantum.CriticalMode = criticalDetected

	if State.AntiFlingActive then
		if now - (AntiFlingQuantum.LastPassThroughCheck or 0) >= 0.25 then
			AntiFlingQuantum.LastPassThroughCheck = now
			AntiFlingQuantum.EnsurePlayerPassThrough(Players:GetPlayers(), now)
		end
		
		local existingDanger = next(AntiFlingQuantum.DangerousPlayers) ~= nil
		local isolateNow = emergencyIsolation or existingDanger
		AntiFlingQuantum.UpdateLocalPlayerIsolation(Players:GetPlayers(), isolateNow, now, isolationReason)
		
		if residualDetected or isolateNow or AntiFlingQuantum.CriticalMode then
			StabilizeLocalCharacter(myRoot, AntiFlingQuantum.CriticalMode or isolateNow, true)
		end
	else
		AntiFlingQuantum.ClearPlayerPassThrough()
		AntiFlingQuantum.UpdateLocalPlayerIsolation(Players:GetPlayers(), false, now)
	end
	CleanupInvalidPlayers()
end

-- ====================================================================
-- OTI
-- ====================================================================

local OTI = {
	TrackedObjects = {}, ObjectPool = {}, PoolList = {},
	SuspiciousPlayers = {}, DangerousPlayers = {}, PlayerOTI = {},
	LastScan = 0, ScanInterval = 0.15, LastPoolRefresh = 0,
	ScanQueueIndex = 1, LastAnalyzedCount = 0, ActiveCount = 0, ThreatCount = 0,
}
_G.Celestial.OTI = OTI

local RealPlayerScan = {Count = 0, CycleLimit = 0, LastPlayerCount = 0, PauseUntil = 0}
_G.Celestial.RealPlayerScan = RealPlayerScan

local function RecordRealPlayerScanPlayer(playerCount)
	playerCount = tonumber(playerCount) or 0
	if playerCount <= 0 then return end
	local now = tick()
	if now < (RealPlayerScan.PauseUntil or 0) then return end
	if RealPlayerScan.LastPlayerCount ~= playerCount then
		RealPlayerScan.Count = 0
		RealPlayerScan.LastPlayerCount = playerCount
		RealPlayerScan.CycleLimit = playerCount * playerCount
	end
	local cycleLimit = playerCount * playerCount
	RealPlayerScan.CycleLimit = cycleLimit
	if RealPlayerScan.Count >= cycleLimit then return end
	RealPlayerScan.Count += 1
	local label = _G.Celestial.ScannedPlayersLabel
	if label and label.Parent then
		label.Text = "Scanned Players: " .. tostring(RealPlayerScan.Count)
	end
	if RealPlayerScan.Count >= cycleLimit then RealPlayerScan.PauseUntil = now + 15 end
end

local function ResetRealPlayerScanDisplay()
	RealPlayerScan.Count = 0
	RealPlayerScan.CycleLimit = 0
	RealPlayerScan.LastPlayerCount = 0
	RealPlayerScan.PauseUntil = 0
	local label = _G.Celestial.ScannedPlayersLabel
	if label and label.Parent then label.Text = "Scanned Players: 0" end
end

local function OTI_IsHeldOrInteractive(obj)
	if not obj or not obj.Parent then return false end
	if obj:FindFirstAncestorOfClass("Tool") then return true end
	if obj:FindFirstAncestorOfClass("Accessory") then return true end
	local model = obj:FindFirstAncestorOfClass("Model")
	if model and model:FindFirstChildOfClass("Humanoid") then return true end
	if obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChildOfClass("ClickDetector") then return true end
	for _, child in ipairs(obj:GetChildren()) do
		if child:IsA("WeldConstraint") then
			for _, p in ipairs({child.Part0, child.Part1}) do
				if p then
					local weldModel = p:FindFirstAncestorOfClass("Model")
					if weldModel and weldModel:FindFirstChildOfClass("Humanoid") then return true end
				end
			end
		end
	end
	return false
end

local function OTI_ResolveOwner(obj, myRoot)
	if not obj or not obj.Parent or OTI_IsHeldOrInteractive(obj) then return nil, nil end
	local now = tick()
	local data = OTI.TrackedObjects[obj]
	if data and data.Owner and data.Owner.Parent and now - (data.OwnerLastCheck or 0) < 0.35 then
		return data.Owner, data.OwnerReason or "cached"
	end
	local ancestor = obj
	local depth = 0
	while ancestor and depth < 5 do
		local nameLower = string.lower(ancestor.Name or "")
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local n = string.lower(plr.Name)
				if #n >= 3 and nameLower:find(n, 1, true) then return plr, "name:" .. ancestor.Name end
			end
		end
		ancestor = ancestor.Parent
		depth += 1
	end
	local velocity = SafeVector(obj.AssemblyLinearVelocity)
	local angular = SafeMagnitude(obj.AssemblyAngularVelocity)
	if velocity.Magnitude < 12 and angular < 180 then return nil, nil end
	local pos = obj.Position
	local bestPlr, bestDist = nil, 8
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local root = GetRoot(plr)
			if root then
				local d = (root.Position - pos).Magnitude
				if d < bestDist then bestDist, bestPlr = d, plr end
			end
		end
	end
	if bestPlr then return bestPlr, "dynamic-proximity" end
	return nil, nil
end

local function OTI_IsRelevantObject(obj)
	if not obj or not obj.Parent or not obj:IsA("BasePart") or obj.Anchored then return false end
	if LocalPlayer.Character and obj:IsDescendantOf(LocalPlayer.Character) then return false end
	if OTI_IsHeldOrInteractive(obj) then return false end
	local sz = obj.Size
	local maxDim = math.max(sz.X, sz.Y, sz.Z)
	local vol = sz.X * sz.Y * sz.Z
	if maxDim < 3.5 and vol < 24 then return false end
	return true
end

local function OTI_IsNaturalMotion(obj, currentVel, lastVel, angularSpeed)
	local horizontal = Vector3.new(currentVel.X, 0, currentVel.Z).Magnitude
	local vertical = currentVel.Y
	if vertical < -45 and horizontal < 20 and angularSpeed < 250 then return true end
	if currentVel.Magnitude < 28 and angularSpeed < 170 then return true end
	return false
end

local function OTI_RefreshPool(myPos)
	local maxDist = GetOTITrackingRadius()
	local char = LocalPlayer.Character
	local parts = {}
	local ok = pcall(function()
		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		if char then params.FilterDescendantsInstances = {char} end
		parts = Workspace:GetPartBoundsInBox(CFrame.new(myPos), Vector3.new(maxDist * 2, maxDist * 2, maxDist * 2), params)
	end)
	if not ok or type(parts) ~= "table" then parts = {} end
	local pool, poolList = {}, {}
	local maxDistSq = maxDist * maxDist
	for _, obj in ipairs(parts) do
		if OTI_IsRelevantObject(obj) then
			local d = obj.Position - myPos
			if d:Dot(d) <= maxDistSq then pool[obj] = true; poolList[#poolList + 1] = obj end
		end
	end
	OTI.ObjectPool = pool
	OTI.PoolList = poolList
end

local function OTI_ShouldSkipDormant(obj, data, now)
	if not data or not data.Dormant then return false end
	local lastCheck = data.LastDormantCheck or 0
	if now - lastCheck < GetOTIDormantScanInterval() then
		local vel = SafeVector(obj.AssemblyLinearVelocity)
		local ang = SafeMagnitude(obj.AssemblyAngularVelocity)
		if vel.Magnitude < GetOTIDormantSpeedThreshold() and ang < 20 then return true end
		data.Dormant = false; data.LastActiveTime = now; data.LastDormantCheck = now
		return false
	end
	data.LastDormantCheck = now
	return false
end

local function OTI_AnalyzeObject(obj, myRoot)
	if not OTI_IsRelevantObject(obj) then return nil end
	local now = tick()
	local data = OTI.TrackedObjects[obj]
	local currentPos = obj.Position
	local currentVel = SafeVector(obj.AssemblyLinearVelocity)
	local currentAngular = SafeVector(obj.AssemblyAngularVelocity)
	local speed = currentVel.Magnitude
	local angularSpeed = currentAngular.Magnitude
	if not data then
		data = {Owner=nil, OwnerName=nil, OwnerLastCheck=0, OwnerReason=nil, LastPos=currentPos, LastVel=currentVel, LastAngular=currentAngular, LastAccel=0, ObjectScore=0, FirstSeen=now, LastUpdate=now, LastSuspicionTime=0, Dormant=false, LastMovementTime=now, LastDormantCheck=0, LastActiveTime=now, SustainedAnomalyStart=nil}
		OTI.TrackedObjects[obj] = data
		return 0
	end
	local dt = math.max(now - (data.LastUpdate or now), 0.01)
	local accel = (currentVel - data.LastVel).Magnitude / dt
	local displacement = (currentPos - data.LastPos).Magnitude
	local dirChange = 0
	if data.LastVel.Magnitude > 6 and speed > 6 then
		local dot = math.clamp(data.LastVel.Unit:Dot(currentVel.Unit), -1, 1)
		dirChange = math.deg(math.acos(dot))
	end
	local naturalMotion = OTI_IsNaturalMotion(obj, currentVel, data.LastVel, angularSpeed)
	local score = 0
	if not naturalMotion then
		local speedThr, accelThr, angThr = GetOTIObjectSpeedThreshold(), GetOTIObjectAccelerationThreshold(), GetOTIObjectAngularThreshold()
		if speed >= speedThr then score += 26 elseif speed >= speedThr * 0.72 then score += 10 end
		if accel >= accelThr then score += 25 elseif accel >= accelThr * 0.72 then score += 10 end
		if angularSpeed >= angThr then score += 24 elseif angularSpeed >= angThr * 0.72 then score += 8 end
		if dirChange >= 100 and speed >= speedThr * 0.55 then score += 12 end
		if displacement > 12 then score += 14 elseif displacement > 6 then score += 6 end
	end
	local owner, reason = OTI_ResolveOwner(obj, myRoot)
	if owner then
		data.Owner, data.OwnerName, data.OwnerReason, data.OwnerLastCheck = owner, owner.Name, reason, now
	end
	if score >= 48 then data.SustainedAnomalyStart = data.SustainedAnomalyStart or now else data.SustainedAnomalyStart = nil end
	if data.SustainedAnomalyStart and now - data.SustainedAnomalyStart >= 0.35 then data.LastSuspicionTime = now end
	if data.LastSuspicionTime > 0 and now - data.LastSuspicionTime < GetOTISustainedTime() * 2 then score += 8 end
	data.ObjectScore = math.clamp((data.ObjectScore * 0.58) + (score * 0.42), 0, 100)
	data.LastPos, data.LastVel, data.LastAngular, data.LastAccel, data.LastUpdate = currentPos, currentVel, currentAngular, accel, now
	local dormantThr = GetOTIDormantSpeedThreshold()
	if speed < dormantThr and angularSpeed < 20 and displacement < 0.5 then
		if now - (data.LastMovementTime or now) >= GetOTIDormantTime() then data.Dormant = true end
	else
		data.LastMovementTime, data.Dormant, data.LastActiveTime = now, false, now
	end
	return data.ObjectScore
end

local function OTI_Tick()
	if not State.OTIActive then return end
	local myRoot = GetRoot()
	if not myRoot then return end
	local now, myPos = tick(), GetRoot().Position
	if now - OTI.LastPoolRefresh >= GetOTIPoolRefreshInterval() then
		OTI.LastPoolRefresh = now; pcall(OTI_RefreshPool, myPos)
	end
	local budget, analyzed = GetOTIMaxObjectsPerTick(), 0
	local processedThisTick = {}
	for obj, data in pairs(OTI.TrackedObjects) do
		if analyzed >= budget then break end
		if obj and obj.Parent and OTI.ObjectPool[obj] and (data.ObjectScore or 0) >= 25 and not data.Dormant then
			local ok = pcall(OTI_AnalyzeObject, obj, myRoot)
			if not ok then OTI.TrackedObjects[obj] = nil end
			processedThisTick[obj], analyzed = true, analyzed + 1
		end
	end
	local poolList, n = OTI.PoolList, #OTI.PoolList
	if n > 0 and analyzed < budget then
		local idx = OTI.ScanQueueIndex or 1
		if idx < 1 or idx > n then idx = 1 end
		local attempts = 0
		while analyzed < budget and attempts < n do
			local obj = poolList[idx]; idx = (idx % n) + 1; attempts += 1
			if obj and obj.Parent and not processedThisTick[obj] then
				local data = OTI.TrackedObjects[obj]
				if not OTI_ShouldSkipDormant(obj, data, now) then
					local ok = pcall(OTI_AnalyzeObject, obj, myRoot)
					if not ok then OTI.TrackedObjects[obj] = nil end
					analyzed += 1
				end
			end
		end
		OTI.ScanQueueIndex = idx
	end
	OTI.LastAnalyzedCount = analyzed
	for obj in pairs(OTI.TrackedObjects) do
		if not obj or not obj.Parent or not OTI.ObjectPool[obj] then OTI.TrackedObjects[obj] = nil end
	end
	local activeCount, threatCount = 0, 0
	for obj, data in pairs(OTI.TrackedObjects) do
		if obj and obj.Parent then
			if not data.Dormant then activeCount += 1 end
			if (data.ObjectScore or 0) >= 45 then threatCount += 1 end
		end
	end
	OTI.ActiveCount, OTI.ThreatCount = activeCount, threatCount
	local otSuspThreshold, otCritThreshold = GetOTIThreatConfidenceThreshold(), GetOTICriticalThreshold()
	local perOwner = {}
	for obj, data in pairs(OTI.TrackedObjects) do
		if data.Owner and data.Owner.Parent and not OTI_IsHeldOrInteractive(obj) then
			local e = perOwner[data.Owner]
			if not e then e = {maxScore=0,maxSpeed=0,maxAngular=0,objects={},count=0,severeCount=0}; perOwner[data.Owner]=e end
			e.objects[obj] = data.ObjectScore
			e.maxScore = math.max(e.maxScore, data.ObjectScore or 0)
			e.maxSpeed = math.max(e.maxSpeed, SafeMagnitude(data.LastVel))
			e.maxAngular = math.max(e.maxAngular, SafeMagnitude(data.LastAngular))
			e.count += 1
			if (data.ObjectScore or 0) >= otSuspThreshold then e.severeCount += 1 end
		end
	end
	for owner, entry in pairs(perOwner) do
		local history = GetHistory(owner)
		local po = OTI.PlayerOTI[owner]
		if not po then po={ObjectScore=0,SuspicionStart=nil,ConfirmedSuspicious=false,DangerousFlag=false,LastSeen=now}; OTI.PlayerOTI[owner]=po end
		po.LastSeen = now
		local clusterEvidence = entry.count >= 3 and entry.severeCount >= 2
		local singleObjectEvidence = entry.maxScore >= otSuspThreshold + 10 and entry.maxSpeed >= 135
		local combinedScore = math.clamp(entry.maxScore + (clusterEvidence and 18 or 0), 0, 100)
		po.ObjectScore = po.ObjectScore * 0.72 + combinedScore * 0.28
		history.OTI_Score, history.OTI_Objects = po.ObjectScore, entry.objects
		if (clusterEvidence or singleObjectEvidence) and po.ObjectScore >= otSuspThreshold then
			po.SuspicionStart = po.SuspicionStart or now
			if now - po.SuspicionStart >= GetOTISustainedTime() then
				po.ConfirmedSuspicious = true; history.OTI_ConfirmedSuspicious = true
				OTI.SuspiciousPlayers[owner] = {Score=math.floor(po.ObjectScore), Since=po.SuspicionStart}
			end
		else
			po.SuspicionStart = nil; po.ConfirmedSuspicious = false; history.OTI_ConfirmedSuspicious = false
			OTI.SuspiciousPlayers[owner] = nil
		end
		local criticalEvidence = false
		if po.ConfirmedSuspicious and po.ObjectScore >= otCritThreshold then
			for obj, score in pairs(entry.objects) do
				if obj and obj.Parent and score >= otCritThreshold and not OTI_IsHeldOrInteractive(obj) then
					local pos = obj.Position
					for _, plr in ipairs(Players:GetPlayers()) do
						if plr ~= owner and plr ~= LocalPlayer then
							local root = GetRoot(plr)
							if root and (root.Position - pos).Magnitude <= GetOTIThreatDistance() then criticalEvidence = true; break end
						end
					end
				end
				if criticalEvidence then break end
			end
		end
		if criticalEvidence then
			po.DangerousFlag = true; history.OTI_DangerousFlag = true
			OTI.DangerousPlayers[owner] = {Score=math.floor(po.ObjectScore), Since=now}
		else
			po.DangerousFlag = false; history.OTI_DangerousFlag = false; OTI.DangerousPlayers[owner] = nil
		end
	end
	for owner, po in pairs(OTI.PlayerOTI) do
		if not owner or not owner.Parent then
			OTI.PlayerOTI[owner] = nil
		elseif now - (po.LastSeen or 0) > 1.5 then
			po.ObjectScore *= 0.55
			if po.ObjectScore < 20 then po.ConfirmedSuspicious=false; po.DangerousFlag=false; OTI.SuspiciousPlayers[owner]=nil; OTI.DangerousPlayers[owner]=nil end
		end
	end
end

OTI.Connection = RunService.Heartbeat:Connect(function()
	local now = tick()
	if now - OTI.LastScan < OTI.ScanInterval then return end
	OTI.LastScan = now
	pcall(OTI_Tick)
end)

_G.Celestial.ConnectionOTI = OTI.Connection

-- ====================================================================
-- QUANTUM CORE
-- ====================================================================

AntiFlingQuantum.CharacterCache[LocalPlayer] = LocalPlayer.Character

AntiFlingQuantum.LocalCharacterConnection =
	LocalPlayer.CharacterAdded:Connect(function(character)
		AntiFlingQuantum.CharacterCache[LocalPlayer] = character
		AntiFlingQuantum.LastLocalPosition = nil
		AntiFlingQuantum.LastLocalVelocity = Vector3.zero
		AntiFlingQuantum.LastLocalAngularVelocity = Vector3.zero
		AntiFlingQuantum.CriticalMode = false
		AntiFlingQuantum.LastPassThroughCheck = 0
		if _G.Celestial.OTI then
			_G.Celestial.OTI.ObjectPool = {}
			_G.Celestial.OTI.PoolList = {}
			_G.Celestial.OTI.LastPoolRefresh = 0
		end
		task.delay(0.25, function()
			if not State.AntiFlingActive then return end
			local root = character:FindFirstChild("HumanoidRootPart")
			local hum = character:FindFirstChildOfClass("Humanoid")
			if root and hum and hum.Health > 0 then
				pcall(function()
					root.AssemblyLinearVelocity = Vector3.zero
					root.AssemblyAngularVelocity = Vector3.zero
				end)
			end
		end)
	end)

AntiFlingQuantum.Connection = RunService.Heartbeat:Connect(function()
	local now = tick()
	
	local fastInterval = AntiFlingQuantum.CriticalMode and AntiFlingQuantum.ThreatScanInterval or AntiFlingQuantum.BaseScanInterval
	if now - (AntiFlingQuantum.LastFastScan or 0) >= fastInterval then
		AntiFlingQuantum.LastFastScan = now
		pcall(AntiFlingQuantumFastTick, now)
	end
	
	local allPlayers = Players:GetPlayers()
	local N = #allPlayers - 1
	if N ~= QMAScheduler.LastPlayerCount then
		QMAScheduler.RebuildQueue(allPlayers)
	end
	
	if now >= QMAScheduler.NextBatchTime then
		local processed = 0
		local myRoot = GetRoot()
		if myRoot then
			local shared = QMAScheduler.GetSharedData(allPlayers, now)
			
			while processed < QMAScheduler.BatchSize and QMAScheduler.Index <= #QMAScheduler.Queue do
				local player = QMAScheduler.Queue[QMAScheduler.Index]
				QMAScheduler.Index = QMAScheduler.Index + 1
				processed = processed + 1
				
				if player and player.Parent and player.Character then
					RecordRealPlayerScanPlayer(#allPlayers)
					local analysis = AnalyzePlayer(player, myRoot, now, State.AntiFlingScanInterval or 0.08, allPlayers, shared)
					if analysis.Valid then
						local history = GetHistory(player)
						
						local closeRisk = analysis.Distance <= math.max(14, GetQuantumThreatDistance())
						local multiEvidence = (analysis.IndependentEvidenceCount or 0) >= 2
						local extremeSpinRisk = analysis.ExtremeSpinConfirmed and analysis.Distance <= 20
						local hardCollisionRisk = (closeRisk and multiEvidence) or extremeSpinRisk or (closeRisk and analysis.SpeedCritical and analysis.SustainedSpin)
						
						if hardCollisionRisk then
							history.DangerHoldUntil = math.max(history.DangerHoldUntil or 0, now + AntiFlingQuantum.GetDangerIsolationHold())
						end
						
						local flungByMeUntil = AntiFlingQuantum.RecentlyFlungByMe[player]
						local isFlungByMe = flungByMeUntil and now < flungByMeUntil
						
						if isFlungByMe or analysis.RelocationGrace then
							history.SustainedSpin = false
							history.Orbiting = false
							analysis.State = "Normal"
							analysis.Confidence = 0
						end

						if not isFlungByMe and not analysis.RelocationGrace and (analysis.SustainedSpin or analysis.Orbiting or analysis.State == "Critical") then
							local detectedFlinger, dist = DetectFlingerVictimPair(player, allPlayers, now)
							if detectedFlinger and dist <= AntiFlingQuantum.GetFlingerPairDistance() then
								local fr = GetRoot(detectedFlinger)
								local fs = fr and SafeMagnitude(fr.AssemblyLinearVelocity) or 0
								local fa = fr and SafeMagnitude(fr.AssemblyAngularVelocity) or 0
								local culpritHistory = GetHistory(detectedFlinger)
								local observedFlingerSpeed = culpritHistory.ObservedHorizontalSpeed or 0
								local speedEvidence = culpritHistory.SpeedAnomaly or culpritHistory.SpeedCritical or culpritHistory.TeleportSuspected
								local po = OTI.PlayerOTI[detectedFlinger]
								local otiScore = po and po.ObjectScore or 0
								if fs >= 100 or fa >= 500 or otiScore >= 85 or (speedEvidence and observedFlingerSpeed >= AntiFlingQuantum.GetFlingerSpeedThreshold() * 1.5) then
									local confidence = math.max(82, analysis.Confidence or 0, otiScore)
									AntiFlingQuantum.DangerousPlayers[detectedFlinger] = {Reason=otiScore >= 72 and "QMA + OTI correlation" or "Abnormal physics near flung player", Confidence=confidence, Source="QMA"}
									AntiFlingQuantum.ThreatStates[detectedFlinger] = {Valid=true,State="Critical",Confidence=confidence,Source="QMA-Flinger"}
									GetHistory(detectedFlinger).LastCriticalTime = now
								end
							end
						end

						local existingThreat = AntiFlingQuantum.ThreatStates[player]
						if existingThreat and (existingThreat.State == "Critical" or existingThreat.State == "Threat")
							and analysis.State ~= "Critical" and analysis.State ~= "Threat" and not analysis.RelocationGrace then
							analysis.State = existingThreat.State
							analysis.Confidence = math.max(analysis.Confidence or 0, existingThreat.Confidence or 0)
						end
						
						AntiFlingQuantum.ThreatStates[player] = analysis

						if not isFlungByMe and not analysis.RelocationGrace then
							if analysis.State == "Suspicious" or analysis.SustainedSpin or analysis.Orbiting or analysis.Flying
								or analysis.SpeedAnomaly or analysis.ExtremeSpinConfirmed or analysis.TeleportDetected then
								AntiFlingQuantum.SuspiciousPlayers[player] = {
									Reason=analysis.TeleportDetected and "Impossible Relocation"
										or analysis.SpeedCritical and "Extreme Speed"
										or analysis.SpeedAnomaly and "Sustained Speed Anomaly"
										or analysis.Hovering and "Hover/Fly Pattern"
										or analysis.SustainedSpin and "Abnormal Spin"
										or analysis.Orbiting and "Orbit Pattern"
										or analysis.Flying and "Extreme Air Physics"
										or analysis.Escalating and "Escalating Physics"
										or "Suspicious Physics",
									Confidence=analysis.Confidence, Speed=math.floor(analysis.ObservedHorizontalSpeed or 0),
									PeerSpeed=math.floor(analysis.PeerSpeedBaseline or 0), SpeedRatio=analysis.SpeedRatio or 1
								}
							else
								AntiFlingQuantum.SuspiciousPlayers[player] = nil
							end
							
							if analysis.State == "Threat" or analysis.State == "Critical" then
								history.LastProtectedTime = now
								if analysis.State == "Critical" then
									history.LastCriticalTime = now
								end
							end
						end
					end
				end
			end
		end
		
		if QMAScheduler.Index > #QMAScheduler.Queue then
			QMAScheduler.Index = 1
		end
		
		QMAScheduler.NextBatchTime = now + QMAScheduler.TimePerBatch
	end
end)

AntiFlingQuantum.RenderDefenseConnection = RunService.RenderStepped:Connect(function()
	if not State.AntiFlingActive then return end
	local root, hum = GetRoot(), GetHumanoid()
	if not root or not hum or hum.Health <= 0 then return end
	local ctx = AntiFlingQuantum.SelfActionContext
	if ctx.FlyActive or ctx.NoClipActive then return end
	local movementState = AntiFlingQuantum.GetMovementState(hum)
	if movementState == "Jumping" or movementState == "Freefall" then return end
	local linear = SafeVector(root.AssemblyLinearVelocity)
	local angular = SafeMagnitude(root.AssemblyAngularVelocity)
	local linearThreshold = math.max(260, ctx.ExpectedMaxHorizontal * 2.8)
	local verticalThreshold = math.max(260, ctx.ExpectedMaxVertical * 2.8)
	if angular >= 900 or linear.Magnitude >= linearThreshold or math.abs(linear.Y) >= verticalThreshold then
		AntiFlingQuantum.CriticalMode = true
		StabilizeLocalCharacter(root, true, true)
	end
end)

_G.Celestial.ConnectionAntiFling = AntiFlingQuantum.Connection

_G.Celestial.StopAntiFling = function()
	State.AntiFlingActive = false
	ClearAllProtection()
	if _G.Celestial.ClearQMAPlayerIsolation then pcall(_G.Celestial.ClearQMAPlayerIsolation) end
	if _G.Celestial.ClearQMPlayerPassThrough then pcall(_G.Celestial.ClearQMPlayerPassThrough) end
	if AntiFlingQuantum.Connection then
		pcall(function() AntiFlingQuantum.Connection:Disconnect() end)
		AntiFlingQuantum.Connection = nil
	end
	if AntiFlingQuantum.RenderDefenseConnection then
		pcall(function() AntiFlingQuantum.RenderDefenseConnection:Disconnect() end)
		AntiFlingQuantum.RenderDefenseConnection = nil
	end
	if AntiFlingQuantum.LocalCharacterConnection then
		pcall(function() AntiFlingQuantum.LocalCharacterConnection:Disconnect() end)
		AntiFlingQuantum.LocalCharacterConnection = nil
	end
	if AntiFlingQuantum.PlayerAddedConnection then
		pcall(function() AntiFlingQuantum.PlayerAddedConnection:Disconnect() end)
		AntiFlingQuantum.PlayerAddedConnection = nil
	end
	if AntiFlingQuantum.PlayerRemovingConnection then
		pcall(function() AntiFlingQuantum.PlayerRemovingConnection:Disconnect() end)
		AntiFlingQuantum.PlayerRemovingConnection = nil
	end
	for player in pairs(AntiFlingQuantum.AnimationConnections) do DisconnectAnimationConnection(player) end
	for player, connection in pairs(AntiFlingQuantum.PlayerConnections) do
		if connection then pcall(function() connection:Disconnect() end) end
		AntiFlingQuantum.PlayerConnections[player] = nil
	end
	table.clear(AntiFlingQuantum.SuspiciousPlayers)
	table.clear(AntiFlingQuantum.DangerousPlayers)
	table.clear(AntiFlingQuantum.ThreatStates)
	table.clear(AntiFlingQuantum.PlayerHistory)
end

-- ====================================================================
-- DETECTOR / POWER / TRAP / GUN / SCANNER
-- ====================================================================

local function CheckPlayerInventory(plr)
	local success, isKnife, isGun = pcall(function()
		if not plr or not plr.Character then return false, false end
		local hum = GetHumanoid(plr)
		if not hum or hum.Health <= 0 then return false, false end
		local char = plr.Character
		local backpack = plr:FindFirstChild("Backpack")
		local function scanContainer(container)
			if not container then return false, false end
			local ik, ig = false, false
			local knifeKeywords = {"knife", "dagger", "blade", "cutter", "sword", "shiv", "scaler"}
			local gunKeywords = {"gun", "revolver", "pistol", "blaster", "sheriff", "peacemaker"}
			for _, item in ipairs(container:GetChildren()) do
				if item:IsA("Tool") then
					local lowerName = string.lower(item.Name)
					if lowerName ~= "coin" and lowerName ~= "bag" then
						for _, kw in ipairs(knifeKeywords) do
							if lowerName:find(kw) then ik = true; break end
						end
						for _, kw in ipairs(gunKeywords) do
							if lowerName:find(kw) then ig = true; break end
						end
					end
				end
			end
			return ik, ig
		end
		local k1, g1 = scanContainer(char)
		local k2, g2 = scanContainer(backpack)
		return (k1 or k2), (g1 or g2)
	end)
	if success then return isKnife, isGun else return false, false end
end

local function ReadSheriffAimbotMurderer()
	local found = ""
	pcall(function()
		local knifeKeywords = {"knife", "dagger", "blade", "cutter", "sword", "shiv", "scaler"}
		local function hasKnife(container)
			if not container then return false end
			for _, item in ipairs(container:GetChildren()) do
				if item:IsA("Tool") then
					local lowerName = string.lower(item.Name)
					if lowerName ~= "coin" and lowerName ~= "bag" then
						for _, keyword in ipairs(knifeKeywords) do
							if lowerName:find(keyword, 1, true) then return true end
						end
					end
				end
			end
			return false
		end
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character then
				local hum = GetHumanoid(plr)
				if hum and hum.Health > 0 then
					local backpack = plr:FindFirstChild("Backpack")
					if hasKnife(plr.Character) or hasKnife(backpack) then
						found = plr.Name; break
					end
				end
			end
		end
	end)
	return found
end

task.spawn(function()
	while task.wait(0.12) do
		pcall(function()
			if State.AimbotActive then
				State.AimbotMurdererName = ReadSheriffAimbotMurderer()
			else
				State.AimbotMurdererName = ""
			end
		end)
	end
end)

local POWER_DEFINITIONS = {
	Footsteps = { Icon = "👣", Image = "rbxassetid://89678762692556", Passive = true, Aliases = {"footsteps", "footstep"} },
	Sleight = { Icon = "🔪⚡", Image = "rbxassetid://89382998597805", Passive = true, Aliases = {"sleight", "sleightofhand", "sleightofhands"} },
	Ninja = { Icon = "🥷", Image = "rbxassetid://131530180190063", Passive = true, Aliases = {"ninja"} },
	Haste = { Icon = "⚡", Image = "rbxassetid://123970889668725", Passive = true, Aliases = {"haste"} },
	["X-Ray"] = { Icon = "👁️", Image = "rbxassetid://106748195495135", Passive = false, Aliases = {"xray", "x-ray"} },
	Ghost = { Icon = "👻", Image = "rbxassetid://81925292959988", Passive = false, Aliases = {"ghost"} },
	Sprint = { Icon = "🏃‍♂️", Image = "rbxassetid://75031746905651", Passive = false, Aliases = {"sprint"} },
	Trap = { Icon = "🪤", Image = "rbxassetid://101459661649999", Passive = false, Aliases = {"trap", "murdertrap", "beartrap"} },
	["Fake Gun"] = { Icon = "🔫", Image = "rbxassetid://129230991277819", Passive = false, Aliases = {"fakegun", "fake-gun", "fake gun"} },
	Decoy = { Icon = "🪞", Image = "rbxassetid://108387103063998", Passive = false, Aliases = {"decoy"} }
}

local POWER_ORDER = {"Footsteps", "Sleight", "Ninja", "Haste", "X-Ray", "Ghost", "Sprint", "Trap", "Fake Gun", "Decoy"}

local PowerDetectionCache = {}
local PowerWatchConnections = {}
local PowerWatchInstances = {}
local PowerWatchPlayer = nil
local PowerWatchCharacter = nil
local PowerWatchRevision = 0
_G.Celestial.PowerWatchConnections = PowerWatchConnections

local function ClearPowerWatchers()
	for _, connection in pairs(PowerWatchConnections) do
		pcall(function() connection:Disconnect() end)
	end
	table.clear(PowerWatchConnections)
	table.clear(PowerWatchInstances)
	PowerWatchPlayer = nil
	PowerWatchCharacter = nil
	PowerWatchRevision += 1
end

local function MarkPowerWatchDirty() PowerWatchRevision += 1 end

local function WatchPowerInstance(instance)
	if not instance or PowerWatchInstances[instance] then return end
	PowerWatchInstances[instance] = true
	pcall(function()
		table.insert(PowerWatchConnections, instance.AttributeChanged:Connect(MarkPowerWatchDirty))
	end)
	if instance:IsA("ValueBase") then
		pcall(function()
			table.insert(PowerWatchConnections, instance.Changed:Connect(MarkPowerWatchDirty))
		end)
	end
end

local function SetupPowerWatchers(murderPlayer)
	local character = murderPlayer and murderPlayer.Character or nil
	if murderPlayer == PowerWatchPlayer and character == PowerWatchCharacter then return end
	ClearPowerWatchers()
	PowerWatchPlayer = murderPlayer
	PowerWatchCharacter = character
	if not murderPlayer then return end
	local containers = {
		murderPlayer, character,
		murderPlayer:FindFirstChild("Backpack"),
		murderPlayer:FindFirstChild("PlayerData"),
		murderPlayer:FindFirstChild("PlayerGui")
	}
	for _, container in ipairs(containers) do
		if container then
			WatchPowerInstance(container)
			for _, descendant in ipairs(container:GetDescendants()) do
				WatchPowerInstance(descendant)
			end
			pcall(function()
				table.insert(PowerWatchConnections, container.DescendantAdded:Connect(function(descendant)
					WatchPowerInstance(descendant)
					MarkPowerWatchDirty()
				end))
			end)
		end
	end
end

local function GetGhostTransparency(character)
	if not character then return 0 end
	local maxTransparency = 0
	local partCount = 0
	local nearlyTransparentCount = 0
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and not part:FindFirstAncestorOfClass("Tool") then
			partCount += 1
			local effectiveTransparency = math.max(part.Transparency, part.LocalTransparencyModifier)
			maxTransparency = math.max(maxTransparency, effectiveTransparency)
			if effectiveTransparency >= 0.98 then nearlyTransparentCount += 1 end
		end
	end
	if partCount >= 3 and nearlyTransparentCount >= math.max(3, math.ceil(partCount * 0.80)) then return 1 end
	return maxTransparency
end

local function NormalizePowerText(value)
	value = tostring(value or "")
	value = string.lower(value)
	value = value:gsub("[%s_%-%%%.%,]", "")
	return value
end

local function PowerAliasMatches(value, definition)
	local normalized = NormalizePowerText(value)
	if normalized == "" then return false end
	for _, alias in ipairs(definition.Aliases) do
		if normalized == NormalizePowerText(alias) then return true end
	end
	return false
end

local function DetectPowerFromContainer(container)
	if not container then return nil end
	local function checkName(name)
		for _, powerName in ipairs(POWER_ORDER) do
			local definition = POWER_DEFINITIONS[powerName]
			if PowerAliasMatches(name, definition) then return powerName end
		end
		return nil
	end
	local directPower = checkName(container.Name)
	if directPower then return directPower end
	for _, attributeName in ipairs({"Power", "MurderPower", "MurderAbility", "Ability", "Perk", "SelectedPower", "EquippedPower", "PowerName"}) do
		local ok, value = pcall(function() return container:GetAttribute(attributeName) end)
		if ok and value ~= nil then
			for _, powerName in ipairs(POWER_ORDER) do
				if PowerAliasMatches(value, POWER_DEFINITIONS[powerName]) then return powerName end
			end
		end
	end
	for _, obj in ipairs(container:GetDescendants()) do
		local byName = checkName(obj.Name)
		if byName then return byName end
		if obj:IsA("StringValue") then
			for _, powerName in ipairs(POWER_ORDER) do
				if PowerAliasMatches(obj.Value, POWER_DEFINITIONS[powerName]) then return powerName end
			end
		end
		if obj:IsA("ObjectValue") and obj.Value then
			local objectPower = checkName(obj.Value.Name)
			if objectPower then return objectPower end
		end
	end
	return nil
end

local function DetectMurderPower(plr)
	if not plr then return nil end
	local containers = {plr, plr.Character, plr:FindFirstChild("Backpack"), plr:FindFirstChild("PlayerData"), plr:FindFirstChild("PlayerGui")}
	for _, container in ipairs(containers) do
		local foundPower = DetectPowerFromContainer(container)
		if foundPower then return foundPower end
	end
	local playerGui = plr:FindFirstChildOfClass("PlayerGui")
	if playerGui then
		local foundPower = DetectPowerFromContainer(playerGui)
		if foundPower then return foundPower end
	end
	return nil
end

function _G.Celestial.ResolveLocalMurderPower()
	local now = tick()
	local character = LocalPlayer.Character
	local cache = PowerDetectionCache[LocalPlayer]
	if not cache or cache.Character ~= character then
		cache = {Character=character,Power=nil,Active=false,NextFastScan=0,NextDeepScan=0,NextActivityScan=0}
		PowerDetectionCache[LocalPlayer] = cache
	end
	if now < (cache.NextFastScan or 0) then return cache.Power, cache.Active end
	local function normalized(value)
		value = tostring(value or ""):lower():gsub("[%s_%-%%%.%,]", "")
		return value
	end
	local function powerFromValue(value)
		local n = normalized(value)
		if n == "" then return nil end
		for _, powerName in ipairs(POWER_ORDER) do
			local definition = POWER_DEFINITIONS[powerName]
			for _, alias in ipairs(definition.Aliases) do
				if n == normalized(alias) then return powerName end
			end
		end
		return nil
	end
	local function directPower(container)
		if not container then return nil end
		for _, attributeName in ipairs({"Power","MurderPower","MurderAbility","Ability","Perk","SelectedPower","EquippedPower","PowerName"}) do
			local ok, value = pcall(function() return container:GetAttribute(attributeName) end)
			if ok and value ~= nil then
				local found = powerFromValue(value)
				if found then return found end
			end
		end
		local found = powerFromValue(container.Name)
		if found then return found end
		for _, child in ipairs(container:GetChildren()) do
			found = powerFromValue(child.Name)
			if found then return found end
			if child:IsA("StringValue") then
				found = powerFromValue(child.Value)
				if found then return found end
			elseif child:IsA("ObjectValue") and child.Value then
				found = powerFromValue(child.Value.Name)
				if found then return found end
			end
		end
		return nil
	end
	local fastContainers = {LocalPlayer, character, LocalPlayer:FindFirstChild("Backpack"), LocalPlayer:FindFirstChild("PlayerData"), LocalPlayer:FindFirstChildOfClass("PlayerGui")}
	local foundPower
	for _, container in ipairs(fastContainers) do
		foundPower = directPower(container)
		if foundPower then break end
	end
	if not foundPower and now >= (cache.NextDeepScan or 0) then
		foundPower = DetectMurderPower(LocalPlayer)
		cache.NextDeepScan = now + 1.50
	end
	if foundPower then cache.Power = foundPower end
	cache.Character = character
	cache.NextFastScan = now + 0.20
	if cache.Power and now >= (cache.NextActivityScan or 0) then
		local definition = POWER_DEFINITIONS[cache.Power]
		if definition and definition.Passive then
			cache.Active = false
		else
			local ok, active = pcall(function() return IsPowerCurrentlyActive(LocalPlayer, cache.Power) end)
			cache.Active = ok and active == true or false
		end
		cache.NextActivityScan = now + 0.50
	end
	return cache.Power, cache.Active
end

local function PowerObjectLooksActive(obj)
	if not obj then return false end
	local activeNames = {"active","isactive","enabled","isenabled","using","isusing","inuse","isusingpower"}
	for _, name in ipairs(activeNames) do
		local ok, value = pcall(function() return obj:GetAttribute(name) end)
		if ok and value == true then return true end
	end
	for _, child in ipairs(obj:GetDescendants()) do
		if child:IsA("BoolValue") and child.Value == true then
			local normalizedName = NormalizePowerText(child.Name)
			for _, activeName in ipairs(activeNames) do
				if normalizedName == activeName then return true end
			end
		end
	end
	return false
end

local function IsPowerCurrentlyActive(plr, powerName)
	if not plr or not powerName then return false end
	local definition = POWER_DEFINITIONS[powerName]
	if not definition or definition.Passive then return false end

	if powerName == "Ghost" then
		local detector = _G.Celestial.PowerDetector
		local character = plr.Character
		local humanoid = GetHumanoid(plr)
		local characterInWorkspace = character and character.Parent == Workspace
		local root = characterInWorkspace and character:FindFirstChild("HumanoidRootPart") or nil
		local health = humanoid and humanoid.Health or detector.GhostLastKnownHealth or 0
		local transparency = GetGhostTransparency(character)
		local fullyTransparent = transparency >= 0.98
		if plr ~= _G.Celestial.PowerDetector.GhostLastPlayer or character ~= _G.Celestial.PowerDetector.GhostLastCharacter then
			_G.Celestial.PowerDetector.GhostLastPlayer = plr
			_G.Celestial.PowerDetector.GhostLastCharacter = character
			_G.Celestial.PowerDetector.GhostLastSeenAt = characterInWorkspace and tick() or 0
			_G.Celestial.PowerDetector.GhostLastKnownHealth = health > 0 and health or 0
		end
		if humanoid and humanoid.Health > 0 then _G.Celestial.PowerDetector.GhostLastKnownHealth = humanoid.Health end
		if characterInWorkspace then
			_G.Celestial.PowerDetector.GhostLastSeenAt = tick()
			if root then _G.Celestial.PowerDetector.GhostLastKnownCFrame = root.CFrame end
		end
		local roundState = _G.Celestial.RoundTimerState
		local roundActive
		if roundState then
			roundActive = roundState.phase == "Round" and not roundState.ended
				and (roundState.remaining == nil or roundState.remaining > 0)
		else roundActive = State.MurdererName == plr.Name end
		local stillAlive = (humanoid and humanoid.Health > 0) or (not humanoid and _G.Celestial.PowerDetector.GhostLastKnownHealth > 0)
		local missingFromMap = roundActive and stillAlive
			and _G.Celestial.PowerDetector.GhostLastSeenAt > 0
			and (not characterInWorkspace or not root)
			and plr.Parent == Players
		detector.GhostLastTransparency = transparency
		detector.GhostVisualActive = fullyTransparent
		detector.GhostMissingActive = missingFromMap
		detector.GhostActive = fullyTransparent or missingFromMap
		if detector.GhostActive then
			detector.GhostESPPlayer = plr
			detector.GhostActivationAt = detector.GhostActivationAt > 0 and detector.GhostActivationAt or tick()
			State.MurdererName = plr.Name
		else
			detector.GhostActivationAt = 0
			if detector.GhostESPPlayer == plr then detector.GhostESPPlayer = nil end
		end
		return detector.GhostActive
	end

	if powerName == "Sprint" then
		local detector = _G.Celestial.PowerDetector
		local murderHumanoid = GetHumanoid(plr)
		local murderRoot = GetRoot(plr)
		if not murderHumanoid or murderHumanoid.Health <= 0 or not murderRoot then
			detector.SprintActive = false; detector.SprintRatio = 0
			detector.SprintBaselineWalkSpeed = 0; detector.SprintLastWalkSpeed = 0
			detector.SprintLastMoveSpeed = 0; detector.SprintConfirmCount = 0
			detector.SprintSpikeAt = 0
			return false
		end
		local now = tick()
		if detector.SprintLastPlayer ~= plr or detector.SprintLastCharacter ~= plr.Character then
			detector.SprintLastPlayer = plr
			detector.SprintLastCharacter = plr.Character
			detector.SprintBaselineWalkSpeed = 0
			detector.SprintLastWalkSpeed = tonumber(murderHumanoid.WalkSpeed) or 16
			detector.SprintLastMoveSpeed = 0
			detector.SprintLastSampleAt = 0
			detector.SprintConfirmCount = 0
			detector.SprintSpikeAt = 0
		end
		local innocentWalkSpeeds = {}
		for _, otherPlr in ipairs(Players:GetPlayers()) do
			if otherPlr ~= LocalPlayer and otherPlr ~= plr then
				local hum = GetHumanoid(otherPlr)
				if hum and hum.Health > 0 then
					local walkSpeed = tonumber(hum.WalkSpeed) or 0
					if walkSpeed > 0 and walkSpeed < 100 then table.insert(innocentWalkSpeeds, walkSpeed) end
				end
			end
		end
		local innocentWalkSpeed = 16
		if #innocentWalkSpeeds > 0 then
			table.sort(innocentWalkSpeeds)
			local middle = (#innocentWalkSpeeds + 1) / 2
			if middle % 1 == 0 then innocentWalkSpeed = innocentWalkSpeeds[middle]
			else
				local lower = innocentWalkSpeeds[math.floor(middle)]
				local upper = innocentWalkSpeeds[math.ceil(middle)]
				innocentWalkSpeed = (lower + upper) / 2
			end
		end
		if (detector.SprintBaselineWalkSpeed or 0) <= 0 then detector.SprintBaselineWalkSpeed = innocentWalkSpeed end
		local murdererWalkSpeed = tonumber(murderHumanoid.WalkSpeed) or 0
		local murderVelocity = murderRoot.AssemblyLinearVelocity
		local murdererMoveSpeed = Vector3.new(murderVelocity.X, 0, murderVelocity.Z).Magnitude
		local lastWalkSpeed = detector.SprintLastWalkSpeed or murdererWalkSpeed
		local lastMoveSpeed = detector.SprintLastMoveSpeed or 0
		local baseline = detector.SprintBaselineWalkSpeed or innocentWalkSpeed
		if baseline <= 0 then baseline = innocentWalkSpeed end
		local normalCeiling = math.max(innocentWalkSpeed * 1.12, baseline * 1.12)
		if not detector.SprintActive and murdererWalkSpeed <= normalCeiling then
			if baseline <= 0 then baseline = murdererWalkSpeed
			else baseline = baseline + ((murdererWalkSpeed - baseline) * 0.25) end
		end
		detector.SprintBaselineWalkSpeed = baseline
		local walkRatio = innocentWalkSpeed > 0 and (murdererWalkSpeed / innocentWalkSpeed) or 0
		local baselineRatio = baseline > 0 and (murdererWalkSpeed / baseline) or 0
		local strongestRatio = math.max(walkRatio, baselineRatio)
		local dt = now - (detector.SprintLastSampleAt or now)
		local walkDelta = murdererWalkSpeed - lastWalkSpeed
		local moveDelta = murdererMoveSpeed - lastMoveSpeed
		local abruptWalkJump = dt >= 0 and dt <= 0.20 and walkDelta >= math.max(3.0, baseline * 0.15)
		local abruptMoveJump = dt >= 0 and dt <= 0.20 and moveDelta >= math.max(5.0, baseline * 0.25)
		local highEnough = murdererWalkSpeed >= math.max(20, innocentWalkSpeed * 1.30) and baselineRatio >= 1.25
		local activationSignal = highEnough and abruptWalkJump and (walkRatio >= 1.28 or abruptMoveJump)
		if activationSignal then
			detector.SprintConfirmCount = math.min((detector.SprintConfirmCount or 0) + 1, 3)
			detector.SprintSpikeAt = detector.SprintSpikeAt > 0 and detector.SprintSpikeAt or now
		elseif detector.SprintConfirmCount and detector.SprintConfirmCount > 0 then
			if highEnough and now - (detector.SprintSpikeAt or now) <= 0.18 then
				detector.SprintConfirmCount = math.min(detector.SprintConfirmCount + 1, 3)
			else
				detector.SprintConfirmCount = 0; detector.SprintSpikeAt = 0
			end
		end
		local active = detector.SprintActive
		if detector.SprintConfirmCount >= 2 and highEnough then
			active = true; detector.SprintSpikeAt = now
		elseif active then
			if murdererWalkSpeed < math.max(innocentWalkSpeed * 1.20, baseline * 1.15) then
				active = false; detector.SprintConfirmCount = 0; detector.SprintSpikeAt = 0
			end
		end
		detector.SprintLastWalkSpeed = murdererWalkSpeed
		detector.SprintLastMoveSpeed = murdererMoveSpeed
		detector.SprintLastSampleAt = now
		detector.SprintActive = active
		detector.SprintRatio = strongestRatio
		return active
	end

	local containers = {plr, plr.Character, plr:FindFirstChild("Backpack"), plr:FindFirstChild("PlayerData")}
	local normalizedPower = NormalizePowerText(powerName)
	for _, container in ipairs(containers) do
		if container then
			for key, value in pairs(container:GetAttributes()) do
				if value == true then
					local normalizedKey = NormalizePowerText(key)
					if normalizedKey:find(normalizedPower .. "active", 1, true)
						or normalizedKey:find(normalizedPower .. "using", 1, true)
						or normalizedKey:find("active" .. normalizedPower, 1, true)
						or normalizedKey:find("using" .. normalizedPower, 1, true)
						or normalizedKey == "activepower" or normalizedKey == "usingpower" then
						return true
					end
				end
			end
			for _, obj in ipairs(container:GetDescendants()) do
				local objNormalized = NormalizePowerText(obj.Name)
				if objNormalized == normalizedPower or objNormalized:find(normalizedPower, 1, true) then
					if PowerObjectLooksActive(obj) then return true end
				end
			end
		end
	end
	return false
end

_G.Celestial.PowerDetector = {
	CurrentPower = nil, CurrentState = "Unknown", CurrentPlayer = nil,
	GhostActive = false, GhostVisualActive = false, GhostMissingActive = false,
	GhostLastPlayer = nil, GhostLastCharacter = nil, GhostLastSeenAt = 0,
	GhostLastKnownHealth = 0, GhostLastKnownCFrame = nil, GhostESPPlayer = nil,
	GhostActivationAt = 0, GhostLastTransparency = 0,
	SprintActive = false, SprintRatio = 0, SprintBaselineWalkSpeed = 0,
	SprintLastWalkSpeed = 0, SprintLastMoveSpeed = 0, SprintLastSampleAt = 0,
	SprintLastPlayer = nil, SprintLastCharacter = nil, SprintConfirmCount = 0,
	SprintSpikeAt = 0
}

local function UpdatePowerDetectorState()
	if not State.PowerDetectorActive then
		_G.Celestial.PowerDetector.CurrentPower = nil
		_G.Celestial.PowerDetector.CurrentState = "Disabled"
		_G.Celestial.PowerDetector.CurrentPlayer = nil
		return
	end
	local detector = _G.Celestial.PowerDetector
	local murderName = State.MurdererName
	local murderPlayer = murderName ~= "" and Players:FindFirstChild(murderName) or nil
	if not murderPlayer and detector.CurrentPower == "Ghost"
		and detector.CurrentPlayer and detector.GhostActive
		and detector.CurrentPlayer.Parent == Players then
		murderPlayer = detector.CurrentPlayer
	end
	if not murderPlayer then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character then
				local hum = GetHumanoid(plr)
				if hum and hum.Health > 0 then
					local isKnife = CheckPlayerInventory(plr)
					if isKnife then murderPlayer = plr; break end
				end
			end
		end
	end
	if not murderPlayer then
		ClearPowerWatchers()
		_G.Celestial.PowerDetector.CurrentPower = nil
		_G.Celestial.PowerDetector.CurrentState = "Unknown"
		_G.Celestial.PowerDetector.CurrentPlayer = nil
		_G.Celestial.PowerDetector.GhostActive = false
		_G.Celestial.PowerDetector.GhostVisualActive = false
		_G.Celestial.PowerDetector.GhostMissingActive = false
		_G.Celestial.PowerDetector.SprintActive = false
		return
	end
	if murderPlayer == LocalPlayer then
		ClearPowerWatchers()
		local ownPower = _G.Celestial.ResolveLocalMurderPower()
		_G.Celestial.PowerDetector.CurrentPower = ownPower
		_G.Celestial.PowerDetector.CurrentState = "You are the Murderer"
		_G.Celestial.PowerDetector.CurrentPlayer = murderPlayer
		_G.Celestial.PowerDetector.GhostActive = false
		_G.Celestial.PowerDetector.SprintActive = false
		return
	end
	SetupPowerWatchers(murderPlayer)
	local now = tick()
	local character = murderPlayer.Character
	local cache = PowerDetectionCache[murderPlayer]
	local detectedPower
	if cache and cache.Character == character and cache.Revision == PowerWatchRevision
		and now < (cache.NextScan or 0) then
		detectedPower = cache.Power
	else
		detectedPower = DetectMurderPower(murderPlayer)
		PowerDetectionCache[murderPlayer] = {
			Character = character, Power = detectedPower,
			Revision = PowerWatchRevision, NextScan = now + 0.35,
		}
	end
	_G.Celestial.PowerDetector.CurrentPlayer = murderPlayer
	_G.Celestial.PowerDetector.CurrentPower = detectedPower
	if not detectedPower then
		_G.Celestial.PowerDetector.CurrentState = "Unknown"
		_G.Celestial.PowerDetector.GhostActive = false
		_G.Celestial.PowerDetector.SprintActive = false
		return
	end
	local definition = POWER_DEFINITIONS[detectedPower]
	if definition.Passive then
		_G.Celestial.PowerDetector.CurrentState = "Passive"
	else
		local isActive
		if detectedPower == "Ghost" or detectedPower == "Sprint" then
			isActive = IsPowerCurrentlyActive(murderPlayer, detectedPower)
		else
			local activityCache = cache and cache.Activity
			local activityRevision = cache and cache.ActivityRevision or -1
			if activityCache ~= nil and activityRevision == PowerWatchRevision
				and now < (cache.NextActivityScan or 0) then
				isActive = activityCache
			else
				isActive = IsPowerCurrentlyActive(murderPlayer, detectedPower)
				local currentCache = PowerDetectionCache[murderPlayer] or {}
				currentCache.Character = character
				currentCache.Power = detectedPower
				currentCache.Revision = PowerWatchRevision
				currentCache.Activity = isActive
				currentCache.ActivityRevision = PowerWatchRevision
				currentCache.NextActivityScan = now + 0.20
				currentCache.NextScan = math.max(currentCache.NextScan or 0, now + 0.20)
				PowerDetectionCache[murderPlayer] = currentCache
			end
		end
		_G.Celestial.PowerDetector.CurrentState = isActive and "Active" or "Inactive"
	end
	if detectedPower ~= "Ghost" then
		_G.Celestial.PowerDetector.GhostActive = false
		_G.Celestial.PowerDetector.GhostVisualActive = false
		_G.Celestial.PowerDetector.GhostMissingActive = false
	end
	if detectedPower ~= "Sprint" then
		_G.Celestial.PowerDetector.SprintActive = false
		_G.Celestial.PowerDetector.SprintRatio = 0
	end
end

_G.Celestial.TrapESPObjects = _G.Celestial.TrapESPObjects or {}
local TrapPowerState = false
local TrapRefreshQueued = false

local function IsPossibleTrapObject(obj)
	if not obj or not obj.Parent then return false end
	if not obj:IsDescendantOf(Workspace) then return false end
	local normalizedName = NormalizePowerText(obj.Name)
	local validNames = {["trap"]=true,["murdertrap"]=true,["beartrap"]=true,["trapmodel"]=true,["traphitbox"]=true,["trappart"]=true}
	if validNames[normalizedName] then return true end
	if normalizedName:find("trap", 1, true) then
		return obj:IsA("Model") or obj:IsA("BasePart")
	end
	return false
end

local function GetTrapAdornee(obj)
	if not obj or not obj.Parent then return nil end
	if obj:IsA("Model") or obj:IsA("BasePart") then return obj end
	local model = obj:FindFirstAncestorOfClass("Model")
	if model and string.lower(model.Name):find("trap", 1, true) then return model end
	return obj:FindFirstChildWhichIsA("BasePart", true)
end

local function ClearSingleTrapESP(obj)
	local hl = _G.Celestial.TrapESPObjects[obj]
	if hl then pcall(function() hl:Destroy() end) end
	_G.Celestial.TrapESPObjects[obj] = nil
end

local function ClearAllTrapESP()
	for obj, hl in pairs(_G.Celestial.TrapESPObjects) do
		if hl then pcall(function() hl:Destroy() end) end
		_G.Celestial.TrapESPObjects[obj] = nil
	end
end

local function IsMurderUsingTrapPower()
	local detector = _G.Celestial.PowerDetector
	if not detector then return false end
	local murderName = State.MurdererName
	if murderName == "" then return false end
	local murderPlayer = Players:FindFirstChild(murderName)
	return murderPlayer ~= nil and detector.CurrentPlayer == murderPlayer and detector.CurrentPower == "Trap"
end

local function CreateTrapHighlight(adornee)
	if not adornee or not adornee.Parent then return end
	if _G.Celestial.TrapESPObjects[adornee] and _G.Celestial.TrapESPObjects[adornee].Parent then return end
	local hl = Instance.new("Highlight")
	hl.Name = "TrapESP"
	hl.FillColor = Color3.fromRGB(255, 70, 70)
	hl.FillTransparency = 0.2
	hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Adornee = adornee
	hl.Parent = _G.Celestial.ESPFolder
	_G.Celestial.TrapESPObjects[adornee] = hl
end

local function RefreshTrapESP()
	if not State.TrapESPEnabled or not IsMurderUsingTrapPower() then
		ClearAllTrapESP()
		return
	end
	if not _G.Celestial.ESPFolder or not _G.Celestial.ESPFolder.Parent then return end
	local foundObjects = {}
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if IsPossibleTrapObject(obj) then
			local adornee = GetTrapAdornee(obj)
			if adornee then
				foundObjects[adornee] = true
				CreateTrapHighlight(adornee)
			end
		end
	end
	for obj, hl in pairs(_G.Celestial.TrapESPObjects) do
		if not foundObjects[obj] or not obj or not obj.Parent then
			if hl then pcall(function() hl:Destroy() end) end
			_G.Celestial.TrapESPObjects[obj] = nil
		end
	end
end

local function QueueTrapRefresh()
	if TrapRefreshQueued then return end
	TrapRefreshQueued = true
	task.defer(function()
		TrapRefreshQueued = false
		RefreshTrapESP()
	end)
end

local function HandleTrapPowerChange()
	local shouldDetect = State.TrapESPEnabled and IsMurderUsingTrapPower()
	if shouldDetect ~= TrapPowerState then
		TrapPowerState = shouldDetect
		if shouldDetect then QueueTrapRefresh()
		else ClearAllTrapESP() end
	end
end

_G.Celestial.ConnectionTrapDescendant =
	Workspace.DescendantAdded:Connect(function(obj)
		if not State.TrapESPEnabled or not TrapPowerState then return end
		if not IsPossibleTrapObject(obj) then return end
		local adornee = GetTrapAdornee(obj)
		if adornee then CreateTrapHighlight(adornee) end
	end)

_G.Celestial.ConnectionTrapRemoving =
	Workspace.DescendantRemoving:Connect(function(obj)
		ClearSingleTrapESP(obj)
	end)

_G.Celestial.ConnectionTrapESP = nil

local lastDeepGunScan = 0
local function FindDroppedGun()
	local direct = Workspace:FindFirstChild("GunDrop")
	if direct then
		if direct:IsA("BasePart") then return direct end
		if direct:IsA("Model") or direct:IsA("Tool") then
			local handle = direct:FindFirstChild("Handle") or direct:FindFirstChildOfClass("BasePart")
			if handle then return handle end
		end
	end
	local mapContainers = {"Normal", "Map", "Round", "CoinContainer"}
	for _, containerName in ipairs(mapContainers) do
		local container = Workspace:FindFirstChild(containerName)
		if container then
			local found = container:FindFirstChild("GunDrop")
			if found then
				if found:IsA("BasePart") then return found end
				if found:IsA("Model") or found:IsA("Tool") then
					local handle = found:FindFirstChild("Handle") or found:FindFirstChildOfClass("BasePart")
					if handle then return handle end
				end
			end
		end
	end
	
	local now = tick()
	if now - lastDeepGunScan > 1.0 then
		lastDeepGunScan = now
		for _, obj in ipairs(Workspace:GetDescendants()) do
			if obj.Name == "GunDrop" or obj.Name == "RevolverDrop" then
				if obj:IsA("BasePart") then return obj
				elseif obj:IsA("Model") or obj:IsA("Tool") then
					local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
					if handle then return handle end
				end
			end
		end
	end
	return nil
end

_G.Celestial.Highlights = _G.Celestial.Highlights or {}
local lastRoleScan = 0
local forceRoleScan = false

_G.Celestial.ForceRoleScan = function() forceRoleScan = true end

-- ====================================================================
-- SPIDER ESP (ROLE + WORLD ITEMS)
-- Uses the existing ESPFolder and role-scanner cycle. Item/model candidates
-- are tracked through Workspace events; the map is scanned only on activation.
-- ====================================================================

local SpiderESP = {
	Active = false,
	Connections = {},
	ItemObjects = setmetatable({}, {__mode = "k"}),
	NPCObjects = setmetatable({}, {__mode = "k"}),
	RoleCache = setmetatable({}, {__mode = "k"}),
	UIRoleHints = setmetatable({}, {__mode = "k"}),
	LastRoleRefresh = 0,
	LastUIRefresh = 0,
	NPCRefreshQueued = false,
}
_G.Celestial.SpiderESP = SpiderESP

local SPIDER_ROLE_PLAYER_COLOR = Color3.fromRGB(255, 77, 206) -- #FF4DCE
local SPIDER_ROLE_BOT_COLOR = Color3.fromRGB(255, 122, 0) -- #FF7A00
local SPIDER_ROLE_HUMAN_COLOR = Color3.fromRGB(0, 229, 255) -- #00E5FF
local SPIDER_ITEM_COLORS = {
	["Red Key"] = Color3.fromRGB(255, 48, 48), -- #FF3030
	["Blue Key"] = Color3.fromRGB(48, 128, 255), -- #3080FF
	["Green Key"] = Color3.fromRGB(57, 211, 83), -- #39D353
	["Orange Key"] = Color3.fromRGB(255, 140, 36), -- #FF8C24
	["Yellow Key"] = Color3.fromRGB(255, 225, 53), -- #FFE135
	["Purple Key"] = Color3.fromRGB(168, 85, 247), -- #A855F7
	["Crowbar"] = Color3.fromRGB(167, 173, 180), -- #A7ADB4
	["Battery"] = Color3.fromRGB(0, 229, 255), -- #00E5FF
	["Wrench"] = Color3.fromRGB(192, 192, 192), -- #C0C0C0
	["Bug Spray"] = Color3.fromRGB(255, 79, 163), -- #FF4FA3
}

local function SpiderDestroyVisual(visual)
	if visual then pcall(function() visual:Destroy() end) end
end

local function SpiderClearItemVisual(entry)
	if not entry then return end
	SpiderDestroyVisual(entry.Highlight)
	SpiderDestroyVisual(entry.Billboard)
	entry.Highlight = nil
	entry.Billboard = nil
	entry.Label = nil
end

local function SpiderClearNPCVisual(entry)
	if not entry then return end
	SpiderDestroyVisual(entry.Highlight)
	entry.Highlight = nil
end

local function SpiderIsUnderPlayerCharacter(instance)
	if not instance then return false end
	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if character and (instance == character or instance:IsDescendantOf(character)) then
			return true
		end
	end
	return false
end

local function SpiderIsAvailableInWorld(root)
	if not root or not root.Parent then return false end
	local ok, inWorkspace = pcall(function() return root:IsDescendantOf(Workspace) end)
	if not ok or not inWorkspace then return false end
	if SpiderIsUnderPlayerCharacter(root) then return false end

	local function IsCollectedMarker(key, value)
		local normalizedKey = NormalizeSpiderName(key)
		if type(value) == "boolean" then
			if (normalizedKey:find("collected", 1, true) or normalizedKey:find("pickedup", 1, true)
				or normalizedKey:find("equipped", 1, true)) and value then
				return true
			end
			if (normalizedKey == "available" or normalizedKey == "ispickup") and not value then
				return true
			end
		elseif type(value) == "string" then
			local normalizedValue = NormalizeSpiderName(value)
			if (normalizedKey:find("state", 1, true) or normalizedKey:find("status", 1, true))
				and (normalizedValue == "collected" or normalizedValue == "pickedup" or normalizedValue == "equipped") then
				return true
			end
		end
		return false
	end

	local okAttrs, attributes = pcall(function() return root:GetAttributes() end)
	if okAttrs and attributes then
		for key, value in pairs(attributes) do
			if IsCollectedMarker(key, value) then return false end
		end
	end
	for _, child in ipairs(root:GetChildren()) do
		if child:IsA("BoolValue") or child:IsA("StringValue") then
			if IsCollectedMarker(child.Name, child.Value) then return false end
		end
	end
	return true
end

local function SpiderIsItemRootClass(instance)
	return instance and (instance:IsA("Model") or instance:IsA("Tool")
		or instance:IsA("BasePart") or instance:IsA("Accessory"))
end

local function SpiderFindItemRoot(instance)
	if not instance then return nil, nil end
	local current = instance
	local bestRoot, bestKind = nil, nil
	while current and current ~= Workspace do
		if SpiderIsItemRootClass(current) then
			local kind = SpiderItemKindFromName(current.Name)
			if kind then
				-- Prefer an outer named model/tool over a same-named handle inside it.
				bestRoot, bestKind = current, kind
			end
		end
		current = current.Parent
	end
	return bestRoot, bestKind
end

local function SpiderGetHighlightAdornee(root)
	if not root or not root.Parent then return nil end
	if root:IsA("Model") or root:IsA("BasePart") then return root end
	if root:IsA("Tool") or root:IsA("Accessory") then
		return root:FindFirstChild("Handle") or root:FindFirstChildWhichIsA("BasePart", true)
	end
	return root:FindFirstChildWhichIsA("BasePart", true)
end

local function SpiderGetBillboardAdornee(root)
	local target = SpiderGetHighlightAdornee(root)
	if target and target:IsA("BasePart") then return target end
	if root and root:IsA("Model") then
		return root.PrimaryPart or root:FindFirstChildWhichIsA("BasePart", true)
	end
	return nil
end

local function SpiderUpdateItemVisual(root, entry)
	if not State.ESPEnabled or not SpiderESP.Active or not SpiderIsAvailableInWorld(root) then
		SpiderClearItemVisual(entry)
		return
	end
	local color = SPIDER_ITEM_COLORS[entry.Kind]
	local adornee = SpiderGetHighlightAdornee(root)
	if not color or not adornee or not _G.Celestial.ESPFolder or not _G.Celestial.ESPFolder.Parent then return end

	if not entry.Highlight or not entry.Highlight.Parent then
		local highlight = Instance.new("Highlight")
		highlight.Name = "SpiderItemESP_" .. tostring(entry.Kind):gsub("%s+", "")
		highlight.FillTransparency = 0.28
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		entry.Highlight = highlight
	end
	entry.Highlight.Adornee = adornee
	entry.Highlight.FillColor = color
	entry.Highlight.OutlineColor = color
	entry.Highlight.Enabled = true
	entry.Highlight.Parent = _G.Celestial.ESPFolder

	local billboardAdornee = SpiderGetBillboardAdornee(root)
	if billboardAdornee then
		if not entry.Billboard or not entry.Billboard.Parent then
			local billboard = Instance.new("BillboardGui")
			billboard.Name = "SpiderItemLabel_" .. tostring(entry.Kind):gsub("%s+", "")
			billboard.Size = UDim2.new(0, 118, 0, 24)
			billboard.StudsOffset = Vector3.new(0, 2.5, 0)
			billboard.AlwaysOnTop = true
			billboard.LightInfluence = 0
			billboard.MaxDistance = 250
			local label = Instance.new("TextLabel")
			label.Name = "ItemName"
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.GothamBold
			label.TextSize = 13
			label.TextStrokeTransparency = 0.15
			label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			label.Parent = billboard
			entry.Billboard = billboard
			entry.Label = label
		end
		entry.Billboard.Adornee = billboardAdornee
		entry.Billboard.Enabled = true
		entry.Label.Text = tostring(entry.Kind)
		entry.Label.TextColor3 = color
		if entry.Kind == "Crowbar" then
			entry.Label.TextStrokeColor3 = Color3.fromRGB(20, 20, 20)
		elseif entry.Kind == "Battery" then
			entry.Label.TextStrokeColor3 = Color3.fromRGB(0, 35, 40)
		end
		local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:FindFirstChild("PlayerGui")
		entry.Billboard.Parent = playerGui or _G.Celestial.ESPFolder
	end
end

local function SpiderRoleSignalFromValue(key, value)
	local normalizedKey = NormalizeSpiderName(key)
	local roleContext = normalizedKey:find("role", 1, true) or normalizedKey:find("team", 1, true)
		or normalizedKey:find("class", 1, true) or normalizedKey:find("side", 1, true)
		or normalizedKey:find("character", 1, true) or normalizedKey:find("isspider", 1, true)
		or normalizedKey:find("ishuman", 1, true) or normalizedKey:find("issurvivor", 1, true)
	if type(value) == "boolean" then
		if normalizedKey:find("isspider", 1, true) then return value and "SPIDER" or "HUMAN" end
		if (normalizedKey:find("ishuman", 1, true) or normalizedKey:find("issurvivor", 1, true)) and value then
			return "HUMAN"
		end
	elseif type(value) == "string" and roleContext then
		local normalizedValue = NormalizeSpiderName(value)
		if normalizedValue == "spider" or normalizedValue == "thespider" or normalizedValue == "spiderplayer" then
			return "SPIDER"
		end
		if normalizedValue == "human" or normalizedValue == "survivor" or normalizedValue == "survivors"
			or normalizedValue == "humanplayer" then
			return "HUMAN"
		end
	end
	return nil
end

local function SpiderReadRoleSignal(root, scanDescendants)
	if not root then return nil end
	local okAttrs, attributes = pcall(function() return root:GetAttributes() end)
	if okAttrs and attributes then
		for key, value in pairs(attributes) do
			local signal = SpiderRoleSignalFromValue(key, value)
			if signal then return signal end
		end
	end
	for _, child in ipairs(root:GetChildren()) do
		if child:IsA("ValueBase") then
			local signal = SpiderRoleSignalFromValue(child.Name, child.Value)
			if signal then return signal end
		end
	end
	if scanDescendants then
		for _, child in ipairs(root:GetDescendants()) do
			local okChildAttrs, childAttributes = pcall(function() return child:GetAttributes() end)
			if okChildAttrs and childAttributes then
				for key, value in pairs(childAttributes) do
					local signal = SpiderRoleSignalFromValue(key, value)
					if signal then return signal end
				end
			end
			if child:IsA("ValueBase") then
				local signal = SpiderRoleSignalFromValue(child.Name, child.Value)
				if signal then return signal end
			end
		end
	end
	return nil
end

local function SpiderRefreshUIRoleHints(now)
	if now - (SpiderESP.LastUIRefresh or 0) < 0.85 then return end
	SpiderESP.LastUIRefresh = now
	table.clear(SpiderESP.UIRoleHints)
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if not playerGui then return end
	for _, object in ipairs(playerGui:GetDescendants()) do
		if object:IsA("TextLabel") or object:IsA("TextButton") then
			local text = NormalizeSpiderName(object.Text)
			if text ~= "" and text:find("spider", 1, true) then
				if text:find("youarethespider", 1, true) or text:find("youareaspider", 1, true) then
					SpiderESP.UIRoleHints[LocalPlayer] = "SPIDER"
				end
				for _, player in ipairs(Players:GetPlayers()) do
					local playerName = NormalizeSpiderName(player.Name)
					if #playerName >= 3 and text:find(playerName, 1, true) then
						SpiderESP.UIRoleHints[player] = "SPIDER"
					end
				end
			elseif text:find("youarehuman", 1, true) or text:find("youaresurvivor", 1, true) then
				SpiderESP.UIRoleHints[LocalPlayer] = "HUMAN"
			end
		end
	end
end

local function SpiderGetPlayerRole(player, now)
	local cached = SpiderESP.RoleCache[player]
	if cached and now - cached.At < 0.45 then return cached.Role end
	local role = nil
	if player.Team then
		local teamName = NormalizeSpiderName(player.Team.Name)
		if teamName == "spider" or teamName == "spiderteam" then role = "SPIDER"
		elseif teamName == "human" or teamName == "humans" or teamName == "survivor" or teamName == "survivors" then role = "HUMAN" end
	end
	if not role then role = SpiderReadRoleSignal(player, false) end
	if not role and player.Character then role = SpiderReadRoleSignal(player.Character, true) end
	if not role then role = SpiderESP.UIRoleHints[player] end
	SpiderESP.RoleCache[player] = {Role = role, At = now}
	return role
end

local function SpiderIsPlayerCharacterModel(model)
	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if character and (character == model or model:IsDescendantOf(character)) then return true end
	end
	return false
end

local function SpiderIsBotModel(model)
	if not model or not model:IsA("Model") or not model.Parent then return false end
	if not model:IsDescendantOf(Workspace) or SpiderIsPlayerCharacterModel(model) then return false end
	local explicitRole = SpiderReadRoleSignal(model, false)
	local nameCue = IsSpiderNamedModel(model.Name)
	if explicitRole == "HUMAN" then return false end
	if explicitRole ~= "SPIDER" and not nameCue then return false end
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local root = model:FindFirstChild("HumanoidRootPart", true) or model.PrimaryPart
	if explicitRole == "SPIDER" and (humanoid or root or model:FindFirstChildWhichIsA("BasePart", true)) then return true end
	if nameCue and humanoid and root then return true end
	if nameCue then
		local partCount = 0
		for _, child in ipairs(model:GetDescendants()) do
			if child:IsA("BasePart") then
				partCount += 1
				if partCount >= 6 then return true end
			end
		end
	end
	return false
end

local function SpiderUpdateNPCVisual(model, entry)
	if not State.ESPEnabled or not SpiderESP.Active or not SpiderIsBotModel(model) then
		SpiderClearNPCVisual(entry)
		return
	end
	if not _G.Celestial.ESPFolder or not _G.Celestial.ESPFolder.Parent then return end
	if not entry.Highlight or not entry.Highlight.Parent then
		local highlight = Instance.new("Highlight")
		highlight.Name = "SpiderBotESP"
		highlight.FillTransparency = 0.25
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		entry.Highlight = highlight
	end
	entry.Highlight.Adornee = model
	entry.Highlight.FillColor = SPIDER_ROLE_BOT_COLOR
	entry.Highlight.OutlineColor = SPIDER_ROLE_BOT_COLOR
	entry.Highlight.Enabled = true
	entry.Highlight.Parent = _G.Celestial.ESPFolder
end

local function SpiderTrackItem(root, kind)
	if not root or not kind then return end
	local entry = SpiderESP.ItemObjects[root]
	if not entry then
		entry = {Kind = kind, Highlight = nil, Billboard = nil, Label = nil}
		SpiderESP.ItemObjects[root] = entry
	elseif entry.Kind ~= kind then
		SpiderClearItemVisual(entry)
		entry.Kind = kind
	end
	if State.ESPEnabled then SpiderUpdateItemVisual(root, entry) end
end

local function SpiderTrackNPC(model)
	if not model or not model:IsA("Model") then return end
	if not SpiderIsBotModel(model) then return end
	local entry = SpiderESP.NPCObjects[model]
	if not entry then
		entry = {Highlight = nil}
		SpiderESP.NPCObjects[model] = entry
	end
	if State.ESPEnabled then SpiderUpdateNPCVisual(model, entry) end
end

local function SpiderProcessAddedObject(object)
	if not SpiderESP.Active or not State.ESPEnabled or _G.Celestial.GameMode ~= "SPIDER" then return end
	local root, kind = SpiderFindItemRoot(object)
	if root and SpiderIsAvailableInWorld(root) then SpiderTrackItem(root, kind) end
	if not SpiderESP.NPCRefreshQueued then
		SpiderESP.NPCRefreshQueued = true
		task.defer(function()
			SpiderESP.NPCRefreshQueued = false
			if not SpiderESP.Active or not State.ESPEnabled or _G.Celestial.GameMode ~= "SPIDER" then return end
			local model = object and (object:IsA("Model") and object or object:FindFirstAncestorOfClass("Model"))
			if model then SpiderTrackNPC(model) end
		end)
	end
end

local function SpiderRemoveObject(object)
	for root, entry in pairs(SpiderESP.ItemObjects) do
		local shouldRemove = root == object
		if not shouldRemove then
			local ok, isDescendant = pcall(function() return root:IsDescendantOf(object) end)
			shouldRemove = ok and isDescendant
		end
		if shouldRemove or not root.Parent then
			SpiderClearItemVisual(entry)
			SpiderESP.ItemObjects[root] = nil
		end
	end
	for model, entry in pairs(SpiderESP.NPCObjects) do
		local shouldRemove = model == object
		if not shouldRemove then
			local ok, isDescendant = pcall(function() return model:IsDescendantOf(object) end)
			shouldRemove = ok and isDescendant
		end
		if shouldRemove or not model.Parent then
			SpiderClearNPCVisual(entry)
			SpiderESP.NPCObjects[model] = nil
		end
	end
end

function SpiderESP.Activate()
	if SpiderESP.Active or _G.Celestial.GameMode ~= "SPIDER" then return end
	SpiderESP.Active = true
	SpiderESP.LastRoleRefresh = 0
	SpiderESP.LastUIRefresh = 0
	local added = Workspace.DescendantAdded:Connect(SpiderProcessAddedObject)
	local removing = Workspace.DescendantRemoving:Connect(SpiderRemoveObject)
	table.insert(SpiderESP.Connections, added)
	table.insert(SpiderESP.Connections, removing)

	-- A single initial scan seeds item and NPC caches; future changes are event-driven.
	for _, object in ipairs(Workspace:GetDescendants()) do
		if SpiderIsItemRootClass(object) then
			local kind = SpiderItemKindFromName(object.Name)
			if kind then
				local root, resolvedKind = SpiderFindItemRoot(object)
				if root and resolvedKind and SpiderIsAvailableInWorld(root) then
					SpiderTrackItem(root, resolvedKind)
				end
			end
		end
		if object:IsA("Model") then
			local explicitRole = SpiderReadRoleSignal(object, false)
			if IsSpiderNamedModel(object.Name) or explicitRole == "SPIDER" then
				SpiderTrackNPC(object)
			end
		end
	end
end

function SpiderESP.DisableVisuals()
	for _, entry in pairs(SpiderESP.ItemObjects) do SpiderClearItemVisual(entry) end
	for _, entry in pairs(SpiderESP.NPCObjects) do SpiderClearNPCVisual(entry) end
end

function SpiderESP.Cleanup()
	for _, connection in ipairs(SpiderESP.Connections) do
		pcall(function() connection:Disconnect() end)
	end
	table.clear(SpiderESP.Connections)
	for root, entry in pairs(SpiderESP.ItemObjects) do
		SpiderClearItemVisual(entry)
		SpiderESP.ItemObjects[root] = nil
	end
	for model, entry in pairs(SpiderESP.NPCObjects) do
		SpiderClearNPCVisual(entry)
		SpiderESP.NPCObjects[model] = nil
	end
	table.clear(SpiderESP.RoleCache)
	table.clear(SpiderESP.UIRoleHints)
	SpiderESP.NPCRefreshQueued = false
	SpiderESP.Active = false
end

local function UpdateSpiderESP(activePlayers, now)
	if not State.ESPEnabled then
		AbsoluteClearESP()
		if SpiderESP.Active then SpiderESP.Cleanup() else SpiderESP.DisableVisuals() end
		if _G.Celestial.SelfHighlight then
			SpiderDestroyVisual(_G.Celestial.SelfHighlight)
			_G.Celestial.SelfHighlight = nil
		end
		for _, highlight in pairs(_G.Celestial.Highlights) do
			if highlight then pcall(function() highlight.Adornee = nil end) end
		end
		return
	end
	if not SpiderESP.Active then SpiderESP.Activate() end
	if not SpiderESP.Active then return end
	SpiderRefreshUIRoleHints(now)

	if now - (SpiderESP.LastRoleRefresh or 0) >= 0.35 then
		SpiderESP.LastRoleRefresh = now
		local activeMap = {}
		for _, player in ipairs(activePlayers) do
			activeMap[player] = true
			SpiderGetPlayerRole(player, now)
		end
		for player in pairs(SpiderESP.RoleCache) do
			if not activeMap[player] or not player.Parent then SpiderESP.RoleCache[player] = nil end
		end
		for player in pairs(SpiderESP.UIRoleHints) do
			if not activeMap[player] or not player.Parent then SpiderESP.UIRoleHints[player] = nil end
		end
	end

	for _, player in ipairs(activePlayers) do
		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local isAliveOrCharacterReady = character and (humanoid == nil or humanoid.Health > 0)
		if player ~= LocalPlayer and character and character:IsDescendantOf(Workspace) and isAliveOrCharacterReady then
			local highlight = _G.Celestial.Highlights[player]
			if not highlight or not highlight.Parent then
				highlight = Instance.new("Highlight")
				highlight.Name = "SpiderRoleESP_" .. player.Name
				highlight.Parent = _G.Celestial.ESPFolder
				_G.Celestial.Highlights[player] = highlight
			end
			local role = SpiderGetPlayerRole(player, now)
			local color = role == "SPIDER" and SPIDER_ROLE_PLAYER_COLOR
				or (role == "HUMAN" and SPIDER_ROLE_HUMAN_COLOR or nil)
			if color then
				highlight.Adornee = character
				highlight.Enabled = true
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.FillColor = color
				highlight.OutlineColor = color
				highlight.FillTransparency = 0.42
				highlight.OutlineTransparency = 0.05
			else
				-- No confirmed role signal: avoid guessing and do not render a definitive class.
				highlight.Adornee = nil
				highlight.Enabled = false
			end
		elseif player ~= LocalPlayer then
			local highlight = _G.Celestial.Highlights[player]
			if highlight then highlight.Adornee = nil end
		end
	end

	if State.ShowOwnESP then
		local character = LocalPlayer.Character
		if character and character:IsDescendantOf(Workspace) then
			local highlight = _G.Celestial.SelfHighlight
			if not highlight or not highlight.Parent then
				highlight = Instance.new("Highlight")
				highlight.Name = "CelestialSelfESP"
				highlight.Parent = _G.Celestial.ESPFolder
				_G.Celestial.SelfHighlight = highlight
			end
			local role = SpiderGetPlayerRole(LocalPlayer, now)
			local color = role == "SPIDER" and SPIDER_ROLE_PLAYER_COLOR
				or (role == "HUMAN" and SPIDER_ROLE_HUMAN_COLOR or nil)
			if color then
				highlight.Adornee = character
				highlight.Enabled = true
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.FillColor = color
				highlight.OutlineColor = color
				highlight.FillTransparency = 0.42
				highlight.OutlineTransparency = 0.05
			else
				highlight.Adornee = nil
				highlight.Enabled = false
			end
		end
	elseif _G.Celestial.SelfHighlight then
		SpiderDestroyVisual(_G.Celestial.SelfHighlight)
		_G.Celestial.SelfHighlight = nil
	end

	for root, entry in pairs(SpiderESP.ItemObjects) do
		if not SpiderIsAvailableInWorld(root) then
			SpiderClearItemVisual(entry)
			SpiderESP.ItemObjects[root] = nil
		else
			SpiderUpdateItemVisual(root, entry)
		end
	end
	for model, entry in pairs(SpiderESP.NPCObjects) do
		if not model.Parent or not model:IsDescendantOf(Workspace) or not SpiderIsBotModel(model) then
			SpiderClearNPCVisual(entry)
			SpiderESP.NPCObjects[model] = nil
		else
			SpiderUpdateNPCVisual(model, entry)
		end
	end
end

_G.Celestial.ConnectionRoleScanner =
	RunService.RenderStepped:Connect(function()
		local now = tick()
		if not forceRoleScan and now - lastRoleScan < 0.20 then return end
		lastRoleScan = now
		forceRoleScan = false
		pcall(function()
			if not _G.Celestial.ESPFolder or not _G.Celestial.ESPFolder.Parent then
				local folder = CoreGui:FindFirstChild("CelestialESP")
				if not folder then
					folder = Instance.new("Folder")
					folder.Name = "CelestialESP"
					pcall(function() folder.Parent = gethui() or CoreGui end)
				end
				_G.Celestial.ESPFolder = folder
			end
			local activePlayers = Players:GetPlayers()
			local activePlayersMap = {}
			for _, p in ipairs(activePlayers) do activePlayersMap[p] = true end
			for plr, hl in pairs(_G.Celestial.Highlights) do
				if not activePlayersMap[plr] or not plr.Parent then
					if hl then pcall(function() hl:Destroy() end) end
					PowerDetectionCache[plr] = nil
					DuelsMatchState.TeamByPlayer[plr] = nil
					_G.Celestial.Highlights[plr] = nil
				end
			end
			if _G.Celestial.GameMode == "SPIDER" then
				UpdateSpiderESP(activePlayers, now)
				return
			elseif SpiderESP.Active then
				SpiderESP.Cleanup()
			end
			if #activePlayers <= 1 then
				State.MurdererName = ""
				State.SheriffName = ""
				State.HeroName = ""
				State.OriginalSheriff = nil
				State.HasGunBeenDropped = false
				DuelsMatchState.TeamByPlayer = {}
				if not State.ESPEnabled then AbsoluteClearESP() end
				return
			end
			if not State.ESPEnabled then
				AbsoluteClearESP()
				for _, hl in pairs(_G.Celestial.Highlights) do
					if hl then hl.Adornee = nil end
				end
				return
			end
			if _G.Celestial.GameMode == "DUELS" then
				CheckDuelsMatchState()
				RefreshDuelsTeamAssignments()
			end
			if _G.Celestial.GameMode == "MM2" then
				local foundMurder = ""
				local currentGunHolder = nil
				for _, plr in ipairs(activePlayers) do
					local hum = GetHumanoid(plr)
					if plr.Character and hum and hum.Health > 0 then
						local isKnife, isGun = CheckPlayerInventory(plr)
						if isKnife then foundMurder = plr.Name end
						if isGun then currentGunHolder = plr.Name end
					end
				end
				local detector = _G.Celestial.PowerDetector
				local ghostLockedMurderer = detector
					and detector.GhostActive == true
					and detector.GhostESPPlayer
					and detector.GhostESPPlayer.Parent == Players
					and detector.GhostESPPlayer
				State.MurdererName = foundMurder ~= "" and foundMurder
					or (ghostLockedMurderer and ghostLockedMurderer.Name or "")
				local droppedGun = FindDroppedGun()
				if droppedGun then State.HasGunBeenDropped = true end
				if foundMurder == "" and currentGunHolder == nil and not droppedGun then
					State.OriginalSheriff = nil
					State.SheriffName = ""
					State.HeroName = ""
					State.HasGunBeenDropped = false
				else
					if currentGunHolder then
						if State.OriginalSheriff == nil then
							if State.HasGunBeenDropped then
								State.SheriffName = ""
								State.HeroName = currentGunHolder
							else
								State.OriginalSheriff = currentGunHolder
								State.SheriffName = currentGunHolder
								State.HeroName = ""
							end
						elseif currentGunHolder == State.OriginalSheriff then
							State.SheriffName = State.OriginalSheriff
							State.HeroName = ""
						else
							State.HasGunBeenDropped = true
							State.SheriffName = ""
							State.HeroName = currentGunHolder
						end
					else
						if State.OriginalSheriff then
							local origPlr = Players:FindFirstChild(State.OriginalSheriff)
							if origPlr then
								local _, origHasGun = CheckPlayerInventory(origPlr)
								if origHasGun then State.SheriffName = State.OriginalSheriff
								else State.SheriffName = "" end
							else State.SheriffName = "" end
						else State.SheriffName = "" end
						State.HeroName = ""
					end
				end
			else
				State.MurdererName = ""
				State.SheriffName = ""
				State.HeroName = ""
			end
			for _, plr in ipairs(activePlayers) do
				if plr ~= LocalPlayer then
					local hl = _G.Celestial.Highlights[plr]
					local char = plr.Character
					local isSuppressed = (_G.Celestial.HitboxSuppressedPlayer == plr)
					if isSuppressed then
						if hl then hl.Enabled = false end
					elseif char and char.Parent == Workspace then
						local hum = GetHumanoid(plr)
						local isAlive = hum and hum.Health > 0
						if isAlive or char:FindFirstChildOfClass("Humanoid") then
							if not hl or not hl.Parent then
								hl = Instance.new("Highlight")
								hl.Name = plr.Name
								hl.Parent = _G.Celestial.ESPFolder
								_G.Celestial.Highlights[plr] = hl
							end
							hl.Adornee = char
							local roleColor = COLOR_INNOCENT
							local isGhostVisual = false
							if _G.Celestial.GameMode == "MM2" then
								local name = plr.Name
								if name == State.MurdererName then
									roleColor = COLOR_MURDERER
									isGhostVisual = _G.Celestial.PowerDetector.CurrentPower == "Ghost"
										and _G.Celestial.PowerDetector.CurrentPlayer == plr
										and _G.Celestial.PowerDetector.GhostActive == true
									if isGhostVisual then roleColor = COLOR_GHOST end
								elseif name == State.SheriffName then roleColor = COLOR_SHERIFF
								elseif name == State.HeroName then roleColor = COLOR_HERO end
							else
								if DuelsMatchState.InMatch then
									local side = DuelsMatchState.TeamByPlayer[plr]
									if side == "SELF" then roleColor = COLOR_TEAM_SELF
									elseif side == "ENEMY" then roleColor = COLOR_TEAM_ENEMY
									else
										if IsDuelsGreenTeamMarker(plr) then
											DuelsMatchState.TeamByPlayer[plr] = "SELF"
											roleColor = COLOR_TEAM_SELF
										else
											DuelsMatchState.TeamByPlayer[plr] = "ENEMY"
											roleColor = COLOR_TEAM_ENEMY
										end
									end
								else roleColor = COLOR_LOBBY_WHITE end
							end
							hl.Enabled = true
							hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
							hl.FillColor = roleColor
							hl.OutlineColor = roleColor
							hl.FillTransparency = isGhostVisual and 0.18 or 0.5
							hl.OutlineTransparency = isGhostVisual and 0 or 0.15
						else
							if hl then hl.Adornee = nil end
						end
					else
						if hl then hl.Adornee = nil end
					end
				end
			end
			if State.ShowOwnESP then
				local myChar = LocalPlayer.Character
				if myChar and myChar.Parent == Workspace then
					local myHum = myChar:FindFirstChildOfClass("Humanoid")
					if myHum and myHum.Health > 0 then
						local selfHl = _G.Celestial.SelfHighlight
						if not selfHl or not selfHl.Parent then
							selfHl = Instance.new("Highlight")
							selfHl.Name = "CelestialSelfESP"
							selfHl.Parent = _G.Celestial.ESPFolder
							_G.Celestial.SelfHighlight = selfHl
						end
						selfHl.Adornee = myChar
						local selfColor = COLOR_INNOCENT
						if _G.Celestial.GameMode == "MM2" then
							if LocalPlayer.Name == State.MurdererName then selfColor = COLOR_MURDERER
							elseif LocalPlayer.Name == State.SheriffName then selfColor = COLOR_SHERIFF
							elseif LocalPlayer.Name == State.HeroName then selfColor = COLOR_HERO
							else selfColor = COLOR_INNOCENT end
						else selfColor = COLOR_TEAM_SELF end
						selfHl.Enabled = true
						selfHl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						selfHl.FillColor = selfColor
						selfHl.OutlineColor = selfColor
						selfHl.FillTransparency = 0.5
						selfHl.OutlineTransparency = 0.15
					end
				end
			else
				if _G.Celestial.SelfHighlight then
					pcall(function() _G.Celestial.SelfHighlight:Destroy() end)
					_G.Celestial.SelfHighlight = nil
				end
			end
		end)
	end)

function AntiFlingQuantum.EnsureGhostESPProxy()
	if _G.Celestial.GhostESPProxy and _G.Celestial.GhostESPProxy.Parent then
		return _G.Celestial.GhostESPProxy
	end
	local model = Instance.new("Model")
	model.Name = "CelestialGhostESPProxy"
	model.Parent = Workspace
	local humanoid = Instance.new("Humanoid")
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	humanoid.AutoRotate = false
	humanoid.Parent = model
	local proxy = Instance.new("Part")
	proxy.Name = "GhostMarker"
	proxy.Size = Vector3.new(2.6, 5.8, 2.0)
	proxy.Transparency = 1
	proxy.Anchored = true
	proxy.CanCollide = false
	proxy.CanTouch = false
	proxy.CanQuery = false
	proxy.CastShadow = false
	proxy.Parent = model
	model.PrimaryPart = proxy
	_G.Celestial.GhostESPProxy = model
	return model
end

local lastGhostESPRefresh = 0
_G.Celestial.ConnectionGhostESP = RunService.RenderStepped:Connect(function()
	local now = tick()
	if now - lastGhostESPRefresh < 0.016 then return end
	lastGhostESPRefresh = now
	if not State.ESPEnabled then
		if _G.Celestial.GhostESPProxy then
			pcall(function() _G.Celestial.GhostESPProxy:Destroy() end)
			_G.Celestial.GhostESPProxy = nil
		end
		return
	end
	if _G.Celestial.GameMode ~= "MM2" then
		if _G.Celestial.GhostESPProxy then
			pcall(function() _G.Celestial.GhostESPProxy:Destroy() end)
			_G.Celestial.GhostESPProxy = nil
		end
		return
	end
	local detector = _G.Celestial.PowerDetector
	local murderer = nil
	if State.MurdererName ~= "" then murderer = Players:FindFirstChild(State.MurdererName) end
	if not murderer and detector and detector.CurrentPower == "Ghost"
		and detector.CurrentPlayer and detector.CurrentPlayer.Parent == Players then
		murderer = detector.CurrentPlayer
	end
	if not murderer and detector and detector.GhostESPPlayer and detector.GhostESPPlayer.Parent == Players then
		murderer = detector.GhostESPPlayer
	end
	if not murderer then
		if _G.Celestial.GhostESPProxy then
			pcall(function() _G.Celestial.GhostESPProxy:Destroy() end)
			_G.Celestial.GhostESPProxy = nil
		end
		return
	end
	if murderer == LocalPlayer then
		local ownRoleHighlight = _G.Celestial.Highlights[LocalPlayer]
		if ownRoleHighlight then
			pcall(function() ownRoleHighlight:Destroy() end)
			_G.Celestial.Highlights[LocalPlayer] = nil
		end
		if _G.Celestial.GhostESPProxy then
			pcall(function() _G.Celestial.GhostESPProxy:Destroy() end)
			_G.Celestial.GhostESPProxy = nil
		end
		return
	end
	local char = murderer.Character
	local ghostActiveLatched = detector and detector.CurrentPower == "Ghost"
		and detector.CurrentPlayer == murderer and detector.GhostActive == true
	if not char then
		if not ghostActiveLatched and _G.Celestial.GhostESPProxy then
			pcall(function() _G.Celestial.GhostESPProxy:Destroy() end)
			_G.Celestial.GhostESPProxy = nil
		end
		return
	end
	local charInWorkspace = char.Parent == Workspace
	if not charInWorkspace and not ghostActiveLatched then return end
	local hl = _G.Celestial.Highlights[murderer]
	if not hl or not hl.Parent then
		hl = Instance.new("Highlight")
		hl.Name = murderer.Name
		hl.Parent = _G.Celestial.ESPFolder
		_G.Celestial.Highlights[murderer] = hl
	end
	local ghostVisual = false
	if detector and detector.CurrentPower == "Ghost" and detector.CurrentPlayer == murderer then
		local transparency = GetGhostTransparency(char)
		ghostVisual = transparency >= 0.98
		if ghostVisual then
			detector.GhostLastTransparency = transparency
			detector.GhostVisualActive = true
			detector.GhostActive = true
			detector.GhostESPPlayer = murderer
			if detector.GhostActivationAt == 0 then detector.GhostActivationAt = now end
			State.MurdererName = murderer.Name
		else detector.GhostVisualActive = false end
	end
	local ghostActive = ghostVisual
		or (detector and detector.CurrentPower == "Ghost" and detector.CurrentPlayer == murderer and detector.GhostActive == true)
	local ghostAdornee = char
	if ghostActive then
		local proxyModel = AntiFlingQuantum.EnsureGhostESPProxy()
		local proxyPart = proxyModel and proxyModel.PrimaryPart
		local root = char:FindFirstChild("HumanoidRootPart")
		local knownCFrame = detector and detector.GhostLastKnownCFrame
		if proxyPart then
			if root and root.Parent == Workspace then proxyPart.CFrame = root.CFrame
			elseif knownCFrame then proxyPart.CFrame = knownCFrame end
			if proxyPart.Parent then ghostAdornee = proxyModel end
		end
	elseif _G.Celestial.GhostESPProxy then
		pcall(function() _G.Celestial.GhostESPProxy:Destroy() end)
		_G.Celestial.GhostESPProxy = nil
	end
	hl.Enabled = true
	hl.Adornee = ghostAdornee
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	if ghostActive then
		hl.FillColor = COLOR_GHOST
		hl.OutlineColor = COLOR_GHOST
		hl.FillTransparency = 0.05
		hl.OutlineTransparency = 0
	else
		hl.FillColor = COLOR_MURDERER
		hl.OutlineColor = COLOR_MURDERER
		hl.FillTransparency = 0.5
		hl.OutlineTransparency = 0.15
	end
end)

-- ====================================================================
-- COIN FARMING SYSTEM
-- ====================================================================

local CoinEngine = {
	Running = false, CurrentTarget = nil, TargetQueue = {}, CurrentTween = nil,
	CoinCache = {}, CoinConnections = {}, LastFullScan = 0, FullScanInterval = 1.5,
	LastTargetScan = 0, TargetScanInterval = 0.018, MaxDistance = 600,
	PickupDistance = 3.4, ScanDebounce = {},
}
_G.Celestial.CoinEngine = CoinEngine

local function CoinNameMatches(obj)
	if not obj then return false end
	local name = string.lower(obj.Name)
	if name == "coin" or name:find("coin") or name:find("cash") or name == "collectable" or name == "collectible" then
		return name ~= "coincontainer"
	end
	return false
end

local function IsValidCoin(obj)
	if not obj or not obj.Parent or not obj:IsA("BasePart") or not CoinNameMatches(obj) then return false end
	local s = obj.Size
	return not (s.X > 10 or s.Y > 10 or s.Z > 10)
end

local function RegisterCoin(coin)
	if not IsValidCoin(coin) or CoinEngine.CoinCache[coin] then return end
	CoinEngine.CoinCache[coin] = true
	local connection
	connection = coin.AncestryChanged:Connect(function(_, parent)
		if not parent then
			CoinEngine.CoinCache[coin] = nil
			if connection then connection:Disconnect() end
			CoinEngine.CoinConnections[coin] = nil
			if CoinEngine.CurrentTarget == coin then CoinEngine.CurrentTarget = nil end
		end
	end)
	CoinEngine.CoinConnections[coin] = connection
end

local function UnregisterCoin(coin)
	CoinEngine.CoinCache[coin] = nil
	local connection = CoinEngine.CoinConnections[coin]
	if connection then connection:Disconnect() end
	CoinEngine.CoinConnections[coin] = nil
	if CoinEngine.CurrentTarget == coin then CoinEngine.CurrentTarget = nil end
end

local function ScanContainer(container)
	if not container then return end
	for _, obj in ipairs(container:GetDescendants()) do
		if IsValidCoin(obj) then RegisterCoin(obj) end
	end
end

local function FullCoinScan()
	local now = tick()
	if now - CoinEngine.LastFullScan < CoinEngine.FullScanInterval then return end
	CoinEngine.LastFullScan = now
	local preferredContainers = {Workspace:FindFirstChild("CoinContainer"), Workspace:FindFirstChild("Map"), Workspace:FindFirstChild("Normal"), Workspace:FindFirstChild("Round")}
	local scanned, foundAny = {}, false
	for _, container in ipairs(preferredContainers) do
		if container and not scanned[container] then scanned[container] = true; ScanContainer(container); foundAny = true end
	end
	if not foundAny and next(CoinEngine.CoinCache) == nil then ScanContainer(Workspace) end
end

local descendantConnection
local function StartCoinDetection()
	if descendantConnection then descendantConnection:Disconnect() end
	descendantConnection = Workspace.DescendantAdded:Connect(function(obj)
		if obj:IsA("BasePart") and CoinNameMatches(obj) then
			task.defer(function() if IsValidCoin(obj) then RegisterCoin(obj) end end)
		end
	end)
	_G.Celestial.CoinDescendantConnection = descendantConnection
end

local function CleanupCoinCache()
	for coin in pairs(CoinEngine.CoinCache) do
		if not IsValidCoin(coin) then UnregisterCoin(coin) end
	end
end

local function GetNearestCoins(root, maxTargets)
	if not root then return {} end
	maxTargets = maxTargets or 2
	local pos, nearest = root.Position, {}
	for coin in pairs(CoinEngine.CoinCache) do
		if IsValidCoin(coin) then
			local d = (pos - coin.Position).Magnitude
			if d <= CoinEngine.MaxDistance then
				local e = {Coin=coin, Distance=d}
				local inserted = false
				for i = 1, #nearest do
					if d < nearest[i].Distance then table.insert(nearest, i, e); inserted = true; break end
				end
				if not inserted then nearest[#nearest + 1] = e end
				while #nearest > maxTargets do table.remove(nearest) end
			end
		else UnregisterCoin(coin) end
	end
	local result = {}
	for i = 1, math.min(maxTargets, #nearest) do result[i] = nearest[i].Coin end
	return result
end

local function QueueTwoNearestCoins(root)
	CoinEngine.TargetQueue = {}
	for _, coin in ipairs(GetNearestCoins(root, 2)) do
		if IsValidCoin(coin) then CoinEngine.TargetQueue[#CoinEngine.TargetQueue + 1] = coin end
	end
	return #CoinEngine.TargetQueue
end

local function CancelCoinTween(clearQueue)
	if CoinEngine.CurrentTween then pcall(function() CoinEngine.CurrentTween:Cancel() end); CoinEngine.CurrentTween = nil end
	CoinEngine.CurrentTarget = nil
	if clearQueue then CoinEngine.TargetQueue = {} end
end

local function TryCollectCoin(root, coin)
	if not root or not root.Parent or not IsValidCoin(coin) then return false end
	if (root.Position - coin.Position).Magnitude > CoinEngine.PickupDistance then return false end
	if firetouchinterest then
		pcall(function() firetouchinterest(root, coin, 0) end)
		task.wait()
		pcall(function() firetouchinterest(root, coin, 1) end)
	else
		pcall(function() root.CFrame = CFrame.new(coin.Position) end)
	end
	pcall(function()
		local v = SafeVector(root.AssemblyLinearVelocity)
		if math.abs(v.Y) < 18 then root.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z) end
	end)
	return true
end

local function MoveToCoin(root, hum, coin)
	if not root or not hum or hum.Health <= 0 or not IsValidCoin(coin) then return false end
	CoinEngine.CurrentTarget = coin
	local speed = math.clamp(tonumber(State.TweenSpeed) or 95, 10, 100)
	local distance = (root.Position - coin.Position).Magnitude
	if distance > CoinEngine.MaxDistance then return false end
	if distance <= CoinEngine.PickupDistance then return TryCollectCoin(root, coin) end
	local travelTime = math.clamp(distance / speed, 0.035, 8)
	local targetCFrame = CFrame.new(coin.Position)
	CancelCoinTween(false)
	CoinEngine.CurrentTarget = coin
	local tween = TweenService:Create(root, TweenInfo.new(travelTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = targetCFrame})
	CoinEngine.CurrentTween = tween
	tween:Play()
	local startTime = tick()
	while tween.PlaybackState == Enum.PlaybackState.Playing do
		if not State.FarmEnabled or not root.Parent or not hum.Parent or hum.Health <= 0 or not IsValidCoin(coin) or tick() - startTime > travelTime + 1 then
			tween:Cancel()
			CoinEngine.CurrentTween = nil
			return false
		end
		task.wait()
	end
	CoinEngine.CurrentTween = nil
	if not State.FarmEnabled then return false end
	if not IsValidCoin(coin) then return true end
	TryCollectCoin(root, coin)
	task.wait()
	if not IsValidCoin(coin) then UnregisterCoin(coin); return true end
	return true
end

local function CoinFarmLoop()
	while true do
		task.wait(CoinEngine.TargetScanInterval)
		if not State.FarmEnabled then CancelCoinTween(true); continue end
		pcall(function()
			local root, hum = GetRoot(), GetHumanoid()
			if not root or not hum or hum.Health <= 0 then CancelCoinTween(true); return end
			FullCoinScan()
			local now = tick()
			if now - CoinEngine.LastTargetScan >= 0.25 then
				CleanupCoinCache()
				CoinEngine.LastTargetScan = now
			end
			if #CoinEngine.TargetQueue == 0 and not CoinEngine.CurrentTarget then
				QueueTwoNearestCoins(root)
			end
			local target = table.remove(CoinEngine.TargetQueue, 1)
			if target and IsValidCoin(target) then MoveToCoin(root, hum, target) end
		end)
	end
end

StartCoinDetection()
task.defer(function() pcall(function() CoinEngine.LastFullScan = 0; FullCoinScan() end) end)
if _G.Celestial.CoinFarmLoopThread then pcall(function() task.cancel(_G.Celestial.CoinFarmLoopThread) end) end
_G.Celestial.CoinFarmLoopThread = task.spawn(CoinFarmLoop)
_G.Celestial.ConnectionFarm = _G.Celestial.CoinFarmLoopThread

_G.Celestial.StopCoinEngine = function()
	State.FarmEnabled = false
	CancelCoinTween(true)
	for coin, connection in pairs(CoinEngine.CoinConnections) do
		if connection then connection:Disconnect() end
		CoinEngine.CoinConnections[coin] = nil
		CoinEngine.CoinCache[coin] = nil
	end
	if descendantConnection then descendantConnection:Disconnect(); descendantConnection = nil end
	CoinEngine.CurrentTarget = nil
	CoinEngine.TargetQueue = {}
end

-- ====================================================================
-- AIMBOT PRO + MURDER AIMBOT
-- ====================================================================

local smoothedPositions = {}
local skinSizeCache = {}
local smoothedVelocities = {}
local CachedPingMs = 0
local LastPingSample = 0

local function GetPlayerPing()
	local now = tick()
	if now - LastPingSample < 0.25 then return CachedPingMs end
	LastPingSample = now
	local success, ping = pcall(function()
		local Stats = game:GetService("Stats")
		local netStats = Stats:GetNetworkStats()
		return netStats:GetAveragePing()
	end)
	if success and type(ping) == "number" and ping >= 0 then CachedPingMs = ping end
	return CachedPingMs
end

local function GetPingAdjustmentFactor(ping)
	if ping <= 0 or ping > 200 then return 1.0 end
	if ping < 75 then return 1.0 + (75 - ping) / 75 * 0.3
	elseif ping < 100 then return 1.0
	else return math.max(0.6, 1.0 - (ping - 100) / 100 * 0.4) end
end

local function GetChestPosition(targetChar)
	if not targetChar then return nil end
	local chest = targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso")
	if chest then return chest.Position end
	local root = targetChar:FindFirstChild("HumanoidRootPart")
	if root then return root.Position + Vector3.new(0, 0.8, 0) end
	return nil
end

local function GetHeadPosition(targetChar)
	if not targetChar then return nil end
	local head = targetChar:FindFirstChild("Head")
	if head and head:IsA("BasePart") then return head.Position end
	local chest = GetChestPosition(targetChar)
	return chest and (chest + Vector3.new(0, 0.75, 0)) or nil
end

local function Predict3DAdaptiveTarget(targetChar, deltaTime, externalStrength)
	local tRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
	if not tRoot then return nil end
	local chestPos = GetChestPosition(targetChar)
	if not chestPos then return nil end
	local charName = targetChar.Name
	local rawVel = tRoot.AssemblyLinearVelocity
	local prevSmoothVel = smoothedVelocities[charName] or rawVel
	local dt = deltaTime or 0.016
	local velAlpha = 1 - math.exp(-25 * dt)
	local currentVel = prevSmoothVel:Lerp(rawVel, velAlpha)
	smoothedVelocities[charName] = currentVel
	local ping = GetPlayerPing()
	local pingFactor = GetPingAdjustmentFactor(ping)
	local speed = currentVel.Magnitude
	local strength = externalStrength or State.AimbotStrength or 5
	strength = math.clamp(strength, 1, 10)
	local strengthFactor = 0.4 + (strength - 1) * (1.2 / 9)
	local baseLeadFactor = math.clamp(speed * 0.020, 0, 0.5)
	local leadFactor = baseLeadFactor * pingFactor * strengthFactor
	local predictedPos = chestPos + (currentVel * leadFactor)
	local lastSmoothed = smoothedPositions[charName] or predictedPos
	local posAlpha = 1 - math.exp(-60 * dt)
	local finalPos = lastSmoothed:Lerp(predictedPos, posAlpha)
	smoothedPositions[charName] = finalPos
	return finalPos
end

local MurderAimState = {
	Target = nil,
	TargetChangedAt = 0,
	LastTargetSeenAt = 0,
	SmoothedPosition = nil,
	SmoothedVelocity = Vector3.zero,
	CamCFrame = nil,
}

local function ResetMurderAimState()
	MurderAimState.Target = nil
	MurderAimState.TargetChangedAt = 0
	MurderAimState.LastTargetSeenAt = 0
	MurderAimState.SmoothedPosition = nil
	MurderAimState.SmoothedVelocity = Vector3.zero
	MurderAimState.CamCFrame = nil
end

local function GetMurderTorsoPos(targetChar)
	if not targetChar then return nil end
	local upper = targetChar:FindFirstChild("UpperTorso")
	if upper and upper:IsA("BasePart") then return upper.Position end
	local torso = targetChar:FindFirstChild("Torso")
	if torso and torso:IsA("BasePart") then return torso.Position end
	local root = targetChar:FindFirstChild("HumanoidRootPart")
	if root and root:IsA("BasePart") then return root.Position + Vector3.new(0, 0.6, 0) end
	return nil
end

local function ComputeMurderAimTarget(targetChar, deltaTime)
	if not targetChar then return nil end
	local tRoot = targetChar:FindFirstChild("HumanoidRootPart")
	if not tRoot then return nil end
	local torsoPos = GetMurderTorsoPos(targetChar)
	if not torsoPos then return nil end
	local dt = math.clamp(deltaTime or 0.016, 0.008, 0.05)
	local charName = targetChar.Name
	local rawVel = tRoot.AssemblyLinearVelocity
	local prevVel = smoothedVelocities[charName] or rawVel
	local velAlpha = 1 - math.exp(-22 * dt)
	local smoothVel = prevVel:Lerp(rawVel, velAlpha)
	smoothedVelocities[charName] = smoothVel
	local horizontalVel = Vector3.new(smoothVel.X, 0, smoothVel.Z)
	local speed = horizontalVel.Magnitude
	local leadAmount = math.clamp(speed * 0.004, 0, 0.12)
	local predicted = torsoPos + (horizontalVel * leadAmount)
	local prevSmooth = smoothedPositions[charName] or predicted
	local posAlpha = 1 - math.exp(-42 * dt)
	local finalPos = prevSmooth:Lerp(predicted, posAlpha)
	smoothedPositions[charName] = finalPos
	return finalPos
end

local function IsValidAimbotTarget(plr)
	if not plr or plr == LocalPlayer then return false end
	local char = plr.Character
	if not char or char.Parent ~= Workspace then return false end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return false end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return false end
	local pos = root.Position
	if pos.Y < -200 or pos.Y > 2000 then return false end
	local myRoot = GetRoot()
	if myRoot and (myRoot.Position - pos).Magnitude > 1500 then return false end
	local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
	local allowInvisibleTrackedMurderer = State.AimbotActive
		and _G.Celestial.GameMode == "MM2"
		and State.AimbotMurdererName == plr.Name
	if torso and torso.Transparency > 0.95
		and (char:FindFirstChild("Head") and char.Head.Transparency > 0.95)
		and not allowInvisibleTrackedMurderer then
		return false
	end
	if _G.Celestial.GameMode == "DUELS" and IsSameTeam(plr) then return false end
	return true
end

local function GetClosestTargetForMurder()
	local closestPlr
	local shortestDist = math.huge
	local myRoot = GetRoot()
	if not myRoot then return nil end
	for _, plr in ipairs(Players:GetPlayers()) do
		if IsValidAimbotTarget(plr) then
			if _G.Celestial.GameMode == "MM2" and plr.Name == State.MurdererName then
				-- skip self
			else
				local tRoot = GetRoot(plr)
				if tRoot then
					local dist = (tRoot.Position - myRoot.Position).Magnitude
					if dist < shortestDist then
						shortestDist = dist
						closestPlr = plr
					end
				end
			end
		end
	end
	return closestPlr
end

local function AimThrowAtTarget()
	if not State.MurderAimbotActive then return end
	local hasKnife, _ = CheckPlayerInventory(LocalPlayer)
	if not hasKnife then return end
	local targetPlr = GetClosestTargetForMurder()
	if not targetPlr or not targetPlr.Character then return end
	local torsoPos = ComputeMurderAimTarget(targetPlr.Character, 0.016)
	if not torsoPos then
		torsoPos = GetMurderTorsoPos(targetPlr.Character)
	end
	if not torsoPos then return end
	Camera.CFrame = CFrame.new(Camera.CFrame.Position, torsoPos)
end

local AimbotStabilization = {
	Target = nil, TargetChangedAt = 0, LastTargetSeenAt = 0,
	SmoothedPosition = nil, SmoothedVelocity = Vector3.zero,
}

local function ResetAimbotStabilization()
	AimbotStabilization.Target = nil
	AimbotStabilization.TargetChangedAt = 0
	AimbotStabilization.LastTargetSeenAt = 0
	AimbotStabilization.SmoothedPosition = nil
	AimbotStabilization.SmoothedVelocity = Vector3.zero
end

local function StabilizeSheriffTarget(currentTarget, rawTargetPos, deltaTime)
	local now = tick()
	local dt = math.clamp(deltaTime or 0.016, 0.008, 0.05)
	if currentTarget and AimbotStabilization.Target ~= currentTarget then
		local previousTarget = AimbotStabilization.Target
		if previousTarget and (now - AimbotStabilization.TargetChangedAt) < 0.10
			and IsValidAimbotTarget(previousTarget) then
			currentTarget = previousTarget
		else
			AimbotStabilization.Target = currentTarget
			AimbotStabilization.TargetChangedAt = now
			AimbotStabilization.SmoothedPosition = nil
		end
	end
	if not currentTarget or not rawTargetPos then
		if AimbotStabilization.SmoothedPosition
			and (now - AimbotStabilization.LastTargetSeenAt) < 0.10 then
			return nil, AimbotStabilization.SmoothedPosition
		end
		return nil, nil
	end
	AimbotStabilization.LastTargetSeenAt = now
	local targetChar = currentTarget.Character
	local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
	local targetVelocity = targetRoot and SafeVector(targetRoot.AssemblyLinearVelocity) or Vector3.zero
	AimbotStabilization.SmoothedVelocity =
		AimbotStabilization.SmoothedVelocity:Lerp(targetVelocity, 1 - math.exp(-18 * dt))
	local speed = AimbotStabilization.SmoothedVelocity.Magnitude
	local responseRate = 24 + math.clamp(speed * 0.45, 0, 18)
	local alpha = 1 - math.exp(-responseRate * dt)
	local previous = AimbotStabilization.SmoothedPosition or rawTargetPos
	local stabilized = previous:Lerp(rawTargetPos, alpha)
	local verticalAlpha = math.clamp(alpha * 0.70, 0.12, 0.85)
	stabilized = Vector3.new(
		stabilized.X,
		previous.Y + (stabilized.Y - previous.Y) * verticalAlpha,
		stabilized.Z
	)
	if (stabilized - previous).Magnitude < 0.025 then stabilized = previous end
	AimbotStabilization.SmoothedPosition = stabilized
	return currentTarget, stabilized
end

local function GetClosestTargetForStab()
	local closestPlr
	local shortestDist = math.huge
	local myRoot = GetRoot()
	if not myRoot then return nil end
	for _, plr in ipairs(Players:GetPlayers()) do
		if IsValidAimbotTarget(plr) then
			local tRoot = GetRoot(plr)
			if tRoot then
				local dist = (tRoot.Position - myRoot.Position).Magnitude
				if dist < shortestDist then
					shortestDist = dist
					closestPlr = plr
				end
			end
		end
	end
	return closestPlr
end

local function UpdateMurderAimCamera(deltaTime, predictedPos, stabMode)
	if not predictedPos then return end
	local smoothness = stabMode
		and math.clamp(State.StabSmoothness or 50, 1, 150)
		or math.clamp(State.AimbotSmoothness or 22, 1, 50)
	local t = stabMode and ((smoothness - 1) / 149) or ((smoothness - 1) / 49)
	local convSpeed = stabMode and (30 - t * 24) or (75 - t * 45)
	local strength = stabMode
		and math.clamp(State.StabPredictionStrength or 5, 1, 10)
		or math.clamp(State.AimbotStrength or 5, 1, 10)
	local strengthBoost = 0.85 + (strength - 1) * (0.55 / 9)
	local finalConvSpeed = convSpeed * strengthBoost
	local alpha = 1 - math.exp(-deltaTime * finalConvSpeed)
	local targetCFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
	Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, alpha)
end

task.spawn(function()
	pcall(function()
		RunService.RenderStepped:Connect(function(deltaTime)
			pcall(function()
				local isShiftlockActive = (UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter)
				local hasKnife, hasGun = CheckPlayerInventory(LocalPlayer)
				local localHumanoid = GetHumanoid(LocalPlayer)
				local localAlive = localHumanoid and localHumanoid.Health > 0
				local gameMode = _G.Celestial.GameMode

				if not State.AimbotActive or not State.SuperStableActive then
					ResetAimbotStabilization()
				end

				if State.AimbotActive and (gameMode == "MM2" or gameMode == "DUELS") and isShiftlockActive and localAlive then
					local canAim = hasGun or hasKnife
					if gameMode == "MM2" then canAim = hasGun end
					if canAim then
						local smoothness = math.clamp(State.AimbotSmoothness or 22, 1, 50)
						local sliderStrength = math.clamp(State.AimbotStrength or 5, 1, 10)
						local effectiveStrength = sliderStrength + 3
						local t = (smoothness - 1) / 49
						local convSpeed = 75 - t * 45
						local mappedStrengthBoost = 1.00 + (effectiveStrength - 4) * (0.35 / 9)
						local strengthBoost = mappedStrengthBoost * 3
						local alpha = 1 - math.exp(-deltaTime * convSpeed * strengthBoost)
						local targetPlayer = nil
						if gameMode == "MM2" then
							targetPlayer = State.AimbotMurdererName ~= "" and Players:FindFirstChild(State.AimbotMurdererName) or nil
						else
							targetPlayer = GetClosestTargetForMurder()
						end
						if targetPlayer and IsValidAimbotTarget(targetPlayer) then
							local targetPos = GetHeadPosition(targetPlayer.Character)
							if targetPos then
								if State.SuperStableActive then
									local stabilizedTarget, stabilizedPos = StabilizeSheriffTarget(targetPlayer, targetPos, deltaTime)
									if stabilizedTarget then
										targetPlayer = stabilizedTarget
										targetPos = stabilizedPos
									end
								end
								if targetPos then
									local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
									Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, alpha)
								end
							end
						elseif State.SuperStableActive then
							local _, heldPosition = StabilizeSheriffTarget(nil, nil, deltaTime)
							if heldPosition then
								local targetCFrame = CFrame.new(Camera.CFrame.Position, heldPosition)
								Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, alpha)
							end
						end
					end
				end

				if State.MurderStabAimbotActive and (gameMode == "MM2" or gameMode == "DUELS") and isShiftlockActive and hasKnife then
					local canStab = false
					if gameMode == "MM2" then canStab = (State.MurdererName == LocalPlayer.Name)
					else canStab = true end
					if canStab then
						local targetPlr = GetClosestTargetForStab()
						if targetPlr and targetPlr.Character then
							local torsoPos = ComputeMurderAimTarget(targetPlr.Character, deltaTime)
							if torsoPos then
								UpdateMurderAimCamera(deltaTime, torsoPos, true)
							end
						end
					end
				end
			end)
		end)
	end)
end)

RunService.Heartbeat:Connect(function()
	pcall(function()
		if State.SuperStableActive then
			local root = GetRoot()
			if root then root.AssemblyAngularVelocity = Vector3.new(0, 0, 0) end
		end
	end)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if State.MurderAimbotActive then
			local hasKnife, _ = CheckPlayerInventory(LocalPlayer)
			if hasKnife then
				if _G.Celestial.GameMode == "MM2" and State.MurdererName == LocalPlayer.Name then
					task.defer(function() AimThrowAtTarget() end)
				elseif _G.Celestial.GameMode == "DUELS" then
					task.defer(function() AimThrowAtTarget() end)
				end
			end
		end
	end
end)

-- ====================================================================
-- MODIFIERS AND FLY
-- ====================================================================

local bg, bv = nil, nil

local function ToggleFly(active)
	State.FlyActive = active
	local ctx = AntiFlingQuantum.SelfActionContext
	if ctx then ctx.LastFlyToggle = tick() end
	local root, hum = GetRoot(), GetHumanoid()
	if active and root then
		if bg then bg:Destroy() end
		if bv then bv:Destroy() end
		bg = Instance.new("BodyGyro")
		bg.MaxTorque = Vector3.new(99999, 99999, 99999)
		bg.P = 9000
		bg.Parent = root
		bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(99999, 99999, 99999)
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.Parent = root
		if hum then hum.PlatformStand = true end
		_G.Celestial.ConnectionFly = RunService.RenderStepped:Connect(function()
			if not State.FlyActive or not root or not root.Parent or not hum or hum.Health <= 0 then
				if bg then bg:Destroy() end
				if bv then bv:Destroy() end
				if hum then hum.PlatformStand = false end
				if _G.Celestial.ConnectionFly then _G.Celestial.ConnectionFly:Disconnect() end
				return
			end
			bg.CFrame = Camera.CFrame
			local moveDir = hum.MoveDirection
			if moveDir.Magnitude > 0 then
				local camSpaceDir = Camera.CFrame:VectorToObjectSpace(moveDir)
				bv.Velocity = (Camera.CFrame.LookVector * -camSpaceDir.Z + Camera.CFrame.RightVector * camSpaceDir.X) * State.FlySpeed
			else
				bv.Velocity = Vector3.new(0, 0.1, 0)
			end
		end)
	else
		if bg then bg:Destroy() end
		if bv then bv:Destroy() end
		if hum then hum.PlatformStand = false end
		if _G.Celestial.ConnectionFly then _G.Celestial.ConnectionFly:Disconnect() end
	end
end

local _lastWalkSpeed, _lastJumpPower = nil, nil
local _noclipActive = false

local function ApplyNoClipImmediate()
	local char = GetCharacter()
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") and part.CanCollide then
			part.CanCollide = false
		end
	end
end

_G.Celestial.ConnectionNoClip = RunService.Heartbeat:Connect(function()
	local now = tick()
	if State.NoClipActive then
		if now - (_G.Celestial.LastNoClipCheck or 0) >= 0.25 then
			_G.Celestial.LastNoClipCheck = now
			ApplyNoClipImmediate()
		end
		_noclipActive = true
	elseif _noclipActive then
		_noclipActive = false
		local char = GetCharacter()
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "Head" then
					part.CanCollide = true
				end
			end
		end
	end
end)

_G.Celestial.ConnectionPhysModifiers = RunService.Heartbeat:Connect(function()
	pcall(function()
		local hum = GetHumanoid()
		if hum then
			if State.WalkSpeed ~= _lastWalkSpeed then
				hum.WalkSpeed = State.WalkSpeed
				_lastWalkSpeed = State.WalkSpeed
			end
			if State.JumpPower ~= _lastJumpPower then
				hum.JumpPower = State.JumpPower
				_lastJumpPower = State.JumpPower
			end
		end
	end)
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	char.DescendantAdded:Connect(function(obj)
		if obj:IsA("BasePart") and State.NoClipActive then
			task.defer(function()
				if obj and obj.Parent then obj.CanCollide = false end
			end)
		end
	end)
end)

UserInputService.JumpRequest:Connect(function()
	local root = GetRoot()
	local hum = GetHumanoid()
	if not root or not hum then return end
	AntiFlingQuantum.SelfActionContext.LastJumpAt = tick()
	if State.WallJumpActive and not State.InfiniteJumpActive then
		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {GetCharacter()}
		rayParams.FilterType = Enum.RaycastFilterType.Exclude
		local dirs = {root.CFrame.LookVector, -root.CFrame.LookVector, root.CFrame.RightVector, -root.CFrame.RightVector}
		for _, dir in ipairs(dirs) do
			local hit = Workspace:Raycast(root.Position, dir * 3, rayParams)
			if hit then
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
				local v = root.AssemblyLinearVelocity
				root.AssemblyLinearVelocity = Vector3.new(v.X, math.max(v.Y, 50), v.Z)
				break
			end
		end
	end
	if State.InfiniteJumpActive then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

_G.Celestial.LastBombBoost = 0
_G.Celestial.ConnectionBombBoost = Workspace.DescendantAdded:Connect(function(obj)
	if not obj:IsA("Explosion") then return end
	if not State.BombBoostActive then return end
	local now = tick()
	if now - (_G.Celestial.LastBombBoost or 0) < 1.5 then return end
	local root, hum = GetRoot(), GetHumanoid()
	if not root or not hum or hum.Health <= 0 then return end
	if (obj.Position - root.Position).Magnitude > 25 then return end
	_G.Celestial.LastBombBoost = now
	hum:ChangeState(Enum.HumanoidStateType.Jumping)
	local look = Camera.CFrame.LookVector
	look = Vector3.new(look.X, 0, look.Z)
	if look.Magnitude > 0.01 then look = look.Unit else look = Vector3.zero end
	root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + Vector3.new(0, State.BoostPower, 0) + (look * (State.BoostPower * 0.5))
end)

-- ====================================================================
-- FLING ENGINE
-- ====================================================================

_G.Celestial.FlingConnection = nil
_G.Celestial.FlingRestoreConnection = nil
_G.Celestial.FlingReturnCF = nil
_G.Celestial.FlingSessionActive = false
_G.Celestial.FlingRestoreToken = 0
_G.Celestial.FlingGeneration = (_G.Celestial.FlingGeneration or 0) + 1
_G.Celestial.FlingMotor = nil
_G.Celestial.FlingAttachment = nil

local function DisconnectFlingMotor()
	pcall(function() if _G.Celestial.FlingConnection then _G.Celestial.FlingConnection:Disconnect() end end)
	_G.Celestial.FlingConnection = nil
	pcall(function() if _G.Celestial.FlingMotor then _G.Celestial.FlingMotor.Enabled = false; _G.Celestial.FlingMotor:Destroy() end end)
	_G.Celestial.FlingMotor = nil
	pcall(function() if _G.Celestial.FlingForce then _G.Celestial.FlingForce.Enabled = false; _G.Celestial.FlingForce:Destroy() end end)
	_G.Celestial.FlingForce = nil
	pcall(function() if _G.Celestial.FlingForceAttachment then _G.Celestial.FlingForceAttachment:Destroy() end end)
	_G.Celestial.FlingForceAttachment = nil
	pcall(function() if _G.Celestial.FlingCameraConnection then _G.Celestial.FlingCameraConnection:Disconnect() end end)
	_G.Celestial.FlingCameraConnection = nil
	pcall(function()
		local cam = Workspace.CurrentCamera
		local state = _G.Celestial.FlingCameraState
		if cam and state then
			if state.CameraType then cam.CameraType = state.CameraType end
			if state.CameraSubject and state.CameraSubject.Parent then cam.CameraSubject = state.CameraSubject end
			if state.CFrame then cam.CFrame = state.CFrame end
			if state.Focus then cam.Focus = state.Focus end
		end
	end)
	_G.Celestial.FlingCameraState = nil
	pcall(function() if _G.Celestial.FlingAttachment then _G.Celestial.FlingAttachment:Destroy() end end)
	_G.Celestial.FlingAttachment = nil
end

local function DisconnectFlingRestore()
	pcall(function() if _G.Celestial.FlingRestoreConnection then _G.Celestial.FlingRestoreConnection:Disconnect() end end)
	_G.Celestial.FlingRestoreConnection = nil
end

local function RestoreFlingPosition(returnCF, root, hum, originalAnchored)
	if not returnCF or not root or not root.Parent or not hum or hum.Health <= 0 then
		_G.Celestial.FlingReturnCF = nil
		_G.Celestial.FlingSessionActive = false
		return
	end
	DisconnectFlingRestore()
	_G.Celestial.FlingRestoreToken = (_G.Celestial.FlingRestoreToken or 0) + 1
	local restoreToken = _G.Celestial.FlingRestoreToken
	local restoreStart = tick()
	local restoreDuration = 0.20
	local finalized = false
	pcall(function()
		hum.PlatformStand = false
		hum.AutoRotate = true
		hum.Sit = false
		if root and root.Parent then
			root.Anchored = true
			root.CFrame = returnCF
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
		end
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	end)
	local function ApplyReturnTransform()
		if not root or not root.Parent or not hum or not hum.Parent or hum.Health <= 0 then return false end
		local character = root.Parent
		pcall(function()
			character:PivotTo(returnCF)
			root.CFrame = returnCF
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
			root.Anchored = true
			hum.PlatformStand = false
			hum.AutoRotate = true
			hum.Sit = false
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		end)
		return true
	end
	local function FinalizeRestore()
		if finalized then return end
		finalized = true
		if _G.Celestial.FlingRestoreToken ~= restoreToken then return end
		pcall(function()
			if root and root.Parent then
				local character = root.Parent
				character:PivotTo(returnCF)
				root.CFrame = returnCF
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
				root.Anchored = originalAnchored == true
			end
			if hum and hum.Parent and hum.Health > 0 then
				hum.PlatformStand = false
				hum.AutoRotate = true
				hum.Sit = false
				hum:ChangeState(Enum.HumanoidStateType.GettingUp)
			end
		end)
		if originalAnchored ~= true then
			task.defer(function()
				for _ = 1, 8 do
					if not root or not root.Parent or not hum or not hum.Parent or hum.Health <= 0 then break end
					pcall(function()
						root.Anchored = false
						root.CFrame = returnCF
						root.AssemblyLinearVelocity = Vector3.zero
						root.AssemblyAngularVelocity = Vector3.zero
						hum.PlatformStand = false
						hum.AutoRotate = true
						hum.Sit = false
						hum:ChangeState(Enum.HumanoidStateType.Running)
					end)
					task.wait(0.025)
				end
			end)
		end
		DisconnectFlingRestore()
		_G.Celestial.FlingReturnCF = nil
		_G.Celestial.FlingSessionActive = false
	end
	_G.Celestial.FlingRestoreConnection = RunService.Heartbeat:Connect(function()
		if _G.Celestial.FlingRestoreToken ~= restoreToken then
			DisconnectFlingRestore()
			return
		end
		if not ApplyReturnTransform() then FinalizeRestore(); return end
		if tick() - restoreStart >= restoreDuration then FinalizeRestore() end
	end)
end

_G.Celestial.StopTorqueFling = function(restoreCharacter)
	_G.Celestial.FlingGeneration = (_G.Celestial.FlingGeneration or 0) + 1
	DisconnectFlingMotor()
	DisconnectFlingRestore()
	State.FlingActive = false
	local r, h = GetRoot(), GetHumanoid()
	local returnCF = _G.Celestial.FlingReturnCF
	pcall(function()
		if r and r.Parent then
			r.AssemblyLinearVelocity = Vector3.zero
			r.AssemblyAngularVelocity = Vector3.zero
		end
		if h and h.Parent and h.Health > 0 then
			h.PlatformStand = false
			h.AutoRotate = true
			h.Sit = false
		end
	end)
	if not restoreCharacter then return end
	if r and r.Parent and h and h.Health > 0 and returnCF then
		RestoreFlingPosition(returnCF, r, h, false)
	else
		pcall(function()
			if r and r.Parent and h and h.Health > 0 then
				r.Anchored = false
				r.AssemblyLinearVelocity = Vector3.zero
				r.AssemblyAngularVelocity = Vector3.zero
				h.PlatformStand = false
				h.AutoRotate = true
				h.Sit = false
				h:ChangeState(Enum.HumanoidStateType.Running)
			end
		end)
		_G.Celestial.FlingReturnCF = nil
		_G.Celestial.FlingSessionActive = false
	end
end

local FLING_CACHE_MAX_BYTES = 16 * 1024 * 1024
local FLING_CACHE_AUTO_RESET_RATIO = 0.80

local FlingEngine = {
	CacheBytes = tonumber(State.FlingCacheBytes) or 0,
	MaxCacheBytes = FLING_CACHE_MAX_BYTES,
	CompletedFlings = tonumber(State.FlingCompletedCount) or 0,
	Entries = {}, ResetBusy = false, CurrentEntry = nil,
	CacheLabel = nil, ResetStatusLabel = nil,
}
_G.Celestial.FlingEngine = FlingEngine

local function FormatTinyKB(kb)
	if kb <= 0 then return "0.00 KB" end
	local decimals
	if kb >= 0.01 then decimals = 2
	elseif kb >= 0.001 then decimals = 3
	elseif kb >= 0.0001 then decimals = 4
	elseif kb >= 0.00001 then decimals = 5
	elseif kb >= 0.000001 then decimals = 6
	else decimals = 8 end
	return string.format("%." .. decimals .. "f KB", kb)
end

local function FormatFlingSize(bytes)
	bytes = math.max(0, tonumber(bytes) or 0)
	if bytes < 1024 then return FormatTinyKB(bytes / 1024)
	elseif bytes < 1024 * 1024 then return string.format("%.2f KB", bytes / 1024)
	elseif bytes < 1024 * 1024 * 1024 then return string.format("%.2f MB", bytes / (1024 * 1024))
	else return string.format("%.2f GB", bytes / (1024 * 1024 * 1024)) end
end

local function FormatFlingCache(bytes)
	bytes = math.max(0, tonumber(bytes) or 0)
	local pct = math.clamp((bytes / FLING_CACHE_MAX_BYTES) * 100, 0, 100)
	local current = FormatFlingSize(bytes)
	return string.format("Fling Engine Cache  %s / 16.00 MB  (%d%%)", current, math.floor(pct + 0.5))
end

local function UpdateFlingCacheUI()
	State.FlingCacheBytes = FlingEngine.CacheBytes
	State.FlingCompletedCount = FlingEngine.CompletedFlings
	if FlingEngine.CacheLabel and FlingEngine.CacheLabel.Parent then
		FlingEngine.CacheLabel.Text = FormatFlingCache(FlingEngine.CacheBytes)
	end
end
_G.Celestial.UpdateFlingCacheUI = UpdateFlingCacheUI

local function SetFlingResetStatus(text)
	if FlingEngine.ResetStatusLabel and FlingEngine.ResetStatusLabel.Parent then
		FlingEngine.ResetStatusLabel.Text = text
	end
end
_G.Celestial.SetFlingResetStatus = SetFlingResetStatus

local function ClearFlingCache()
	table.clear(FlingEngine.Entries)
	FlingEngine.CurrentEntry = nil
	FlingEngine.CacheBytes = 0
	State.FlingCacheBytes = 0
	UpdateFlingCacheUI()
	pcall(function() collectgarbage("collect") end)
end
_G.Celestial.ClearFlingCache = ClearFlingCache

local function AddFlingCacheEntry(targetPlayer, duration, sampleCount, samples)
	local sampleTotal = math.max(0, tonumber(sampleCount) or 0)
	local estimatedBytes = 3072 + (sampleTotal * 160)
	local entry = {
		Player = targetPlayer, Duration = duration, Samples = samples or {},
		SampleCount = sampleTotal, EstimatedBytes = estimatedBytes, Timestamp = tick(),
	}
	FlingEngine.Entries[#FlingEngine.Entries + 1] = entry
	FlingEngine.CompletedFlings += 1
	FlingEngine.CacheBytes = FlingEngine.CacheBytes + estimatedBytes
	while FlingEngine.CacheBytes > FlingEngine.MaxCacheBytes and #FlingEngine.Entries > 0 do
		local removed = table.remove(FlingEngine.Entries, 1)
		FlingEngine.CacheBytes = math.max(0, FlingEngine.CacheBytes - (removed.EstimatedBytes or 0))
	end
	FlingEngine.CurrentEntry = nil
	UpdateFlingCacheUI()
end

local function ResetFlingEngineInternal()
	if FlingEngine.ResetBusy then return false end
	FlingEngine.ResetBusy = true
	if _G.Celestial.FlingResetThread then
		pcall(function() task.cancel(_G.Celestial.FlingResetThread) end)
	end
	_G.Celestial.FlingResetThread = task.spawn(function()
		local startingRatio = math.clamp(FlingEngine.CacheBytes / FlingEngine.MaxCacheBytes, 0, 1)
		local totalDuration = 0.35 + (startingRatio * 1.65)
		SetFlingResetStatus("Re-Starting Fling Engine...")
		pcall(function() _G.Celestial.StopTorqueFling(true) end)
		task.wait(totalDuration * 0.50)
		SetFlingResetStatus("Optimizing Fling Engine and other components...")
		ClearFlingCache()
		pcall(function() collectgarbage("collect") end)
		task.wait(totalDuration * 0.50)
		SetFlingResetStatus("Successfull Reboot and Optimizacion")
		FlingEngine.ResetBusy = false
		_G.Celestial.FlingResetThread = nil
		task.delay(1.75, function()
			if FlingEngine.ResetStatusLabel and FlingEngine.ResetStatusLabel.Parent and not FlingEngine.ResetBusy then
				FlingEngine.ResetStatusLabel.Text = "Ready — Fling Engine optimized"
			end
		end)
	end)
	return true
end
_G.Celestial.ResetFlingEngine = ResetFlingEngineInternal

_G.Celestial.ExecuteTorqueFling = function(targetChar)
	pcall(function() _G.Celestial.StopTorqueFling(false) end)
	local root, hum = GetRoot(), GetHumanoid()
	if not root or not hum or hum.Health <= 0 or not targetChar then return end
	local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
	local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
	if not targetRoot or not targetHum or targetHum.Health <= 0 then return end
	if targetRoot == root then return end
	local returnCF = root.CFrame
	_G.Celestial.FlingReturnCF = returnCF
	_G.Celestial.FlingSessionActive = true
	local generation = _G.Celestial.FlingGeneration or 0
	local targetPlayer = Players:GetPlayerFromCharacter(targetChar)
	if targetPlayer then MarkAsFlungByMe(targetPlayer, 6.0) end
	local originalAnchored = root.Anchored
	local originalCanCollide = root.CanCollide
	local startTime = tick()

	local POWER_MULTIPLIER = 24.0
	local DURATION = 4.00
	local MIN_FLING_TIME = 0.70
	local SPIN_BASE = 9000 * POWER_MULTIPLIER
	local SPIN_SPEED_GAIN = 300 * POWER_MULTIPLIER
	local DIRECT_PUSH_BASE = 220 * POWER_MULTIPLIER
	local TARGET_SPEED_PUSH_GAIN = 110 * POWER_MULTIPLIER
	local UPWARD_PUSH_BASE = 70 * POWER_MULTIPLIER
	local TARGET_VERTICAL_GAIN = 25 * POWER_MULTIPLIER
	local FORCE_BASE = 30000 * POWER_MULTIPLIER
	local FORCE_SPEED_GAIN = 1500 * POWER_MULTIPLIER
	local PULSE_INTERVAL = 0.012
	local PULSE_DELTA_V = 180 * POWER_MULTIPLIER

	local localPingSeconds = 0
	local targetPingSeconds = 0
	pcall(function() localPingSeconds = LocalPlayer:GetNetworkPing() end)
	if type(localPingSeconds) ~= "number" or localPingSeconds < 0 then
		local pingMs = GetPlayerPing()
		localPingSeconds = (type(pingMs) == "number" and pingMs >= 0) and (pingMs / 1000) or 0
	end
	if targetPlayer then pcall(function() targetPingSeconds = targetPlayer:GetNetworkPing() end) end
	localPingSeconds = math.clamp(localPingSeconds, 0, 0.45)
	targetPingSeconds = (type(targetPingSeconds) == "number" and targetPingSeconds >= 0)
		and math.clamp(targetPingSeconds, 0, 0.45) or 0
	local combinedPingSeconds = math.clamp(localPingSeconds + targetPingSeconds, 0, 0.70)
	local pingForceScale = 1 + (combinedPingSeconds * 2.25)

	pcall(function()
		hum.PlatformStand = true
		hum.AutoRotate = false
		hum.Sit = false
		hum:ChangeState(Enum.HumanoidStateType.Physics)
		root.Anchored = false
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		root.CanCollide = true
	end)

	local spinAttachment = Instance.new("Attachment")
	spinAttachment.Name = "__CelestialFlingSpin"
	spinAttachment.Parent = root
	local spinMotor = Instance.new("AngularVelocity")
	spinMotor.Name = "__CelestialFlingMotor"
	spinMotor.Attachment0 = spinAttachment
	spinMotor.RelativeTo = Enum.ActuatorRelativeTo.World
	spinMotor.MaxTorque = 1000000000 * POWER_MULTIPLIER
	spinMotor.AngularVelocity = Vector3.new(0, SPIN_BASE, 0)
	spinMotor.Parent = root
	local forceAttachment = Instance.new("Attachment")
	forceAttachment.Name = "__CelestialFlingForce"
	forceAttachment.Parent = root
	local forceMotor = Instance.new("VectorForce")
	forceMotor.Name = "__CelestialFlingVectorForce"
	forceMotor.Attachment0 = forceAttachment
	forceMotor.RelativeTo = Enum.ActuatorRelativeTo.World
	forceMotor.ApplyAtCenterOfMass = true
	forceMotor.Force = Vector3.zero
	forceMotor.Parent = root

	pcall(function()
		local mass = math.max(root.AssemblyMass, 1)
		local launchDirection = -SafeVector(targetRoot.AssemblyLinearVelocity)
		if launchDirection.Magnitude < 0.05 then launchDirection = targetRoot.CFrame.LookVector
		else launchDirection = launchDirection.Unit end
		root:ApplyImpulse((launchDirection * (mass * 2200)) + Vector3.new(0, mass * 900, 0))
		root:ApplyAngularImpulse(Vector3.new(0, mass * 8500, 0))
	end)

	_G.Celestial.FlingAttachment = spinAttachment
	_G.Celestial.FlingMotor = spinMotor
	_G.Celestial.FlingForceAttachment = forceAttachment
	_G.Celestial.FlingForce = forceMotor

	local camera = Workspace.CurrentCamera or Camera
	local cameraConnection
	if camera then
		local cameraState = {CameraType = camera.CameraType, CameraSubject = camera.CameraSubject, CFrame = camera.CFrame, Focus = camera.Focus}
		_G.Celestial.FlingCameraState = cameraState
		local cameraOffset = camera.CFrame.Position - root.Position
		local cameraRotation = camera.CFrame - camera.CFrame.Position
		pcall(function() camera.CameraType = Enum.CameraType.Scriptable end)
		cameraConnection = RunService.RenderStepped:Connect(function()
			if generation ~= (_G.Celestial.FlingGeneration or 0) or not root or not root.Parent then
				pcall(function() if cameraConnection then cameraConnection:Disconnect() end end)
				return
			end
			pcall(function()
				camera.CFrame = CFrame.new(root.Position + cameraOffset) * cameraRotation
				camera.Focus = CFrame.new(root.Position)
			end)
		end)
		_G.Celestial.FlingCameraConnection = cameraConnection
	end

	local connectionFling
	local lastPulse = 0
	local lastCacheSample = 0
	local sampleCount = 0
	local samples = {}
	local initialTargetPosition = targetRoot.Position
	local launchConfirmed = false
	local cacheEntry = {Player = targetPlayer, Start = startTime, SampleCount = 0}
	FlingEngine.CurrentEntry = cacheEntry

	local function CleanupFling()
		if generation ~= (_G.Celestial.FlingGeneration or 0) then return end
		DisconnectFlingMotor()
		if _G.Celestial.FlingForceAttachment then
			pcall(function() _G.Celestial.FlingForceAttachment:Destroy() end)
		end
		_G.Celestial.FlingForceAttachment = nil
		pcall(function()
			root.CanCollide = originalCanCollide
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
		end)
		State.FlingActive = false
		AddFlingCacheEntry(targetPlayer, tick() - startTime, sampleCount, samples)
		RestoreFlingPosition(returnCF, root, hum, originalAnchored)
		if State.FlingAutoResetOptimize and not FlingEngine.ResetBusy
			and (FlingEngine.CacheBytes / FlingEngine.MaxCacheBytes) >= FLING_CACHE_AUTO_RESET_RATIO then
			task.defer(function() ResetFlingEngineInternal() end)
		end
	end

	State.FlingActive = true
	connectionFling = RunService.Heartbeat:Connect(function(dt)
		if generation ~= (_G.Celestial.FlingGeneration or 0) then
			pcall(function() if connectionFling then connectionFling:Disconnect() end end)
			return
		end
		local elapsed = tick() - startTime
		local targetNowPosition = targetRoot and targetRoot.Parent and targetRoot.Position or nil
		local targetVelocityNow = targetRoot and targetRoot.Parent
			and SafeVector(targetRoot.AssemblyLinearVelocity) or Vector3.zero
		local targetDisplacement = (targetNowPosition and initialTargetPosition)
			and (targetNowPosition - initialTargetPosition).Magnitude or 0
		if targetDisplacement >= 10 or targetVelocityNow.Magnitude >= 70 then launchConfirmed = true end
		if not State.FlingActive
			or (elapsed >= MIN_FLING_TIME and launchConfirmed)
			or elapsed >= DURATION
			or not targetRoot or not targetRoot.Parent
			or not root or not root.Parent
			or not hum.Parent or not targetHum.Parent
			or hum.Health <= 0 or targetHum.Health <= 0 then
			CleanupFling()
			return
		end
		local now = tick()
		local targetVelocity = SafeVector(targetRoot.AssemblyLinearVelocity)
		local targetSpeed = targetVelocity.Magnitude
		local contactCF = targetRoot.CFrame
		local contactPosition = targetRoot.Position
		local resistanceFactor = math.max(0, elapsed - 0.12)
		local lackOfLaunch = math.max(0, 10 - targetDisplacement)
		local timeEscalation = 1 + (elapsed * 6.0)
		local resistanceEscalation = 1 + (resistanceFactor * resistanceFactor * 11.0) + (lackOfLaunch * 0.55)
		local motionEscalation = 1 + (math.max(0, 70 - targetSpeed) * 0.08)
		local launchEscalation = timeEscalation * resistanceEscalation * motionEscalation
		local speedBoost = (targetSpeed + (launchConfirmed and 0 or 12)) * launchEscalation
		local spinRate = (SPIN_BASE + (speedBoost * SPIN_SPEED_GAIN * pingForceScale)) * launchEscalation
		local movementContribution = speedBoost * TARGET_SPEED_PUSH_GAIN * pingForceScale * launchEscalation
		local forwardPush = DIRECT_PUSH_BASE + movementContribution
		local upwardPush = (UPWARD_PUSH_BASE + (math.abs(targetVelocity.Y) * TARGET_VERTICAL_GAIN * pingForceScale)) * launchEscalation
		local awayVector = -SafeVector(targetVelocity)
		if awayVector.Magnitude < 0.05 then awayVector = Vector3.new(0, 0, -1)
		else awayVector = awayVector.Unit end
		pcall(function() root.CFrame = contactCF end)
		pcall(function()
			if _G.Celestial.FlingMotor and _G.Celestial.FlingMotor.Parent then
				_G.Celestial.FlingMotor.AngularVelocity = Vector3.new(0, spinRate, 0)
			end
		end)
		local pushVector = (awayVector * forwardPush)
			+ Vector3.new(0, upwardPush + math.max(0, targetVelocity.Y) * 3, 0)
			+ (targetVelocity * (0.55 * pingForceScale))
		local forceMagnitude = (FORCE_BASE + (speedBoost * FORCE_SPEED_GAIN * pingForceScale)) * launchEscalation
		pcall(function()
			if _G.Celestial.FlingForce and _G.Celestial.FlingForce.Parent then
				local pushMagnitude = pushVector.Magnitude
				if pushMagnitude >= 0.05 then
					_G.Celestial.FlingForce.Force = pushVector.Unit * math.max(forceMagnitude, 0) * math.max(root.AssemblyMass, 1)
				else
					_G.Celestial.FlingForce.Force = Vector3.zero
				end
			end
		end)
		if now - lastPulse >= PULSE_INTERVAL then
			lastPulse = now
			pcall(function()
				local mass = math.max(root.AssemblyMass, 1)
				local deltaV = (PULSE_DELTA_V + (speedBoost * 0.90 * POWER_MULTIPLIER * pingForceScale)) * launchEscalation
				root:ApplyImpulse(awayVector * mass * deltaV)
			end)
		end
		if now - lastCacheSample >= 0.08 then
			lastCacheSample = now
			sampleCount += 1
			samples[sampleCount] = {t = now - startTime, p = targetRoot.Position, v = targetVelocity, d = contactPosition}
			cacheEntry.SampleCount = sampleCount
			cacheEntry.Samples = samples
		end
	end)
	_G.Celestial.FlingConnection = connectionFling
end

local function GetActiveSheriffOrHeroPlayer()
	local heroPlr = State.HeroName ~= "" and Players:FindFirstChild(State.HeroName) or nil
	if heroPlr and GetHumanoid(heroPlr) and GetHumanoid(heroPlr).Health > 0 then return heroPlr end
	local sheriffPlr = State.SheriffName ~= "" and Players:FindFirstChild(State.SheriffName) or nil
	if sheriffPlr and GetHumanoid(sheriffPlr) and GetHumanoid(sheriffPlr).Health > 0 then return sheriffPlr end
	return nil
end

-- ====================================================================
-- GAME DETECTION INITIALIZATION + DEFERRED UI LOADING
-- ====================================================================

local scanGui = ShowScanningGui()
local scanStartTime = tick()
local minScanTime = 5.0
local maxScanTime = 7.0

_G.Celestial.GameDetectionThread = task.spawn(function()
	local detectedMode = nil
	while true do
		local elapsed = tick() - scanStartTime
		if elapsed >= minScanTime then
			detectedMode = ScanGameMode()
			if detectedMode then break end
		end
		if elapsed >= maxScanTime then
			detectedMode = detectedMode or "DUELS"
			break
		end
		task.wait(0.25)
	end
	SetCelestialGameMode(detectedMode)
	if scanGui and scanGui.Parent then scanGui:Destroy() end
	_G.Celestial.ScanGui = nil
	print("✨ CELESTIAL FRAMEWORK: Detected game mode -> " .. tostring(detectedMode))
	_G.Celestial.GameDetectionConnection = LocalPlayer.OnTeleport:Connect(function()
		task.wait(1)
		local newMode = ScanGameMode(true)
		if newMode then
			SetCelestialGameMode(newMode)
			print("✨ CELESTIAL FRAMEWORK: Re-detected game mode after teleport -> " .. tostring(newMode))
		end
	end)

	local successUI, errorMsg = pcall(function()

		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = "CelestialMobileHubV19"
		ScreenGui.ResetOnSpawn = false
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		pcall(function()
			if gethui then ScreenGui.Parent = gethui()
			else ScreenGui.Parent = CoreGui end
		end)
		if not ScreenGui.Parent then
			ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
		end
		if game.PlaceId == _G.Celestial.CrosshairAPI.MM2PlaceId then
			ScreenGui.Destroying:Connect(function()
				if _G.Celestial.CrosshairCleanup then pcall(_G.Celestial.CrosshairCleanup) end
			end)
		end

		-- ====================================================================
		-- FPS / PING PERFORMANCE WIDGETS
		-- ====================================================================

		local PerformanceIsland
		local FPSValueLabel, PingValueLabel
		local FPSGradient, PingGradient
		local PerformanceConnection
		local FPSLastPingSample = 0
		local FPSSampleElapsed = 0
		local FPSSampleFrames = 0
		local FPSDisplayValue = 60
		local FPSLastDisplayUpdate = 0
		local FPSSmoothedValue = 60
		local PerformanceIslandTween
		local LastPerformanceIslandMode = "Hidden"

		local function GetPerformanceTextWidth(label, fallbackPerCharacter)
			local width = 0
			pcall(function() width = label.TextBounds.X end)
			if type(width) ~= "number" or width <= 0 then
				width = #tostring(label.Text) * fallbackPerCharacter
			end
			return math.max(1, math.ceil(width))
		end

		local function CreatePerformanceIsland()
			local frame = Instance.new("Frame")
			frame.Name = "PerformanceIsland"
			frame.Size = UDim2.new(0, 58, 0, 140)
			frame.Position = UDim2.new(0, 2, 0.5, -88)
			frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			frame.BackgroundTransparency = 0
			frame.BorderSizePixel = 0
			frame.ZIndex = 125
			frame.Visible = false
			frame.ClipsDescendants = true
			frame.Parent = ScreenGui
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0.5, 0)
			corner.Parent = frame
			return frame
		end

		PerformanceIsland = CreatePerformanceIsland()

		FPSValueLabel = Instance.new("TextLabel")
		FPSValueLabel.Name = "FPSValue"
		FPSValueLabel.Size = UDim2.new(0, 20, 0, 28)
		FPSValueLabel.Position = UDim2.new(0.5, -10, 0, 9)
		FPSValueLabel.BackgroundTransparency = 1
		FPSValueLabel.Text = "60"
		FPSValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		FPSValueLabel.Font = Enum.Font.GothamBold
		FPSValueLabel.TextSize = 17
		FPSValueLabel.TextXAlignment = Enum.TextXAlignment.Center
		FPSValueLabel.TextYAlignment = Enum.TextYAlignment.Center
		FPSValueLabel.Rotation = -90
		FPSValueLabel.ZIndex = 126
		FPSValueLabel.Parent = PerformanceIsland
		FPSGradient = Instance.new("UIGradient")
		FPSGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.0, Color3.fromRGB(248, 248, 250)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 248, 185)),
			ColorSequenceKeypoint.new(1.0, Color3.fromRGB(220, 200, 255))
		})
		FPSGradient.Offset = Vector2.new(-1, 0)
		FPSGradient.Parent = FPSValueLabel

		PingValueLabel = Instance.new("TextLabel")
		PingValueLabel.Name = "PingValue"
		PingValueLabel.Size = UDim2.new(0, 20, 0, 38)
		PingValueLabel.Position = UDim2.new(0.5, -10, 1, -47)
		PingValueLabel.BackgroundTransparency = 1
		PingValueLabel.Text = "0 ms"
		PingValueLabel.TextColor3 = Color3.fromRGB(238, 238, 244)
		PingValueLabel.Font = Enum.Font.GothamBold
		PingValueLabel.TextSize = 16
		PingValueLabel.TextXAlignment = Enum.TextXAlignment.Center
		PingValueLabel.TextYAlignment = Enum.TextYAlignment.Center
		PingValueLabel.Rotation = -90
		PingValueLabel.ZIndex = 126
		PingValueLabel.Parent = PerformanceIsland
		PingGradient = Instance.new("UIGradient")
		PingGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.0, Color3.fromRGB(248, 248, 250)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 248, 185)),
			ColorSequenceKeypoint.new(1.0, Color3.fromRGB(220, 200, 255))
		})
		PingGradient.Offset = Vector2.new(-1, 0)
		PingGradient.Parent = PingValueLabel

		local function UpdatePerformanceIslandLayout()
			local showFPS = State.FPSCounterEnabled == true
			local showPing = State.PingDisplayEnabled == true
			if not showFPS and not showPing then
				PerformanceIsland.Visible = false
				LastPerformanceIslandMode = "Hidden"
				return
			end
			PerformanceIsland.Visible = true
			local mode
			local targetWidth = 58
			local targetHeight = 140
			local fpsWidth = GetPerformanceTextWidth(FPSValueLabel, 9)
			local pingWidth = GetPerformanceTextWidth(PingValueLabel, 8)
			local verticalPadding = 26
			local gap = 16
			if showFPS and showPing then
				mode = "Both"
				targetWidth = 58
				targetHeight = math.max(140, fpsWidth + pingWidth + verticalPadding + gap)
				FPSValueLabel.Size = UDim2.new(0, 20, 0, fpsWidth + 4)
				FPSValueLabel.Position = UDim2.new(0.5, -10, 0, 8)
				PingValueLabel.Size = UDim2.new(0, 20, 0, pingWidth + 4)
				PingValueLabel.Position = UDim2.new(0.5, -10, 1, -(pingWidth + 12))
				FPSValueLabel.Visible = true
				PingValueLabel.Visible = true
			elseif showFPS then
				mode = "FPS"
				targetWidth = 58
				targetHeight = math.max(83, fpsWidth + verticalPadding)
				FPSValueLabel.Size = UDim2.new(0, 20, 0, fpsWidth + 4)
				FPSValueLabel.Position = UDim2.new(0.5, -10, 0.5, -(fpsWidth * 0.5) - 2)
				FPSValueLabel.Visible = true
				PingValueLabel.Visible = false
			else
				mode = "Ping"
				targetWidth = 58
				targetHeight = math.max(83, pingWidth + verticalPadding)
				PingValueLabel.Size = UDim2.new(0, 20, 0, pingWidth + 4)
				PingValueLabel.Position = UDim2.new(0.5, -10, 0.5, -(pingWidth * 0.5) - 2)
				PingValueLabel.Visible = true
				FPSValueLabel.Visible = false
			end
			local sizeKey = mode .. ":" .. tostring(targetWidth) .. ":" .. tostring(targetHeight)
			if LastPerformanceIslandMode == sizeKey then return end
			LastPerformanceIslandMode = sizeKey
			if PerformanceIslandTween then
				pcall(function() PerformanceIslandTween:Cancel() end)
				PerformanceIslandTween = nil
			end
			local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			PerformanceIslandTween = TweenService:Create(PerformanceIsland, tweenInfo, {
				Size = UDim2.new(0, targetWidth, 0, targetHeight),
				Position = UDim2.new(0, 2, 0.5, -(targetHeight * 0.5) - 25.5)
			})
			PerformanceIslandTween:Play()
		end

		local PerformanceOriginals = setmetatable({}, {__mode = "k"})
		local Lighting = game:GetService("Lighting")
		local OriginalGlobalShadows = nil
		local GlobalShadowsSnapshotActive = false

		local function CaptureGlobalShadows()
			if GlobalShadowsSnapshotActive then return end
			pcall(function()
				OriginalGlobalShadows = Lighting.GlobalShadows
				GlobalShadowsSnapshotActive = true
			end)
		end
		local function RestoreGlobalShadowsSnapshot()
			if not GlobalShadowsSnapshotActive then return end
			pcall(function() Lighting.GlobalShadows = OriginalGlobalShadows end)
			OriginalGlobalShadows = nil
			GlobalShadowsSnapshotActive = false
		end

		local function rememberProperty(obj, property, value)
			local data = PerformanceOriginals[obj]
			if not data then data = {}; PerformanceOriginals[obj] = data end
			if not data[property] then data[property] = {Present = true, Value = value} end
		end

		local function setOrRestoreProperty(obj, property, active, newValue)
			if not obj then return end
			if active then
				local ok, current = pcall(function() return obj[property] end)
				if not ok then return end
				rememberProperty(obj, property, current)
				pcall(function() obj[property] = newValue end)
			else
				local data = PerformanceOriginals[obj]
				local original = data and data[property]
				if original and original.Present then
					pcall(function() obj[property] = original.Value end)
					data[property] = nil
				end
			end
		end

		local function ApplyPerformanceOptimization(obj)
			if not obj then return end
			local boost = State.FPSBoostActive
			local disableParticles = boost or State.DisableParticles
			local disableTrails = boost or State.DisableTrails
			local disableShadows = boost or State.DisableShadows
			local disableTextures = boost or State.DisableTextures
			local disableEffects = boost or State.DisableEffects
			local reduceRenderEffects = boost or State.ReduceRenderEffects
			if obj:IsA("ParticleEmitter") then
				setOrRestoreProperty(obj, "Enabled", disableParticles or disableEffects, false)
				local ok, originalRate = pcall(function()
					return PerformanceOriginals[obj] and PerformanceOriginals[obj].Rate and PerformanceOriginals[obj].Rate.Value or obj.Rate
				end)
				if reduceRenderEffects and ok then
					rememberProperty(obj, "Rate", originalRate)
					pcall(function() obj.Rate = math.max(0, originalRate * 0.25) end)
				else
					setOrRestoreProperty(obj, "Rate", false)
				end
			elseif obj:IsA("Trail") or obj:IsA("Beam") then
				setOrRestoreProperty(obj, "Enabled", disableTrails or disableEffects, false)
			elseif obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
				setOrRestoreProperty(obj, "Enabled", disableEffects, false)
			elseif obj:IsA("Light") then
				setOrRestoreProperty(obj, "Shadows", disableShadows, false)
				setOrRestoreProperty(obj, "Enabled", disableEffects, false)
				if reduceRenderEffects then
					local okBrightness, brightness = pcall(function()
						return PerformanceOriginals[obj] and PerformanceOriginals[obj].Brightness and PerformanceOriginals[obj].Brightness.Value or obj.Brightness
					end)
					local okRange, range = pcall(function()
						return PerformanceOriginals[obj] and PerformanceOriginals[obj].Range and PerformanceOriginals[obj].Range.Value or obj.Range
					end)
					if okBrightness then
						rememberProperty(obj, "Brightness", brightness)
						pcall(function() obj.Brightness = brightness * 0.5 end)
					end
					if okRange then
						rememberProperty(obj, "Range", range)
						pcall(function() obj.Range = range * 0.75 end)
					end
				else
					setOrRestoreProperty(obj, "Brightness", false)
					setOrRestoreProperty(obj, "Range", false)
				end
			elseif obj:IsA("PostEffect") then
				setOrRestoreProperty(obj, "Enabled", disableEffects, false)
			elseif obj:IsA("Decal") or obj:IsA("Texture") then
				setOrRestoreProperty(obj, "Transparency", disableTextures, 1)
			elseif obj:IsA("MeshPart") then
				setOrRestoreProperty(obj, "TextureID", disableTextures, "")
				setOrRestoreProperty(obj, "Material", disableTextures, Enum.Material.SmoothPlastic)
			elseif obj:IsA("SpecialMesh") then
				setOrRestoreProperty(obj, "TextureId", disableTextures, "")
			elseif obj:IsA("BasePart") then
				setOrRestoreProperty(obj, "CastShadow", disableShadows, false)
				setOrRestoreProperty(obj, "Material", disableTextures, Enum.Material.SmoothPlastic)
			end
		end

		local function RestoreAllPerformanceOptimizations()
			for obj, data in pairs(PerformanceOriginals) do
				if obj and data then
					for property, original in pairs(data) do
						if original and original.Present then
							pcall(function() obj[property] = original.Value end)
						end
					end
				end
			end
			table.clear(PerformanceOriginals)
			RestoreGlobalShadowsSnapshot()
		end

		local function ApplyAllPerformanceOptimizations()
			local anyOptimization = State.FPSBoostActive or State.DisableParticles or State.DisableTrails
				or State.DisableShadows or State.DisableTextures or State.DisableEffects or State.ReduceRenderEffects
			if anyOptimization then
				if State.DisableShadows or State.FPSBoostActive then CaptureGlobalShadows() end
				for _, obj in ipairs(Workspace:GetDescendants()) do
					ApplyPerformanceOptimization(obj)
				end
				pcall(function()
					if State.DisableShadows or State.FPSBoostActive then Lighting.GlobalShadows = false end
				end)
			else
				RestoreAllPerformanceOptimizations()
			end
		end

		local oldRestore = _G.Celestial.RestoreFPSOptimizations
		_G.Celestial.RestoreFPSOptimizations = function()
			if oldRestore then pcall(oldRestore) end
			RestoreAllPerformanceOptimizations()
		end

		PerformanceConnection = RunService.RenderStepped:Connect(function(deltaTime)
			if not ScreenGui.Parent then
				if PerformanceConnection then PerformanceConnection:Disconnect(); PerformanceConnection = nil end
				if _G.Celestial.ConnectionPerformanceDescendantAdded then
					pcall(function() _G.Celestial.ConnectionPerformanceDescendantAdded:Disconnect() end)
					_G.Celestial.ConnectionPerformanceDescendantAdded = nil
				end
				return
			end
			local now = tick()
			if State.FPSCounterEnabled then
				if type(deltaTime) == "number" and deltaTime > 0 then FPSSampleElapsed += deltaTime end
				FPSSampleFrames += 1
				if FPSSampleElapsed >= 0.12 then
					local measuredFPS = FPSSampleFrames / math.max(FPSSampleElapsed, 0.001)
					measuredFPS = math.clamp(measuredFPS, 1, 1000)
					FPSSmoothedValue = FPSSmoothedValue + ((measuredFPS - FPSSmoothedValue) * 0.28)
					if now - FPSLastDisplayUpdate >= 0.16 then
						FPSDisplayValue = math.floor(FPSSmoothedValue + 0.5)
						FPSDisplayValue = math.clamp(FPSDisplayValue, 1, 1000)
						FPSValueLabel.Text = tostring(FPSDisplayValue)
						FPSLastDisplayUpdate = now
					end
					FPSSampleElapsed = 0
					FPSSampleFrames = 0
				end
			else
				FPSSampleElapsed = 0
				FPSSampleFrames = 0
				FPSDisplayValue = 60
			end
			if State.PingDisplayEnabled and now - FPSLastPingSample >= 0.20 then
				FPSLastPingSample = now
				local pingMs
				local ok, pingSeconds = pcall(function() return LocalPlayer:GetNetworkPing() end)
				if ok and type(pingSeconds) == "number" and pingSeconds >= 0 then pingMs = pingSeconds * 1000
				else pingMs = GetPlayerPing() end
				if type(pingMs) == "number" and pingMs >= 0 then
					PingValueLabel.Text = string.format("%d ms", math.floor(pingMs + 0.5))
				end
			end
			UpdatePerformanceIslandLayout()
			local sweep = ((now * 0.25) % 2) - 1
			FPSGradient.Offset = Vector2.new(sweep, 0)
			PingGradient.Offset = Vector2.new(sweep, 0)
		end)

		_G.Celestial.ConnectionPerformanceWidgets = PerformanceConnection
		UpdatePerformanceIslandLayout()

		_G.Celestial.PerformanceApply = ApplyAllPerformanceOptimizations
		_G.Celestial.ConnectionPerformanceDescendantAdded = Workspace.DescendantAdded:Connect(function(obj)
			if State.FPSBoostActive or State.DisableParticles or State.DisableTrails
				or State.DisableShadows or State.DisableTextures or State.DisableEffects or State.ReduceRenderEffects then
				ApplyPerformanceOptimization(obj)
			end
		end)

		pcall(function()
			if State.DisableShadows or State.FPSBoostActive then
				Lighting.GlobalShadows = false
			elseif OriginalGlobalShadows ~= nil then
				Lighting.GlobalShadows = OriginalGlobalShadows
			end
		end)

		-- ====================================================================
		-- DANGEROMETER
		-- ====================================================================

		local DangerometerFrame = Instance.new("Frame")
		DangerometerFrame.Name = "DangerometerWidget"
		DangerometerFrame.Size = UDim2.new(0, 180, 0, 56)
		DangerometerFrame.Position = UDim2.new(0.5, -90, 0.82, 0)
		DangerometerFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
		DangerometerFrame.BackgroundTransparency = 0.35
		DangerometerFrame.BorderSizePixel = 0
		DangerometerFrame.Visible = false
		DangerometerFrame.ZIndex = 120
		DangerometerFrame.Active = true
		DangerometerFrame.Parent = ScreenGui

		local dCorner = Instance.new("UICorner")
		dCorner.CornerRadius = UDim.new(0, 10)
		dCorner.Parent = DangerometerFrame
		local dStroke = Instance.new("UIStroke")
		dStroke.Thickness = 1.5
		dStroke.Parent = DangerometerFrame
		local dStrokeGradient = Instance.new("UIGradient")
		dStrokeGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 150, 255)),
			ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255))
		})
		dStrokeGradient.Parent = dStroke

		local DangerSquaresFrame = Instance.new("Frame")
		DangerSquaresFrame.Name = "DangerSquaresContainer"
		DangerSquaresFrame.Size = UDim2.new(1, -12, 0.48, 0)
		DangerSquaresFrame.Position = UDim2.new(0, 6, 0, 5)
		DangerSquaresFrame.BackgroundTransparency = 1
		DangerSquaresFrame.ZIndex = 121
		DangerSquaresFrame.Parent = DangerometerFrame
		local dSquaresLayout = Instance.new("UIListLayout")
		dSquaresLayout.FillDirection = Enum.FillDirection.Horizontal
		dSquaresLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		dSquaresLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		dSquaresLayout.Padding = UDim.new(0.05, 0)
		dSquaresLayout.Parent = DangerSquaresFrame
		local dangerSquareBoxes = {}
		for i = 1, 5 do
			local sq = Instance.new("Frame")
			sq.Name = "Square" .. i
			sq.Size = UDim2.new(0.15, 0, 0.9, 0)
			sq.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
			sq.BorderSizePixel = 0
			sq.ZIndex = 121
			sq.Parent = DangerSquaresFrame
			local sqAspect = Instance.new("UIAspectRatioConstraint")
			sqAspect.AspectRatio = 1
			sqAspect.AspectType = Enum.AspectType.FitWithinMaxSize
			sqAspect.DominantAxis = Enum.DominantAxis.Height
			sqAspect.Parent = sq
			local sqCorner = Instance.new("UICorner")
			sqCorner.CornerRadius = UDim.new(0.2, 0)
			sqCorner.Parent = sq
			dangerSquareBoxes[i] = sq
		end

		local DangerDistanceLabel = Instance.new("TextLabel")
		DangerDistanceLabel.Size = UDim2.new(1, -12, 0.38, 0)
		DangerDistanceLabel.Position = UDim2.new(0, 6, 0.55, 0)
		DangerDistanceLabel.BackgroundTransparency = 1
		DangerDistanceLabel.Font = Enum.Font.GothamBold
		DangerDistanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		DangerDistanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		DangerDistanceLabel.TextStrokeTransparency = 0
		DangerDistanceLabel.TextScaled = true
		DangerDistanceLabel.Text = "No murder"
		DangerDistanceLabel.ZIndex = 121
		DangerDistanceLabel.Parent = DangerometerFrame
		local dTextSizeConstraint = Instance.new("UITextSizeConstraint")
		dTextSizeConstraint.MaxTextSize = 14
		dTextSizeConstraint.MinTextSize = 8
		dTextSizeConstraint.Parent = DangerDistanceLabel

		local DangerMurderLabel = Instance.new("TextLabel")
		DangerMurderLabel.Name = "DangerMurderLabel"
		DangerMurderLabel.Size = UDim2.new(1, -12, 0.28, 0)
		DangerMurderLabel.Position = UDim2.new(0, 6, 0.72, 0)
		DangerMurderLabel.BackgroundTransparency = 1
		DangerMurderLabel.Font = Enum.Font.GothamBold
		DangerMurderLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
		DangerMurderLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		DangerMurderLabel.TextStrokeTransparency = 0
		DangerMurderLabel.TextScaled = true
		DangerMurderLabel.Text = "You are the murder!"
		DangerMurderLabel.Visible = false
		DangerMurderLabel.ZIndex = 121
		DangerMurderLabel.Parent = DangerometerFrame

		local DangerResizeBtn = Instance.new("TextButton")
		DangerResizeBtn.Name = "DangerResizeControl"
		DangerResizeBtn.Size = UDim2.new(0, 18, 0, 18)
		DangerResizeBtn.Position = UDim2.new(1, -18, 1, -18)
		DangerResizeBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 220)
		DangerResizeBtn.BackgroundTransparency = 0.4
		DangerResizeBtn.Text = "◢"
		DangerResizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		DangerResizeBtn.TextSize = 9
		DangerResizeBtn.ZIndex = 122
		DangerResizeBtn.Parent = DangerometerFrame

		local dDragging, dDragStart, dStartPos, activeDTouchId, dHasMoved = nil, nil, nil, nil, false
		local dResizing, dResizeStartPos, dStartSize, activeDResizeInput = nil, nil, nil, nil

		local function IsInputOnResizeBtn(inputPos)
			local btnPos = DangerResizeBtn.AbsolutePosition
			local btnSize = DangerResizeBtn.AbsoluteSize
			return inputPos.X >= btnPos.X and inputPos.X <= (btnPos.X + btnSize.X)
				and inputPos.Y >= btnPos.Y and inputPos.Y <= (btnPos.Y + btnSize.Y)
		end

		DangerometerFrame.InputBegan:Connect(function(input)
			if dResizing then return end
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				if IsInputOnResizeBtn(input.Position) then return end
				if not dDragging then
					dDragging = true
					activeDTouchId = input
					dDragStart = input.Position
					dStartPos = DangerometerFrame.Position
					dHasMoved = false
				end
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dDragging and not dResizing and input == activeDTouchId then
				if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
					local delta = input.Position - dDragStart
					if delta.Magnitude > 6 then dHasMoved = true end
					DangerometerFrame.Position = UDim2.new(
						dStartPos.X.Scale, dStartPos.X.Offset + delta.X,
						dStartPos.Y.Scale, dStartPos.Y.Offset + delta.Y
					)
				end
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if dDragging and input == activeDTouchId then
				dDragging = false
				activeDTouchId = nil
			end
		end)
		DangerResizeBtn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				dResizing = true
				dDragging = false
				activeDResizeInput = input
				dResizeStartPos = input.Position
				dStartSize = DangerometerFrame.AbsoluteSize
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dResizing and input == activeDResizeInput then
				if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
					local delta = input.Position - dResizeStartPos
					local newWidth = math.clamp(dStartSize.X + delta.X, 140, 450)
					local newHeight = math.clamp(dStartSize.Y + delta.Y, 45, 200)
					DangerometerFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
				end
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input == activeDResizeInput then
				dResizing = false
				activeDResizeInput = nil
			end
		end)

		local PowerIndicatorFrame = Instance.new("Frame")
		PowerIndicatorFrame.Name = "PowerDetectorIndicator"
		PowerIndicatorFrame.Size = UDim2.new(0, 72, 0, 48)
		PowerIndicatorFrame.Position = UDim2.new(0, -78, 0.5, -24)
		PowerIndicatorFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
		PowerIndicatorFrame.BackgroundTransparency = 0.25
		PowerIndicatorFrame.BorderSizePixel = 0
		PowerIndicatorFrame.Visible = false
		PowerIndicatorFrame.ZIndex = 119
		PowerIndicatorFrame.Parent = DangerometerFrame
		local powerIndicatorCorner = Instance.new("UICorner")
		powerIndicatorCorner.CornerRadius = UDim.new(0, 8)
		powerIndicatorCorner.Parent = PowerIndicatorFrame

		local PowerIndicatorImage = Instance.new("ImageLabel")
		PowerIndicatorImage.Name = "PowerIndicatorImage"
		PowerIndicatorImage.Size = UDim2.new(0, 28, 0, 28)
		PowerIndicatorImage.Position = UDim2.new(0.5, -14, 0, 3)
		PowerIndicatorImage.BackgroundTransparency = 1
		PowerIndicatorImage.ScaleType = Enum.ScaleType.Fit
		PowerIndicatorImage.Visible = false
		PowerIndicatorImage.ZIndex = 120
		PowerIndicatorImage.Parent = PowerIndicatorFrame
		local PowerIndicatorFallback = Instance.new("TextLabel")
		PowerIndicatorFallback.Name = "PowerIndicatorFallback"
		PowerIndicatorFallback.Size = UDim2.new(0, 34, 0, 28)
		PowerIndicatorFallback.Position = UDim2.new(0.5, -17, 0, 2)
		PowerIndicatorFallback.BackgroundTransparency = 1
		PowerIndicatorFallback.Font = Enum.Font.GothamBold
		PowerIndicatorFallback.TextColor3 = Color3.fromRGB(255, 255, 255)
		PowerIndicatorFallback.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		PowerIndicatorFallback.TextStrokeTransparency = 0
		PowerIndicatorFallback.TextScaled = true
		PowerIndicatorFallback.Visible = false
		PowerIndicatorFallback.ZIndex = 120
		PowerIndicatorFallback.Parent = PowerIndicatorFrame
		local PowerIndicatorStatus = Instance.new("TextLabel")
		PowerIndicatorStatus.Name = "PowerIndicatorStatus"
		PowerIndicatorStatus.Size = UDim2.new(1, -4, 0, 14)
		PowerIndicatorStatus.Position = UDim2.new(0, 2, 1, -16)
		PowerIndicatorStatus.BackgroundTransparency = 1
		PowerIndicatorStatus.Font = Enum.Font.GothamBold
		PowerIndicatorStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
		PowerIndicatorStatus.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		PowerIndicatorStatus.TextStrokeTransparency = 0
		PowerIndicatorStatus.TextScaled = true
		PowerIndicatorStatus.Text = "Unknown"
		PowerIndicatorStatus.ZIndex = 120
		PowerIndicatorStatus.Parent = PowerIndicatorFrame
		local powerIndicatorStatusConstraint = Instance.new("UITextSizeConstraint")
		powerIndicatorStatusConstraint.MaxTextSize = 10
		powerIndicatorStatusConstraint.MinTextSize = 7
		powerIndicatorStatusConstraint.Parent = PowerIndicatorStatus

		local function UpdatePowerIndicator()
			if not State.DangerometerActive then
				PowerIndicatorFrame.Visible = false
				return
			end
			PowerIndicatorFrame.Visible = true
			local currentPower = _G.Celestial.PowerDetector.CurrentPower
			local currentState = _G.Celestial.PowerDetector.CurrentState
			if State.MurdererName == LocalPlayer.Name then
				local ownPower, ownActive = _G.Celestial.ResolveLocalMurderPower()
				if ownPower then
					currentPower = ownPower
					local ownDefinition = POWER_DEFINITIONS[ownPower]
					if ownDefinition and ownDefinition.Passive then
						currentState = "Passive"
					else
						currentState = ownActive and "Active" or "Inactive"
					end
				end
			end
			local function SetFallback(icon, status, bg)
				PowerIndicatorFrame.BackgroundColor3 = bg
				PowerIndicatorImage.Visible = false
				PowerIndicatorFallback.Visible = true
				PowerIndicatorFallback.Text = icon or "❓"
				PowerIndicatorStatus.Text = status
			end
			if not currentPower or currentState == "Unknown" then
				SetFallback("❓", "Unknown", Color3.fromRGB(90, 90, 90))
				return
			end
			local definition = POWER_DEFINITIONS[currentPower]
			if not definition then
				SetFallback("❓", "Unknown", Color3.fromRGB(90, 90, 90))
				return
			end
			if definition.Image and definition.Image ~= "" then
				PowerIndicatorImage.Image = definition.Image
				PowerIndicatorImage.Visible = true
				PowerIndicatorFallback.Visible = false
			else
				PowerIndicatorImage.Visible = false
				PowerIndicatorFallback.Visible = true
				PowerIndicatorFallback.Text = definition.Icon or "❓"
			end
			if definition.Passive then
				PowerIndicatorFrame.BackgroundColor3 = Color3.fromRGB(50, 140, 255)
				PowerIndicatorStatus.Text = "Passive"
			elseif currentState == "Active" then
				PowerIndicatorFrame.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
				PowerIndicatorStatus.Text = "Active"
			else
				PowerIndicatorFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				PowerIndicatorStatus.Text = "Inactive"
			end
		end

		local lastPowerDetection = 0
		_G.Celestial.ConnectionPowerDetector = RunService.Heartbeat:Connect(function()
			local now = tick()
			local detectorInterval = 0.08
			if _G.Celestial.PowerDetector
				and (_G.Celestial.PowerDetector.CurrentPower == "Ghost"
					or _G.Celestial.PowerDetector.CurrentPower == "Sprint") then
				detectorInterval = 0.04
			end
			if now - lastPowerDetection < detectorInterval then return end
			lastPowerDetection = now
			pcall(function()
				State.PowerDetectorActive = true
				UpdatePowerDetectorState()
				UpdatePowerIndicator()
				HandleTrapPowerChange()
			end)
		end)

		task.spawn(function()
			while task.wait(0.15) do
				pcall(function()
					DangerometerFrame.Visible = State.DangerometerActive
					local myRoot = GetRoot()
					local isMeMurderer = (State.MurdererName == LocalPlayer.Name)
					local targetChar = nil
					if isMeMurderer then
						DangerMurderLabel.Visible = true
						DangerDistanceLabel.Visible = false
						for i = 1, 5 do dangerSquareBoxes[i].BackgroundColor3 = Color3.fromRGB(120, 0, 180) end
					else
						DangerMurderLabel.Visible = false
						DangerDistanceLabel.Visible = true
						DangerDistanceLabel.Position = UDim2.new(0, 6, 0.55, 0)
						if State.MurdererName ~= "" then
							local mPlr = Players:FindFirstChild(State.MurdererName)
							if mPlr and mPlr.Character and GetHumanoid(mPlr) and GetHumanoid(mPlr).Health > 0 then
								targetChar = mPlr.Character
							end
						end
						if not targetChar then
							for _, plr in ipairs(Players:GetPlayers()) do
								if plr ~= LocalPlayer then
									local hum = GetHumanoid(plr)
									if plr.Character and hum and hum.Health > 0 then
										local isKnife, _ = CheckPlayerInventory(plr)
										if isKnife then targetChar = plr.Character; break end
									end
								end
							end
						end
						if targetChar and myRoot then
							local mRoot = targetChar:FindFirstChild("HumanoidRootPart")
							if mRoot then
								local dist = math.floor((myRoot.Position - mRoot.Position).Magnitude)
								local activeCount, activeColor = 0, Color3.fromRGB(40, 40, 45)
								if dist <= 15 then activeCount, activeColor = 5, Color3.fromRGB(255, 50, 50)
								elseif dist <= 30 then activeCount, activeColor = 4, Color3.fromRGB(255, 140, 0)
								elseif dist <= 50 then activeCount, activeColor = 3, Color3.fromRGB(255, 220, 0)
								elseif dist <= 80 then activeCount, activeColor = 2, Color3.fromRGB(50, 220, 100)
								elseif dist <= 110 then activeCount, activeColor = 1, Color3.fromRGB(50, 150, 255) end
								for i = 1, 5 do
									dangerSquareBoxes[i].BackgroundColor3 = i <= activeCount and activeColor or Color3.fromRGB(40, 40, 45)
								end
								DangerDistanceLabel.Text = string.format("%d studs", dist)
							else
								for i = 1, 5 do dangerSquareBoxes[i].BackgroundColor3 = Color3.fromRGB(220, 220, 220) end
								DangerDistanceLabel.Text = "No murder"
							end
						else
							for i = 1, 5 do dangerSquareBoxes[i].BackgroundColor3 = Color3.fromRGB(220, 220, 220) end
							DangerDistanceLabel.Text = "No murder"
						end
					end
				end)
			end
		end)

		-- ====================================================================
		-- FLING BUBBLES
		-- ====================================================================

		local FlingMurderBubble = Instance.new("TextButton")
		FlingMurderBubble.Name = "FlingMurderBubble"
		FlingMurderBubble.Size = UDim2.new(0, 56, 0, 56)
		FlingMurderBubble.Position = UDim2.new(0.02, 0, 0.4, 0)
		FlingMurderBubble.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
		FlingMurderBubble.BackgroundTransparency = 0.2
		FlingMurderBubble.Text = "💀"
		FlingMurderBubble.TextSize = 24
		FlingMurderBubble.Visible = false
		FlingMurderBubble.ZIndex = 60
		FlingMurderBubble.Parent = ScreenGui
		local bMCorner = Instance.new("UICorner")
		bMCorner.CornerRadius = UDim.new(1, 0)
		bMCorner.Parent = FlingMurderBubble
		local bMStroke = Instance.new("UIStroke")
		bMStroke.Color = Color3.fromRGB(255, 255, 255)
		bMStroke.Thickness = 2
		bMStroke.Parent = FlingMurderBubble

		local FlingSheriffBubble = Instance.new("TextButton")
		FlingSheriffBubble.Name = "FlingSheriffBubble"
		FlingSheriffBubble.Size = UDim2.new(0, 56, 0, 56)
		FlingSheriffBubble.Position = UDim2.new(0.02, 0, 0.52, 0)
		FlingSheriffBubble.BackgroundColor3 = Color3.fromRGB(50, 140, 255)
		FlingSheriffBubble.BackgroundTransparency = 0.2
		FlingSheriffBubble.Text = "🛡️"
		FlingSheriffBubble.TextSize = 24
		FlingSheriffBubble.Visible = false
		FlingSheriffBubble.ZIndex = 60
		FlingSheriffBubble.Parent = ScreenGui
		local bSCorner = Instance.new("UICorner")
		bSCorner.CornerRadius = UDim.new(1, 0)
		bSCorner.Parent = FlingSheriffBubble
		local bSStroke = Instance.new("UIStroke")
		bSStroke.Color = Color3.fromRGB(255, 255, 255)
		bSStroke.Thickness = 2
		bSStroke.Parent = FlingSheriffBubble

		local function MakeDraggableBubble(btn)
			local dragging, dragInput, dragStart, startPos, hasMoved = nil, nil, nil, nil, false
			btn.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					dragInput = input
					dragStart = input.Position
					startPos = btn.Position
					hasMoved = false
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input == dragInput then
					local delta = input.Position - dragStart
					if delta.Magnitude > 5 then hasMoved = true end
					btn.Position = UDim2.new(
						startPos.X.Scale, startPos.X.Offset + delta.X,
						startPos.Y.Scale, startPos.Y.Offset + delta.Y
					)
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input == dragInput then
					if not hasMoved then
						if btn == FlingMurderBubble then
							local target = State.MurdererName ~= "" and Players:FindFirstChild(State.MurdererName) or nil
							if target and target.Character then _G.Celestial.ExecuteTorqueFling(target.Character) end
						elseif btn == FlingSheriffBubble then
							local target = GetActiveSheriffOrHeroPlayer()
							if target and target.Character then _G.Celestial.ExecuteTorqueFling(target.Character) end
						end
					end
					dragging = false
					dragInput = nil
				end
			end)
		end

		MakeDraggableBubble(FlingMurderBubble)
		MakeDraggableBubble(FlingSheriffBubble)

		_G.Celestial.TeleportToGun = function(btn)
			local root = GetRoot()
			if not root then return end
			local gunDrop = FindDroppedGun()
			if not gunDrop then
				if btn then
					local oldText = btn.Text
					btn.Text = "No gun dropped⚠️"
					task.spawn(function()
						task.wait(1.5)
						if btn and btn.Parent then btn.Text = oldText end
					end)
				end
				return
			end
			local originalCFrame = root.CFrame
			local originalVelocity = root.AssemblyLinearVelocity
			local originalAngular = root.AssemblyAngularVelocity
			local function forceTouchEnabled()
				local char = GetCharacter()
				if char then
					for _, part in ipairs(char:GetDescendants()) do
						if part:IsA("BasePart") then
							pcall(function() part.CanTouch = true end)
						end
					end
				end
			end
			task.spawn(function()
				forceTouchEnabled()
				root.CFrame = gunDrop.CFrame + Vector3.new(0, 1.5, 0)
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
				task.wait(0.2)
				local startTime = tick()
				while tick() - startTime < 1.5 and root.Parent do
					if not gunDrop.Parent then break end
					if firetouchinterest then
						pcall(function() firetouchinterest(root, gunDrop, 0) end)
						task.wait(0.04)
						pcall(function() firetouchinterest(root, gunDrop, 1) end)
					end
					task.wait(0.08)
				end
				if root and root.Parent then
					task.wait(0.1)
					root.CFrame = originalCFrame
					root.AssemblyLinearVelocity = originalVelocity
					root.AssemblyAngularVelocity = originalAngular
				end
				if _G.Celestial.ClearQMAPlayerIsolation then
					pcall(_G.Celestial.ClearQMAPlayerIsolation)
				end
				task.wait(0.05)
				forceTouchEnabled()
			end)
		end

		-- ====================================================================
		-- ROUND TIMER
		-- ====================================================================

		local TimerTextLabel = Instance.new("TextLabel")
		TimerTextLabel.Size = UDim2.new(0, 260, 0, 40)
		TimerTextLabel.Position = UDim2.new(0.5, -130, 0, -10)
		TimerTextLabel.BackgroundTransparency = 1
		TimerTextLabel.Font = Enum.Font.GothamMedium
		TimerTextLabel.TextStrokeTransparency = 0
		TimerTextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		TimerTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TimerTextLabel.TextSize = 20
		TimerTextLabel.Text = ""
		TimerTextLabel.Visible = false
		TimerTextLabel.ZIndex = 100
		TimerTextLabel.Parent = ScreenGui

		local function GetTimerColor(timeLeft)
			if timeLeft <= 30 then return Color3.fromRGB(255, 50, 50)
			elseif timeLeft <= 75 then return Color3.fromRGB(255, 140, 0):Lerp(Color3.fromRGB(255, 50, 50), (75 - timeLeft) / 45)
			elseif timeLeft <= 120 then return Color3.fromRGB(255, 230, 0):Lerp(Color3.fromRGB(255, 140, 0), (120 - timeLeft) / 45)
			else return Color3.fromRGB(0, 160, 70):Lerp(Color3.fromRGB(255, 230, 0), (180 - timeLeft) / 60) end
		end
		local ROUND_DURATION = 180
		local MIN_TIMER_VALUE = 1
		local MAX_TIMER_VALUE = 720

		local function ParseTimerText(raw)
			if raw == nil then return nil end
			raw = tostring(raw):lower()
			raw = raw:gsub("%s+", "")
			raw = raw:gsub("^%s+", ""):gsub("%s+$", "")
			local m, s = raw:match("^(%d+)m(%d+)s$")
			if m and s then
				local total = tonumber(m) * 60 + tonumber(s)
				if total >= MIN_TIMER_VALUE and total <= MAX_TIMER_VALUE then return total end
				return nil
			end
			local cm, cs = raw:match("^(%d+):(%d%d)$")
			if cm and cs then
				local total = tonumber(cm) * 60 + tonumber(cs)
				if total >= MIN_TIMER_VALUE and total <= MAX_TIMER_VALUE then return total end
				return nil
			end
			local sOnly = raw:match("^(%d+)s$")
			if sOnly then
				local total = tonumber(sOnly)
				if total >= MIN_TIMER_VALUE and total <= MAX_TIMER_VALUE then return total end
			end
			return nil
		end

		local function FormatTimerText(seconds)
			seconds = math.max(0, math.floor(tonumber(seconds) or 0))
			return string.format("%dm %ds", math.floor(seconds / 60), seconds % 60)
		end

		local mm2TimerCache = nil
		local mm2TimerCacheScore = -math.huge
		local mm2TimerLastSample = nil
		local mm2TimerLastSampleAt = 0
		local mm2TimerLastDeepScanAt = 0

		local function TimerCandidateScore(obj, root, parsed)
			if not obj or not parsed or not obj.Visible then return -math.huge end
			local score = 0
			local anc = obj
			local depth = 0
			while anc and depth < 12 do
				local n = string.lower(tostring(anc.Name or ""))
				if n:find("round", 1, true) then score += 26 end
				if n:find("timer", 1, true) then score += 34 end
				if n:find("countdown", 1, true) then score += 24 end
				if n:find("clock", 1, true) then score += 14 end
				if n:find("time", 1, true) then score += 10 end
				if n:find("game", 1, true) then score += 6 end
				if n:find("lobby", 1, true) then score += 4 end
				if n:find("status", 1, true) then score += 2 end
				if n:find("cooldown", 1, true) or n:find("ability", 1, true)
					or n:find("shop", 1, true) or n:find("inventory", 1, true)
					or n:find("trade", 1, true) or n:find("vote", 1, true)
					or n:find("quest", 1, true) or n:find("reward", 1, true)
					or n:find("streak", 1, true) then score -= 24 end
				if anc:IsA("GuiObject") and not anc.Visible then return -math.huge end
				anc = anc.Parent
				depth += 1
			end
			local normalized = tostring(obj.Text or ""):lower():gsub("%s+", "")
			if normalized:match("^%d+m%d+s$") then score += 20 end
			if normalized:match("^%d+:%d%d$") then score += 16 end
			if normalized:match("^%d+s$") then score += 5 end
			pcall(function()
				local rootSize = root.AbsoluteSize
				local rootPos = root.AbsolutePosition
				local objPos = obj.AbsolutePosition
				local objCenterX = objPos.X + obj.AbsoluteSize.X * 0.5
				local rootCenterX = rootPos.X + rootSize.X * 0.5
				if rootSize.Y > 0 then
					local relativeY = (objPos.Y - rootPos.Y) / rootSize.Y
					if relativeY <= 0.35 then score += 8 end
					if relativeY <= 0.20 then score += 5 end
				end
				if rootSize.X > 0 and math.abs(objCenterX - rootCenterX) <= rootSize.X * 0.30 then score += 5 end
			end)
			if mm2TimerLastSample and mm2TimerLastSampleAt > 0 and obj == mm2TimerCache then
				local dt = math.max(0.02, tick() - mm2TimerLastSampleAt)
				local delta = mm2TimerLastSample - parsed
				if delta >= 0 and delta <= math.ceil(dt * 3) then score += 12
				elseif delta > 3 then score -= 6 end
			end
			return score
		end

		local function ScanTimerRoot(root)
			if not root then return nil, nil, -math.huge end
			local bestObj, bestParsed, bestScore = nil, nil, -math.huge
			local function evaluate(obj)
				if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then return end
				if not obj.Visible then return end
				local parsed = ParseTimerText(obj.Text)
				if not parsed then return end
				local score = TimerCandidateScore(obj, root, parsed)
				if score > bestScore then bestObj, bestParsed, bestScore = obj, parsed, score end
			end
			evaluate(root)
			for _, obj in ipairs(root:GetDescendants()) do evaluate(obj) end
			return bestObj, bestParsed, bestScore
		end

		local function FindMM2TimerLabel()
			local now = tick()
			if mm2TimerCache and mm2TimerCache.Parent and mm2TimerCache.Visible then
				local parsed = ParseTimerText(mm2TimerCache.Text)
				if parsed and (now - mm2TimerLastDeepScanAt) < 0.5 then
					mm2TimerLastSample = parsed
					mm2TimerLastSampleAt = now
					return mm2TimerCache, parsed
				elseif not parsed then
					mm2TimerCache = nil
					mm2TimerCacheScore = -math.huge
				end
			end
			local pg = LocalPlayer:FindFirstChild("PlayerGui")
			if not pg then return nil, nil end
			local mainGui = pg:FindFirstChild("MainGUI")
			local bestObj, bestParsed, bestScore = nil, nil, -math.huge
			if mainGui then bestObj, bestParsed, bestScore = ScanTimerRoot(mainGui) end
			for _, child in ipairs(pg:GetChildren()) do
				if child:IsA("ScreenGui") and child ~= mainGui then
					local n = string.lower(tostring(child.Name or ""))
					if n:find("main", 1, true) or n:find("game", 1, true) or n:find("round", 1, true)
						or n:find("lobby", 1, true) or n:find("hud", 1, true) then
						local obj, parsed, score = ScanTimerRoot(child)
						if obj and score > bestScore then bestObj, bestParsed, bestScore = obj, parsed, score end
					end
				end
			end
			if not bestObj then
				local obj, parsed, score = ScanTimerRoot(pg)
				if obj and parsed then bestObj, bestParsed, bestScore = obj, parsed, score end
			end
			mm2TimerLastDeepScanAt = now
			if bestObj then
				mm2TimerCache = bestObj
				mm2TimerCacheScore = bestScore
				mm2TimerLastSample = bestParsed
				mm2TimerLastSampleAt = now
				return bestObj, bestParsed
			end
			return nil, nil
		end

		local loadingLabelCache = nil
		local function IsMapLoading()
			if loadingLabelCache and loadingLabelCache.Parent and loadingLabelCache.Visible then return true end
			loadingLabelCache = nil
			local pg = LocalPlayer:FindFirstChild("PlayerGui")
			if not pg then return false end
			local mainGui = pg:FindFirstChild("MainGUI")
			if not mainGui then return false end
			for _, obj in ipairs(mainGui:GetDescendants()) do
				if obj:IsA("TextLabel") and obj.Visible then
					local t = string.lower(tostring(obj.Text or ""))
					if t:find("loading map") or t:find("choosing map") or t:find("map vote") or t:find("voting") then
						loadingLabelCache = obj
						return true
					end
				end
			end
			return false
		end

		local timerState = {
			phase = "Idle", roundStartTime = nil, remaining = nil,
			observedDuration = nil, lastObservedRemaining = nil, lastObservedAt = nil,
			ended = true, waitingTeleportArmed = false,
			waitingHiddenAfterNaturalTeleport = false, lastMapLoadingAt = 0,
			lastRootPosition = nil, lastRootSampleAt = 0,
		}
		_G.Celestial.RoundTimerState = timerState

		task.spawn(function()
			local prevHasRoles = false
			while task.wait(0.1) do
				pcall(function()
					if not State.ShowTimerActive then
						TimerTextLabel.Visible = false
						timerState.waitingTeleportArmed = false
						timerState.waitingHiddenAfterNaturalTeleport = false
						return
					end
					if _G.Celestial.GameMode == "DUELS" then
						TimerTextLabel.Visible = false
						timerState.waitingTeleportArmed = false
						timerState.waitingHiddenAfterNaturalTeleport = false
						return
					end
					local now = tick()
					local mapLoadingNow = IsMapLoading()
					if mapLoadingNow then timerState.lastMapLoadingAt = now end
					local waitingForTurnVisible = (TimerTextLabel.Visible and TimerTextLabel.Text == "Waiting for your turn...")
					if waitingForTurnVisible then timerState.waitingTeleportArmed = true end
					local root = GetRoot()
					if root and root.Parent then
						local previousPosition = timerState.lastRootPosition
						local previousAt = timerState.lastRootSampleAt or 0
						timerState.lastRootPosition = root.Position
						timerState.lastRootSampleAt = now
						if timerState.waitingTeleportArmed
							and timerState.lastMapLoadingAt > 0
							and (now - timerState.lastMapLoadingAt) <= 4.0
							and previousPosition and previousAt > 0 and (now - previousAt) <= 0.35
							and not State.FlingActive and not _G.Celestial.FlingSessionActive then
							local displacement = (root.Position - previousPosition).Magnitude
							if displacement >= 35 then
								timerState.waitingHiddenAfterNaturalTeleport = true
								timerState.waitingTeleportArmed = false
								TimerTextLabel.Visible = false
							end
						end
					end
					local hasRoles = (State.MurdererName ~= "" or State.SheriffName ~= "")
					if hasRoles and not prevHasRoles then
						timerState.waitingHiddenAfterNaturalTeleport = false
						timerState.waitingTeleportArmed = false
						timerState.phase = "Round"
						timerState.roundStartTime = tick()
						timerState.remaining = nil
						timerState.observedDuration = nil
						timerState.lastObservedRemaining = nil
						timerState.lastObservedAt = nil
						timerState.ended = false
					end
					if not hasRoles and prevHasRoles then
						timerState.waitingTeleportArmed = false
						timerState.waitingHiddenAfterNaturalTeleport = false
						timerState.lastRootPosition = nil
						timerState.phase = "Idle"
						timerState.roundStartTime = nil
						timerState.remaining = nil
						timerState.observedDuration = nil
						timerState.lastObservedRemaining = nil
						timerState.lastObservedAt = nil
						timerState.ended = true
					end
					prevHasRoles = hasRoles
					if timerState.phase == "Round" then
						local label, value = FindMM2TimerLabel()
						if value then
							if not timerState.observedDuration then timerState.observedDuration = value end
							timerState.remaining = value
							timerState.lastObservedRemaining = value
							timerState.lastObservedAt = tick()
							timerState.ended = value <= 0
							TimerTextLabel.Visible = true
							TimerTextLabel.Text = FormatTimerText(value)
							TimerTextLabel.TextColor3 = GetTimerColor(value)
						elseif timerState.lastObservedRemaining and timerState.lastObservedAt then
							local elapsedSinceObserved = tick() - timerState.lastObservedAt
							local remaining = math.max(0, timerState.lastObservedRemaining - math.floor(elapsedSinceObserved))
							timerState.remaining = remaining
							timerState.ended = remaining <= 0
							if remaining > 0 then
								TimerTextLabel.Visible = true
								TimerTextLabel.Text = FormatTimerText(remaining)
								TimerTextLabel.TextColor3 = GetTimerColor(remaining)
							else TimerTextLabel.Visible = false end
						elseif timerState.roundStartTime and timerState.observedDuration then
							local elapsed = tick() - timerState.roundStartTime
							local remaining = math.max(0, timerState.observedDuration - math.floor(elapsed))
							timerState.remaining = remaining
							timerState.ended = remaining <= 0
							if remaining > 0 then
								TimerTextLabel.Visible = true
								TimerTextLabel.Text = FormatTimerText(remaining)
								TimerTextLabel.TextColor3 = GetTimerColor(remaining)
							else TimerTextLabel.Visible = false end
						elseif timerState.roundStartTime then
							local elapsed = tick() - timerState.roundStartTime
							local remaining = math.max(0, ROUND_DURATION - math.floor(elapsed))
							timerState.remaining = remaining
							timerState.ended = remaining <= 0
							if remaining > 0 then
								TimerTextLabel.Visible = true
								TimerTextLabel.Text = FormatTimerText(remaining)
								TimerTextLabel.TextColor3 = GetTimerColor(remaining)
							else TimerTextLabel.Visible = false end
						else TimerTextLabel.Visible = false end
					else
						if timerState.waitingHiddenAfterNaturalTeleport then
							TimerTextLabel.Visible = false
						elseif IsMapLoading() then
							TimerTextLabel.Position = UDim2.new(0.5, -130, 0, -10)
							TimerTextLabel.Visible = true
							TimerTextLabel.Text = "Loading Map..."
							TimerTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						elseif #Players:GetPlayers() > 1 then
							TimerTextLabel.Position = UDim2.new(0.5, -130, 0, -10)
							TimerTextLabel.Visible = true
							TimerTextLabel.Text = "Waiting for your turn..."
							TimerTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						else TimerTextLabel.Visible = false end
					end
				end)
			end
		end)

		-- ====================================================================
		-- TARGET MODAL
		-- ====================================================================

		local TargetModal = Instance.new("Frame")
		TargetModal.Name = "TargetModalFrame"
		TargetModal.Size = UDim2.new(0, 208, 0, 218)
		TargetModal.Position = UDim2.new(0.5, -104, 0.5, -109)
		TargetModal.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
		TargetModal.BackgroundTransparency = 0.35
		TargetModal.BorderSizePixel = 0
		TargetModal.Visible = false
		TargetModal.ZIndex = 150
		TargetModal.Active = true
		TargetModal.Parent = ScreenGui
		local modalCorner = Instance.new("UICorner")
		modalCorner.CornerRadius = UDim.new(0, 12)
		modalCorner.Parent = TargetModal

		local ModalHeader = Instance.new("Frame")
		ModalHeader.Size = UDim2.new(1, 0, 0, 36)
		ModalHeader.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
		ModalHeader.BackgroundTransparency = 0.35
		ModalHeader.BorderSizePixel = 0
		ModalHeader.ZIndex = 151
		ModalHeader.Parent = TargetModal
		local modalHeaderCorner = Instance.new("UICorner")
		modalHeaderCorner.CornerRadius = UDim.new(0, 12)
		modalHeaderCorner.Parent = ModalHeader
		local ModalTitle = Instance.new("TextLabel")
		ModalTitle.Size = UDim2.new(1, 0, 1, 0)
		ModalTitle.BackgroundTransparency = 1
		ModalTitle.Text = "🎯 Select Player"
		ModalTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		ModalTitle.Font = Enum.Font.GothamBold
		ModalTitle.TextSize = 13
		ModalTitle.ZIndex = 152
		ModalTitle.Parent = ModalHeader
		local ModalScroll = Instance.new("ScrollingFrame")
		ModalScroll.Size = UDim2.new(1, -12, 1, -44)
		ModalScroll.Position = UDim2.new(0, 6, 0, 40)
		ModalScroll.BackgroundTransparency = 1
		ModalScroll.BorderSizePixel = 0
		ModalScroll.ScrollBarThickness = 3
		ModalScroll.ZIndex = 151
		ModalScroll.Parent = TargetModal
		local ModalLayout = Instance.new("UIListLayout")
		ModalLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ModalLayout.Padding = UDim.new(0, 5)
		ModalLayout.Parent = ModalScroll
		ModalLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			ModalScroll.CanvasSize = UDim2.new(0, 0, 0, ModalLayout.AbsoluteContentSize.Y + 12)
		end)

		local mDragging, mDragStart, mStartPos, mTouchId = nil, nil, nil, nil
		ModalHeader.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				mDragging = true
				mTouchId = input
				mDragStart = input.Position
				mStartPos = TargetModal.Position
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if mDragging and input == mTouchId then
				local delta = input.Position - mDragStart
				TargetModal.Position = UDim2.new(
					mStartPos.X.Scale, mStartPos.X.Offset + delta.X,
					mStartPos.Y.Scale, mStartPos.Y.Offset + delta.Y
				)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input == mTouchId then
				mDragging = false
				mTouchId = nil
			end
		end)

		-- ====================================================================
		-- MAIN WINDOW
		-- ====================================================================

		local MainFrame = Instance.new("Frame")
		MainFrame.Size = State.LastUISize
		MainFrame.Position = UDim2.new(0.5, -240, 0.5, -135)
		MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		MainFrame.BackgroundTransparency = 0.10
		MainFrame.BorderSizePixel = 0
		MainFrame.Active = true
		MainFrame.ClipsDescendants = true
		MainFrame.Parent = ScreenGui

		local MainBackground = Instance.new("ImageLabel")
		MainBackground.Name = "CHTextureBackground"
		MainBackground.Size = UDim2.new(1, 0, 1, 0)
		MainBackground.Position = UDim2.new(0, 0, 0, 0)
		MainBackground.BackgroundTransparency = 1
		MainBackground.Image = "rbxassetid://97205530302812"
		MainBackground.ImageTransparency = 0.05
		MainBackground.ScaleType = Enum.ScaleType.Stretch
		MainBackground.ZIndex = 0
		MainBackground.Active = false
		MainBackground.Parent = MainFrame
		local MainBackgroundCorner = Instance.new("UICorner")
		MainBackgroundCorner.CornerRadius = UDim.new(0, 14)
		MainBackgroundCorner.Parent = MainBackground
		_G.Celestial.MainFrame = MainFrame

		local MainCorner = Instance.new("UICorner")
		MainCorner.CornerRadius = UDim.new(0, 14)
		MainCorner.Parent = MainFrame
		local MainStroke = Instance.new("UIStroke")
		MainStroke.Thickness = 1.5
		MainStroke.Parent = MainFrame
		local StrokeGradient = Instance.new("UIGradient")
		StrokeGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 150, 255)),
			ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255))
		})
		StrokeGradient.Parent = MainStroke

		local DragHeader = Instance.new("Frame")
		DragHeader.Size = UDim2.new(1, 0, 0, 40)
		DragHeader.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		DragHeader.BackgroundTransparency = 0.4
		DragHeader.BorderSizePixel = 0
		DragHeader.Parent = MainFrame
		local HeaderCorner = Instance.new("UICorner")
		HeaderCorner.CornerRadius = UDim.new(0, 14)
		HeaderCorner.Parent = DragHeader

		local TitleGroup = Instance.new("Frame")
		TitleGroup.Name = "CelestialTitleGroup"
		TitleGroup.Size = UDim2.new(0, 280, 1, 0)
		TitleGroup.Position = UDim2.new(0, 6, 0, 0)
		TitleGroup.BackgroundTransparency = 1
		TitleGroup.Parent = DragHeader
		local TitleLayout = Instance.new("UIListLayout")
		TitleLayout.FillDirection = Enum.FillDirection.Horizontal
		TitleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		TitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		TitleLayout.Padding = UDim.new(0, 4)
		TitleLayout.Parent = TitleGroup
		local TitleIcon = Instance.new("ImageLabel")
		TitleIcon.Name = "CelestialTitleIcon"
		TitleIcon.Size = UDim2.new(0, 28.35, 0, 28.35)
		TitleIcon.BackgroundTransparency = 1
		TitleIcon.Image = "rbxassetid://118869628234830"
		TitleIcon.ScaleType = Enum.ScaleType.Fit
		TitleIcon.LayoutOrder = 1
		TitleIcon.Parent = TitleGroup
		local TitleText = Instance.new("TextLabel")
		TitleText.Name = "CelestialTitleText"
		TitleText.Size = UDim2.new(0, 220, 0, 40)
		TitleText.BackgroundTransparency = 1
		TitleText.Text = "CELESTIAL HUB"
		TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
		TitleText.Font = Enum.Font.GothamBold
		TitleText.TextSize = 26
		TitleText.TextXAlignment = Enum.TextXAlignment.Left
		TitleText.TextYAlignment = Enum.TextYAlignment.Center
		TitleText.LayoutOrder = 2
		TitleText.Parent = TitleGroup
		local TitleGradient = Instance.new("UIGradient")
		TitleGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.22, Color3.fromRGB(242, 242, 250)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 220, 255)),
			ColorSequenceKeypoint.new(0.78, Color3.fromRGB(242, 242, 250)),
			ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255))
		})
		TitleGradient.Offset = Vector2.new(1, 0)
		TitleGradient.Parent = TitleText
		task.spawn(function()
			while TitleText.Parent do
				TitleGradient.Offset = Vector2.new(1, 0)
				local sweepLeft = TweenService:Create(TitleGradient, TweenInfo.new(2.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), { Offset = Vector2.new(-1, 0) })
				sweepLeft:Play()
				sweepLeft.Completed:Wait()
				task.wait(0.18)
			end
		end)

		local CloseBtn = Instance.new("TextButton")
		CloseBtn.Size = UDim2.new(0, 26, 0, 26)
		CloseBtn.Position = UDim2.new(1, -34, 0, 7)
		CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
		CloseBtn.BackgroundTransparency = 0.35
		CloseBtn.Text = "✕"
		CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		CloseBtn.Font = Enum.Font.GothamBold
		CloseBtn.TextSize = 11
		CloseBtn.Parent = DragHeader
		local CloseCorner = Instance.new("UICorner")
		CloseCorner.CornerRadius = UDim.new(0, 8)
		CloseCorner.Parent = CloseBtn

		local MinimizeBtn = Instance.new("TextButton")
		MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
		MinimizeBtn.Position = UDim2.new(1, -68, 0, 7)
		MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		MinimizeBtn.BackgroundTransparency = 0.35
		MinimizeBtn.Text = "-"
		MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		MinimizeBtn.Font = Enum.Font.GothamBold
		MinimizeBtn.TextSize = 13
		MinimizeBtn.Parent = DragHeader
		local MinCorner = Instance.new("UICorner")
		MinCorner.CornerRadius = UDim.new(0, 8)
		MinCorner.Parent = MinimizeBtn

		CloseBtn.MouseButton1Click:Connect(function()
			if _G.Celestial.StopCoinEngine then _G.Celestial.StopCoinEngine() end
			AntiFlingClearAllProtection()
			if _G.Celestial.ConnectionAntiFling then _G.Celestial.ConnectionAntiFling:Disconnect(); _G.Celestial.ConnectionAntiFling = nil end
			if _G.Celestial.ConnectionOTI then
				pcall(function() _G.Celestial.ConnectionOTI:Disconnect() end)
				_G.Celestial.ConnectionOTI = nil
			end
			if _G.Celestial.ResizeControlsConnection then
				pcall(function() _G.Celestial.ResizeControlsConnection:Disconnect() end)
				_G.Celestial.ResizeControlsConnection = nil
			end
			ScreenGui:Destroy()
		end)

		local Sidebar = Instance.new("ScrollingFrame")
		Sidebar.Size = UDim2.new(0, 135, 1, -42)
		Sidebar.Position = UDim2.new(0, 0, 0, 40)
		Sidebar.BackgroundTransparency = 1
		Sidebar.BorderSizePixel = 0
		Sidebar.ScrollBarThickness = 2
		Sidebar.Parent = MainFrame
		local SidebarLayout = Instance.new("UIListLayout")
		SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
		SidebarLayout.Padding = UDim.new(0, 4)
		SidebarLayout.Parent = Sidebar
		SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 12)
		end)

		local ContainerHolder = Instance.new("Frame")
		ContainerHolder.Size = UDim2.new(1, -140, 1, -42)
		ContainerHolder.Position = UDim2.new(0, 140, 0, 42)
		ContainerHolder.BackgroundTransparency = 1
		ContainerHolder.ClipsDescendants = true
		ContainerHolder.Parent = MainFrame

		local MinimzedBar = Instance.new("ImageButton")
		MinimzedBar.Name = "CelestialBubble"
		MinimzedBar.Size = UDim2.new(0, 82.39, 0, 82.39)
		MinimzedBar.Position = UDim2.new(0.92, -38, 0.5, -38)
		MinimzedBar.BackgroundTransparency = 1
		MinimzedBar.BorderSizePixel = 0
		MinimzedBar.Image = "rbxassetid://118869628234830"
		MinimzedBar.ImageTransparency = 0
		MinimzedBar.ScaleType = Enum.ScaleType.Fit
		MinimzedBar.Visible = true
		MinimzedBar.ZIndex = 50
		MinimzedBar.Parent = ScreenGui

		local ResizeWidthButton = Instance.new("TextButton")
		ResizeWidthButton.Name = "ResizeDownTouchZone"
		ResizeWidthButton.Size = UDim2.new(0, 58, 0, 22)
		ResizeWidthButton.AnchorPoint = Vector2.new(1, 0)
		ResizeWidthButton.BackgroundTransparency = 1
		ResizeWidthButton.BorderSizePixel = 0
		ResizeWidthButton.Text = ""
		ResizeWidthButton.AutoButtonColor = false
		ResizeWidthButton.ZIndex = 100
		ResizeWidthButton.Parent = ScreenGui

		local ResizeHeightButton = Instance.new("TextButton")
		ResizeHeightButton.Name = "ResizeRightTouchZone"
		ResizeHeightButton.Size = UDim2.new(0, 22, 0, 58)
		ResizeHeightButton.AnchorPoint = Vector2.new(0, 1)
		ResizeHeightButton.BackgroundTransparency = 1
		ResizeHeightButton.BorderSizePixel = 0
		ResizeHeightButton.Text = ""
		ResizeHeightButton.AutoButtonColor = false
		ResizeHeightButton.ZIndex = 100
		ResizeHeightButton.Parent = ScreenGui

		local function UpdateResizeControls()
			if not MainFrame or not MainFrame.Parent then return end
			local pos = MainFrame.AbsolutePosition
			local size = MainFrame.AbsoluteSize
			ResizeWidthButton.Position = UDim2.new(0, pos.X + size.X - 58, 0, pos.Y + size.Y - 22)
			ResizeHeightButton.Position = UDim2.new(0, pos.X + size.X - 22, 0, pos.Y + size.Y - 58)
		end
		UpdateResizeControls()
		_G.Celestial.ResizeControlsConnection = RunService.RenderStepped:Connect(UpdateResizeControls)

		local function UpdateWindowState(mode)
			State.WindowMode = mode
			if mode == "Normal" then
				MainFrame.Visible = true
				MainFrame.Size = State.LastUISize
				Sidebar.Visible = true
				ContainerHolder.Visible = true
				ResizeWidthButton.Visible = true
				ResizeHeightButton.Visible = true
				MinimizeBtn.Text = "-"
				if State.TargetModalWasOpen then
					TargetModal.Visible = true
					State.TargetModalWasOpen = false
				end
			elseif mode == "Minimized90" then
				MainFrame.Visible = true
				MainFrame.Size = UDim2.new(0, MainFrame.AbsoluteSize.X, 0, 40)
				Sidebar.Visible = false
				ContainerHolder.Visible = false
				ResizeWidthButton.Visible = false
				ResizeHeightButton.Visible = false
				MinimizeBtn.Text = "+"
				if TargetModal.Visible then
					State.TargetModalWasOpen = true
					TargetModal.Visible = false
				end
			elseif mode == "Minimized100" then
				MainFrame.Visible = false
				ResizeWidthButton.Visible = false
				ResizeHeightButton.Visible = false
				MinimizeBtn.Text = "+"
				if TargetModal.Visible then
					State.TargetModalWasOpen = true
					TargetModal.Visible = false
				end
			end
		end

		MinimizeBtn.MouseButton1Click:Connect(function()
			if State.WindowMode == "Normal" then UpdateWindowState("Minimized90")
			elseif State.WindowMode == "Minimized90" then UpdateWindowState("Normal")
			elseif State.WindowMode == "Minimized100" then UpdateWindowState("Minimized90") end
		end)

		local minDragging, minDragStart, minStartPos, hasMovedBubble, activeBubbleTouchId = nil, nil, nil, false, nil
		MinimzedBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				if not minDragging then
					minDragging = true
					activeBubbleTouchId = input
					minDragStart = input.Position
					minStartPos = MinimzedBar.Position
					hasMovedBubble = false
				end
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if minDragging and input == activeBubbleTouchId then
				if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
					local delta = input.Position - minDragStart
					if delta.Magnitude > 6 then hasMovedBubble = true end
					MinimzedBar.Position = UDim2.new(
						minStartPos.X.Scale, minStartPos.X.Offset + delta.X,
						minStartPos.Y.Scale, minStartPos.Y.Offset + delta.Y
					)
				end
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if minDragging and input == activeBubbleTouchId then
				if not hasMovedBubble then
					if State.WindowMode == "Minimized100" then
						UpdateWindowState(State.LastPre100Mode or "Normal")
					else
						State.LastPre100Mode = State.WindowMode
						UpdateWindowState("Minimized100")
					end
				end
				minDragging = false
				activeBubbleTouchId = nil
			end
		end)

		local frameDragging, frameDragStart, frameStartPos, activeFrameTouchId = nil, nil, nil, nil
		DragHeader.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				if not frameDragging then
					frameDragging = true
					activeFrameTouchId = input
					frameDragStart = input.Position
					frameStartPos = MainFrame.Position
				end
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if frameDragging and input == activeFrameTouchId then
				if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
					local delta = input.Position - frameDragStart
					MainFrame.Position = UDim2.new(
						frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X,
						frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y
					)
				end
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if frameDragging and input == activeFrameTouchId then
				frameDragging = false
				activeFrameTouchId = nil
			end
		end)

		local resizingAxis, resizeStartPos, startSize, activeResizeInput = nil, nil, nil, nil
		_G.Celestial.SliderDragging = false

		local function BeginResize(axis, input)
			if _G.Celestial.SliderDragging then return end
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				resizingAxis = axis
				activeResizeInput = input
				resizeStartPos = input.Position
				startSize = MainFrame.AbsoluteSize
			end
		end

		ResizeWidthButton.InputBegan:Connect(function(input) BeginResize("Height", input) end)
		ResizeHeightButton.InputBegan:Connect(function(input) BeginResize("Width", input) end)

		UserInputService.InputChanged:Connect(function(input)
			if resizingAxis and input == activeResizeInput then
				if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
					local delta = input.Position - resizeStartPos
					local newWidth = math.clamp(startSize.X + delta.X, 300, 1200)
					local newHeight = math.clamp(startSize.Y + delta.Y, 180, 800)
					if resizingAxis == "Width" then
						MainFrame.Size = UDim2.new(0, newWidth, 0, startSize.Y)
					else
						MainFrame.Size = UDim2.new(0, startSize.X, 0, newHeight)
					end
					if State.WindowMode == "Normal" then State.LastUISize = MainFrame.Size end
					UpdateResizeControls()
				end
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input == activeResizeInput then
				resizingAxis = nil
				activeResizeInput = nil
			end
		end)

		local sections = {}
		_G.Celestial.ToggleButtons = _G.Celestial.ToggleButtons or {}

		local function CreateSection(name)
			local scroll = Instance.new("ScrollingFrame")
			scroll.Size = UDim2.new(1, 0, 1, 0)
			scroll.BackgroundTransparency = 1
			scroll.Visible = false
			scroll.ScrollBarThickness = 3
			scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
			scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
			scroll.Parent = ContainerHolder
			local layout = Instance.new("UIListLayout")
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			layout.Padding = UDim.new(0, 6)
			layout.Parent = scroll
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
			end)
			sections[name] = scroll
			return scroll
		end

		local function AddTabButton(tabName, targetSection, imageId)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -6, 0, 38)
			btn.Position = UDim2.new(0, 3, 0, 0)
			btn.BackgroundColor3 = Color3.fromRGB(2, 2, 4)
			btn.BackgroundTransparency = 0.35
			btn.Text = ""
			btn.AutoButtonColor = false
			btn.Parent = Sidebar
			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0, 8)
			btnCorner.Parent = btn
			if imageId then
				local img = Instance.new("ImageLabel")
				img.Name = "TabImage"
				img.Size = UDim2.new(0, 20.16, 0, 20.16)
				img.Position = UDim2.new(0, 9, 0.5, -10.08)
				img.BackgroundTransparency = 1
				img.Image = "rbxassetid://" .. tostring(imageId)
				img.ScaleType = Enum.ScaleType.Fit
				img.ZIndex = 1
				img.Parent = btn
			end
			local label = Instance.new("TextLabel")
			label.Name = "TabText"
			label.Size = UDim2.new(1, -38, 1, 0)
			label.Position = UDim2.new(0, 32, 0, 0)
			label.BackgroundTransparency = 1
			label.Text = tabName
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.Font = Enum.Font.GothamBold
			label.TextSize = 12
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextYAlignment = Enum.TextYAlignment.Center
			label.ZIndex = 1
			label.Parent = btn
			btn.MouseButton1Click:Connect(function()
				for _, sec in pairs(sections) do sec.Visible = false end
				targetSection.Visible = true
			end)
			return btn
		end

		local function AddCategoryHeader(section, titleText)
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, -8, 0, 24)
			lbl.BackgroundTransparency = 1
			lbl.Text = "  " .. titleText
			lbl.TextColor3 = Color3.fromRGB(200, 150, 255)
			lbl.Font = Enum.Font.GothamBold
			lbl.TextSize = 13
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = section
			return lbl
		end

		local function AddSpacer(section, height)
			local spacer = Instance.new("Frame")
			spacer.Size = UDim2.new(1, 0, 0, height or 4)
			spacer.BackgroundTransparency = 1
			spacer.Parent = section
		end

		local function AddToggleToSection(section, text, defaultState, callback, customActiveColor, customInactiveColor)
			local holder = Instance.new("Frame")
			holder.Size = UDim2.new(1, -8, 0, 36)
			holder.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			holder.BackgroundTransparency = 0.35
			holder.BorderSizePixel = 0
			holder.Parent = section
			local holderCorner = Instance.new("UICorner")
			holderCorner.CornerRadius = UDim.new(0, 8)
			holderCorner.Parent = holder
			local label = Instance.new("TextLabel")
			label.Name = "ToggleLabel"
			label.Size = UDim2.new(1, -78, 1, 0)
			label.Position = UDim2.new(0, 8, 0, 0)
			label.BackgroundTransparency = 1
			label.Text = text
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.Font = Enum.Font.GothamBold
			label.TextSize = 12
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextYAlignment = Enum.TextYAlignment.Center
			label.Parent = holder
			local btn = Instance.new("TextButton")
			btn.Name = "ToggleSwitch"
			btn.Size = UDim2.new(0, 56, 0, 26)
			btn.Position = UDim2.new(1, -64, 0.5, -13)
			btn.BackgroundColor3 = defaultState and Color3.fromRGB(75, 210, 115) or Color3.fromRGB(145, 145, 145)
			btn.BackgroundTransparency = 0
			btn.BorderSizePixel = 0
			btn.Text = ""
			btn.AutoButtonColor = false
			btn.Parent = holder
			local switchCorner = Instance.new("UICorner")
			switchCorner.CornerRadius = UDim.new(1, 0)
			switchCorner.Parent = btn
			local knob = Instance.new("Frame")
			knob.Name = "ToggleKnob"
			knob.Size = UDim2.new(0, 22, 0, 22)
			knob.Position = defaultState and UDim2.new(1, -24, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
			knob.AnchorPoint = Vector2.new(0, 0.5)
			knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			knob.BorderSizePixel = 0
			knob.ZIndex = btn.ZIndex + 1
			knob.Parent = btn
			local knobCorner = Instance.new("UICorner")
			knobCorner.CornerRadius = UDim.new(1, 0)
			knobCorner.Parent = knob
			_G.Celestial.ToggleButtons[text] = btn
			local active = defaultState
			local function setToggleState(newState)
				active = newState
				btn.Text = ""
				btn.BackgroundColor3 = active and Color3.fromRGB(75, 210, 115) or Color3.fromRGB(145, 145, 145)
				knob.Position = active and UDim2.new(1, -24, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
				callback(active)
			end
			btn.MouseButton1Click:Connect(function() setToggleState(not active) end)
			return btn
		end

		local function AddSliderToSection(section, title, desc, min, max, defaultVal, callback, decimals)
			local holder = Instance.new("Frame")
			holder.Size = UDim2.new(1, -8, 0, 48)
			holder.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			holder.BackgroundTransparency = 0.35
			holder.Parent = section
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 8)
			corner.Parent = holder
			local function FormatSliderValue(value)
				if decimals and decimals > 0 then
					local factor = 10 ^ decimals
					return string.format("%." .. decimals .. "f", math.floor(value * factor + 0.5) / factor)
				end
				return tostring(math.floor(value))
			end
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, -16, 0, 18)
			label.Position = UDim2.new(0, 8, 0, 4)
			label.BackgroundTransparency = 1
			label.Text = title .. "  (" .. FormatSliderValue(defaultVal) .. ")"
			label.TextColor3 = Color3.fromRGB(240, 230, 255)
			label.Font = Enum.Font.GothamBold
			label.TextSize = 12
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = holder
			local sliderTrack = Instance.new("Frame")
			sliderTrack.Size = UDim2.new(1, -16, 0, 8)
			sliderTrack.Position = UDim2.new(0, 8, 0, 28)
			sliderTrack.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			sliderTrack.BorderSizePixel = 0
			sliderTrack.Parent = holder
			local trackCorner = Instance.new("UICorner")
			trackCorner.CornerRadius = UDim.new(1, 0)
			trackCorner.Parent = sliderTrack
			local fill = Instance.new("Frame")
			fill.Size = UDim2.new((defaultVal - min) / (max - min), 0, 1, 0)
			fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			fill.BorderSizePixel = 0
			fill.Parent = sliderTrack
			local fillCorner = Instance.new("UICorner")
			fillCorner.CornerRadius = UDim.new(1, 0)
			fillCorner.Parent = fill
			local fillGradient = Instance.new("UIGradient")
			fillGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(192, 192, 200)),
				ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
			})
			fillGradient.Parent = fill
			local hitbox = Instance.new("TextButton")
			hitbox.Size = UDim2.new(1, 20, 1, 20)
			hitbox.Position = UDim2.new(0, -10, 0, -10)
			hitbox.BackgroundTransparency = 1
			hitbox.Text = ""
			hitbox.ZIndex = 5
			hitbox.Parent = sliderTrack
			local draggingSlider, dragInput = nil, nil
			local function UpdateSlider(inputPos)
				local pos = math.clamp((inputPos.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
				local rawVal = min + (max - min) * pos
				local val
				if decimals and decimals > 0 then
					local factor = 10 ^ decimals
					val = math.floor(rawVal * factor + 0.5) / factor
				else
					val = math.floor(rawVal)
				end
				fill.Size = UDim2.new(pos, 0, 1, 0)
				label.Text = title .. "  (" .. FormatSliderValue(val) .. ")"
				callback(val)
			end
			hitbox.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
					draggingSlider = true
					dragInput = input
					_G.Celestial.SliderDragging = true
					UpdateSlider(input.Position)
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if draggingSlider and input == dragInput then
					_G.Celestial.SliderDragging = true
					UpdateSlider(input.Position)
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input == dragInput then
					draggingSlider = false
					dragInput = nil
					_G.Celestial.SliderDragging = false
				end
			end)
		end

		local function AddButtonToSection(section, text, color, callback)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -8, 0, 36)
			btn.BackgroundColor3 = color
			btn.BackgroundTransparency = 0.35
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Text = text
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 12
			btn.Parent = section
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 8)
			corner.Parent = btn
			btn.MouseButton1Click:Connect(function() callback(btn) end)
			return btn
		end

		-- ====================================================================
		-- PLAYER TAB (MOVEMENT)
		-- ====================================================================

		local secPlayer = CreateSection("MOVEMENT")
		AddTabButton("MOVEMENT", secPlayer, 138429150113777)
		AddSliderToSection(secPlayer, "Walk Speed", "Sets your walking speed.", 16, 200, State.WalkSpeed, function(v) State.WalkSpeed = v end)
		AddSliderToSection(secPlayer, "Jump Power", "Sets how high you jump.", 50, 300, State.JumpPower, function(v) State.JumpPower = v end)
		AddToggleToSection(secPlayer, "Fly", State.FlyActive, function(v) ToggleFly(v) end)
		AddSliderToSection(secPlayer, "Fly Speed", "Sets your flying speed.", 10, 450, State.FlySpeed, function(v) State.FlySpeed = v end)
		AddToggleToSection(secPlayer, "Noclip", State.NoClipActive, function(v) State.NoClipActive = v end)
		AddToggleToSection(secPlayer, "Infinite Jump", State.InfiniteJumpActive, function(v) State.InfiniteJumpActive = v end)
		AddToggleToSection(secPlayer, "Wall Jump", State.WallJumpActive, function(v) State.WallJumpActive = v end)
		AddToggleToSection(secPlayer, "Bomb Boost", State.BombBoostActive, function(v) State.BombBoostActive = v end)
		AddSliderToSection(secPlayer, "Boost Power", "How hard the blast throws you.", 50, 600, State.BoostPower, function(v) State.BoostPower = v end)

		-- ====================================================================
		-- FARM TAB
		-- ====================================================================

		local secFarm = CreateSection("AUTO-FARM")
		AddTabButton("AUTO-FARM", secFarm, 74568347443971)
		AddCategoryHeader(secFarm, "Coin Farmer (MM2)")
		AddSpacer(secFarm, 2)
		AddToggleToSection(secFarm, "Auto Farm Coins", State.FarmEnabled, function(v) State.FarmEnabled = v end, Color3.fromRGB(255, 215, 0))
		AddSliderToSection(secFarm, "Tween Speed", "Flight speed towards coins.", 10, 100, State.TweenSpeed, function(v) State.TweenSpeed = v end)

		-- ====================================================================
		-- COMBAT TAB
		-- ====================================================================

		local secCombat = CreateSection("COMBAT")
		AddTabButton("COMBAT", secCombat, 72820016268082)
		AddCategoryHeader(secCombat, "Sheriff Tools (Requires Shiftlock)")
		AddSpacer(secCombat, 2)
		AddToggleToSection(secCombat, "Sheriff Aimbot", State.AimbotActive, function(v) State.AimbotActive = v end, Color3.fromRGB(90, 0, 180))
		AddSliderToSection(secCombat, "Aimbot Smoothness", "Tracking smoothness level.", 5, 50, State.AimbotSmoothness, function(v) State.AimbotSmoothness = v end)
		AddSliderToSection(secCombat, "Aimbot Strength", "Aimbot force & precision (1-10).", 1, 10, State.AimbotStrength, function(v) State.AimbotStrength = v end)
		AddToggleToSection(secCombat, "Stabilization", State.SuperStableActive, function(v) State.SuperStableActive = v end, Color3.fromRGB(150, 100, 225))
		AddSpacer(secCombat, 4)
		AddToggleToSection(secCombat, "Dangerometer", State.DangerometerActive, function(v)
			State.DangerometerActive = v
			DangerometerFrame.Visible = v
			UpdatePowerIndicator()
		end, Color3.fromRGB(180, 50, 180))
		AddSpacer(secCombat, 6)
		AddCategoryHeader(secCombat, "Murderer Tools")
		AddSpacer(secCombat, 2)
		AddToggleToSection(secCombat, "Murder Throw Aimbot", State.MurderAimbotActive, function(v) State.MurderAimbotActive = v end, Color3.fromRGB(180, 40, 40))
		AddToggleToSection(secCombat, "Murder Stab Aimbot", State.MurderStabAimbotActive, function(v) State.MurderStabAimbotActive = v end, Color3.fromRGB(200, 100, 50))
		AddSliderToSection(secCombat, "Stab Smoothness", "Stab turn smoothness (1-150).", 1, 150, State.StabSmoothness, function(v) State.StabSmoothness = v end)
		AddSliderToSection(secCombat, "Stab Prediction Strength", "Stab predictive precision (1-10).", 1, 10, State.StabPredictionStrength, function(v) State.StabPredictionStrength = v end)
		AddSpacer(secCombat, 4)
		local isKillAllBusy = false
		AddButtonToSection(secCombat, "🔪 Kill All (Bring & Kill)", Color3.fromRGB(210, 40, 40), function(btn)
			if isKillAllBusy then return end
			local myRoot = GetRoot()
			if not myRoot then return end
			local hasKnife, _ = CheckPlayerInventory(LocalPlayer)
			if not hasKnife then
				isKillAllBusy = true
				local defaultText = "🔪 Kill All (Bring & Kill)"
				btn.Text = "⚠️ You need to have the Knife!"
				task.spawn(function()
					task.wait(1.5)
					btn.Text = defaultText
					isKillAllBusy = false
				end)
				return
			end
			isKillAllBusy = true
			local spawnedTasks = 0
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and plr.Character then
					local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
					local tHum = GetHumanoid(plr)
					if tRoot and tHum and tHum.Health > 0 then
						spawnedTasks += 1
						task.spawn(function()
							for i = 1, 5 do
								if not tRoot or not tRoot.Parent then break end
								if not myRoot or not myRoot.Parent then break end
								if tHum.Health <= 0 then break end
								pcall(function() tRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -2.5) end)
								task.wait(0.05)
							end
							if tHum and tHum.Health > 0 then
								pcall(function() tHum.Health = 0 end)
							end
						end)
					end
				end
			end
			task.wait(0.4 + spawnedTasks * 0.05)
			task.spawn(function()
				task.wait(0.3)
				if _G.Celestial.Highlights then
					for plr, hl in pairs(_G.Celestial.Highlights) do
						if hl then
							pcall(function() hl.Adornee = nil end)
							pcall(function() hl:Destroy() end)
						end
						_G.Celestial.Highlights[plr] = nil
					end
				end
				if _G.Celestial.ForceRoleScan then _G.Celestial.ForceRoleScan() end
			end)
			task.delay(0.6, function()
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer and plr.Character then
						local hum = plr.Character:FindFirstChildOfClass("Humanoid")
						local root = plr.Character:FindFirstChild("HumanoidRootPart")
						if hum and root and plr.Character.Parent == Workspace then
							pcall(function()
								for _, part in ipairs(plr.Character:GetDescendants()) do
									if part:IsA("BasePart") and part.LocalTransparencyModifier > 0 then
										part.LocalTransparencyModifier = 0
									end
								end
							end)
						end
					end
				end
			end)
			task.wait(0.5)
			isKillAllBusy = false
		end)

		-- ====================================================================
		-- CROSSHAIR SECTION
		-- ====================================================================

		if game.PlaceId == _G.Celestial.CrosshairAPI.MM2PlaceId then
			do
			local secCrosshair = CreateSection("CROSSHAIR")
			AddTabButton("CROSSHAIR", secCrosshair, 110895612761667)
			AddCategoryHeader(secCrosshair, "Custom Shiftlock / Crosshair")

			local crosshairEnableHolder = Instance.new("Frame")
			crosshairEnableHolder.Size = UDim2.new(1, -8, 0, 36)
			crosshairEnableHolder.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			crosshairEnableHolder.BackgroundTransparency = 0.35
			crosshairEnableHolder.BorderSizePixel = 0
			crosshairEnableHolder.Parent = secCrosshair
			local crosshairEnableCorner = Instance.new("UICorner")
			crosshairEnableCorner.CornerRadius = UDim.new(0, 8)
			crosshairEnableCorner.Parent = crosshairEnableHolder
			local crosshairEnableLabel = Instance.new("TextLabel")
			crosshairEnableLabel.Name = "ToggleLabel"
			crosshairEnableLabel.Size = UDim2.new(1, -78, 1, 0)
			crosshairEnableLabel.Position = UDim2.new(0, 8, 0, 0)
			crosshairEnableLabel.BackgroundTransparency = 1
			crosshairEnableLabel.Text = "Enable custom Shiftlock/Crosshair"
			crosshairEnableLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			crosshairEnableLabel.Font = Enum.Font.GothamBold
			crosshairEnableLabel.TextSize = 12
			crosshairEnableLabel.TextXAlignment = Enum.TextXAlignment.Left
			crosshairEnableLabel.TextYAlignment = Enum.TextYAlignment.Center
			crosshairEnableLabel.Parent = crosshairEnableHolder
			local crosshairEnableButton = Instance.new("TextButton")
			crosshairEnableButton.Name = "ToggleSwitch"
			crosshairEnableButton.Size = UDim2.new(0, 56, 0, 26)
			crosshairEnableButton.Position = UDim2.new(1, -64, 0.5, -13)
			crosshairEnableButton.BackgroundColor3 = State.CrosshairEnabled and Color3.fromRGB(75, 210, 115) or Color3.fromRGB(145, 145, 145)
			crosshairEnableButton.BorderSizePixel = 0
			crosshairEnableButton.Text = ""
			crosshairEnableButton.AutoButtonColor = false
			crosshairEnableButton.Parent = crosshairEnableHolder
			local crosshairEnableButtonCorner = Instance.new("UICorner")
			crosshairEnableButtonCorner.CornerRadius = UDim.new(1, 0)
			crosshairEnableButtonCorner.Parent = crosshairEnableButton
			local crosshairEnableKnob = Instance.new("Frame")
			crosshairEnableKnob.Name = "ToggleKnob"
			crosshairEnableKnob.Size = UDim2.new(0, 22, 0, 22)
			crosshairEnableKnob.Position = State.CrosshairEnabled and UDim2.new(1, -24, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
			crosshairEnableKnob.AnchorPoint = Vector2.new(0, 0.5)
			crosshairEnableKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			crosshairEnableKnob.BorderSizePixel = 0
			crosshairEnableKnob.ZIndex = crosshairEnableButton.ZIndex + 1
			crosshairEnableKnob.Parent = crosshairEnableButton
			local crosshairEnableKnobCorner = Instance.new("UICorner")
			crosshairEnableKnobCorner.CornerRadius = UDim.new(1, 0)
			crosshairEnableKnobCorner.Parent = crosshairEnableKnob
			_G.Celestial.ToggleButtons["Enable custom Shiftlock/Crosshair"] = crosshairEnableButton

			local function RefreshCrosshairEnableToggle()
				local enabled = State.CrosshairEnabled == true
				crosshairEnableButton.BackgroundColor3 = enabled and Color3.fromRGB(75, 210, 115) or Color3.fromRGB(145, 145, 145)
				crosshairEnableKnob.Position = enabled and UDim2.new(1, -24, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
			end

			local crosshairAssetBox = Instance.new("TextBox")
			crosshairAssetBox.Name = "CrosshairAssetId"
			crosshairAssetBox.Size = UDim2.new(1, -8, 0, 34)
			crosshairAssetBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			crosshairAssetBox.BackgroundTransparency = 0.25
			crosshairAssetBox.BorderSizePixel = 0
			crosshairAssetBox.PlaceholderText = "Custom Crosshair Image ID (numbers only)"
			crosshairAssetBox.Text = tostring(State.CrosshairAssetId or "")
			crosshairAssetBox.ClearTextOnFocus = false
			crosshairAssetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			crosshairAssetBox.PlaceholderColor3 = Color3.fromRGB(145, 145, 155)
			crosshairAssetBox.Font = Enum.Font.Gotham
			crosshairAssetBox.TextSize = 12
			crosshairAssetBox.Parent = secCrosshair
			local crosshairAssetCorner = Instance.new("UICorner")
			crosshairAssetCorner.CornerRadius = UDim.new(0, 8)
			crosshairAssetCorner.Parent = crosshairAssetBox
			local crosshairAssetPadding = Instance.new("UIPadding")
			crosshairAssetPadding.PaddingLeft = UDim.new(0, 9)
			crosshairAssetPadding.PaddingRight = UDim.new(0, 7)
			crosshairAssetPadding.Parent = crosshairAssetBox

			AddCategoryHeader(secCrosshair, "Preset Crosshairs  •  scroll horizontally")
			local crosshairPresetScroller = Instance.new("ScrollingFrame")
			crosshairPresetScroller.Name = "PresetCrosshairsScroller"
			crosshairPresetScroller.Size = UDim2.new(1, -8, 0, 72)
			crosshairPresetScroller.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			crosshairPresetScroller.BackgroundTransparency = 0.3
			crosshairPresetScroller.BorderSizePixel = 0
			crosshairPresetScroller.Active = true
			crosshairPresetScroller.ScrollingEnabled = true
			crosshairPresetScroller.ScrollingDirection = Enum.ScrollingDirection.X
			crosshairPresetScroller.AutomaticCanvasSize = Enum.AutomaticSize.X
			crosshairPresetScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
			crosshairPresetScroller.ScrollBarThickness = 3
			crosshairPresetScroller.ScrollBarImageColor3 = Color3.fromRGB(200, 150, 255)
			crosshairPresetScroller.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
			crosshairPresetScroller.Parent = secCrosshair
			local crosshairPresetCorner = Instance.new("UICorner")
			crosshairPresetCorner.CornerRadius = UDim.new(0, 8)
			crosshairPresetCorner.Parent = crosshairPresetScroller
			local crosshairPresetPadding = Instance.new("UIPadding")
			crosshairPresetPadding.PaddingLeft = UDim.new(0, 6)
			crosshairPresetPadding.PaddingRight = UDim.new(0, 6)
			crosshairPresetPadding.PaddingTop = UDim.new(0, 5)
			crosshairPresetPadding.PaddingBottom = UDim.new(0, 5)
			crosshairPresetPadding.Parent = crosshairPresetScroller
			local crosshairPresetLayout = Instance.new("UIListLayout")
			crosshairPresetLayout.FillDirection = Enum.FillDirection.Horizontal
			crosshairPresetLayout.SortOrder = Enum.SortOrder.LayoutOrder
			crosshairPresetLayout.Padding = UDim.new(0, 7)
			crosshairPresetLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			crosshairPresetLayout.Parent = crosshairPresetScroller

			local crosshairPresetStrokes = {}
			local function RefreshCrosshairPresetSelection()
				local selectedId = tostring(State.CrosshairAssetId or ""):gsub("%s+", "")
				for index, assetId in ipairs(_G.Celestial.CrosshairAPI.PresetIds) do
					local stroke = crosshairPresetStrokes[index]
					if stroke then
						local selected = selectedId == assetId
						stroke.Color = selected and Color3.fromRGB(205, 190, 255) or Color3.fromRGB(92, 92, 108)
						stroke.Thickness = selected and 2 or 1
						stroke.Transparency = selected and 0 or 0.1
					end
				end
			end

			for index, assetId in ipairs(_G.Celestial.CrosshairAPI.PresetIds) do
				local presetButton = Instance.new("ImageButton")
				presetButton.Name = "PresetCrosshair" .. index
				presetButton.Size = UDim2.new(0, 54, 0, 54)
				presetButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				presetButton.BackgroundTransparency = 0.1
				presetButton.BorderSizePixel = 0
				presetButton.AutoButtonColor = true
				presetButton.Image = "rbxassetid://" .. assetId
				presetButton.ScaleType = Enum.ScaleType.Fit
				presetButton.LayoutOrder = index
				presetButton.Parent = crosshairPresetScroller
				local presetCorner = Instance.new("UICorner")
				presetCorner.CornerRadius = UDim.new(0, 7)
				presetCorner.Parent = presetButton
				local presetStroke = Instance.new("UIStroke")
				presetStroke.Color = Color3.fromRGB(92, 92, 108)
				presetStroke.Thickness = 1
				presetStroke.Transparency = 0.1
				presetStroke.Parent = presetButton
				crosshairPresetStrokes[index] = presetStroke
				presetButton.Activated:Connect(function()
					State.CrosshairAssetId = assetId
					crosshairAssetBox.Text = assetId
					RefreshCrosshairPresetSelection()
					_G.Celestial.CrosshairAPI.ApplyAll()
				end)
			end

			local function RefreshCrosshairSection(exposedCount)
				RefreshCrosshairEnableToggle()
				RefreshCrosshairPresetSelection()
			end
			_G.Celestial.CrosshairRefreshUI = RefreshCrosshairSection

			crosshairEnableButton.Activated:Connect(function()
				State.CrosshairEnabled = not State.CrosshairEnabled
				RefreshCrosshairEnableToggle()
				_G.Celestial.CrosshairAPI.ApplyAll()
			end)

			crosshairAssetBox.FocusLost:Connect(function()
				local raw = tostring(crosshairAssetBox.Text or ""):gsub("%s+", "")
				State.CrosshairAssetId = raw:match("^%d+$") and raw or ""
				_G.Celestial.CrosshairAPI.ApplyAll()
			end)

			AddToggleToSection(secCrosshair, "Crosshair Rotation Animation", State.CrosshairRotationEnabled, function(v)
				State.CrosshairRotationEnabled = v
				_G.Celestial.CrosshairAPI.ApplyAll()
			end)
			AddSliderToSection(secCrosshair, "Crosshair Size Modifier (%)", "Increases the exposed mobile Shift Lock control size up to 35%.", 0, 35, State.CrosshairSizeModifier, function(v)
				State.CrosshairSizeModifier = math.clamp(tonumber(v) or 0, 0, 35)
				_G.Celestial.CrosshairAPI.ApplyAll()
			end)
			AddSliderToSection(secCrosshair, "Crosshair Animation Speed", "Adjusts the Shift Lock rotation speed (1X - 10X).", 1, 10, State.CrosshairAnimationSpeed, function(v)
				State.CrosshairAnimationSpeed = math.clamp(tonumber(v) or 5, 1, 10)
				_G.Celestial.CrosshairAPI.ApplyAll()
			end)

			_G.Celestial.CrosshairAPI.ApplyAll()
			end
		end

		-- ====================================================================
		-- FLING TAB
		-- ====================================================================

		local secFling = CreateSection("FLING")
		AddTabButton("FLING", secFling, 109382157886392)
		AddCategoryHeader(secFling, "On-Screen Buttons")
		AddSpacer(secFling, 2)
		AddToggleToSection(secFling, "Fling Murderer Button", State.FlingMurdererOnScreen, function(v)
			State.FlingMurdererOnScreen = v
			FlingMurderBubble.Visible = v
		end, Color3.fromRGB(50, 50, 50))
		AddToggleToSection(secFling, "Fling Sheriff Button", State.FlingSheriffOnScreen, function(v)
			State.FlingSheriffOnScreen = v
			FlingSheriffBubble.Visible = v
		end, Color3.fromRGB(50, 50, 50))
		AddSpacer(secFling, 6)
		AddCategoryHeader(secFling, "Fling Stability & Engine")
		AddSpacer(secFling, 2)
		AddToggleToSection(secFling, "Stable Mode", State.FlingStableMode, function(v) State.FlingStableMode = v end, Color3.fromRGB(35, 105, 160), Color3.fromRGB(15, 15, 15))

		local cachePanel = Instance.new("Frame")
		cachePanel.Size = UDim2.new(1, -8, 0, 34)
		cachePanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		cachePanel.BackgroundTransparency = 0.15
		cachePanel.Parent = secFling
		local cachePanelCorner = Instance.new("UICorner")
		cachePanelCorner.CornerRadius = UDim.new(0, 8)
		cachePanelCorner.Parent = cachePanel
		local cacheLabel = Instance.new("TextLabel")
		cacheLabel.Size = UDim2.new(1, -16, 1, 0)
		cacheLabel.Position = UDim2.new(0, 8, 0, 0)
		cacheLabel.BackgroundTransparency = 1
		cacheLabel.TextColor3 = Color3.fromRGB(235, 225, 255)
		cacheLabel.Font = Enum.Font.GothamBold
		cacheLabel.TextSize = 12
		cacheLabel.TextXAlignment = Enum.TextXAlignment.Left
		cacheLabel.Text = "Fling Engine Cache  0.00 KB / 16.00 MB  (0%)"
		cacheLabel.Parent = cachePanel
		FlingEngine.CacheLabel = cacheLabel
		UpdateFlingCacheUI()

		AddButtonToSection(secFling, "🧹 Clear Fling Cache", Color3.fromRGB(65, 65, 95), function(btn)
			ClearFlingCache()
			btn.Text = "✅ Fling Cache Cleared"
			task.delay(1.5, function()
				if btn and btn.Parent then btn.Text = "🧹 Clear Fling Cache" end
			end)
		end)
		local resetFlingButton = AddButtonToSection(secFling, "🔄 Reset Fling Engine", Color3.fromRGB(85, 55, 110), function(btn)
			if ResetFlingEngineInternal() then
				btn.Text = "🔄 Resetting Fling Engine..."
				task.delay(0.20, function()
					if btn and btn.Parent then btn.Text = "🔄 Reset Fling Engine" end
				end)
			end
		end)

		local statusPanel = Instance.new("Frame")
		statusPanel.Size = UDim2.new(1, -8, 0, 48)
		statusPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
		statusPanel.BackgroundTransparency = 0.12
		statusPanel.Parent = secFling
		local statusPanelCorner = Instance.new("UICorner")
		statusPanelCorner.CornerRadius = UDim.new(0, 8)
		statusPanelCorner.Parent = statusPanel
		local statusTitle = Instance.new("TextLabel")
		statusTitle.Size = UDim2.new(1, -16, 0, 17)
		statusTitle.Position = UDim2.new(0, 8, 0, 4)
		statusTitle.BackgroundTransparency = 1
		statusTitle.Text = "Fling Engine Status"
		statusTitle.TextColor3 = Color3.fromRGB(205, 195, 225)
		statusTitle.Font = Enum.Font.GothamBold
		statusTitle.TextSize = 11
		statusTitle.TextXAlignment = Enum.TextXAlignment.Left
		statusTitle.Parent = statusPanel
		local resetStatusLabel = Instance.new("TextLabel")
		resetStatusLabel.Size = UDim2.new(1, -16, 0, 20)
		resetStatusLabel.Position = UDim2.new(0, 8, 0, 22)
		resetStatusLabel.BackgroundTransparency = 1
		resetStatusLabel.Text = "Ready — Fling Engine optimized"
		resetStatusLabel.TextColor3 = Color3.fromRGB(180, 230, 200)
		resetStatusLabel.Font = Enum.Font.GothamMedium
		resetStatusLabel.TextSize = 11
		resetStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
		resetStatusLabel.Parent = statusPanel
		FlingEngine.ResetStatusLabel = resetStatusLabel
		SetFlingResetStatus("Ready — Fling Engine optimized")

		AddToggleToSection(secFling, "Auto Reset-Optimize Fling Engine", State.FlingAutoResetOptimize, function(v)
			State.FlingAutoResetOptimize = v
		end, Color3.fromRGB(55, 115, 85), Color3.fromRGB(15, 15, 15))
		AddSpacer(secFling, 6)
		AddCategoryHeader(secFling, "Target Selection & Action")
		AddSpacer(secFling, 2)

		local SelectTargetModalBtn = Instance.new("TextButton")
		SelectTargetModalBtn.Size = UDim2.new(1, -8, 0, 36)
		SelectTargetModalBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 95)
		SelectTargetModalBtn.BackgroundTransparency = 0.35
		SelectTargetModalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		SelectTargetModalBtn.Text = "🎯 Target: [ None ]"
		SelectTargetModalBtn.Font = Enum.Font.GothamBold
		SelectTargetModalBtn.TextSize = 12
		SelectTargetModalBtn.Parent = secFling
		local stCorner = Instance.new("UICorner")
		stCorner.CornerRadius = UDim.new(0, 8)
		stCorner.Parent = SelectTargetModalBtn

		local function OpenTargetModal()
			for _, child in ipairs(ModalScroll:GetChildren()) do
				if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
			end
			local cancelBtn = Instance.new("TextButton")
			cancelBtn.Size = UDim2.new(1, -4, 0, 32)
			cancelBtn.BackgroundColor3 = Color3.fromRGB(200, 45, 45)
			cancelBtn.BackgroundTransparency = 0.35
			cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			cancelBtn.Text = "❌ Cancel"
			cancelBtn.Font = Enum.Font.GothamBold
			cancelBtn.TextSize = 12
			cancelBtn.ZIndex = 153
			cancelBtn.LayoutOrder = 0
			cancelBtn.Parent = ModalScroll
			local cCorner = Instance.new("UICorner")
			cCorner.CornerRadius = UDim.new(0, 6)
			cCorner.Parent = cancelBtn
			cancelBtn.MouseButton1Click:Connect(function()
				TargetModal.Visible = false
				State.TargetModalWasOpen = false
			end)
			local count = 0
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LocalPlayer then
					count += 1
					local pBtn = Instance.new("TextButton")
					pBtn.Size = UDim2.new(1, -4, 0, 32)
					pBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					pBtn.BackgroundTransparency = 0.35
					pBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
					pBtn.Text = p.Name
					pBtn.Font = Enum.Font.GothamMedium
					pBtn.TextSize = 12
					pBtn.ZIndex = 153
					pBtn.LayoutOrder = count
					pBtn.Parent = ModalScroll
					local pCorner = Instance.new("UICorner")
					pCorner.CornerRadius = UDim.new(0, 6)
					pCorner.Parent = pBtn
					pBtn.MouseButton1Click:Connect(function()
						State.SelectedFlingTarget = p
						SelectTargetModalBtn.Text = "🎯 Target: " .. p.Name
						TargetModal.Visible = false
						State.TargetModalWasOpen = false
					end)
				end
			end
			if count == 0 then
				local emptyLbl = Instance.new("TextLabel")
				emptyLbl.Size = UDim2.new(1, 0, 0, 30)
				emptyLbl.BackgroundTransparency = 1
				emptyLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
				emptyLbl.Text = "No other players found"
				emptyLbl.Font = Enum.Font.Gotham
				emptyLbl.TextSize = 11
				emptyLbl.ZIndex = 153
				emptyLbl.LayoutOrder = 1
				emptyLbl.Parent = ModalScroll
			end
			TargetModal.Visible = true
		end

		SelectTargetModalBtn.MouseButton1Click:Connect(function() OpenTargetModal() end)

		local executeTargetBtn = Instance.new("TextButton")
		executeTargetBtn.Size = UDim2.new(1, -8, 0, 36)
		executeTargetBtn.BackgroundColor3 = Color3.fromRGB(160, 50, 50)
		executeTargetBtn.BackgroundTransparency = 0.35
		executeTargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		executeTargetBtn.Text = "🚀 Execute Fling to Target"
		executeTargetBtn.Font = Enum.Font.GothamBold
		executeTargetBtn.TextSize = 12
		executeTargetBtn.Parent = secFling
		local etCorner = Instance.new("UICorner")
		etCorner.CornerRadius = UDim.new(0, 8)
		etCorner.Parent = executeTargetBtn
		executeTargetBtn.MouseButton1Click:Connect(function()
			if State.SelectedFlingTarget and State.SelectedFlingTarget.Character then
				_G.Celestial.ExecuteTorqueFling(State.SelectedFlingTarget.Character)
			else
				executeTargetBtn.Text = "⚠️ Select a target first!"
				task.spawn(function()
					task.wait(1.5)
					executeTargetBtn.Text = "🚀 Execute Fling to Target"
				end)
			end
		end)

		AddSpacer(secFling, 6)
		AddCategoryHeader(secFling, "Role Targets")
		AddSpacer(secFling, 2)

		local btnMurderCard = Instance.new("TextButton")
		btnMurderCard.Size = UDim2.new(1, -8, 0, 52)
		btnMurderCard.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
		btnMurderCard.BackgroundTransparency = 0.35
		btnMurderCard.Text = ""
		btnMurderCard.Parent = secFling
		local mCardCorner = Instance.new("UICorner")
		mCardCorner.CornerRadius = UDim.new(0, 10)
		mCardCorner.Parent = btnMurderCard
		local titleMurder = Instance.new("TextLabel")
		titleMurder.Size = UDim2.new(1, -45, 0, 22)
		titleMurder.Position = UDim2.new(0, 12, 0, 6)
		titleMurder.BackgroundTransparency = 1
		titleMurder.Text = "Fling Murderer"
		titleMurder.TextColor3 = Color3.fromRGB(255, 255, 255)
		titleMurder.Font = Enum.Font.GothamBold
		titleMurder.TextSize = 13
		titleMurder.TextXAlignment = Enum.TextXAlignment.Left
		titleMurder.Parent = btnMurderCard
		local descMurder = Instance.new("TextLabel")
		descMurder.Size = UDim2.new(1, -45, 0, 18)
		descMurder.Position = UDim2.new(0, 12, 0, 26)
		descMurder.BackgroundTransparency = 1
		descMurder.Text = "Throws the Murderer away."
		descMurder.TextColor3 = Color3.fromRGB(255, 200, 200)
		descMurder.Font = Enum.Font.GothamMedium
		descMurder.TextSize = 11
		descMurder.TextXAlignment = Enum.TextXAlignment.Left
		descMurder.Parent = btnMurderCard
		local iconMurder = Instance.new("TextLabel")
		iconMurder.Size = UDim2.new(0, 35, 0, 35)
		iconMurder.Position = UDim2.new(1, -38, 0.5, -18)
		iconMurder.BackgroundTransparency = 1
		iconMurder.Text = "💀"
		iconMurder.TextSize = 20
		iconMurder.Parent = btnMurderCard
		btnMurderCard.MouseButton1Click:Connect(function()
			local target = State.MurdererName ~= "" and Players:FindFirstChild(State.MurdererName) or nil
			if target and target.Character then _G.Celestial.ExecuteTorqueFling(target.Character) end
		end)

		local btnSheriffCard = Instance.new("TextButton")
		btnSheriffCard.Size = UDim2.new(1, -8, 0, 52)
		btnSheriffCard.BackgroundColor3 = Color3.fromRGB(50, 140, 255)
		btnSheriffCard.BackgroundTransparency = 0.35
		btnSheriffCard.TextColor3 = Color3.fromRGB(255, 255, 255)
		btnSheriffCard.Text = ""
		btnSheriffCard.Parent = secFling
		local sCardCorner = Instance.new("UICorner")
		sCardCorner.CornerRadius = UDim.new(0, 10)
		sCardCorner.Parent = btnSheriffCard
		local titleSheriff = Instance.new("TextLabel")
		titleSheriff.Size = UDim2.new(1, -45, 0, 22)
		titleSheriff.Position = UDim2.new(0, 12, 0, 6)
		titleSheriff.BackgroundTransparency = 1
		titleSheriff.Text = "Fling Hero / Sheriff"
		titleSheriff.TextColor3 = Color3.fromRGB(0, 0, 0)
		titleSheriff.Font = Enum.Font.GothamBold
		titleSheriff.TextSize = 13
		titleSheriff.TextXAlignment = Enum.TextXAlignment.Left
		titleSheriff.Parent = btnSheriffCard
		local descSheriff = Instance.new("TextLabel")
		descSheriff.Size = UDim2.new(1, -45, 0, 18)
		descSheriff.Position = UDim2.new(0, 12, 0, 26)
		descSheriff.BackgroundTransparency = 1
		descSheriff.Text = "Throws the Hero or Sheriff away."
		descSheriff.TextColor3 = Color3.fromRGB(0, 0, 0)
		descSheriff.Font = Enum.Font.GothamMedium
		descSheriff.TextSize = 11
		descSheriff.TextXAlignment = Enum.TextXAlignment.Left
		descSheriff.Parent = btnSheriffCard
		local iconSheriff = Instance.new("TextLabel")
		iconSheriff.Size = UDim2.new(0, 35, 0, 35)
		iconSheriff.Position = UDim2.new(1, -38, 0.5, -18)
		iconSheriff.BackgroundTransparency = 1
		iconSheriff.Text = "🛡️"
		iconSheriff.TextSize = 20
		iconSheriff.Parent = btnSheriffCard
		btnSheriffCard.MouseButton1Click:Connect(function()
			local target = GetActiveSheriffOrHeroPlayer()
			if target and target.Character then _G.Celestial.ExecuteTorqueFling(target.Character) end
		end)

		-- ====================================================================
		-- ANTI FLING TAB
		-- ====================================================================

		local secAntiFling = CreateSection("ANTI FLING")
		AddTabButton("ANTI FLING", secAntiFling, 114603150996525)
		AddCategoryHeader(secAntiFling, "Quantum Master Anti-Fling")
		AddSpacer(secAntiFling, 2)
		AddToggleToSection(secAntiFling, "QM Anti-Fling", State.AntiFlingActive, function(v)
			State.AntiFlingActive = v
			if not v then ClearAllProtection() end
		end, Color3.fromRGB(0, 50, 180), Color3.fromRGB(8, 8, 28))
		AddToggleToSection(secAntiFling, "⚛️ Quantum Auto-Defense", State.QuantumAutoDefense, function(v)
			State.QuantumAutoDefense = v
			if v then AntiFlingQuantum.DefenseTriggered = false end
		end, Color3.fromRGB(200, 160, 50), Color3.fromRGB(15, 15, 15))
		AddSpacer(secAntiFling, 4)

		local StatusPanel = Instance.new("Frame")
		StatusPanel.Size = UDim2.new(1, -8, 0, 110)
		StatusPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
		StatusPanel.BackgroundTransparency = 0.4
		StatusPanel.BorderSizePixel = 0
		StatusPanel.Parent = secAntiFling
		local statusCorner = Instance.new("UICorner")
		statusCorner.CornerRadius = UDim.new(0, 10)
		statusCorner.Parent = StatusPanel
		local ProtectionStatus = Instance.new("TextLabel")
		ProtectionStatus.Size = UDim2.new(1, -10, 0, 28)
		ProtectionStatus.Position = UDim2.new(0, 5, 0, 4)
		ProtectionStatus.BackgroundTransparency = 1
		ProtectionStatus.Font = Enum.Font.GothamBold
		ProtectionStatus.TextSize = 14
		ProtectionStatus.TextColor3 = Color3.fromRGB(150, 255, 150)
		ProtectionStatus.Text = "🟢 Protection Status: SAFE"
		ProtectionStatus.TextXAlignment = Enum.TextXAlignment.Left
		ProtectionStatus.Parent = StatusPanel
		local ScannedPlayersLabel = Instance.new("TextLabel")
		ScannedPlayersLabel.Size = UDim2.new(1, -10, 0, 18)
		ScannedPlayersLabel.Position = UDim2.new(0, 5, 0, 32)
		ScannedPlayersLabel.BackgroundTransparency = 1
		ScannedPlayersLabel.Font = Enum.Font.GothamMedium
		ScannedPlayersLabel.TextSize = 11
		ScannedPlayersLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
		ScannedPlayersLabel.Text = "Scanned Players: 0"
		ScannedPlayersLabel.TextXAlignment = Enum.TextXAlignment.Left
		ScannedPlayersLabel.Parent = StatusPanel
		_G.Celestial.ScannedPlayersLabel = ScannedPlayersLabel

		local SuspiciousBox = Instance.new("Frame")
		SuspiciousBox.Size = UDim2.new(0.48, -6, 0, 48)
		SuspiciousBox.Position = UDim2.new(0, 4, 0, 54)
		SuspiciousBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		SuspiciousBox.BackgroundTransparency = 0.6
		SuspiciousBox.BorderSizePixel = 0
		SuspiciousBox.Parent = StatusPanel
		local sbCorner = Instance.new("UICorner")
		sbCorner.CornerRadius = UDim.new(0, 6)
		sbCorner.Parent = SuspiciousBox
		local SuspiciousTitle = Instance.new("TextLabel")
		SuspiciousTitle.Size = UDim2.new(1, 0, 0, 18)
		SuspiciousTitle.Position = UDim2.new(0, 4, 0, 2)
		SuspiciousTitle.BackgroundTransparency = 1
		SuspiciousTitle.Font = Enum.Font.GothamBold
		SuspiciousTitle.TextSize = 10
		SuspiciousTitle.TextColor3 = Color3.fromRGB(255, 220, 100)
		SuspiciousTitle.Text = "⚠️ QMA Suspicious: 0"
		SuspiciousTitle.TextXAlignment = Enum.TextXAlignment.Left
		SuspiciousTitle.Parent = SuspiciousBox
		local SuspiciousUsers = Instance.new("TextLabel")
		SuspiciousUsers.Size = UDim2.new(1, -6, 0, 22)
		SuspiciousUsers.Position = UDim2.new(0, 4, 0, 22)
		SuspiciousUsers.BackgroundTransparency = 1
		SuspiciousUsers.Font = Enum.Font.Gotham
		SuspiciousUsers.TextSize = 9
		SuspiciousUsers.TextColor3 = Color3.fromRGB(200, 200, 210)
		SuspiciousUsers.Text = "Users: None"
		SuspiciousUsers.TextXAlignment = Enum.TextXAlignment.Left
		SuspiciousUsers.TextWrapped = true
		SuspiciousUsers.Parent = SuspiciousBox

		local DangerousBox = Instance.new("Frame")
		DangerousBox.Size = UDim2.new(0.48, -6, 0, 48)
		DangerousBox.Position = UDim2.new(0.52, 0, 0, 54)
		DangerousBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		DangerousBox.BackgroundTransparency = 0.6
		DangerousBox.BorderSizePixel = 0
		DangerousBox.Parent = StatusPanel
		local dbCorner = Instance.new("UICorner")
		dbCorner.CornerRadius = UDim.new(0, 6)
		dbCorner.Parent = DangerousBox
		local DangerousTitle = Instance.new("TextLabel")
		DangerousTitle.Size = UDim2.new(1, 0, 0, 18)
		DangerousTitle.Position = UDim2.new(0, 4, 0, 2)
		DangerousTitle.BackgroundTransparency = 1
		DangerousTitle.Font = Enum.Font.GothamBold
		DangerousTitle.TextSize = 10
		DangerousTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
		DangerousTitle.Text = "🔴 QMA Dangerous: 0"
		DangerousTitle.TextXAlignment = Enum.TextXAlignment.Left
		DangerousTitle.Parent = DangerousBox
		local DangerousUsers = Instance.new("TextLabel")
		DangerousUsers.Size = UDim2.new(1, -6, 0, 22)
		DangerousUsers.Position = UDim2.new(0, 4, 0, 22)
		DangerousUsers.BackgroundTransparency = 1
		DangerousUsers.Font = Enum.Font.Gotham
		DangerousUsers.TextSize = 9
		DangerousUsers.TextColor3 = Color3.fromRGB(200, 200, 210)
		DangerousUsers.Text = "Users: None"
		DangerousUsers.TextXAlignment = Enum.TextXAlignment.Left
		DangerousUsers.TextWrapped = true
		DangerousUsers.Parent = DangerousBox

		task.spawn(function()
			local alpha = 0
			local dir = 1
			while task.wait(0.1) do
				if not SuspiciousBox or not SuspiciousBox.Parent then break end
				alpha = alpha + dir * 0.02
				if alpha >= 1 or alpha <= 0 then dir = -dir end
				SuspiciousBox.BackgroundTransparency = 0.6 - alpha * 0.2
				DangerousBox.BackgroundTransparency = 0.6 - alpha * 0.2
			end
		end)

		AddSpacer(secAntiFling, 6)
		AddCategoryHeader(secAntiFling, "⚛️ OTI — Object Threat Intelligence")
		AddSpacer(secAntiFling, 2)
		AddToggleToSection(secAntiFling, "OTI Enabled", State.OTIActive, function(v)
			State.OTIActive = v
			if not v then
				if _G.Celestial.OTI then
					table.clear(_G.Celestial.OTI.TrackedObjects)
					table.clear(_G.Celestial.OTI.ObjectPool)
					_G.Celestial.OTI.PoolList = {}
					table.clear(_G.Celestial.OTI.SuspiciousPlayers)
					table.clear(_G.Celestial.OTI.DangerousPlayers)
					for plr, pData in pairs(_G.Celestial.OTI.PlayerOTI) do
						pData.ConfirmedSuspicious = false
						pData.DangerousFlag = false
					end
				end
			end
		end, Color3.fromRGB(90, 40, 140), Color3.fromRGB(12, 8, 20))

		local OTIPanel = Instance.new("Frame")
		OTIPanel.Size = UDim2.new(1, -8, 0, 118)
		OTIPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
		OTIPanel.BackgroundTransparency = 0.4
		OTIPanel.BorderSizePixel = 0
		OTIPanel.Parent = secAntiFling
		local otiCorner = Instance.new("UICorner")
		otiCorner.CornerRadius = UDim.new(0, 10)
		otiCorner.Parent = OTIPanel
		local OTIHeader = Instance.new("TextLabel")
		OTIHeader.Size = UDim2.new(1, -10, 0, 22)
		OTIHeader.Position = UDim2.new(0, 5, 0, 3)
		OTIHeader.BackgroundTransparency = 1
		OTIHeader.Font = Enum.Font.GothamBold
		OTIHeader.TextSize = 12
		OTIHeader.TextColor3 = Color3.fromRGB(200, 150, 255)
		OTIHeader.Text = "⚛️ OTI — Object Tracking Active"
		OTIHeader.TextXAlignment = Enum.TextXAlignment.Left
		OTIHeader.Parent = OTIPanel
		local OTIObjectsLabel = Instance.new("TextLabel")
		OTIObjectsLabel.Size = UDim2.new(1, -10, 0, 16)
		OTIObjectsLabel.Position = UDim2.new(0, 5, 0, 24)
		OTIObjectsLabel.BackgroundTransparency = 1
		OTIObjectsLabel.Font = Enum.Font.GothamMedium
		OTIObjectsLabel.TextSize = 10
		OTIObjectsLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
		OTIObjectsLabel.Text = "Objects: 0 | Active: 0 | Threats: 0"
		OTIObjectsLabel.TextXAlignment = Enum.TextXAlignment.Left
		OTIObjectsLabel.Parent = OTIPanel
		local OTIStatsLabel = Instance.new("TextLabel")
		OTIStatsLabel.Size = UDim2.new(1, -10, 0, 14)
		OTIStatsLabel.Position = UDim2.new(0, 5, 0, 40)
		OTIStatsLabel.BackgroundTransparency = 1
		OTIStatsLabel.Font = Enum.Font.Gotham
		OTIStatsLabel.TextSize = 9
		OTIStatsLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
		OTIStatsLabel.Text = "Pool: 0 | Analyzed/tick: 0"
		OTIStatsLabel.TextXAlignment = Enum.TextXAlignment.Left
		OTIStatsLabel.Parent = OTIPanel

		local OTISuspBox = Instance.new("Frame")
		OTISuspBox.Size = UDim2.new(0.48, -6, 0, 56)
		OTISuspBox.Position = UDim2.new(0, 4, 0, 58)
		OTISuspBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		OTISuspBox.BackgroundTransparency = 0.6
		OTISuspBox.BorderSizePixel = 0
		OTISuspBox.Parent = OTIPanel
		local otiSuspCorner = Instance.new("UICorner")
		otiSuspCorner.CornerRadius = UDim.new(0, 6)
		otiSuspCorner.Parent = OTISuspBox
		local OTISuspTitle = Instance.new("TextLabel")
		OTISuspTitle.Size = UDim2.new(1, 0, 0, 18)
		OTISuspTitle.Position = UDim2.new(0, 4, 0, 2)
		OTISuspTitle.BackgroundTransparency = 1
		OTISuspTitle.Font = Enum.Font.GothamBold
		OTISuspTitle.TextSize = 10
		OTISuspTitle.TextColor3 = Color3.fromRGB(200, 150, 255)
		OTISuspTitle.Text = "🟣 OTI Suspicious: 0"
		OTISuspTitle.TextXAlignment = Enum.TextXAlignment.Left
		OTISuspTitle.Parent = OTISuspBox
		local OTISuspUsers = Instance.new("TextLabel")
		OTISuspUsers.Size = UDim2.new(1, -6, 0, 34)
		OTISuspUsers.Position = UDim2.new(0, 4, 0, 20)
		OTISuspUsers.BackgroundTransparency = 1
		OTISuspUsers.Font = Enum.Font.Gotham
		OTISuspUsers.TextSize = 9
		OTISuspUsers.TextColor3 = Color3.fromRGB(210, 200, 230)
		OTISuspUsers.Text = "None"
		OTISuspUsers.TextXAlignment = Enum.TextXAlignment.Left
		OTISuspUsers.TextYAlignment = Enum.TextYAlignment.Top
		OTISuspUsers.TextWrapped = true
		OTISuspUsers.Parent = OTISuspBox

		local OTIDangBox = Instance.new("Frame")
		OTIDangBox.Size = UDim2.new(0.48, -6, 0, 56)
		OTIDangBox.Position = UDim2.new(0.52, 0, 0, 58)
		OTIDangBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		OTIDangBox.BackgroundTransparency = 0.6
		OTIDangBox.BorderSizePixel = 0
		OTIDangBox.Parent = OTIPanel
		local otiDangCorner = Instance.new("UICorner")
		otiDangCorner.CornerRadius = UDim.new(0, 6)
		otiDangCorner.Parent = OTIDangBox
		local OTIDangTitle = Instance.new("TextLabel")
		OTIDangTitle.Size = UDim2.new(1, 0, 0, 18)
		OTIDangTitle.Position = UDim2.new(0, 4, 0, 2)
		OTIDangTitle.BackgroundTransparency = 1
		OTIDangTitle.Font = Enum.Font.GothamBold
		OTIDangTitle.TextSize = 10
		OTIDangTitle.TextColor3 = Color3.fromRGB(220, 100, 220)
		OTIDangTitle.Text = "🟣 OTI Dangerous: 0"
		OTIDangTitle.TextXAlignment = Enum.TextXAlignment.Left
		OTIDangTitle.Parent = OTIDangBox
		local OTIDangUsers = Instance.new("TextLabel")
		OTIDangUsers.Size = UDim2.new(1, -6, 0, 34)
		OTIDangUsers.Position = UDim2.new(0, 4, 0, 20)
		OTIDangUsers.BackgroundTransparency = 1
		OTIDangUsers.Font = Enum.Font.Gotham
		OTIDangUsers.TextSize = 9
		OTIDangUsers.TextColor3 = Color3.fromRGB(230, 200, 230)
		OTIDangUsers.Text = "None"
		OTIDangUsers.TextXAlignment = Enum.TextXAlignment.Left
		OTIDangUsers.TextYAlignment = Enum.TextYAlignment.Top
		OTIDangUsers.TextWrapped = true
		OTIDangUsers.Parent = OTIDangBox

		_G.Celestial.OTIUI = {
			ObjectsLabel = OTIObjectsLabel, StatsLabel = OTIStatsLabel,
			SuspTitle = OTISuspTitle, SuspUsers = OTISuspUsers,
			DangTitle = OTIDangTitle, DangUsers = OTIDangUsers,
		}

		task.spawn(function()
			while task.wait(0.5) do
				pcall(function()
					local oti = _G.Celestial.OTI
					local ui = _G.Celestial.OTIUI
					if not oti or not ui then return end
					if not ui.ObjectsLabel or not ui.ObjectsLabel.Parent then return end
					local poolCount = #(oti.PoolList or {})
					local activeCount = oti.ActiveCount or 0
					local threatCount = oti.ThreatCount or 0
					local analyzedTick = oti.LastAnalyzedCount or 0
					local suspList = {}
					local dangList = {}
					for plr, pData in pairs(oti.PlayerOTI) do
						if plr and plr.Parent then
							if pData.DangerousFlag then
								table.insert(dangList, plr.Name .. " (" .. math.floor(pData.ObjectScore) .. ")")
							elseif pData.ConfirmedSuspicious then
								table.insert(suspList, plr.Name .. " (" .. math.floor(pData.ObjectScore) .. ")")
							end
						end
					end
					ui.ObjectsLabel.Text = string.format("Objects: %d | Active: %d | Threats: %d", poolCount, activeCount, threatCount)
					ui.StatsLabel.Text = string.format("Analyzed/tick: %d | Susp: %d | Dang: %d", analyzedTick, #suspList, #dangList)
					ui.SuspTitle.Text = "🟣 OTI Suspicious: " .. #suspList
					ui.DangTitle.Text = "🟣 OTI Dangerous: " .. #dangList
					ui.SuspUsers.Text = #suspList > 0 and table.concat(suspList, "\n") or "None"
					ui.DangUsers.Text = #dangList > 0 and table.concat(dangList, "\n") or "None"
				end)
			end
		end)

		AddSpacer(secAntiFling, 4)
		AddCategoryHeader(secAntiFling, "OTI — Detection Parameters")
		AddSpacer(secAntiFling, 2)
		AddSliderToSection(secAntiFling, "OTI Object Speed Threshold", "Speed (studs/s) to flag anomalous.", 20, 300, State.OTIObjectSpeedThreshold, function(v) State.OTIObjectSpeedThreshold = v end)
		AddSliderToSection(secAntiFling, "OTI Object Acceleration Threshold", "Anomalous acceleration (studs/s²).", 10, 250, State.OTIObjectAccelerationThreshold, function(v) State.OTIObjectAccelerationThreshold = v end)
		AddSliderToSection(secAntiFling, "OTI Object Angular Threshold", "Anomalous angular velocity.", 50, 1500, State.OTIObjectAngularThreshold, function(v) State.OTIObjectAngularThreshold = v end)
		AddSliderToSection(secAntiFling, "OTI Threat Distance", "Object↔player distance for alarm.", 3, 40, State.OTIThreatDistance, function(v) State.OTIThreatDistance = v end)
		AddSliderToSection(secAntiFling, "OTI Sustained Time", "Minimum sustained anomaly time.", 0.1, 3.0, State.OTISustainedTime, function(v) State.OTISustainedTime = v end)
		AddSliderToSection(secAntiFling, "OTI Threat Confidence", "OTI score to flag suspicious.", 30, 90, State.OTIThreatConfidenceThreshold, function(v) State.OTIThreatConfidenceThreshold = v end)
		AddSliderToSection(secAntiFling, "OTI Critical Threshold", "OTI score to escalate to Dangerous.", 60, 100, State.OTICriticalThreshold, function(v) State.OTICriticalThreshold = v end)
		AddSpacer(secAntiFling, 4)
		AddCategoryHeader(secAntiFling, "OTI — Performance Optimization")
		AddSpacer(secAntiFling, 2)
		AddSliderToSection(secAntiFling, "OTI Tracking Radius", "Max distance to track nearby objects.", 20, 200, State.OTITrackingRadius, function(v) State.OTITrackingRadius = v end)
		AddSliderToSection(secAntiFling, "OTI Full Track Radius", "Radius for intensive tracking (priority).", 5, 100, State.OTIFullTrackingRadius, function(v) State.OTIFullTrackingRadius = v end)
		AddSliderToSection(secAntiFling, "OTI Max Objects/Tick", "Analysis budget per tick (lower = less lag).", 3, 60, State.OTIMaxObjectsPerTick, function(v) State.OTIMaxObjectsPerTick = v end)
		AddSliderToSection(secAntiFling, "OTI Pool Refresh (s)", "Seconds between pool rebuilds (lower = more reactive).", 0.5, 5.0, State.OTIPoolRefreshInterval, function(v) State.OTIPoolRefreshInterval = v end)
		AddSliderToSection(secAntiFling, "OTI Dormant Time (s)", "Immobile time to sleep an object.", 0.5, 10.0, State.OTIDormantTime, function(v) State.OTIDormantTime = v end)
		AddSliderToSection(secAntiFling, "OTI Dormant Scan (s)", "Re-check interval for dormant objects.", 0.2, 3.0, State.OTIDormantScanInterval, function(v) State.OTIDormantScanInterval = v end)

		local AntiFlingResetButton = Instance.new("TextButton")
		AntiFlingResetButton.Size = UDim2.new(1, -8, 0, 36)
		AntiFlingResetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
		AntiFlingResetButton.BackgroundTransparency = 0.35
		AntiFlingResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		AntiFlingResetButton.Text = "🔄 Clear Protection Cache"
		AntiFlingResetButton.Font = Enum.Font.GothamBold
		AntiFlingResetButton.TextSize = 12
		AntiFlingResetButton.Parent = secAntiFling
		local antiFlingResetCorner = Instance.new("UICorner")
		antiFlingResetCorner.CornerRadius = UDim.new(0, 8)
		antiFlingResetCorner.Parent = AntiFlingResetButton
		AntiFlingResetButton.MouseButton1Click:Connect(function()
			AntiFlingClearAllProtection()
			AntiFlingResetButton.Text = "✅ Protection cache cleared"
			task.delay(1.2, function()
				if AntiFlingResetButton and AntiFlingResetButton.Parent then
					AntiFlingResetButton.Text = "🔄 Clear Protection Cache"
				end
			end)
		end)

		AddSpacer(secAntiFling, 4)
		AddCategoryHeader(secAntiFling, "QMA Detection Parameters")
		AddSpacer(secAntiFling, 2)
		AddSliderToSection(secAntiFling, "Observed Speed Suspicion", "Position-derived horizontal speed that starts movement suspicion.", 20, 40, State.AntiFlingObservedSpeedSuspicion, function(v) State.AntiFlingObservedSpeedSuspicion = v end)
		AddSliderToSection(secAntiFling, "Observed Speed Critical", "Position-derived horizontal speed treated as severe.", 32, 70, State.AntiFlingObservedSpeedCritical, function(v) State.AntiFlingObservedSpeedCritical = v end)
		AddSliderToSection(secAntiFling, "Peer Speed Multiplier", "Compare a player against the current server movement baseline.", 1.20, 2.20, State.AntiFlingPeerSpeedMultiplier, function(v) State.AntiFlingPeerSpeedMultiplier = v end, 2)
		AddSliderToSection(secAntiFling, "Speed Confirm Time", "How long an abnormal speed must persist before QMA records it.", 0.15, 0.80, State.AntiFlingSpeedConfirmTime, function(v) State.AntiFlingSpeedConfirmTime = v end, 2)
		AddSliderToSection(secAntiFling, "Fly Air Time", "Minimum sustained airborne time for flight evidence.", 0.90, 2.50, State.AntiFlingFlyAirTime, function(v) State.AntiFlingFlyAirTime = v end, 2)
		AddSliderToSection(secAntiFling, "Fly Hover Time", "Stable airborne hover duration for hover detection.", 0.30, 1.50, State.AntiFlingFlyHoverTime, function(v) State.AntiFlingFlyHoverTime = v end, 2)
		AddSliderToSection(secAntiFling, "Teleport Distance", "Observed displacement that becomes a relocation/teleport signal.", 18, 60, State.AntiFlingTeleportDistance, function(v) State.AntiFlingTeleportDistance = v end)
		AddSliderToSection(secAntiFling, "Angular Escalation Threshold", "Min angular increase to trigger escalation.", 30, 500, State.AntiFlingAngularEscalationThreshold, function(v) State.AntiFlingAngularEscalationThreshold = v end)
		AddSliderToSection(secAntiFling, "Velocity Acceleration Threshold", "Min linear increase to trigger escalation.", 20, 200, State.AntiFlingVelocityAccelerationThreshold, function(v) State.AntiFlingVelocityAccelerationThreshold = v end)
		AddSliderToSection(secAntiFling, "Escalation Window", "Time window for escalation detection.", 0.1, 1.5, State.AntiFlingEscalationWindow, function(v) State.AntiFlingEscalationWindow = v end)
		AddSliderToSection(secAntiFling, "Residual Vertical Velocity", "Vertical speed considered residual.", 10, 100, State.AntiFlingResidualVerticalVelocity, function(v) State.AntiFlingResidualVerticalVelocity = v end)
		AddSliderToSection(secAntiFling, "Residual Horizontal Velocity", "Horizontal speed considered residual.", 10, 150, State.AntiFlingResidualHorizontalVelocity, function(v) State.AntiFlingResidualHorizontalVelocity = v end)
		AddSliderToSection(secAntiFling, "Residual Displacement", "Displacement considered residual.", 1, 15, State.AntiFlingResidualDisplacement, function(v) State.AntiFlingResidualDisplacement = v end)
		AddSliderToSection(secAntiFling, "Spin Threshold", "Angular speed to start spin detection.", 100, 1200, State.AntiFlingSpinThreshold, function(v) State.AntiFlingSpinThreshold = v end)
		AddSliderToSection(secAntiFling, "Sustained Spin Time", "Time to confirm sustained spin.", 0.1, 1.0, State.AntiFlingSustainedSpinTime, function(v) State.AntiFlingSustainedSpinTime = v end)
		AddSliderToSection(secAntiFling, "Orbit Distance", "Max distance for orbit detection.", 2, 15, State.AntiFlingOrbitDistance, function(v) State.AntiFlingOrbitDistance = v end)
		AddSliderToSection(secAntiFling, "Orbit Speed Threshold", "Min speed for orbit detection.", 10, 100, State.AntiFlingOrbitSpeedThreshold, function(v) State.AntiFlingOrbitSpeedThreshold = v end)
		AddSliderToSection(secAntiFling, "Threat Confidence Threshold", "Confidence % to consider a threat.", 30, 90, State.AntiFlingThreatConfidenceThreshold, function(v) State.AntiFlingThreatConfidenceThreshold = v end)
		AddSliderToSection(secAntiFling, "Critical Confidence Threshold", "Confidence % for critical threat.", 50, 100, State.AntiFlingCriticalConfidenceThreshold, function(v) State.AntiFlingCriticalConfidenceThreshold = v end)
		AddSliderToSection(secAntiFling, "Protection Hold Time", "Time to keep protection after threat.", 0.1, 1.5, State.AntiFlingProtectionHoldTime, function(v) State.AntiFlingProtectionHoldTime = v end)
		AddSliderToSection(secAntiFling, "Protection Release Time", "Time to release protection after threat.", 0.2, 2.0, State.AntiFlingProtectionReleaseTime, function(v) State.AntiFlingProtectionReleaseTime = v end)
		AddSliderToSection(secAntiFling, "Critical Protection Time", "Extended hold time for critical threats.", 0.2, 2.0, State.AntiFlingCriticalProtectionTime, function(v) State.AntiFlingCriticalProtectionTime = v end)
		AddSliderToSection(secAntiFling, "Max Self Corrections/s", "Maximum stabilization corrections per second.", 2, 40, State.AntiFlingMaxSelfCorrectionPerSecond, function(v) State.AntiFlingMaxSelfCorrectionPerSecond = v end)

		task.spawn(function()
			while task.wait(0.5) do
				pcall(function()
					local qmaSusp = {}
					local qmaDang = {}
					for player in pairs(AntiFlingQuantum.SuspiciousPlayers) do
						if player and player.Parent and player ~= LocalPlayer then
							table.insert(qmaSusp, player.Name)
						end
					end
					for player in pairs(AntiFlingQuantum.DangerousPlayers) do
						if player and player.Parent and player ~= LocalPlayer then
							table.insert(qmaDang, player.Name)
						end
					end
					for player, data in pairs(AntiFlingQuantum.ThreatStates) do
						if player and player.Parent and player ~= LocalPlayer
							and (data.State == "Threat" or data.State == "Critical") then
							local found = false
							for _, name in ipairs(qmaDang) do
								if name == player.Name then found = true; break end
							end
							if not found then table.insert(qmaDang, player.Name) end
						end
					end
					local suspiciousCount = #qmaSusp
					local dangerousCount = #qmaDang
					SuspiciousTitle.Text = "⚠️ QMA Suspicious: " .. suspiciousCount
					DangerousTitle.Text = "🔴 QMA Dangerous: " .. dangerousCount
					local speedSuspiciousNames = {}
					for player, data in pairs(AntiFlingQuantum.SuspiciousPlayers) do
						if player and player.Parent and data
							and (data.Reason == "Sustained Speed Anomaly" or data.Reason == "Extreme Speed" or data.Reason == "Impossible Relocation") then
							table.insert(speedSuspiciousNames, player.Name)
						end
					end
					local speedSuffix = #speedSuspiciousNames > 0 and (" | MOVEMENT: " .. table.concat(speedSuspiciousNames, ", ")) or ""
					SuspiciousUsers.Text = suspiciousCount > 0 and (("Users: " .. table.concat(qmaSusp, ", ")) .. speedSuffix) or (("Users: None") .. speedSuffix)
					DangerousUsers.Text = dangerousCount > 0 and ("Users: " .. table.concat(qmaDang, ", ")) or "Users: None"

					local statusColor = Color3.fromRGB(150, 255, 150)
					local statusText = "🟢 Protection Status: SAFE"
					local combined = dangerousCount + suspiciousCount
					local movementAnomalyCount = #speedSuspiciousNames
					if movementAnomalyCount > 0 then
						SuspiciousTitle.Text = "⚠️ QMA Suspicious: " .. suspiciousCount .. " | ⚡ " .. movementAnomalyCount .. " MOVEMENT"
					end
					if combined > 5 then
						statusColor = Color3.fromRGB(55, 0, 85)
						statusText = "🟣 Protection Status: EXTREME THREAT"
					elseif dangerousCount > 2 and suspiciousCount > 2 then
						statusColor = Color3.fromRGB(110, 0, 165)
						statusText = "🟣 Protection Status: SEVERE THREAT"
					elseif dangerousCount >= 1 and suspiciousCount >= 1 then
						statusColor = Color3.fromRGB(120, 55, 0)
						statusText = "🟠 Protection Status: CRITICAL (DPD + SPD)"
					elseif dangerousCount >= 1 then
						statusColor = Color3.fromRGB(255, 40, 40)
						statusText = "🔴 Protection Status: DANGER"
					elseif suspiciousCount >= 8 then
						statusColor = Color3.fromRGB(255, 165, 0)
						statusText = "🟠 Protection Status: HIGH SUSPICION"
					elseif suspiciousCount >= 3 then
						statusColor = Color3.fromRGB(255, 230, 0)
						statusText = "🟡 Protection Status: MODERATE SUSPICION"
					elseif suspiciousCount >= 1 then
						statusColor = Color3.fromRGB(150, 255, 150)
						statusText = "🟢 Protection Status: LOW SUSPICION"
					end
					ProtectionStatus.TextColor3 = statusColor
					ProtectionStatus.Text = statusText
				end)
			end
		end)

		-- ====================================================================
		-- TELEPORT TAB
		-- ====================================================================

		pcall(function()
			local TPState = _G.Celestial.TeleportState or {}
			TPState.Saved = TPState.Saved or {}
			TPState.MapSpawns = TPState.MapSpawns or {}
			TPState.ReturnOnDeath = TPState.ReturnOnDeath or {}
			TPState.VisualSignatures = TPState.VisualSignatures or {}
			TPState.Selected = TPState.Selected or {}
			TPState.LobbyCFrame = TPState.LobbyCFrame or nil
			TPState.PendingDeathReturn = nil
			TPState.CurrentMap = TPState.CurrentMap or nil
			TPState.LastMap = TPState.LastMap or nil
			TPState.LastRoundMap = TPState.LastRoundMap or nil
			TPState.IgnoreNaturalUntil = 0
			TPState.NaturalGeneration = 0
			TPState.ErrorToken = 0
			TPState.LastInRound = false
			TPState.LobbyConfirmStart = nil
			TPState.PlayerLastPositions = TPState.PlayerLastPositions or {}
			_G.Celestial.TeleportState = TPState

			if _G.Celestial.TeleportConnections then
				for _, connection in pairs(_G.Celestial.TeleportConnections) do
					pcall(function() connection:Disconnect() end)
				end
			end
			_G.Celestial.TeleportConnections = {}

			local TPMaps = {
				{n="MANSION 2", id=83538178695138}, {n="BANK 2", id=107914513579125},
				{n="BANK 3", id=120529229306871}, {n="HOUSE 2", id=139072612149430},
				{n="MIL BASE", id=95635237513938}, {n="HOTEL 2", id=100646189670485},
				{n="OFFICE 3", id=102422231283113}, {n="HOSPITAL 3", id=124324799384429},
				{n="RESEARCH FACILITY", id=86334308397351}, {n="FACTORY", id=90788725587214},
				{n="POLICE STATION", id=135141198289063}, {n="MINESHAFT", id=79259766676752},
				{n="PIER", id=124298853119484}, {n="FARMHOUSE", id=87828791439147},
				{n="BEACH RESORT", id=73362529543535}, {n="YACHT", id=76667602539178},
				{n="INFECTION BARN", id=76492571136638}, {n="CHRISTMAS IN ITALY", id=95526006510848},
				{n="BIO LAB", id=115831412861075}, {n="VAMPIRES CASTLE", id=107866090072905},
				{n="SKI VILLAGE", id=76257737960710}, {n="LOG CABIN", id=133713663591282},
				{n="ICE CASTLE", id=109723343363260}, {n="WORKPLACE", id=92311280732880},
				{n="SKI LODGE", id=133621945817788}, {n="WORKSHOP", id=96119741728787},
				{n="TRAIN STATION", id=100116890537404}, {n="MANOR", id=104553665794078},
			}

			local TPById, TPAlias = {}, {}
			for _, info in ipairs(TPMaps) do TPById[tostring(info.id)] = info.n end
			local function TP_norm(value) return tostring(value or ""):upper():gsub("[^A-Z0-9]", "") end
			local function TP_registerAlias(displayName, ...)
				for _, alias in ipairs({...}) do TPAlias[TP_norm(alias)] = displayName end
			end
			TP_registerAlias("MANSION 2", "MANSION2", "MANSION", "MANSIONV2")
			TP_registerAlias("BANK 2", "BANK", "BANK2", "BANKV2")
			TP_registerAlias("BANK 3", "BANK3", "BANKV3")
			TP_registerAlias("HOUSE 2", "HOUSE2", "HOUSE", "HOUSEV2")
			TP_registerAlias("MIL BASE", "MILBASE", "MILITARYBASE", "MILITARYBASE2")
			TP_registerAlias("HOTEL 2", "HOTEL2", "HOTEL", "HOTELV2")
			TP_registerAlias("OFFICE 3", "OFFICE3", "OFFICE", "OFFICEV3")
			TP_registerAlias("HOSPITAL 3", "HOSPITAL3", "HOSPITAL", "HOSPITALV3")
			TP_registerAlias("RESEARCH FACILITY", "RESEARCHFACILITY", "RESEARCHFACILITY3", "RESEARCH")
			TP_registerAlias("FACTORY", "FACTORY", "FACTORY2")
			TP_registerAlias("POLICE STATION", "POLICESTATION", "POLICE", "POLICESTATION2")
			TP_registerAlias("MINESHAFT", "MINESHAFT", "MINE", "MINES")
			TP_registerAlias("PIER", "PIER")
			TP_registerAlias("FARMHOUSE", "FARMHOUSE", "FARM")
			TP_registerAlias("BEACH RESORT", "BEACHRESORT", "BEACH")
			TP_registerAlias("YACHT", "YACHT", "YACHT2")
			TP_registerAlias("INFECTION BARN", "INFECTIONBARN", "BARNINFECTION")
			TP_registerAlias("CHRISTMAS IN ITALY", "CHRISTMASINITALY", "CHRISTMASITALY")
			TP_registerAlias("BIO LAB", "BIOLAB", "BIOLABORATORY")
			TP_registerAlias("VAMPIRES CASTLE", "VAMPIRESCASTLE", "VAMPIRECASTLE")
			TP_registerAlias("SKI VILLAGE", "SKIVILLAGE")
			TP_registerAlias("LOG CABIN", "LOGCABIN")
			TP_registerAlias("ICE CASTLE", "ICECASTLE")
			TP_registerAlias("WORKPLACE", "WORKPLACE")
			TP_registerAlias("SKI LODGE", "SKILODGE")
			TP_registerAlias("WORKSHOP", "WORKSHOP")
			TP_registerAlias("TRAIN STATION", "TRAINSTATION")
			TP_registerAlias("MANOR", "MANOR")

			local function TP_findAlias(value)
				local normalized = TP_norm(value)
				if normalized == "" then return nil end
				if TPAlias[normalized] then return TPAlias[normalized] end
				for alias, displayName in pairs(TPAlias) do
					if #alias >= 5 and normalized:find(alias, 1, true) then return displayName end
				end
				return nil
			end

			local function TP_guiVisible(obj, playerGui)
				local current = obj
				while current and current ~= playerGui do
					if current:IsA("GuiObject") and not current.Visible then return false end
					if current:IsA("ScreenGui") and not current.Enabled then return false end
					current = current.Parent
				end
				return true
			end

			local function TP_votingActive()
				local pg = LocalPlayer:FindFirstChild("PlayerGui")
				if not pg then return false end
				local directNames = {"Vote","Voting","VoteFrame","VotingFrame","MapVoting","MapVote","VoteGUI","MapVoteGUI"}
				for _, name in ipairs(directNames) do
					local candidate = pg:FindFirstChild(name, true)
					if candidate and TP_guiVisible(candidate, pg) then return true end
				end
				local checked = 0
				for _, obj in ipairs(pg:GetDescendants()) do
					checked = checked + 1
					if checked > 160 then break end
					if TP_guiVisible(obj, pg) then
						local lower = string.lower(obj.Name)
						if lower:find("vote", 1, true) and not lower:find("avoid", 1, true) then return true end
						if obj:IsA("TextLabel") or obj:IsA("TextButton") then
							local text = string.lower(tostring(obj.Text or ""))
							if text:find("vote", 1, true) or text:find("voting", 1, true) then return true end
						end
					end
				end
				return false
			end

			local function TP_localPlayerIsInLobby()
				local root = GetRoot()
				if not root or not root.Parent then return nil end
				if TPState.LobbyCFrame then
					local dist = (root.Position - TPState.LobbyCFrame.Position).Magnitude
					if dist < 40 then return true end
					if dist > 100 then return false end
				end
				local roundState = _G.Celestial.RoundTimerState
				if roundState and roundState.phase then
					if roundState.phase == "Round" and not roundState.ended then return false end
					if roundState.phase == "Idle" then return true end
				end
				if TP_votingActive() then return true end
				return nil
			end

			local function TP_visualContainer()
				return Workspace:FindFirstChild("Map") or Workspace:FindFirstChild("Normal")
					or Workspace:FindFirstChild("Round") or Workspace:FindFirstChild("Arena")
					or Workspace:FindFirstChild("DuelArena")
			end

			local function TP_visualSignature(container)
				if not container then return nil end
				local counts = {}
				local total = 0
				local scanned = 0
				for _, obj in ipairs(container:GetDescendants()) do
					scanned = scanned + 1
					if obj:IsA("BasePart") then
						local c = obj.Color
						local material = tostring(obj.Material)
						local key = material .. ":" ..
							tostring(math.floor(c.R * 4)) .. ":" ..
							tostring(math.floor(c.G * 4)) .. ":" ..
							tostring(math.floor(c.B * 4))
						counts[key] = (counts[key] or 0) + 1
						total = total + 1
						if total >= 80 or scanned >= 500 then break end
					end
				end
				if total < 8 then return nil end
				local keys = {}
				for key, count in pairs(counts) do keys[#keys + 1] = {key=key, count=count} end
				table.sort(keys, function(a, b) return a.count > b.count end)
				local result = {}
				local limit = math.min(16, #keys)
				for i = 1, limit do result[keys[i].key] = keys[i].count / total end
				return result
			end

			local function TP_visualSimilarity(a, b)
				if not a or not b then return 0 end
				local score = 0
				local common = 0
				local totalA = 0
				local totalB = 0
				for key, value in pairs(a) do
					totalA = totalA + value
					if b[key] then score = score + math.min(value, b[key]); common = common + 1 end
				end
				for _, value in pairs(b) do totalB = totalB + value end
				if common == 0 then return 0 end
				return math.min(score / math.max(totalA, 0.001), score / math.max(totalB, 0.001))
			end

			local function TP_learnVisual(mapName)
				if not mapName then return end
				local container = TP_visualContainer()
				local signature = TP_visualSignature(container)
				if signature then TPState.VisualSignatures[mapName] = signature end
			end

			local function TP_findMapByTexture()
				if TP_votingActive() then return nil end
				local pg = LocalPlayer:FindFirstChild("PlayerGui")
				if not pg then return nil end
				local checked = 0
				for _, obj in ipairs(pg:GetDescendants()) do
					checked = checked + 1
					if checked > 260 then break end
					if (obj:IsA("ImageLabel") or obj:IsA("ImageButton")) and TP_guiVisible(obj, pg) then
						local image = tostring(obj.Image or "")
						local id = image:match("(%d+)")
						if id and TPById[id] then return TPById[id] end
					end
				end
				return nil
			end

			local function TP_findMap()
				if TP_votingActive() then return nil end
				local containers = {
					Workspace, Workspace:FindFirstChild("Map"),
					Workspace:FindFirstChild("Normal"), Workspace:FindFirstChild("Round"),
					Workspace:FindFirstChild("Arena"), Workspace:FindFirstChild("DuelArena"),
				}
				for _, container in ipairs(containers) do
					if container then
						for _, attributeName in ipairs({"MapName", "Map", "CurrentMap", "MapId"}) do
							local ok, value = pcall(function() return container:GetAttribute(attributeName) end)
							if ok and value ~= nil then
								local alias = TP_findAlias(value)
								if alias then return alias end
								local id = tostring(value):match("(%d+)")
								if id and TPById[id] then return TPById[id] end
							end
						end
					end
				end
				for _, container in ipairs(containers) do
					if container then
						for _, child in ipairs(container:GetChildren()) do
							local alias = TP_findAlias(child.Name)
							if alias then return alias end
						end
					end
				end
				local candidates = {Workspace:FindFirstChild("Map"), Workspace:FindFirstChild("Normal"), Workspace:FindFirstChild("Round")}
				for _, container in ipairs(candidates) do
					if container then
						local checked = 0
						for _, obj in ipairs(container:GetDescendants()) do
							checked = checked + 1
							if checked > 260 then break end
							local alias = TP_findAlias(obj.Name)
							if alias then return alias end
						end
					end
				end
				local byTexture = TP_findMapByTexture()
				if byTexture then return byTexture end
				local currentSignature = TP_visualSignature(TP_visualContainer())
				if currentSignature then
					local bestName, bestScore, secondScore = nil, 0, 0
					for mapName, learnedSignature in pairs(TPState.VisualSignatures) do
						local score = TP_visualSimilarity(currentSignature, learnedSignature)
						if score > bestScore then
							secondScore = bestScore
							bestScore = score
							bestName = mapName
						elseif score > secondScore then
							secondScore = score
						end
					end
					if bestName and bestScore >= 0.55 and bestScore - secondScore >= 0.06 then return bestName end
				end
				return nil
			end

			local function TP_mapImage(mapName)
				if TP_norm(mapName) == "LOBBY" then return "rbxassetid://88089614966439" end
				for _, info in ipairs(TPMaps) do
					if info.n == mapName then return "rbxassetid://" .. tostring(info.id) end
				end
				return ""
			end

			local function TP_getSaved(mapName)
				local list = TPState.Saved[mapName]
				if type(list) ~= "table" then
					list = {}
					TPState.Saved[mapName] = list
				end
				return list
			end

			local function TP_tempButtonText(button, text, duration)
				if not button or not button.Parent then return end
				local oldText = button.Text
				button.Text = text
				task.delay(duration or 1.3, function()
					if button and button.Parent and button.Text == text then button.Text = oldText end
				end)
			end

			local TPErrorLabel
			if PerformanceIsland then
				TPErrorLabel = Instance.new("TextLabel")
				TPErrorLabel.Name = "TeleportError"
				TPErrorLabel.Size = UDim2.new(1, 0, 0, 34)
				TPErrorLabel.Position = UDim2.new(0, 0, 0.5, -17)
				TPErrorLabel.BackgroundTransparency = 1
				TPErrorLabel.Text = "Error"
				TPErrorLabel.TextColor3 = Color3.fromRGB(255, 45, 45)
				TPErrorLabel.Font = Enum.Font.GothamBold
				TPErrorLabel.TextSize = 16
				TPErrorLabel.TextXAlignment = Enum.TextXAlignment.Center
				TPErrorLabel.TextYAlignment = Enum.TextYAlignment.Center
				TPErrorLabel.ZIndex = 140
				TPErrorLabel.Visible = false
				TPErrorLabel.Parent = PerformanceIsland
			end
			local function TP_showError()
				if not TPErrorLabel then return end
				if State.FPSCounterEnabled ~= true and State.PingDisplayEnabled ~= true then return end
				TPState.ErrorToken = TPState.ErrorToken + 1
				local token = TPState.ErrorToken
				TPErrorLabel.Visible = true
				task.delay(1.5, function()
					if TPState.ErrorToken == token and TPErrorLabel and TPErrorLabel.Parent then
						TPErrorLabel.Visible = false
					end
				end)
			end

			local function TP_directTeleport(targetCFrame)
				local root = GetRoot()
				if not root or not root.Parent or not targetCFrame then return false end
				TPState.IgnoreNaturalUntil = tick() + 3.0
				TPState.NaturalGeneration = TPState.NaturalGeneration + 1
				local ok = pcall(function() root.CFrame = targetCFrame end)
				return ok
			end
			local function TP_teleport(targetCFrame) return TP_directTeleport(targetCFrame) end

			local function TP_getMapReferenceCFrame()
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer and plr.Character then
						local pRoot = plr.Character:FindFirstChild("HumanoidRootPart")
						local pHum = plr.Character:FindFirstChildOfClass("Humanoid")
						if pRoot and pHum and pHum.Health > 0 and TPState.LobbyCFrame then
							local dist = (pRoot.Position - TPState.LobbyCFrame.Position).Magnitude
							if dist > 100 then return pRoot.CFrame + Vector3.new(3, 0, 3) end
						end
					end
				end
				return nil
			end

			local function TP_getLobbyReferenceCFrame()
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer and plr.Character then
						local pRoot = plr.Character:FindFirstChild("HumanoidRootPart")
						local pHum = plr.Character:FindFirstChildOfClass("Humanoid")
						if pRoot and pHum and pHum.Health > 0 and TPState.LobbyCFrame then
							local dist = (pRoot.Position - TPState.LobbyCFrame.Position).Magnitude
							if dist < 40 then return pRoot.CFrame + Vector3.new(2, 0, 2) end
						end
					end
				end
				return nil
			end

			local function TP_setCurrentMap(mapName)
				if mapName == TPState.CurrentMap then
					if mapName then TPState.LastMap = mapName end
					return
				end
				local previous = TPState.CurrentMap
				TPState.CurrentMap = mapName
				if mapName then
					TPState.LastMap = mapName
					TP_learnVisual(mapName)
				end
			end

			local function TP_updateMap()
				local found = TP_findMap()
				TP_setCurrentMap(found)
				return found
			end

			local function TP_isLobby()
				if TP_findMap() then return false end
				local names = {"Lobby","Lobby3D","LobbyArea","MainLobby","LobbyMap","LobbySpawn"}
				for _, name in ipairs(names) do
					if Workspace:FindFirstChild(name, true) then return true end
				end
				local pg = LocalPlayer:FindFirstChild("PlayerGui")
				if pg then
					local checked = 0
					for _, obj in ipairs(pg:GetDescendants()) do
						checked = checked + 1
						if checked > 120 then break end
						if string.lower(obj.Name):find("lobby", 1, true) then return true end
					end
				end
				return false
			end

			local function TP_captureLobby(forceRefresh, assumeLobbyIfNoMap)
				local isLobby = TP_localPlayerIsInLobby()
				if isLobby == false then return false end
				if isLobby == nil and not assumeLobbyIfNoMap then return false end
				local root = GetRoot()
				if not root or not root.Parent then return false end
				if forceRefresh or not TPState.LobbyCFrame then
					TPState.LobbyCFrame = root.CFrame
				end
				return true
			end

			local function TP_locationContext()
				local isLobby = TP_localPlayerIsInLobby()
				if isLobby == true then return "LOBBY" end
				if isLobby == false then
					local mapName = TP_findMap()
					if mapName then return mapName end
					if TPState.LastRoundMap then return TPState.LastRoundMap end
					return "MAP"
				end
				if TP_votingActive() or TP_isLobby() then return "LOBBY" end
				local mapName = TP_findMap()
				if mapName then return mapName end
				if TPState.LastRoundMap then return TPState.LastRoundMap end
				return nil
			end

			local function TP_saveLocation(button)
				local root = GetRoot()
				if not root or not root.Parent then
					TP_tempButtonText(button, "Character not ready", 1.4)
					return
				end
				local isLobby = TP_localPlayerIsInLobby()
				if isLobby == nil then
					local mapName = TP_findMap()
					if mapName then isLobby = false
					elseif TP_votingActive() then isLobby = true
					else
						TP_tempButtonText(button, "Location not detected", 1.4)
						return
					end
				end
				local contextName
				if isLobby then
					contextName = "LOBBY"
					TPState.LobbyCFrame = root.CFrame
				else
					contextName = TP_findMap() or TPState.LastRoundMap or "MAP"
					if TPState.LobbyCFrame then
						local dist = (root.Position - TPState.LobbyCFrame.Position).Magnitude
						if dist < 40 then
							TP_tempButtonText(button, "Position looks like lobby", 1.4)
							return
						end
					end
				end
				local list = TP_getSaved(contextName)
				table.insert(list, {CFrame = root.CFrame, Map = contextName, CreatedAt = tick()})
				while #list > 3 do table.remove(list, 1) end
				TPState.ReturnOnDeath[contextName] = list[#list]
				TP_tempButtonText(button, "Saved " .. tostring(#list) .. "/3", 1.0)
			end

			local function TP_updateReturnTarget(mapName)
				local list = TPState.Saved[mapName]
				if type(list) == "table" and #list > 0 then
					TPState.ReturnOnDeath[mapName] = list[#list]
				else
					TPState.ReturnOnDeath[mapName] = nil
				end
			end

			local function TP_teleportSaved(entry)
				if not entry or not entry.CFrame then return end
				local isLobby = TP_localPlayerIsInLobby()
				if isLobby ~= nil then
					local entryIsLobby = (entry.Map == "LOBBY")
					if isLobby ~= entryIsLobby then TP_showError(); return end
				end
				TP_teleport(entry.CFrame)
			end

			local savedGui, savedList, savedSearch, savedDelete, savedLayout
			local deleteSelectionMode = false
			local selected = TPState.Selected
			local entryButtons = {}

			local function TP_selectedKey(mapName, index) return tostring(mapName) .. "#" .. tostring(index) end
			local function TP_clearSelected() table.clear(selected) end
			local function TP_deleteSelected()
				for mapName, list in pairs(TPState.Saved) do
					if type(list) == "table" then
						local kept = {}
						for index, entry in ipairs(list) do
							if not selected[TP_selectedKey(mapName, index)] then kept[#kept + 1] = entry end
						end
						TPState.Saved[mapName] = kept
						TP_updateReturnTarget(mapName)
						if #kept == 0 then
							TPState.Saved[mapName] = nil
							TPState.ReturnOnDeath[mapName] = nil
						end
					end
				end
				TP_clearSelected()
			end
			local function TP_selectedVisibleMapEntries(query)
				local rows = {}
				local q = TP_norm(query)
				for mapName, list in pairs(TPState.Saved) do
					if type(list) == "table" and (q == "" or TP_norm(mapName):find(q, 1, true)) then
						for index, entry in ipairs(list) do rows[#rows + 1] = {Map=mapName, Index=index, Entry=entry} end
					end
				end
				table.sort(rows, function(a, b)
					if a.Map == b.Map then return a.Index < b.Index end
					return a.Map < b.Map
				end)
				return rows
			end
			local function TP_styleSelected(button, isSelected)
				if not button then return end
				if isSelected then button.BackgroundColor3 = Color3.fromRGB(60, 100, 70)
				else button.BackgroundColor3 = Color3.fromRGB(15, 15, 20) end
			end
			local function TP_closeSaved()
				if savedGui then pcall(function() savedGui:Destroy() end) end
				savedGui = nil
				entryButtons = {}
				deleteSelectionMode = false
				TP_clearSelected()
			end
			local function TP_makeSavedEntry(parent, row)
				local holder = Instance.new("TextButton")
				holder.Name = "SavedLocation"
				holder.Size = UDim2.new(1, -4, 0, 64)
				holder.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
				holder.BackgroundTransparency = 0.15
				holder.BorderSizePixel = 0
				holder.Text = ""
				holder.AutoButtonColor = false
				holder.ZIndex = 252
				holder.Parent = parent
				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 9)
				corner.Parent = holder
				local thumb = Instance.new("ImageLabel")
				thumb.Name = "MapImage"
				thumb.Size = UDim2.new(0, 44, 0, 44)
				thumb.Position = UDim2.new(0, 7, 0.5, -22)
				thumb.BackgroundTransparency = 1
				thumb.Image = TP_mapImage(row.Map)
				thumb.ScaleType = Enum.ScaleType.Fit
				thumb.ZIndex = 253
				thumb.Parent = holder
				local nameLabel = Instance.new("TextLabel")
				nameLabel.Size = UDim2.new(1, -64, 0, 22)
				nameLabel.Position = UDim2.new(0, 59, 0, 9)
				nameLabel.BackgroundTransparency = 1
				nameLabel.Text = string.upper(row.Map)
				nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				nameLabel.Font = Enum.Font.GothamBold
				nameLabel.TextSize = 13
				nameLabel.TextXAlignment = Enum.TextXAlignment.Left
				nameLabel.ZIndex = 253
				nameLabel.Parent = holder
				local positionLabel = Instance.new("TextLabel")
				positionLabel.Size = UDim2.new(1, -64, 0, 20)
				positionLabel.Position = UDim2.new(0, 59, 0, 32)
				positionLabel.BackgroundTransparency = 1
				local p = row.Entry.CFrame.Position
				positionLabel.Text = string.format("#%d  X %.1f  Y %.1f  Z %.1f", row.Index, p.X, p.Y, p.Z)
				positionLabel.TextColor3 = Color3.fromRGB(190, 190, 200)
				positionLabel.Font = Enum.Font.Gotham
				positionLabel.TextSize = 10
				positionLabel.TextXAlignment = Enum.TextXAlignment.Left
				positionLabel.ZIndex = 253
				positionLabel.Parent = holder
				local function refreshSelection() TP_styleSelected(holder, selected[TP_selectedKey(row.Map, row.Index)] == true) end
				refreshSelection()
				entryButtons[holder] = row
				local pressInput, pressStart, moved, longPressed, pressTask
				holder.InputBegan:Connect(function(input)
					if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
					pressInput = input
					pressStart = input.Position
					moved = false
					longPressed = false
					pressTask = task.delay(0.55, function()
						if pressInput == input and not moved and holder.Parent then
							longPressed = true
							local key = TP_selectedKey(row.Map, row.Index)
							selected[key] = not selected[key]
							refreshSelection()
						end
					end)
				end)
				holder.InputChanged:Connect(function(input)
					if pressInput and input == pressInput then
						if (input.Position - pressStart).Magnitude > 10 then
							moved = true
							if pressTask then pcall(function() task.cancel(pressTask) end); pressTask = nil end
						end
					end
				end)
				holder.InputEnded:Connect(function(input)
					if input ~= pressInput then return end
					if pressTask then pcall(function() task.cancel(pressTask) end); pressTask = nil end
					local wasTap = not moved and not longPressed
					pressInput = nil
					if not wasTap then return end
					if deleteSelectionMode then
						local key = TP_selectedKey(row.Map, row.Index)
						selected[key] = not selected[key]
						refreshSelection()
						return
					end
					TP_teleportSaved(row.Entry)
				end)
				return holder
			end

			local function TP_refreshSaved()
				if not savedGui or not savedGui.Parent then return end
				if not savedList or not savedList.Parent then return end
				entryButtons = {}
				for _, child in ipairs(savedList:GetChildren()) do
					if child ~= savedLayout then pcall(function() child:Destroy() end) end
				end
				local rows = TP_selectedVisibleMapEntries(savedSearch and savedSearch.Text or "")
				local layoutOrder = 0
				for _, row in ipairs(rows) do
					layoutOrder = layoutOrder + 1
					local wrapped = {Map=row.Map, Index=row.Index, Entry=row.Entry}
					local created = TP_makeSavedEntry(savedList, wrapped)
					if created then created.LayoutOrder = layoutOrder end
				end
				if #rows == 0 then
					local empty = Instance.new("TextLabel")
					empty.Size = UDim2.new(1, -4, 0, 40)
					empty.BackgroundTransparency = 1
					empty.Text = "No saved locations"
					empty.TextColor3 = Color3.fromRGB(180, 180, 190)
					empty.Font = Enum.Font.GothamBold
					empty.TextSize = 12
					empty.LayoutOrder = 1
					empty.Parent = savedList
				end
			end

			local function TP_openSaved()
				if savedGui and savedGui.Parent then return end
				savedGui = Instance.new("Frame")
				savedGui.Name = "SavedLocationsWindow"
				savedGui.Size = UDim2.new(0.92, 0, 0.76, 0)
				savedGui.Position = UDim2.new(0.04, 0, 0.12, 0)
				savedGui.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
				savedGui.BackgroundTransparency = 0.08
				savedGui.BorderSizePixel = 0
				savedGui.ZIndex = 250
				savedGui.Parent = ScreenGui
				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 14)
				corner.Parent = savedGui
				local title = Instance.new("TextLabel")
				title.Size = UDim2.new(1, -116, 0, 34)
				title.Position = UDim2.new(0, 12, 0, 5)
				title.BackgroundTransparency = 1
				title.Text = "SAVED LOCATIONS"
				title.TextColor3 = Color3.fromRGB(255, 255, 255)
				title.Font = Enum.Font.GothamBold
				title.TextSize = 14
				title.TextXAlignment = Enum.TextXAlignment.Left
				title.ZIndex = 252
				title.Parent = savedGui
				local close = Instance.new("TextButton")
				close.Size = UDim2.new(0, 34, 0, 30)
				close.Position = UDim2.new(1, -40, 0, 7)
				close.BackgroundColor3 = Color3.fromRGB(70, 35, 45)
				close.BackgroundTransparency = 0.2
				close.Text = "×"
				close.TextColor3 = Color3.fromRGB(255, 255, 255)
				close.Font = Enum.Font.GothamBold
				close.TextSize = 20
				close.ZIndex = 253
				close.Parent = savedGui
				close.MouseButton1Click:Connect(TP_closeSaved)
				savedSearch = Instance.new("TextBox")
				savedSearch.Name = "Search"
				savedSearch.Size = UDim2.new(1, -116, 0, 32)
				savedSearch.Position = UDim2.new(0, 10, 0, 43)
				savedSearch.BackgroundColor3 = Color3.fromRGB(25, 25, 31)
				savedSearch.BackgroundTransparency = 0.15
				savedSearch.BorderSizePixel = 0
				savedSearch.PlaceholderText = "Search map name..."
				savedSearch.PlaceholderColor3 = Color3.fromRGB(150, 150, 160)
				savedSearch.Text = ""
				savedSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
				savedSearch.Font = Enum.Font.Gotham
				savedSearch.TextSize = 11
				savedSearch.ClearTextOnFocus = false
				savedSearch.ZIndex = 253
				savedSearch.Parent = savedGui
				local searchCorner = Instance.new("UICorner")
				searchCorner.CornerRadius = UDim.new(0, 8)
				searchCorner.Parent = savedSearch
				savedDelete = Instance.new("TextButton")
				savedDelete.Name = "Delete"
				savedDelete.Size = UDim2.new(0, 48, 0, 32)
				savedDelete.Position = UDim2.new(1, -102, 0, 43)
				savedDelete.BackgroundColor3 = Color3.fromRGB(55, 25, 30)
				savedDelete.BackgroundTransparency = 0.15
				savedDelete.BorderSizePixel = 0
				savedDelete.Text = ""
				savedDelete.ZIndex = 253
				savedDelete.Parent = savedGui
				local deleteCorner = Instance.new("UICorner")
				deleteCorner.CornerRadius = UDim.new(0, 8)
				deleteCorner.Parent = savedDelete
				local deleteImage = Instance.new("ImageLabel")
				deleteImage.Size = UDim2.new(0, 20, 0, 20)
				deleteImage.Position = UDim2.new(0.5, -10, 0.5, -10)
				deleteImage.BackgroundTransparency = 1
				deleteImage.Image = "rbxassetid://123139299778580"
				deleteImage.ScaleType = Enum.ScaleType.Fit
				deleteImage.ZIndex = 254
				deleteImage.Parent = savedDelete
				local selectedCountLabel = Instance.new("TextLabel")
				selectedCountLabel.Size = UDim2.new(0, 44, 0, 16)
				selectedCountLabel.Position = UDim2.new(1, -49, 1, -18)
				selectedCountLabel.BackgroundTransparency = 1
				selectedCountLabel.Text = ""
				selectedCountLabel.TextColor3 = Color3.fromRGB(255, 210, 210)
				selectedCountLabel.Font = Enum.Font.GothamBold
				selectedCountLabel.TextSize = 9
				selectedCountLabel.TextXAlignment = Enum.TextXAlignment.Center
				selectedCountLabel.ZIndex = 255
				selectedCountLabel.Parent = savedGui
				savedList = Instance.new("ScrollingFrame")
				savedList.Name = "SavedList"
				savedList.Size = UDim2.new(1, -16, 1, -84)
				savedList.Position = UDim2.new(0, 8, 0, 80)
				savedList.BackgroundTransparency = 1
				savedList.BorderSizePixel = 0
				savedList.ScrollBarThickness = 3
				savedList.AutomaticCanvasSize = Enum.AutomaticSize.Y
				savedList.CanvasSize = UDim2.new(0, 0, 0, 0)
				savedList.ZIndex = 252
				savedList.Parent = savedGui
				savedLayout = Instance.new("UIListLayout")
				savedLayout.SortOrder = Enum.SortOrder.LayoutOrder
				savedLayout.Padding = UDim.new(0, 5)
				savedLayout.Parent = savedList
				savedLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					if savedList and savedList.Parent then
						savedList.CanvasSize = UDim2.new(0, 0, 0, savedLayout.AbsoluteContentSize.Y + 8)
					end
				end)
				savedSearch:GetPropertyChangedSignal("Text"):Connect(function() TP_refreshSaved() end)
				savedDelete.MouseButton1Click:Connect(function()
					local selectedCount = 0
					for _, isSelected in pairs(selected) do
						if isSelected then selectedCount = selectedCount + 1 end
					end
					if not deleteSelectionMode and selectedCount > 0 then
						TP_deleteSelected()
						TP_refreshSaved()
						selectedCountLabel.Text = ""
						return
					end
					if not deleteSelectionMode then
						deleteSelectionMode = true
						deleteImage.Visible = false
						savedDelete.Text = "□"
						savedDelete.TextColor3 = Color3.fromRGB(255, 255, 255)
						savedDelete.Font = Enum.Font.GothamBold
						savedDelete.TextSize = 19
						selectedCountLabel.Text = "SELECT"
						return
					end
					local rows = TP_selectedVisibleMapEntries(savedSearch.Text)
					for _, row in ipairs(rows) do
						selected[TP_selectedKey(row.Map, row.Index)] = true
					end
					deleteSelectionMode = false
					deleteImage.Visible = true
					savedDelete.Text = ""
					selectedCount = 0
					for _, isSelected in pairs(selected) do
						if isSelected then selectedCount = selectedCount + 1 end
					end
					selectedCountLabel.Text = selectedCount > 0 and tostring(selectedCount) or ""
					TP_refreshSaved()
				end)
				TP_refreshSaved()
			end

			local function TP_returnToMap(button)
				local mapName = TPState.LastRoundMap or TPState.LastMap
				local targetCFrame = mapName and TPState.MapSpawns[mapName] or nil
				if targetCFrame and TPState.LobbyCFrame then
					local dist = (targetCFrame.Position - TPState.LobbyCFrame.Position).Magnitude
					if dist < 40 then
						if mapName then TPState.MapSpawns[mapName] = nil end
						targetCFrame = nil
					end
				end
				if not targetCFrame then targetCFrame = TP_getMapReferenceCFrame() end
				if not targetCFrame then
					TP_tempButtonText(button, "Visit map first", 1.4)
					return
				end
				TP_teleport(targetCFrame)
			end

			local function TP_returnToLobby(button)
				if not TPState.LobbyCFrame then
					TP_captureLobby(true, false)
				end
				if not TPState.LobbyCFrame then
					TPState.LobbyCFrame = TP_getLobbyReferenceCFrame()
				end
				if not TPState.LobbyCFrame then
					TP_tempButtonText(button, "Lobby not saved", 1.4)
					return
				end
				TP_teleport(TPState.LobbyCFrame)
			end

			local function TP_hookCharacter(character)
				if not character then return end
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if not humanoid then humanoid = character:WaitForChild("Humanoid", 4) end
				if not humanoid then return end
				local deathConnection = humanoid.Died:Connect(function()
					local mapName = TPState.CurrentMap or TP_updateMap()
					local target = mapName and TPState.ReturnOnDeath[mapName]
					if target and target.CFrame then
						TPState.PendingDeathReturn = {Map = mapName, CFrame = target.CFrame}
					else TPState.PendingDeathReturn = nil end
				end)
				_G.Celestial.TeleportConnections[#_G.Celestial.TeleportConnections + 1] = deathConnection
			end

			_G.Celestial.TeleportConnections.MapMonitor = task.spawn(function()
				while ScreenGui and ScreenGui.Parent do
					pcall(function()
						local now = tick()
						local isLobby = TP_localPlayerIsInLobby()
						for _, plr in ipairs(Players:GetPlayers()) do
							if plr.Character then
								local pRoot = plr.Character:FindFirstChild("HumanoidRootPart")
								local pHum = plr.Character:FindFirstChildOfClass("Humanoid")
								if pRoot and pHum and pHum.Health > 0 then
									TPState.PlayerLastPositions[plr] = {
										Position = pRoot.Position,
										InRound = (isLobby == false),
										Time = now,
									}
								end
							end
						end
						if isLobby == true then
							local localRoot = GetRoot()
							if localRoot and localRoot.Parent then
								if not TPState.LobbyCFrame then
									TPState.LobbyCFrame = localRoot.CFrame
								else
									local dist = (localRoot.Position - TPState.LobbyCFrame.Position).Magnitude
									if dist > 200 then TPState.LobbyCFrame = localRoot.CFrame end
								end
							end
						end
						local inRound = (isLobby == false)
						if inRound and not TPState.LastInRound then
							local mapName = TP_findMap()
							local key = mapName or ("MAP_" .. tostring(math.floor(now)))
							task.spawn(function()
								task.wait(1.2)
								if TP_localPlayerIsInLobby() == false then
									local root = GetRoot()
									if root and root.Parent then
										local valid = true
										if TPState.LobbyCFrame then
											local dist = (root.Position - TPState.LobbyCFrame.Position).Magnitude
											if dist < 60 then valid = false end
										end
										if valid then
											TPState.MapSpawns[key] = root.CFrame
											TPState.LastRoundMap = key
											TPState.LastMap = key
										end
									end
								end
							end)
						end
						if isLobby == true and TPState.LastInRound then
							task.spawn(function()
								task.wait(1.5)
								if TP_localPlayerIsInLobby() == true then
									local root = GetRoot()
									if root and root.Parent then
										if not TPState.LobbyCFrame
											or (root.Position - TPState.LobbyCFrame.Position).Magnitude > 100 then
											TPState.LobbyCFrame = root.CFrame
										end
									end
								end
							end)
						end
						if isLobby ~= nil then TPState.LastInRound = inRound end
						TP_updateMap()
					end)
					task.wait(0.5)
				end
			end)

			if LocalPlayer.Character then TP_hookCharacter(LocalPlayer.Character) end

			_G.Celestial.TeleportConnections.CharacterAdded =
				LocalPlayer.CharacterAdded:Connect(function(character)
					TP_hookCharacter(character)
					task.spawn(function()
						local pending = TPState.PendingDeathReturn
						if not pending or not pending.Map or not pending.CFrame then return end
						for _ = 1, 12 do
							if not ScreenGui or not ScreenGui.Parent then return end
							local currentMap = TP_findMap()
							if currentMap == pending.Map then
								TPState.IgnoreNaturalUntil = tick() + 3.0
								TP_teleport(pending.CFrame)
								TPState.PendingDeathReturn = nil
								return
							end
							if currentMap and currentMap ~= pending.Map then
								TPState.PendingDeathReturn = nil
								return
							end
							task.wait(0.25)
						end
						TPState.PendingDeathReturn = nil
					end)
				end)

			local secTeleport = CreateSection("TELEPORT")
			AddTabButton("TELEPORT", secTeleport, 126447675359685)
			AddButtonToSection(secTeleport, "TP TO GUN", Color3.fromRGB(50, 140, 255), function(button)
				_G.Celestial.TeleportToGun(button)
			end)
			AddCategoryHeader(secTeleport, "Position Tools")
			AddSpacer(secTeleport, 2)
			AddButtonToSection(secTeleport, "Save Current Location", Color3.fromRGB(55, 105, 165), function(button)
				TP_saveLocation(button)
			end)
			AddButtonToSection(secTeleport, "Show Saved Locations", Color3.fromRGB(55, 55, 80), function()
				TP_openSaved()
			end)
			AddCategoryHeader(secTeleport, "Map Travel")
			AddSpacer(secTeleport, 2)
			AddButtonToSection(secTeleport, "Teleport to Map", Color3.fromRGB(55, 85, 135), function(button)
				TP_returnToMap(button)
			end)
			AddButtonToSection(secTeleport, "Teleport To Lobby", Color3.fromRGB(55, 85, 105), function(button)
				TP_returnToLobby(button)
			end)
			task.spawn(function()
				task.wait(1.0)
				for _ = 1, 12 do
					if not ScreenGui or not ScreenGui.Parent then return end
					if TP_captureLobby(true, true) then break end
					task.wait(0.5)
				end
			end)
		end)

		-- ====================================================================
		-- FPS TAB
		-- ====================================================================

		local secFPS = CreateSection("FPS")
		AddTabButton("FPS", secFPS, 72329844163469)
		AddToggleToSection(secFPS, "FPS Counter", State.FPSCounterEnabled, function(v)
			State.FPSCounterEnabled = v
			UpdatePerformanceIslandLayout()
		end)
		AddToggleToSection(secFPS, "Ping Display", State.PingDisplayEnabled, function(v)
			State.PingDisplayEnabled = v
			UpdatePerformanceIslandLayout()
		end)
		AddToggleToSection(secFPS, "FPS Boost", State.FPSBoostActive, function(v)
			State.FPSBoostActive = v
			if v then ApplyAllPerformanceOptimizations()
			else
				RestoreAllPerformanceOptimizations()
				if State.DisableParticles or State.DisableTrails or State.DisableShadows
					or State.DisableTextures or State.DisableEffects or State.ReduceRenderEffects then
					ApplyAllPerformanceOptimizations()
				end
			end
		end)
		AddToggleToSection(secFPS, "Disable Particles", State.DisableParticles, function(v)
			State.DisableParticles = v
			ApplyAllPerformanceOptimizations()
		end)
		AddToggleToSection(secFPS, "Disable Trails", State.DisableTrails, function(v)
			State.DisableTrails = v
			ApplyAllPerformanceOptimizations()
		end)
		AddToggleToSection(secFPS, "Disable Shadows", State.DisableShadows, function(v)
			State.DisableShadows = v
			ApplyAllPerformanceOptimizations()
		end)
		AddToggleToSection(secFPS, "Disable Textures", State.DisableTextures, function(v)
			State.DisableTextures = v
			ApplyAllPerformanceOptimizations()
		end)
		AddToggleToSection(secFPS, "Disable Effects", State.DisableEffects, function(v)
			State.DisableEffects = v
			ApplyAllPerformanceOptimizations()
		end)
		AddToggleToSection(secFPS, "Reduce Render Effects", State.ReduceRenderEffects, function(v)
			State.ReduceRenderEffects = v
			ApplyAllPerformanceOptimizations()
		end)

		-- ====================================================================
		-- VISUALS TAB
		-- ====================================================================

		local secVisuals = CreateSection("CHAMS")
		AddTabButton("CHAMS", secVisuals, 122232139135601)
		AddToggleToSection(secVisuals, "Global ESP (Team/Role Colors)", State.ESPEnabled, function(v) State.ESPEnabled = v end)
		AddToggleToSection(secVisuals, "Show your own ESP", State.ShowOwnESP, function(v) State.ShowOwnESP = v end, Color3.fromRGB(180, 100, 60))
		State.GunDropESPEnabled = false
		local gunESPObj = nil
		local function ClearGunESP()
			if gunESPObj then pcall(function() gunESPObj:Destroy() end); gunESPObj = nil end
		end
		AddToggleToSection(secVisuals, "Dropped Gun ESP", State.GunDropESPEnabled, function(v)
			State.GunDropESPEnabled = v
			if not v then ClearGunESP()
			else
				task.spawn(function()
					while State.GunDropESPEnabled do
						local gunDrop = FindDroppedGun()
						if gunDrop then
							if not gunESPObj then
								gunESPObj = Instance.new("Highlight")
								gunESPObj.Name = "GunDropESP"
								gunESPObj.FillColor = Color3.fromRGB(255, 255, 0)
								gunESPObj.FillTransparency = 0
								gunESPObj.OutlineTransparency = 1
								gunESPObj.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
							end
							local targetAdornee = gunDrop
							if gunDrop.Parent and (gunDrop.Parent:IsA("Tool")
								or gunDrop.Parent.Name == "GunDrop"
								or gunDrop.Parent.Name == "RevolverDrop") then
								targetAdornee = gunDrop.Parent
							end
							gunESPObj.Adornee = targetAdornee
							if gunESPObj.Parent ~= _G.Celestial.ESPFolder then
								pcall(function() gunESPObj.Parent = _G.Celestial.ESPFolder end)
							end
						else ClearGunESP() end
						task.wait(0.2)
					end
					ClearGunESP()
				end)
			end
		end)
		AddToggleToSection(secVisuals, "Trap ESP", State.TrapESPEnabled, function(v)
			State.TrapESPEnabled = v
			if not v then
				TrapPowerState = false
				ClearAllTrapESP()
			else
				HandleTrapPowerChange()
			end
		end, Color3.fromRGB(180, 60, 60))
		AddToggleToSection(secVisuals, "Show Round Timer", State.ShowTimerActive, function(v) State.ShowTimerActive = v end)

		-- ====================================================================
		-- MISC TAB
		-- ====================================================================

		local secMisc = CreateSection("MISC")
		AddTabButton("MISC", secMisc, 125144052381568)
		AddCategoryHeader(secMisc, "Server & UI Options")
		AddSpacer(secMisc, 2)
		AddButtonToSection(secMisc, "🔄 Rejoin Server", Color3.fromRGB(60, 60, 90), function()
			task.spawn(function()
				local TeleportService = game:GetService("TeleportService")
				local placeId = game.PlaceId
				local jobId = game.JobId
				if not jobId or jobId == "" then return end
				pcall(function() TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer) end)
			end)
		end)
		AddButtonToSection(secMisc, "🌐 Server Hop", Color3.fromRGB(60, 90, 60), function()
			task.spawn(function()
				local TeleportService = game:GetService("TeleportService")
				local HttpService = game:GetService("HttpService")
				local placeId = game.PlaceId
				local currentJobId = game.JobId
				local req = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
				local function getPage(cursor)
					local url = "https://games.roblox.com/v1/games/" .. tostring(placeId) .. "/servers/Public?sortOrder=Asc&limit=100"
					if cursor and cursor ~= "" then url = url .. "&cursor=" .. HttpService:UrlEncode(cursor) end
					local ok, raw = pcall(function()
						if req then
							local response = req({Url = url, Method = "GET"})
							if response and response.Body then return response.Body end
							return nil
						end
						return game:HttpGet(url)
					end)
					if not ok or not raw then return nil end
					local decodedOk, result = pcall(function() return HttpService:JSONDecode(raw) end)
					if decodedOk and result then return result end
					return nil
				end
				local candidates = {}
				local cursor = nil
				for _ = 1, 5 do
					local result = getPage(cursor)
					if not result or type(result.data) ~= "table" then break end
					for _, server in ipairs(result.data) do
						if server and server.id and server.id ~= currentJobId
							and tonumber(server.playing or 0) < tonumber(server.maxPlayers or 0) then
							table.insert(candidates, server.id)
						end
					end
					cursor = result.nextPageCursor
					if not cursor or cursor == "" then break end
				end
				if #candidates == 0 then return end
				for i = #candidates, 2, -1 do
					local j = math.random(1, i)
					candidates[i], candidates[j] = candidates[j], candidates[i]
				end
				pcall(function() TeleportService:TeleportToPlaceInstance(placeId, candidates[1], LocalPlayer) end)
			end)
		end)
		AddButtonToSection(secMisc, "❌ Close & Destroy Hub", Color3.fromRGB(180, 40, 40), function()
			if _G.Celestial.StopCoinEngine then _G.Celestial.StopCoinEngine() end
			if _G.Celestial.SpiderESP and _G.Celestial.SpiderESP.Cleanup then pcall(_G.Celestial.SpiderESP.Cleanup) end
			AntiFlingClearAllProtection()
			if _G.Celestial.ConnectionAntiFling then _G.Celestial.ConnectionAntiFling:Disconnect(); _G.Celestial.ConnectionAntiFling = nil end
			if _G.Celestial.ConnectionOTI then
				pcall(function() _G.Celestial.ConnectionOTI:Disconnect() end)
				_G.Celestial.ConnectionOTI = nil
			end
			if _G.Celestial.ConnectionNoClip then pcall(function() _G.Celestial.ConnectionNoClip:Disconnect() end) end
			if _G.Celestial.ConnectionPhysModifiers then pcall(function() _G.Celestial.ConnectionPhysModifiers:Disconnect() end) end
			if _G.Celestial.ConnectionBombBoost then pcall(function() _G.Celestial.ConnectionBombBoost:Disconnect() end) end
			AbsoluteClearESP()
			if _G.Celestial.SelfHighlight then pcall(function() _G.Celestial.SelfHighlight:Destroy() end); _G.Celestial.SelfHighlight = nil end
			if _G.Celestial.ConnectionFly then _G.Celestial.ConnectionFly:Disconnect(); _G.Celestial.ConnectionFly = nil end
			if _G.Celestial.ConnectionRoleScanner then _G.Celestial.ConnectionRoleScanner:Disconnect(); _G.Celestial.ConnectionRoleScanner = nil end
			if _G.Celestial.ConnectionGhostESP then _G.Celestial.ConnectionGhostESP:Disconnect(); _G.Celestial.ConnectionGhostESP = nil end
			if _G.Celestial.ConnectionPowerDetector then _G.Celestial.ConnectionPowerDetector:Disconnect(); _G.Celestial.ConnectionPowerDetector = nil end
			if _G.Celestial.ConnectionTrapESP then _G.Celestial.ConnectionTrapESP:Disconnect(); _G.Celestial.ConnectionTrapESP = nil end
			if _G.Celestial.ConnectionTrapDescendant then _G.Celestial.ConnectionTrapDescendant:Disconnect(); _G.Celestial.ConnectionTrapDescendant = nil end
			if _G.Celestial.GameDetectionConnection then _G.Celestial.GameDetectionConnection:Disconnect(); _G.Celestial.GameDetectionConnection = nil end
			if _G.Celestial.ScanGui then _G.Celestial.ScanGui:Destroy(); _G.Celestial.ScanGui = nil end
			ScreenGui:Destroy()
		end)

		secPlayer.Visible = true
	end)

	if not successUI then
		warn("Error al construir la UI de Celestial:", errorMsg)
	end

	_G.Celestial.ScanCounter = 0
	_G.Celestial.ScanCounterThread = task.spawn(function()
		while true do
			task.wait(0.1)
			pcall(function()
				local now = tick()
				if RealPlayerScan.PauseUntil > 0 and now >= RealPlayerScan.PauseUntil then
					ResetRealPlayerScanDisplay()
				end
				_G.Celestial.ScanCounter = RealPlayerScan.Count
			end)
		end
	end)
end)

State.AntiFlingActive = true
State.PowerDetectorActive = true

print("✨ CELESTIAL FRAMEWORK V19.18.16 - DUAL GAME MODE + SELF ESP + LOBBY DETECTION ✨")
