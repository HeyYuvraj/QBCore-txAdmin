local tasking = false
local drugStorePed = 0
local oxyVehicle = 0

local OxyDropOffs = {
	[1] =  { ['coords'] = vector4(74.5, -762.17, 31.68, 160.98), ['info'] = ' 1' },
	[2] =  { ['coords'] = vector4(100.58, -644.11, 44.23, 69.11), ['info'] = ' 2' },
	[3] =  { ['coords'] = vector4(175.45, -445.95, 41.1, 92.72), ['info'] = ' 3' },
	[4] =  { ['coords'] = vector4(130.3, -246.26,  51.45, 219.63), ['info'] = ' 4' },
	[5] =  { ['coords'] = vector4(198.1, -162.11, 56.35, 340.09), ['info'] = ' 5' },
	[6] =  { ['coords'] = vector4(341.0, -184.71, 58.07, 159.33), ['info'] = ' 6' },
	[7] =  { ['coords'] = vector4(-26.96, -368.45, 39.69, 251.12), ['info'] = ' 7' },
	[8] =  { ['coords'] = vector4(-155.88, -751.76, 33.76, 251.82), ['info'] = ' 8' },

	[9] =  { ['coords'] = vector4(-305.02, -226.17, 36.29, 306.04), ['info'] = ' chewy1' },
	[10] =  { ['coords'] = vector4(-347.19, -791.04, 33.97, 3.06), ['info'] = ' biscuts2' },
	[11] =  { ['coords'] = vector4(-703.75, -932.93, 19.22, 87.86), ['info'] = ' are3' },
	[12] =  { ['coords'] = vector4(-659.35, -256.83, 36.23, 118.92), ['info'] = ' only4' },
	[13] =  { ['coords'] = vector4(-934.18, -124.28, 37.77, 205.79), ['info'] = ' nice5' },
	[14] =  { ['coords'] = vector4(-1214.3, -317.57, 37.75, 18.39), ['info'] = ' ifthey6' },
	[15] =  { ['coords'] = vector4(-822.83, -636.97, 27.9, 160.23), ['info'] = ' contain7' },
	[16] =  { ['coords'] = vector4(308.04, -1386.09, 31.79, 47.23), ['info'] = ' chocolate' },

}

local carspawns = {
	[1] =  { ['coords'] = vector4(79.85, -1544.99, 29.47, 51.55), ['info'] = ' car 8' },
	[2] =  { ['coords'] = vector4(66.93, -1561.73, 29.47, 45.73), ['info'] = ' car 1' },
	[3] =  { ['coords'] = vector4(68.57, -1559.53, 29.47, 50.6), ['info'] = ' car 2' },
	[4] =  { ['coords'] = vector4(70.4, -1557.12, 29.47, 51.18), ['info'] = ' car 3' },
	[5] =  { ['coords'] = vector4(72.22, -1554.63, 29.47, 50.32), ['info'] = ' car 4' },
	[6] =  { ['coords'] = vector4(73.99, -1552.22, 29.47, 52.47), ['info'] = ' car 5' },
	[7] =  { ['coords'] = vector4(76.06, -1549.87, 29.47, 51.53), ['info'] = ' car 6' },
	[8] =  { ['coords'] = vector4(77.9, -1547.45, 29.47, 53.24), ['info'] = ' car 7' },
}

local pillWorker = { ['coords'] = vector4(68.7, -1569.87, 29.6, 230.65), ['info'] = 'boop bap' }

local rnd = 0
local blip = 0
local deliveryPed = 0

local oxyPeds = {
	'a_m_y_stwhi_02',
	'a_m_y_stwhi_01'
}


local drugLocs = {
	[1] =  { ['coords'] = vector4(131.94, -1937.95, 0, 118.59), ['info'] = ' Grove Stash' },
	[2] =  { ['coords'] = vector4(1390.84, -1507.94, 0, 29.6), ['info'] = ' East Side' },
	[3] =  { ['coords'] = vector4(-676.81, -877.94, 0, 324.9), ['info'] = ' Wei Cheng' },
}

