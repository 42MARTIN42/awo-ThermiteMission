 local QBCore = exports['qb-core']:GetCoreObject()
local StartPeds = {}
local isActive = false
local InMilitaryPoint = false
local InBuyerPoint = false
local CurrentCops = 0 
local ConvoyVehicles = {}
local StartCoolDownRemaining = 0
local MissionNumber = 1

local barracksNetId = nil

local function Notify(type, message, textType, sender, subject, time)
    if type == "qb" then
        QBCore.Functions.Notify(message, textType, time)
    else
        TriggerServerEvent(Config.Phone..':server:sendNewMail', {
            sender = sender,
            subject = subject,
            message = message,
            button = {}
        })
    end
end

local function CreateCutscene()
    local ped = PlayerPedId()   
    local clone = ClonePedEx(ped, 0.0, false, true, 1)
    local clone2 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone3 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone4 = ClonePedEx(ped, 0.0, false, true, 1)
    local clone5 = ClonePedEx(ped, 0.0, false, true, 1)
    SetBlockingOfNonTemporaryEvents(clone, true)
    SetEntityVisible(clone, false, false)
    SetEntityInvincible(clone, true)
    SetEntityCollision(clone, false, false)
    FreezeEntityPosition(clone, true)
    SetPedHelmet(clone, false)
    RemovePedHelmet(clone, true) 
    SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
    RegisterEntityForCutscene(ped, 'MP_1', 0, GetEntityModel(ped), 64)
    SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
    RegisterEntityForCutscene(clone2, 'MP_2', 0, GetEntityModel(clone2), 64)
    SetCutsceneEntityStreamingFlags('MP_3', 0, 1)
    RegisterEntityForCutscene(clone3, 'MP_3', 0, GetEntityModel(clone3), 64)
    SetCutsceneEntityStreamingFlags('MP_4', 0, 1)
    RegisterEntityForCutscene(clone4, 'MP_4', 0, GetEntityModel(clone4), 64)
    SetCutsceneEntityStreamingFlags('MP_5', 0, 1)
    RegisterEntityForCutscene(clone5, 'MP_5', 0, GetEntityModel(clone5), 64)
    Wait(10)
    StartCutscene(0)
    Wait(10)
    ClonePedToTarget(clone, ped)
    Wait(10)
    DeleteEntity(clone)
    DeleteEntity(clone2)
    DeleteEntity(clone3)
    DeleteEntity(clone4)
    DeleteEntity(clone5)
    Wait(50)
    DoScreenFadeIn(250)
end

local function PlayCutscene(cut)
    while not HasThisCutsceneLoaded(cut) do 
        RequestCutscene(cut, 8)
        Wait(0) 
    end
    CreateCutscene()
    RemoveCutscene()
    DoScreenFadeIn(500)
end


local function CheckBuyerCoords()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(7)
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = GetDistanceBetweenCoords(PlayerCoords, 1963.4307, 5160.2871, 47.196655, true) 
            local car = GetVehiclePedIsIn(PlayerPedId(),false) --barracksNetId
            local Vehicle = NetworkGetNetworkIdFromEntity(car)
            if Config.Debug then
                print("Vehicle ID: " .. car)
                print("Vehicle ID: " .. Vehicle) 
            end

            if Vehicle == barracksNetId then    
                if Distance < 5.0 then
                    InBuyerPoint = true
                    PlayCutscene('mph_pac_con_ext')
                    DeleteEntity(car)
                    Citizen.Wait(20000)
                        TriggerServerEvent('awo-ThermiteMission:server:GiveReward', true)
                    break
                end

            end
        end
    end)
end
 
CreateThread(function()
    if Config.Debug then
        while true do
            Citizen.Wait(0)
            for k, v in pairs(ConvoyVehicles) do
                local pedPos = GetEntityCoords(PlayerPedId())
                local vehPos = GetEntityCoords(v)
    
                DrawLine(pedPos, vehPos, 255, 0, 0, 255)
            end
        end
    end
end)

