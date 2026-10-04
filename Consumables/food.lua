----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Food', --atlas key
    path = 'Food.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.ConsumableType{
    key = 'Food', --consumable type key
    collection_rows = {5,6}, --amount of cards in one page
    primary_colour = G.C.WHITE, --first color
    secondary_colour = G.C.GREY, --second color
    loc_txt = {
        collection = 'Food', --name displayed in collection
        name = 'Food', --name displayed in badge
        undiscovered = {
            name = 'Hidden Food', --undiscovered name
            text = {'Go to Walmart'} --undiscovered text
        }
    },
    shop_rate = 1, --rate in shop out of 100
}

SMODS.UndiscoveredSprite{
    key = 'Food', --must be the same key as the consumabletype
    atlas = 'Food',
    pos = {x = 0, y = 2}
}

SMODS.Consumable{
    key = 'fried_chicken', --key
    set = 'Food', --the set of the card: corresponds to a consumable type
    atlas = 'Food', --atlas
    pos = {x = 9, y = 0}, --position in atlas
    loc_txt = {
        name = 'Fried Chicken', --name of card
        text = { --text of card
            'Placeholder'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
    end, 
}