local carpick = {
    [1] = "felon",
    [2] = "kuruma",
    [3] = "sultan",
    [4] = "granger",
    [5] = "tailgater",
}

function CreateOxyVehicle()

	if DoesEntityExist(oxyVehicle) then

	    SetVehicleHasBeenOwnedByPlayer(oxyVehicle,false)
		SetEntityAsNoLongerNeeded(oxyVehicle)
		DeleteEntity(oxyVehicle)
	end

    local car = GetHashKey(carpick[math.random(#carpick)])
    RequestModel(car)
    while not HasModelLoaded(car) do
        Citizen.Wait(0)
    end

    local spawnpoint = 1
    for i = 1, #carspawns do
	    local caisseo = GetClosestVehicle(carspawns[i]['coords']["x"], carspawns[i]['coords']["y"], carspawns[i]['coords']["z"], 3.500, 0, 70)
		if not DoesEntityExist(caisseo) then
			spawnpoint = i
		end
    end

    oxyVehicle = CreateVehicle(car, carspawns[spawnpoint]['coords']["x"], carspawns[spawnpoint]['coords']["y"], carspawns[spawnpoint]['coords']["z"], carspawns[spawnpoint]['coords']["w"], true, false)
    local plt = GetVehicleNumberPlateText(oxyVehicle)
    SetVehicleHasBeenOwnedByPlayer(oxyVehicle,true)

    while true do
    	Citizen.Wait(1)
    	 DrawText3Ds(carspawns[spawnpoint]['coords']["x"], carspawns[spawnpoint]['coords']["y"], carspawns[spawnpoint]['coords']["z"], "Your Delivery Car (Stolen).")
    	 if #(GetEntityCoords(PlayerPedId()) - vector3(carspawns[spawnpoint]['coords']["x"], carspawns[spawnpoint]['coords']["y"], carspawns[spawnpoint]['coords']["z"])) < 8.0 then
    	 	return
    	 end
    end

end

function CreateOxyPed()

    local hashKey = `a_m_y_stwhi_01`

    local pedType = 5

    RequestModel(hashKey)
    while not HasModelLoaded(hashKey) do
        RequestModel(hashKey)
        Citizen.Wait(100)
    end


	deliveryPed = CreatePed(pedType, hashKey, OxyDropOffs[rnd]['coords']["x"],OxyDropOffs[rnd]['coords']["y"],OxyDropOffs[rnd]['coords']["z"], OxyDropOffs[rnd]['coords']["w"], 0, 0)
	

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
	if OxyRun then
		blip = AddBlipForCoord(OxyDropOffs[rnd]['coords']["x"],OxyDropOffs[rnd]['coords']["y"],OxyDropOffs[rnd]['coords']["z"])
	end
    
    SetBlipSprite(blip, 51)
	SetBlipScale(blip, 1.0)
	SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Drop Off")
    EndTextCommandSetBlipName(blip)
end

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
	local OxyChance = math.random(1,1000)

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
		if success then

			if OxyChance <= Config.OxyChance then
				TriggerServerEvent("oxydelivery:receiveoxy")
			elseif OxyChance <= Config.BigRewarditemChance then
				TriggerServerEvent("oxydelivery:receiveBigRewarditem")
			else
				TriggerServerEvent("oxydelivery:receivemoneyyy")
			end

			Citizen.Wait(2000)
			QBCore.Functions.Notify('The delivery was on point, your GPS will be updated with the next drop off', 'success')
		else
			QBCore.Functions.Notify('The Drop Off Failed', 'error')
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

RegisterNetEvent("oxydelivery:client")
AddEventHandler("oxydelivery:client", function()

	if tasking then
		return
	end
	
	rnd = math.random(1,#OxyDropOffs)

	CreateBlip()

	local pedCreated = false

	tasking = true
	local toolong = 600000
	while tasking do

		Citizen.Wait(1)
		local plycoords = GetEntityCoords(PlayerPedId())
		local dstcheck = #(plycoords - vector3(OxyDropOffs[rnd]['coords']["x"],OxyDropOffs[rnd]['coords']["y"],OxyDropOffs[rnd]['coords']["z"])) 
		local oxyVehCoords = GetEntityCoords(oxyVehicle)
		local dstcheck2 = #(plycoords - oxyVehCoords) 

		local veh = GetVehiclePedIsIn(PlayerPedId(),false)
		if dstcheck < 40.0 and not pedCreated and (oxyVehicle == veh or dstcheck2 < 15.0) then
			pedCreated = true
			DeleteCreatedPed()
			CreateOxyPed()
			QBCore.Functions.Notify('You Are Close To The Drop Off Point')
		end
		toolong = toolong - 1
		if toolong < 0 then

		    SetVehicleHasBeenOwnedByPlayer(oxyVehicle,false)
			SetEntityAsNoLongerNeeded(oxyVehicle)
			tasking = false
			OxyRun = false
			QBCore.Functions.Notify('You Took Too Long', 'error')
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

Citizen.CreateThread(function()

    while true do

	    Citizen.Wait(1)
	    local dropOff6 = #(GetEntityCoords(PlayerPedId()) - vector3(pillWorker['coords']["x"],pillWorker['coords']["y"],pillWorker['coords']["z"]))

		if dropOff6 < 1.6 and not OxyRun then

			DrawText3Ds(pillWorker['coords']["x"],pillWorker['coords']["y"],pillWorker['coords']["z"], "[E] $6,500 - Delivery Job (Payment Cash + Oxy)") 
			if IsControlJustReleased(0,38) then
				TriggerServerEvent("oxydelivery:server")
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

		elseif OxyRun then

			if not DoesEntityExist(oxyVehicle) or GetVehicleEngineHealth(oxyVehicle) < 200.0 or GetVehicleBodyHealth(oxyVehicle) < 200.0 then
				OxyRun = false
				tasking = false
				QBCore.Functions.Notify('The Car Is Too Damaged', 'error')
			else
				if tasking then
			        Citizen.Wait(30000)
			    else
			        TriggerEvent("oxydelivery:client")  
				    salecount = salecount + 1
				    if salecount == Config.RunAmount then
				    	Citizen.Wait(300000)
				    	OxyRun = false
				    end
				end
			end

	    else

	    	local close = false

	    	for i = 1, #drugLocs do

				local plycoords = GetEntityCoords(PlayerPedId())

				local dstcheck = #(plycoords - vector3(drugLocs[i]['coords']["x"],drugLocs[i]['coords']["y"],drugLocs[i]['coords']["z"])) 

			

				if dstcheck < 5.0 then

					close = true

					local job = QBCore.Functions.GetPlayerData().job.name

					if job ~= "police" then

						local price = 100

			    		DrawText3Ds(drugLocs[i]['coords']["x"],drugLocs[i]['coords']["y"],drugLocs[i]['coords']["z"], "[E] $" .. price .. " offer to sell stolen goods (12).") 
				    	
				    	if IsControlJustReleased(0,38) then

				    		local countpolice = exports["isPed"]:isPed("countpolice")
				    		local daytime = exports["isPed"]:isPed("daytime")

							if not daytime then
								QBCore.Functions.Notify('Come Back During The Day', 'error')
		            		else
		            			mygang = drugLocs[i]["gang"]
					    		TriggerServerEvent("drugdelivery:server",price,"robbery",50)
					    		Citizen.Wait(1500)
					    	end

				    	end

			    	else

			    		Citizen.Wait(60000)

			    	end

			    	Citizen.Wait(1)

			    end

			end

			if not close then
				Citizen.Wait(2000)
			end

	    end

    end

end)

RegisterNetEvent("oxydelivery:startDealing")
AddEventHandler("oxydelivery:startDealing", function()
    local NearNPC = GetClosestPed()

	PlayAmbientSpeech1(NearNPC, "Chat_Resp", "SPEECH_PARAMS_FORCE", 1)
	salecount = 0
	OxyRun = true
	firstdeal = true
	CreateOxyVehicle()
	QBCore.Functions.Notify('A Car Has Been Provided. Your GPS Will Be Updated With Locations Soon', 'success')
end)