local function BuyerBlip()
    local Bblip = AddBlipForCoord(1963.4307, 5160.2871, 47.196655)
    SetBlipSprite(Bblip, 586)
    SetBlipColour(Bblip, 4)
    SetBlipScale(Bblip, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Buyer")
    EndTextCommandSetBlipName(Bblip)
    SetBlipRoute(Bblip, true)
    SetBlipRouteColour(Bblip, 5)
    CheckBuyerCoords()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(7)
            if InBuyerPoint == true then
                RemoveBlip(Bblip)
                break
            end
        end
    end)
end

local function StartCoolDown()
    StartCoolDownRemaining = Config.NextRob
    Citizen.CreateThread(function()
        while StartCoolDownRemaining > 0 do
            Citizen.Wait(1000)
            StartCoolDownRemaining = StartCoolDownRemaining - 1
        end
    end)
end

local function CheckCoords()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(7)
            local ped = GetPlayerPed(-1) 
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = GetDistanceBetweenCoords(PlayerCoords, -1620.6226, 4201.7515, 85.7138, true) 
            if Distance < 240.0 then
                InMilitaryPoint = true
                TriggerServerEvent("awo-ThermiteMission:Server:GuardsSync", -1)
                TriggerEvent("awo-ThermiteMission:SpawnTruck")
                QBCore.Functions.Notify("Többen vannak, mit elsőre gondoltuk..")
                break
            end
        end
    end)
end

local function MissionBlip()
    --local Mblip = AddBlipForCoord(-1620.6226, 4201.7515, 85.7138)  BlipRadius
    local Coords = Config.ConvoyLocatoins[MissionNumber].Trucklocation
    print(Coords.x)
    local Mblip = AddBlipForRadius(Coords.x, Coords.y, Coords.z, Config.ConvoyLocatoins[MissionNumber].BlipRadius)
    --SetBlipSprite(Mblip, 307)
    SetBlipColour(Mblip, 1)
    SetBlipAlpha(Mblip, 75)
    --SetBlipScale(Mblip, 0.8)
    --BeginTextCommandSetBlipName("STRING")
    --AddTextComponentString("Konvoy")
    --EndTextCommandSetBlipName(Mblip)
    CheckCoords()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(7)
            if InMilitaryPoint == true then
                RemoveBlip(Mblip)
                --TriggerServerEvent('police:server:policeAlert', 'Attempted Thermite Robbery')
                break
            end
        end
    end)
end

local function CancelMission()
    local barrack = NetworkGetEntityFromNetworkId(barracksNetId)
    if GetVehiclePedIsIn(PlayerPedId(), false) == barrack then
        TaskLeaveVehicle(PlayerPedId(), barrack, 0)
        SetVehicleDoorsLocked(barrack, 10)
    end

    Citizen.Wait(20000)

    local coords = Config.ConvoyLocatoins[MissionNumber].Trucklocation
    ClearArea(coords.x, coords.y, coords.z, 120.0)
    ClearAreaOfVehicles(coords.x, coords.y, coords.z, 120.73, false, false, false, false, false)
    for k,v in pairs(ConvoyVehicles) do
        DeleteEntity(v)
        QBCore.Functions.DeleteVehicle(v)
    end
end

