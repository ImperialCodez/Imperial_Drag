local QBCore = exports['qb-core']:GetCoreObject()

local function IsPlayerDown(ped)
    return IsEntityDead(ped) or IsPedRagdoll(ped)
end

local function GetNearestVehicle(coords, radius)
    local vehicles = GetGamePool("CVehicle")
    local closestVeh, closestDist = nil, radius

    for _, veh in pairs(vehicles) do
        local dist = #(coords - GetEntityCoords(veh))
        if dist < closestDist then
            closestVeh, closestDist = veh, dist
        end
    end

    return closestVeh
end

RegisterNetEvent("drag:client:putInVehicle", function(target)
    local targetPed = GetPlayerPed(GetPlayerServerId(target))
    if not targetPed then return end

    ClearPedTasksImmediately(targetPed)
    Wait(300)

    local success = lib.progressCircle({
        duration = 3000,
        label = 'Placing into vehicle...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, mouse = false },
        anim = {
            dict = "missfinale_c2mcs_1",
            clip = "fin_c2_mcs_1_camman"
        }
    })

    if not success then return end

    local veh = GetNearestVehicle(GetEntityCoords(targetPed), 5.0)
    if veh then
        for seat = -1, GetVehicleMaxNumberOfPassengers(veh) - 1 do
            if IsVehicleSeatFree(veh, seat) then
                TaskWarpPedIntoVehicle(targetPed, veh, seat)
                return
            end
        end
        QBCore.Functions.Notify("No free seats", "error")
    else
        QBCore.Functions.Notify("No vehicle nearby", "error")
    end
end)

RegisterNetEvent("drag:client:pullOutVehicle", function(target)
    local targetPed = GetPlayerPed(GetPlayerServerId(target))
    if not targetPed then return end

    local success = lib.progressCircle({
        duration = 3000,
        label = 'Removing from vehicle...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, mouse = false },
        anim = {
            dict = "missfinale_c2mcs_1",
            clip = "fin_c2_mcs_1_camman"
        }
    })

    if not success then return end

    local veh = GetVehiclePedIsIn(targetPed, false)
    if veh and veh ~= 0 then
        TaskLeaveVehicle(targetPed, veh, 0)
    else
        QBCore.Functions.Notify("Target not in a vehicle", "error")
    end
end)

exports.ox_target:addGlobalPlayer({
    {
        label = "Put in Vehicle",
        icon = "fas fa-car-side",
        onSelect = function(data)
            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            TriggerServerEvent("drag:server:putInVehicle", targetId)
        end,
        canInteract = function(entity)
            return not IsPedInAnyVehicle(entity, false)
        end
    },
    {
        label = "Take out of Vehicle",
        icon = "fas fa-car-burst",
        onSelect = function(data)
            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            TriggerServerEvent("drag:server:pullOutVehicle", targetId)
        end,
        canInteract = function(entity)
            return IsPedInAnyVehicle(entity, false)
        end
    }
})
