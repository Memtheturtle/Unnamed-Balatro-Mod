SMODS.Atlas{
    key = 'Unhinged_jokers',
    path = 'Unhinged_jokers.png',
    px = 71,
    py = 95
}

SMODS.Sound({
	key = "music_criminal",
	path = "music_criminal.mp3",
	sync = false,
	pitch = 1,
	select_music_track = function()
		return next(find_joker("j_gcbm_criminal")) 
	end,
})

SMODS.Rarity{
    key = "unh",
    loc_txt = {
        name = 'Unhinged'
    },
    badge_colour = HEX('3e0a1e'),
    pools = {["Joker"] = false},
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

SMODS.Joker{
    key = 'criminal',
    loc_txt = {
        name = 'Criminal',
        text = {
          'When blind is selected,',
          'create a Negative Joker of',
          'everyone who had a part in Criminal',
          '{s:0.8}{C:inactive}Art by Theskycrusher{}',
        },
    },
    atlas = 'Unhinged_jokers',
    rarity = 'gcbm_unh',
    cost = 50,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    calculate = function(self,card,context) 
        self.select_music_track = "music_criminal"
        local NEGATIVE_SPAWN_KEYS = {
            'j_gcbm_mem', 'j_gcbm_whisk', 'j_gcbm_sky', 'j_gcbm_leg',
            'j_gcbm_avo', 'j_gcbm_lig', 'j_gcbm_dave',
        }
        if context.setting_blind then
            for _, key in ipairs(NEGATIVE_SPAWN_KEYS) do
                local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, key)
                new_card:set_edition({ negative = true }, true)
                new_card:add_to_deck()
                G.jokers:emplace(new_card)
            end
        end
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'sweeper',
    loc_txt = {
        name = 'Minesweeper',
        text = {
            'At the start of each blind,',
            'open a cell',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    atlas = 'Unhinged_jokers',
    rarity = 'gcbm_unh',
    cost = 50,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 0},
    calculate = function(self, card, context)
        if context.setting_blind then
            local consumables = {
                'c_gcbm_one',
                'c_gcbm_two',
                'c_gcbm_three',
                'c_gcbm_four',
                'c_gcbm_five',
                'c_gcbm_six',
                'c_gcbm_seven',
                'c_gcbm_eight',
                'c_gcbm_flag'
            }
            local random_consumable = pseudorandom_element(consumables, pseudoseed('cellopen'))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    local new_card = create_card('cellopen', G.consumeables, nil, nil, nil, nil, random_consumable, 'cellopen')
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                    return true
                end
            }))
            return {
                message = 'Cell Opened!',
                colour = G.C.PURPLE,
                card = card
            }
        end
    end,
    in_pool = function(self)
        return true
    end
}

SMODS.Joker{
    key = 'xvi',
    loc_txt = {
        name = 'XVI',
        text = {
          'When blind is selected,',
          'Create {C:attention}16{} Negative {C:attention}Black Holes{}',
          '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        },
    },
    atlas = 'Unhinged_jokers',
    rarity = 'gcbm_unh',
    cost = 50,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    calculate = function(self,card,context) 
        if context.setting_blind then
            for i = 1, 16 do
                SMODS.add_card({ set = "Spectral", key = 'c_black_hole', area = G.spectrals, edition = 'e_negative' })
            end
        end
    end,
    in_pool = function(self)
        return true
    end,
}