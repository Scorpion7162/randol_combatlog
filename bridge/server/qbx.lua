if GetResourceState('qbx_core') ~= 'started' then return end



function GetPlayer(id)
    return exports.qbx_core:GetPlayer(id)
end

function DoNotification(src, text, nType)
    lib.notify(src, {
        title = 'Combat Log',
        description = text,
        type = nType,
        position = 'top',
        duration = 5000,
    })
end

function GetCharacterName(Player)
    return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
end

function GetPlyIdentifier(Player)
    return Player.PlayerData.citizenid
end

function GetPlyLicense(Player)
    return Player.PlayerData.license
end

function GetPlayerSkinData(cid)
    local result = MySQL.single.await('SELECT skin FROM playerskins WHERE citizenid = ? AND active = ?', { cid, 1 })
    if result and result.skin then
        local skinData = json.decode(result.skin)
        if skinData then
            return skinData, skinData.model
        end
    end
    return false
end

RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(source)
    OnPlayerUnload(source)
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    OnPlayerLoaded(source)
end)
