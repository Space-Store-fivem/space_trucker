-- Anti Teleport GS Trucker
spaceconfig.AntiTeleport = {
    -- ['buy_from_industry_name'] = {
    --      ['sell_to_industry_name'] = min time
    -- }
    -- Tested on Packer with max speedboosting is 90km/h
    -- Now for Primary Industry, will update for secondary and business soon
    [spaceconfig.Industry.Name.OILFIELD_MURRIETA] = {
        [spaceconfig.Industry.Name.PALETO_BAY_GAS_STATION] = 350,
        [spaceconfig.Industry.Name.PALETO_BAY_NO2_GAS_STATION] = 350,
        [spaceconfig.Industry.Name.MOUNT_CHILIAD_GAS_STATION] = 250,
        [spaceconfig.Industry.Name.GAPESEED_GAS_STATION] = 320,
        [spaceconfig.Industry.Name.SANDY_SHORES_GAS_STATION] = 170,
        [spaceconfig.Industry.Name.GRAND_SENORA_GAS_STATION] = 150,
        [spaceconfig.Industry.Name.GRAND_SENORA_NO2_GAS_STATION] = 123,
        [spaceconfig.Industry.Name.GRAND_SENORA_NO3_GAS_STATION] = 137,
        [spaceconfig.Industry.Name.GRAND_SENORA_NO4_GAS_STATION] = 126,
        [spaceconfig.Industry.Name.GRAND_SENORA_NO5_GAS_STATION] = 150,
        [spaceconfig.Industry.Name.DAVIS_QUARTZ_GAS_STATION] = 110,
        [spaceconfig.Industry.Name.HARMONY_GAS_STATION] = 110,
        [spaceconfig.Industry.Name.LAGO_ZANCUDO_GAS_STATION] = 200,
        [spaceconfig.Industry.Name.RICHMAN_GLEN_GAS_STATION] = 110,
        [spaceconfig.Industry.Name.TATAVIAM_GAS_STATION] = 40,
        [spaceconfig.Industry.Name.DOWNTOWN_VINEWOOD_GAS_STATION] = 100, --min 100 sec
        [spaceconfig.Industry.Name.MIRROR_PARK_GAS_STATION] = 100,
        [spaceconfig.Industry.Name.LA_MESA_GAS_STATION] = 80,
        [spaceconfig.Industry.Name.EL_BURRO_GAS_STATION] = 15,
        [spaceconfig.Industry.Name.STRAWBERRY_GAS_STATION] = 100,
        [spaceconfig.Industry.Name.DAVIS_GAS_STATION] = 50,
        [spaceconfig.Industry.Name.DAVIS_NO2_GAS_STATION] = 45,
        [spaceconfig.Industry.Name.LITTLE_SEOUL_GAS_STATION] = 50,
        [spaceconfig.Industry.Name.LITTLE_SEOUL_NO2_GAS_STATION] = 50,
        [spaceconfig.Industry.Name.MORNINGWOOD_GAS_STATION] = 100,
        [spaceconfig.Industry.Name.PACIFIC_BLUFFS_GAS_STATION] = 120,
        [spaceconfig.Industry.Name.LA_PUERTA_GAS_STATION] = 50,
        [spaceconfig.Industry.Name.ELYSIAN_ISLAND_GAS_STATION] = 40,
    },
    [spaceconfig.Industry.Name.CHEMICAL_FACTORY] = {
        [spaceconfig.Industry.Name.FEDERAL_WEAPON_FACTORY] = 200,
        [spaceconfig.Industry.Name.BROS_TEXTILE_FACTORY] = 200,
        [spaceconfig.Industry.Name.LOS_SANTOS_AUTOS] = 280,
        [spaceconfig.Industry.Name.PALETO_BAY_AUTOMOTIVE_SHOP] = 120,
        [spaceconfig.Industry.Name.GRAND_SENORA_AUTOMOTIVE_SHOP] = 100,
        [spaceconfig.Industry.Name.BURTON_AUTOMOTIVE_SHOP] = 220,
        [spaceconfig.Industry.Name.LSIA_AUTOMOTIVE_SHOP] = 260,
        [spaceconfig.Industry.Name.LA_MESA_AUTOMOTIVE_SHOP] = 200,
        [spaceconfig.Industry.Name.STRAWBERRY_AUTOMOTIVE_SHOP] = 200,
    },
    [spaceconfig.Industry.Name.ROGERS_SCRAPYARD] = {
        [spaceconfig.Industry.Name.FEDERAL_STEEL_MILL] = 300
    },
    [spaceconfig.Industry.Name.THOMSON_SCRAPYARD] = {
        [spaceconfig.Industry.Name.FEDERAL_STEEL_MILL] = 150
    },
    [spaceconfig.Industry.Name.FOREST_CENTER] = {
        [spaceconfig.Industry.Name.SAWMILL_FACTORY] = 110,
    },
    [spaceconfig.Industry.Name.ZANCUDO_FARM] = {
        [spaceconfig.Industry.Name.THE_MOUNT_DISTILLERY] = 180
    },
    [spaceconfig.Industry.Name.PALETO_BAY_FARM] = {
        [spaceconfig.Industry.Name.BROS_TEXTILE_FACTORY] = 300
    },
    [spaceconfig.Industry.Name.N10_FARM] = {
        [spaceconfig.Industry.Name.PALETO_BAY_FOOD_PROCESSING_PLANT] = 80,
        [spaceconfig.Industry.Name.TRADITION_MALT_HOUSE] = 280
    },
    [spaceconfig.Industry.Name.N11_FARM] = {
        [spaceconfig.Industry.Name.PALETO_BAY_FOOD_PROCESSING_PLANT] = 60,
        [spaceconfig.Industry.Name.TRADITION_MALT_HOUSE] = 240
    }
}

function GSTruckerAntiTeleportFilter(source, _fromIndustryName, _toIndustryName, _addTime)
    -- if not spaceconfig.AntiTeleport[_fromIndustryName] or not spaceconfig.AntiTeleport[_fromIndustryName][_toIndustryName] then 
    --     -- This route is not defined
    --     return true
    -- end
    -- local min_time_needed_to_complete = spaceconfig.AntiTeleport[_fromIndustryName][_toIndustryName]

    -- local time_do_trucker = os.time() - _addTime
    -- if time_do_trucker < min_time_needed_to_complete then 
    --     TriggerEvent('GSTrucker:WarningTruckerTeleport', source, _fromIndustryName, _toIndustryName, time_do_trucker)
    --     return false 
    -- end
    -- Return true when everything is fine or you need turn off anticheat
    return true
end

RegisterNetEvent('GSTrucker:WarningTruckerTeleport', function (playerSource, fromIndustryName, toIndustryName, timeDoTrucker)
    -- Change your discord webhook or ban here
    TriggerClientEvent('QBCore:Notify', playerSource, 'Trucker Hacking: from '..fromIndustryName..' to '..toIndustryName..' with '..timeDoTrucker..' sec', 'error')
end)
-- Anti duplicate vehicle plate
-- Credits to https://github.com/TGIANN/tgiann-anti-duplicate-vehicle
-- Thank TGIANN
CreateThread(function()
    while true do
        local plateList = {}
        local allVeh = GetAllVehicles()
        for i=1, #allVeh do
            if DoesEntityExist(allVeh[i]) then
                local plate = GetVehicleNumberPlateText(allVeh[i])
                local model = GetEntityModel(allVeh[i])
                if not plateList[plate] then 
                    plateList[plate] = model
                elseif model == plateList[plate] then
                    DeleteEntity(allVeh[i])
                end
            end
        end
        Wait(5000)
    end
end)