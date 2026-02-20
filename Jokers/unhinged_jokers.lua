----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Unhinged_jokers', --atlas key
    path = 'Unhinged_jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
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
    key = 'criminal', --joker key
    loc_txt = { -- local text
        name = 'Criminal',
        text = {
          'When blind is selected,',
          'create a Negative Joker of',
          'everyone who had a part in Criminal'
          
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Unhinged_jokers', --atlas' key
    rarity = 'gcbm_unh', --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 50, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 1, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    
   
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
        select_music_track = "music_criminal"
        if context.setting_blind then
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_mem')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_whisk')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_sky')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
             local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_leg')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_avo')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_lig')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_dave')
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
    key = 'sweeper',
    loc_txt = {
        name = 'Minesweeper',
        text = {
            'At the start of each blind,',
            'open a cell'
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
            -- List of 9 consumables to choose from (8 safe + 1 mine)
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
            
            -- Pick one at random
            local random_consumable = pseudorandom_element(consumables, pseudoseed('cellopen'))
            
            -- Create the card
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
    key = 'xvi', --joker key
    loc_txt = { -- local text
        name = 'XVI',
        text = {
          'When blind is selected,',
          'Create {C:attention}16{} Negative {C:attention}Black Holes{}',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Unhinged_jokers', --atlas' key
    rarity = 'gcbm_unh', --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
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
            for i = 1, 16 do
            SMODS.add_card({ set = "Spectral", key = 'c_black_hole', area = G.spectrals, edition = 'e_negative' })
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}


----------------------------------------------
------------MOD CODE END----------------------
