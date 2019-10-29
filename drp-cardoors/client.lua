-- /door [open/close] [0-5]

RegisterCommand("door", function(source, args)
  local player = GetPlayerPed(-1)
  if args[1] == "open" and IsPedSittingInAnyVehicle(player) then
    if args[2] == "0" then
      SetVehicleDoorOpen(GetVehiclePedIsIn(player, false), 0, false, false)
    elseif args[2] == "1" then
      SetVehicleDoorOpen(GetVehiclePedIsIn(player, false), 1, false, false)
    elseif args[2] == "2" then
      SetVehicleDoorOpen(GetVehiclePedIsIn(player, false), 2, false, false)
    elseif args[2] == "3" then
      SetVehicleDoorOpen(GetVehiclePedIsIn(player, false), 3, false, false)
    elseif args[2] == "4" then
      SetVehicleDoorOpen(GetVehiclePedIsIn(player, false), 4, false, false)
    elseif args[2] == "5" then
      SetVehicleDoorOpen(GetVehiclePedIsIn(player, false), 5, false, false)
    end
  elseif args[1] == "close" then
    if args[2] == "0" then
      SetVehicleDoorShut(GetVehiclePedIsIn(player, false), 0, false)
    elseif args[2] == "1" then
      SetVehicleDoorShut(GetVehiclePedIsIn(player, false), 1, false)
    elseif args[2] == "2" then
      SetVehicleDoorShut(GetVehiclePedIsIn(player, false), 2, false)
    elseif args[2] == "3" then
      SetVehicleDoorShut(GetVehiclePedIsIn(player, false), 3, false)
    elseif args[2] == "4" then
      SetVehicleDoorShut(GetVehiclePedIsIn(player, false), 4, false)
    elseif args[2] == "5" then
      SetVehicleDoorShut(GetVehiclePedIsIn(player, false), 5, false)
    end
  end
end)
