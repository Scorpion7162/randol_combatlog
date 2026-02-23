local Server = lib.load('sv_config')

if GetResourceState('ox_inventory') ~= 'started' or Server.Inventory ~= 'ox_inventory' then return end

function OpenInventory(src, cid)
    exports.ox_inventory:forceOpenInventory(src, 'player', cid)
end