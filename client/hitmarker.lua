local ns_hitmarker = {}
ns_hitmarker.ShowNPCDamages = false

ns_hitmarker.ArmorHitColor = {
    r = 29, 
    g = 108, 
    b = 177 
}
 
ns_hitmarker.NormalHitColor = {
     r = 255, 
     g = 255, 
     b = 255 
}

AddEventHandler('gameEventTriggered', function(name, data)
    local sure = 0
    if IN_ZONE and FastConfig_SH.HitMarker then
        if name == "CEventNetworkEntityDamage" then
            if health == nil then 
                health = GetEntityMaxHealth(data[2])
            end
            local sourceEntity = data[1]
            local Player = data[2]

            if Player == PlayerPedId() and sourceEntity ~= Player then
                if ns_hitmarker.ShowNPCDamages then
                    if IsPedAPlayer(Player) and GetEntityType(sourceEntity) == 1 then
                        repeat
                            local damage = math.ceil(health - GetEntityHealth(sourceEntity))

                            if GetEntityHealth(sourceEntity) >= 100 then
                                DrawText3D(GetEntityCoords(sourceEntity), damage, ns_hitmarker.ArmorHitColor.r, ns_hitmarker.ArmorHitColor.g, ns_hitmarker.ArmorHitColor.b)
                            else
                                DrawText3D(GetEntityCoords(sourceEntity), damage, ns_hitmarker.NormalHitColor.r, ns_hitmarker.NormalHitColor.g, ns_hitmarker.NormalHitColor.b)
                            end

                            sure = sure + 1
                            Wait(1)
                        until sure > 50
                        health = GetEntityHealth(sourceEntity)
                    end
                else
                    if IsPedAPlayer(Player) and GetEntityType(sourceEntity) == 1 and IsPedAPlayer(sourceEntity) then
                        repeat
                            local damage = math.ceil(health - GetEntityHealth(sourceEntity))

                            if GetEntityHealth(sourceEntity) >= 100 then
                                DrawText3D(GetEntityCoords(sourceEntity), damage, ns_hitmarker.ArmorHitColor.r, ns_hitmarker.ArmorHitColor.g, ns_hitmarker.ArmorHitColor.b)
                            else
                                DrawText3D(GetEntityCoords(sourceEntity), damage, ns_hitmarker.NormalHitColor.r, ns_hitmarker.NormalHitColor.g, ns_hitmarker.NormalHitColor.b)
                            end

                            sure = sure + 1
                            Wait(1)
                        until sure > 200
                        health = GetEntityHealth(sourceEntity)
                    end
                end
            end
        end
    end
end)

function DrawText3D(coords, text, r, g, b)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextOutline(1)
        SetTextScale(0.50, 0.50)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(x, y)   
    end
end