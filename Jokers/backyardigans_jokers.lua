----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Backyardigans_jokers', --atlas key
    path = 'Backyardigans_jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}



SMODS.Sound({
	key = "music_animal",
	path = "music_animal.mp3",
	sync = false,
	pitch = 1,
	volume = 6,
	select_music_track = function()
		return next(find_joker("j_gcbm_per")) 
	end,
})

SMODS.Sound({
    key = "music_frankenstein",
    path = "music_frankenstein.mp3",
    sync = false,
    pitch = 1,
    volume = 6,
    looping = false,
    select_music_track = function()
        return G.GAME.piggomoo_track == "frankenstein"
    end,
})

SMODS.Sound({
    key = "music_pale",
    path = "music_pale.mp3",
    sync = false,
    pitch = 1,
    volume = 6,
    looping = false,
    select_music_track = function()
        return G.GAME.piggomoo_track == "pale"
    end,
})

SMODS.Sound({
	key = "music_whiskers",
	path = "music_whiskers.mp3",
	sync = false,
	pitch = 1,
	select_music_track = function()
		return next(find_joker("j_gcbm_whisk")) 
	end,
})


SMODS.Sound({
    key = "legacymoneygain",
    path = "legacymoneygain.mp3",
})

SMODS.Sound({
    key = "legacymoneylost",
    path = "legacymoneylost.mp3",
})



SMODS.Rarity{
    key = "yard",
    loc_txt = {
        name = 'Backyardigan'
    },
    badge_colour = HEX('003c00'),
    pools = {["Joker"] = false},
    get_weight = function(self, weight, object_type)
        return weight
    end,
}



SMODS.Joker{
    key = 'avo', --joker key
    loc_txt = { -- local text
        name = 'Avocat0',
        text = {
          'Spawns {C:attention}1{} Negative {C:attention}Gorb{}',
          'at the start of each blind',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    
  
    atlas = 'Backyardigans_jokers', --atlas' key
    rarity = 'gcbm_yard', --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 50, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 5, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right


    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
        if context.setting_blind then
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_gorb')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
           G.gorb_count = G.gorb_count +1 
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'dave',
    loc_txt = {
        name = 'Dxv3d',
        text = {
          '{X:mult,C:white}X#1#{} Mult',
          '{C:green}#2# in 2{} chance to Debuff',
          'all Jokers',
        },
    },
    
    atlas = 'Backyardigans_jokers',
    rarity = 'gcbm_yard',
    cost = 50,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 9, y = 0},
    config = { 
        extra = {
            Xmult = 10,
        }
    },

    loc_vars = function(self, info_queue, center)
        -- Fixed: combined both vars into one return
        return {vars = {center.ability.extra.Xmult, G.GAME.probabilities.normal}}
    end,

    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self)
    end,

    calculate = function(self, card, context)
        if context.setting_blind then
             if pseudorandom('dave') < G.GAME.probabilities.normal / 2 then
            for _, joker in ipairs(G.jokers.cards) do
                joker.debuff = true
                card_eval_status_text(joker, 'extra', nil, nil, nil, {
                    message = 'Debuffed!',
                    colour = G.C.RED
                })
            end
        end
        end
        
        if context.joker_main then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end

        if context.end_of_round and context.game_over == false then
            for _, joker in ipairs(G.jokers.cards) do
                joker.debuff = false
            end
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end,
}  -- <-- closing parenthesis added here

SMODS.Joker{
    key = 'leg',
    loc_txt = {
        name = 'Legacy5',
        text = {
            'At the start of each blind,',
            'gain {C:money}$1-$150{}.',
            '{C:green}#1# in 20{} chance',
            'to lose all money.'
        }
    },
    atlas = 'Backyardigans_jokers',
    rarity = 'gcbm_yard',
    cost = 50,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 7, y = 0},

    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.probabilities.normal}} 
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            -- Add a flag to prevent multiple triggers in the same blind
            if not card.ability.triggered_this_blind then
                local money_gain = math.random(1, 150)
                if pseudorandom('leg') < G.GAME.probabilities.normal / 20 then
                    local money_lost = -G.GAME.dollars
                    G.GAME.dollars = 0
                    ease_dollars(money_lost) -- Only use ease_dollars to animate the change
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Lost All Money!", colour = G.C.RED})
                    play_sound('gcbm_legacymoneylost')
                else
                    ease_dollars(money_gain) -- Only use ease_dollars to apply the gain
                    card_eval_status_text(card, 'dollars', money_gain)
                     play_sound('gcbm_legacymoneygain')
                end
                card.ability.triggered_this_blind = true -- Mark as triggered
                return nil
            end
        elseif context.end_of_round then
            -- Reset the flag at the end of the round
            card.ability.triggered_this_blind = false
        end
    end,

    in_pool = function(self)
        return true
    end
}

SMODS.Joker{
    key = 'lud',
    loc_txt = {
        name = 'Ludtropolis',
        text = {
            'Spawns 10 Gooby!',
            'Kills itself',
        }
    },
    atlas = 'Backyardigans_jokers',
    rarity = 'gcbm_yard',
    cost = 50,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 8, y = 0},


    calculate = function(self, card, context)
        if context.setting_blind then
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_goob')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_goob')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_goob')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_goob')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_goob')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_goob')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_goob')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_goob')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_goob')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_goob')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            G.E_MANAGER:add_event(Event({ 
                trigger = 'after',
                delay = 0.1,
                func = function()
                    card:start_dissolve({G.C.RED}, nil, 1.6)
                    return true
                end
            }))
        end
    end,

    in_pool = function(self)
        return true
    end
}

