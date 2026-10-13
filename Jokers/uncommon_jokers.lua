----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Uncommon_jokers', --atlas key
    path = 'Uncommon_jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Joker{
    key = 'maxwell',
    loc_txt = {
        name = 'Maxwell',
        text = {
            'Gains {C:chips}+#1#{} Chip and {C:mult}+#2#{} Mult',
            'for every card played',
            '{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips and {C:mult}+#4#{C:inactive} Mult)',
        },
    },
    atlas = 'Uncommon_jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    config = {
        extra = {
            chip_gain = 1,
            mult_gain = 1,
            chips = 0,
            mult = 0,
        }
    },

    loc_vars = function(self, info_queue, card)
        local e = card.ability.extra
        return { vars = { e.chip_gain, e.mult_gain, e.chips, e.mult } }
    end,

    calculate = function(self, card, context)
        local e = card.ability.extra

        -- Upgrade before scoring, once per card played (scoring or not)
        if context.before and not context.blueprint then
            local played = #context.full_hand
            e.chips = e.chips + e.chip_gain * played
            e.mult = e.mult + e.mult_gain * played
            return {
                message = 'Upgraded!',
                colour = G.C.CHIPS,
                card = card,
            }
        end

        -- Apply the stored bonus when the hand scores
        if context.joker_main then
            return {
                chips = e.chips,
                mult = e.mult,
            }
        end
    end,

    in_pool = function(self)
        return true
    end,
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
        if context.setting_blind then
            SMODS.add_card({ set = "Drugs", key = 'c_gcbm_meth', area = G.consumeables, edition = 'e_negative' })
            SMODS.add_card({ set = "Drugs", key = 'c_gcbm_meth', area = G.consumeables, edition = 'e_negative' })
            SMODS.add_card({ set = "Drugs", key = 'c_gcbm_meth', area = G.consumeables, edition = 'e_negative' })
        end
    end,
    in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'spoil',
    loc_txt = {
        name = 'This Card Will Spoil You',
        text = {
          'When blind is selected,',
          'spoil {C:attention}1{} piece of media',
        },
    },
    atlas = 'Uncommon_jokers',
    rarity = 2,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},

    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then
            unlock_card(self)
        end
        unlock_card(self)
    end,

    calculate = function(self, card, context)
    if context.setting_blind then
        local spoilers = {
           "Walter White cooks meth and dies",
            "Darth Vader is Luke's father",
            "memtheturtle dies of stroke on may 27, 2029",
            "Craig opens your camera",
            "tsuki is dead",
            "Granny dies in Celeste",
            "Robert F Kennedy dies",
            "They tackled the pentagon",
            "Iron Man dies in Avengers",
            "PerfectLKM will return in Avengers Doomsday",
            "Sans is the secret boss",
            "The cake is a lie",
            "CarlJR wins another world cup",
            "Perfect beats Zaphkiel",
            "Misfire 2 is created",
            "William afton gets springlocked",
        }

        local msg = pseudorandom_element(spoilers, pseudoseed('gcbm_spoil'))
        local hold_time = 3 -- seconds the message stays up

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                attention_text({
                    text = msg,
                    scale = 0.9,
                    hold = hold_time,
                    major = card,
                    backdrop_colour = G.C.SECONDARY_SET.Tarot,
                    align = 'tm',
                    offset = {x = 0, y = -10.3},
                    silent = true,
                })
                play_sound('generic1', 1, 0.6)
                return true
            end
        }))

        -- Pause the event queue so the message isn't skipped past by other effects
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = hold_time,
            func = function() return true end
        }))
    end
 end,
}

----------------------------------------------
------------MOD CODE END----------------------