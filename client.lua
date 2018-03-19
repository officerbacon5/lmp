---------------------------
-- POLICE MANAGEMENT API --
---------------------------
local pluginName = 'policeSystem'

local isCop = false
local isFire = false
local isAdmin = false

local callsign
local department

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('pm:isCop', GetPlayerServerId(PlayerId()), pluginName .. ':isCop', pluginName .. ':isNotCop')
	TriggerServerEvent('pm:isAdmin', GetPlayerServerId(PlayerId()), pluginName .. ':isAdmin', pluginName .. ':isNotAdmin')
	TriggerServerEvent('pm:isFire', GetPlayerServerId(PlayerId()), pluginName .. ':isFire', pluginName .. ':isNotFire')
end)

RegisterNetEvent(pluginName..':isCop')
AddEventHandler(pluginName..':isCop', function(callsignR, departmentR)
    callsign = callsignR
    department = departmentR
    isCop = true
end)

RegisterNetEvent(pluginName..':isNotCop')
AddEventHandler(pluginName..':isNotCop', function()
    isCop = false
end)

RegisterNetEvent(pluginName..':isFire')
AddEventHandler(pluginName..':isFire', function(callsignR, departmentR)
    callsign = callsignR
    department = departmentR
    isFire = true
end)

RegisterNetEvent(pluginName..':isNotFire')
AddEventHandler(pluginName..':isNotFire', function()
    isFire = false
end)

RegisterNetEvent(pluginName..':isAdmin')
AddEventHandler(pluginName..':isAdmin', function()
    isAdmin = true
end)

RegisterNetEvent(pluginName..':isNotAdmin')
AddEventHandler(pluginName..':isNotAdmin', function()
    isAdmin = false
end)

-- Variables
local handcuffed = false
local officer = -1
local id = 'This user did not set their ID!'
local deletegun = false
local copidle = false
local volume = 1.0

-- Commands
RegisterCommand('update', function()
    TriggerServerEvent('pm:isCop', GetPlayerServerId(PlayerId()), pluginName .. ':isCop', pluginName .. ':isNotCop')
	TriggerServerEvent('pm:isAdmin', GetPlayerServerId(PlayerId()), pluginName .. ':isAdmin', pluginName .. ':isNotAdmin')
	TriggerServerEvent('pm:isFire', GetPlayerServerId(PlayerId()), pluginName .. ':isFire', pluginName .. ':isNotFire')
	
	if isCop == true then
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are a cop')
	else
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are not a cop')
	end

	if isFire == true then
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are a firefighter')
	else
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are not a firefighter')
	end
	
	if isAdmin == true then
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are an admin')
	else
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are not an admin')
	end
end)

RegisterCommand('cuff', function()
	if isCop == true then
		closest, distance = GetClosestPlayer()
		if closest ~= nil and DoesEntityExist(GetPlayerPed(closest)) then
			if distance -1 and distance < 3 then
				TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You cuffed the nearest player. (' .. GetPlayerName(closest) .. ')')
				local closestID = GetPlayerServerId(closest)
				TriggerServerEvent('cuffServer', closestID)
			else
				TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'Nearest player is too far away.')
			end
		end
	else
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are not a cop.')
	end
end)

RegisterCommand('uncuff', function()
	if isCop == true then
		closest, distance = GetClosestPlayer()
		if closest ~= nil and DoesEntityExist(GetPlayerPed(closest)) then
			if distance -1 and distance < 3 then
				TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You uncuffed the nearest player.  (' .. GetPlayerName(closest) .. ')')
				local closestID = GetPlayerServerId(closest)
				TriggerServerEvent('unCuffServer', closestID)
			end
		end
	else
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are not a cop.')
	end
end)

RegisterCommand('showid', function()
    closest = GetClosestPlayer()
    if closest ~= nil and DoesEntityExist(GetPlayerPed(closest)) then
		local closestID = GetPlayerServerId(closest)
        TriggerServerEvent('showIDMessage', id)
    end
end)

RegisterCommand('drag', function(source, args, rawCommand)
	if isCop == true then
		closest, distance = GetClosestPlayer()
		if closest ~= nil and DoesEntityExist(GetPlayerPed(closest)) then
			if distance -1 and distance < 3 then
				local closestID = GetPlayerServerId(closest)
				local pP = GetPlayerPed(-1)
				TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are dragging the nearest player. (' .. GetPlayerName(closest) .. ')')
				TriggerServerEvent('dragServer', closestID)
			else
				TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'Nearest player is too far away.')
			end
		end
	else
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are not a cop.')
	end
