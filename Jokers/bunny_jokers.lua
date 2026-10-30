----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Bunny_jokers', --atlas key
    path = 'Bunny_jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}



SMODS.Rarity{
    key = "bunny",
    loc_txt = {
        name = 'Bunny'
    },
    badge_colour = HEX('FFFF00'),
    pools = {["Joker"] = false},
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

SMODS.Joker{
    key = 'bnuuy',
    loc_txt = {
        name = 'Bunny',
        text = {
            '+{C:chips}#1#{} Chips',
        }
    },
    atlas = 'Bunny_jokers',
    rarity = 'gcbm_bunny',
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    config = { 
        extra = {
            chips = 6767,
        }
    },

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips, G.GAME.probabilities.normal or 1}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
            }
        end
        return {calculated = true}
    end,

    in_pool = function(self)
        return true
    end
}