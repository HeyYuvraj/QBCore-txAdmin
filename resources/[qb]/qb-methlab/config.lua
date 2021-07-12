Config = Config or {}

Config.MinZOffset = 30
Config.CurrentLab = 0
Config.CooldownActive = false

Config.Locations = {
    ["laboratories"] = {
        [1] = {
            coords = vector4(321.72, -305.87, 52.50, 94.5),
        },
    },
    ["exit"] = {
        coords = vector4(997.01, -3200.65, -36.4, 275.5), 
    },
    ["break"] = {
        coords = vector4(1016.04, -3194.95, -38.99, 275.5), 
    },
    ["laptop"] = {
        coords = vector4(1002.0, -3194.87, -39.0, 2.5),
        inUse = false,
    }
}

Config.Tasks = {
    ["Furnace"] = {
        label = "Furnace",
        completed = false,
        started = false,
        -- ingredients = {
        --     current = 0,
        --     needed = 1,
        -- },
        coords = vector4(1005.72, -3200.38, -38.52, 124.5),
        timeremaining = 3,
        duration = 3,
        done = false,
    },
}

-- Config.Ingredients = {
--     ["lab"] = {
--         coords = {x = 998.11, y = -3200.27, z = -39.0, h = 85.5, r = 1.0},
--         taken = false,
--     }
-- }

-- Meth runs.
Config.StartMethPayment = 0 -- How much you pay at the start to start the run

Config.RunAmount = math.random(7,10) -- How many drop offs the player does before it automatixally stops.

Config.Payment = math.random(50, 120) -- How much you get paid when RN Jesus doesnt give you Meth, divided by 2 for when it does.

Config.Item = "ephedrine" -- The item you receive from the Meth run. Should be Meth right??
Config.MethChance = 999 -- Percentage chance of getting Meth on the run. Multiplied by 100. 10% = 100, 20% = 200, 50% = 500, etc. Default 55%.
Config.MethAmount = 1 -- How much Meth you get when RN Jesus gives you Meth. Default: 1.

Config.BigRewarditemChance = 1 -- Percentage of getting rare item on Meth run. Multiplied by 100. 0.1% = 1, 1% = 10, 20% = 200, 50% = 500, etc. Default 0.1%.
Config.BigRewarditem = "security_card_02" -- Put a rare item here which will have 0.1% chance of being given on the run.

Config.MethCars = "CHECK THE CODE" -- Cars

Config.DropOffs = "CHECK THE CODE" -- Drop off spots


--Robbery

Config.Pharmacy = {
    ["takeables"] = {
        [1] = {
            x = -170.39, 
            y = 6386.89, 
            z = 31.50,
            isDone = false,
            isBusy = false,
            reward =  {name = "psuedoephedrine", amount = 3},
        },
        [2] = {
            x = -174.28, 
            y = 6386.15, 
            z = 31.50,
            isDone = false,
            isBusy = false,
            reward =  {name = "psuedoephedrine", amount = 4},
        },
        [3] = {
            x = -175.06, 
            y = 6381.07, 
            z = 31.50,
            isDone = false,
            isBusy = false,
            reward =  {name = "psuedoephedrine", amount = 3},
        },
        [4] = {
            x = -176.59, 
            y = 6382.70, 
            z = 31.50,
            isDone = false,
            isBusy = false,
            reward =  {name = "psuedoephedrine", amount = 5},
        },
        [5] = {
            x = -176.37, 
            y = 6383.89, 
            z = 31.50,
            isDone = false,
            isBusy = false,
            reward =  {name = "psuedoephedrine", amount = 4},
        },
    },
}
