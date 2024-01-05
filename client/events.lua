-- PD Events
dragStatus, isDragged = {}, false

RegisterNetEvent('DE_faction:frisk')
AddEventHandler('DE_faction:frisk', function()
    exports['ox_inventory']:openNearbyInventory()
end)

RegisterNetEvent('DE_faction:CuffEye')
AddEventHandler('DE_faction:CuffEye', function(data)
    local entity = data.entity
    local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
    playerHeading = GetEntityHeading(PlayerPedId())
	playerLocation = GetEntityForwardVector(PlayerPedId())
	playerCoords = GetEntityCoords(PlayerPedId())

    Entity(entity).state.isCuffed = true
    TriggerServerEvent('DE_faction:server:Cuff', target, playerHeading, playerCoords, playerLocation)
end)

RegisterNetEvent('DE_faction:Cuff:Player')
AddEventHandler('DE_faction:Cuff:Player', function(heading, coords, location)
    local plyPed = PlayerPedId()
	SetCurrentPedWeapon(plyPed, GetHashKey('WEAPON_UNARMED'), true)
	local x, y, z   = table.unpack(coords + location * 1.0)
	SetEntityCoords(plyPed, x, y, z - 1)
	SetEntityHeading(plyPed, heading)
	Citizen.Wait(250)

	ESX.Streaming.RequestAnimDict('mp_arrest_paired', function()
		TaskPlayAnim(plyPed, 'mp_arrest_paired', 'crook_p2_back_left', 8.0, -8, 3750, 2, 0.0, false, false, false)
	end)

	Citizen.Wait(3760)
	ESX.Streaming.RequestAnimDict('mp_arresting', function()
        TaskPlayAnim(plyPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
    end)

    SetEnableHandcuffs(plyPed, true)
    DisablePlayerFiring(plyPed, true)
    SetPedCanPlayGestureAnims(plyPed, false)
    DisplayRadar(false)
end)

RegisterNetEvent('DE_faction:Cuff:Police')
AddEventHandler('DE_faction:Cuff:Police', function()
    local plyPed = PlayerPedId()

    Citizen.Wait(250)
	ESX.Streaming.RequestAnimDict('mp_arrest_paired', function()
		TaskPlayAnim(plyPed, 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8, 3750, 2, 0.0, false, false, false)
	end)
end)

RegisterNetEvent('DE_faction:UncuffEye')
AddEventHandler('DE_faction:UncuffEye', function(data)
    local entity = data.entity
    local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
    playerHeading = GetEntityHeading(PlayerPedId())
	playerLocation = GetEntityForwardVector(PlayerPedId())
	playerCoords = GetEntityCoords(PlayerPedId())

    Entity(entity).state.isCuffed = false
    TriggerServerEvent('DE_faction:server:Uncuff', target, playerHeading, playerCoords, playerLocation)
end)

RegisterNetEvent('DE_faction:Uncuff:Player')
AddEventHandler('DE_faction:Uncuff:Player', function(heading, coords, location)
	local plyPed = PlayerPedId()
	local x, y, z = table.unpack(coords + location * 1.0)
	SetEntityCoords(plyPed, x, y, z - 1)
	SetEntityHeading(plyPed, heading)
	Citizen.Wait(250)

    ESX.Streaming.RequestAnimDict('mp_arresting', function()
		TaskPlayAnim(plyPed, 'mp_arresting', 'b_uncuff', 8.0, -8, -1, 2, 0.0, false, false, false)
	end)
	Citizen.Wait(5500)

    ClearPedTasks(plyPed)
    SetEnableHandcuffs(plyPed, false)
    DisablePlayerFiring(plyPed, false)
    SetPedCanPlayGestureAnims(plyPed, true)
    FreezeEntityPosition(plyPed, false)
end)

RegisterNetEvent('DE_faction:Uncuff:Police')
AddEventHandler('DE_faction:Uncuff:Police', function()
	local plyPed = PlayerPedId()
	Citizen.Wait(250)
	ESX.Streaming.RequestAnimDict('mp_arresting', function()
		TaskPlayAnim(plyPed, 'mp_arresting', 'a_uncuff', 8.0, -8, -1, 2, 0.0, false, false, false)
	end)

	Citizen.Wait(5500)
	ClearPedTasks(plyPed)
end)

RegisterNetEvent('DE_faction:PDDragEye')
AddEventHandler('DE_faction:PDDragEye', function(data)
    local entity = data.entity
    local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))

    TriggerServerEvent('DE_faction:server:PDDrag', target)
end)

RegisterNetEvent('DE_faction:PDDrag')
AddEventHandler('DE_faction:PDDrag', function(cop)
	isDragged = not isDragged
	dragStatus.CopId = cop
end)

