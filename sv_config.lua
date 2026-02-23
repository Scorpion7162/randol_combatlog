return {
    Inventory = 'ox_inventory', -- Only ox inv at the moment, you can addd support in bridge/server/inventory.lua
    CullingDist = 100.0,
    ReasonList = {
        ['game crashed'] = 'Head Popped',
        ['timed out'] = 'Head Popped',
        ['exiting'] = 'F8 Quit',
        ['you were kicked for being afk'] = 'Kicked for AFK',
        ['banned'] = 'Banned. Ggs. Get shit on.',
        ['exploit'] = 'Exploiting',
        ['kicked'] = 'Kicked',
    }
}