--------------------------------------------------------------------
-- fight.lua : "intro attack" dodge fight, drawn as an overlay.
-- Order: blue-soul floor slam -> bone hallway -> 4 blaster sets
-- Logical screen is 640x480, scaled to fit the window.
--------------------------------------------------------------------
local cfg = ... or {
    max_hp = 100, damage = 1, iframes = 0.01,
    gameover_seconds = 6, real_game_over = true,
}

-- Undertale-style beam damage: lose 1 HP every `beam_tick` seconds while inside a beam.
-- 1/30 = 1 HP per game tick (30 fps). Use 2/30 for 1 HP every 2 ticks, etc.
local BEAM_TICK = cfg.beam_tick or (1 / 100)
local BONE_DMG  = cfg.damage or 5     -- HP lost per bone hit (has i-frames)

local F = { cur = nil, active = false }

local W, H  = 640, 480
local A     = 240                                   -- arena is an A x A square
local ARENA = { x = (W - A) / 2, y = 190, w = A, h = A }
local CX, CY = ARENA.x + A / 2, ARENA.y + A / 2

local CHARGE, BEAM = 0.4, 0.3         -- blaster telegraph / live time (faster)
local SOUL, HIT    = 14, 5
local SPEED        = 190
local GRAV, JUMP   = 900, 280
local SLAM_H       = 22
local BONE_W, BONE_SPEED, BONE_GAP = 10, 420, 34
local GAPC         = ARENA.y + A * 0.62

-- timeline (seconds), compressed from the first version
local BLUE_ON, SLAM_WARN, SLAM_ON, SLAM_OFF, BLUE_OFF = 0.5, 0.7, 1.1, 1.4, 1.6
local HALL_START, HALL_N, HALL_STEP = 1.8, 10, 0.12
local SET_T0, SET_STEP, STAGGER     = 3.5, 0.95, 0.07
local OUTRO = 0.6

local font_small, font_big, sprites
local function fonts()
    if not font_small then
        font_small = love.graphics.newFont(16)
        font_big = love.graphics.newFont(48)
    end
end

-- Optional sprites. Drop your OWN art in <sprite_dir>/sans.png and blaster.png
-- (blaster art should face RIGHT). Missing files => plain shapes are used.
local function load_sprites()
    if sprites then return end
    sprites = {}
    local dir = cfg.sprite_dir
    if not dir or not NFS then return end
    for _, name in ipairs { 'sans', 'blaster' } do
        local p = dir .. name .. '.png'
        pcall(function()
            if NFS.getInfo(p) then
                ---@diagnostic disable-next-line: param-type-mismatch
                local img = love.graphics.newImage(NFS.newFileData(p))
                img:setFilter('nearest', 'nearest')
                sprites[name] = img
            end
        end)
    end
end

local function clamp(v, lo, hi) return math.max(lo, math.min(hi, v)) end

local function roll_reverse()
    return pseudorandom('gcbm_sans_reverse') < 0.01
end

local function safe_sound(key, pitch, vol)
    local known = G and G.SOUND_MANAGER and SMODS and SMODS.Sounds and SMODS.Sounds[key]
    local ok, err = pcall(play_sound, key, pitch or 1, vol or 1)
    if not ok or (key ~= 'cancel' and not known) then
        print('[SansJoker] sound "' .. tostring(key) .. '" problem: ' .. tostring(err)
            .. (known and '' or ' (key not registered in SMODS.Sounds)'))
    end
end

---------------------------------------------------------------- music
local function start_music(f)
    if not cfg.music_path or not NFS then return end
    pcall(function()
        if not NFS.getInfo(cfg.music_path) then return end
        ---@diagnostic disable-next-line: param-type-mismatch
        local src = love.audio.newSource(NFS.newFileData(cfg.music_path), 'stream')
        local s = G.SETTINGS and G.SETTINGS.SOUND or {}
        local vol = ((s.volume or 50) / 100) * ((s.music_volume or 100) / 100)
        src:setVolume(clamp(vol * (cfg.music_gain or 1), 0, 1))
        src:setLooping(false)
        src:play()
        f.music = src
    end)
end

