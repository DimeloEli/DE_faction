RegisterCommand('drag', function(playerId, args, rawCommand)
    if ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= 'ambulance' then return end
  
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local target = GetPlayerServerId(closestPlayer)
  
    if closestPlayer ~= -1 and closestDistance <= 2 then
        if ESX.PlayerData.job.name == 'police' and Entity(closestPlayer).state.isCuffed then
            TriggerServerEvent('DE_faction:server:PDDrag', target)
        else
            TriggerServerEvent('DE_faction:server:EMSDrag', target)
        end
    end
end)

RegisterCommand('frepair', function(source, args, rawCommand)
    TriggerEvent('DE_faction:repairVehicle')
end)

RegisterCommand('fclean', function(source, args, rawCommand)
    TriggerEvent('DE_faction:cleanVehicle')
end)

RegisterCommand('flivery', function(source, args, rawCommand)
    TriggerEvent('DE_faction:getLiveries')
end)

RegisterCommand('fextra', function(source, args, rawCommand)
    TriggerEvent('DE_faction:getExtras')
end)