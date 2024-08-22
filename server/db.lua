function updateKillStats(area)
    local currentTime = os.time()
    if currentTime - lastUpdateTime < cacheExpiry then
        return 
    end
    
    if area == "pistol" then 
        local response = MySQL.query.await('SELECT `playername`, `kill`, `death` FROM `fast_ffa_pistolzone` ORDER BY `kill` DESC')
        CACHE_PISTOL_PLAYER_DATA = {}
        if response then
            for i = 1, #response do
                local row = response[i]
                local playerName = row.playername
                local killCount = row.kill
                local deathCount = row.death
                table.insert(CACHE_PISTOL_PLAYER_DATA, {name = playerName, kd = "K: " .. killCount .. " | D: ".. deathCount })
            end
        end
    elseif area == "smg" then 
        local response = MySQL.query.await('SELECT `playername`, `kill`, `death` FROM `fast_ffa_smgzone` ORDER BY `kill` DESC')
        CACHE_SMG_PLAYER_DATA = {}
        if response then
            for i = 1, #response do
                local row = response[i]
                local playerName = row.playername
                local killCount = row.kill
                local deathCount = row.death
                table.insert(CACHE_SMG_PLAYER_DATA, {name = playerName, kd = "K: " .. killCount .. " | D: ".. deathCount })
            end
        end
    elseif area == "rifle" then 
        local response = MySQL.query.await('SELECT `playername`, `kill`, `death` FROM `fast_ffa_riflezone` ORDER BY `kill` DESC')
        CACHE_RIFLE_PLAYER_DATA = {}
        if response then
            for i = 1, #response do
                local row = response[i]
                local playerName = row.playername
                local killCount = row.kill
                local deathCount = row.death
                table.insert(CACHE_RIFLE_PLAYER_DATA, {name = playerName, kd = "K: " .. killCount .. " | D: ".. deathCount })
            end
        end
    end

    lastUpdateTime = currentTime
end

RegisterNetEvent("f4st-ffa:server:onplayerdeath", function(attacker, target, area)
    local tableName
    if area == "pistol" then 
        tableName = "fast_ffa_pistolzone"
    elseif area == "smg" then 
        tableName = "fast_ffa_smgzone"
    elseif area == "rifle" then 
        tableName = "fast_ffa_riflezone"
    else
        return 
    end
    local aPlayer = QBCore.Functions.GetPlayer(attacker)
    local tPlayer = QBCore.Functions.GetPlayer(target)

    local aPlayerData = exports.oxmysql:fetchSync("SELECT * FROM `" .. tableName .. "` WHERE citizenid = ?", {aPlayer.PlayerData.citizenid})
    if aPlayerData and #aPlayerData > 0 then
        exports.oxmysql:execute("UPDATE `" .. tableName .. "` SET `kill` = `kill` + 1 WHERE citizenid = ?", {aPlayer.PlayerData.citizenid})
    else
        exports.oxmysql:insert("INSERT INTO `" .. tableName .. "` (playername, citizenid, `kill`, `death`) VALUES (?, ?, 1, 0)", {aPlayer.PlayerData.charinfo.firstname .. " " .. aPlayer.PlayerData.charinfo.lastname, aPlayer.PlayerData.citizenid})
    end

    local tPlayerData = exports.oxmysql:fetchSync("SELECT * FROM `" .. tableName .. "` WHERE citizenid = ?", {tPlayer.PlayerData.citizenid})
    if tPlayerData and #tPlayerData > 0 then
        exports.oxmysql:execute("UPDATE `" .. tableName .. "` SET `death` = `death` + 1 WHERE citizenid = ?", {tPlayer.PlayerData.citizenid})
    else
        exports.oxmysql:insert("INSERT INTO `" .. tableName .. "` (playername, citizenid, `kill`, `death`) VALUES (?, ?, 0, 1)", {tPlayer.PlayerData.charinfo.firstname .. " " .. tPlayer.PlayerData.charinfo.lastname, tPlayer.PlayerData.citizenid})
    end
    TriggerEvent("f4st-ffa:send_scoreboard", area)
end)

RegisterNetEvent("f4st-ffa:sendkillsclient", function(area)
    local src = source
    local pDataCitizenID = QBCore.Functions.GetPlayer(source).PlayerData.citizenid

    if area == "pistol" then 
        MySQL.scalar('SELECT `kill` FROM `fast_ffa_pistolzone` WHERE `citizenid` = ? LIMIT 1', {
            pDataCitizenID
        }, function(data)
            TriggerClientEvent("f4st-ffa:client:getplayerkills", src, data)  
        end)
    
        MySQL.scalar('SELECT `death` FROM `fast_ffa_pistolzone` WHERE `citizenid` = ? LIMIT 1', {
            pDataCitizenID
        }, function(data)
            TriggerClientEvent("f4st-ffa:client:getplayerdeaths", src, data)  
        end)
    elseif area == "smg" then 
        MySQL.scalar('SELECT `kill` FROM `fast_ffa_smgzone` WHERE `citizenid` = ? LIMIT 1', {
            pDataCitizenID
        }, function(data)
            TriggerClientEvent("f4st-ffa:client:getplayerkills", src, data) 
        end)
    
        MySQL.scalar('SELECT `death` FROM `fast_ffa_smgzone` WHERE `citizenid` = ? LIMIT 1', {
            pDataCitizenID
        }, function(data)
            TriggerClientEvent("f4st-ffa:client:getplayerdeaths", src, data)  
        end)
    elseif area == "rifle" then 
        MySQL.scalar('SELECT `kill` FROM `fast_ffa_riflezone` WHERE `citizenid` = ? LIMIT 1', {
            pDataCitizenID
        }, function(data)
            TriggerClientEvent("f4st-ffa:client:getplayerkills", src, data)   
        end)
    
        MySQL.scalar('SELECT `death` FROM `fast_ffa_riflezone` WHERE `citizenid` = ? LIMIT 1', {
            pDataCitizenID
        }, function(data)
            TriggerClientEvent("f4st-ffa:client:getplayerdeaths", src, data)          
        end)
    end
end)

function ResetAllPlayerData(data)
    if data == "pistol" then 
        local query = string.format("DELETE FROM `%s`", "fast_ffa_pistolzone")
        exports.oxmysql:execute(query, {}, function(affectedRows)
            print("[DEBUG]: All pistol area data deleted")
        end)
    elseif data == "smg" then 
        local query = string.format("DELETE FROM `%s`", "fast_ffa_smgzone")
        exports.oxmysql:execute(query, {}, function(affectedRows)
            print("[DEBUG]: All smg area data deleted")
        end)
    elseif data == "rifle" then 
        local query = string.format("DELETE FROM `%s`", "fast_ffa_riflezone")
        exports.oxmysql:execute(query, {}, function(affectedRows)
            print("[DEBUG]: All rifle area data deleted")
        end)
    else 
        return 
    end
end 
