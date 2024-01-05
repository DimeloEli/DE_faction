Config = {}

Config.Blips = {
    {label = 'Hospital', coords = vector3(299.63, -584.72, 43.26), id = 61, color = 2, scale = 0.7},
    {label = 'Police Station', coords = vector3(425.1, -979.5, 30.7), id = 60, color = 29, scale = 0.7}
}

Config.GenderNumbers = {
	['male'] = 4,
	['female'] = 5
}

Config.Garages = {
    {
        SpawnCoords = vector4(440.1377, -1021.5377, 28.0249, 91.3087),
        PedCoords = vector4(458.4638, -1017.2072, 28.2185, 91.8906),
        PedModel = 's_m_y_cop_01',
        job = 'police',
        vehicles = {
            {label = 'Police Car', model = 'police'},
            {label = 'Riot Van', model = 'riot'}
        }
    },
    {
        SpawnCoords = vector4(337.2954, -546.9200, 28.1371, 273.4630),
        PedCoords = vector4(333.4722, -563.9605, 28.7968, 161.0334),
        PedModel = 's_m_m_paramedic_01',
        job = 'ambulance',
        vehicles = {
            {label = 'Ambulance', model = 'ambulance'}
        }
    }
}

Config.Duty = {
    {
        DutyCoords = vector4(441.3096, -981.8527, 30.6896, 266.2555),
        job = 'police'
    },
    {
        DutyCoords = vector4(310.4146, -597.0709, 43.2841, 159.6694),
        job = 'ambulance'
    }
}