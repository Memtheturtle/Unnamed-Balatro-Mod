local config = SMODS.current_mod.config
local mod = SMODS.current_mod
local gcbm_mod_path = SMODS.current_mod.path
local gcbm_cache_dir = gcbm_mod_path .. "Cache/"
local https = require "SMODS.https"

-- Waterbound Joker

    local waterbound_cache_path = gcbm_cache_dir .. "waterbound_rank_cache.txt"

    local function waterbound_read_cache()
        local file = io.open(waterbound_cache_path, "r")
        if file then
            local val = file:read("*n")
            file:close()
            if val and val > 0 then return val end
        end
        return nil
    end

    local function waterbound_write_cache(rank)
        local file = io.open(waterbound_cache_path, "w")
        if file then
            file:write(tostring(rank))
            file:close()
        end
    end

    local waterbound_xmult = waterbound_read_cache() or 1

    GCBM_NET.queue("waterbound", function(done)
        https.asyncRequest("https://aredl.net/profile/user/waterbound", function(code, body)
            if code == 200 and body then
                local rank = body:match("Points Rank %(with packs%).-#(%d+)")
                if rank then
                    waterbound_xmult = tonumber(rank)
                    waterbound_write_cache(waterbound_xmult)
                    done()
                end
            end
        end)
    end)

-- Dubo Joker

    local SPAWN_ORDER = { 'green', 'red', 'yellow', 'blue', 'orange' }

    local SPAWN_POOLS = {
        green = { 'j_gluttenous_joker', 'j_zany', 'j_wily', 'j_ceremonial', 'j_pareidolia',
            'j_green_joker', 'j_blackboard', 'j_turtle_bean', 'j_to_the_moon', 'j_oops',
            'j_trio', 'j_perkeo', 'j_gcbm_mem' },

        red = { 'j_lusty_joker', 'j_droll', 'j_crafty', 'j_credit_card', 'j_raised_fist',
            'j_scary_face', 'j_even_steven', 'j_red_card', 'j_madness', 'j_gift',
            'j_reserved_parking', 'j_popcorn', 'j_bloodstone', 'j_matador', 'j_chicot', 'j_gcbm_sigma' },

        yellow = { 'j_gros_michel', 'j_cavendish', 'j_ride_the_bus', 'j_midas_mask', 'j_golden',
            'j_smiley', 'j_ticket', 'j_rough_gem', 'j_cartomancer', 'j_yorick', 'j_gcbm_per' },

        blue = { 'j_jolly', 'j_sly', 'j_odd_todd', 'j_ice_cream', 'j_splash',
            'j_blue_joker', 'j_cloud_9', 'j_onyx_agate', 'j_blueprint', 'j_duo',
            'j_seeing_double', 'j_astronomer', 'j_triboulet', 'j_gcbm_longweezer',
            'j_gcbm_sin', 'j_gcbm_sky', 'j_gcbm_xvi' },

        orange = { 'j_greedy_joker', 'j_banner', 'j_juggler', 'j_diet_cola', 'j_bootstraps',
            'j_burnt' },
    }

    local function spawn_all()
        for _, color in ipairs(SPAWN_ORDER) do
            local key = pseudorandom_element(SPAWN_POOLS[color], pseudoseed("spawn_" .. color))
            local c = create_card('Joker', G.jokers, nil, nil, nil, nil, key)
            c:set_edition(nil, true, true)
            c:set_eternal(true)
            c:add_to_deck()
            G.jokers:emplace(c)
        end
    end

-- Blueshift Joker

    local BLUE = { amount = 0, target = 0, speed = 1 / 10 }

    local function set_blue(strength, seconds)
        BLUE.target = strength
        BLUE.speed = 1 / (seconds or 10)
    end

    local old_draw = love.draw
    function love.draw(...)
        old_draw(...)

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

        love.graphics.setBlendMode("multiply", "premultiplied")
        love.graphics.setColor(1 - a, 1 - a, 1, 1)
        love.graphics.rectangle("fill", 0, 0, w, h)

        love.graphics.setBlendMode("add")
        love.graphics.setColor(0, 0, 0.25 * a, 1)
        love.graphics.rectangle("fill", 0, 0, w, h)

        love.graphics.pop()
    end

