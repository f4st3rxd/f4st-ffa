local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function ArmorAnim()
    loadAnimDict("missmic4")
    TaskPlayAnim(PlayerPedId(), "missmic4", "michael_tux_fidget", 8.0, 1.0, -1, 49, 0, false, false, false)
end

RegisterKeyMapping('+ffa_bandage', 'FFA BANDAGE KEYBIND', 'keyboard', '2')
RegisterKeyMapping('+ffa_armor', 'FFA ARMOR KEYBIND', 'keyboard', '1')

RegisterCommand("+ffa_armor", function()
    if not IN_ZONE then return end
    if GetPedArmour(PlayerPedId()) == 100 then QBCore.Functions.Notify('Zaten yeterince zırhınız var!', 'error') return end
    local ped = PlayerPedId()
    ArmorAnim()
    QBCore.Functions.Progressbar("use_heavyarmor", "Zırhı giyiyorsun..", 6000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,

    }, {}, {}, {}, function() -- Done
        SetPedArmour(ped, 100)
        StopAnimTask(PlayerPedId(), "smissmic4", "michael_tux_fidget", 1.0)
    end)
end)

RegisterCommand("+ffa_bandage", function()
    if not IN_ZONE then return end
    if GetEntityHealth(PlayerPedId()) == 200 then QBCore.Functions.Notify('Bandaj kullanmaya ihtiyacınız yok!', 'error') return end
    local ped = PlayerPedId()
    ArmorAnim()
    QBCore.Functions.Progressbar("use_bandage", "Bandaj kullanıyorsun..", 6000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,

    }, {}, {}, {}, function() -- Done
        SetEntityHealth(ped, GetEntityHealth(PlayerPedId()) + 25)
        StopAnimTask(PlayerPedId(), "smissmic4", "michael_tux_fidget", 1.0)
    end)
end)