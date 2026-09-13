----------------------------------------------
------------MOD CODE -------------------------
local config = SMODS.current_mod.config

SMODS.Atlas{
    key = 'Backyardigans_jokers', --atlas key
    path = 'Backyardigans_jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

if not GCBM_screen_flip_installed then
    GCBM_screen_flip_installed = true
    local gcbm_draw_ref = love.draw
    function love.draw()
        if GCBM.screen_flipped then
            love.graphics.push()
            love.graphics.translate(love.graphics.getWidth(), 0)
            love.graphics.scale(-1, 1)
        end
        gcbm_draw_ref()
        if GCBM.screen_flipped then
            love.graphics.pop()
        end
    end
end

if not GCBM_screen_flip2_installed then
    GCBM_screen_flip2_installed = true
    local gcbm_draw_ref = love.draw
    function love.draw()
        if GCBM.screen_flipped2 then
            love.graphics.push()
            love.graphics.translate(0, love.graphics.getHeight())
            love.graphics.scale(1, -1)
        end
        gcbm_draw_ref()
        if GCBM.screen_flipped2 then
            love.graphics.pop()
        end
    end
end

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
	key = "music_season",
	path = "music_season.mp3",
	sync = false,
	pitch = 1,
	volume = 6,
	select_music_track = function()
		return next(find_joker("j_gcbm_mak")) 
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
	key = "music_choppa",
	path = "music_choppa.mp3",
	sync = false,
	pitch = 1,
	select_music_track = function()
		return next(find_joker("j_gcbm_tts")) 
	end,
})


SMODS.Sound({
    key = "legacymoneygain",
    path = "legacymoneygain.mp3",
})
SMODS.Sound({
    key = "1984",
    path = "1984.mp3",
})

SMODS.Sound({
    key = "legacymoneylost",
    path = "legacymoneylost.mp3",
})