SMODS.Joker{
    key = 'mem', --joker key
    loc_txt = { -- local text
        name = 'Memtheturtle',
        text = {
          'When blind is selected,',
          '{C:green}#1# in 8{} chance to {C:attention}10x{} {C:money}${}, otherwise lose it all',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Backyardigans_jokers', --atlas' key
    rarity = 'gcbm_yard', --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 50, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 1, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    
    loc_vars = function(self,info_queue,center)
        return {vars = {G.GAME.probabilities.normal}} 
    end,
   
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
        if context.setting_blind then
            if pseudorandom('gamble') < G.GAME.probabilities.normal / 8 then
                ease_dollars(9 * G.GAME.dollars)
            else
                ease_dollars(-G.GAME.dollars)
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'per',
    loc_txt = {
        name = 'PerfectLKM',
        text = {
            '{C:money}$1{}'
        }
    },
    atlas = 'Backyardigans_jokers',
    rarity = 'gcbm_yard',
    cost = 50,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 6, y = 0},

    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.probabilities.normal}} 
    end,

    calculate = function(self, card, context)
        select_music_track = "music_animal"
        if context.setting_blind then
            ease_dollars(1)
            G.E_MANAGER:add_event(Event({ 
                trigger = 'after',
                delay = 0.1,
                func = function()
                    card:start_dissolve({G.C.RED}, nil, 1.6)
                    return true
                end
            }))
        end
    end,

    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'pig',
    loc_txt = {
        name = 'Raindear',
        text = {
            'Its Heckling Time'
        }
    },
    atlas = 'Backyardigans_jokers',
    rarity = 'gcbm_yard',
    cost = 50,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    pos = {x = 0, y = 1},
    
    add_to_deck = function(self, card, from_debuff)
        G.GAME.stop_use_and_sell = true
        
        local song_duration
        
        if pseudorandom('piggomoo_music') < 0.99 then
            G.GAME.piggomoo_track = "frankenstein"
            song_duration = 77
        else
            G.GAME.piggomoo_track = "pale"
            song_duration = 1575
        end
        
        if G.SETTINGS.SOUND.music then
            G.FUNCS.music_set_main_track()
        end
        
        card.ability.extra = {spinning = true}
        
        -- Override the card's update function for constant spinning
        local old_update = card.update
        card.update = function(self, dt)
            if old_update then old_update(self, dt) end
            if card.ability.extra and card.ability.extra.spinning then
                card.T.r = card.T.r + dt * 10
            end
        end
        
        -- Timer to dissolve when music is done
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = song_duration,
            func = function()
                card.ability.extra.spinning = false
                card.T.r = 0
                
                if G.SETTINGS.SOUND.music then
                    G.FUNCS.music_set_main_track()
                end
                
                card:start_dissolve()
                G.GAME.stop_use_and_sell = false
                G.GAME.piggomoo_track = nil
                
                return true
            end
        }))
    end,
    
    calculate = function(self, card, context)
    end,
    
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'sin', --joker key
    loc_txt = { -- local text
        name = 'Singularity',
        text = {
          'When blind is selected,',
          'Create a Negative {C:attention}Black Hole{}',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Backyardigans_jokers', --atlas' key
    rarity = 'gcbm_yard', --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 50, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 4, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
        if context.setting_blind then
            SMODS.add_card({ set = "Spectral", key = 'c_black_hole', area = G.spectrals, edition = 'e_negative' })
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'sky', --joker key
    loc_txt = { -- local text
        name = 'skycrusher',
        text = {
          'When blind is selected,',
          'Create {C:attention}2{} Negative {C:attention}Anime Women{}',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Backyardigans_jokers', --atlas' key
    rarity = 'gcbm_yard', --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 50, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
        if context.setting_blind then
            SMODS.add_card({ set = "Tarot", key = 'c_gcbm_women', area = G.consumeables, edition = 'e_negative' })
            SMODS.add_card({ set = "Tarot", key = 'c_gcbm_women', area = G.consumeables, edition = 'e_negative' })
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'real',
    loc_txt = {
        name = 'Stayreal',
        text = {
          'When blind is selected, destroy 1 card from deck',
          'and gain +{C:chips}100{} Chips (Currently +{C:chips}#1#{} Chips)'
        },
    },
    atlas = 'Backyardigans_jokers',
    rarity = 'gcbm_yard',
    cost = 50,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 0},
    
    config = { 
        extra = {
            chips = 100,
        }
    },
    
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips}}
    end,

    calculate = function(self, card, context) 
        if context.setting_blind then
            -- Destroy a random card from deck
            if #G.playing_cards > 0 then
                local destroyed_card = pseudorandom_element(G.playing_cards, pseudoseed('stayreal'))
                destroyed_card:start_dissolve()
                
                -- Increase chip bonus
                card.ability.extra.chips = card.ability.extra.chips + 100
                
                return {
                    message = 'Card Consumed',
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end
        
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips
            }
        end
    end,
    
    in_pool = function(self, wawa, wawa2)
        return true
    end,
}

SMODS.Joker{
    key = 'whisk', --joker key
    loc_txt = { -- local text
        name = 'Whiskers',
        text = {
          'When blind is selected,',
          'create {C:attention}3{} Negative {C:attention}Estrogen{}',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Backyardigans_jokers', --atlas' key
    rarity = 'gcbm_yard', --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 50, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 3, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
        select_music_track = "music_whiskers"
        if context.setting_blind then
            SMODS.add_card({ set = "Drugs", key = 'c_gcbm_est', area = G.consumeables, edition = 'e_negative' })
            SMODS.add_card({ set = "Drugs", key = 'c_gcbm_est', area = G.consumeables, edition = 'e_negative' })
            SMODS.add_card({ set = "Drugs", key = 'c_gcbm_est', area = G.consumeables, edition = 'e_negative' })
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

----------------------------------------------
------------MOD CODE END----------------------