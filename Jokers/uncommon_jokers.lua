----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Uncommon_jokers', --atlas key
    path = 'Uncommon_jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'mike', --joker key
    loc_txt = { -- local text
        name = 'Mike Ehrmantraut',
        text = {
          'When blind is selected,',
          'create {C:attention}3{} Negative {C:attention}Methamphetamine{}',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Uncommon_jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 4, --cost
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
        select_music_track = "music_whiskers"
        if context.setting_blind then
            SMODS.add_card({ set = "Drugs", key = 'c_gcbm_meth', area = G.consumeables, edition = 'e_negative' })
            SMODS.add_card({ set = "Drugs", key = 'c_gcbm_meth', area = G.consumeables, edition = 'e_negative' })
            SMODS.add_card({ set = "Drugs", key = 'c_gcbm_meth', area = G.consumeables, edition = 'e_negative' })
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}
----------------------------------------------
------------MOD CODE END----------------------