----------------------------------------------
------------MOD CODE -------------------------

-- Atlas for deck art (once per file/mod)
SMODS.Atlas{
    key = 'Decks',
    path = 'Decks.png', -- goes in assets/1x/ and assets/2x/ (2x is double size)
    px = 71,
    py = 95,
}

SMODS.Back{
    key = 'backyarddeck',
    loc_txt = {
        name = 'Backyard Deck',
        text = {
            'Start with',
            '{C:attention}1 Backyardigans Joker{}',
        },
    },
    atlas = 'Decks',
    pos = {x = 0, y = 0},
    unlocked = true,
    discovered = true,

    config = {
        hands = 0,        -- extra hands per round
        discards = 0,    -- discard change
        hand_size = 0,    -- hand size change
        dollars = 0,      -- starting money change
        -- joker_slot = 1,
        -- consumable_slot = 1,
        -- vouchers = {'v_hone'},
        -- consumables = {'c_fool'},
        -- remove_faces = true,
        -- no_interest = true,
    },

   loc_vars = function(self, info_queue, back)
    local c = self.config
    ---@cast c -nil

    return {
        vars = {
            c.hands,
            math.abs(c.discards),
            c.hand_size
            }
        }
    end,

    -- Runs when a new run starts with this deck
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                 SMODS.add_card{
                set = 'Joker',
                rarity = 'gcbm_yard', -- mod prefix + rarity key
                key_append = 'gcbm_deck',
                }
                return true
            end
        }))
    end,

    -- Optional: works like a joker's calculate
    calculate = function(self, back, context)
        if context.setting_blind then
            -- do something every blind
        end
    end,
}



















----------------------------------------------
------------MOD CODE END----------------------