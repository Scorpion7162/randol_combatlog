local Server = lib.load('sv_config')
lib.locale()
local cachedCids = {}


function OnPlayerLoaded(source)
    local src = source
    local player = GetPlayer(src)
    if not player then return end
    cachedCids[src] = { cid = GetPlyIdentifier(player), name = GetCharacterName(player), license = GetPlyLicense(player)}
end

function OnPlayerUnload(source)
    local src = source
    if cachedCids[src] then cachedCids[src] = nil end
end

AddEventHandler('playerDropped', function(reason)
    local src = source
    local cached = cachedCids[src]
    if not cached then return end

    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local skin, model = GetPlayerSkinData(cached.cid)
    if not skin then return end

    if reason then
        local key = reason:lower():gsub('%s+', '_')
        local translated = locale(key)
        if translated ~= key then
            reason = translated
        end
    end

    local data = {
        id = src,
        cid = cached.cid,
        license = cached.license,
        name = cached.name,
        reason = reason or 'Unknown Reason',
        coords = vec4(coords.x, coords.y, coords.z - 1.0, heading),
        model = model,
        skin = skin,
    }

    cachedCids[src] = nil

    local plys = lib.getNearbyPlayers(coords, Server.CullingDist, false)
    for i = 1, #plys do
        TriggerClientEvent('randol_combatlog:client:onDropped', plys[i].id, data)
    end
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function()
    table.wipe(cachedCids)
end)
