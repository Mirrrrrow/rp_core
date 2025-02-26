return {
    airport = {
        label = 'Airport Bicycle Rental',
        coords = vec4(-1046.68, -2728.36, 19.17, 238.01),
        ped = {
            model = `a_m_m_prolhost_01`,
            animation = {
                dict = 'friends@frj@ig_1',
                name = 'wave_a',
                flag = 1,
            },
        },
        blip = {
            sprite = 226,
            color = 24,
            label = 'Bicycle Rental',
            scale = 0.7,
        },
        items = {
            bmx = {
                icon = 'fas fa-bicycle',
                pricePerMinute = 5,
                contract = true,
                modifications = {
                    plate = '000000'
                }
            }
        },
        spawnpoints = {
            vec4(-1039.6387, -2724.8054, 20.1631, 299.3374),
            --vec4(-1047.4242, -2725.9915, 18.5588, 274.4802),
            --vec4(-1046.9692, -2726.8735, 19.5580, 285.9687)
        }
    }
} --[[@as table<string, VehicleRentalConfig>]]
