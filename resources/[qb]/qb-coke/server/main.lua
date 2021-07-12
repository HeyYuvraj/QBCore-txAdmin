local ItemList = {
    ["cocaleaf"] = "cocaleaf"
}

local DrugList = {
    ["cokebaggy"] = "cokebaggy"
}


RegisterServerEvent('qb-coke:server:grindleaves')
AddEventHandler('qb-coke:server:grindleaves', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cocaleaf = Player.Functions.GetItemByName('cocaleaf')

    if Player.PlayerData.items ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if cocaleaf ~= nil then
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    if Player.PlayerData.items[k].name == "cocaleaf" and Player.PlayerData.items[k].amount >= 2 then 
                        Player.Functions.RemoveItem("cocaleaf", 2)
                        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['cocaleaf'], "remove")

                        TriggerClientEvent("qb-coke:client:grindleavesMinigame", src)
                    else
                        TriggerClientEvent('QBCore:Notify', src, "You dont have enough coca leaves", 'error')
                        break
                    end
                end
            else
                TriggerClientEvent('QBCore:Notify', src, "You do not have coca leaf", 'error')
                break
            end
        end
    end
end)

RegisterServerEvent('qb-coke:server:processCrack')
AddEventHandler('qb-coke:server:processCrack', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cokebaggy = Player.Functions.GetItemByName('cokebaggy')

    if Player.PlayerData.gang.name == "ballas" then
        if Player.PlayerData.items ~= nil then 
            if cokebaggy ~= nil then 
                if cokebaggy.amount >= 2 then 

                    Player.Functions.RemoveItem("cokebaggy", 2, false)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['cokebaggy'], "remove")

                    TriggerClientEvent("qb-coke:client:processCrack", src)
                else
                    TriggerClientEvent('QBCore:Notify', src, "You do not have the correct items", 'error')   
                end
            else
                TriggerClientEvent('QBCore:Notify', src, "You do not have the correct items", 'error')   
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "You Have Nothing...", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "You might need to talk to a gang member...", 'error')   
        
    end
end)

RegisterServerEvent('qb-coke:server:cokesell')
AddEventHandler('qb-coke:server:cokesell', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cokebaggy = Player.Functions.GetItemByName('cokebaggy')

    if Player.PlayerData.items ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if cokebaggy ~= nil then
                if DrugList[Player.PlayerData.items[k].name] ~= nil then 
                    if Player.PlayerData.items[k].name == "cokebaggy" and Player.PlayerData.items[k].amount >= 1 then 
                        local random = math.random(50, 65)
                        local amount = Player.PlayerData.items[k].amount * random

                        TriggerClientEvent('chatMessage', source, "Dealer Johnny", "normal", 'Yo '..Player.PlayerData.firstname..', damn you got '..Player.PlayerData.items[k].amount..'bags of coke')
                        TriggerClientEvent('chatMessage', source, "Dealer Johnny", "normal", 'Ill buy all of it for $'..amount )

                        Player.Functions.RemoveItem("cokebaggy", Player.PlayerData.items[k].amount)
                        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['cokebaggy'], "remove")
                        Player.Functions.AddMoney("cash", amount)
                        break
                    else
                        TriggerClientEvent('QBCore:Notify', src, "You do not have coke", 'error')
                        break
                    end
                end
            else
                TriggerClientEvent('QBCore:Notify', src, "You do not have coke", 'error')
                break
            end
        end
    end
end)


RegisterServerEvent('qb-coke:server:getleaf')
AddEventHandler('qb-coke:server:getleaf', function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("cocaleaf", 10)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['cocaleaf'], "add")
end)

RegisterServerEvent('qb-coke:server:getcoke')
AddEventHandler('qb-coke:server:getcoke', function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("cokebaggy", 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['cokebaggy'], "add")
end)

RegisterServerEvent('qb-coke:server:getcrack')
AddEventHandler('qb-coke:server:getcrack', function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("crack_baggy", 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['crack_baggy'], "add")
end)