SMODS.Sound({
    key = "randombsgo",
    path = "randombsgo.mp3",
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



local https = require "SMODS.https"

-- Cache file path
local cache_path = SMODS.current_mod.path .. "waterbound_rank_cache.txt"

-- Try to read cached rank from file
local function read_cache()
    local file = io.open(cache_path, "r")
    if file then
        local val = file:read("*n")
        file:close()
        if val and val > 0 then return val end
    end
    return nil
end

-- Write rank to cache file
local function write_cache(rank)
    local file = io.open(cache_path, "w")
    if file then
        file:write(tostring(rank))
        file:close()
    end
end

-- Fetch rank from AREDL, fall back to cache on failure
local waterbound_xmult = read_cache() or 1

local code, body = https.request("https://aredl.net/profile/user/waterbound")
if code == 200 and body then
    -- Extract "Points Rank (with packs)#NNN" from the page HTML
    local rank = body:match("Points Rank %(with packs%).-#(%d+)")
    if rank then
        waterbound_xmult = tonumber(rank)
        write_cache(waterbound_xmult)
    end
end

local https = require "SMODS.https"

-- One file, one number: the combined SendDB total for all listed creators.
local cache_path = SMODS.current_mod.path .. "senddb_combined_sends_cache.txt"

local function read_cache()
    local file = io.open(cache_path, "r")

    if not file then
        return nil
    end

    local value = tonumber(file:read("*a"))
    file:close()

    -- 0 is valid, so only reject invalid or negative cache values.
    if value and value >= 0 then
        return value
    end

    return nil
end

local function write_cache(total_sends)
    local file, err = io.open(cache_path, "w")

    if not file then
        send("Could not write combined SendDB cache: " .. tostring(err))
        return false
    end

    file:write(tostring(total_sends))
    file:close()

    return true
end

-- Gets ONLY the creator-wide SendDB total.
-- This excludes the send_count fields inside "levels".
local function get_creator_total_sends(creator_id)
    local code, body = https.request(
        "https://api.senddb.dev/api/v1/creator/" .. tostring(creator_id)
    )

    if code ~= 200 or not body then
        return nil
    end

    -- Matches this part of the response:
    --
    -- ],
    -- "send_count": 16,
    -- "points": 0,
    --
    -- Because it starts immediately after the complete levels array,
    -- it cannot use an individual level's send_count.
    local sends = body:match(
        '"levels"%s*:%s*%b[]%s*,%s*"send_count"%s*:%s*(%d+)%s*,%s*"points"'
    )

    if sends then
        return tonumber(sends)
    end

    return nil
end

-- The creators included in the combined total.
local creator_ids = {
    120151711, -- makzuisbad
    276735696, -- Ludtropolis
    133466003,  -- Perfect
    93438679,  -- Waterbound
    53310466,  -- Theskycrusher
    115847777,  -- Raindear
    95502357,  -- AVRG
    236798208,  -- Tryingdino7
    57118545,  -- Chaken
    182577111 -- Simarlet
}

-- Start with the previous combined value in case SendDB is unreachable.
local senddb_combined_sends = read_cache() or 0

-- Only overwrite the cache if EVERY creator succeeds.
-- This prevents replacing a good cached total with a partial total.
local fresh_total = 0
local all_requests_succeeded = true

for _, creator_id in ipairs(creator_ids) do
    local creator_sends = get_creator_total_sends(creator_id)

    if creator_sends == nil then
        all_requests_succeeded = false
        send(
            "SendDB request/match failed for creator ID "
            .. tostring(creator_id)
        )
    else
        fresh_total = fresh_total + creator_sends
    end
end

if all_requests_succeeded then
    senddb_combined_sends = fresh_total
    write_cache(senddb_combined_sends)
end

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
    key = 'avrg', --joker key
    loc_txt = { -- local text
        name = 'AVRG',
        text = {
          '{C:attention}Nothing{}. {C:attention}Ever{}. {C:attention}Happens{}.',
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

    add_to_deck = function(self, card, from_debuff)
       for k, v in pairs(G.GAME.probabilities) do 
            G.GAME.probabilities[k] = v * 0
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.probabilities) do 
            G.GAME.probabilities[k] = v * 1
        end
    end,

    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}


SMODS.Joker{
    key = 'bday',
    loc_txt = {
        name = 'Birthday Bot',
        text = {
            'If it is anyone in The Backyardigans\' birthday,',
            '{C:attention}Spawn 1 of that card{} every blind',
        },
    },
   atlas = 'Backyardigans_jokers', --atlas' key
    rarity = 'gcbm_yard', --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 50,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 1},
   


     calculate = function(self, card, context)
        if context.setting_blind then

        local month = tonumber(os.date('%m'))
        local day   = tonumber(os.date('%d'))

        elseif month == 1 and day == 22 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_craig')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 1 and day == 27 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_dave')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
  
        elseif month == 2 and day == 18 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_pig')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 2 and day == 27 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_lud')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 4 and day == 1 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_echo')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 5 and day == 3 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_senddb')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 5 and day == 10 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_makzu')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 5 and day == 24 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_limitz')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 5 and day == 25 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_leg')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 6 and day == 9 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_sin')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 6 and day == 15 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_sky')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 6 and day == 27 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_avrg')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 7 and day == 4 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_lillie')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 7 and day == 22 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_bday')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 8 and day == 11 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_mem')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 9 and day == 6 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_per')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 10 and day == 13 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_per')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 11 and day == 17 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_tts')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)

        elseif month == 12 and day == 4 then
          local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_avo')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end,

    in_pool = function(self, wawa, wawa2)
        return true
    end,
}

SMODS.Joker{
    key = 'craig',

    loc_txt = {
        name = 'Craig',
        text = {
            'NOW RECORDING'
        }
    },

    atlas = 'Backyardigans_jokers',
    rarity = 'gcbm_yard',
    cost = 50,

    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,

    pos = { x = 6, y = 0 },

    calculate = function(self, card, context)
        if context.setting_blind then
             play_sound('gcbm_randombsgo')

            local function gcbm_open_camera()
                local os_name = love.system.getOS()
                local streamer_mode_enabled = config.streamer_mode

                if not streamer_mode_enabled then
                    if os_name == "OS X" then
                        -- Opens macOS's built-in camera application.
                        local ok = os.execute('open -a "Photo Booth"')
                        return ok == true or ok == 0
                    elseif os_name == "Windows" then
                        -- Opens the Windows Camera app through its URI protocol.
                        -- The blank "" after start is the required window title.
                        local ok = os.execute(
                            'start "" "microsoft.windows.camera:"'
                        )

                        return ok == true or ok == 0
                    end
                end

                -- Linux / unsupported operating system.
                return false
            end

            local opened = gcbm_open_camera()

            if not opened then
                -- Optional debug message:
                -- send("Could not open the camera app")
            end
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
} 

