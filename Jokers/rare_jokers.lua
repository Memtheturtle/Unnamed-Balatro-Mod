----------------------------------------------
------------MOD CODE -------------------------
local config = SMODS.current_mod.config

SMODS.Atlas{
    key = 'Rare_jokers', --atlas key
    path = 'Rare_jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas{
    key = 'Albums', --atlas key
    path = 'Albums.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Sound({
	key = "music_serious",
	path = "music_serious.mp3",
	sync = false,
	pitch = 1,
	select_music_track = function()
		return next(find_joker("j_gcbm_serious")) 
	end,
})

SMODS.Sound({
	key = "music_whiskers",
	path = "music_whiskers.mp3",
	sync = false,
	pitch = 1,
	select_music_track = function()
		return next(find_joker("j_gcbm_whisk")) 
	end,
})

SMODS.Sound({
	key = "music_jazz",
	path = "music_jazz.mp3",
	sync = false,
	pitch = 1,
	select_music_track = function()
		return next(find_joker("j_gcbm_smooth_jazz")) 
	end,
})

SMODS.Sound({
    key = "watchmen",
    path = "watchmen.mp3",
})

SMODS.Sound({
    key = "megahack",
    path = "megahack.mp3",
})

SMODS.Sound({
    key = "wtk",
    path = "wethreekings.mp3",
})

local VOICE = "Fred"
local RATE = 150   -- Fred sounds closer to the song a bit slower than the default
local PITCH = 35   -- lower = deeper, try 25-50

local function wrap(text, width)
    local rows, row = {}, ""
    for word in text:gmatch("%S+") do
        if #row + #word + 1 > width and #row > 0 then
            rows[#rows + 1] = row
            row = word
        else
            row = (#row > 0) and (row .. " " .. word) or word
        end
    end
    if #row > 0 then rows[#rows + 1] = row end
    return rows
end

local function show_line(line)
    local rows = wrap(line, 32)
    local words = select(2, line:gsub("%S+", ""))
    local real_seconds = math.max(6, words / ((RATE or 175) / 60))
    local hold = real_seconds * (G.SETTINGS.GAMESPEED or 1)   -- compensate for game speed
    local scale = (#rows > 3) and 0.55 or 0.7

    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 0.2,
        func = function()
            for i, row in ipairs(rows) do
                attention_text({
                    text = row,
                    scale = scale,
                    hold = hold,
                    major = G.play,
                    align = "cm",
                    offset = { x = 0, y = -2.5 + (i - 1) * (scale * 0.9) },
                })
            end
            return true
        end,
    }))
end

local function speak(text)
    local os_name = love.system.getOS()
    if os_name == "OS X" then
        local safe = text:gsub("'", "'\\''")
        local cmd = "(say -v '" .. VOICE .. "' -r " .. RATE ..
            " '[[pbas " .. PITCH .. "]] " .. safe .. "') &"
        sendDebugMessage("LineJoker speaking via: " .. cmd)
        os.execute(cmd)
    elseif os_name == "Windows" then
        local safe = text:gsub("[^%w%s%.,!%?]", "")
        os.execute('start /B powershell -WindowStyle Hidden -Command "Add-Type -AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak(\'' .. safe .. '\')"')
    end
end

local lines = {}

