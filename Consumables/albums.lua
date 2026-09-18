----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Albums', --atlas key
    path = 'Albums.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.ConsumableType{
    key = 'Albums', --consumable type key
    collection_rows = {5,6}, --amount of cards in one page
    primary_colour = G.C.WHITE, --first color
    secondary_colour = G.C.GREY, --second color
    loc_txt = {
        collection = 'Albums', --name displayed in collection
        name = 'Albums', --name displayed in badge
        undiscovered = {
            name = 'Hidden Albums', --undiscovered name
            text = {'Go to Barnes and Noble'} --undiscovered text
        }
    },
    shop_rate = 1, --rate in shop out of 100
}

SMODS.UndiscoveredSprite{
    key = 'Albums', --must be the same key as the consumabletype
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

SMODS.Consumable{
    key = 'back_in_black', --key
    set = 'Albums', --the set of the card: corresponds to a consumable type
    atlas = 'Albums', --atlas
    pos = {x = 9, y = 0}, --position in atlas
    loc_txt = {
        name = 'Back in Black', --name of card
        text = { --text of card
            'Placeholder'
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
    key = 'eits', --key
    set = 'Albums', --the set of the card: corresponds to a consumable type
    atlas = 'Albums', --atlas
    pos = {x = 2, y = 0}, --position in atlas
    loc_txt = {
        name = 'Eye in the Sky', --name of card
        text = { --text of card
            'Placeholder'
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
    key = 'minecraft_volume_alpha', --key
    set = 'Albums', --the set of the card: corresponds to a consumable type
    atlas = 'Albums', --atlas
    pos = {x = 0, y = 1}, --position in atlas
    loc_txt = {
        name = 'Minecraft Volume Alpha', --name of card
        text = { --text of card
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
    key = 'minecraft_volume_beta', --key
    set = 'Albums', --the set of the card: corresponds to a consumable type
    atlas = 'Albums', --atlas
    pos = {x = 0, y = 1}, --position in atlas
    loc_txt = {
        name = 'Minecraft Volume Beta', --name of card
        text = { --text of card
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
    key = 'brat', --key
    set = 'Albums', --the set of the card: corresponds to a consumable type
    atlas = 'Albums', --atlas
    pos = {x = 0, y = 1}, --position in atlas
    loc_txt = {
        name = 'BRAT', --name of card
        text = { --text of card
            'Placeholder'
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
    key = 'styan', --key
    set = 'Albums', --the set of the card: corresponds to a consumable type
    atlas = 'Albums', --atlas
    pos = {x = 0, y = 1}, --position in atlas
    loc_txt = {
        name = 'Stranger Than You Are Now', --name of card
        text = { --text of card
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
    key = 'ityttmom', --key
    set = 'Albums', --the set of the card: corresponds to a consumable type
    atlas = 'Albums', --atlas
    pos = {x = 0, y = 0}, --position in atlas
    loc_txt = {
        name = 'i think you think too much of me', --name of card
        text = { --text of card
            'Placeholder'
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
    key = 'currents', --key
    set = 'Albums', --the set of the card: corresponds to a consumable type
    atlas = 'Albums', --atlas
    pos = {x = 0, y = 1}, --position in atlas
    loc_txt = {
        name = 'Currents', --name of card
        text = { --text of card
            'Placeholder'
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
    key = 'u', --key
    set = 'Albums', --the set of the card: corresponds to a consumable type
    atlas = 'Albums', --atlas
    pos = {x = 0, y = 1}, --position in atlas
    loc_txt = {
        name = 'U', --name of card
        text = { --text of card
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
    key = 'a_waterlogged_letter', --key
    set = 'Albums', --the set of the card: corresponds to a consumable type
    atlas = 'Albums', --atlas
    pos = {x = 0, y = 1}, --position in atlas
    loc_txt = {
        name = 'A Waterlogged Letter', --name of card
        text = { --text of card
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
    key = 'weezer_blue', --key
    set = 'Albums', --the set of the card: corresponds to a consumable type
    atlas = 'Albums', --atlas
    pos = {x = 1, y = 0}, --position in atlas
    loc_txt = {
        name = 'Weezer', --name of card
        text = { --text of card
            'Placeholder'
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
    key = 'wetdream', --key
    set = 'Albums', --the set of the card: corresponds to a consumable type
    atlas = 'Albums', --atlas
    pos = {x = 0, y = 1}, --position in atlas
    loc_txt = {
        name = 'wetdream', --name of card
        text = { --text of card
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

----------------------------------------------
------------MOD CODE END----------------------
