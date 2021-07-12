local InsideMethlab = true
local ClosestMethlab = 0
local CurrentTask = 0
local UsingLaptop = false
local CarryPackage = nil
local loadIngredients = false
local machinetimer = 0

local NeededAttempts = 0
local SucceededAttempts = 0
local FailedAttemps = 0

local tasking = false
local drugStorePed = 0
local methVehicle = 0



function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    TriggerServerEvent("qb-methlab:server:LoadLocationList")
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

function SetClosestMethlab()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    for id, methlab in pairs(Config.Locations["laboratories"]) do
        if current ~= nil then
            if #(pos - vector3(Config.Locations["laboratories"][id].coords.x, Config.Locations["laboratories"][id].coords.y, Config.Locations["laboratories"][id].coords.z)) < dist then
                current = id
                dist = #(pos - vector3(Config.Locations["laboratories"][id].coords.x, Config.Locations["laboratories"][id].coords.y, Config.Locations["laboratories"][id].coords.z))
            end
        else
            dist = #(pos - vector3(Config.Locations["laboratories"][id].coords.x, Config.Locations["laboratories"][id].coords.y, Config.Locations["laboratories"][id].coords.z))
            current = id
        end
    end
    ClosestMethlab = current
end

Citizen.CreateThread(function()
    Wait(500)
    QBCore.Functions.TriggerCallback('qb-methlab:server:GetData', function(data)
        Config.CurrentLab = data.CurrentLab
        --print('Lab entry has been set to location: '..data.CurrentLab)
    end)

    CurrentTask = GetCurrentTask()

    --print('Current Task: '..CurrentTask)

    while true do
        SetClosestMethlab()
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    Config.CurrentLab = math.random(1, #Config.Locations["laboratories"])

    while true do
        local inRange = false
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        -- Exit distance check
        if InsideMethlab then
            if #(pos - vector3(Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z)) < 20 then
                inRange = true
                if #(pos - vector3(Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z)) < 1 then
                    DrawText3Ds(Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z, '~g~E~w~ - Leave methlab')
                    if IsControlJustPressed(0, 38) then
                        ExitMethlab()
                    end
                end
            end
        end

        -- Laptop distance check
        if InsideMethlab then
            if #(pos - vector3(Config.Locations["laptop"].coords.x, Config.Locations["laptop"].coords.y, Config.Locations["laptop"].coords.z)) < 20 then
                inRange = true
                DrawMarker(2, Config.Locations["laptop"].coords.x, Config.Locations["laptop"].coords.y, Config.Locations["laptop"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 222, 11, 11, 155, false, false, false, true, false, false, false)
                if GetDistanceBetweenCoords(pos - vector3(Config.Locations["laptop"].coords.x, Config.Locations["laptop"].coords.y, Config.Locations["laptop"].coords.z)) < 1 then
                    DrawText3Ds(Config.Locations["laptop"].coords.x - 0.04, Config.Locations["laptop"].coords.y + 0.45, Config.Locations["laptop"].coords.z, '~g~E~w~ - Use laptop')
                    if IsControlJustPressed(0, 38) then
                        OpenLaptop()
                    end
                end
            end
        end
			
        -- break Meth
        if InsideMethlab then
            if #(pos - vector3(Config.Locations["break"].coords.x, Config.Locations["break"].coords.y, Config.Locations["break"].coords.z)) < 20 then
                inRange = true
                DrawMarker(2, Config.Locations["break"].coords.x, Config.Locations["break"].coords.y, Config.Locations["break"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 222, 11, 11, 155, false, false, false, true, false, false, false)
                if #(pos - vector3(Config.Locations["break"].coords.x, Config.Locations["break"].coords.y, Config.Locations["break"].coords.z)) < 1 then
                    DrawText3Ds(Config.Locations["break"].coords.x - 0.06, Config.Locations["break"].coords.y + 0.90, Config.Locations["break"].coords.z, '~g~G~w~ - Break Meth ')
                    if IsControlJustPressed(0, 47) then
                        TriggerServerEvent("qb-methlab:server:breakMeth")
                    end
                end
            end
        end

        if InsideMethlab then
            if #(pos - vector3(Config.Tasks["Furnace"].coords.x, Config.Tasks["Furnace"].coords.y, Config.Tasks["Furnace"].coords.z)) < 20 then
                inRange = true
                DrawMarker(2, Config.Tasks["Furnace"].coords.x, Config.Tasks["Furnace"].coords.y,  Config.Tasks["Furnace"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 222, 11, 11, 155, false, false, false, true, false, false, false)
                DrawText3Ds(Config.Tasks["Furnace"].coords.x, Config.Tasks["Furnace"].coords.y,  Config.Tasks["Furnace"].coords.z, Config.Tasks["Furnace"].label)
                if  not machineStarted then
                    if not loadIngredients then
                        if #(pos - vector3(Config.Tasks["Furnace"].coords.x, Config.Tasks["Furnace"].coords.y, Config.Tasks["Furnace"].coords.z)) < 1 then
                            DrawText3Ds(Config.Tasks["Furnace"].coords.x, Config.Tasks["Furnace"].coords.y,  Config.Tasks["Furnace"].coords.z + 0.2, '[G] Load Ingredients')
                            if IsControlJustPressed(0, 47) then
                                TriggerServerEvent("qb-methlab:server:loadIngredients")
                            end
                        end
                    else
                        if not finishedMachine then
                            if #(pos - vector3(Config.Tasks["Furnace"].coords.x, Config.Tasks["Furnace"].coords.y, Config.Tasks["Furnace"].coords.z)) < 1 then
                                DrawText3Ds(Config.Tasks["Furnace"].coords.x, Config.Tasks["Furnace"].coords.y,  Config.Tasks["Furnace"].coords.z + 0.2, '[E] Start Machine')
                                if IsControlJustPressed(0, 38) then
                                    StartMachine()
                                end
                            end
                        else
                            if #(pos - vector3(Config.Tasks["Furnace"].coords.x, Config.Tasks["Furnace"].coords.y, Config.Tasks["Furnace"].coords.z)) < 1 then
                                DrawText3Ds(Config.Tasks["Furnace"].coords.x, Config.Tasks["Furnace"].coords.y,  Config.Tasks["Furnace"].coords.z + 0.2, '[E] Get Meth')
                                if IsControlJustPressed(0, 38) then
                                    TriggerServerEvent("qb-methlab:server:receivemethtray")
                                    finishedMachine = false
                                    loadIngredients = false
                                    machineStarted = false
                                end
                            end
                        end
                    end
                else
                    DrawText3Ds(Config.Tasks["Furnace"].coords.x, Config.Tasks["Furnace"].coords.y, Config.Tasks["Furnace"].coords.z - 0.4, 'Ready over '..machinetimer..'s')
                end
            end
        end

        if not inRange then
            Citizen.Wait(1000)
        end

        Citizen.Wait(3)
    end
end)

RegisterNetEvent('qb-methlab:client:breakMeth')
AddEventHandler('qb-methlab:client:breakMeth', function()
    PrepareAnim()
    BreakMinigame()
end)

RegisterNetEvent('qb-methlab:client:loadIngredients')
AddEventHandler('qb-methlab:client:loadIngredients', function()
    ProcessMinigame()
end)

function BreakMinigame()
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(3, 5)
        -- NeededAttempts = 1
    end

    local maxwidth = 10
    local maxduration = 3500

    Skillbar.Start({
        duration = math.random(700, 800),
        pos = math.random(10, 30),
        width = math.random(8, 12),
    }, function()

        if SucceededAttempts + 1 >= NeededAttempts then

            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0

            local random = math.random(8, 12)
            breakingMeth(random)
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(700, 800),
                pos = math.random(10, 30),
                width = math.random(8, 12),
            })
        end  
        
	end, function()
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0

            local random = math.random(6, 10)
            breakingMeth(random)

            ClearPedTasks(PlayerPedId())
    end)
end

function breakingMeth(amount)
    QBCore.Functions.Progressbar("break_meth", "Breaking Meth ..", math.random(10000, 12000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("qb-methlab:server:getmethtray", amount)
        ClearPedTasks(PlayerPedId())
    end, function() -- Cancel
    end)
end

function PrepareAnim()
    local ped = PlayerPedId()
    LoadAnim('anim@heists@prison_heiststation@cop_reactions')
    TaskPlayAnim(ped, 'anim@heists@prison_heiststation@cop_reactions', 'cop_b_idle', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
    -- TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    -- PreparingAnimCheck()
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function ProcessMinigame()
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(3, 4)
        -- NeededAttempts = 1
    end

    local maxwidth = 10
    local maxduration = 3500

    Skillbar.Start({
        duration = math.random(700, 800),
        pos = math.random(10, 30),
        width = math.random(8, 12),
    }, function()

        if SucceededAttempts + 1 >= NeededAttempts then

            QBCore.Functions.Notify("You loaded the ingredients!", "success")
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
            loadIngredients = true
            machinetimer = 120

        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(700, 800),
                pos = math.random(10, 30),
                width = math.random(8, 12),
            })
        end
                
        
	end, function()

            QBCore.Functions.Notify("You loaded the ingredients!", "success")
            machinetimer = 120
            loadIngredients = true
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
       
    end)
end

function StartMachine()
    Citizen.CreateThread(function()
        machineStarted = true
        while machinetimer > 0 do
            machinetimer = machinetimer - 1
            Citizen.Wait(1000)
        end
        machineStarted = false
        finishedMachine = true
    end)
end

function FinishMachine(k)
    Config.Tasks[k].done = false
    Config.Tasks[k].timeremaining = Config.Tasks[k].duration
    Config.Tasks[k].ingredients.current = 0

    if CurrentTask + 1 > #Config.Tasks then
        Config.CooldownActive = true
    else
        print('next task')
    end
end

RegisterNetEvent('qb-methlab:client:UseLabKey')
AddEventHandler('qb-methlab:client:UseLabKey', function(labkey)
    if ClosestMethlab == Config.CurrentLab then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        local dist = #(pos - vector3(Config.Locations["laboratories"][ClosestMethlab].coords.x, Config.Locations["laboratories"][ClosestMethlab].coords.y, Config.Locations["laboratories"][ClosestMethlab].coords.z))
        if dist < 1 then
            if labkey == ClosestMethlab then
                EnterMethlab()
            else
                QBCore.Functions.Notify('This is not the correct key..', 'error')
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        nearMethDoor = false
       
            local MethDoor = #(pos - vector3(321.72,-305.87,52.50))

            if MethDoor <= 6 then
                nearMethDoor = true

                if MethDoor <= 1 then
                    -- if not interacting then
                        -- if dealerIsHome then
                        DrawText3Ds(321.72,-305.87,52.50, '[E]')

                        if IsControlJustPressed(0, 38) then
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)
                    
                            local dist = #(pos - vector3(Config.Locations["laboratories"][ClosestMethlab].coords.x, Config.Locations["laboratories"][ClosestMethlab].coords.y, Config.Locations["laboratories"][ClosestMethlab].coords.z))
                            if dist < 1 then
                                -- if labkey == ClosestMethlab then
                                    EnterMethlab()
                                -- else
                                    -- QBCore.Functions.Notify('This is not the correct key..', 'error')
                                -- end
                            end
                        end
                        -- end
                    -- end
                end
            end

        if not nearMethDoor then
            dealerIsHome = false
            Citizen.Wait(2000)
        end

        Citizen.Wait(3)
    end
end)

function OpenLaptop()
    if not UsingLaptop then
        local ped = PlayerPedId()
        local dict = "mp_prison_break"
        local anim = "hack_loop"
        local flag = 0

        SetEntityCoords(ped, Config.Locations["laptop"].coords.x, Config.Locations["laptop"].coords.y, Config.Locations["laptop"].coords.z - 0.98, 0.0, 0.0, 0.0, false)
        SetEntityHeading(ped, Config.Locations["laptop"].coords.w)

        LoadAnimationDict(dict)
        TaskPlayAnim(ped, dict, anim, 2.0, 2.0, -1, flag, 0, false, false, false)

        Citizen.Wait(400)
        SendNUIMessage({
            action = "open",
            tasks = Config.Tasks,
        })
        SetNuiFocus(true, true)
        UsingLaptop = true
    end
end

function CloseLaptop()
    local ped = PlayerPedId()
    local dict = "mp_prison_break"
    local flag = 0

    TaskPlayAnim(ped, dict, "exit", 8.0, 8.0, -1, flag, 0, false, false, false)

    SetNuiFocus(false, false)
    UsingLaptop = false
end

RegisterNUICallback('Close', CloseLaptop)

function EnterMethlab()
    local ped = PlayerPedId()

    OpenDoorAnimation()
    InsideMethlab = true
    Citizen.Wait(500)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    SetEntityCoords(ped, Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z - 0.98)
    SetEntityHeading(ped, Config.Locations["exit"].coords.w)
    Citizen.Wait(1000)
    DoScreenFadeIn(250)
end

function ExitMethlab()
    local ped = PlayerPedId()
    local dict = "mp_heists@keypad@"
    local anim = "idle_a"
    local flag = 0
    local keypad = {
        coords = {x = 996.92, y = -3199.85, z = -36.4, h = 94.5, r = 1.0}, 
    }

    CurrentTask = GetCurrentTask()

    SetEntityCoords(ped, keypad.coords.x, keypad.coords.y, keypad.coords.z - 0.98)
    SetEntityHeading(ped, keypad.coords.w)

    LoadAnimationDict(dict) 

    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, flag, 0, false, false, false)
    Citizen.Wait(2500)
    TaskPlayAnim(ped, dict, "exit", 2.0, 2.0, -1, flag, 0, false, false, false)
    Citizen.Wait(1000)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    SetEntityCoords(ped, Config.Locations["laboratories"][Config.CurrentLab].coords.x, Config.Locations["laboratories"][Config.CurrentLab].coords.y, Config.Locations["laboratories"][Config.CurrentLab].coords.z - 0.98)
    SetEntityHeading(ped, Config.Locations["laboratories"][Config.CurrentLab].coords.w)
    InsideMethlab = false
    Citizen.Wait(1000)
    DoScreenFadeIn(250)
