ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Create Blips here if you want
--[[Citizen.CreateThread(function()
    local blip = AddBlipForCoord(2433.91, 4965.50, 42.00)

    SetBlipSprite (blip, 357)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 59)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Grandmas House")
    EndTextCommandSetBlipName(blip)
    
end)]]--

function Draw3DText(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
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
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 68)
end
local coords = { x = 2433.91, y = 4965.50, z = 42.00, h = 43.69 }

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local plyCoords = GetEntityCoords(PlayerPedId(), 0)
        local distance = #(vector3(coords.x, coords.y, coords.z) - plyCoords)
        if distance < 10 then

            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                if distance < 3 then
			        Draw3DText(coords.x, coords.y, coords.z + 0.5, '[E] - Check in for $1,000')
                        if IsControlJustReleased(0, 54) then
                            DisableControlAction(0, 54, true)
                            if (GetEntityHealth(PlayerPedId()) <= 200) then
                                exports['mythic_progbar']:Progress({
                                    name = "grandmas_house",
                                    duration = 10500,
                                    label = "Checking In",
                                    useWhileDead = true,
                                    canCancel = true,
                                    controlDisables = {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    },
                                    animation = {
                                        animDict = "missheistdockssetup1clipboard@base",
                                        anim = "base",
                                        flags = 49,
                                    },
                                    prop = {
                                        model = "p_amb_clipboard_01",
                                        bone = 18905,
					                    coords = { x = 0.10, y = 0.02, z = 0.08 },
					                    rotation = { x = -80.0, y = 0.0, z = 0.0 },
                                    },
                                    propTwo = {
                                        model = "prop_pencil_01",
                                        bone = 58866,
					                    coords = { x = 0.12, y = 0.0, z = 0.001 },
					                    rotation = { x = -150.0, y = 0.0, z = 0.0 },
                                    },
                                }, function(status)
                                    if not status then
                                        exports['progressBars']:startUI(60000, "Treating, Do not move")
                                        Citizen.Wait(60000)
                                        --your revive script code goes here
                                        TriggerEvent('esx_ambulancejob:revive')
                                        --end revive code
                                        TriggerServerEvent('drp-grandmas:payBill')
                                        EnableControlAction(0, 54, true)
                                    end
                                end)
                            else
                                exports['mythic_notify']:DoHudText('error', 'You do not need medical attention')
                            end
                        end
                    end
                end
            else
                Citizen.Wait(1000)
            end
    end
end)