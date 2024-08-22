QBCore = exports['qb-core']:GetCoreObject()
L_BOARDATA = nil
CURRENT_WEAPON_TYPE = nil
CURRENT_ZONE = nil
IN_ZONE = false 
SMG_ZONE_PLAYERS = 0
PISTOL_ZONE_PLAYERS = 0
RIFLE_ZONE_PLAYERS = 0
D_KILLS = 0 
D_DEATHS = 0

RegisterNetEvent("f4st-ffa:client:getplayers", function(smg, pistol, rifle)
    SMG_ZONE_PLAYERS = smg 
    PISTOL_ZONE_PLAYERS = pistol 
    RIFLE_ZONE_PLAYERS = rifle 
end)

RegisterNetEvent("f4st-ffa:client:exitzone", function()
    -- print("getcl2")
    IN_ZONE = false 
    CURRENT_WEAPON_TYPE = nil
    CURRENT_ZONE = nil
    CloseUI()
    CloseHud()   
    SetPedInfiniteAmmo(PlayerPedId(), false, GetHashKey(FastConfig_Pistol_Area_Settings.Weapon))
    SetPedInfiniteAmmo(PlayerPedId(), false, GetHashKey(FastConfig_Smg_Area_Settings.Weapon))
    SetPedInfiniteAmmo(PlayerPedId(), false, GetHashKey(FastConfig_Rifle_Area_Settings.Weapon))
    SetPedCanRagdoll(PlayerPedId(), true)
    RemoveAllPedWeapons(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), FastConfig_SH.ExitCoords.x, FastConfig_SH.ExitCoords.y, FastConfig_SH.ExitCoords.z)
    SetEntityHeading(PlayerPedId(), FastConfig_SH.ExitCoords.w)
end)

RegisterCommand(FastConfig_Commands.EditModeCommand, function()
    if not IN_ZONE then return end
    SendNUIMessage({
        editMode = true 
    })
    SetNuiFocus(true, true)
end)


RegisterCommand(FastConfig_Commands.ResetEdit, function()
    if not IN_ZONE then return end
    SendNUIMessage({
        resetEdits = true 
    })
end)

RegisterNetEvent("f4st-ffa:client:getplayerkills", function(kill)
    -- if not kill then return end 
    D_KILLS = kill
    SendDataFunc()
end)

RegisterNetEvent("f4st-ffa:client:getplayerdeaths", function(death)
    -- if not death then return end
    D_DEATHS = death
    SendDataFunc()
end)


Citizen.CreateThread(function()
    local ped_hash2 = GetHashKey(FastConfig_SH.NpcModel)
    local ped_coords2 = { x = FastConfig_SH.JoinCoords.x, y = FastConfig_SH.JoinCoords.y, z = FastConfig_SH.JoinCoords.z - 1, h = FastConfig_SH.JoinCoords.w} 

    RequestModel(ped_hash2)
    while not HasModelLoaded(ped_hash2) do
        Wait(1)
    end
    
    ped_info2 = CreatePed(1, ped_hash2, ped_coords2.x, ped_coords2.y, ped_coords2.z, ped_coords2.h, false, true)
    SetBlockingOfNonTemporaryEvents(ped_info2, true) 
    SetPedDiesWhenInjured(ped_info2, false) 
    SetPedCanPlayAmbientAnims(ped_info2, true) 
    SetPedCanRagdollFromPlayerImpact(ped_info2, false) 
    SetEntityInvincible(ped_info2, true)    
    FreezeEntityPosition(ped_info2, true) 
    TaskStartScenarioInPlace(ped_info2, "WORLD_HUMAN_GUARD_STAND", 0, true); 
end)

CreateThread(function()
	local sleep = 2000
	while true do 
		Wait(sleep)
		local ply_coords = GetEntityCoords(PlayerPedId())
		local npc_coords = vector3(FastConfig_SH.JoinCoords.x, FastConfig_SH.JoinCoords.y, FastConfig_SH.JoinCoords.z - 1)
		local distance = #(ply_coords - npc_coords) 
	
		if distance <= 2 then 
			sleep = 3
			QBCore.Functions.DrawText3D(npc_coords.x, npc_coords.y, npc_coords.z + 1.02, "[E] - Open FFA Menu")

			if IsControlJustReleased(0, 38) then 
				OpenNUI()
			end
		end
	end 	
end)
