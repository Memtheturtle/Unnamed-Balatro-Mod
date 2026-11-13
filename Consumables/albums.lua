SMODS.Atlas{
    key = 'Albums',
    path = 'Albums.png',
    px = 71,
    py = 95
}

SMODS.ConsumableType{
    key = 'Albums',
    collection_rows = {5,6},
    primary_colour = G.C.WHITE,
    secondary_colour = G.C.GREY,
    loc_txt = {
        collection = 'Albums',
        name = 'Albums',
        undiscovered = {
            name = 'Hidden Albums',
            text = {'Go to Barnes and Noble'}
        }
    },
    shop_rate = 1,
}

SMODS.UndiscoveredSprite{
    key = 'Albums',
    atlas = 'Albums',
    pos = {x = 0, y = 2}
}

SMODS.Sound({
    key = "styan",
    path = "styan.mp3",
})

SMODS.Sound({
    key = "back_in_black",
    path = "back_in_black.mp3",
})

SMODS.Sound({
    key = "fitter_happier",
    path = "fitter_happier.mp3",
})

SMODS.Sound({
    key = "minecraft_volume_alpha",
    path = "minecraft_volume_alpha.mp3",
})

SMODS.Sound({
    key = "minecraft_volume_beta",
    path = "minecraft_volume_beta.mp3",
})

SMODS.Sound({
    key = "currents",
    path = "currents.mp3",
})

SMODS.Sound({
    key = "u",
    path = "u.mp3",
})

SMODS.Sound({
    key = "eits",
    path = "eits.mp3",
})

SMODS.Sound({
    key = "brat",
    path = "brat.mp3",
})

SMODS.Sound({
    key = "weezer",
    path = "weezer.mp3",
})

SMODS.Sound({
    key = "wetdream",
    path = "wetdream.mp3",
})

SMODS.Sound({
    key = "a_waterlogged_letter",
    path = "a_waterlogged_letter.mp3",
})

SMODS.Sound({
    key = "ityttmom",
    path = "ityttmom.mp3",
})

SMODS.Sound({
    key = "lagwafis",
    path = "lagwafis.mp3",
})

SMODS.Sound({
    key = "shsl",
    path = "shsl.mp3",
})

SMODS.Sound({
    key = "the_wall",
    path = "the_wall.mp3",
})

SMODS.Sound({
    key = "dsotm",
    path = "dark.mp3",
})

SMODS.Sound({
    key = "metallica",
    path = "metallica.mp3",
})

SMODS.Sound({
    key = "l_faps",
    path = "l_faps.mp3",
})

SMODS.Sound({
    key = "ok_computer",
    path = "ok_computer.mp3",
})

SMODS.Sound({
    key = "wyns",
    path = "wyns.mp3",
})

SMODS.Sound({
    key = "in_rainbows",
    path = "in_rainbows.mp3",
})

SMODS.Sound({
    key = "appetite_for_destruction",
    path = "appetite_for_destruction.mp3",
})

SMODS.Sound({
    key = "getting_killed",
    path = "getting_killed.mp3",
})

SMODS.Sound({
    key = "kid_a",
    path = "kid_a.mp3",
})

SMODS.Sound({
    key = "revengeseekerz",
    path = "revengeseekerz.mp3",
})

