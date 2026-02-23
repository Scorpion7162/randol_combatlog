local temp = {}
local oxtarget = GetResourceState('ox_target') == 'started'
local BOARD_MODEL = `prop_police_id_board`
local ANIM_DICT = 'mp_character_creation@customise@male_a'
local TARGET_LABEL = 'View Information'

local function targetLocalEntity(entity, options, distance)
    if oxtarget then
        for _, option in ipairs(options) do
            option.distance = distance
            option.onSelect = option.action
            option.action = nil
        end
        exports.ox_target:addLocalEntity(entity, options)
    else
        exports['qb-target']:AddTargetEntity(entity, {
            options = options,
            distance = distance,
        })
    end
end

local function removeTarget(entity)
    if oxtarget then
        exports.ox_target:removeLocalEntity(entity, TARGET_LABEL)
    else
        exports['qb-target']:RemoveTargetEntity(entity, TARGET_LABEL)
    end
end

local function cleanupEntry(cid)
    local entry = temp[cid]
    if not entry then return end

    if DoesEntityExist(entry.entity) then
        removeTarget(entry.entity)
        DeleteEntity(entry.entity)
    end

    if DoesEntityExist(entry.prop) then
        DeleteEntity(entry.prop)
    end

    temp[cid] = nil
end

function clearEverything()
    for cid in pairs(temp) do
        cleanupEntry(cid)
    end
end

local function attachBoard(ped)
    lib.requestModel(BOARD_MODEL)
    local coords = GetEntityCoords(ped)
    local object = CreateObject(BOARD_MODEL, coords.x, coords.y, coords.z, false, false, false)
    AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, 58868), 0.12, 0.24, 0.0, 5.0, 0.0, 70.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(BOARD_MODEL)
    return object
end

RegisterNetEvent('randol_combatlog:client:onDropped', function(data)
    if GetInvokingResource() or not data then return end

    local cid = data.cid

    lib.requestModel(data.model)

    local entity = CreatePed(0, data.model, data.coords, false, false)
    SetEntityAsMissionEntity(entity, false, false)
    SetPedFleeAttributes(entity, 0, 0)
    SetBlockingOfNonTemporaryEvents(entity, true)
    SetEntityInvincible(entity, true)
    FreezeEntityPosition(entity, true)
    SetEntityAlpha(entity, 180, true)
    SetModelAsNoLongerNeeded(data.model)

    lib.requestAnimDict(ANIM_DICT)
    TaskPlayAnim(entity, ANIM_DICT, 'loop', 5.0, 5.0, -1, 1, 0, 0, 0, 0)
    RemoveAnimDict(ANIM_DICT)

    local prop = attachBoard(entity)
    SetEntityAlpha(prop, 180)
    exports['illenium-appearance']:setPedAppearance(entity, data.skin)

    temp[cid] = { entity = entity, prop = prop }

    local contextId = 'cl_ped' .. cid

    local targetOptions = {
        {
            icon = 'fa-solid fa-circle-info',
            label = 'View Information',
            action = function()
                lib.registerContext({
                    id = contextId,
                    title = 'Player Disconnected',
                    options = {
                        {
                            title = ('%s [%s]'):format(data.name, data.id),
                            description = ('Reason: %s'):format(data.reason),
                            icon = 'circle-info',
                            onSelect = function()
                                local info = ('**Character Name**: %s\n**ID**: %s\n**License**: %s\n**Reason**: %s'):format(data.name, data.id, data.license, data.reason)
                                lib.setClipboard(info)
                                lib.notify({ title = 'Player Information', description = 'Copied the player\'s information.', position = 'center-right' })
                            end,
                        },
                    },
                })
                lib.showContext(contextId)
            end,
        },
    }

    targetLocalEntity(entity, targetOptions, 1.2)

    SetTimeout(15000, function()
        cleanupEntry(cid)
    end)
end)

AddEventHandler('onResourceStop', function(res)
    if GetCurrentResourceName() ~= res or not hasPlyLoaded() then return end
    clearEverything()
end)
