if GetResourceState('qbx_core') ~= 'started' then return end


RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    clearEverything()
end)

function hasPlyLoaded()
    return LocalPlayer.state.isLoggedIn
end

function DoNotification(text, nType)
    exports.qbx_core:Notify(text, nType)
end
