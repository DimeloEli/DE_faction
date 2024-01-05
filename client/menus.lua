lib.registerMenu({
    id = 'pd_options',
    title = 'PD Interaction Options',
    position = 'bottom-right',
    options = {
        {label = 'Civilian Interactions', description = 'Interact with a civilian.'},
        {label = 'Vehicle Interactions', description = 'Interact with a vehicle.'},
    }
}, function(selected, scrollIndex, args)
    if selected == 1 then
        lib.showMenu('pd_civilian')
    elseif selected == 2 then
        lib.showMenu('pd_vehicle')
    end
end)

lib.registerMenu({
    id = 'pd_civilian',
    title = 'PD Civilian Interactions',
    position = 'bottom-right',
    onClose = function(keyPressed)
        lib.showMenu('pd_options')
    end,
    options = {
        {label = 'Frisk', description = 'Frisk a civilian.', close = false},
        {label = 'Handcuff', description = 'Handcuff a suspect.', close = false},
        {label = 'Uncuff', description = 'Uncuff a civilian.', close = false},
        {label = 'Drag', description = 'Drag a suspect.', close = false},
        {label = 'Put In Vehicle', description = 'Put suspect in vehicle.', close = false},
        {label = 'Take From Vehicle', description = 'Take suspect from vehicle.', close = false},
    }
}, function(selected, scrollIndex, args)
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
    local target = GetPlayerServerId(closestPlayer)
    
    if selected == 1 then
        if distance ~= -1 and distance <= 3.0 then
			TriggerEvent('DE_faction:frisk')
		else
			TriggerEvent('ox_lib:notify', {type = 'error', description = 'No player nearby.'})
		end
    elseif selected == 2 then
        if distance ~= -1 and distance <= 3.0 then
            if not Entity(GetPlayerPed(closestPlayer)).state.isCuffed then
                playerHeading = GetEntityHeading(PlayerPedId())
	            playerLocation = GetEntityForwardVector(PlayerPedId())
	            playerCoords = GetEntityCoords(PlayerPedId())

                Entity(GetPlayerPed(closestPlayer)).state.isCuffed = true
			    TriggerServerEvent('DE_faction:server:Cuff', target, playerHeading, playerCoords, playerLocation)
            else
                TriggerEvent('ox_lib:notify', {type = 'error', description = 'Player already handcuffed.'})
            end
		else
			TriggerEvent('ox_lib:notify', {type = 'error', description = 'No player nearby.'})
		end
    elseif selected == 3 then
        if distance ~= -1 and distance <= 3.0 then
            if Entity(GetPlayerPed(closestPlayer)).state.isCuffed then
			    playerHeading = GetEntityHeading(PlayerPedId())
                playerLocation = GetEntityForwardVector(PlayerPedId())
                playerCoords = GetEntityCoords(PlayerPedId())

                Entity(GetPlayerPed(closestPlayer)).state.isCuffed = false
                TriggerServerEvent('DE_faction:server:Uncuff', target, playerHeading, playerCoords, playerLocation)
            else
                TriggerEvent('ox_lib:notify', {type = 'error', description = 'Player isn\'t handcuffed.'})
            end
		else
			TriggerEvent('ox_lib:notify', {type = 'error', description = 'No player nearby.'})
		end
    elseif selected == 4 then
        if distance ~= -1 and distance <= 3.0 then
            if Entity(GetPlayerPed(closestPlayer)).state.isCuffed then
			    TriggerServerEvent('DE_faction:server:PDDrag', target)
            else
                TriggerEvent('ox_lib:notify', {type = 'error', description = 'Player isn\'t handcuffed.'})
            end
		else
			TriggerEvent('ox_lib:notify', {type = 'error', description = 'No player nearby.'})
		end
    elseif selected == 5 then
        if distance ~= -1 and distance <= 3.0 then
            if Entity(GetPlayerPed(closestPlayer)).state.isCuffed then
                TriggerServerEvent('DE_faction:car', target, 'put')
            else
                TriggerEvent('ox_lib:notify', {type = 'error', description = 'Player isn\'t handcuffed.'})
            end
        else
            TriggerEvent('ox_lib:notify', {type = 'error', description = 'No player nearby.'})
        end
    elseif selected == 6 then
        if distance ~= -1 and distance <= 3.0 then
            if Entity(GetPlayerPed(closestPlayer)).state.isCuffed then
                TriggerServerEvent('DE_faction:car', target, 'take')
            else
                TriggerEvent('ox_lib:notify', {type = 'error', description = 'Player isn\'t handcuffed.'})
            end
        else
            TriggerEvent('ox_lib:notify', {type = 'error', description = 'No player nearby.'})
        end
    end
end)

