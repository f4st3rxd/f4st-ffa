function OpenNUI()
    if IN_ZONE then return end
    if IsEntityDead(PlayerPedId()) then return end
    TriggerServerEvent("f4st-ffa:server:getplayers") 
    Wait(100)
    SendNUIMessage({
        openModeSelector = "show",
        smgZonePlayerCount = tostring(SMG_ZONE_PLAYERS) .. "/" .. FastConfig_Smg_Area_Settings.MaxPlayerLimit,
        pistolZonePlayerCount = tostring(PISTOL_ZONE_PLAYERS) .. "/" .. FastConfig_Pistol_Area_Settings.MaxPlayerLimit,
        rifleZonePlayerCount = tostring(RIFLE_ZONE_PLAYERS) .. "/" .. FastConfig_Rifle_Area_Settings.MaxPlayerLimit
    })
    SetNuiFocus(true, true)
end

RegisterNUICallback("closeUI", function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent("f4st-ffa:getscoreboard_data", function(SCOREBOARD_DATA)
    -- print(json.encode(SCOREBOARD_DATA))
    L_BOARDATA = SCOREBOARD_DATA
end)


function SendDataFunc()
    local CURR_DATA_K = D_KILLS
    local CURR_DATA_D = D_DEATHS
    local CURR_KD
    if CURR_DATA_K == nil then 
        CURR_DATA_K = 0 
    end
    
    if CURR_DATA_D == nil or CURR_DATA_D == 0 then 
        CURR_DATA_D = 0 
        CURR_KD = "N/A"
    else
        CURR_KD = CURR_DATA_K / CURR_DATA_D 
    end

    SendNUIMessage({
        updatePlyHudData = true,
        sendPlyKills = "KILL: " .. tostring(CURR_DATA_K),
        sendPlyDeaths = "DEATH: " .. tostring(CURR_DATA_D),
        sendKD = "K/D: " .. (CURR_KD == "N/A" and CURR_KD or string.format("%.2f", CURR_KD))  
    })
end



RegisterCommand("+ffa_menu", function()
    if IN_ZONE then 
        TriggerServerEvent("f4st-ffa:send_scoreboard", CURRENT_ZONE)
        Wait(100)
        -- print(json.encode(L_BOARDATA))
        SendNUIMessage({
            openLeaderBoard = "show",
            scoreBoardData = L_BOARDATA
        })
        SendDataFunc()
        SetNuiFocus(true, true)
    end
end)

RegisterKeyMapping("+ffa_menu", 'FFA MENU', 'keyboard', 'M')



function OpenFFAHud()
    if IN_ZONE then
        TriggerServerEvent("f4st-ffa:sendkillsclient", CURRENT_ZONE)
        Wait(100)
        SendNUIMessage({
            openHud = "show",
        })
        Wait(100)
        SendDataFunc()
    end
end

function JoinArea(area)
    if area == "smg" then
        IN_ZONE = true
        CURRENT_WEAPON_TYPE = area
        CURRENT_ZONE = area
        CURR_ARMOR = GetPedArmour(PlayerPedId())
        TriggerServerEvent("f4st-ffa:sendkillsclient", CURRENT_ZONE)
        TriggerServerEvent("f4st-ffa:server:joinarea",  area)
        RandomSpawnPlayer("smg")
        OpenFFAHud()
        GiveWeaponPlayer()
    elseif area == "pistol" then 
        IN_ZONE = true
        CURRENT_WEAPON_TYPE = area
        CURRENT_ZONE = area
        CURR_ARMOR = GetPedArmour(PlayerPedId())
        TriggerServerEvent("f4st-ffa:sendkillsclient", CURRENT_ZONE)
        TriggerServerEvent("f4st-ffa:server:joinarea",  area)
        RandomSpawnPlayer("pistol")
        OpenFFAHud()
        GiveWeaponPlayer()
    elseif area == "rifle" then 
        IN_ZONE = true 
        CURRENT_WEAPON_TYPE = area
        CURRENT_ZONE = area
        CURR_ARMOR = GetPedArmour(PlayerPedId())
        TriggerServerEvent("f4st-ffa:sendkillsclient", CURRENT_ZONE)
        TriggerServerEvent("f4st-ffa:server:joinarea",  area)
        RandomSpawnPlayer("rifle")
        OpenFFAHud()
        GiveWeaponPlayer()
    end 
end

function RandomSpawnPlayer(area)
    if area == "smg" then 
        local RandomCoords = FastConfig_Smg_Area_Settings.SpawnCoords[math.random(1, #FastConfig_Smg_Area_Settings.SpawnCoords)]
        SetEntityCoords(PlayerPedId(), RandomCoords.x, RandomCoords.y, RandomCoords.z)
        SetPedArmour(PlayerPedId(), 100)
        SendDataFunc()
    elseif area == "pistol" then 
        local RandomCoords = FastConfig_Pistol_Area_Settings.SpawnCoords[math.random(1, #FastConfig_Pistol_Area_Settings.SpawnCoords)]
        SetEntityCoords(PlayerPedId(), RandomCoords.x, RandomCoords.y, RandomCoords.z)
        SetPedArmour(PlayerPedId(), 100)
        SendDataFunc()
    elseif area == "rifle" then 
        local RandomCoords = FastConfig_Rifle_Area_Settings.SpawnCoords[math.random(1, #FastConfig_Rifle_Area_Settings.SpawnCoords)]
        SetEntityCoords(PlayerPedId(), RandomCoords.x, RandomCoords.y, RandomCoords.z)
        SetPedArmour(PlayerPedId(), 100)
        SendDataFunc()
    end 
end

function GiveWeaponPlayer()
    if IN_ZONE then  
        if CURRENT_WEAPON_TYPE == "smg" then 
            GiveWeaponToPed(PlayerPedId(), GetHashKey(FastConfig_Smg_Area_Settings.Weapon), 200, false, true)
            SetPedInfiniteAmmo(PlayerPedId(), true, GetHashKey(FastConfig_Smg_Area_Settings.Weapon))
        elseif CURRENT_WEAPON_TYPE == "pistol" then 
            GiveWeaponToPed(PlayerPedId(), GetHashKey(FastConfig_Pistol_Area_Settings.Weapon), 200, false, true)
            SetPedInfiniteAmmo(PlayerPedId(), true, GetHashKey(FastConfig_Pistol_Area_Settings.Weapon))
        elseif CURRENT_WEAPON_TYPE == "rifle" then
            GiveWeaponToPed(PlayerPedId(), GetHashKey(FastConfig_Rifle_Area_Settings.Weapon), 200, false, true)
            SetPedInfiniteAmmo(PlayerPedId(), true, GetHashKey(FastConfig_Rifle_Area_Settings.Weapon))
        end
    end
end

function CloseHud()
    SendNUIMessage({
        closeHud = true
    })
    SetNuiFocus(false, false)
end

function CloseUI()
    SendNUIMessage({
        openJoinMenu = "close"
    })
    SendNUIMessage({
        openFFA_MENU = "close"
    })
    SetNuiFocus(false, false)
end

local function GameEventTriggered(eventName, data)
    if IN_ZONE then 
        if eventName == "CEventNetworkEntityDamage" then
            -- -- print(1)
            local newbuild = #data == 13
            local i = 1
            local function iplus()
                local x = i
                i = i + 1
                return x
            end
            local victim = tonumber(data[iplus()])
            local attacker = tonumber(data[iplus()])
            iplus()
            if newbuild then
                iplus()
                iplus()
                if #data == 12 then i = i - 1 end
            end 
            TriggerServerEvent("f4st-ffa:sendkillsclient", CURRENT_ZONE)
            local victimDied = tonumber(data[iplus()]) == 1 and true or false
            if attacker == PlayerPedId() then
                -- -- print(2)
                if attacker ~= victim then
                    -- -- print(3)
                    if IsPedAPlayer(attacker) and IsPedAPlayer(victim) then
                        -- -- print(4)
                        if victimDied then
                            -- -- print(5)    
                            local boneWasDamaged, damagedBone = GetPedLastDamageBone(victim)
                            if not boneWasDamaged then
                                damagedBone = -1
                            end
                            TriggerServerEvent("f4st-ffa:sendkillsclient", CURRENT_ZONE)
                            -- TriggerServerEvent("f4st-ffa:sendkillsclient")
                            TriggerServerEvent('f4st-ffa:server:onplayerdeath',GetPlayerServerId(NetworkGetEntityOwner(attacker)), GetPlayerServerId(NetworkGetEntityOwner(victim)), CURRENT_ZONE)
                        end
                    end
                end
            end
        end
    end
end

AddEventHandler('gameEventTriggered',function(name, args)
    GameEventTriggered(name,args)
end)

CreateThread(function()
    while true do 
        if IN_ZONE then 
            local PlayerDead = QBCore.Functions.GetPlayerData().metadata["isdead"]
            local PlayerIslaststand = QBCore.Functions.GetPlayerData().metadata["inlaststand"]

            SetPedCanRagdoll(PlayerPedId(), false)
            if PlayerDead or PlayerIslaststand then 
                TriggerEvent(FastConfig_Events.Revive)
                RandomSpawnPlayer(CURRENT_ZONE)
                GiveWeaponPlayer(CURRENT_ZONE)
                TriggerServerEvent("f4st-ffa:sendkillsclient", CURRENT_ZONE)
            end 

            TriggerServerEvent("f4st-ffa:sendkillsclient", CURRENT_ZONE)
            SendDataFunc()
        end
        Wait(5000)
    end
end)

RegisterNUICallback("CloseUI", function()
    CloseUI()
    SendDataFunc()
end)

RegisterNUICallback("JoinArea2", function()
    JoinArea("smg")
    CloseUI()
end)

RegisterNUICallback("JoinArea1", function()
    JoinArea("pistol")
    CloseUI()
end)

RegisterNUICallback("JoinArea3", function()
    JoinArea("rifle")
    CloseUI()
end)

RegisterNUICallback("ExitZone", function()
    SetPedArmour(PlayerPedId(), CURR_ARMOR)
    TriggerServerEvent("f4st-ffa:server:exitzone", CURRENT_ZONE)
end)

exports("InZone", function()
    return IN_ZONE
end)