RegisterNetEvent('DE_faction:vehicleAction')
AddEventHandler('DE_faction:vehicleAction', function(data)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local target = GetPlayerServerId(closestPlayer)

    if closestPlayer ~= -1 and closestDistance <= 2 then
        if data.type == 'seat' then
            TriggerServerEvent('DE_faction:car', target, 'put')
        elseif data.type == 'unseat' then
            TriggerServerEvent('DE_faction:car', target, 'take')
        end
    end
end)

RegisterNetEvent('DE_faction:putInVehicle')
AddEventHandler('DE_faction:putInVehicle', function()
    local playerPed = PlayerPedId()
    local vehicle, distance = ESX.Game.GetClosestVehicle()

    if vehicle and distance < 5 then
        local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

        for i=maxSeats - 1, 0, -1 do
            if IsVehicleSeatFree(vehicle, i) then
                freeSeat = i
                break
            end
        end

        if freeSeat then
            TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
            dragStatus.isDragged = false
        end
    end
end)

RegisterNetEvent('DE_faction:pulloutOfVehicle')
AddEventHandler('DE_faction:pulloutOfVehicle', function()
	local GetVehiclePedIsIn = GetVehiclePedIsIn
	local IsPedSittingInAnyVehicle = IsPedSittingInAnyVehicle
	local TaskLeaveVehicle = TaskLeaveVehicle
	if IsPedSittingInAnyVehicle(ESX.PlayerData.ped) then
		local vehicle = GetVehiclePedIsIn(ESX.PlayerData.ped, false)
		TaskLeaveVehicle(ESX.PlayerData.ped, vehicle, 64)
	end
end)

-- EMS Events
edragStatus, eisDragged = {}, false

RegisterNetEvent('DE_faction:heal')
AddEventHandler('DE_faction:heal', function(data)
    local entity = data.entity
    local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))

    ESX.ShowNotification('You have healed a player')
    TriggerServerEvent('DE_faction:server:heal', target)
end)

RegisterNetEvent('DE_faction:revive')
AddEventHandler('DE_faction:revive', function(data)
    local entity = data.entity
    local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))

    ESX.ShowNotification('You have revived a player')
    TriggerServerEvent('DE_faction:server:revive', target)
end)

RegisterNetEvent('DE_faction:EMSDragEye')
AddEventHandler('DE_faction:EMSDragEye', function(data)
    local entity = data.entity
    local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))

    TriggerServerEvent('DE_faction:server:EMSDrag', target)
end)

RegisterNetEvent('DE_faction:EMSDrag')
AddEventHandler('DE_faction:EMSDrag', function(paramedic)
    eisDragged = not eisDragged
    edragStatus.EmsId = paramedic
end)

-- Mechanic Events
RegisterNetEvent('DE_faction:ImpoundVehicle')
AddEventHandler('DE_faction:ImpoundVehicle', function(data)
    local entity = data.entity
    
    lib.progressCircle({label = 'Impounding Vehicle', duration = 2500, position = 'bottom', canCancel = false, disable = {move = false, combat = true, car = true, mouse = false}})
    DeleteEntity(entity)
    lib.notify({type = 'inform', description = 'You have successfully impounded this vehicle'})
end)

RegisterNetEvent('DE_faction:CleanVehicle')
AddEventHandler('DE_faction:CleanVehicle', function(data)
    local entity = data.entity
    
    lib.progressCircle({label = 'Cleaning Vehicle', duration = 5000, position = 'bottom', canCancel = false, anim = {scenario = 'WORLD_HUMAN_MAID_CLEAN'}, disable = {move = true, combat = true, car = true, mouse = false}})
    SetVehicleDirtLevel(entity, 0)
    lib.notify({type = 'inform', description = 'You have successfully cleaned this vehicle'})
end)

RegisterNetEvent('DE_faction:UnlockVehicle')
AddEventHandler('DE_faction:UnlockVehicle', function(data)
    local entity = data.entity
    
    lib.progressCircle({label = 'Unlocking Vehicle', duration = 7500, position = 'bottom', canCancel = false, anim = {scenario = 'WORLD_HUMAN_WELDING'}, disable = {move = true, combat = true, car = true, mouse = false}})
    SetVehicleDoorsLocked(entity, 1)
	SetVehicleDoorsLockedForAllPlayers(entity, false)
    lib.notify({type = 'inform', description = 'You have successfully unlocked this vehicle'})
end)

-- Garage Events
jobVehicle = nil

RegisterNetEvent('DE_faction:OpenVehicleSelector')
AddEventHandler('DE_faction:OpenVehicleSelector', function(data)
	local Options = {}
	local garages = Config.Garages

    for k,v in ipairs(garages) do
        if data.job == v.job then
            for k2, v2 in pairs(v.vehicles) do
                table.insert(Options, {
                    title = v2.label,
                    event = 'DE_faction:spawnVehicle',
                    args = { model = v2.model, coords = v.SpawnCoords }
                })
            end
        end
    end

    lib.registerContext({
        id = 'vehicle_selector',
        title = 'Job Vehicle Selector',
        canClose = true,
        options = Options
    })

    lib.showContext('vehicle_selector')
end)

