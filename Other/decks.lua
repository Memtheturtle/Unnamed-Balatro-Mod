----------------------------------------------
------------MOD CODE -------------------------
local config = SMODS.current_mod.config

local DECKIFY_BACK = 'b_gcbm_deckdeck' -- 'b_' + prefix + deck key, change to your deck

local function deck_active()
    local b = G.GAME and G.GAME.selected_back
    local center = b and b.effect and b.effect.center
    return center and center.key == DECKIFY_BACK
end

-- Replace every word with "deck", keeping capitalization
local function deckify(s)
    return (s:gsub("%a[%a']*", function(word)
        if word:sub(1, 1):match("%u") then return "Deck" end
        return "deck"
    end))
end

-- Card descriptions (the parsed text lines)
local old_localize_box = SMODS.localize_box
---@diagnostic disable-next-line duplicate-set-field
SMODS.localize_box = function(lines, args)
    if deck_active() then
        local new_lines = {}
        for i, part in ipairs(lines) do
            local strings = {}
            for j, s in ipairs(part.strings) do
                strings[j] = type(s) == 'string' and deckify(s) or s -- tables are #1# variables
            end
            new_lines[i] = { strings = strings, control = part.control }
        end
        lines = new_lines
    end
    return old_localize_box(lines, args)
end

-- Everything else: names, labels, messages, blind names, etc.
local old_localize = localize
---@diagnostic disable-next-line: lowercase-global
function localize(args, misc_cat)
    local ret = old_localize(args, misc_cat)
    if deck_active() then
        if type(ret) == 'string' then
            return deckify(ret)
        elseif type(ret) == 'table' and type(args) == 'table' and args.type == 'raw_descriptions' then
            local out = {}
            for i, line in ipairs(ret) do out[i] = deckify(line) end
            return out
        end
    end
    return ret
end

local DIM_DECK = 'b_gcbm_decksdark' -- 'b_' + prefix + deck key, change to your deck
local DIM_AMOUNT = 0.8

local function dim_deck_active()
    if not (G.GAME and G.STAGES and G.STAGE == G.STAGES.RUN) then return false end
    local b = G.GAME.selected_back
    local center = b and b.effect and b.effect.center
    return center and center.key == DIM_DECK
end

local old_love_draw_dim = love.draw
love.draw = function(...)
    old_love_draw_dim(...)

    if dim_deck_active() then
        love.graphics.push('all')
        love.graphics.setCanvas()
        love.graphics.setShader()
        love.graphics.origin()
        love.graphics.setColor(0, 0, 0, DIM_AMOUNT)
        love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.pop()
    end
end

local SHUFFLE_DECK = 'b_gcbm_atlasdeck' -- 'b_' + prefix + deck key

local saved = {}       -- [entry] = original image
local entries = {}     -- list of { tbl = table, key = atlas key }
local shuffled = false

local function shuffle_active()
    if not (G.GAME and G.STAGES and G.STAGE == G.STAGES.RUN) then return false end
    local b = G.GAME.selected_back
    local center = b and b.effect and b.effect.center
    return center and center.key == SHUFFLE_DECK
end

-- Seeded from the run seed so reloading a save gives the same scramble
local function make_rng()
    local seed = tostring(G.GAME.pseudorandom and G.GAME.pseudorandom.seed or 'seed')
    local h = 0
    for i = 1, #seed do h = (h * 31 + seed:byte(i)) % 2147483647 end
    return love.math.newRandomGenerator(h)
end

