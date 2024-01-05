-- Duty Event
RegisterNetEvent('DE_faction:duty')
AddEventHandler('DE_faction:duty', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.job.name == "police" then
        if ESX.DoesJobExist("offpolice", xPlayer.job.grade) then
            xPlayer.setJob("offpolice", xPlayer.job.grade)
        end
    elseif xPlayer.job.name == "ambulance" then
        if ESX.DoesJobExist("offambulance", xPlayer.job.grade) then
            xPlayer.setJob("offambulance", xPlayer.job.grade)
        end
    elseif xPlayer.job.name == "offpolice" then
        if ESX.DoesJobExist("police", xPlayer.job.grade) then
            xPlayer.setJob("police", xPlayer.job.grade)
        end
    elseif xPlayer.job.name == "offambulance" then
        if ESX.DoesJobExist("ambulance", xPlayer.job.grade) then
            xPlayer.setJob("ambulance", xPlayer.job.grade)
        end
    end
end)

-- PD Events
RegisterNetEvent('DE_faction:server:Cuff')
AddEventHandler('DE_faction:server:Cuff', function(target, heading, coords, location)
    TriggerClientEvent('DE_faction:Cuff:Player', target, heading, coords, location)
    TriggerClientEvent('DE_faction:Cuff:Police', source)
end)

RegisterNetEvent('DE_faction:server:Uncuff')
AddEventHandler('DE_faction:server:Uncuff', function(target, heading, coords, location)
    TriggerClientEvent('DE_faction:Uncuff:Player', target, heading, coords, location)
    TriggerClientEvent('DE_faction:Uncuff:Police', source)
end)

RegisterNetEvent('DE_faction:server:PDDrag')
AddEventHandler('DE_faction:server:PDDrag', function(target)
    TriggerClientEvent('DE_faction:PDDrag', target, source)
end)

RegisterNetEvent('DE_faction:car')
AddEventHandler('DE_faction:car', function(target, type)
    if type == 'put' then
        TriggerClientEvent('DE_faction:putInVehicle', target)
    elseif type == 'take' then
        TriggerClientEvent('DE_faction:pulloutOfVehicle', target)
    end
end)

-- EMS Events
RegisterNetEvent('DE_faction:server:heal')
AddEventHandler('DE_faction:server:heal', function(target)
    TriggerClientEvent('esx_ambulancejob:heal', target, 'big', true)
end)

RegisterNetEvent('DE_faction:server:revive')
AddEventHandler('DE_faction:server:revive', function(target)
    TriggerClientEvent('esx_ambulancejob:revive', target)
end)

RegisterNetEvent('DE_faction:server:EMSDrag')
AddEventHandler('DE_faction:server:EMSDrag', function(target)
    TriggerClientEvent('DE_faction:EMSDrag', target, source)
end)
