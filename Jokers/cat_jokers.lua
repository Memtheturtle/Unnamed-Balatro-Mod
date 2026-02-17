----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Cat_jokers', --atlas key
    path = 'Cat_jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}



SMODS.Rarity{
    key = "cat",
    loc_txt = {
        name = 'Cat'
    },
    badge_colour = HEX('ee8f8d'),
    pools = {["Joker"] = false},
    get_weight = function(self, weight, object_type)
        return weight
    end,
}



SMODS.Joker{
    key = 'gorb', --joker key
    loc_txt = { -- local text
        name = 'Gorb',
        text = {
          '{X:mult,C:white}X#1#{} Mult,',
          'Increases by {C:attention}1{} for every additional {C:attention}Gorb joker{} held{}',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Cat_jokers', --atlas' key
    rarity = 'gcbm_cat', --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 15, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 7, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        extra = {
            Xmult = G.gorb_count
        }
      },

      loc_vars = function(self,info_queue,center)
        return {vars = {G.gorb_count}} --#1# is replaced with card.ability.extra.Xmult
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
                    Xmult_mod = G.gorb_count,
                    message = 'X' .. G.gorb_count,
                    colour = G.C.MULT
                }
            end
        end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

----------------------------------------------
------------MOD CODE END----------------------
