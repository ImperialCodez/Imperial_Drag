local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("drag:server:putInVehicle", function(targetId)
    local src = source
    -- Ensure we are using correct functions for player identifiers
    local targetPlayer = QBCore.Functions.GetPlayer(targetId)

    if targetPlayer then
        TriggerClientEvent("drag:client:putInVehicle", src, targetId)
    else
        print("Error: Player with ID " .. targetId .. " not found.")
    end
end)

RegisterServerEvent("drag:server:pullOutVehicle", function(targetId)
    local src = source
    -- Ensure we are using correct functions for player identifiers
    local targetPlayer = QBCore.Functions.GetPlayer(targetId)

    if targetPlayer then
        TriggerClientEvent("drag:client:pullOutVehicle", src, targetId)
    else
        print("Error: Player with ID " .. targetId .. " not found.")
    end
end)