end)

RegisterCommand('seat', function(source, args, rawCommand)
	if isCop then
		closest, distance = GetClosestPlayer()
		if closest ~= nil and DoesEntityExist(GetPlayerPed(closest)) then
			if distance -1 and distance < 3 then
				local closestID = GetPlayerServerId(closest)
				local pP = GetPlayerPed(-1)
				local veh = GetVehiclePedIsIn(pP, true)
				TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You forced the player you are dragging into the nearest vehicle. (' .. GetPlayerName(closest) .. ')')
				TriggerServerEvent('seatServer', closestID, veh)
			else
				TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'Nearest player is too far away.')
			end
		end
	else
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are not a cop.')
	end
end)

RegisterCommand('unseat', function(source, args, rawCommand)
	if isCop then
		closest, distance = GetClosestPlayer()
		if closest ~= nil and DoesEntityExist(GetPlayerPed(closest)) then
			if distance -1 and distance < 3 then
				local closestID = GetPlayerServerId(closest)
				TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You forced the player in the nearest vehicle out of the vehicle. (' .. GetPlayerName(closest) .. ')')
				TriggerServerEvent('unSeatServer', closestID)
			else
				TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'Nearest player is too far away.')
			end
		end
	else
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are not a cop.')
	end
end)


RegisterCommand('undrag', function()
	if isCop == true then
		closest, distance = GetClosestPlayer()
		if closest ~= nil and DoesEntityExist(GetPlayerPed(closest)) then
			if distance -1 and distance < 3 then
				TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are no longer dragging the nearest player. (' .. GetPlayerName(closest) .. ')')
				local closestID = GetPlayerServerId(closest)
				TriggerServerEvent('unDragServer', closestID)
			else
				TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'Nearest player is too far away.')
			end
		end
	else
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are not a cop.')
	end
end)

RegisterCommand('pb', function()
    x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    streethash = GetStreetNameAtCoord(x, y, z)
    street = GetStreetNameFromHashKey(streethash)
    TriggerServerEvent('panicServer', street)
end, false)

RegisterCommand('cone', function()
	if isCop == true then
		local pP = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(pP, true))
		local heading = GetEntityHeading(pP)
		local cone = CreateObject(GetHashKey('prop_mp_cone_01'), x, y, z-2, true, true, true)
		PlaceObjectOnGroundProperly(cone)
		SetEntityHeading(cone, heading)
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You placed a cone.')
	else
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are not a cop.')
	end
end)

RegisterCommand('barrier', function()
	if isCop == true then
		local pP = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(pP, true))
		local heading = GetEntityHeading(pP)
		local barrier = CreateObject(GetHashKey('prop_barrier_work05'), x, y, z-2, true, true, true)
		PlaceObjectOnGroundProperly(barrier)
		SetEntityHeading(barrier, heading)
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You placed a barrier.')
	else
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are not a cop.')
	end
end)

RegisterCommand('deletegun', function() -- Thanks to 'murfasa' https://forum.fivem.net/t/release-fx-cfx-gun-delete-object/39422
	if isCop == true or isAdmin == true then
		deletegun = not deletegun
		local pP = GetPlayerPed(-1)
		if deletegun == true then
			TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You toggled the delete gun on.')
		else
			TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You toggled the delete gun off.')
		end
		while deletegun == true do
			Citizen.Wait(0)
			if IsPlayerFreeAiming(PlayerId()) then
				local target = getEntityPlayerAimingAt(PlayerId())
				if IsPedShooting(pP) then
					SetEntityAsMissionEntity(target, true, true)
					DeleteEntity(target)
				end
			end
		end
	else
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are not a cop.')
	end
end)

RegisterCommand('copidle', function()
	if isCop == true then
		copidle = not copidle
		local pP = GetPlayerPed(-1)
		if copidle == true then
			ClearPedTasks(pP)
			TaskStartScenarioInPlace(pP, 'WORLD_HUMAN_COP_IDLES', 0, true)
			TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You started doing the cop idle animation.')
		else
			ClearPedTasks(pP)
		end	
	else
		TriggerEvent('chatMessage', 'Police System', {255, 255, 255}, 'You are not a cop.')
	end
end)
	