local function StartMission()
    local luck = nil
    if CurrentCops >= Config.RequiredPolice then
        if StartCoolDownRemaining <= 0 then
            StartCoolDown()
            TriggerServerEvent("awo-ThermiteMission:server:SetActive", true)
            TriggerServerEvent("awo-ThermiteMission:SendDiscordLog")
            
            Notify("qb", "Nyisd meg a térképet.", "primary", sender, subject, 5000)
            luck = math.random(0,100)
            if luck <= 25 then
                Notify(type, "Tessék itt van a convoy nagyáboli helye. Ne kérdezd honnan tudom, csak menj oda!", textType, "Alan McClean", "Convoy", time)
            elseif luck <= 50 then
                Notify(type, "Egy srác akivel szolgáltam, elküldte a convoy pozicioját! Sies oda, gyorsan haladnak!", textType, "Alan McClean", "Convoy", time)
            elseif luck <= 75 then
                Notify(type, "A scener hallotam hogy, jelenleg a Raton Kanyon közelében járnak, siess! ", textType, "Alan McClean", "Convoy", time)
            elseif luck >= 75 then
                Notify(type, "Felszereltem a Barracks-ra, egy trackert. A hegyekben vannak így rossz a jel, de így is meg találod öket!", textType, "Charlie Reed", "Convoy", time)
            end
            Wait(9000)
            MissionBlip()
            MissionNumber = 1
        else
            local minutes = math.floor(StartCoolDownRemaining / 60)
            local seconds = StartCoolDownRemaining - minutes * 60
            Notify('qb', "You Have To Wait " .. minutes .. " Minutes And ".. seconds .. " Seconds Before Starting Robbing Again !", 'error', 6000)
            --QBCore.Functions.Notify("You Have To Wait " .. minutes .. " Minutes And ".. seconds .. " Seconds Before Starting Robbing Again !", "error")
        end
    else
        luck = math.random(0,100)
        if luck <= 25 then
            Notify(type, "Nincs egyetlen zsaru sem az utcán kritikus időszakokban, ideje kihasználni a helyzetet!", textType, "Vincent Effenburger", "Sürgös", time)
        elseif luck <= 50 then
            Notify(type, "Hé haver, Csak egy kis infó, most nincs egyetlen zsaru sem az utcán a kritikus időszakokban. Tökéletes idő, hogy lépjünk. Vigyázz magadra!", textType, "Vincent Effenburger", "Nincs Rendőr", time)
        elseif luck <= 75 then
            Notify(type, "Figyelem,Nincs zsaru szolgálatban a csúcsidőben! Gyorsan cselekedjünk és használjuk ki ezt. Mozgás gyorsan.", textType, "Vincent Effenburger", "Most vagy soha", time)
        elseif luck >= 75 then
            Notify(type, "Nincsenek rendőrök az utcán kritikus időszakokban. Ideje lépni és kihasználni ezt. Mozgás!", textType, "Vincent Effenburger", "Sürgös", time)
        end
    end
end

RegisterNetEvent("awo-ThermiteMission:SpawnTruck")
AddEventHandler("awo-ThermiteMission:SpawnTruck", function()
    local coords = Config.ConvoyLocatoins[MissionNumber].Trucklocation
    QBCore.Functions.SpawnVehicle("barracks", function(veh)
        SetVehicleNumberPlateText(veh, "U.S Army"..tostring(math.random(1000, 9999)))
        exports[Config.FuelScript]:SetFuel(veh, 100.0)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
        SetVehicleDoorsLocked(veh, true)
        Citizen.Wait(5000)
        SetVehicleDoorsLocked(veh, false)
        table.insert(ConvoyVehicles, veh)
        barracksNetId = NetworkGetNetworkIdFromEntity(veh)
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(7)
                if IsPedInAnyVehicle(PlayerPedId(), false) and GetVehiclePedIsIn(PlayerPedId(), false) == veh then
                    Notify(type, "Szuper meg szerezted a csomagot! Itt vannak a kordináték, itt várlak!", textType, "Paige Harris", "Convoy", time)
                   Wait(10000)
                   Notify("qb", "Menj a ki jelölet helyre, Grapeseed-ben!", "primary", nil, nil, 6000)
                    BuyerBlip()
                    break
                end
            end
        end)
    end, coords, true)
    --
    for k,v in  pairs(Config.ConvoyLocatoins[MissionNumber].Vehicles) do
        QBCore.Functions.SpawnVehicle(v.Model, function(veh)
            SetVehicleNumberPlateText(veh, "U.S Army"..tostring(math.random(1000, 9999)))
            SetVehicleNumberPlateTextIndex(veh, 1)
            SetVehicleDoorsLocked(veh, 10)
            for i = 0, 5 do
                SetVehicleDoorShut(veh, i, true)
            end

            exports[Config.FuelScript]:SetFuel(veh, 0.0)
            
            if v.WheeleBrake then
                local randomWheelIndex = math.random(0,3) -- Wheel index to break off
                BreakOffVehicleWheel(veh, randomWheelIndex, true, false, true, false)
            end

            table.insert(ConvoyVehicles, veh)
        end, v.Coords, true)
    end