RegisterNetEvent('DE_faction:spawnVehicle')
AddEventHandler('DE_faction:spawnVehicle', function(data)
    ESX.Game.SpawnVehicle(data.model, data.coords.xyz, data.coords.w, function(vehicle)
        TaskWarpPedIntoVehicle(ESX.PlayerData.ped, vehicle, -1)
        lib.notify({ type = 'inform', title = 'Vehicle Selector', description = 'Your vehicle has been released' })
        exports['mk_vehiclekeys']:AddKey(vehicle)
        
        jobVehicle = vehicle
    end)
end)

RegisterNetEvent('DE_faction:ReturnJobVehicle')
AddEventHandler('DE_faction:ReturnJobVehicle', function()
    if jobVehicle ~= nil then
        DeleteEntity(jobVehicle)
        jobVehicle = nil
        lib.notify({ type = 'inform', description = 'Vehicle has been returned' })
    else
        lib.notify({ type = 'error', description = 'You don\'t currently have a vehicle out' })
    end
end)

-- Vehicle Events
RegisterNetEvent('DE_faction:getLiveries')
AddEventHandler('DE_faction:getLiveries', function()
    local Options = {}

    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local count = GetVehicleLiveryCount(vehicle)

    for i = 1, count, 1 do
        local liveryStatus = GetVehicleLivery(vehicle)
        if liveryStatus == i then 
            liveryStatus = "Enabled" 
        else 
            liveryStatus = "Disabled" 
        end
        
        table.insert(Options,{
            title = ('Livery %d:&nbsp; %s'):format(i, liveryStatus),
            description = "",
            event = "DE_faction:toggleLivery",
            args = { veh = vehicle, livery = i }
        })
    end

    lib.registerContext({
        id = 'livery_menu',
        title = 'Toggle Liverys',
        options = Options
    })

    lib.showContext('livery_menu')
end)

AddEventHandler('DE_faction:toggleLivery', function(data)
    if ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= "ambulance" then return end
    SetVehicleLivery(data.veh, data.livery)
    TriggerEvent('DE_faction:getLiveries')
    TriggerEvent('esx:fix')
end)

RegisterNetEvent('DE_faction:getExtras')
AddEventHandler('DE_faction:getExtras', function()
    local Options = {}

    for i = 1, 14, 1 do     
        local vehicle = GetVehiclePedIsIn(PlayerPedId())
        if DoesExtraExist(vehicle, i) then 
            local extraStatus = IsVehicleExtraTurnedOn(vehicle, i)
            if extraStatus then 
                extraStatus = "Enabled" 
            else 
                extraStatus = "Disabled" 
            end

            table.insert(Options, {
                title = ('Extra %d:&nbsp; %s'):format(i, extraStatus),
                description = "",
                event = "DE_faction:toggleExtras",
                args = { veh = vehicle, extra = i }
            })
        end
    end

    lib.registerContext({
        id = 'extras_menu',
        title = 'Toggle Extras',
        options = Options
    })

    lib.showContext('extras_menu')
end)

AddEventHandler('DE_faction:toggleExtras', function(data)
    local extraStatus = IsVehicleExtraTurnedOn(data.veh, data.extra)
    if extraStatus then 
        SetVehicleAutoRepairDisabled(data.veh, true)
        SetVehicleExtra(data.veh, data.extra, true)
    else 
        SetVehicleAutoRepairDisabled(data.veh, true)
        SetVehicleExtra(data.veh, data.extra, false)
        TriggerEvent('esx:fix')
    end 

    TriggerEvent('DE_faction:getExtras')
end)

RegisterNetEvent('DE_faction:cleanVehicle')
AddEventHandler('DE_faction:cleanVehicle', function()
    if ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= "ambulance" then return end

    local vehicle = GetVehiclePedIsIn(PlayerPedId())

    FreezeEntityPosition(vehicle, true)
    lib.progressCircle({ label = 'Cleaning Vehicle', duration = 3500, position = 'bottom', canCancel = false, disable = { move = true, car = true, combat = true, mouse = false }})
    SetVehicleDirtLevel(vehicle, 0.0)
    FreezeEntityPosition(vehicle, false)
end)

RegisterNetEvent('DE_faction:repairVehicle')
AddEventHandler('DE_faction:repairVehicle', function()
    if ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= "ambulance" then return end

    local vehicle = GetVehiclePedIsIn(PlayerPedId())

    FreezeEntityPosition(vehicle, true)
    lib.progressCircle({ label = 'Repairing Vehicle', duration = 5000, position = 'bottom', canCancel = false, disable = { move = true, car = true, combat = true, mouse = false }})
    SetVehicleFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)
    FreezeEntityPosition(vehicle, false)
end)