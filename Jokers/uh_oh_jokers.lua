SMODS.Atlas{
    key = 'Uh_oh_jokers',
    path = 'Uh_oh_jokers.png',
    px = 71,
    py = 95
}

SMODS.Rarity{
    key = "nospawn",
    loc_txt = {
        name = 'Uh Oh'
    },
    badge_colour = HEX('7C0D0E'),
    pools = {["Joker"] = false},
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

SMODS.Joker{
    key = 'blue',
    loc_txt = {
        name = 'Blue Screen',
        text = {
          'If you can read this',
          'its already too late',
          '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        },
    },
    atlas = 'Uh_oh_jokers',
    rarity = 'gcbm_nospawn',
    cost = 1,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    calculate = function(self,card,context) 
        for _ = 1, 10000000 do
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_ovk')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end,
    in_pool = function(self)
        return true
    end,
}