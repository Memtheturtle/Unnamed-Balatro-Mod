----------------------------------------------
------------MOD CODE -------------------------
local config = SMODS.current_mod.config

SMODS.Atlas{
    key = 'Aredl_jokers', --atlas key
    path = 'Aredl_jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Rarity{
    key = "aredl",
    loc_txt = {
        name = 'AREDL Staff'
    },
    badge_colour = HEX('8B008B'),
    pools = {["Joker"] = false},
    get_weight = function(self, weight, object_type)
        return weight
    end,
}


local GREEN_SPAWN_POOL = { 'j_gluttenous_joker', 'j_zany', 'j_wily', 'j_ceremonial', 'j_pareidolia',
    'j_green_joker', 'j_blackboard', 'j_turtle_bean', 'j_to_the_moon', 'j_oops',
    'j_trio', 'j_perkeo', 'j_gcbm_mem' }

local function spawn_random_green()
    local key = pseudorandom_element(GREEN_SPAWN_POOL, pseudoseed("spawn"))
    local c = create_card('Joker', G.jokers, nil, nil, nil, nil, key)
    c:set_edition(nil, true, true)
    c:set_eternal(true)
    c:add_to_deck()
    G.jokers:emplace(c)
end

local RED_SPAWN_POOL = { 'j_lusty_joker', 'j_droll', 'j_crafty', 'j_credit_card', 'j_raised_fist',
    'j_scary_face', 'j_even_steven', 'j_red_card', 'j_madness', 'j_gift',
    'j_reserved_parking', 'j_popcorn', 'j_bloodstone', 'j_matador', 'j_chicot', 'j_gcbm_sigma' }

local function spawn_random_red()
    local key = pseudorandom_element(RED_SPAWN_POOL, pseudoseed("spawn"))
    local c = create_card('Joker', G.jokers, nil, nil, nil, nil, key)
    c:set_edition(nil, true, true)
    c:set_eternal(true)
    c:add_to_deck()
    G.jokers:emplace(c)
end

local YELLOW_SPAWN_POOL = { 'j_gros_michel', 'j_cavendish', 'j_ride_the_bus', 'j_midas_mask', 'j_golden',
    'j_smiley', 'j_ticket', 'j_rough_gem', 'j_cartomancer', 'j_yorick', 'j_gcbm_per' }

local function spawn_random_yellow()
    local key = pseudorandom_element(YELLOW_SPAWN_POOL, pseudoseed("spawn"))
    local c = create_card('Joker', G.jokers, nil, nil, nil, nil, key)
    c:set_edition(nil, true, true)
    c:set_eternal(true)
    c:add_to_deck()
    G.jokers:emplace(c)
end

local BLUE_SPAWN_POOL = { 'j_jolly', 'j_sly', 'j_odd_todd', 'j_ice_cream', 'j_splash',
    'j_blue_joker', 'j_cloud_9', 'j_onyx_agate', 'j_blueprint', 'j_duo',
    'j_seeing_double', 'j_astronomer', 'j_triboulet', 'j_gcbm_longweezer', 'j_gcbm_sin', 'j_gcbm_sky', 'j_gcbm_xvi' }

local function spawn_random_blue()
    local key = pseudorandom_element(BLUE_SPAWN_POOL, pseudoseed("spawn"))
    local c = create_card('Joker', G.jokers, nil, nil, nil, nil, key)
    c:set_edition(nil, true, true)
    c:set_eternal(true)
    c:add_to_deck()
    G.jokers:emplace(c)
end

local ORANGE_SPAWN_POOL = { 'j_greedy_joker', 'j_banner', 'j_juggler', 'j_diet_cola', 'j_bootstraps',
    'j_burnt' }

local function spawn_random_orange()
    local key = pseudorandom_element(ORANGE_SPAWN_POOL, pseudoseed("spawn"))
    local c = create_card('Joker', G.jokers, nil, nil, nil, nil, key)
    c:set_edition(nil, true, true)
    c:set_eternal(true)
    c:add_to_deck()
    G.jokers:emplace(c)
end

local BLUE = { amount = 0, target = 0, speed = 1 / 10 }   -- default: 10 seconds for a full shift

-- strength: 0 = off, 1 = full blue. seconds: how long the shift takes.
local function set_blue(strength, seconds)
    BLUE.target = strength
    BLUE.speed = 1 / (seconds or 10)
end

local old_draw = love.draw
function love.draw(...)
    old_draw(...)

    -- move toward the target at a constant rate (real time, so game speed doesn't matter)
    local dt = love.timer.getDelta()
    local diff = BLUE.target - BLUE.amount
    local step = BLUE.speed * dt
    if math.abs(diff) <= step then
        BLUE.amount = BLUE.target
    else
        BLUE.amount = BLUE.amount + (diff > 0 and step or -step)
    end
    if BLUE.amount < 0.01 then return end
    local a = BLUE.amount
    love.graphics.push("all")
    love.graphics.origin()
    local w, h = love.graphics.getDimensions()

    -- 1. remove red and green (fully gone at a = 1)
    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.setColor(1 - a, 1 - a, 1, 1)
    love.graphics.rectangle("fill", 0, 0, w, h)

    -- 2. brighten with blue so it isn't too dark
    love.graphics.setBlendMode("add")
    love.graphics.setColor(0, 0, 0.25 * a, 1)
    love.graphics.rectangle("fill", 0, 0, w, h)

    love.graphics.pop()
end

SMODS.Joker{
    key = 'blueshift', --joker key
    loc_txt = { -- local text
        name = 'Blueshift',
        text = {
          '{C:attention}Trienta Mango Strawberry Energy{}',
          '{C:attention}Refresher with No Strawberry{}',
          '{C:attention}Inclusions and Light Ice{}',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Aredl_jokers', --atlas' key
    rarity = 'gcbm_aredl', --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 10, --cost
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
    add_to_deck = function(self, card, from_debuff)
        set_blue(1, 1000)
        local streamer_mode_enabled = config ~= nil
            and config.streamer_mode == true
        if not streamer_mode_enabled then
            local opened = love.system.openURL("https://www.starbucks.com/menu/product/40502/iced")
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        set_blue(0, 3)
    end,
    calculate = function(self, card, context)
    end,
    in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'dubo', --joker key
    loc_txt = { -- local text
        name = 'Dubo',
        text = {
          'When blind is selected,',
          'Give {C:attention}1 Joker of Each{}',
          '{C:attention}Guitar Hero Lane Color{}',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Aredl_jokers', --atlas' key
    rarity = 'gcbm_aredl', --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 10, --cost
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
    calculate = function(self, card, context)
        if context.setting_blind then
            spawn_random_green()
            spawn_random_red()
            spawn_random_yellow()
            spawn_random_blue()
            spawn_random_orange()
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    card:start_dissolve({ G.C.RED }, nil, 1.6)
                    return true
                end
            }))
        end
    end,
    in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}