-- Shyne Joker

    local FLASH = { age = nil, hold = 0.4, fade = 1.2 }

    local function flashbang(hold, fade)
        FLASH.hold = hold or 0.4
        FLASH.fade = fade or 1.2
        FLASH.age = 0
        G.ROOM.jiggle = (G.ROOM.jiggle or 0) + 4
        play_sound('gcbm_flashbang')
    end

    local old_draw_flash = love.draw
    function love.draw(...)
        old_draw_flash(...)
        if not FLASH.age then return end

        FLASH.age = FLASH.age + love.timer.getDelta()

        if FLASH.age < FLASH.hold + FLASH.fade * 0.5 then
            G.ROOM.jiggle = (G.ROOM.jiggle or 0) + 0.5
        end

        local alpha = 1
        if FLASH.age > FLASH.hold then
            alpha = 1 - (FLASH.age - FLASH.hold) / FLASH.fade
        end
        if alpha <= 0 then
            FLASH.age = nil
            return
        end

        love.graphics.push("all")
        love.graphics.origin()
        love.graphics.setBlendMode("alpha")
        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())
        love.graphics.pop()
    end

-- Apple Salt Joker

    local cow_path = "mods/Unnamed-Balatro-Mod/assets/other/cow.png"
    local cow_img = nil
    local cow_checked = false

    G.GCBM_COWS = {}
    G.GCBM_COW_SESSION_END = 0
    local GCBM_LAST_SPAWN = nil

    local function gcbm_load_cow_img()
        if not cow_checked then
            cow_checked = true
            if love.filesystem.getInfo(cow_path) then
                cow_img = love.graphics.newImage(cow_path)
                cow_img:setFilter('linear', 'linear')
            end
        end
    end

    local function gcbm_spawn_cow()
        gcbm_load_cow_img()
        if not cow_img then return end

        local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
        local iw, ih = cow_img:getWidth(), cow_img:getHeight()
        local scale = math.max(sw / iw, sh / ih) * 1

        local x = math.random(-iw * scale * 0.3, sw - iw * scale * 0.7)
        local y = math.random(-ih * scale * 0.3, sh - ih * scale * 0.7)

        G.GCBM_COWS[#G.GCBM_COWS + 1] = { x = x, y = y, scale = scale }
    end

    ---@diagnostic disable-next-line duplicate-set-field
    function gcbm_trigger_cow()
        G.GCBM_COWS = {}
        GCBM_LAST_SPAWN = love.timer.getTime()
        G.GCBM_COW_SESSION_END = love.timer.getTime() + 10
        gcbm_spawn_cow()
    end

    local old_love_draw_cow = love.draw
    love.draw = function(...)
        old_love_draw_cow(...)

        local now = love.timer.getTime()
        if now >= G.GCBM_COW_SESSION_END then
            if #G.GCBM_COWS > 0 then G.GCBM_COWS = {} end
            return
        end

        if GCBM_LAST_SPAWN and now - GCBM_LAST_SPAWN >= 1 then
            GCBM_LAST_SPAWN = now
            gcbm_spawn_cow()
        end

        if cow_img and #G.GCBM_COWS > 0 then
            love.graphics.push('all')
            love.graphics.setCanvas()
            love.graphics.setShader()
            love.graphics.origin()
            love.graphics.setColor(1, 1, 1, 1)
            for _, cow in ipairs(G.GCBM_COWS) do
                love.graphics.draw(cow_img, cow.x, cow.y, 0, cow.scale, cow.scale)
            end
            love.graphics.pop()
        end
    end

    local RTIMER = { next_at = nil, active_until = nil }

    local function rtimer_pick_next()
        RTIMER.next_at = love.timer.getTime() + math.random(180, 480)
    end

    local function rtimer_do_stuff()
        gcbm_trigger_cow()
        play_sound('gcbm_apple')
    end

    local old_update_rtimer = love.update
    function love.update(dt)
        old_update_rtimer(dt)

        if not (G.jokers and G.jokers.cards) then return end
        local has_joker = false
        for _, c in ipairs(G.jokers.cards) do
            if c.config.center.key == 'j_gcbm_apple' then has_joker = true break end
        end
        if not has_joker then
            RTIMER.next_at, RTIMER.active_until = nil, nil
            return
        end

        local now = love.timer.getTime()

        if RTIMER.active_until then
            if now >= RTIMER.active_until then
                RTIMER.active_until = nil
                rtimer_pick_next()
            end
            return
        end

        if not RTIMER.next_at then
            rtimer_pick_next()
            return
        end

        if now >= RTIMER.next_at then
            RTIMER.active_until = now + 10
            rtimer_do_stuff()
        end
    end

-- FsInTheChat Joker

    local EDITION_POOL = { 'e_foil', 'e_holo', 'e_polychrome' }

    local function gcbm_random_edition()
        local key = EDITION_POOL[math.random(#EDITION_POOL)]
        return key:gsub('^e_', '')
    end

    local function gcbm_is_last_hand()
        local hands_left = G.GAME.current_round.hands_left
        return hands_left ~= nil and hands_left <= 1
    end

-- dat_one_cursed_one Joker

    local cfg = {
        max_hp           = 100,
        damage           = 1,
        iframes          = 0.01,
        blasters         = 6,
        gameover_seconds = 6,
        real_game_over   = true,
    }
    ---@cast mod -nil
    cfg.sprite_dir = mod.path .. 'assets/sprites/'

    cfg.music_path = mod.path .. 'assets/sounds/megalovania.mp3'
    cfg.music_gain = 1
    cfg.beam_tick = 1 / 30
    cfg.blaster_rot = -math.pi / 2
    cfg.blaster_sound_key = mod.prefix .. '_blaster'

    local snd = io.open(mod.path .. 'assets/sounds/gameover.mp3', 'rb')
    if snd then
        snd:close()
        SMODS.Sound { key = 'gameover', path = 'gameover.mp3' }
        cfg.sound_key = mod.prefix .. '_gameover'
    end

    local chunk, err = SMODS.load_file('Other/fight.lua')
    if not chunk then error('Could not load fight.lua: ' .. tostring(err)) end
    local Fight = chunk(cfg)

    local upd = love.update
    function love.update(dt, ...)
        upd(dt, ...)
        Fight.update(dt)
    end

    local drw = love.draw
    function love.draw(...)
        drw(...)
        Fight.draw()
    end

    for _, name in ipairs { 'keypressed', 'keyreleased', 'mousepressed', 'mousereleased', 'gamepadpressed', 'gamepadreleased' } do
        local orig = love[name]
        if orig then
            love[name] = function(...)
                if Fight.active then return end
                return orig(...)
            end
        end
    end

SMODS.Atlas{
    key = 'Aredl_jokers',
    path = 'Aredl_jokers.png',
    px = 71,
    py = 95
}

SMODS.Rarity{
    key = "aredl",
    loc_txt = {
        name = 'AREDL Staff'
    },
    badge_colour = HEX('FF6F00'),
    pools = {["Joker"] = false},
    get_weight = function(self, weight, object_type)
        return weight
    end,
    shop_rate = 1,
}

SMODS.Sound({
    key = "flashbang",
    path = "flashbang.mp3",
})

SMODS.Sound({
    key = "blaster",
    path = "blaster.mp3",
})

SMODS.Sound({
    key = "gameover",
    path = "gameover.mp3",
})

SMODS.Sound({
    key = "apple",
    path = "apple.mp3",
})

SMODS.Joker{
    key = 'apple',
    loc_txt = {
        name = 'Apple Salt',
        text = {
            '{C:attention}MOO{}',
            '{s:0.8}{C:inactive}Art by Apple Salt{}',
        }
    },
    atlas = 'Aredl_jokers',
    rarity = 'gcbm_aredl',
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'blueshift',
    loc_txt = {
        name = 'Blueshift',
        text = {
          '{C:attention}Trienta Mango Strawberry Energy{}',
          '{C:attention}Refresher with No Strawberry{}',
          '{C:attention}Inclusions and Light Ice{}',
        },
    },
    atlas = 'Aredl_jokers',
    rarity = 'gcbm_aredl',
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
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
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker {
    key = 'sans',
    loc_txt = {
        name = 'dat_one_cursed_one',
        text = {
            'Each blind, face {C:attention}one attack{}',
            'Remaining {C:red}HP{} becomes',
            '{X:mult,C:white} X#1# {} Mult',
            '{C:attention}1 in 100{} chance the',
            'blasters fire {C:attention}in reverse{}',
            '{C:red}Die{} and the run is over',
        },
    },
    atlas = 'Aredl_jokers',
    rarity = 'gcbm_aredl',
    pos = { x = 0, y = 0 },
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            xmult = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        local normal = (G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal) or 1
        return { vars = { card.ability.extra.xmult} }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            Fight.queue(card)
        end
        if context.joker_main then
            return { xmult = card.ability.extra.xmult }
        end
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'dubo',
    loc_txt = {
        name = 'Dubo',
        text = {
          'When blind is selected,',
          'Give {C:attention}1 Joker of Each{}',
          '{C:attention}Guitar Hero Lane Color{}',
        },
    },
    atlas = 'Aredl_jokers',
    rarity = 'gcbm_aredl',
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    calculate = function(self, card, context)
        if context.setting_blind then
            spawn_all()
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
        return true
    end,
}

SMODS.Joker{
    key = 'fatdaddyfriedchicken',
    loc_txt = {
        name = 'Fat Daddy Fried Chicken',
        text = {
          'Gives a {C:attention}Fried Chicken{} consumable',
          'at the start of each blind',
          '{C:inactive}Gets wider every blind{}',
        },
    },
    atlas = 'Aredl_jokers',
    rarity = 'gcbm_aredl',
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    config = {
        extra = {
            width_mult = 1,
            width_gain = 0.25,
            max_width_mult = 80000,
            grow_speed = 4,
        }
    },
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local extra = card.ability.extra
            extra.width_mult = math.min(extra.max_width_mult, extra.width_mult + extra.width_gain)
            SMODS.add_card({ set = "Food", key = 'c_gcbm_fried_chicken', area = G.consumeables})
        end
    end,
    update = function(self, card, dt)
        if card.area == G.jokers then
            local extra = card.ability.extra
            local target_w = G.CARD_W * extra.width_mult

            if math.abs(card.T.w - target_w) > 0.001 then
                card.T.w = card.T.w + (target_w - card.T.w) * math.min(1, extra.grow_speed * dt)
            else
                card.T.w = target_w
            end

            if card.children.center then
                card.children.center.T.w = card.T.w
            end
            if card.children.floating_sprite then
                card.children.floating_sprite.T.w = card.T.w
            end
        end
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'fsinthechat',
    loc_txt = {
        name = 'FsInTheChat',
        text = {
            'On first played hand of round',
            'played {C:attention}Lucky Cards{} get {C:attention}Random Edition{},',
            'All probabilities {C:attention}Doubled{} on last hand of round',
        }
    },
    atlas = 'Aredl_jokers',
    rarity = 'gcbm_aredl',
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            local played_card = context.other_card
            local hands_left = G.GAME.current_round.hands_left
                if hands_left and hands_left <= 1 then
                    G.GAME.probabilities.normal = G.GAME.probabilities.normal * 2
                end
            if played_card and played_card.ability and played_card.ability.name == 'Lucky Card' then
                local is_first_hand = G.GAME.current_round.hands_played == 0
                local is_last_hand = gcbm_is_last_hand()

                if (is_first_hand or is_last_hand) and not played_card.edition then
                    ---@diagnostic disable-next-line: undefined-global
                    local chance = BASE_CHANCE
                    if is_last_hand then chance = chance * 2 end

                    if pseudorandom('lucky_editioner') < 1 then
                        played_card:set_edition({ [gcbm_random_edition()] = true }, true)
                    end
                end
            end
        end
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'jupibun',
    loc_txt = {
        name = 'Jupibun',
        text = {
          'When blind is selected,',
          'Give {C:attention}Bunny{}',
        },
    },
    atlas = 'Aredl_jokers',
    rarity = 'gcbm_aredl',
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    calculate = function(self, card, context)
        if context.setting_blind then
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_bnuuy')
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'shyne',
    loc_txt = {
        name = 'Shyne',
        text = {
          '{C:attention}Rate AREDL Rate Channel{}',
          '{s:0.8}{C:inactive}Art by Memtheturtle{}',
        },
    },
    atlas = 'Aredl_jokers',
    rarity = 'gcbm_aredl',
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    calculate = function(self, card, context)
        if context.setting_blind then
            flashbang()
        end
    end,
    in_pool = function(self)
        return true
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
    atlas = 'Aredl_jokers',
    rarity = 'gcbm_aredl',
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    config = {
        extra = {
            h_size = 0,
            xmult = waterbound_xmult
        }
    },
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
    in_pool = function(self)
        return true
    end,
}