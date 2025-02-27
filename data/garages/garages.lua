-- [[
---*   automobile
---*   bike
---*   boat
---*   heli
---*   plane
---*   submarine
---*   trailer
---*   train
--]]
return {
    meeting_point = {
        coords = vec4(99.7660, -1072.9797, 28.3741, 251.4743),
        blip = {
            label = 'Meeting Point Garage',
            sprite = 357,
            color = 44,
            scale = 0.7
        },
        ped = {
            model = 's_m_y_valet_01',
            animation = {
                name = 'WORLD_HUMAN_GUARD_STAND'
            }
        },
        allowedTypes = {
            'automobile', 'bike'
        },
        spawnpoints = {
            vec4(104.1794, -1078.7241, 29.1924, 344.2014)
        },
        polyZone = {
            points = {
                vec3(96.0, -1078.0, 29.0),
                vec3(110.0, -1046.0, 29.0),
                vec3(152.0, -1060.0, 29.0),
                vec3(151.0, -1064.0, 29.0),
                vec3(173.0, -1073.0, 29.0),
                vec3(173.0, -1089.0, 29.0),
                vec3(166.0, -1089.0, 29.0),
                vec3(166.0, -1087.0, 29.0),
                vec3(119.0, -1085.0, 29.0),
                vec3(113.0, -1084.0, 29.0),
            },
            thickness = 4.0,
        }
    }
}
