isCreatingGang = false
hasStash = false
hasGarage = false
gang = nil
name = nil
label = nil

RegisterNetEvent("qb-gangs:client:BeginGangCreation")
AddEventHandler("qb-gangs:client:BeginGangCreation", function(gangName, gangLabel)
    name = gangName
    label = gangLabel
    gang = {
        ["VehicleSpawner"] = {},
        ["Stash"] = {}
    }
    isCreatingGang = true
    TriggerEvent("chatMessage", "SYSTEM", "warning", "New Gang: "..gangName.." added, use /placestash, /placegarage,  /finishgang or /cancelgang")
end)

RegisterCommand("placestash", function()
    if isCreatingGang then
        if not hasStash then
            local plyCoords = GetEntityCoords(PlayerPedId())
            
            gang["Stash"] = {
                label = name.." Stash",
                coords = {x = plyCoords.x, y = plyCoords.y, z = plyCoords.z, h = GetEntityHeading(PlayerPedId())}    
            }

            hasStash = true
            QBCore.Functions.Notify("Gang Stash Placed", "success")
        else
            QBCore.Functions.Notify("You have already placed the stash", "error")
        end
    else
        QBCore.Functions.Notify("You are not creating a gang", "error")
    end
end)

RegisterCommand("placegarage", function()
    if isCreatingGang then
        if not hasGarage then
            -- NUI To handle colour picker and vehicle selection
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "open"
            })
        else
            QBCore.Functions.Notify("You have already placed the garage", "error")
        end
    else
        QBCore.Functions.Notify("You are not creating a gang", "error")
    end
end)

RegisterCommand("finishgang", function()
    if isCreatingGang then
        if hasGarage and hasStash then
            TriggerServerEvent("qb-gangs:server:creategang", gang, name, label)
            gang = nil
            hasGarage, hasStash = false, false
        else
            QBCore.Functions.Notify("You are not finished", "error")
        end
    else
        QBCore.Functions.Notify("You are not creating a gang", "error")
    end
end)

RegisterCommand("cancelgang", function()
    if isCreatingGang then
        isCreatingGang, hasGarage, hasStash = false, false, false
        gang, name, label = nil, nil, nil
    else
        QBCore.Functions.Notify("You are not creating a gang", "error")
    end
end)

RegisterNUICallback("SetVehicleColour", function(data, cb)
    SetNuiFocus(false, false)
    -- Recieve arrays for colours and vehicles, js handlers spliting into arrays
    local primary = data.primary
    local secondary = data.secondary
    local vehicleList = data.vehicleList

    print(json.encode(vehicleList))

    local coords = GetEntityCoords(PlayerPedId())
    
    gang["VehicleSpawner"] = {
        label = "Car Spawn",
        coords = {x = coords.x, y = coords.y, z = coords.z, h = GetEntityHeading(PlayerPedId())},
        colours = {
            ["primary"] = {
                r = tonumber(primary[1]),
                g = tonumber(primary[2]), 
                b = tonumber(primary[3])
            },
            ["secondary"] = { 
                r = tonumber(secondary[1]),
                g = tonumber(secondary[2]), 
                b = tonumber(secondary[3])
            },
        },
        vehicles = {}
    }

    -- Iterate through vehicles array, check they are valid and insert into gang vehicles
    for k, v in pairs(vehicleList) do
        if QBCore.Shared.Vehicles[v] ~= nil then
            local name = QBCore.Shared.Vehicles[v].name
            gang["VehicleSpawner"]["vehicles"][v] = name
        else
            QBCore.Functions.Notify(v.." does not exist in qb-core/shared-modules/vehicles.lua", "error")
        end
    end

    hasGarage = true
    QBCore.Functions.Notify("Garage Placed", "success")

    cb("200 - OK")
end)

RegisterNUICallback("CloseMenu", function(source, cb)
    SetNuiFocus(false, false)

    cb("200 - OK")
end)