end)

CreateThread(function()
    if Config.Debug then
        RegisterCommand("thermitetruck", function()
            TriggerEvent("awo-ThermiteMission:SpawnTruck")
        end)

        RegisterCommand("barrackhealth", function()
            local barrack = NetworkGetEntityFromNetworkId(barracksNetId)
        
            SetVehicleEngineHealth(barrack, 260)
        end)

        RegisterCommand("ItemGive", function()
            TriggerServerEvent('awo-ThermiteMission:server:GiveReward', true)
        end)
    end
end)

AddEventHandler('gameEventTriggered', function (name, args)
    --print("game event triggered: "..name)
    if name == "CEventNetworkEntityDamage" then
        --print('vehicle damage event')
        --print("args: " .. json.encode(args))

        victim = tonumber(args[1])
        attacker = tonumber(args[2])
        victimDied = tonumber(args[4]) == 1 and true or false
        weaponHash = tonumber(args[5])
        isMeleeDamage = tonumber(args[10]) ~= 0 and true or false
        vehicleDamageTypeFlag = tonumber(args[11])

        local barrack = NetworkGetEntityFromNetworkId(barracksNetId)

        if victim == barrack then
            if GetVehicleEngineHealth(barrack) < 250 then
                --cancel mission
                CancelMission()
            end
        end
    end
    --print('game event ' .. name .. ' (' .. json.encode(args) .. ')')
end)

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

--[[Citizen.CreateThread(function()
	for _, info in pairs(Config.BlipLocation) do
		if Config.UseBlips then
	   		info.blip = AddBlipForCoord(info.x, info.y, info.z)
	   		SetBlipSprite(info.blip, info.id)
	   		SetBlipDisplay(info.blip, 4)
	   		SetBlipScale(info.blip, 0.6)	
	   		SetBlipColour(info.blip, info.colour)
	   		SetBlipAsShortRange(info.blip, true)
	   		BeginTextCommandSetBlipName("STRING")
	   		AddTextComponentString(info.title)
	   		EndTextCommandSetBlipName(info.blip)
	 	end
   	end	
end)]]

CreateThread(function()
    local k = nil
    if k == nil or Config.Debug then k = 1 else math.random(1,3) end
    local v = Config.StartPeds[k]

    print(k)
    --print(10000 * 15 / 60)

        RequestModel(GetHashKey(v.Ped))
        while not HasModelLoaded(GetHashKey(v.Ped)) do
            Wait(1)
        end
        StartPed = CreatePed(0, v.Ped, v.Coords['PedCoords'].x,v.Coords['PedCoords'].y, v.Coords['PedCoords'].z, v.Coords['PedCoords'].w, false, true)
        SetEntityInvincible(StartPed, true)
        SetBlockingOfNonTemporaryEvents(StartPed, true)
        TaskStartScenarioInPlace(StartPed, v.Scenario, 0, true) 
        FreezeEntityPosition(StartPed, true)

        exports['qb-target']:AddEntityZone("Paige"..k, StartPed, {
            name = "Paige"..k,
        }, {
          options = {
            { 
                icon = v.Icon,
                label = v.Label,
                action = function()
                    StartMission()
                end,
                canInteract = function(StartPed)
                    if IsPedAPlayer(StartPed) then 
                        return false 
                    end 
                    return true
                end,
            }
          },
          distance = v.Coords['Distance'],
        })
end)