-- Events
AddEventHandler('playerSpawned', function()
	local id = KeyboardInput('Roleplay Name:', '', 20)
end)

RegisterNetEvent('cuffClient')
AddEventHandler('cuffClient', function()
	local pP = GetPlayerPed(-1)
	RequestAnimDict('mp_arresting')
	while not HasAnimDictLoaded('mp_arresting') do
		Citizen.Wait(100)
	end
	TaskPlayAnim(pP, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
	SetEnableHandcuffs(pP, true)
	SetCurrentPedWeapon(pP, GetHashKey('WEAPON_UNARMED'), true)
	DisablePlayerFiring(pP, true)
	FreezeEntityPosition(pP, true)
	handcuffed = true
end)

RegisterNetEvent('unCuffClient')
AddEventHandler('unCuffClient', function()
	local pP = GetPlayerPed(-1)
	ClearPedSecondaryTask(pP)
	SetEnableHandcuffs(pP, false)
	SetCurrentPedWeapon(pP, GetHashKey('WEAPON_UNARMED'), true)
	FreezeEntityPosition(pP, false)
	handcuffed = false
end)

RegisterNetEvent('dragClient')
AddEventHandler('dragClient', function(closestID)
	local officer = closestID
	local officerPed = GetPlayerPed(GetPlayerFromServerId(officer))
	local pP = GetPlayerPed(-1)
	drag = true
	if handcuffed then
		while drag == true do
			Citizen.Wait(0)
			if IsPedDeadOrDying then
				drag = false
			end
			AttachEntityToEntity(pP, officerPed, 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		end
	end
end)

RegisterNetEvent('seatClient')
AddEventHandler('seatClient', function(veh)
	if handcuffed == true then
		local pP = GetPlayerPed(-1)
		local pos = GetEntityCoords(pP)
		local entityWorld = GetOffsetFromEntityInWorldCoords(pP, 0.0, 20.0, 0.0)
		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, pP, 0)
		local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
		local vehicle = GetVehiclePedIsIn(pP, false)
		
		DetachEntity(pP, true, false)
		Citizen.Wait(100)
		if vehicleHandle ~= nil then
			SetPedIntoVehicle(pP, vehicleHandle, 1)
		end
		SetVehicleDoorsLocked(vehicle, 4)
	end
end)

RegisterNetEvent('unSeatClient')
AddEventHandler('unSeatClient', function(closestID)
	if handcuffed then
		local pP = GetPlayerPed(-1)
		local pos = GetEntityCoords(pP)
		ClearPedTasksImmediately(pP)
		local xnew = pos.x + 2
		local ynew = pos.y + 2
		
		SetEntityCoords(pP, xnew, ynew, pos.z)
		SetEnableHandcuffs(pP, true)
		SetCurrentPedWeapon(pP, GetHashKey('WEAPON_UNARMED'), true)
		DisablePlayerFiring(pP, true)
		FreezeEntityPosition(pP, true)
		handcuffed = true
	end
end)

RegisterNetEvent('unDragClient')
AddEventHandler('unDragClient', function(closestID)
	local pP = GetPlayerPed(-1)
	drag = false
	DetachEntity(pP, true, false)
end)

RegisterNetEvent('putInClient')
AddEventHandler('putInClient', function(closestID, veh)
	local pP = GetPlayerPed(-1)
	local pos = GetEntityCoords(pP)
	local entityWorld = GetOffsetFromEntityInWorldCoords(pP, 0.0, 20.0, 0.0)
	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
	local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
	if vehicleHandle ~= nil then
		SetPedIntoVehicle(pP, vehicleHandle, 1)
	end
end)

RegisterNetEvent('panicButtonSound', function()
	SendNUIMessage({
		playpanicbutton = true,
		panicbuttonvolume = volume
		})
end)

RegisterNetEvent('showIDClient')
AddEventHandler('showIDClient', function()
	TriggerEvent('chatMessage', 'ID', {255, 255, 255}, GetPlayerName(sourceID) .. ' has showed you their ID.')
end)

-- Threads

-- Functions
function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
    DisplayOnscreenKeyboard(1, 'FMMC_KEY_TIP1', '', ExampleText, '', '', '', MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

function getEntityPlayerAimingAt(player)
	local result, target = GetEntityPlayerIsFreeAimingAt(player)
	return target
end