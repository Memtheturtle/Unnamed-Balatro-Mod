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

----------------------------------------------
------------MOD CODE END----------------------