RegisterNetEvent("awo-ThermiteMission:ResetMission")
AddEventHandler("awo-ThermiteMission:ResetMission", function()
    StartPeds = {}
    for k,v in pairs(ConvoyVehicles) do
        DeleteEntity(v)
        QBCore.Functions.DeleteVehicle(v)
    end
    for k,v in pairs(StartPeds) do
        DeleteEntity(v)
        DeletePed(v)

    end
    InBuyerPoint = false
    InMilitaryPoint = false
end)

RegisterNetEvent('awo-ThermiteMission:client:SetActive', function(status)
    isActive = status
end)

local function SpawnGuards()
    local ped = PlayerPedId()
    SetPedRelationshipGroupHash(ped, GetHashKey('PLAYER'))
    AddRelationshipGroup('GuardPeds')

    for k, v in pairs(Config.ConvoyLocatoins[MissionNumber].Guards) do
        RequestModel(GetHashKey(v.Ped))
        while not HasModelLoaded(GetHashKey(v.Ped)) do
            Wait(1)
        end
        Guards = CreatePed(0, GetHashKey(v.Ped), v.Coords, true, true)
        NetworkRegisterEntityAsNetworked(Guards)
        networkID = NetworkGetNetworkIdFromEntity(Guards)
        SetNetworkIdCanMigrate(networkID, true)
        GiveWeaponToPed(Guards, GetHashKey(v.Weapon), 255, false, false) 
        SetNetworkIdExistsOnAllMachines(networkID, true)
        SetEntityAsMissionEntity(Guards)
        SetPedDropsWeaponsWhenDead(Guards, false)
        SetPedRelationshipGroupHash(Guards, GetHashKey("GuardPeds"))
        SetEntityVisible(Guards, true)
        SetPedRandomComponentVariation(Guards, 0)
        SetPedRandomProps(Guards)
        SetPedCombatMovement(Guards, v.Aggresiveness)
        SetPedAlertness(Guards, v.Alertness)
        SetPedAccuracy(Guards, v.Accuracy)
        SetPedMaxHealth(Guards, v.Health)
    end

    SetRelationshipBetweenGroups(0, GetHashKey("GuardPeds"), GetHashKey("GuardPeds"))
	SetRelationshipBetweenGroups(5, GetHashKey("GuardPeds"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("GuardPeds"))
end

RegisterNetEvent('awo-ThermiteMission:GuardsSync', function()
    SpawnGuards()
end)

AddEventHandler('onResourceStop', function (resource)
    if resource == GetCurrentResourceName() then
        ClearArea(-1621.66, 4201.4, 83.7, 78.73, 80.0)
		ClearAreaOfEverything(-1621.66, 4201.4, 83.7, 78.73, 80.0, true, true, true, true)
        ClearAreaOfVehicles(-1621.66, 4201.4, 83.7, 120.73, false, false, false, false, false)
        for k,v in pairs(ConvoyVehicles) do
            DeleteEntity(v)
            QBCore.Functions.DeleteVehicle(v)
        end
        
    end
end)

AddEventHandler('onResourceStart', function (resource)
    if resource == GetCurrentResourceName() then
        ClearArea(-1621.66, 4201.4, 83.7, 78.73, 80.0)
		ClearAreaOfEverything(-1621.66, 4201.4, 83.7, 78.73, 80.0, true, true, true, true)
        ClearAreaOfVehicles(-1621.66, 4201.4, 83.7, 120.73, false, false, false, false, false)
        for k,v in pairs(ConvoyVehicles) do
            DeleteEntity(v)
            QBCore.Functions.DeleteVehicle(v)
        end
    end
end)


