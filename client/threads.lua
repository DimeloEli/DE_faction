CreateThread(function()
	for k, v in pairs(Config.Blips) do
		local blip = AddBlipForCoord(v.coords)

		SetBlipSprite(blip, v.id)
		SetBlipScale(blip, v.scale)
		SetBlipColour(blip, v.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(v.label)
		EndTextCommandSetBlipName(blip)
	end
end)

CreateThread(function()
	while true do
		Wait(500)
		for k,v in pairs(Config.Garages) do
			local playerCoords = GetEntityCoords(PlayerPedId())
			local distance = #(playerCoords - v.PedCoords.xyz)

			if distance < 6.0 and not spawnedPeds[k] then
				local spawnedPed = NearPed(v.PedModel, v.PedCoords, v.job)
				spawnedPeds[k] = { spawnedPed = spawnedPed }
			end

			if distance >= 6.0 and spawnedPeds[k] then
                for i = 255, 0, -51 do
                    Wait(50)
                    SetEntityAlpha(spawnedPeds[k].spawnedPed, i, false)
                end
				DeletePed(spawnedPeds[k].spawnedPed)
				spawnedPeds[k] = nil
			end
		end
	end
end)

-- Dragging (Police)
CreateThread(function()
	local wasDragged

	while true do
		Wait(0)
		local plyPed = PlayerPedId()

		if isDragged then
			local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

			if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
				if not wasDragged then
					AttachEntityToEntity(plyPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					wasDragged = true
				else
					Wait(1000)
				end
			else
				wasDragged = false
				isDragged = false
				DetachEntity(plyPed, true, false)
			end
		elseif wasDragged then
			wasDragged = false
			DetachEntity(plyPed, true, false)
		else
			Wait(500)
		end
	end
end)

-- Dragging (Fire Department)
CreateThread(function()
	local wasDragged

	while true do
		Wait(0)
		local plyPed = PlayerPedId()

		if eisDragged then
			local targetPed = GetPlayerPed(GetPlayerFromServerId(edragStatus.EmsId))

			if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
				if not wasDragged then
					AttachEntityToEntity(plyPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					wasDragged = true
				else
					Wait(1000)
				end
			else
				wasDragged = false
				eisDragged = false
				DetachEntity(plyPed, true, false)
			end
		elseif wasDragged then
			wasDragged = false
			DetachEntity(plyPed, true, false)
		else
			Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(5)

		if IsControlJustReleased(0, 167) then
			if ESX.PlayerData.job.name == "ambulance" then
				lib.showMenu('ems_menu')
			elseif ESX.PlayerData.job.name == "police" then
				lib.showMenu('pd_options')
			elseif ESX.PlayerData.job.name == "mechanic" then
				lib.showMenu('mechanic_menu')
			end
		end
	end
end)