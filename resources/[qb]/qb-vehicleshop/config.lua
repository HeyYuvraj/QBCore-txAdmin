QB = {}
QBCustom = {}

QB.DefaultGarage = 'centralgarage'
QB.SpawnPoint = vector4(-59.18, -1109.71, 25.45, 68.5)
QB.DefaultBuySpawn = vector4(-56.79, -1109.85, 26.43, 71.5)
QBCustom.VehicleBuyLocation = vector4(-67.33, 82.17, 71.13, 64.51)

QB.VehicleShop = vector3(-56.71, -1096.6, 25.44)
QB.LuxuryShop = vector3(-63.59, 68.25, 73.06)

QB.GarageLabel = {
    ['motelgarage'] = 'Motel Garage',
    ['sapcounsel']  = 'San Andreas Parking Counsel',
}

QB.VehicleMenuCategories = {
    ['sports']  = {label = 'Sports'},
    ['super']   = {label = 'Super'},
    ['sedans']  = {label = 'Sedans'},
    ['coupes']  = {label = 'Coupes'},
    ['suvs']    = {label = 'SUV\'s'},
    ['offroad'] = {label = 'Offroad'},
}

QB.Classes = {
    [0] = 'compacts',  
    [1] = 'sedans',  
    [2] = 'suvs',  
    [3] = 'coupes',  
    [4] = 'muscle',  
    [5] = 'sportsclassics ', 
    [6] = 'sports',  
    [7] = 'super',  
    [8] = 'motorcycles',  
    [9] = 'offroad', 
    [10] = 'industrial',  
    [11] = 'utility',  
    [12] = 'vans',  
    [13] = 'cycles',  
    [14] = 'boats',  
    [15] = 'helicopters',  
    [16] = 'planes',  
    [17] = 'service',  
    [18] = 'emergency',  
    [19] = 'military',  
    [20] = 'commercial',  
    [21] = 'trains',  
}

QB.ShowroomVehicles = {
    [1] = {
        coords = vector4(-45.65, -1093.66, 25.44, 69.5),
        defaultVehicle = 'adder',
        chosenVehicle = 'adder',
        inUse = false,
    },
    [2] = {
        coords = vector4(-48.27, -1101.86, 25.44, 294.5),
        defaultVehicle = 'schafter2',
        chosenVehicle = 'schafter2',
        inUse = false,
    },
    [3] = {
        coords = vector4(-39.6, -1096.01, 25.44, 66.5),
        defaultVehicle = 'comet2',
        chosenVehicle = 'comet2',
        inUse = false,
    },
    [4] = {
        coords = vector4(-51.21, -1096.77, 25.44, 254.5),
        defaultVehicle = 'vigero',
        chosenVehicle = 'vigero',
        inUse = false,
    },
    [5] = {
        coords = vector4(-40.18, -1104.13, 25.44, 338.5),
        defaultVehicle = 't20',
        chosenVehicle = 't20',
        inUse = false,
    },
    [6] = {
        coords = vector4(-43.31, -1099.02, 25.44, 52.5),
        defaultVehicle = 'bati',
        chosenVehicle = 'bati',
        inUse = false,
    },
    [7] = {
        coords = vector4(-50.66, -1093.05, 25.44, 222.5),
        defaultVehicle = 'bati',
        chosenVehicle = 'bati',
        inUse = false,
    },
    [8] = {
        coords = vector4(-44.28, -1102.47, 25.44, 298.5),
        defaultVehicle = 'bati',
        chosenVehicle = 'bati',
        inUse = false,
    }
}

QBCustom.ShowroomPositions = {
    [1] = {
        coords = vector4(-75.96, 74.78, 71.27, 221.69),
        vehicle = 'italirsx',
        buying = false,
    }, 
    [2] = {
        coords = vector4(-66.52, 74.33, 71.0, 188.03),
        vehicle = 'italigtb',
        buying = false,
    }, 
    [3] = {
        coords = vector4(-71.83, 68.60, 71.12, 276.57),
        vehicle = 'nero',
        buying = false,
    }, 
    [4] = {
        coords = vector4(-59.95, 68.61, 71.24, 181.44),
        vehicle = 'comet2',
        buying = false,
    },
}