SMODS.Consumable{
    key = 'back_in_black',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 9, y = 0},
    loc_txt = {
        name = 'Back in Black',
        text = {
            'Placeholder',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_back_in_black')
    end,
}

SMODS.Consumable{
    key = 'eits',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 2, y = 0},
    loc_txt = {
        name = 'Eye in the Sky',
        text = {
            'Placeholder',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_eits')
    end,
}

SMODS.Consumable{
    key = 'minecraft_volume_alpha',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 0, y = 1},
    loc_txt = {
        name = 'Minecraft Volume Alpha',
        text = {
            'Placeholder'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_minecraft_volume_alpha')
    end,
}

SMODS.Consumable{
    key = 'minecraft_volume_beta',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 0, y = 1},
    loc_txt = {
        name = 'Minecraft Volume Beta',
        text = {
            'Placeholder'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_minecraft_volume_beta')
    end,
}

SMODS.Consumable{
    key = 'brat',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 0, y = 1},
    loc_txt = {
        name = 'BRAT',
        text = {
            'Placeholder',
            '{s:0.8}{C:inactive}Art by Memtheturtle{}',
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_brat')
    end,
}

SMODS.Consumable{
    key = 'styan',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 0, y = 1},
    loc_txt = {
        name = 'Stranger Than You Are Now',
        text = {
            'Placeholder'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_styan')
    end,
}

SMODS.Consumable{
    key = 'ityttmom',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 0, y = 0},
    loc_txt = {
        name = 'i think you think too much of me',
        text = {
            'Placeholder',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_ityttmom')
    end,
}

SMODS.Consumable{
    key = 'getting_killed',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 0, y = 0},
    loc_txt = {
        name = 'Getting Killed',
        text = {
            'Placeholder'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_getting_killed')
    end,
}

SMODS.Consumable{
    key = 'appetite_for_destruction',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 0, y = 0},
    loc_txt = {
        name = 'Appetite for Destruction',
        text = {
            'Placeholder',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_appetite_for_destruction')
    end,
}

SMODS.Consumable{
    key = 'revengeseekerz',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 0, y = 0},
    loc_txt = {
        name = 'Revengeseekerz',
        text = {
            'Placeholder'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_revengeseekerz')
    end,
}

SMODS.Consumable{
    key = 'metallica',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 10, y = 0},
    loc_txt = {
        name = 'Metallica',
        text = {
            'Placeholder',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_metallica')
    end,
}

SMODS.Consumable{
    key = 'dsotm',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 8, y = 1},
    loc_txt = {
        name = 'Dark Side of the Moon',
        text = {
            'Placeholder',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_dsotm')
    end,
}

SMODS.Consumable{
    key = 'the_wall',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 7, y = 1},
    loc_txt = {
        name = 'The Wall',
        text = {
            'Placeholder',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_the_wall')
    end,
}

SMODS.Consumable{
    key = 'ok_computer',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 7, y = 1},
    loc_txt = {
        name = 'OK Computer',
        text = {
            'Placeholder'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        if pseudorandom('fitter') < 0.083 then
            play_sound('gcbm_fitter_happier')
        else
            play_sound('gcbm_ok_computer')
        end
    end,
}

SMODS.Consumable{
    key = 'kid_a',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 7, y = 1},
    loc_txt = {
        name = 'Kid A',
        text = {
            'Placeholder'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_kid_a')
    end,
}

SMODS.Consumable{
    key = 'in_rainbows',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 7, y = 1},
    loc_txt = {
        name = 'In Rainbows',
        text = {
            'Placeholder'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_in_rainbows')
    end,
}

SMODS.Consumable{
    key = 'wyns',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 7, y = 1},
    loc_txt = {
        name = 'Whenever You Need Somebody',
        text = {
            'Placeholder'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_wyns')
    end,
}

SMODS.Consumable{
    key = 'lagwafis',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 3, y = 1},
    loc_txt = {
        name = 'Ladies and gentlemen we are floating in space',
        text = {
            'Placeholder',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_lagwafis')
    end,
}

SMODS.Consumable{
    key = 'shsl',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 5, y = 1},
    loc_txt = {
        name = 'Sweet Heart, Sweet Life',
        text = {
            'Placeholder',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_shsl')
    end,
}

SMODS.Consumable{
    key = 'l_faps',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 5, y = 1},
    loc_txt = {
        name = 'L Faps (Diss Track)',
        text = {
            'Placeholder'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_l_faps')
    end,
}

SMODS.Consumable{
    key = 'currents',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 0, y = 1},
    loc_txt = {
        name = 'Currents',
        text = {
            'Placeholder',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_currents')
    end,
}

SMODS.Consumable{
    key = 'u',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 0, y = 1},
    loc_txt = {
        name = 'U',
        text = {
            'Placeholder'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_u')
    end,
}

SMODS.Consumable{
    key = 'a_waterlogged_letter',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 0, y = 1},
    loc_txt = {
        name = 'A Waterlogged Letter',
        text = {
            'Placeholder'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_a_waterlogged_letter')
    end,
}

SMODS.Consumable{
    key = 'weezer_blue',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 1, y = 0},
    loc_txt = {
        name = 'Weezer',
        text = {
            'Placeholder',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_weezer')
    end,
}

SMODS.Consumable{
    key = 'wetdream',
    set = 'Albums',
    atlas = 'Albums',
    pos = {x = 0, y = 1},
    loc_txt = {
        name = 'wetdream',
        text = {
            'Placeholder'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        play_sound('gcbm_wetdream')
    end,
}