end

function LoadAnimationDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function OpenDoorAnimation()
    local ped = PlayerPedId()

    LoadAnimationDict("anim@heists@keycard@") 
    TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0)
    Citizen.Wait(400)
    ClearPedTasks(ped)
end

function GetCurrentTask()
    local currenttask = nil
    for k, v in pairs(Config.Tasks) do
        if not v.completed then
            currenttask = k
            break
        end
    end
    return currenttask
end

function TakeIngredients()
    local pos = GetEntityCoords(PlayerPedId(), true)
    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
        Citizen.Wait(7)
    end
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("prop_cs_cardbox_01")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
    AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.05, 0.1, -0.3, 300.0, 250.0, 20.0, true, true, false, true, 1, true)
    CarryPackage = object
end

function DropIngredients()
    ClearPedTasks(PlayerPedId())
    DetachEntity(CarryPackage, true, true)
    DeleteObject(CarryPackage)
    CarryPackage = nil
end

-- function RequestLocation()

-- end

local MethDropOffs = {
    [1] =  { ['x'] = 1524.52,['y'] = -2114.09,['z'] = 76.60,['h'] = 69.11, ['info'] = ' 2' },
	[2] =  { ['x'] = 1168.66,['y'] = -1347.02,['z'] = 34.92,['h'] = 92.72, ['info'] = ' 3' },
	[3] =  { ['x'] = 1240.72,['y'] = -369.56,['z'] = 69.09,['h'] = 219.63, ['info'] = ' 4' },
	[4] =  { ['x'] = -1188.29,['y'] = -741.63,['z'] = 20.22,['h'] = 328.40, ['info'] = ' 5' },
	[5] =  { ['x'] = -1297.43,['y'] = -320.48,['z'] = 36.72,['h'] = 167.38, ['info'] = ' 6' },
	[6] =  { ['x'] = -584.60,['y'] = -898.68,['z'] = 25.70,['h'] = 175.35, ['info'] = ' 7' },
	[7] =  { ['x'] = -1156.17,['y'] = -1419.80,['z'] = 4.81,['h'] = 32.40, ['info'] = ' 8' },
	[8] =  { ['x'] = -467.05,['y'] = -1719.73,['z'] = 18.67,['h'] = 291.37, ['info'] = ' chewy1' },
	[9] =  { ['x'] = -1421.79,['y'] = -195.57,['z'] = 47.14,['h'] = 0.68, ['info'] = ' biscuts2' },
	[10] =  { ['x'] = -2963.78,['y'] = 63.95,['z'] = 11.61,['h'] = 336.46, ['info'] = ' are3' },
	[11] =  { ['x'] = -1094.21,['y'] = -505.57,['z'] = 35.88,['h'] = 25.22, ['info'] = ' only4' },
	[12] =  { ['x'] = -26.89,['y'] = -81.34,['z'] = 57.25,['h'] = 151.08, ['info'] = ' nice5' },
	[13] =  { ['x'] = 18.11,['y'] = -604.55,['z'] = 31.73,['h'] = 340.12, ['info'] = ' ifthey6' },
	[14] =  { ['x'] = 152.48,['y'] = -1478.61,['z'] = 29.36,['h'] = 230.74, ['info'] = ' contain7' },
	[15] =  { ['x'] = 558.88,['y'] = -1560.31,['z'] = 29.24,['h'] = 354.38, ['info'] = ' chocolate' },

}

