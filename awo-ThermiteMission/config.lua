    Config = Config or {}

Config.LogsImage = "" -- Image for log bot profile pic
Config.WebHook = "" -- Weebhook for logs

Config.Debug = false
Config.UseBlips = false

Config.FuelScript = 'LegacyFuel'

Config.PoliceType = 'leo' -- Police job
Config.RequiredPolice = 0 -- Needed cops to start the mission
Config.NextRob = 8 -- Time player can start the mission again (in seconds)

Config.Phone = 'qs-smartphone'      -- Only Works whit phone that have ":server:sendNewMail'" event!
Config.Inventory = "qb"         -- qb // New qb inv  Ox // Ox_inventory WIP

Config.ThermiteItem = 'thermite'
Config.MinEarn = 7
Config.MaxEarn = 10

Config.StartPeds = {  -- Start ped locations + model
    [1] = {
        Scenario = "WORLD_HUMAN_BINOCULARS", -- Scenario for the ped, more can be found at : https://wiki.rage.mp/index.php?title=Scenarios
        Icon = "fas fa-box", -- Icon for the target
        Label = "Start Thermite Mission", -- Label for the target
        Ped = "s_f_y_baywatch_01", -- Ped more can be found : https://docs.fivem.net/docs/game-references/ped-models/
        Coords = { -- Coords table  
            PedCoords = vector4(-1904.6, -710.28, 7.83, 129.59), -- Main coords for the ped vector3 format always
            Distance = 2.0, -- Distance to interact with the ped
        },
    },
    [2] = {
        Scenario = "WORLD_HUMAN_GOLF_PLAYER", -- Scenario for the ped, more can be found at : https://wiki.rage.mp/index.php?title=Scenarios
        Icon = "fas fa-box", -- Icon for the target
        Label = "Start Thermite Mission", -- Label for the target
        Ped = "a_m_y_golfer_01", -- Ped more can be found : https://docs.fivem.net/docs/game-references/ped-models/
        Coords = { -- Coords table  
            PedCoords = vector4(-1034.81, -81.85, 43.04, 175.18), -- Main coords for the ped vector3 format always
            Distance = 2.0, -- Distance to interact with the ped
        },
    },
    [3] = {
        Scenario = "WORLD_HUMAN_SEAT_WALL", -- Scenario for the ped, more can be found at : https://wiki.rage.mp/index.php?title=Scenarios
        Icon = "fas fa-box", -- Icon for the target
        Label = "Start Thermite Mission", -- Label for the target
        Ped = "mp_m_bogdangoon", -- Ped more can be found : https://docs.fivem.net/docs/game-references/ped-models/
        Coords = { -- Coords table  
            PedCoords = vector4(941.63, -1505.68, 30.19, 184.35), -- Main coords for the ped vector3 format always
            Distance = 2.0, -- Distance to interact with the ped
        },
    },
}