local function collect()
    entries = {}
    for _, source in ipairs({ { 'A:', G.ASSET_ATLAS }, { 'N:', G.ANIMATION_ATLAS } }) do
        local prefix, tbl = source[1], source[2]
        if tbl then
            for key, atlas in pairs(tbl) do
                if atlas.image then
                    entries[#entries + 1] = { id = prefix .. tostring(key), atlas = atlas }
                end
            end
        end
    end
    table.sort(entries, function(a, b) return a.id < b.id end) -- stable order
end

local function apply_shuffle()
    collect()
    local rng = make_rng()

    local images = {}
    for i, e in ipairs(entries) do
        saved[e.atlas] = saved[e.atlas] or e.atlas.image
        images[i] = saved[e.atlas]
    end

    -- Fisher-Yates across EVERY atlas
    for i = #images, 2, -1 do
        local j = rng:random(1, i)
        images[i], images[j] = images[j], images[i]
    end

    for i, e in ipairs(entries) do e.atlas.image = images[i] end
    shuffled = true
end

local function restore_atlases()
    for atlas, img in pairs(saved) do atlas.image = img end
    shuffled = false
end

local old_love_update = love.update
---@diagnostic disable-next-line duplicate-set-field
love.update = function(dt, ...)
    old_love_update(dt, ...)
    local want = shuffle_active()
    if want and not shuffled then
        apply_shuffle()
    elseif not want and shuffled then
        restore_atlases()
    end
end

local FORCED_BOSS   = 'bl_fish'     -- change to the real key
local FORCE_DECK   = 'b_gcbm_fihdeck' -- change to the real key
local FORCED_JOKER = 'j_gcbm_fih'            -- change to the real key
local FORCED_PACK  = 'p_buffoon_normal_1'     -- a pack type that normally holds jokers

local function force_active()
    local b = G.GAME and G.GAME.selected_back
    local center = b and b.effect and b.effect.center
    return center and center.key == FORCE_DECK
end

-- Everything made through create_card becomes the Fish joker:
-- shop jokers, tarots, planets, spectrals, albums, and all pack contents.
-- Playing cards (Base/Enhanced) are left alone so your hand still works.
local old_create_card = create_card
---@diagnostic disable-next-line duplicate-set-field
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if force_active() and not forced_key
        and _type ~= 'Base' and _type ~= 'Enhanced'
        and G.P_CENTERS[FORCED_JOKER] then
        forced_key = FORCED_JOKER
    end
    return old_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
end

-- Shop vouchers become the Fish joker
local old_get_next_voucher_key = get_next_voucher_key
---@diagnostic disable-next-line duplicate-set-field
function get_next_voucher_key(...)
    if force_active() and G.P_CENTERS[FORCED_JOKER] then
        return FORCED_JOKER
    end
    return old_get_next_voucher_key(...)
end

-- Shop packs are always the same joker pack, and its contents are forced above
local old_get_pack = get_pack
---@diagnostic disable-next-line duplicate-set-field
function get_pack(...)
    if force_active() and G.P_CENTERS[FORCED_PACK] then
        return G.P_CENTERS[FORCED_PACK]
    end
    return old_get_pack(...)
end

-- Every boss blind becomes the forced one (also covers boss rerolls)
local old_get_new_boss = get_new_boss
---@diagnostic disable-next-line duplicate-set-field
function get_new_boss(...)
    if force_active() and G.P_BLINDS[FORCED_BOSS] then
        return FORCED_BOSS
    end
    return old_get_new_boss(...)
end

local old_set_blind = Blind.set_blind
---@diagnostic disable-next-line duplicate-set-field
function Blind:set_blind(blind, reset, silent)
    -- blind is nil/reset when the game is clearing the blind, so leave that alone
    if blind and not reset and force_active() and G.P_BLINDS[FORCED_BOSS] then
        blind = G.P_BLINDS[FORCED_BOSS]
    end
    return old_set_blind(self, blind, reset, silent)
end

local DUSKBREAKER_KEY = 'b_gcbm_duskbreaker' -- 'b_' + prefix + deck key
local DUSKBREAKER_TARGET = 8266

local function duskbreaker_active()
    if not (G.GAME and G.STAGES and G.STAGE == G.STAGES.RUN) then return false end
    local b = G.GAME.selected_back
    local center = b and b.effect and b.effect.center
    return center and center.key == DUSKBREAKER_KEY
end

-- True while the player is still stuck on the first Small Blind
local function duskbreaker_locked()
    return duskbreaker_active()
        and G.GAME.round_resets.ante == 1
        and (G.GAME.gcbm_duskbreaker_count or 0) < DUSKBREAKER_TARGET
end

-- Right before the blind select screen is built, if the Small Blind was just beaten,
-- count it and put the run back on the Small Blind.
local old_update_blind_select = Game.update_blind_select
---@diagnostic disable-next-line duplicate-set-field
function Game:update_blind_select(dt)
    if not G.STATE_COMPLETE and duskbreaker_locked() then
        local states = G.GAME.round_resets.blind_states
        if states.Small == 'Defeated' then
            G.GAME.gcbm_duskbreaker_count = (G.GAME.gcbm_duskbreaker_count or 0) + 1
            if G.GAME.gcbm_duskbreaker_count < DUSKBREAKER_TARGET then
                states.Small = 'Select'
                states.Big = 'Upcoming'
                states.Boss = 'Upcoming'
                G.GAME.blind_on_deck = 'Small'
            end
        end
    end
    return old_update_blind_select(self, dt)
end

-- No skipping the Small Blind to dodge the loop (also stops tag farming)
local old_skip_blind = G.FUNCS.skip_blind
---@diagnostic disable-next-line duplicate-set-field
G.FUNCS.skip_blind = function(e)
    if duskbreaker_locked() then return end
    return old_skip_blind(e)
end

-- Atlas for deck art (once per file/mod)
SMODS.Atlas{
    key = 'Decks',
    path = 'Decks.png', -- goes in assets/1x/ and assets/2x/ (2x is double size)
    px = 71,
    py = 95,
}

SMODS.Sound({
	key = "music_decks_dark",
	path = "music_decks_dark.mp3",
	sync = false,
	pitch = 1,
	volume = 6,
    select_music_track = function()
    if not (G.GAME and G.STAGE == G.STAGES.RUN) then return false end
    local b = G.GAME.selected_back
    local center = b and b.effect and b.effect.center
    return center and center.key == 'b_gcbm_decksdark'
end,
})

SMODS.Back{
    key = 'atlasdeck',
    loc_txt = {
        name = 'Atlas Deck',
        text = {
            'Swap All Atlases',
        },
    },
    atlas = 'Decks',
    pos = {x = 0, y = 2},
    unlocked = true,
    discovered = true,

    config = {
        hands = 0,        -- extra hands per round
        discards = 0,    -- discard change
        hand_size = 0,    -- hand size change
        dollars = 0,      -- starting money change
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
}

SMODS.Back{
    key = 'aotydeck',
    loc_txt = {
        name = 'Album of the Year Deck',
        text = {
            'Start each',
            'bind with',
            '{C:attention}1 Album Card{}',
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

    -- Optional: works like a joker's calculate
    calculate = function(self, back, context)
        if context.setting_blind then
            SMODS.add_card({ set = "Albums", area = G.consumeables })
        end
    end,
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

SMODS.Back{
    key = 'chuddeck',
    loc_txt = {
        name = 'Chud Deck',
        text = {
            '{C:attention}NOTHING{}',
            '{C:attention}EVER{}',
            '{C:attention}HAPPENS{}',
        },
    },
    atlas = 'Decks',
    pos = {x = 0, y = 2},
    unlocked = true,
    discovered = true,

    config = {
        hands = 0,        -- extra hands per round
        discards = 0,    -- discard change
        hand_size = 0,    -- hand size change
        dollars = 0,      -- starting money change
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

    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.GAME.probabilities) do 
                    G.GAME.probabilities[k] = v * 0
                end
                return true
            end
        }))
    end,
}

SMODS.Back{
    key = 'deckdeck',
    loc_txt = {
        name = 'Deck Deck',
        text = {
            'Deck',
        },
    },
    atlas = 'Decks',
    pos = {x = 0, y = 2},
    unlocked = true,
    discovered = true,

    config = {
        hands = 0,        -- extra hands per round
        discards = 0,    -- discard change
        hand_size = 0,    -- hand size change
        dollars = 0,      -- starting money change
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
}

SMODS.Back{
    key = 'decksdark',
    loc_txt = {
        name = 'Decks Dark',
        text = {
            'But it was',
            'just a laugh,',
            'just a laugh,',
            'just a laugh,',
            'just a laugh',
        },
    },
    atlas = 'Decks',
    pos = {x = 0, y = 3},
    unlocked = true,
    discovered = true,

    config = {
        hands = 0,        -- extra hands per round
        discards = 0,    -- discard change
        hand_size = 0,    -- hand size change
        dollars = 0,      -- starting money change
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
                 local streamer_mode_enabled = config ~= nil
                    and config.streamer_mode == true
                    if not streamer_mode_enabled then
                    local opened = love.system.openURL("https://www.youtube.com/watch?v=T14IUd9-fWQ")
                end
                return true
            end
        }))
    end,
}

SMODS.Back{
    key = 'duskbreaker',
    loc_txt = {
        name = 'Duskbreaker Deck',
        text = {
            'Replay the first',
            '{C:attention}Small Blind{} {C:attention}8266{} times',
            'before you can proceed',
        },
    },
    atlas = 'Decks',
    pos = {x = 0, y = 0}, -- placeholder sprite position
    unlocked = true,
    discovered = true,
    config = {},
}

SMODS.Back{
    key = 'fihdeck',
    loc_txt = {
        name = 'Fih Deck',
        text = {
            'Fih',
        },
    },
    atlas = 'Decks',
    pos = {x = 0, y = 2},
    unlocked = true,
    discovered = true,

    config = {
        hands = 0,        -- extra hands per round
        discards = 0,    -- discard change
        hand_size = 0,    -- hand size change
        dollars = 0,      -- starting money change
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
}

SMODS.Back{
    key = 'starlightdeck',
    loc_txt = {
        name = 'Starlight Deck',
        text = {
            'Start with',
            '{C:attention}1 Starlight Joker{}',
            'all cards are',
            '{C:attention}Queen of Hearts{}',
        },
    },
    atlas = 'Decks',
    pos = {x = 1, y = 0},
    unlocked = true,
    discovered = true,

    config = {
        hands = 0,        -- extra hands per round
        discards = 0,    -- discard change
        hand_size = 0,    -- hand size change
        dollars = 0,      -- starting money change
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
            for _, card in ipairs(G.playing_cards) do
                assert(SMODS.change_base(card, 'Hearts', 'Queen'))
            end
            SMODS.add_card{ key = 'j_gcbm_lillie' }
            return true
        end
    }))
end,
}

----------------------------------------------
------------MOD CODE END----------------------