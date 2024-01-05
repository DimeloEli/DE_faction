exports.ox_target:addGlobalPlayer({ -- PD interactions
    {
        label = 'Frisk',
        icon = 'fas fa-handcuffs',
        groups = 'police',
        event = 'DE_faction:frisk',
        canInteract = function(entity)
            return not IsEntityDead(entity)
        end,
    },
    {
        label = 'Handcuff',
        icon = 'fas fa-handcuffs',
        groups = 'police',
        event = 'DE_faction:CuffEye',
        canInteract = function(entity)
            return not IsEntityDead(entity) and not Entity(entity).state.isCuffed
        end,
    },
    {
        label = 'Uncuff',
        icon = 'fas fa-handcuffs',
        groups = 'police',
        event = 'DE_faction:UncuffEye',
        canInteract = function(entity)
            return not IsEntityDead(entity) and Entity(entity).state.isCuffed
        end,
    },
    {
        label = 'Drag',
        icon = 'fas fa-handcuffs',
        groups = 'police',
        event = 'DE_faction:PDDragEye',
        canInteract = function(entity)
            return not IsEntityDead(entity) and Entity(entity).state.isCuffed
        end,
    },
    {
        label = 'Put In Vehicle',
        icon = 'fas fa-plus-square',
        groups = 'police',
        event = 'DE_faction:vehicleAction',
        type = 'seat',
        canInteract = function(entity)
            return not IsEntityDead(entity) and Entity(entity).state.isCuffed
        end,
    },
    {
        label = 'Take From Vehicle',
        icon = 'fas fa-minus-square',
        groups = 'police',
        event = 'DE_faction:vehicleAction',
        type = 'unseat',
        canInteract = function(entity)
            return not IsEntityDead(entity) and Entity(entity).state.isCuffed
        end,
    }
})

exports.ox_target:addGlobalPlayer({ -- EMS interactions
    {
        label = 'Heal',
        icon = 'fas fa-suitcase-medical',
        groups = {['ambulance'] = 0, ['police'] = 0},
        event = 'DE_faction:heal',
        canInteract = function(entity)
            return not IsEntityDead(entity) and GetEntityHealth(entity) - 100 < 100
        end,
    },
    {
        label = 'Revive',
        icon = 'fas fa-suitcase-medical',
        groups = {['ambulance'] = 0, ['police'] = 0},
        event = 'DE_faction:revive',
        canInteract = function(entity)
            return IsEntityDead(entity)
        end,
    },
    {
        label = 'Drag',
        icon = 'fas fa-suitcase-medical',
        groups = 'ambulance',
        event = 'DE_faction:EMSDragEye',
        canInteract = function(entity)
            return not IsEntityDead(entity)
        end,
    },
    {
        label = 'Put In Vehicle',
        icon = 'fas fa-plus-square',
        groups = 'ambulance',
        event = 'DE_faction:vehicleAction',
        type = 'seat',
        canInteract = function(entity)
            return not IsEntityDead(entity)
        end,
    },
    {
        label = 'Take From Vehicle',
        icon = 'fas fa-minus-square',
        groups = 'ambulance',
        event = 'DE_faction:vehicleAction',
        type = 'unseat',
        canInteract = function(entity)
            return not IsEntityDead(entity)
        end,
    }
})

exports.ox_target:addGlobalVehicle({ -- Mechanic Interactions
    {
        label = 'Impound',
        icon = 'fas fa-car',
        groups = {['police'] = 0, ['mechanic'] = 0},
        event = 'DE_faction:ImpoundVehicle',
    },
    {
        label = 'Clean',
        icon = 'fas fa-car',
        groups = {['police'] = 0, ['mechanic'] = 0},
        event = 'DE_faction:CleanVehicle',
        distance = 2.0,
    },
    {
        label = 'Unlock',
        icon = 'fas fa-car',
        groups = 'police',
        event = 'DE_faction:UnlockVehicle',
        distance = 2.0,
        canInteract = function(entity)
            return GetVehicleDoorLockStatus(entity) == 2
        end,
    }
})

for k, v in pairs(Config.Duty) do
    exports.ox_target:addBoxZone({
        coords = v.DutyCoords.xyz,
        size = vector3(1, 1, 2),
        rotation = v.DutyCoords.w,
        debug = false,
        options = {
            {
                label = 'Sign In',
                icon = 'fas fa-clipboard',
                groups = 'off' .. v.job,
                serverEvent = 'DE_faction:duty',
            },
            {
                label = 'Sign Out',
                icon = 'fas fa-clipboard',
                groups = v.job,
                serverEvent = 'DE_faction:duty',
            }
        }
    })
end