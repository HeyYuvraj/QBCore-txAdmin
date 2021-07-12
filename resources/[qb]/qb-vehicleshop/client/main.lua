PlayerJob = {}
isLoggedIn = true
local inVehicleShop = false

vehicleCategorys = {
    ["coupes"] = {
        label = "Coupes",
        vehicles = {}
    },
    ["sedans"] = {
        label = "Sedans",
        vehicles = {}
    },
    ["muscle"] = {
        label = "Muscle",
        vehicles = {}
    },
    ["suvs"] = {
        label = "SUVs",
        vehicles = {}
    },
    ["compacts"] = {
        label = "Compacts",
        vehicles = {}
    },
    ["vans"] = {
        label = "Vans",
        vehicles = {}
    },
    ["super"] = {
        label = "Super",
        vehicles = {}
    },
    ["sports"] = {
        label = "Sports",
        vehicles = {}
    },
    ["sportsclassics"] = {
        label = "Sports Classics",
        vehicles = {}
    },
    ["motorcycles"] = {
        label = "Motorcycles",
        vehicles = {}
    },
    ["offroad"] = {
        label = "Offroad",
        vehicles = {}
    },
}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
    isLoggedIn = true
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for k, v in pairs(QBCore.Shared.Vehicles) do
        if v["shop"] == "pdm" then
            for cat,_ in pairs(vehicleCategorys) do
                if QBCore.Shared.Vehicles[k]["category"] == cat then
                    table.insert(vehicleCategorys[cat].vehicles, QBCore.Shared.Vehicles[k])
                end
            end
        end
    end
end)

function openVehicleShop(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        ui = bool
    })
end

function setupVehicles(vehs)
    SendNUIMessage({
        action = "setupVehicles",
        vehicles = vehs
    })
end

RegisterNUICallback('GetCategoryVehicles', function(data)
    setupVehicles(shopVehicles[data.selectedCategory])
end)

RegisterNUICallback('exit', function()
    openVehicleShop(false)
end)

RegisterNUICallback('buyVehicle', function(data)
    local vehicleData = data.vehicleData
    local garage = data.garage

    TriggerServerEvent('qb-vehicleshop:server:buyVehicle', vehicleData, garage)
    openVehicleShop(false)
end)

RegisterNetEvent('qb-vehicleshop:client:spawnBoughtVehicle')
AddEventHandler('qb-vehicleshop:client:spawnBoughtVehicle', function(vehicle)
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetEntityHeading(veh, QB.SpawnPoint.w)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    end, QB.SpawnPoint, true)
end)

Citizen.CreateThread(function()
    Dealer = AddBlipForCoord(QB.VehicleShop)
    SetBlipSprite (Dealer, 326)
    SetBlipDisplay(Dealer, 4)
    SetBlipScale  (Dealer, 0.75)
    SetBlipAsShortRange(Dealer, true)
    SetBlipColour(Dealer, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Premium Deluxe Motorsport")
    EndTextCommandSetBlipName(Dealer)
end)
