
-- Created by ImperialCodez
local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("drag:server:putInVehicle", function(targetId)
    local src = source
    if GetPlayerPed(src) and GetPlayerPed(GetPlayerFromId(targetId)) then
        TriggerClientEvent("drag:client:putInVehicle", src, targetId)
    end
end)

RegisterServerEvent("drag:server:pullOutVehicle", function(targetId)
    local src = source
    if GetPlayerPed(src) and GetPlayerPed(GetPlayerFromId(targetId)) then
        TriggerClientEvent("drag:client:pullOutVehicle", src, targetId)
    end
end)
