----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Rare_jokers', --atlas key
    path = 'Rare_jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}



SMODS.Sound({
	key = "music_serious",
	path = "music_serious.mp3",
	sync = false,
	pitch = 1,
	select_music_track = function()
		return next(find_joker("j_gcbm_serious")) 
	end,
})


SMODS.Sound({
    key = "watchmen",
    path = "watchmen.mp3",
})

SMODS.Sound({
    key = "wethreekings",
    path = "wethreekings.mp3",
})



SMODS.Joker{
    key = 'tm2', --joker key
    loc_txt = { -- local text
        name = 'A03',
        text = {
          'When blind is selected,',
          'create a Negative Joker of the top 1 TM2 Lagoon Maryland player'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 9, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    
   
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
        if context.setting_blind then
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_whisk')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'crash',
    loc_txt = {
        name = 'Crash Trigger',
        text = {
            '+{C:chips}#1#{} Chips',
            '{C:green}#2# in 19{} chance',
            'to {C:attention}Crash Game{}',
        }
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    config = { 
        extra = {
            chips = 500,
        }
    },

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips, G.GAME.probabilities.normal or 1}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            -- 1/19 crash chance on each hand
            if pseudorandom('crash_trigger') < (G.GAME.probabilities.normal or 1) / 19 then
                G.STATE = G.STATES.GAME_OVER
                G.STATE_COMPLETE = false

                -- Flood jokers with negative copies
                for i = 1, 25 do
                    local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_gcbm_blue')
                    new_card:set_edition({negative = true}, true)
                    G.jokers:emplace(new_card)
                end

                return {calculated = true}
            end

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

SMODS.Joker{
    key = 'goob',
    loc_txt = {
        name = 'Gooby!',
        text = {
          'At the start of each blind, gain {C:money}$10{}',
          'and turn 1 adjacent joker into {C:attention}Gooby!{}'
        },
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 0},

    calculate = function(self, card, context) 
        if context.setting_blind and not context.blueprint then
            ease_dollars(10)
            
            -- Find this card's position
            local my_position = nil
            for i, joker in ipairs(G.jokers.cards) do
                if joker == card then
                    my_position = i
                    break
                end
            end
            
            if my_position then
                -- Check adjacent jokers (left and right)
                local adjacent_jokers = {}
                
                -- Check left neighbor
                if my_position > 1 then
                    local left = G.jokers.cards[my_position - 1]
                    if left.config.center.key ~= 'j_gcbm_goob' and left.ability.name ~= 'Gooby!' then
                        table.insert(adjacent_jokers, left)
                    end
                end
                
                -- Check right neighbor
                if my_position < #G.jokers.cards then
                    local right = G.jokers.cards[my_position + 1]
                    if right.config.center.key ~= 'j_gcbm_goob' and right.ability.name ~= 'Gooby!' then
                        table.insert(adjacent_jokers, right)
                    end
                end
                
                if #adjacent_jokers > 0 then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function()
                            local target = pseudorandom_element(adjacent_jokers, pseudoseed('gooby'))
                            
                            target:juice_up(0.3, 0.5)
                            play_sound('tarot1')
                            
                            -- Change the target into a Gooby directly
                            target:set_ability(G.P_CENTERS.j_gcbm_goob, true, nil)
                            target:juice_up(0.3, 0.5)
                            
                            return true
                        end
                    }))
                    
                    return {
                        message = 'Gooby!',
                        colour = G.C.MONEY,
                        card = card
                    }
                end
            end
        end
    end,
    
    in_pool = function(self, wawa, wawa2)
        return true
    end,
}