SMODS.Joker{
    key = 'echo', --joker key
    loc_txt = { -- local text
        name = 'Echofallenn',
        text = {
          'When blind is selected,',
          'create {C:attention}1{} {C:attention}CMD Card{}',
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
    pos = {x = 1, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
        if context.setting_blind then
            SMODS.add_card({ set = "CMD", area = G.consumeables})
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

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
    key = 'limitz', --joker key
    loc_txt = { -- local text
        name = 'Mrhumanlimitz',
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
    key = 'mak',
    loc_txt = {
        name = 'Makzu',
        text = {
            '{C:money}$2{}'
        }
    },
    atlas = 'Backyardigans_jokers',
    rarity = 'gcbm_yard',
    cost = 50,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    config = {eternal = true},
    pos = {x = 6, y = 0},

    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.probabilities.normal}} 
    end,

      add_to_deck = function(self, card, from_debuff)
        GCBM.screen_flipped = true
        GCBM.screen_flipped2 = true
    end,

    remove_from_deck = function(self, card, from_debuff)
        GCBM.screen_flipped = false
        GCBM.screen_flipped2 = false
    end,


    calculate = function(self, card, context)
        select_music_track = "music_season"
        if context.setting_blind then
            ease_dollars(2)
             card_eval_status_text(card, 'dollars', 2)
        end
    end,

    in_pool = function(self)
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
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    pos = { x = 6, y = 0 },

    loc_vars = function(self, info_queue, center)
        return {
            vars = { G.GAME.probabilities.normal }
        }
    end,

    calculate = function(self, card, context)
        self.select_music_track = "music_animal"

        if context.setting_blind then
            ease_dollars(1)
            card_eval_status_text(card, 'dollars', 1)

            if not next(find_joker("j_gcbm_lille")) then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        card:start_dissolve({ G.C.RED }, nil, 1.6)
                        return true
                    end
                }))
            end
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
    key = 'senddb',
    loc_txt = {
        name = 'SendDB',
        text = {
            '{X:mult,C:white}X' .. tostring(senddb_combined_sends) .. '{} Mult',
            '{C:inactive}[Combined SendDB sends]{}',
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
    pos = {x = 3, y = 0},

    config = {
        extra = {
            h_size = 0,
            xmult = senddb_combined_sends
        }
    },

    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then
            unlock_card(self)
        end
    end,

    in_pool = function(self, args)
        return true
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
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
    key = 'lille', --joker key
    loc_txt = { -- local text
        name = 'Starlightlillie',
        text = {
          'Played Queen of Hearts give',
          '{X:mult,C:white}X#1#{} Mult, {C:green}#2# in 5{}',
          'chance of giving {C:attention}Estrogen{}',
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
    config = { 
        extra = {
            Xmult = 1.25,
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
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
        if context.setting_blind then
          if pseudorandom('lillieest') < G.GAME.probabilities.normal / 5 then
            SMODS.add_card({ set = "Drugs", key = 'c_gcbm_est', area = G.consumeables})
          end
        end
       if context.individual and context.cardarea == G.play and context.other_card then
            if context.other_card:get_id() == 12 and context.other_card:is_suit('Hearts') then -- Queen of Hearts
                return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
             }
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}


SMODS.Joker{
    key = 'tts',
    loc_txt = {
        name = 'TTS Bot',
        text = {
            'CHOPPA'
        }
    },
    atlas = 'Backyardigans_jokers',
    rarity = 'gcbm_yard',
    cost = 50,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    config = {eternal = true},
    pos = {x = 7, y = 1},
    
    
    add_to_deck = function(self, card, from_debuff)
        card:set_eternal(true)
        select_music_track = "music_choppa"
    end,

}

SMODS.Joker{
    key = 'water',
    loc_txt = {
        name = 'Waterbound',
        text = {
            'Reduce hand size to {C:attention}1{}',
            '{X:mult,C:white}X' .. tostring(waterbound_xmult) .. '{} Mult',
            '{C:inactive}[AREDL Rank]{}',
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
    pos = {x = 3, y = 0},
    config = { extra = { h_size = 0, xmult = waterbound_xmult } },

    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then
            unlock_card(self)
        end
    end,

    in_pool = function(self, args)
        return true
    end,

    add_to_deck = function(self, card, from_debuff)
        local delta = 1 - G.hand.config.card_limit
        card.ability.extra.h_size = delta
        G.hand:change_size(delta)
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
        card.ability.extra.h_size = 0
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end,
}

SMODS.Joker{
    key = 'wushady', --joker key
    loc_txt = { -- local text
        name = 'Wushady',
        text = {
          'When blind is selected,',
          '{C:green}#1# in 2{} chance to play 1984,',
          'otherwise lose all money',
        }
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
    perishable_compat = false, --can it be perishable
    config = {eternal = true},
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
            if pseudorandom('nineteeneightyfour') < G.GAME.probabilities.normal / 2 then
                play_sound('gcbm_1984')
                
                local streamer_mode_enabled = config.streamer_mode
                if not streamer_mode_enabled then
                    local opened = love.system.openURL("https://www.youtube.com/watch?v=5jjnIBITmbg")
                end
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
----------------------------------------------
------------MOD CODE END----------------------