lib.registerMenu({
    id = 'pd_vehicle',
    title = 'PD Vehicle Interactions',
    position = 'bottom-right',
    onClose = function(keyPressed)
        lib.showMenu('pd_options')
    end,
    options = {
        {label = 'Impound', description = 'Impound a Vehicle.'},
        {label = 'Clean', description = 'Clean a Vehicle.'},
        {label = 'Unlock', description = 'Unlock a Vehicle.'},
    }
}, function(selected, scrollIndex, args)
    local PlayerPed = PlayerPedId()
    local PlayerCoords = GetEntityCoords(PlayerPed)
    vehicle = ESX.Game.GetVehicleInDirection()
    
    if selected == 1 then
        if IsAnyVehicleNearPoint(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 2.0) then
			TriggerEvent('DE_faction:ImpoundVehicle', {entity = vehicle})
		else
			TriggerEvent('ox_lib:notify', {type = 'error', description = 'No vehicle nearby.'})
		end
    elseif selected == 2 then
        if IsAnyVehicleNearPoint(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 2.0) then
			TriggerEvent('DE_faction:CleanVehicle', {entity = vehicle})
		else
			TriggerEvent('ox_lib:notify', {type = 'error', description = 'No vehicle nearby.'})
		end
    elseif selected == 3 then
        if IsAnyVehicleNearPoint(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 2.0) then
            if GetVehicleDoorLockStatus(vehicle) == 2 then
			    TriggerEvent('DE_faction:UnlockVehicle', {entity = vehicle})
            else
                TriggerEvent('ox_lib:notify', {type = 'error', description = 'Vehicle is not locked.'})
            end
		else
			TriggerEvent('ox_lib:notify', {type = 'error', description = 'No vehicle nearby.'})
		end
    end
end)

lib.registerMenu({
    id = 'ems_menu',
    title = 'EMS Interaction Menu',
    position = 'bottom-right',
    options = {
        {label = 'Heal', description = 'Heal a person.', close = false},
        {label = 'Revive', description = 'Revive a person.', close = false},
        {label = 'Drag', description = 'Drag a person.', close = false},
    }
}, function(selected, scrollIndex, args)
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
    local target = GetPlayerServerId(closestPlayer)

    if selected == 1 then
        if distance ~= -1 and distance <= 3.0 then
			TriggerServerEvent('DE_faction:server:heal', target)
		else
			TriggerEvent('ox_lib:notify', {type = 'error', description = 'No player nearby.'})
		end
    elseif selected == 2 then
        if distance ~= -1 and distance <= 3.0 then
            if IsEntityDead(GetPlayerPed(closestPlayer)) then
			    TriggerServerEvent('DE_faction:server:revive', target)
            else
                TriggerEvent('ox_lib:notify', {type = 'error', description = 'Player is not dead.'})
            end
		else
			TriggerEvent('ox_lib:notify', {type = 'error', description = 'No player nearby.'})
		end
    elseif selected == 3 then
        if distance ~= -1 and distance <= 3.0 then
            TriggerServerEvent('DE_faction:server:EMSDrag', target)
		else
			TriggerEvent('ox_lib:notify', {type = 'error', description = 'No player nearby.'})
		end
    end
end)

lib.registerMenu({
    id = 'mechanic_menu',
    title = 'Mechanic Vehicle Interactions',
    position = 'bottom-right',
    options = {
        {label = 'Impound', description = 'Impound a Vehicle.'},
        {label = 'Clean', description = 'Clean a Vehicle.'},
    }
}, function(selected, scrollIndex, args)
    local PlayerPed = PlayerPedId()
    local PlayerCoords = GetEntityCoords(PlayerPed)
    vehicle = ESX.Game.GetVehicleInDirection()
    
    if selected == 1 then
        if IsAnyVehicleNearPoint(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 2.0) then
			TriggerEvent('DE_faction:ImpoundVehicle', {entity = vehicle})
		else
			TriggerEvent('ox_lib:notify', {type = 'error', description = 'No vehicle nearby.'})
		end
    elseif selected == 2 then
        if IsAnyVehicleNearPoint(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 2.0) then
			TriggerEvent('DE_faction:CleanVehicle', {entity = vehicle})
		else
			TriggerEvent('ox_lib:notify', {type = 'error', description = 'No vehicle nearby.'})
		end
    end
end)