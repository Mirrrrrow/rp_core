return {
    welcomer = {
        model = GetHashKey('mp_f_boatstaff_01'),
        coords = vec4(-1034.35, -2732.90, 19.17, 147.74),
        animation = {
            dict = 'anim@heists@prison_heiststation@cop_reactions',
            name = 'cop_b_idle',
            flag = 1,
        },
        options = {
            {
                label = 'How do I get to the city?',
                icon = 'fas fa-map-marked-alt',
                action = {
                    type = 'message',
                    data = {
                        title = 'City Directions',
                        type = 'info',
                        duration = 5000,
                        message =
                        {
                            'Just walk a bit haha!',
                            'Go to the taxi phone on your right and just call one...',
                            'You can rent a bicycle at the bike station near the entrance!',
                        }
                    }
                }
            },
            {
                label = 'EXAMPLE ACTION',
                icon = 'fas fa-question',
                action = {
                    type = 'custom',
                    callback = function()
                        print('This is an example action!')
                    end
                }
            }
        }
    }
}