Config.ConvoyLocatoins = {
    [1] = {
        Trucklocation = vector4(-1620.6226, 4201.7515, 85.7138, 87.28),
        BlipRadius = 130.0,
        Vehicles = {
            [1] = {
                Model = "mesa3",
                Coords = vector4(-1641.89, 4206.5, 83.77, 71.1),
                WheeleBrake = true
            },
            [2] = {
                Model = "mesa3",
                Coords = vector4(-1586.0, 4200.63, 80.74, 89.87),
                WheeleBrake = false
            },
            [3] = {
                Model = "mesa3",
                Coords = vector4(-1597.36, 4200.67, 81.92, 92.9),
                WheeleBrake = true
            },
            [4] = {
                Model = "squaddie",
                Coords = vector4(-1654.22, 4213.21, 83.22, 49.77),
                WheeleBrake = false
            },
            [5] = {
                Model = "barracks3",
                Coords = vector4(-1630.75, 4203.4, 83.61, 45.5),
                WheeleBrake = true
            }, 
            [6] = {
                Model = "barracks3",
                Coords = vector4(-1610.2, 4200.87, 82.71, 115.0),
                WheeleBrake = false
            },
        },
        Guards = {
            [1] = {
                Coords = vector4(-1623.0, 4200.23, 83.75, 118.35),
                Ped = 'csb_ramp_marine',
                Weapon = 'weapon_pistol_mk2',
                Health = 3000,
                Accuracy = 85,
                Alertness = 3,
                Aggresiveness = 5,
            },
            [2] = {
                Coords = vector4(-1612.7, 4198.98, 83.26, 270.55),
                Ped = 's_m_y_blackops_01',
                Weapon = 'weapon_assaultsmg',
                Health = 3000,
                Accuracy = 90,
                Alertness = 3,
                Aggresiveness = 5,
            },
            [3] = {
                Coords = vector4(-1633.59, 4201.84, 84.13, 246.19),
                Ped = 'csb_ramp_marine',
                Weapon = 'weapon_pistol_mk2',
                Health = 3000,
                Accuracy = 90,
                Alertness = 3,
                Aggresiveness = 5,
            },
            -- Driver
            [4] = {
                Coords = vector4(-1597.53, 4199.28, 82.17, 358.07),
                Ped = 's_m_y_blackops_01',
                Weapon = 'weapon_assaultsmg',
                Health = 3000,
                Accuracy = 85,
                Alertness = 3,
                Aggresiveness = 5,
            },
            [5] = {
                Coords = vector4(-1586.42, 4199.31, 81.1, 357.09),
                Ped = 's_m_y_blackops_01',
                Weapon = 'weapon_assaultsmg',
                Health = 3000,
                Accuracy = 70,
                Alertness = 3,
                Aggresiveness = 8,
            },
            [6] = {
                Coords = vector4(-1642.59, 4205.34, 84.08, 353.51),
                Ped = 'csb_ramp_marine',
                Weapon = 'weapon_pistol_mk2',
                Health = 3000,
                Accuracy = 70,
                Alertness = 3,
                Aggresiveness = 8,
            },
            [7] = {
                Coords = vector4(-1655.68, 4212.64, 83.38, 329.57),
                Ped = 's_m_y_blackops_01',
                Weapon = 'weapon_assaultsmg',
                Health = 3000,
                Accuracy = 70,
                Alertness = 3,
                Aggresiveness = 8,
            },
            -- mesa driver
            [8] = {
                Coords = vector4(-1649.69, 4216.48, 84.16, 227.96),
                Ped = 's_m_y_blackops_01',
                Weapon = 'weapon_assaultsmg',
                Health = 3000,
                Accuracy = 70,
                Alertness = 3,
                Aggresiveness = 8,
            },
            [9] = {
                Coords = vector4(-1641.5, 4207.76, 83.94, 61.0),
                Ped = 's_m_y_blackops_01',
                Weapon = 'weapon_assaultsmg',
                Health = 3000,
                Accuracy = 70,
                Alertness = 3,
                Aggresiveness = 8,
            },
            [10] = {
                Coords = vector4(-1639.27, 4206.63, 84.01, 253.62),
                Ped = 's_m_y_blackops_01',
                Weapon = 'weapon_assaultsmg',
                Health = 3000,
                Accuracy = 70,
                Alertness = 3,
                Aggresiveness = 8,
            },
            [11] = {
                Coords = vector4(-1639.82, 4201.64, 84.71, 359.23),
                Ped = 's_m_y_blackops_01',
                Weapon = 'weapon_assaultsmg',
                Health = 3000,
                Accuracy = 70,
                Alertness = 3,
                Aggresiveness = 8,
            },
            [12] = {
                Coords = vector4(-1629.26, 4209.87, 84.64, 88.5),
                Ped = 's_m_y_blackops_01',
                Weapon = 'weapon_assaultsmg',
                Health = 3000,
                Accuracy = 70,
                Alertness = 3,
                Aggresiveness = 8,
            },
            [13] = {
                Coords = vector4(-1600.17, 4212.73, 82.84, 193.52),
                Ped = 's_m_y_blackops_01',
                Weapon = 'weapon_assaultsmg',
                Health = 3000,
                Accuracy = 70,
                Alertness = 3,
                Aggresiveness = 8,
            },
            [14] = {
                Coords = vector4(-1595.91, 4202.17, 82.0, 2.32),
                Ped = 's_m_y_blackops_01',
                Weapon = 'weapon_assaultsmg',
                Health = 3000,
                Accuracy = 70,
                Alertness = 3,
                Aggresiveness = 8,
            },
            [15] = {
                Coords = vector4(-1580.57, 4196.21, 80.64, 29.97),
                Ped = 's_m_y_blackops_01',
                Weapon = 'weapon_assaultsmg',
                Health = 3000,
                Accuracy = 70,
                Alertness = 3,
                Aggresiveness = 8,
            },
            [16] = {
                Coords = vector4(-1582.29, 4205.03, 80.61, 160.42),
                Ped = 's_m_y_blackops_01',
                Weapon = 'weapon_assaultsmg',
                Health = 3000,
                Accuracy = 70,
                Alertness = 3,
                Aggresiveness = 8,
            },
        },
        --------
    }
}


