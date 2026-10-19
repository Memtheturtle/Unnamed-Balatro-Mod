----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Roles', --atlas key
    path = 'Roles.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.ConsumableType{
    key = 'Roles', --consumable type key
    collection_rows = {5,6}, --amount of cards in one page
    primary_colour = G.C.WHITE, --first color
    secondary_colour = G.C.GREY, --second color
    loc_txt = {
        collection = 'Roles', --name displayed in collection
        name = 'Roles', --name displayed in badge
        undiscovered = {
            name = 'Unearned Roles', --undiscovered name
            text = {'Check Discord'} --undiscovered text
        }
    },
    shop_rate = 1, --rate in shop out of 100
}

SMODS.UndiscoveredSprite{
    key = 'Roles', --must be the same key as the consumabletype
    atlas = 'Roles',
    pos = {x = 0, y = 2}
}

SMODS.Consumable{
    key = 'p', --key
    set = 'Roles', --the set of the card: corresponds to a consumable type
    atlas = 'Roles', --atlas
    pos = {x = 9, y = 0}, --position in atlas
    loc_txt = {
        name = '@p', --name of card
        text = { --text of card
            'Gives everyone in @p'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_lillie')
        new_card:add_to_deck()
        G.jokers:emplace(new_card)
        local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_per')
        new_card:add_to_deck()
        G.jokers:emplace(new_card)
    end,
}


----------------------------------------------
------------MOD CODE END----------------------