local function stop_music(f)
    if f.music then
        pcall(function() f.music:stop() end)
        f.music = nil
    end
end

---------------------------------------------------------------- attack data
-- size = blaster body scale. Beams are thick so the arena is actually threatened.
local function box_set()
    local off, w, len = 84, 68, A + 120
    return {
        { ox = ARENA.x - 60,     oy = CY - off,         ang = 0,           len = len, w = w, size = 2.1 },
        { ox = ARENA.x + A + 60, oy = CY + off,         ang = math.pi,     len = len, w = w, size = 2.1 },
        { ox = CX - off,         oy = ARENA.y - 60,     ang = math.pi / 2, len = len, w = w, size = 2.1 },
        { ox = CX + off,         oy = ARENA.y + A + 60, ang = -math.pi / 2, len = len, w = w, size = 2.1 },
    }
end

local function x_set()
    local out = {}
    for _, a in ipairs { math.pi / 4, 3 * math.pi / 4 } do
        out[#out + 1] = {
            ox = CX - math.cos(a) * 300, oy = CY - math.sin(a) * 300,
            ang = a, len = 600, w = 84, size = 2.2,
        }
    end
    return out
end

local function wide_set()
    local w = A * 0.7
    return {
        { ox = ARENA.x - 70,     oy = CY, ang = 0,       len = A + 140, w = w, size = 3.2, stagger = 0 },
        { ox = ARENA.x + A + 70, oy = CY, ang = math.pi, len = A + 140, w = w, size = 3.2, stagger = 0 },
    }
end

