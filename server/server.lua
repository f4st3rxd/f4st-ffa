QBCore = exports['qb-core']:GetCoreObject()
CACHE_PISTOL_PLAYER_DATA = {}
CACHE_SMG_PLAYER_DATA = {}
CACHE_RIFLE_PLAYER_DATA = {}
SMG_ZONE = {}
PISTOL_ZONE = {}
RIFLE_ZONE = {}
PLY_ITEMS = {}
lastUpdateTime = 0
cacheExpiry = 60 

RegisterNetEvent("f4st-ffa:server:joinarea", function(areatype)
    JoinArea(source, areatype)
end) 

function getKillStats(area)
    updateKillStats(area) 
    if area == "pistol" then
        return CACHE_PISTOL_PLAYER_DATA
    elseif area == "smg" then
        return CACHE_SMG_PLAYER_DATA
    elseif area == "rifle" then
        return CACHE_RIFLE_PLAYER_DATA
    end
    return nil
end

RegisterNetEvent("f4st-ffa:send_scoreboard", function(area)
    TriggerClientEvent("f4st-ffa:getscoreboard_data", source, getKillStats(area))
end)

function RemoveFromTable(table, valueToRemove)
    for key, value in pairs(table) do
        if value == valueToRemove then
            table[key] = nil
            return
        end
    end
end

RegisterNetEvent("f4st-ffa:server:exitzone", function(area)
    local src = source
    if area == "smg" then 
        RemoveFromTable(SMG_ZONE, source)
        SetPlayerRoutingBucket(source, FastConfig_SH.MainBucket)
        ManagePlayerItems(source, "give")
        TriggerClientEvent("f4st-ffa:client:exitzone", source)
    elseif area == "pistol" then 
        RemoveFromTable(PISTOL_ZONE, source)
        SetPlayerRoutingBucket(source, FastConfig_SH.MainBucket)
        ManagePlayerItems(source, "give")
        TriggerClientEvent("f4st-ffa:client:exitzone", source)
    elseif area == "rifle" then 
        RemoveFromTable(RIFLE_ZONE, source)
        SetPlayerRoutingBucket(source, FastConfig_SH.MainBucket)
        ManagePlayerItems(source, "give")
        TriggerClientEvent("f4st-ffa:client:exitzone", source)
    end
end)

RegisterCommand(FastConfig_Commands.CheckAreaCommand, function()
        print("SMG AREA: ".. #(SMG_ZONE))
        print("PISTOL AREA: ".. #(PISTOL_ZONE))
        print("RIFLE AREA: ".. #(RIFLE_ZONE))
        print("----------------------------------------------")
        print(table.unpack(SMG_ZONE))
        print(table.unpack(PISTOL_ZONE))
        print(table.unpack(RIFLE_ZONE))
end)

function JoinArea(source, type)
    if type == "smg" then 
        SetPlayerRoutingBucket(source, FastConfig_Smg_Area_Settings.Bucket)
        ManagePlayerItems(source, "get")
        table.insert(SMG_ZONE, source)
    elseif type == "pistol" then 
        SetPlayerRoutingBucket(source, FastConfig_Pistol_Area_Settings.Bucket)
        ManagePlayerItems(source, "get")
        table.insert(PISTOL_ZONE, source)
    elseif type == "rifle" then 
        SetPlayerRoutingBucket(source, FastConfig_Rifle_Area_Settings.Bucket)
        ManagePlayerItems(source, "get")
        table.insert(RIFLE_ZONE, source)
    else 
        DropPlayer(source, FastConfig.CheaterKickText)
    end
end 

function CountPlayerInTheArea(area)
    if area == "smg" then
        return #(SMG_ZONE) 
    elseif area == "pistol" then 
        return #(PISTOL_ZONE)
    elseif area == "rifle" then 
        return #(RIFLE_ZONE)
    else
        return
    end 
end 

function GetInventoryJsonData(PLAYER_ID)
    if not PLAYER_ID then return end
    if FastConfig_SH.Inventory == "ox" then 
        return exports.ox_inventory:GetInventoryItems(PLAYER_ID)
    elseif FastConfig_SH.Inventory == "qb" then  
        return QBCore.Functions.GetPlayer(PLAYER_ID).PlayerData.items 
    end
end

function ManagePlayerItems(PLAYER_ID, TYPE)
    if not PLAYER_ID then return end 
    if TYPE == "get" then 
        PLY_ITEMS[QBCore.Functions.GetPlayer(PLAYER_ID).PlayerData.citizenid] = GetInventoryJsonData(PLAYER_ID)
        for k, v in pairs(GetInventoryJsonData(PLAYER_ID)) do 
            if FastConfig_SH.Inventory == "ox" then 
                QBCore.Functions.GetPlayer(PLAYER_ID).Functions.RemoveItem(v.name, v.count)
            elseif FastConfig_SH.Inventory == "qb" then 
                QBCore.Functions.GetPlayer(PLAYER_ID).Functions.RemoveItem(v.name, v.amount)
            end
        end
    elseif TYPE == "give" then 
        for k, v in pairs(PLY_ITEMS[QBCore.Functions.GetPlayer(PLAYER_ID).PlayerData.citizenid]) do 
            if FastConfig_SH.Inventory == "ox" then 
                exports.ox_inventory:AddItem(PLAYER_ID, v.name, v.count, v.metadata, v.slot) 
            elseif FastConfig_SH.Inventory == "qb" then 
                QBCore.Functions.GetPlayer(PLAYER_ID).Functions.AddItem(v.name, v.amount)
            end
        end 
    end 
end 

RegisterCommand(FastConfig_Commands.ResetDataCommand, function(source, args, rawCommand) 
    if source == 0 then 
        if not args[1] then 
            print("[ERROR]: please enter a valid argument e.g. (smg, rifle, pistol)") 
            return 
        end
        if args[1] == "pistol" then 
            ResetAllPlayerData("pistol")
        elseif args[1] == "smg" then 
            ResetAllPlayerData("smg")
        elseif args[1] == "rifle" then 
            ResetAllPlayerData("rifle")
        else 
            print("[ERROR]: please enter a valid argument e.g. (smg, rifle, pistol)") 
        end 
    else 
        return 
    end
end)

RegisterNetEvent("f4st-ffa:server:getplayers", function()
    TriggerClientEvent("f4st-ffa:client:getplayers", source, CountPlayerInTheArea("smg"), CountPlayerInTheArea("pistol"), CountPlayerInTheArea("rifle"))  
end)

AddEventHandler("playerDropped", function()
    RemoveFromTable(SMG_ZONE, source)
    RemoveFromTable(PISTOL_ZONE, source)
    RemoveFromTable(RIFLE_ZONE, source)
end)
