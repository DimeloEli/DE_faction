spawnedPeds = {}

function NearPed(model, coords, job)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(50)
	end

	spawnedPed = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)

	SetEntityAlpha(spawnedPed, 0, false)
	FreezeEntityPosition(spawnedPed, true)
	SetEntityInvincible(spawnedPed, true)
	SetBlockingOfNonTemporaryEvents(spawnedPed, true)

    for i = 0, 255, 51 do
        Wait(50)
        SetEntityAlpha(spawnedPed, i, false)
    end

    exports.ox_target:addLocalEntity(spawnedPed, {
        {
            label = 'Job Vehicle Selection',
            icon = 'fas fa-car',
            groups = job,
            event = 'DE_faction:OpenVehicleSelector',
            job = job,
        },
        {
            label = 'Return Job Vehicle',
            icon = 'fas fa-rotate-left',
            groups = job,
            event = 'DE_faction:ReturnJobVehicle',
        }
    })

	return spawnedPed
end