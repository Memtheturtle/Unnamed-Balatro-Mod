SMODS.Atlas{
    key = 'Roles',
    path = 'Roles.png',
    px = 71,
    py = 95
}

SMODS.ConsumableType{
    key = 'Roles',
    collection_rows = {5,6},
    primary_colour = G.C.WHITE,
    secondary_colour = G.C.GREY,
    loc_txt = {
        collection = 'Roles',
        name = 'Roles',
        undiscovered = {
            name = 'Unearned Roles',
            text = {'Check Discord'}
        }
    },
    shop_rate = 1,
}

SMODS.UndiscoveredSprite{
    key = 'Roles',
    atlas = 'Roles',
    pos = {x = 0, y = 2}
}

SMODS.Consumable{
    key = 'p',
    set = 'Roles',
    atlas = 'Roles',
    pos = {x = 9, y = 0},
    loc_txt = {
        name = '@p',
        text = {
            'Gives everyone in @p'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        local SPAWN_KEYS = {
            'j_gcbm_lillie', 'j_gcbm_per',
        }
        for _, key in ipairs(SPAWN_KEYS) do
            local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, key)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end,
}