local vehicles = {
  "adder",
  "futo",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
--  "Vehicle Name",
 -- "Vehicle Name",
  "zentorno"
  -- Make sure the last one does not have a , or it will break.
}

local selectvehicle = 1
local vehicleseconds = 0
local spawnedvehicle = nil

Citizen.CreateThread(function()
  while true do 
    Citizen.Wait(5)
    local dist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 109.47, -1090.69, 29.30, true)
    -- add money check here
    if dist < 5.0 then
      DrawText3Ds(109.47, -1090.69, 29.50, "Vehicle: ~g~"..vehicles[selectvehicle])
      DrawText3Ds(109.47, -1090.69, 29.30, "Press [E] to rent the vehicle")
      DrawText3Ds(109.47, -1090.69, 29.10, "Press [~g~Left Arrow~w~] or [~g~Right Arrow~w~] to scroll")
      if IsControlJustReleased(0, 307) then
        selectvehicle = selectvehicle +1
        if selectvehicle == 4 then
          selectvehicle = 1
        end
      end
      if IsControlJustReleased(0, 308) then
        selectvehicle = selectvehicle -1
        if selectvehicle == 0 then
          selectvehicle = 3
        end
      end
      if IsControlJustReleased(0, 38) then
        -- Add if statement and remove money here
        createVehicle()
      end
    end
  end
end)

RegisterCommand("checktime", function (source, args, rawcommand)
  if spawnedvehicle ~= nil then
  TriggerEvent("DoLongHudText", "You have "..vehicleseconds.." seconds left until the vehicle is returned" , 1)
  else
    TriggerEvent("DoLongHudText", "You have not rented a vehicle." , 2)
  end
end)

function createVehicle() 
    while not HasModelLoaded(GetHashKey(vehicles[selectvehicle])) do
        RequestModel(GetHashKey(vehicles[selectvehicle]))
        Wait(10)
    end

    local vehicle = CreateVehicle(GetHashKey(vehicles[selectvehicle]), 110.99, -1081.95, 29.19, 340.48, true, false)
    spawnedvehicle = vehicle
    Citizen.Wait(1000)
    TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
    -- TestDriveTimer(CHANGEME, vehicle)
    -- How to increase rental time. Seconds not milsecs.
    TestDriveTimer(30, vehicle)
end

function TestDriveTimer(seconds, vehicle)
  seconds = seconds -1
  vehicleseconds = seconds
  Citizen.Wait(1000)
  if seconds == 0 then
    DeleteVehicle(vehicle)
    SetEntityCoords(GetPlayerPed(-1), 109.47, -1090.69, 29.30, 0, 0, 0, true)
    spawnedvehicle = nil
  else
    TestDriveTimer(seconds, vehicle)
  end
end

function DrawText3Ds(x,y,z, text)
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
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)

end