local function build_beams(reversed)
    local sets = { box_set(), x_set(), box_set(), wide_set() }
    if reversed then
        local r = {}
        for i = #sets, 1, -1 do
            local s, rs = sets[i], {}
            for j = #s, 1, -1 do rs[#rs + 1] = s[j] end
            r[#r + 1] = rs
        end
        sets = r
    end
    local beams = {}
    for k, s in ipairs(sets) do
        for j, b in ipairs(s) do
            b.t0 = SET_T0 + (k - 1) * SET_STEP + (j - 1) * (b.stagger or STAGGER)
            beams[#beams + 1] = b
        end
    end
    return beams
end

local function beam_state(b, t)
    local lt = t - b.t0
    if lt < -0.15 or lt > CHARGE + BEAM + 0.2 then return nil end
    if lt < CHARGE then return 'charge', lt / CHARGE, b.w end
    if lt < CHARGE + BEAM then
        local p = (lt - CHARGE) / BEAM
        return 'fire', p, b.w * (1 - math.max(0, p - 0.6) / 0.4)
    end
    return 'done', 1, 0
end

local function in_beam(b, sx, sy, w)
    local c, s = math.cos(b.ang), math.sin(b.ang)
    local dx, dy = sx - b.ox, sy - b.oy
    local u = dx * c + dy * s
    local v = -dx * s + dy * c
    return u >= 24 and u <= b.len and math.abs(v) < w / 2 + 1
end

---------------------------------------------------------------- flow
local function finish(f)
    stop_music(f)
    F.active = false
    F.cur = nil
    if G and G.CONTROLLER then G.CONTROLLER.locks.sansjk = nil end
    f.finished = true
end

function F.start(f)
    fonts()
    load_sprites()
    f.started  = true
    f.t        = 0
    f.hp       = cfg.max_hp
    f.iframes  = 0
    f.shake    = 0
    f.tick     = 0
    f.state    = 'fight'
    f.mode     = 'red'
    f.vy       = 0
    f.reversed = roll_reverse()
    f.soul     = { x = ARENA.x + 40, y = ARENA.y + A - SOUL / 2 }
    f.beams    = build_beams(f.reversed)

    f.bones = {}
    for i = 0, HALL_N - 1 do f.bones[#f.bones + 1] = HALL_START + i * HALL_STEP end

    local last = 0
    for _, b in ipairs(f.beams) do last = math.max(last, b.t0) end
    f.end_t = last + CHARGE + BEAM + OUTRO

    start_music(f)

    F.cur, F.active = f, true
    G.CONTROLLER.locks.sansjk = true
end

-- Called from the joker: blocks Balatro's event queue until the fight is over.
function F.queue(card)
    local f = { card = card, started = false, finished = false }
    G.E_MANAGER:add_event(Event({
        trigger = 'after', delay = 0.2, blocking = true, blockable = true,
        func = function()
            if not f.started then F.start(f) end
            return f.finished
        end,
    }))
end

local function die(f)
    f.state, f.dt = 'dying', 0
    f.hp = 0
    stop_music(f)   -- the music cuts out on death, like the real game
    if cfg.sound_key then safe_sound(cfg.sound_key, 1, 1) end
end

local function win(f) f.state, f.wt = 'won', 0 end

local function trigger_game_over()
    G.STATE = G.STATES.GAME_OVER
    G.STATE_COMPLETE = false
end

local function bone_hit(f)
    if f.iframes > 0 then return end
    f.hp = f.hp - BONE_DMG
    f.iframes = cfg.iframes or 0.6
    f.shake = 0.2
    safe_sound('cancel', 0.6, 0.8)
    if f.hp <= 0 then die(f) end
end

local function bone_geometry()
    local top_h = GAPC - BONE_GAP / 2 - ARENA.y
    local bot_y = GAPC + BONE_GAP / 2
    return top_h, bot_y
end

local function bone_x(f, t0) return ARENA.x + A + BONE_W - (f.t - t0) * BONE_SPEED end

---------------------------------------------------------------- update
function F.update(dt)
    local f = F.cur
    if not f then return end
    dt = math.min(dt, 1 / 20)
    f.t = f.t + dt
    if f.shake > 0 then f.shake = f.shake - dt end

    if f.state == 'fight' then
        local t = f.t
        local mode = (t >= BLUE_ON and t < BLUE_OFF) and 'blue' or 'red'
        if mode ~= f.mode then f.mode, f.vy = mode, 0 end

        local kd = love.keyboard.isDown
        local left, right = kd('left', 'a'), kd('right', 'd')
        local up, down = kd('up', 'w'), kd('down', 's')
        local dx = (right and 1 or 0) - (left and 1 or 0)
        local minx, maxx = ARENA.x + SOUL / 2, ARENA.x + A - SOUL / 2
        local miny, maxy = ARENA.y + SOUL / 2, ARENA.y + A - SOUL / 2

        if mode == 'blue' then
            f.soul.x = clamp(f.soul.x + dx * SPEED * dt, minx, maxx)
            f.vy = f.vy + GRAV * dt
            if up and f.soul.y >= maxy - 0.5 then f.vy = -JUMP end
            if not up and f.vy < -80 then f.vy = -80 end     -- release early = short hop
            f.soul.y = f.soul.y + f.vy * dt
            if f.soul.y >= maxy then f.soul.y, f.vy = maxy, 0 end
            if f.soul.y <= miny then f.soul.y, f.vy = miny, 0 end
        else
            local dy = (down and 1 or 0) - (up and 1 or 0)
            if dx ~= 0 and dy ~= 0 then dx, dy = dx * 0.7071, dy * 0.7071 end
            f.soul.x = clamp(f.soul.x + dx * SPEED * dt, minx, maxx)
            f.soul.y = clamp(f.soul.y + dy * SPEED * dt, miny, maxy)
        end

        if f.iframes > 0 then f.iframes = f.iframes - dt end
        local sx, sy = f.soul.x, f.soul.y

        -- floor slam
        if t >= SLAM_ON and t < SLAM_OFF and sy + HIT > ARENA.y + A - SLAM_H then
            bone_hit(f)
        end

        -- bone hallway
        if f.state == 'fight' then
            local top_h, bot_y = bone_geometry()
            for _, t0 in ipairs(f.bones) do
                if t >= t0 then
                    local x = bone_x(f, t0)
                    local x0, x1 = math.max(x, ARENA.x), math.min(x + BONE_W, ARENA.x + A)
                    if x1 > x0 and sx + HIT > x0 and sx - HIT < x1
                        and (sy - HIT < ARENA.y + top_h or sy + HIT > bot_y) then
                        bone_hit(f)
                        break
                    end
                end
            end
        end

        -- blasters: blaster SFX on fire, 1 HP every BEAM_TICK seconds while inside a beam
        if f.state == 'fight' then
            local burning = false
            for _, b in ipairs(f.beams) do
                local st, _, w = beam_state(b, t)
                if st == 'fire' then
                    if not b.fired then
                        b.fired = true
                        if cfg.blaster_sound_key then safe_sound(cfg.blaster_sound_key, 1, 1) end
                    end
                    if in_beam(b, sx, sy, w) then burning = true end
                end
            end
            if burning then
                f.shake = math.max(f.shake, 0.05)
                f.tick = f.tick + dt
                while f.tick >= BEAM_TICK and f.state == 'fight' do
                    f.tick = f.tick - BEAM_TICK
                    f.hp = f.hp - 1
                    if f.hp <= 0 then die(f) end
                end
            else
                f.tick = 0
            end
        end

        if f.state == 'fight' and f.t >= f.end_t then win(f) end

    elseif f.state == 'won' then
        f.wt = f.wt + dt
        if f.wt >= 0.9 then
            local hp = math.max(1, math.ceil(f.hp))
            f.card.ability.extra.xmult = hp
            card_eval_status_text(f.card, 'extra', nil, nil, nil,
                { message = 'X' .. hp, colour = G.C.MULT })
            finish(f)
        end

    elseif f.state == 'dying' then
        f.dt = f.dt + dt
        if f.dt >= (cfg.gameover_seconds or 6) then
            if cfg.real_game_over ~= false then
                finish(f)
                trigger_game_over()
            else
                f.card.ability.extra.xmult = 1
                finish(f)
            end
        end
    end
end

---------------------------------------------------------------- draw
local function draw_soul(x, y)
    love.graphics.circle('fill', x - 3.5, y - 2, 4)
    love.graphics.circle('fill', x + 3.5, y - 2, 4)
    love.graphics.polygon('fill', x - 7, y - 0.5, x + 7, y - 0.5, x, y + 7)
end

local function draw_blaster_body(b, alpha)
    local img = sprites and sprites.blaster
    love.graphics.push()
    love.graphics.translate(b.ox, b.oy)
    -- cfg.blaster_rot: which way YOUR sprite faces. Right = 0 (default), down = -math.pi/2,
    -- left = math.pi, up = math.pi/2
    love.graphics.rotate(b.ang + (cfg.blaster_rot or 0))
    if img then
        local sc = (36 * b.size) / img:getHeight()
        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.draw(img, 0, 0, 0, sc, sc, img:getWidth() / 2, img:getHeight() / 2)
    else
        local bw, bh = 26 * b.size, 18 * b.size
        love.graphics.setColor(0.75, 0.75, 0.8, alpha)
        love.graphics.rectangle('fill', -bw / 2, -bh / 2, bw, bh, 6, 6)
        love.graphics.setColor(0.3, 0.9, 1, alpha)
        love.graphics.rectangle('line', -bw / 2, -bh / 2, bw, bh, 6, 6)
    end
    love.graphics.pop()
end

local function draw_beam(b, alpha, w)
    love.graphics.push()
    love.graphics.translate(b.ox, b.oy)
    love.graphics.rotate(b.ang)
    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.rectangle('fill', 24, -w / 2, b.len - 24, w)
    love.graphics.pop()
end

function F.draw()
    local f = F.cur
    if not f then return end
    fonts()

    local sw, sh = love.graphics.getDimensions()
    local s = math.min(sw / W, sh / H)

    love.graphics.push('all')
    love.graphics.origin()
    love.graphics.setScissor()
    love.graphics.setCanvas()

    love.graphics.setColor(0, 0, 0, 0.93 * math.min(1, f.t / 0.4))
    love.graphics.rectangle('fill', 0, 0, sw, sh)

    love.graphics.translate((sw - W * s) / 2, (sh - H * s) / 2)
    love.graphics.scale(s)

    -- Game over screen
    if f.state == 'dying' and f.dt >= 1.0 then
        local a = math.min(1, (f.dt - 1.0) / 1.5)
        love.graphics.setColor(1, 1, 1, a)
        love.graphics.setFont(font_big)
        love.graphics.printf('GAME OVER', 0, H / 2 - 30, W, 'center')
        love.graphics.pop()
        return
    end

    if f.shake > 0 then
        love.graphics.translate(love.math.random(-3, 3), love.math.random(-3, 3))
    end

    -- opponent sprite (only if you supplied sans.png)
    if sprites and sprites.sans then
        local img = sprites.sans
        local sc = 110 / img:getHeight()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(img, CX, 80, 0, sc, sc, img:getWidth() / 2, img:getHeight() / 2)
    end

    -- arena
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', ARENA.x - 2, ARENA.y - 2, A + 4, A + 4)

    local alive = not (f.state == 'dying' and f.dt >= 0.6)
    if alive then
        local t = f.t

        -- floor slam
        local fy = ARENA.y + A - SLAM_H
        if t >= SLAM_WARN and t < SLAM_ON then
            love.graphics.setColor(1, 1, 1, 0.25 + 0.25 * (math.floor(t / 0.1) % 2))
            love.graphics.rectangle('fill', ARENA.x, fy, A, 2)
        elseif t >= SLAM_ON and t < SLAM_OFF then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.rectangle('fill', ARENA.x, fy, A, SLAM_H)
        end

        -- bone hallway
        local top_h, bot_y = bone_geometry()
        love.graphics.setColor(1, 1, 1, 1)
        for _, t0 in ipairs(f.bones) do
            if t >= t0 then
                local x = bone_x(f, t0)
                local x0, x1 = math.max(x, ARENA.x), math.min(x + BONE_W, ARENA.x + A)
                if x1 > x0 then
                    love.graphics.rectangle('fill', x0, ARENA.y, x1 - x0, top_h, 3, 3)
                    love.graphics.rectangle('fill', x0, bot_y, x1 - x0, ARENA.y + A - bot_y, 3, 3)
                end
            end
        end

        -- blasters + beams (clipped to the screen, not the arena, like the real thing)
        for _, b in ipairs(f.beams) do
            local st, p, w = beam_state(b, t)
            if st then
                if st == 'charge' then
                    draw_beam(b, 0.06 + 0.2 * p, b.w)
                    draw_blaster_body(b, math.min(1, 0.4 + p))
                elseif st == 'fire' then
                    draw_beam(b, 1, w)
                    draw_blaster_body(b, 1)
                else
                    draw_blaster_body(b, 0.4)
                end
            end
        end
    end

    -- soul
    if f.state == 'dying' then
        if f.dt < 0.6 then
            love.graphics.setColor(1, 0, 0, 1)
            draw_soul(f.soul.x, f.soul.y)
        else
            local d = (f.dt - 0.6) * 220
            love.graphics.setColor(1, 0, 0, math.max(0, 1 - (f.dt - 0.6) / 0.4))
            for i = 0, 5 do
                local ang = i * math.pi / 3 + 0.4
                love.graphics.rectangle('fill', f.soul.x + math.cos(ang) * d - 2, f.soul.y + math.sin(ang) * d - 2, 4, 4)
            end
        end
    elseif f.iframes <= 0 or math.floor(f.t / 0.07) % 2 == 0 then
        if f.mode == 'blue' then love.graphics.setColor(0.15, 0.35, 1, 1)
        else love.graphics.setColor(1, 0, 0, 1) end
        draw_soul(f.soul.x, f.soul.y)
    end

    -- HP bar
    local shown = math.max(0, math.ceil(f.hp))
    local frac = math.max(0, f.hp) / cfg.max_hp
    local by = ARENA.y + A + 16
    love.graphics.setFont(font_small)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('HP', ARENA.x, by)
    love.graphics.setColor(0.8, 0, 0, 1)
    love.graphics.rectangle('fill', ARENA.x + 36, by, 120, 18)
    love.graphics.setColor(1, 0.9, 0, 1)
    love.graphics.rectangle('fill', ARENA.x + 36, by, 120 * frac, 18)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(shown .. ' / ' .. cfg.max_hp, ARENA.x + 166, by)

    if f.state == 'won' then
        love.graphics.setColor(1, 0.9, 0, 1)
        love.graphics.printf('X' .. math.max(1, shown) .. ' Mult', 0, 30, W, 'center')
    end

    love.graphics.pop()
end

return F
