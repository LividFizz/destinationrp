local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX					= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	-- Update the door list
	ESX.TriggerServerCallback('esx_doorlock:getDoorInfo', function(doorInfo, count)
		for localID = 1, count, 1 do
			if doorInfo[localID] ~= nil then
				Config.DoorList[doorInfo[localID].doorID].locked = doorInfo[localID].state
			end
		end
	end)
end)

RegisterNetEvent('esx_doorlock:currentlyhacking')
AddEventHandler('esx_doorlock:currentlyhacking', function(mycb)
			mycb = true
			TriggerEvent("mhacking:show") --This line is where the hacking even starts
			TriggerEvent("mhacking:start",7,19,mycb1) --This line is the difficulty and tells it to start. First number is how long the blocks will be the second is how much time they have is.
end)

function DrawText3DTest(coords, text, size)

    local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
function DrawText3D(coords, text, size)

    local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z + 1.0)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

RegisterNetEvent( 'dooranim' )
AddEventHandler( 'dooranim', function()
    
    ClearPedSecondaryTask(GetPlayerPed(-1))
    loadAnimDict( "anim@heists@keycard@" ) 
    TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(850)
    ClearPedTasks(GetPlayerPed(-1))

end)

function isKeyDoor(num)
    if num == 0 then
        return false
    end
    if doorID.objName == "prop_gate_prison_01" then
        return false
    end
    if doorTypes[num]["doorType"] == "v_ilev_fin_vaultdoor" then
        return false
    end
    if doorTypes[num]["doorType"] == "hei_prop_station_gate" then
        return false
    end
    return true
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local closestString = "None"

		for i=1, #Config.DoorList do
			local doorID   = Config.DoorList[i]
			local distance = GetDistanceBetweenCoords(playerCoords, doorID.objCoords.x, doorID.objCoords.y, doorID.objCoords.z, true)
			local isAuthorized = IsAuthorized(doorID)

			local maxDistance = 1.25
			if doorID.distance then
				maxDistance = doorID.distance
			end

			if distance < maxDistance then
				ApplyDoorState(doorID)

				local size = 1
				if doorID.size then
					size = doorID.size
				end
				if doorID.locked then 
					closestString = "[E] - Locked"
					DrawText3DTest(doorID.textCoords, closestString, size) 
				elseif doorID.locked == false then 
					closestString = "[E] - Unlocked"
					DrawText3DTest(doorID.textCoords, closestString, size) 
				end
				
				
				if  IsControlJustReleased(1,  38) and isAuthorized then
					local displayText
					if doorID.locked == true then
						displayText = _U('locked')
						local active = true
						local swingcount = 0
						TriggerEvent("dooranim")
						doorID.locked = false
                        while active do
                            Citizen.Wait(1)

                            locked, heading = GetStateOfClosestDoorOfType(GetHashKey(doorID.objName, doorID.objCoords.x, doorID.objCoords.y, doorID.objCoords.z)) 
                            heading = math.ceil(heading * 100) 
                            DrawText3DTest(doorID.textCoords, "Unlocking", size)
                            
                            local dist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), doorID.objCoords.x, doorID.objCoords.y, doorID.objCoords.z, true)
                            local dst2 = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 1830.45, 2607.56, 45.59,true)

                            if heading < 1.5 and heading > -1.5 then
                                swingcount = swingcount + 1
                            end             
                            if dist > 150.0 or swingcount > 100 or dst2 < 200.0 then
                                active = false
                            end
						end

                    elseif doorID.locked == false then

                        local active = true
						local swingcount = 0
						TriggerEvent("dooranim")
						doorID.locked = true
                        while active do
                            Citizen.Wait(1)
                            DrawText3DTest(doorID.textCoords, "Locking", size)
                            swingcount = swingcount + 1
                            if swingcount > 100 then
                                active = false
                            end
						end

					end
					TriggerServerEvent('esx_doorlock:updateState', i, doorID.locked)
				end

				if isAuthorized then
					--displayText = _U('press_button', displayText)
				end	
			end
		end
	end
end)

function ApplyDoorState(doorID)
	local closeDoor = GetClosestObjectOfType(doorID.objCoords.x, doorID.objCoords.y, doorID.objCoords.z, 1.0, GetHashKey(doorID.objName), false, false, false)
	FreezeEntityPosition(closeDoor, doorID.locked)
end

function IsAuthorized(doorID)
	if ESX.PlayerData.job == nil then
		return false
	end



	for i=1, #doorID.authorizedJobs, 1 do
		if doorID.authorizedJobs[i] == ESX.PlayerData.job.name then
			return true
		end
	end

	return false
end


-- Set state for a door
RegisterNetEvent('esx_doorlock:setState')
AddEventHandler('esx_doorlock:setState', function(doorID, state)
	Config.DoorList[doorID].locked = state
end)