SMODS.Joker{
    key = 'king', --joker key
    loc_txt = { -- local text
        name = 'King Whale',
        text = {
          'Makes you {C:attention}Get Rekd Botch{}',
          'Destroy {C:attention}2{} jokers, gain {X:mult,C:white}x25{} mult, currently {X:mult,C:white}X#1#{}'
          
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        extra = {
            Xmult = G.whale
      }
    },
    loc_vars = function(self,info_queue,center)

        return {vars = {G.whale}} --#1# is replaced with card.ability.extra.Xmult
    end,
   
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,

    calculate = function(self, card, context) 
        if context.joker_main then
            return {
                card = card,
                Xmult_mod = G.whale,
                message = 'X' .. G.whale,
                colour = G.C.MULT
            }
        end
    
        if context.setting_blind then
            local destructable_jokers = {}
            -- Populate list of Jokers that can be destroyed (exclude self, eternal, and already-destroyed Jokers)
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card -- Exclude this specific King Whale instance
                    and not G.jokers.cards[i].ability.eternal 
                    and not G.jokers.cards[i].getting_sliced then
                    destructable_jokers[#destructable_jokers + 1] = G.jokers.cards[i]
                end
            end
    
            -- Select up to 2 Jokers to destroy
            if #destructable_jokers > 0 then
                for i = 1, math.min(2, #destructable_jokers) do
                    local joker_to_destroy = pseudorandom_element(destructable_jokers, pseudoseed('whale' .. i))
                    if joker_to_destroy then
                        joker_to_destroy.getting_sliced = true
                        G.E_MANAGER:add_event(Event({func = function()
                            joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                            return true
                        end }))
                        -- Remove the destroyed Joker from the list to avoid re-selecting it
                        for k, v in ipairs(destructable_jokers) do
                            if v == joker_to_destroy then
                                table.remove(destructable_jokers, k)
                                break
                            end
                        end
                    end
                end
                G.whale = G.whale + 25 -- Increase Xmult only once per blind, not per Joker destroyed
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'knee',
    loc_txt = {
        name = 'Knee Surgery',
        text = {
            '{X:mult,C:white}X#1#{} Mult,',
            '{C:attention}Self Destructs{} if blind set {C:attention}Tomorrow{}',
        },
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    pos = {x = 1, y = 5},
    config = { 
        extra = {
            Xmult = 10,
            start_day = nil
        }
    },

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult}}
    end,

    -- Attempt to initialize on creation (may not always trigger)
    init = function(self, card)
        if not card.ability.extra.start_day then
            card.ability.extra.start_day = os.date('%d')
     
        end
    end,

    calculate = function(self, card, context) 
        -- Apply the Xmult bonus during scoring
        if context.joker_main then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end

        -- Ensure start_day is set when the Joker is active
        if not card.ability.extra.start_day then
            card.ability.extra.start_day = os.date('%d')
        
        end

        -- Check for self-destruct when setting a blind, but only during gameplay
        if context.setting_blind and G.STAGE == G.STAGES.RUN then
            local current_day = os.date('%d')
           
            if card.ability.extra.start_day and current_day ~= card.ability.extra.start_day then
                
                G.E_MANAGER:add_event(Event({ 
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        card:start_dissolve({G.C.RED}, nil, 1.6)
                        return true
                    end
                }))
            else
              
            end
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end,
}

SMODS.Joker{
    key = 'lig',
    loc_txt = {
        name = 'Ligshu',
        text = {
            'Spawns 10 Ludtropolis',
            'Kills itself',
        }
    },
    atlas = 'Backyardigans_jokers',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 1},


    calculate = function(self, card, context)
        if context.setting_blind then
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_lud')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_lud')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_lud')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_lud')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_lud')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_lud')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_lud')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_lud')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_lud')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_lud')
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
    key = 'bone',
    loc_txt = {
        name = 'Mr. Weak Bones',
        text = {
            'Saves you if your score',
            'is at least 25% of required score',
            '{C:attention}Self Destructs{}, {C:attention}-1 Ante{}'
        },
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 0},

    calculate = function(self, card, context)
        if context.game_over and not context.blueprint then
            if G.GAME.chips >= G.GAME.blind.chips * 0.25 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('tarot1')
                        
                        -- Reduce ante by 1
                        ease_ante(-1)
                        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - 1
                        
                        card:start_dissolve()
                        return true
                    end
                }))
                return {
                    message = 'Go drink some milk!',
                    saved = true,
                    colour = G.C.WHITE  -- white for milk theme!
                }
            end
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end,
}