local MethWorker = { ['x'] = 858.60,['y'] = -3202.55,['z'] = 5.99,['h'] = 356.84, ['info'] = 'boop bap' }

local carspawns = {
	[1] =  { ['x'] = 904.64,['y'] = -3210.75,['z'] = 5.90,['h'] = 181.21, ['info'] = ' car 1' },
    [2] =  { ['x'] = 900.77,['y'] = -3210.41,['z'] = 5.90,['h'] = 181.21, ['info'] = ' car 2' },
    [3] =  { ['x'] = 896.24,['y'] = -3210.21,['z'] = 5.90,['h'] = 181.21, ['info'] = ' car 3' },
    [4] =  { ['x'] = 892.41,['y'] = -3211.16,['z'] = 5.90,['h'] = 181.21, ['info'] = ' car 4' },
}



local rnd = 0
local blip = 0
local deliveryPed = 0

local methPeds = {
	'mp_m_meth_01',
	'mp_m_meth_01'
}

local carpick = {
    [1] = "mule3",
}

function CreateMethVehicle()
	if DoesEntityExist(methVehicle) then
	    SetVehicleHasBeenOwnedByPlayer(methVehicle,false)
		SetEntityAsNoLongerNeeded(methVehicle)
		DeleteEntity(methVehicle)
	end

    local car = GetHashKey(carpick[math.random(#carpick)])
    RequestModel(car)
    while not HasModelLoaded(car) do
        Citizen.Wait(0)
    end

    local spawnpoint = 1
    for i = 1, #carspawns do
	    local caisseo = GetClosestVehicle(carspawns[i]["x"], carspawns[i]["y"], carspawns[i]["z"], 3.500, 0, 70)
		if not DoesEntityExist(caisseo) then
			spawnpoint = i
		end
    end

    methVehicle = CreateVehicle(car, carspawns[spawnpoint]["x"], carspawns[spawnpoint]["y"], carspawns[spawnpoint]["z"], carspawns[spawnpoint]["h"], true, false)
    local plt = GetVehicleNumberPlateText(methVehicle)
		SetVehicleHasBeenOwnedByPlayer(methVehicle,true)
		SetVehicleNeedsToBeHotwired(methVehicle, false)
		SetVehRadioStation(methVehicle, "OFF")
		exports['LegacyFuel']:SetFuel(methVehicle, 100)
		TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(methVehicle))

    while true do
    	Citizen.Wait(1)
    	 DrawText3Ds(carspawns[spawnpoint]["x"], carspawns[spawnpoint]["y"], carspawns[spawnpoint]["z"], "Your Delivery Car (Stolen).")
    	 if #(GetEntityCoords(PlayerPedId()) - vector3(carspawns[spawnpoint]["x"], carspawns[spawnpoint]["y"], carspawns[spawnpoint]["z"])) < 8.0 then
    	 	return
    	 end
	end

end

function PoliceCall(vehicle)

            local pos = GetEntityCoords(PlayerPedId())
            local chance = 20
			local msg = ""
			local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
			local streetLabel = GetStreetNameFromHashKey(s1)
			local street2 = GetStreetNameFromHashKey(s2)
			if street2 ~= nil and street2 ~= "" then 
				streetLabel = streetLabel .. " " .. street2
			end
			local alertTitle = ""

				local vehicle = vehicle
				local modelName = GetEntityModel(vehicle)
				if QBCore.Shared.VehicleModels[modelName] ~= nil then
					Name = QBCore.Shared.Vehicles[QBCore.Shared.VehicleModels[modelName]["model"]]["brand"] .. ' ' .. QBCore.Shared.Vehicles[QBCore.Shared.VehicleModels[modelName]["model"]]["name"]
				else
					Name = "Unknown"
				end
				local modelPlate = GetVehicleNumberPlateText(vehicle)
				local msg = "10-31 | Vehicle Spotted Selling Drugs At " ..streetLabel.. ". Vehicle: " .. Name .. ", License Plate: " .. modelPlate
				local alertTitle = " Drug Selling"
				TriggerServerEvent("police:server:VehicleCall", pos, msg, alertTitle, streetLabel, modelPlate, Name)

end

function CreateMethPed()

    local hashKey = `s_m_y_factory_01`

    local pedType = 3

    RequestModel(hashKey)
    while not HasModelLoaded(hashKey) do
        RequestModel(hashKey)
        Citizen.Wait(100)
    end


    deliveryPed = CreatePed(pedType, hashKey, MethDropOffs[rnd]["x"],MethDropOffs[rnd]["y"],MethDropOffs[rnd]["z"], MethDropOffs[rnd]["h"], 0, 0)
    
    
	

    ClearPedTasks(deliveryPed)
    ClearPedSecondaryTask(deliveryPed)
    TaskSetBlockingOfNonTemporaryEvents(deliveryPed, true)
    SetPedFleeAttributes(deliveryPed, 0, 0)
    SetPedCombatAttributes(deliveryPed, 17, 1)

    SetPedSeeingRange(deliveryPed, 0.0)
    SetPedHearingRange(deliveryPed, 0.0)
    SetPedAlertness(deliveryPed, 0)
    SetPedKeepTask(deliveryPed, true)

end

function DeleteCreatedPed()
	--print("Deleting Ped?")
	if DoesEntityExist(deliveryPed) then 
		SetPedKeepTask(deliveryPed, false)
		TaskSetBlockingOfNonTemporaryEvents(deliveryPed, false)
		ClearPedTasks(deliveryPed)
		TaskWanderStandard(deliveryPed, 10.0, 10)
		SetPedAsNoLongerNeeded(deliveryPed)

		Citizen.Wait(20000)
		DeletePed(deliveryPed)
	end
end

function DeleteBlip()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
	end
end

function CreateBlip()
	DeleteBlip()
	if MethRun then
        blip = AddBlipForCoord(MethDropOffs[rnd]["x"],MethDropOffs[rnd]["y"],MethDropOffs[rnd]["z"])

        local x = MethDropOffs[rnd]["x"]
        local y = MethDropOffs[rnd]["y"]
        local z = MethDropOffs[rnd]["z"]
        
        waitingDelivery = {
            ["coords"] = {x = MethDropOffs[rnd]["x"], y = MethDropOffs[rnd]["y"], z = MethDropOffs[rnd]["z"]}
        }
      
        SetTimeout(2000, function()
            TriggerServerEvent('qb-phone:server:sendNewMail', {
                sender = "Johnny",
                subject = "Delivery Location",
                message = "Make sure you are on time!",
                button = {
                    enabled = true,
                    buttonEvent = "qb-methlab:client:setLocation",
                    buttonData = waitingDelivery
                }
            })
        end)
	end
    
    SetBlipSprite(blip, 514)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Drop Off")
    EndTextCommandSetBlipName(blip)
end

RegisterNetEvent('qb-methlab:client:setLocation')
AddEventHandler('qb-methlab:client:setLocation', function(locationData)
    setMapBlip(locationData["coords"].x, locationData["coords"].y)
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function playerAnim()
	loadAnimDict( "mp_safehouselost@" )
    TaskPlayAnim( PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
end

function giveAnim()
    if ( DoesEntityExist( deliveryPed ) and not IsEntityDead( deliveryPed ) ) then 
        loadAnimDict( "mp_safehouselost@" )
        if ( IsEntityPlayingAnim( deliveryPed, "mp_safehouselost@", "package_dropoff", 3 ) ) then 
            TaskPlayAnim( deliveryPed, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        else
            TaskPlayAnim( deliveryPed, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        end     
    end
end

function DoDropOff()
	local success = true
	local MethChance = math.random(1,1000)

	Citizen.Wait(1000)
	playerAnim()
	Citizen.Wait(800)

	PlayAmbientSpeech1(deliveryPed, "Chat_State", "Speech_Params_Force")

	if DoesEntityExist(deliveryPed) and not IsEntityDead(deliveryPed) then

		local counter = math.random(50,200)
		while counter > 0 do
			local crds = GetEntityCoords(deliveryPed)
			counter = counter - 1
			Citizen.Wait(1)
		end
	
		if success then
			local counter = math.random(100,300)
			while counter > 0 do
				local crds = GetEntityCoords(deliveryPed)
				counter = counter - 1
				Citizen.Wait(1)
			end
			giveAnim()
		end
	
		local crds = GetEntityCoords(deliveryPed)
		local crds2 = GetEntityCoords(PlayerPedId())
	
		if #(crds - crds2) > 3.0 or not DoesEntityExist(deliveryPed) or IsEntityDead(deliveryPed) then
			success = false
		end
		
		DeleteBlip()
		
		local chancecall = (math.random(0, 100))

		if chancecall <= 4 then
			PoliceCall(methVehicle)
		end

		if success then

			if MethChance <= Config.BigRewarditemChance then
				TriggerServerEvent("qb-methlab:server:receiveBigRewarditem")
            else
                TriggerServerEvent("qb-methlab:server:receivemeth")
			end

			Citizen.Wait(2000)

			QBCore.Functions.Notify('The delivery was on point, your pager will be updated with the next drop off', 'success', 2500)
		else
			QBCore.Functions.Notify('The drop off failed', 'error', 2500)
		end
	
		DeleteCreatedPed()
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

RegisterNetEvent("qb-methlab:client:client")
AddEventHandler("qb-methlab:client:client", function()

	if tasking then
		return
	end
	
	rnd = math.random(1,#MethDropOffs)

	CreateBlip()

	local pedCreated = false

	tasking = true
	local toolong = 120000
	while tasking do

		Citizen.Wait(1)
		local plycoords = GetEntityCoords(PlayerPedId())
		local dstcheck = #(plycoords - vector3(MethDropOffs[rnd]["x"],MethDropOffs[rnd]["y"],MethDropOffs[rnd]["z"])) 
		local methVehCoords = GetEntityCoords(methVehicle)
		local dstcheck2 = #(plycoords - methVehCoords) 

		local veh = GetVehiclePedIsIn(PlayerPedId(),false)
		if dstcheck < 40.0 and not pedCreated and (methVehicle == veh or dstcheck2 < 15.0) then
			pedCreated = true
			DeleteCreatedPed()
			CreateMethPed()
			QBCore.Functions.Notify("You are close to the drop off")
		end
		toolong = toolong - 1
		if toolong <= 0 then

		    SetVehicleHasBeenOwnedByPlayer(methVehicle,false)
			SetEntityAsNoLongerNeeded(methVehicle)
			tasking = false
			MethRun = false
			QBCore.Functions.Notify('You are no longer selling meth due to taking too long to drop off', 'error', 2500)
			DeleteBlip()
		end
		if dstcheck < 2.0 and pedCreated then

			local crds = GetEntityCoords(deliveryPed)
			DrawText3Ds(crds["x"],crds["y"],crds["z"], "[E]")  

			if not IsPedInAnyVehicle(PlayerPedId()) and IsControlJustReleased(0,38) then
				TaskTurnPedToFaceEntity(deliveryPed, PlayerPedId(), 1.0)
				Citizen.Wait(1500)
				PlayAmbientSpeech1(deliveryPed, "Generic_Hi", "Speech_Params_Force")
				DoDropOff()
				tasking = false
			end

		end

	end
	

	DeleteCreatedPed()
	DeleteBlip()

end)

RegisterNetEvent('qb-drugs:client:sendDeliveryMail')
AddEventHandler('qb-drugs:client:sendDeliveryMail', function(type, deliveryData)
    if type == 'perfect' then
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = "Danny",
            subject = "Delivery",
            message = "Thanks dog lets do some more buisness soon ;)<br><br> Danny"
        })
    elseif type == 'bad' then
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Config.Dealers[deliveryData["dealer"]]["name"],
            subject = "Delivery",
            message = "I got some complaints about your delivery, don't let this happen again..."
        })
    elseif type == 'late' then
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Config.Dealers[deliveryData["dealer"]]["name"],
            subject = "Delivery",
            message = "You were not on time.. Seems like you had something more important to do?"
        })
    end
end)

Citizen.CreateThread(function()

    while true do

	    Citizen.Wait(1)
	    local dropOff6 = #(GetEntityCoords(PlayerPedId()) - vector3(MethWorker["x"],MethWorker["y"],MethWorker["z"]))

		if dropOff6 < 1.6 and not MethRun then

			DrawText3Ds(MethWorker["x"],MethWorker["y"],MethWorker["z"], "[E] Delivery Illegal Chemicals (Payment Cash)") 
			if IsControlJustReleased(0,38) then
				TriggerServerEvent("qb-methlab:server:server")
				Citizen.Wait(1000)
			end
		end

    end

end)

local firstdeal = false
Citizen.CreateThread(function()


    while true do

        if drugdealer then

	        Citizen.Wait(1000)

	        if firstdeal then
	        	Citizen.Wait(10000)
	        end

	        TriggerEvent("drugdelivery:client")  

		    salecount = salecount + 1
		    if salecount == 12 then
		    	Citizen.Wait(600000)
		    	drugdealer = false
		    end

		    Citizen.Wait(150000)
		    firstdeal = false

		elseif MethRun then

			if not DoesEntityExist(methVehicle) or GetVehicleEngineHealth(methVehicle) < 200.0 or GetVehicleBodyHealth(methVehicle) < 200.0 then
				MethRun = false
				tasking = false
				QBCore.Functions.Notify('The dealer isnt giving you anymore locations due to the state of his car', 'error', 3500)
			else
				if tasking then
			        Citizen.Wait(30000)
			    else
			        TriggerEvent("qb-methlab:client:client")  
				    salecount = salecount + 1
					if salecount == Config.RunAmount then
						QBCore.Functions.Notify('You are on your last delivery!', 'error', 3500)
				    	Citizen.Wait(420000)
						MethRun = false
				    end
				end
			end

	    else

	    	local close = false


			if not close then
				Citizen.Wait(2000)
			end

	    end

    end

end)

RegisterNetEvent("qb-methlab:client:startDealing")
AddEventHandler("qb-methlab:client:startDealing", function()
    local NearNPC = GetClosestPed()

	PlayAmbientSpeech1(NearNPC, "Chat_Resp", "SPEECH_PARAMS_FORCE", 1)
	salecount = 0
	MethRun = true
	firstdeal = true
	QBCore.Functions.Notify('A car has been left outside for you. Your pager will be updated with locations soon', 'success', 2500)
	CreateMethVehicle()
end)

function setMapBlip(x, y)
    SetNewWaypoint(x, y)
    QBCore.Functions.Notify('The delivery location is marked on your GPS.', 'success');
end

function deliveryTimer()
    Citizen.CreateThread(function()
        while true do

            if deliveryTimeout - 1 > 0 then
                deliveryTimeout = deliveryTimeout - 1
            else
                deliveryTimeout = 0
                break
            end

            Citizen.Wait(1000)
        end
    end)
end

-- ROBBERY

-- Citizen.CreateThread(function()
--     local inRange = false
--     while true do
--         Citizen.Wait(1)
--         if isLoggedIn then
--             local pos = GetEntityCoords(PlayerPedId())
--             for spot, location in pairs(Config.Pharmacy["takeables"]) do
--                 local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Pharmacy["takeables"][spot].x, Config.Pharmacy["takeables"][spot].y,Config.Pharmacy["takeables"][spot].z, true)
--                 if dist < 1.0 then
--                     inRange = true
--                     if dist < 0.6 then
--                         if not Config.Pharmacy["takeables"][spot].isBusy and not Config.Pharmacy["takeables"][spot].isDone then
--                             DrawText3Ds(Config.Pharmacy["takeables"][spot].x, Config.Pharmacy["takeables"][spot].y,Config.Pharmacy["takeables"][spot].z, '~g~E~w~ To grab item')
--                             if IsControlJustPressed(0, 38) then
--                                 if CurrentCops >= 0 then
--                                     TriggerServerEvent('qb-methlab:server:PoliceAlertMessage', 'People try to steal items at the Pharmacy in Palteo', pos, true)
--                                         currentSpot = spot
--                                         GrabItem(currentSpot)
--                                 else
--                                     QBCore.Functions.Notify("Not enough Police", "error")
--                                 end
--                             end
--                         end
--                     end
--                 end
--             end

--             if not inRange then
--                 Citizen.Wait(2000)
--             end

--         end
--     end
-- end)