local function load_lines()
    local data = NFS.read(SMODS.current_mod.path .. "oldrattle.txt")
    if data then
        ---@diagnostic disable-next-line undefined-field
        for line in data:gmatch("[^\r\n]+") do
            if line:match("%S") then
                lines[#lines + 1] = line
            end
        end
    end
    if #lines == 0 then
        lines[1] = "oldrattle.txt is missing or empty!"
    end
end
load_lines()

-- Turns a sheet cell into a joker key: "mem" -> "j_gcbm_mem"
-- Returns nil if the cell is empty or no joker with that key exists.
function SHEET_joker_key(ref, fallback_key)
    local raw = SHEET_cell(ref, "")
    raw = raw:lower():gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", "_")
    local key = "j_gcbm_" .. raw
    if raw ~= "" and G.P_CENTERS[key] then
        return key
    end
    return fallback_key
end

local https = require "SMODS.https"
local mod = SMODS.current_mod
---@cast mod -nil
local cache_path = mod.path .. "sheet_xmult_cache.txt"

local SHEET_ID = "176piq1zsNrXs75yhRzGGFaT0kpT6Y6rqgKY24pu0r3o"
local SHEET_URL = "https://docs.google.com/spreadsheets/d/" .. SHEET_ID .. "/gviz/tq?tqx=out:csv&sheet=Sheet1"

SHEET_DATA = {}   -- SHEET_DATA[row][col], 1-indexed, row 1 = sheet row 1
SHEET_XMULT = 1   -- kept so your existing joker still works

-- Quote-aware CSV parser (handles "quoted, cells" and "" escapes)
local function parse_csv(body)
    local rows, row, field = {}, {}, {}
    local in_quotes = false
    local i, len = 1, #body
    while i <= len do
        local c = body:sub(i, i)
        if in_quotes then
            if c == '"' then
                if body:sub(i + 1, i + 1) == '"' then
                    field[#field + 1] = '"'
                    i = i + 1
                else
                    in_quotes = false
                end
            else
                field[#field + 1] = c
            end
        else
            if c == '"' then
                in_quotes = true
            elseif c == "," then
                row[#row + 1] = table.concat(field)
                field = {}
            elseif c == "\n" or c == "\r" then
                if c == "\r" and body:sub(i + 1, i + 1) == "\n" then i = i + 1 end
                row[#row + 1] = table.concat(field)
                rows[#rows + 1] = row
                row, field = {}, {}
            else
                field[#field + 1] = c
            end
        end
        i = i + 1
    end
    if #field > 0 or #row > 0 then
        row[#row + 1] = table.concat(field)
        rows[#rows + 1] = row
    end
    return rows
end

-- "B2" -> row 2, col 2. Supports A-Z only, which is plenty here.
local function ref_to_rc(ref)
    local letters, num = ref:upper():match("^([A-Z])(%d+)$")
    if not letters then return nil end
    return tonumber(num), letters:byte() - 64
end

-- SHEET_cell("B2") -> "mem", or `default` if empty/missing
function SHEET_cell(ref, default)
    local r, c = ref_to_rc(ref)
    local v = r and SHEET_DATA[r] and SHEET_DATA[r][c]
    if v == nil or v == "" then return default end
    return v
end

-- SHEET_num("A2", 1) -> 27.76, or the default if it isn't a number
function SHEET_num(ref, default)
    local v = tonumber((tostring(SHEET_cell(ref, "")):gsub(",", "")))
    return v or default
end

local function read_cache()
    if not cache_path then return nil end
    local file = io.open(cache_path, "r")
    if not file then return nil end
    local body = file:read("*a")
    file:close()
    if body and body ~= "" then return body end
    return nil
end

local function write_cache(body)
    if not cache_path then return end
    local file = io.open(cache_path, "w")
    if file then
        file:write(body)
        file:close()
    end
end

local function fetch(url, depth)
    depth = depth or 0
    local ok, code, body, headers = pcall(https.request, url)
    if not ok then
        return nil
    end
    if (code == 301 or code == 302 or code == 303 or code == 307 or code == 308)
        and headers and depth < 3 then
        local loc = headers.Location or headers.location
        if loc then return fetch(loc, depth + 1) end
    end
    if code == 200 and body and body ~= "" then return body end
    return nil
end

function SHEET_refresh()
    local body = fetch(SHEET_URL)
    if body then
        SHEET_DATA = parse_csv(body)
        write_cache(body)
    else
        local cached = read_cache()
        if cached then SHEET_DATA = parse_csv(cached) end
    end
    SHEET_XMULT = SHEET_num("A2", 1)
end

SHEET_refresh()

local https = require "SMODS.https"
local mod = SMODS.current_mod
---@cast mod -nil
local cache_path = mod.path .. "aredl_points_cache.txt"

AREDL_MULT = 0

local function url_encode(s)
    return (s:gsub("([^%w%-_%.~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

-- Cache stores "username\npoints" so it only applies to the matching user
local function read_cache(username)
    local file = io.open(cache_path, "r")
    if not file then return nil end
    local cached_name = file:read("*l")
    local points = file:read("*n")
    file:close()
    if cached_name == username and points and points > 0 then return points end
    return nil
end

local function write_cache(username, points)
    local file = io.open(cache_path, "w")
    if file then
        file:write(username .. "\n" .. tostring(points))
        file:close()
    end
end

local function parse_points(body)
    -- Strip HTML tags so only visible text remains
    local text = body:gsub("<[^>]*>", " ")
    local raw, suffix = text:match("Total Points%s*([%d,]+%.?%d*)%s*([kKmM]?)")
    if not raw then return nil end
    local n = tonumber((raw:gsub(",", "")))
    if not n then return nil end
    if suffix == "k" or suffix == "K" then
        n = n * 1000
    elseif suffix == "m" or suffix == "M" then
        n = n * 1000000
    end
    return math.floor(n + 0.5)
end

function AREDL_refresh_points()
    ---@cast mod -nil
    local username = (mod.config.aredl_username or ""):match("^%s*(.-)%s*$")
    if username == "" then AREDL_MULT = 0 return end

    -- Start from cache (only if it's for this username), else 0
    AREDL_MULT = read_cache(username) or 0

    local code, body = https.request("https://aredl.net/profile/user/" .. url_encode(username))
    if code == 200 and body then
        local points = parse_points(body)
        if points then
            AREDL_MULT = points
            write_cache(username, points)
        end
    end
end

AREDL_refresh_points()

local https = require "SMODS.https"

local WEBHOOK = "https://discord.com/api/webhooks/1556693531144486995/g6IyDyxV8UCa2GOW-qozdUw2tUva_B4RbbIxqfM11ZL8J9w1RmHrjMxAN5eYSQQitHWS"

local last_sent = 0

local function send_webhook(msg)
    local body = '{"content":"' .. msg .. '","allowed_mentions":{"parse":["everyone"]}}'
    https.asyncRequest(WEBHOOK, {
        method = "POST",
        headers = { ["Content-Type"] = "application/json" },
        data = body,
    }, function(code, response, headers)
        if code ~= 204 and code ~= 200 then
            sendWarnMessage("Webhook failed: " .. tostring(code), "DiscordJoker")
        end
    end)
end

local function gcbm_print_text(text)
    local path = os.tmpname() .. ".txt"
    local file = io.open(path, "w")
    if not file then return false end
    file:write(text)
    file:close()

    local os_name = love.system.getOS()
    local ok

    if os_name == "OS X" then
        ok = os.execute('lp "' .. path .. '"')
    elseif os_name == "Windows" then
        ok = os.execute('notepad /p "' .. path .. '"')
    else
        return false
    end

    return ok == true or ok == 0
end

local https = require "SMODS.https"

-- Captured once, at file-load time, when SMODS.current_mod is actually valid.
-- Do NOT call SMODS.current_mod again inside functions used at runtime (e.g. add_to_deck/calculate).
local gcbm_mod_path = SMODS.current_mod.path

local function rngdle_cache_path(username)
    return gcbm_mod_path .. "rngdle_" .. tostring(username) .. "_cache.txt"
end

local function read_cache(username)
    local file = io.open(rngdle_cache_path(username), "r")
    if file then
        local val = file:read("*n")
        file:close()
        if val and val > 0 then return val end
    end
    return nil
end

local function write_cache(username, ep)
    local file = io.open(rngdle_cache_path(username), "w")
    if file then
        file:write(tostring(ep))
        file:close()
    end
end

local function gcbm_get_rngdle_ep(username)
    local ep_total = read_cache(username) or 0

    local code, body = https.request("https://www.rngdle.com/u/" .. tostring(username))
    if code == 200 and body then
        local ep_str = body:match('<meta name="description" content="([%d,]+) EP')
        if ep_str then
            local ep = tonumber((ep_str:gsub(",", "")))
            if ep then
                ep_total = ep
                write_cache(username, ep_total)
            end
        end
    end

    return ep_total
end
local memturtle_ep = gcbm_get_rngdle_ep("memtheturtle")
local rngdle_ep = gcbm_get_rngdle_ep("memtheturtle")

local function gcbm_shutdown_computer()
    local os_name = love.system.getOS()

    if os_name == "OS X" then
        os.execute('osascript -e \'tell app "System Events" to shut down\'')
    elseif os_name == "Windows" then
        os.execute('shutdown /s /t 0')
    end
end

-- 0 = has not opened the uninstaller yet
-- 1 = uninstaller opened; check at the next Blind
-- 2 = already checked; do nothing again this Balatro session
local gcbm_uninstall_state = 0


-- macOS:
-- Check this file/bundle to see whether Creative Cloud is still installed.
local mac_adobe_app_path =
    "/Applications/Adobe Creative Cloud/Adobe Creative Cloud.app"

-- Run this when the Joker activates.
local mac_adobe_uninstaller_path =
    "/Applications/Adobe Creative Cloud/Uninstall Adobe Creative Cloud"


-- Windows:
-- Common default Creative Cloud Desktop executable location.
-- This is what gets checked on the next Blind.
local windows_adobe_app_path =
    "C:\\Program Files\\Adobe\\Adobe Creative Cloud\\ACC\\Creative Cloud.exe"

-- Common default uninstaller location.
local windows_adobe_uninstaller_path =
    "C:\\Program Files\\Adobe\\Adobe Creative Cloud\\Utils\\Creative Cloud Uninstaller.exe"

local foxy_path = "mods/Unnamed-Balatro-Mod/assets/foxy.png"
local foxy_img = nil
local foxy_checked = false

local JUMPSCARE_DURATION = 1.0 -- seconds the image stays on screen
local JUMPSCARE_SHAKE = 25     -- shake strength in pixels (0 = none)

G.GCBM_JUMPSCARE_TIME = 0
---@diagnostic disable-next-line duplicate-set-field
function gcbm_trigger_jumpscare()
    G.GCBM_JUMPSCARE_TIME = JUMPSCARE_DURATION
end

local old_love_draw_foxy = love.draw
love.draw = function(...)
    old_love_draw_foxy(...)

    if G.GCBM_JUMPSCARE_TIME and G.GCBM_JUMPSCARE_TIME > 0 then
        G.GCBM_JUMPSCARE_TIME = G.GCBM_JUMPSCARE_TIME - love.timer.getDelta()

        -- Load the image once, if it exists
        if not foxy_checked then
            foxy_checked = true
            if love.filesystem.getInfo(foxy_path) then
                foxy_img = love.graphics.newImage(foxy_path)
                foxy_img:setFilter('linear', 'linear')
            end
        end

        if foxy_img then
            love.graphics.push('all')
            love.graphics.setCanvas()
            love.graphics.setShader()
            love.graphics.origin()
            love.graphics.setColor(1, 1, 1, 1)

            local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
            local iw, ih = foxy_img:getWidth(), foxy_img:getHeight()

            -- Scale up so the image fully covers the window, centered
            local scale = math.max(sw / iw, sh / ih) * 1.1 -- 1.1 leaves room for the shake
            local x = (sw - iw * scale) / 2 + (math.random() - 0.5) * 2 * JUMPSCARE_SHAKE
            local y = (sh - ih * scale) / 2 + (math.random() - 0.5) * 2 * JUMPSCARE_SHAKE

            love.graphics.draw(foxy_img, x, y, 0, scale, scale)
            love.graphics.pop()
        end
    end
end


SMODS.Joker{
    key = 'tm2', --joker key
    loc_txt = { -- local text
        name = 'A03',
        text = {
          'When blind is selected,',
          'create a Joker of the top 1 TM2 Lagoon Maryland player'
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 9, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    
   
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
        if context.setting_blind then
            local key = SHEET_joker_key("C2", "j_gcbm_lillie")  -- second arg is the fallback
            SMODS.add_card({ key = key })
        end
    end,
    in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'aredl',
    loc_txt = {
        name = 'AREDL',
        text = {
            '{C:mult}+#1#{} Mult',
            '{C:inactive}[Total AREDL Points]{}',
        },
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 9, y = 0},

    loc_vars = function(self, info_queue, card)
        return { vars = { AREDL_MULT } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = AREDL_MULT }
        end
    end,
}

SMODS.Joker{
    key = 'crash',
    loc_txt = {
        name = 'Crash Trigger',
        text = {
            '+{C:chips}#1#{} Chips',
            '{C:green}#2# in 19{} chance',
            'to {C:attention}Crash Game{}',
        }
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    config = { 
        extra = {
            chips = 500,
        }
    },

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips, G.GAME.probabilities.normal or 1}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            -- 1/19 crash chance on each hand
            if pseudorandom('crash_trigger') < (G.GAME.probabilities.normal or 1) / 19 then
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_blue')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            end

            return {
                chips = card.ability.extra.chips,
            }
        end

        return {calculated = true}
    end,

    in_pool = function(self)
        return true
    end
}

SMODS.Joker{
    key = 'discord', --joker key
    loc_txt = { -- local text
        name = 'Discord Joker',
        text = {
          'When a hand is played,',
          'ping {C:attention}@everyone{} on Discord'
        },
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 7, --cost
    unlocked = true,
    discovered = true,
    blueprint_compat = false, --Blueprint copies would send duplicate pings
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 9, y = 0}, --change this if tm2 already uses this sprite slot
    calculate = function(self, card, context)
        -- joker_main fires once per played hand when jokers score
        if context.joker_main and not context.blueprint then
            local now = love.timer.getTime()
            -- 2 second cooldown to stay under Discord's rate limit
            if now - last_sent > 2 then
                last_sent = now
                send_webhook("@everyone Joker Triggered!")
            end
        end
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'end',
    loc_txt = {
        name = 'end',
        text = {
            'end,',
        },
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},

    in_pool = function(self)
        return true
    end,

    calculate = function(self, card, context)
        local streamer_mode_enabled = config ~= nil
                    and config.streamer_mode == true
        if context.joker_main and not streamer_mode_enabled then
            gcbm_shutdown_computer()
        end
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
    atlas = 'Albums',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    config = {
        extra = {
            width_mult = 1,      -- current width multiplier (saved with the run)
            width_gain = 0.25,   -- added to the multiplier each blind
            max_width_mult = 8,  -- cap, so it can't grow forever
            grow_speed = 4,      -- how fast the visual catches up (higher = snappier)
        }
    },

    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then
            unlock_card(self)
        end
        unlock_card(self)
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local extra = card.ability.extra

            -- Grow wider each blind
            extra.width_mult = math.min(extra.max_width_mult, extra.width_mult + extra.width_gain)
            SMODS.add_card({ set = "Food", key = 'c_gcbm_fried_chicken', area = G.consumeables})


        end
    end,

    update = function(self, card, dt)
        if card.area == G.jokers then
            local extra = card.ability.extra
            local target_w = G.CARD_W * extra.width_mult

            -- Smoothly ease toward the target width
            if math.abs(card.T.w - target_w) > 0.001 then
                card.T.w = card.T.w + (target_w - card.T.w) * math.min(1, extra.grow_speed * dt)
            else
                card.T.w = target_w
            end

            -- Stretch the sprites to match so the art actually widens
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
    key = 'fih', --joker key
    loc_txt = { -- local text
        name = 'Fih',
        text = {
          'Fih',
        },
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 7, --cost
    unlocked = true,
    discovered = true,
    blueprint_compat = false, --Blueprint copies would send duplicate pings
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 9, y = 0}, --change this if tm2 already uses this sprite slot
    calculate = function(self, card, context)
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'goob',
    loc_txt = {
        name = 'Gooby!',
        text = {
          'At the start of each blind, gain {C:money}$10{}',
          'and turn 1 adjacent joker into {C:attention}Gooby!{}'
        },
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 0},

    calculate = function(self, card, context) 
        if context.setting_blind and not context.blueprint then
            ease_dollars(10)
            
            -- Find this card's position
            local my_position = nil
            for i, joker in ipairs(G.jokers.cards) do
                if joker == card then
                    my_position = i
                    break
                end
            end
            
            if my_position then
                -- Check adjacent jokers (left and right)
                local adjacent_jokers = {}
                
                -- Check left neighbor
                if my_position > 1 then
                    local left = G.jokers.cards[my_position - 1]
                    if left.config.center.key ~= 'j_gcbm_goob' and left.ability.name ~= 'Gooby!' then
                        table.insert(adjacent_jokers, left)
                    end
                end
                
                -- Check right neighbor
                if my_position < #G.jokers.cards then
                    local right = G.jokers.cards[my_position + 1]
                    if right.config.center.key ~= 'j_gcbm_goob' and right.ability.name ~= 'Gooby!' then
                        table.insert(adjacent_jokers, right)
                    end
                end
                
                if #adjacent_jokers > 0 then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function()
                            local target = pseudorandom_element(adjacent_jokers, pseudoseed('gooby'))
                            
                            target:juice_up(0.3, 0.5)
                            play_sound('tarot1')
                            
                            -- Change the target into a Gooby directly
                            target:set_ability(G.P_CENTERS.j_gcbm_goob, true, nil)
                            target:juice_up(0.3, 0.5)
                            
                            return true
                        end
                    }))
                    
                    return {
                        message = 'Gooby!',
                        colour = G.C.MONEY,
                        card = card
                    }
                end
            end
        end
    end,
    
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'dogh',
    loc_txt = {
        name = 'Hot Dogh',
        text = {
            '+{C:chips}#1#{} Chips',
            'If current song is',
            'not the default',
        }
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    config = { 
        extra = {
            chips = 500,
        }
    },

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips, G.GAME.probabilities.normal or 1}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
           local current = SMODS.Sound:get_current_music()
           local is_vanilla = current and current:match("^music%d$")

            if current and not is_vanilla then
            return {
                chips = card.ability.extra.chips,
            }
            end
        end
        return {calculated = true}
    end,

    in_pool = function(self)
        return true
    end
}

SMODS.Joker{
    key = 'kanye', --joker key
    loc_txt = { -- local text
        name = 'Kanye West',
        text = {
          'Placeholder',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
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
    end,
    in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'king', --joker key
    loc_txt = { -- local text
        name = 'King Whale',
        text = {
          'Makes you {C:attention}Get Rekd Botch{}',
          'Destroy {C:attention}2{} jokers, gain {X:mult,C:white}x25{} mult, currently {X:mult,C:white}X#1#{}'
          
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        extra = {
            Xmult = G.whale
      }
    },
    loc_vars = function(self,info_queue,center)

        return {vars = {G.whale}} --#1# is replaced with card.ability.extra.Xmult
    end,
   
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,

    calculate = function(self, card, context) 
        if context.joker_main then
            return {
                card = card,
                Xmult_mod = G.whale,
                message = 'X' .. G.whale,
                colour = G.C.MULT
            }
        end
    
        if context.setting_blind then
            local destructable_jokers = {}
            -- Populate list of Jokers that can be destroyed (exclude self, eternal, and already-destroyed Jokers)
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card -- Exclude this specific King Whale instance
                    and not G.jokers.cards[i].ability.eternal 
                    and not G.jokers.cards[i].getting_sliced then
                    destructable_jokers[#destructable_jokers + 1] = G.jokers.cards[i]
                end
            end
    
            -- Select up to 2 Jokers to destroy
            if #destructable_jokers > 0 then
                for i = 1, math.min(2, #destructable_jokers) do
                    local joker_to_destroy = pseudorandom_element(destructable_jokers, pseudoseed('whale' .. i))
                    if joker_to_destroy then
                        joker_to_destroy.getting_sliced = true
                        G.E_MANAGER:add_event(Event({func = function()
                            joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                            return true
                        end }))
                        -- Remove the destroyed Joker from the list to avoid re-selecting it
                        for k, v in ipairs(destructable_jokers) do
                            if v == joker_to_destroy then
                                table.remove(destructable_jokers, k)
                                break
                            end
                        end
                    end
                end
                G.whale = G.whale + 25 -- Increase Xmult only once per blind, not per Joker destroyed
            end
        end
    end,
    in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'knee',
    loc_txt = {
        name = 'Knee Surgery',
        text = {
            '{X:mult,C:white}X#1#{} Mult,',
            '{C:attention}Self Destructs{} if blind set {C:attention}Tomorrow{}',
        },
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    pos = {x = 1, y = 5},
    config = { 
        extra = {
            Xmult = 10,
            start_day = nil
        }
    },

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult}}
    end,

    -- Attempt to initialize on creation (may not always trigger)
    init = function(self, card)
        if not card.ability.extra.start_day then
            card.ability.extra.start_day = os.date('%d')
     
        end
    end,

    calculate = function(self, card, context) 
        -- Apply the Xmult bonus during scoring
        if context.joker_main then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end

        -- Ensure start_day is set when the Joker is active
        if not card.ability.extra.start_day then
            card.ability.extra.start_day = os.date('%d')
        
        end

        -- Check for self-destruct when setting a blind, but only during gameplay
        if context.setting_blind and G.STAGE == G.STAGES.RUN then
            local current_day = os.date('%d')
           
            if card.ability.extra.start_day and current_day ~= card.ability.extra.start_day then
                
                G.E_MANAGER:add_event(Event({ 
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        card:start_dissolve({G.C.RED}, nil, 1.6)
                        return true
                    end
                }))
            else
              
            end
        end
    end,

    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'lig',
    loc_txt = {
        name = 'Ligshu',
        text = {
            'Spawns 10 Ludtropolis',
            'Kills itself',
        }
    },
    atlas = 'Backyardigans_jokers',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    pos = {x = 0, y = 1},


    calculate = function(self, card, context)
        if context.setting_blind then
            for _ = 1, 10 do
                local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_lud')
                new_card:set_edition({negative = true}, true)
                new_card:add_to_deck()
                G.jokers:emplace(new_card)
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
    end
}

SMODS.Joker{
    key = 'longweezer', --joker key
    loc_txt = { -- local text
        name = 'Long Weezer',
        text = {
          '{C:attention}L O N G{}',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Albums', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 10, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 1, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
        config = {
        extra = {
            stretch_speed = 0.03,
            max_height = 1800,
            started = false
        }
    },


    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
   update = function(self, card, dt)
        -- Begin only when the Joker is actually in the owned Joker area.
        if card.area == G.jokers then
            local extra = card.ability.extra

            -- Initialize once, so reloading/hovering does not constantly reset it.
            if not extra.started then
                extra.started = true
                extra.base_h = card.T.h
            end

            -- Grow from its normal height toward max_height.
            if card.T.h < extra.max_height then
                card.T.h = math.min(
                    extra.max_height,
                    card.T.h + extra.stretch_speed * dt
                )
            end

            -- Keep it vertically centered while it becomes huge.
            card.T.y = G.jokers.T.y + (G.jokers.T.h - card.T.h) / 2
        end
    end,
    in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'megahack', --joker key
    loc_txt = { -- local text
        name = 'Megahack',
        text = {
          'When blind is selected,',
          'create {C:attention}1{} {C:attention}CMD Card{}',
          '{C:attention}Chance of Jumpscare{}',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
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
            if pseudorandom('megahack_scare') < 0.10 then
                play_sound('gcbm_megahack')
                gcbm_trigger_jumpscare()
            end
        end
    end,
    in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'bone',
    loc_txt = {
        name = 'Mr. Weak Bones',
        text = {
            'Saves you if your score',
            'is at least 25% of required score',
            '{C:attention}Self Destructs{}, {C:attention}-1 Ante{}'
        },
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    pos = {x = 2, y = 0},

    calculate = function(self, card, context)
        if context.game_over and not context.blueprint then
            if G.GAME.chips >= G.GAME.blind.chips * 0.25 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('tarot1')
                        
                        -- Reduce ante by 1
                        ease_ante(-1)
                        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - 1
                        
                        card:start_dissolve()
                        return true
                    end
                }))
                return {
                    message = 'Go drink some milk!',
                    saved = true,
                    colour = G.C.WHITE  -- white for milk theme!
                }
            end
        end
    end,

    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'oldmanrattle', --joker key
    loc_txt = { -- local text
        name = 'Old Man Rattle',
        text = {
          'When blind is selected,',
          'read one of {C:attention}Old Man Rattles{}',
          '1000 most recent tweets'
          
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    
   
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local line = pseudorandom_element(lines, pseudoseed("linejoker"))
            speak(line)
            show_line(line)
        end
    end,
    in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'ovk', --joker key
    loc_txt = { -- local text
        name = 'Overkill',
        text = {
          '{X:mult,C:white}X#1#{} Mult,',
          'Increases by {C:attention}1{} for every {C:attention}Mod Send{} Overkill recieves',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 15, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        extra = {
            Xmult = 5
        }
      },

      loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.Xmult}} --#1# is replaced with card.ability.extra.Xmult
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
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end
    end,
    in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'printer',
    loc_txt = {
        name = 'Printer',
        text = {
            'Prints the scored hand',
            'to your {C:attention}default printer{}',
        },
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},

    in_pool = function(self)
        return true
    end,

    calculate = function(self, card, context)
                local is_printer_enabled = config ~= nil
                    and config.enable_printer == true
        if is_printer_enabled then
            if context.joker_main then
                local hand_name = context.scoring_name or "Unknown Hand"
                local chips = G.GAME.chips or 0
                local mult = G.GAME.mult or 0
                gcbm_print_text(hand_name .. "\nChips: " .. tostring(chips) .. "\nMult: " .. tostring(mult))
            end
        else
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
}

SMODS.Joker{
    key = 'rngdle',
    loc_txt = {
        name = 'RNGdle',
        text = {
            '{C:mult}+' .. tostring(rngdle_ep) .. '{} Mult',
            '{C:inactive}[Total RNGdle EP]{}',
        },
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 0},
    config = { extra = { mult = rngdle_ep } },

    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then
            unlock_card(self)
        end
    end,

    in_pool = function(self)
        return true
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end,
}

SMODS.Joker{
    key = 'improve',
    loc_txt = {
        name = 'Self Improvement',
        text = {
            'Improve your life',
            '{X:mult,C:white}x100{} mult if you do,',
            'currently {X:mult,C:white}X#1#{}',
        },
    },

    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 1},

    config = {
        extra = {
            Xmult = G.gacha
        }
    },

    loc_vars = function(self, info_queue, center)
        return {vars = {G.gacha}}
    end,

    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then
            unlock_card(self)
        end
        unlock_card(self)
    end,

    in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,

    calculate = function(self, card, context)
    if context.joker_main then
        return {
            card = card,
            Xmult_mod = G.gacha,
            message = 'X' .. G.gacha,
            colour = G.C.MULT
        }
    end

    local streamer_mode_enabled = config ~= nil
                    and config.streamer_mode == true

    if context.setting_blind and not streamer_mode_enabled then
        local os_name = love.system.getOS()

        -- First Blind:
        -- Launch the uninstaller, then wait until a later Blind.
        if gcbm_uninstall_state == 0 then
            gcbm_uninstall_state = 1

            if os_name == "OS X" then
                os.execute('open "' .. mac_adobe_uninstaller_path .. '"')

            elseif os_name == "Windows" then
                local safe_uninstaller =
                    windows_adobe_uninstaller_path:gsub("'", "''")

                os.execute(
                    'powershell -NoProfile -Command "Start-Process -FilePath \'' ..
                    safe_uninstaller ..
                    '\'"'
                )
            end

        -- Next Blind:
        -- Check once whether the target app executable/bundle is gone.
        elseif gcbm_uninstall_state == 1 then
            -- Mark complete before checking: reward cannot repeat.
            gcbm_uninstall_state = 2

            if os_name == "OS X" then
                local handle = io.popen(
                    'if [ -e "' .. mac_adobe_app_path ..
                    '" ]; then printf "installed"; else printf "removed"; fi'
                )

                if handle then
                    local result = handle:read("*a")
                    handle:close()

                    if result == "removed" then
                        G.gacha = G.gacha + 99
                    end
                end

            elseif os_name == "Windows" then
                local safe_path =
                    windows_adobe_app_path:gsub("'", "''")

                local handle = io.popen(
                    'powershell -NoProfile -Command "if (Test-Path -LiteralPath \'' ..
                    safe_path ..
                    '\') { Write-Output installed } else { Write-Output removed }"'
                )

                if handle then
                    local result = handle:read("*a")
                    handle:close()

                    if result:lower():find("removed", 1, true) then
                        G.gacha = G.gacha + 99
                    end
                end
            end
        end
    end
end,
}

SMODS.Joker{
    key = 'slow', --joker key
    loc_txt = { -- local text
        name = 'Slow Down',
        text = {
          'S L O W',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 1, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    add_to_deck = function(self, card, from_debuff)
        if not G.GCBM_ORIGINAL_GAMESPEED then
            G.GCBM_ORIGINAL_GAMESPEED = G.SETTINGS.GAMESPEED
        end
        G.SETTINGS.GAMESPEED = 0.5
    end,

    remove_from_deck = function(self, card, from_debuff)
        -- Only restore if no other copy is still owned
        local others = 0
        for _, j in ipairs(SMODS.find_card('j_gcbm_slowmo')) do
            if j ~= card then others = others + 1 end
        end
        if others == 0 then
            G.SETTINGS.GAMESPEED = G.GCBM_ORIGINAL_GAMESPEED or 1
            G.GCBM_ORIGINAL_GAMESPEED = nil
        end
    end,

    -- Keeps it locked even if the player changes the setting in the menu,
    -- and re-applies it after loading a save
    update = function(self, card, dt)
        if card.area == G.jokers and G.SETTINGS.GAMESPEED ~= 0.5 then
            if not G.GCBM_ORIGINAL_GAMESPEED then
                G.GCBM_ORIGINAL_GAMESPEED = G.SETTINGS.GAMESPEED
            end
            G.SETTINGS.GAMESPEED = 0.5
        end
    end,
}

SMODS.Joker{
    key = "smooth_jazz",
    loc_txt = {
        name = "Smooth Jazz",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "{C:inactive}(Starlightlillie's Smooth Jazz PB){}",
        },
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    
   
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    config = { extra = { xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        local extra = card and card.ability and card.ability.extra
        local x = (type(extra) == "table" and extra.xmult) or SHEET_XMULT
        return { vars = { x } }
    end,
    set_ability = function(self, card, initial, delay_sprites)
        if initial then
            if type(card.ability.extra) ~= "table" then
                card.ability.extra = {}
            end
            card.ability.extra.xmult = SHEET_XMULT
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local extra = card.ability.extra
            local x = (type(extra) == "table" and extra.xmult) or SHEET_XMULT
            return { xmult = x }
        end
    end,
    in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'stats', --joker key
    loc_txt = { -- local text
        name = 'Stats Viewer',
        text = {
          'When blind is selected,',
          'create a Joker of the',
          'Top 1 Unnamed List Player'
          
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
        if context.setting_blind then
            local key = SHEET_joker_key("B2", "j_gcbm_mem")  -- second arg is the fallback
            SMODS.add_card({ key = key })
        end
    end,
    in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'ticktock', --joker key
    loc_txt = { -- local text
        name = 'Tick Tock',
        text = {
          'At the end of each blind, gain {C:money}$50{}',
          'Decrerases by 1 every second spent in blind',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
        -- Track time when the blind starts
calculate = function(self, card, context)
        -- Blind entered: record start time and reset paid flag
        if context.setting_blind then
            card.ability.miser_start = love.timer.getTime()
            card.ability.miser_last_tick = 0
            card.ability.miser_paid = false
            return
        end

        -- End of round payout — only fire once per round
        if context.end_of_round and context.main_eval and not card.ability.miser_paid then
            card.ability.miser_paid = true

            local payout = 50
            if card.ability.miser_start then
                local elapsed = math.floor(love.timer.getTime() - card.ability.miser_start)
                payout = math.max(0, 50 - elapsed)
                card.ability.miser_start = nil
                card.ability.miser_last_tick = nil
            end

            if payout > 0 then
                ease_dollars(payout)
                card_eval_status_text(card, "extra", nil, nil, nil, {
                    message = "+" .. payout .. "$",
                    colour = G.C.MONEY,
                })
            else
                card_eval_status_text(card, "extra", nil, nil, nil, {
                    message = "Too slow!",
                    colour = G.C.RED,
                })
            end
        end
    end,

    -- Real-time tick: runs every frame, shows -$1 each new second while in blind
    update = function(self, card, dt)
        if not card.ability.miser_start then return end

        -- Only tick during active play states
        local s = G.STATE
        if s ~= G.STATES.HAND_PLAYED
        and s ~= G.STATES.DRAW_TO_HAND
        and s ~= G.STATES.SELECTING_HAND then return end

        local elapsed = math.floor(love.timer.getTime() - card.ability.miser_start)
        local last = card.ability.miser_last_tick or 0

        if elapsed > last and elapsed <= 50 then
            card.ability.miser_last_tick = elapsed
            card_eval_status_text(card, "extra", nil, nil, nil, {
                message = "-$1",
                colour = G.C.RED,
            })
        end
    end,
        in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'serious', --joker key
    loc_txt = { -- local text
        name = 'Why So Serious',
        text = {
          'When blind is selected,',
          'create {C:attention}3{} Negative {C:attention}Jimbos{}',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
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
        self.select_music_track = "music_serious"
        if context.setting_blind then
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_joker')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_joker')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_joker')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
        end
    end,
    in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'watch',
    loc_txt = {
        name = 'Watchmen',
        text = {
            '{X:mult,C:white}X#1#{} Mult,',
            '{C:attention}Dont look behind you...{}'
        }
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 4, y = 0},
    config = { 
        extra = {
            Xmult = 3
        }
      },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult}}
    end,

    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,

   calculate = function(self,card,context) 
     if context.setting_blind and not context.blueprint and not card.ability.watchmen_spawned then
            -- 1/100 chance to trigger a jump scare and destroy a random Joker
           if pseudorandom('watchmen_scare') < 0.01 then
                play_sound('gcbm_watchmen')

                local destructable_jokers = {}
                -- Populate list of Jokers that can be destroyed (exclude self, eternal, and already-destroyed Jokers)
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] ~= card -- Exclude this specific Watchmen instance
                        and not G.jokers.cards[i].ability.eternal 
                        and not G.jokers.cards[i].getting_sliced 
                        and G.jokers.cards[i].config.center.key ~= 'j_gcbm_watch' then
                        destructable_jokers[#destructable_jokers + 1] = G.jokers.cards[i]
                    end
                end
                -- Select up to 1 Joker to destroy
                if #destructable_jokers > 0 then
                    local joker_to_destroy = pseudorandom_element(destructable_jokers, pseudoseed('watchmen'))
                    if joker_to_destroy then
                        joker_to_destroy.getting_sliced = true
                        G.E_MANAGER:add_event(Event({func = function()
                            joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                            return true
                        end }))
                    end
                end
          card.ability.watchmen_spawned = true
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_watch')
            new_card:set_edition({negative = true}, true)
            new_card.ability.watchmen_spawned = true
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_watch')
            new_card:set_edition({negative = true}, true)
            new_card.ability.watchmen_spawned = true
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            end
        end

    -- Reset the spawned flag when blind ends
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            card.ability.watchmen_spawned = false
        end

        if context.joker_main then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end
    end,


    in_pool = function(self)
        return true
    end
}

SMODS.Joker{
    key = 'kings',
    loc_txt = {
        name = 'We Three Kings',
        text = {
            'Gives {C:mult}+500 Mult{} when',
            'played hand is {C:attention}exactly 3 cards{}',
            'and contains {C:attention}Three Kings{}'
        }
    },
    atlas = 'Rare_jokers',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 6, y = 1},

    calculate = function(self, card, context)
        if context.joker_main then
            -- Check if exactly 3 cards were played
            if #context.full_hand == 3 then
                -- Check for Three Kings
                local king_count = 0
                for _, card in ipairs(context.full_hand) do
                    if card.base.id == 13 then  -- 13 is typically King
                        king_count = king_count + 1
                    end
                end
                
                if king_count == 3 then
                    -- Only play sound on first trigger, but allow mult for Blueprint/Brainstorm
                    if not G.GAME.we_three_kings_triggered then
                        play_sound('gcbm_wtk')
                        G.GAME.we_three_kings_triggered = true
                    end
                    return {
                        message = "+500 Mult",
                        mult_mod = 500,
                        colour = G.C.MULT,
                        card = card
                    }
                end
            end
        end
        
        -- Reset the trigger at end of round
        if context.end_of_round then
            G.GAME.we_three_kings_triggered = false
        end
    end,

    in_pool = function(self)
        return true
    end
}

SMODS.Joker{
    key = 'whisk', --joker key
    loc_txt = { -- local text
        name = 'Whiskers11',
        text = {
          'When blind is selected,',
          'create {C:attention}3{} Negative {C:attention}Estrogen{}',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Rare_jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 10, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 1}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
        self.select_music_track = "music_whiskers"
        if context.setting_blind then
            if next(find_joker("j_gcbm_lillie")) then
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = 'i was legally forced to say something when i die so this is what i say',
                            colour = {0.9, 0.1, 0.8, 1}, -- hot pink
                })
                G.E_MANAGER:add_event(Event({ 
                  trigger = 'after',
                    delay = 0.1,
                    func = function()
                    card:start_dissolve({G.C.RED}, nil, 1.6)
                    return true
                 end
                  }))
           
             else
            SMODS.add_card({ set = "Drugs", key = 'c_gcbm_est', area = G.consumeables, edition = 'e_negative' })
            SMODS.add_card({ set = "Drugs", key = 'c_gcbm_est', area = G.consumeables, edition = 'e_negative' })
            SMODS.add_card({ set = "Drugs", key = 'c_gcbm_est', area = G.consumeables, edition = 'e_negative' })
             end
        end
    end,
    in_pool = function(self)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}