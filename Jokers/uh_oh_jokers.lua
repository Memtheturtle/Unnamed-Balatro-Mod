----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Uh_oh_jokers', --atlas key
    path = 'Uh_oh_jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
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
    key = 'blue', --joker key
    loc_txt = { -- local text
        name = 'Blue Screen',
        text = {
          'If you can read this',
          'its already too late'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    
  
    atlas = 'Uh_oh_jokers', --atlas' key
    rarity = 'gcbm_nospawn', --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 50, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 6, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right


    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_ovk')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

----------------------------------------------
------------MOD CODE END----------------------