-- function GrabItem(spot)
--     local pos = GetEntityCoords(PlayerPedId())
--     QBCore.Functions.Progressbar("grab_pills", "Grabbing Pills", 5000, false, true, {
--         disableMovement = true,
--         disableCarMovement = true,
--         disableMouse = false,
--         disableCombat = true,
--     }, {
--         animDict = "anim@gangops@facility@servers@",
--         anim = "hotwire",
--         flags = 16,
--     }, {}, {}, function() -- Done
--         StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
--         TriggerServerEvent('qb-methlab:server:setSpotState', "isDone", true, spot)
--         TriggerServerEvent('qb-methlab:server:setSpotState', "isBusy", false, spot)
--         TriggerServerEvent('qb-methlab:server:itemReward', spot)
--     end, function() -- Cancel
--         StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
--         TriggerServerEvent('qb-methlab:server:setSpotState', "isBusy", false, spot)
--         QBCore.Functions.Notify("Canceled..", "error")
--     end)
-- end

-- RegisterNetEvent('qb-methlab:client:setSpotState')
-- AddEventHandler('qb-methlab:client:setSpotState', function(stateType, state, spot)
--     if stateType == "isBusy" then
--         Config.Pharmacy["takeables"][spot].isBusy = state
--     elseif stateType == "isDone" then
--         Config.Pharmacy["takeables"][spot].isDone = state
--     end
-- end)

-- RegisterNetEvent('qb-methlab:client:PoliceAlertMessage')
-- AddEventHandler('qb-methlab:client:PoliceAlertMessage', function(msg, coords, blip)
--     if blip then
--         PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
--         TriggerEvent("chatMessage", "911-Report", "error", msg)
--         local transG = 100
--         local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0)
--         SetBlipSprite(blip, 9)
--         SetBlipColour(blip, 1)
--         SetBlipAlpha(blip, transG)
--         SetBlipAsShortRange(blip, false)
--         BeginTextCommandSetBlipName('STRING')
--         AddTextComponentString("911 - Robbery At The Pharmacy In Paleto")
--         EndTextCommandSetBlipName(blip)
--         while transG ~= 0 do
--             Wait(180 * 4)
--             transG = transG - 1
--             SetBlipAlpha(blip, transG)
--             if transG == 0 then
--                 SetBlipSprite(blip, 2)
--                 RemoveBlip(blip)
--                 return
--             end
--         end
--     else
--         if not robberyAlert then
--             PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
--             TriggerEvent("chatMessage", "911-Report", "error", msg)
--             robberyAlert = true
--         end
--     end 
-- end)
