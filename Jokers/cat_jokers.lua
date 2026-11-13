-- Bluecat Joker

    local FRAME_DIR = "mods/Unnamed-Balatro-Mod/assets/other/bluecat_frames/"
    local FRAME_PATTERN = "bluecat_%03d.png"
    local FRAME_COUNT = 12
    local FRAME_FPS = 9
    local BLUECAT_OPACITY = 1.0
    local BLUECAT_JOKER_KEY = "j_gcbm_bluecat"
    local bluecat_sfx_path = "mods/Unnamed-Balatro-Mod/assets/sounds/bluecat_sfx.mp3"

    local bluecat_frames = nil
    local bluecat_sfx = nil
    local bluecat_time = 0

    local WIN_SHIFT_INTERVAL = 2.0
    local WIN_FALLBACK_SIZE = {1280, 720}
    local WIN_TOP_MARGIN = 40

    local win_saved = nil
    local win_timer = 0

    local function bluecat_load()
        if not bluecat_frames then
            local frames = {}
            for i = 1, FRAME_COUNT do
                local path = FRAME_DIR .. string.format(FRAME_PATTERN, i)
                if love.filesystem.getInfo(path) then
                    local ok, img = pcall(love.graphics.newImage, path)
                    if ok then
                        img:setFilter('linear', 'linear')
                        frames[#frames + 1] = img
                    end
                end
            end
            if #frames > 0 then bluecat_frames = frames end
        end
        if not bluecat_sfx and love.filesystem.getInfo(bluecat_sfx_path) then
            local ok, src = pcall(love.audio.newSource, bluecat_sfx_path, 'static')
            if ok then bluecat_sfx = src; bluecat_sfx:setLooping(true) end
        end
    end

    local function bluecat_owned()
        if not (G and G.jokers and G.jokers.cards) then return false end
        for _, c in ipairs(G.jokers.cards) do
            if c.config and c.config.center and c.config.center.key == BLUECAT_JOKER_KEY
                and not c.debuff then
                return true
            end
        end
        return false
    end

    local function bluecat_volume()
        local s = G and G.SETTINGS and G.SETTINGS.SOUND
        if not s then return 1 end
        return (s.volume or 50) / 100 * (s.game_sounds_volume or 50) / 100
    end

    local bluecat_active = false

    local function bluecat_draw()
        if not (bluecat_active and bluecat_frames) then return end

        local idx = (math.floor(bluecat_time * FRAME_FPS) % #bluecat_frames) + 1
        local img = bluecat_frames[idx]

        love.graphics.push('all')
        love.graphics.setCanvas()
        love.graphics.setShader()
        love.graphics.origin()
        love.graphics.setScissor()
        love.graphics.setBlendMode('alpha')
        love.graphics.setColor(1, 1, 1, BLUECAT_OPACITY)

        local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
        local iw, ih = img:getDimensions()
        local scale = math.max(sw / iw, sh / ih)
        love.graphics.draw(img, (sw - iw * scale) / 2, (sh - ih * scale) / 2, 0, scale, scale)

        love.graphics.pop()
    end

    local bluecat_inner_draw = love.draw
    local function bluecat_wrapped_draw(...)
        bluecat_inner_draw(...)
        bluecat_draw()
    end
    love.draw = bluecat_wrapped_draw

    local bluecat_inner_update = love.update
    love.update = function(dt, ...)
        bluecat_inner_update(dt, ...)

        if love.draw ~= bluecat_wrapped_draw then
            bluecat_inner_draw = love.draw
            love.draw = bluecat_wrapped_draw
        end

        bluecat_load()
        if bluecat_sfx then bluecat_sfx:setVolume(bluecat_volume()) end

        bluecat_active = bluecat_owned()
        if bluecat_active then
            bluecat_time = bluecat_time + dt
            if bluecat_sfx and not bluecat_sfx:isPlaying() then bluecat_sfx:play() end
        else
            bluecat_time = 0
            if bluecat_sfx and bluecat_sfx:isPlaying() then bluecat_sfx:stop() end
        end
    end

    local function win_enter()
        local w, h, flags = love.window.getMode()
        if not win_saved then
            local x, y, display = love.window.getPosition()
            local copy = {}
            for k, v in pairs(flags) do copy[k] = v end
            win_saved = { w = w, h = h, flags = copy, x = x, y = y, display = display }
        end

        local _, _, display = love.window.getPosition()
        local dw, dh = love.window.getDesktopDimensions(display)

        local nflags = {}
        for k, v in pairs(flags) do nflags[k] = v end
        nflags.fullscreen = false
        nflags.borderless = false
        nflags.centered = false

        local nw, nh = w, h
        if w >= dw - 16 or h >= dh - 16 then
            nw = math.min(WIN_FALLBACK_SIZE[1], dw - 100)
            nh = math.min(WIN_FALLBACK_SIZE[2], dh - 100)
        end

        love.window.updateMode(nw, nh, nflags)
        if love.resize then love.resize(love.graphics.getDimensions()) end
    end

    local function win_shift()
        local w, h = love.window.getMode()
        local _, _, display = love.window.getPosition()
        local dw, dh = love.window.getDesktopDimensions(display)
        local maxx = math.max(0, dw - w)
        local maxy = math.max(WIN_TOP_MARGIN, dh - h)
        love.window.setPosition(math.random(0, maxx), math.random(WIN_TOP_MARGIN, maxy), display)
    end

    local function win_restore()
        if not win_saved then return end
        local s = win_saved
        win_saved = nil
        love.window.updateMode(s.w, s.h, s.flags)
        love.window.setPosition(s.x, s.y, s.display)
        if love.resize then love.resize(love.graphics.getDimensions()) end
    end

    local win_inner_update = love.update
    love.update = function(dt, ...)
        win_inner_update(dt, ...)

        if bluecat_owned() then
            if not win_saved or love.window.getFullscreen() then
                win_enter()
                win_timer = 0
            end
            win_timer = win_timer + dt
            if win_timer >= WIN_SHIFT_INTERVAL then
                win_timer = win_timer - WIN_SHIFT_INTERVAL
                win_shift()
            end
        else
            win_restore()
        end
    end


SMODS.Atlas{
    key = 'Cat_jokers',
    path = 'Cat_jokers.png',
    px = 71,
    py = 95
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
    shop_rate = 1,
}

SMODS.Joker{
    key = 'bluecat',
    loc_txt = {
        name = 'Bluecat',
        text = {
          '+{C:chips}#1#{} Chips',
          '{s:0.8}{C:inactive}Art by Ludtropolis{}',
        },
    },
    atlas = 'Cat_jokers',
    rarity = 'gcbm_cat',
    cost = 15,
    unlocked = true, 
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
     config = {
        extra = {
            chips = 250,
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips, G.GAME.probabilities.normal or 1}}
    end,
    calculate = function(self,card,context) 
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'gorb',
    loc_txt = {
        name = 'Gorb',
        text = {
          '{X:mult,C:white}X#1#{} Mult,',
          'Increases by {C:attention}1{} for every additional {C:attention}Gorb joker{} held{}',
        },
    },
    atlas = 'Cat_jokers',
    rarity = 'gcbm_cat',
    cost = 15,
    unlocked = true, 
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 7, y = 0},
    config = {
        extra = {
            Xmult = G.gorb_count
        }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {G.gorb_count}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.gorb_count = G.gorb_count +1
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
    in_pool = function(self)
        return true
    end,
}