SMODS.Joker{
    key = 'ovk', --joker key
    loc_txt = { -- local text
        name = 'Overkill',
        text = {
          '{X:mult,C:white}X#1#{} Mult,',
          'Increases by {C:attention}1{} for every {C:attention}Mod Send{} Overkill recieves',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 15, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        extra = {
            Xmult = 8
        }
      },

      loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.Xmult}} --#1# is replaced with card.ability.extra.Xmult
    end,
   


    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
        if context.joker_main then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'ticktock', --joker key
    loc_txt = { -- local text
        name = 'Tick Tock',
        text = {
          'At the end of each blind, gain {C:money}$50{}',
          'Decrerases by 1 every second spent in blind',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    
   
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
        -- Track time when the blind starts
calculate = function(self, card, context)

        -- Blind entered: record start time and reset paid flag
        if context.setting_blind then
            card.ability.miser_start = love.timer.getTime()
            card.ability.miser_last_tick = 0
            card.ability.miser_paid = false
            return
        end

        -- End of round payout — only fire once per round
        if context.end_of_round and context.main_eval and not card.ability.miser_paid then
            card.ability.miser_paid = true

            local payout = 50
            if card.ability.miser_start then
                local elapsed = math.floor(love.timer.getTime() - card.ability.miser_start)
                payout = math.max(0, 50 - elapsed)
                card.ability.miser_start = nil
                card.ability.miser_last_tick = nil
            end

            if payout > 0 then
                ease_dollars(payout)
                card_eval_status_text(card, "extra", nil, nil, nil, {
                    message = "+" .. payout .. "$",
                    colour = G.C.MONEY,
                })
            else
                card_eval_status_text(card, "extra", nil, nil, nil, {
                    message = "Too slow!",
                    colour = G.C.RED,
                })
            end
        end
    end,

    -- Real-time tick: runs every frame, shows -$1 each new second while in blind
    update = function(self, card, dt)
        if not card.ability.miser_start then return end

        -- Only tick during active play states
        local s = G.STATE
        if s ~= G.STATES.HAND_PLAYED
        and s ~= G.STATES.DRAW_TO_HAND
        and s ~= G.STATES.SELECTING_HAND then return end

        local elapsed = math.floor(love.timer.getTime() - card.ability.miser_start)
        local last = card.ability.miser_last_tick or 0

        if elapsed > last and elapsed <= 50 then
            card.ability.miser_last_tick = elapsed
            card_eval_status_text(card, "extra", nil, nil, nil, {
                message = "-$1",
                colour = G.C.RED,
            })
        end
    end,
}

SMODS.Joker{
    key = 'serious', --joker key
    loc_txt = { -- local text
        name = 'Why So Serious',
        text = {
          'When blind is selected,',
          'create {C:attention}3{} Negative {C:attention}Jimbos{}',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
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
        select_music_track = "music_serious"
        if context.setting_blind then
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_joker')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_joker')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_joker')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'unnamed', --joker key
    loc_txt = { -- local text
        name = 'Unnamed List',
        text = {
          'When blind is selected,',
          'create a Negative Joker of the',
          'Top 1 Unnamed List Player'
          
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    
   
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
        if context.setting_blind then
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_mem')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'watch',
    loc_txt = {
        name = 'Watchmen',
        text = {
            '{X:mult,C:white}X#1#{} Mult,',
            '{C:attention}Dont look behind you...{}'
        }
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 4, y = 0},
    config = { 
        extra = {
            Xmult = 3
        }
      },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult}}
    end,

    
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,

   calculate = function(self,card,context) 
     if context.setting_blind and not context.blueprint and not card.ability.watchmen_spawned then
            -- 1/100 chance to trigger a jump scare and destroy a random Joker
           if pseudorandom('watchmen_scare') < 0.01 then
                play_sound('gcbm_watchmen')

                local destructable_jokers = {}
                -- Populate list of Jokers that can be destroyed (exclude self, eternal, and already-destroyed Jokers)
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] ~= card -- Exclude this specific Watchmen instance
                        and not G.jokers.cards[i].ability.eternal 
                        and not G.jokers.cards[i].getting_sliced 
                        and G.jokers.cards[i].config.center.key ~= 'j_gcbm_watch' then
                        destructable_jokers[#destructable_jokers + 1] = G.jokers.cards[i]
                    end
                end
                -- Select up to 1 Joker to destroy
                if #destructable_jokers > 0 then
                    local joker_to_destroy = pseudorandom_element(destructable_jokers, pseudoseed('watchmen'))
                    if joker_to_destroy then
                        joker_to_destroy.getting_sliced = true
                        G.E_MANAGER:add_event(Event({func = function()
                            joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                            return true
                        end }))
                    end
                end
          card.ability.watchmen_spawned = true
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_watch')
            new_card:set_edition({negative = true}, true)
            new_card.ability.watchmen_spawned = true
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_watch')
            new_card:set_edition({negative = true}, true)
            new_card.ability.watchmen_spawned = true
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            end
        end

        -- Reset the spawned flag when blind ends
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            card.ability.watchmen_spawned = false
        end
    -- Reset the spawned flag when blind ends
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            card.ability.watchmen_spawned = false
        end

        if context.joker_main then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end
    end,


    in_pool = function(self)
        return true
    end
}

SMODS.Joker{
    key = 'kings',
    loc_txt = {
        name = 'We Three Kings',
        text = {
            'Gives {C:mult}+500 Mult{} when',
            'played hand is {C:attention}exactly 3 cards{}',
            'and contains {C:attention}Three Kings{}'
        }
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 6, y = 1},

    sound = SMODS.Sound({
        key = "wethreekings",
        path = "wethreekings.mp3",
    }),

    calculate = function(self, card, context)
        if context.joker_main then
            -- Check if exactly 3 cards were played
            if #context.full_hand == 3 then
                -- Check for Three Kings
                local king_count = 0
                for _, card in ipairs(context.full_hand) do
                    if card.base.id == 13 then  -- 13 is typically King
                        king_count = king_count + 1
                    end
                end
                
                if king_count == 3 then
                    -- Only play sound on first trigger, but allow mult for Blueprint/Brainstorm
                    if not G.GAME.we_three_kings_triggered then
                        play_sound('gcbm_wethreekings')
                        G.GAME.we_three_kings_triggered = true
                    end
                    return {
                        message = "+500 Mult",
                        mult_mod = 500,
                        colour = G.C.MULT,
                        card = card
                    }
                end
            end
        end
        
        -- Reset the trigger at end of round
        if context.end_of_round then
            G.GAME.we_three_kings_triggered = false
        end
    end,

    in_pool = function(self)
        return true
    end
}