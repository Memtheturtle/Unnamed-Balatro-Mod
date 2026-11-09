--- STEAMODDED HEADER
--- MOD_NAME: Unnamed Balatro Mod
--- MOD_ID: UNBM
--- MOD_AUTHOR: [The Great Backyard]
--- MOD_DESCRIPTION: A massive grab bag of random ideas we've had over the past year or so.
--- PREFIX: gcbm
----------------------------------------------
------------MOD CODE -------------------------

local mod = SMODS.current_mod
---@cast mod -nil
G.gorb_count = 0
G.whale = 1
G.gacha = 1

local function load(path)
    local chunk = love.filesystem.load(path)
    chunk()
end

-- Put this above your config tab (same file where mod is defined)
local status = { text = "" }

local function is_webhook(url)
    return url:match("^https://discord%.com/api/webhooks/")
        or url:match("^https://discordapp%.com/api/webhooks/")
end

local function refresh_status()
    local url = mod.config.discord_webhook or ""
    if url == "" then
        status.text = "No webhook set"
    else
        status.text = "Webhook set (ends ..." .. url:sub(-6) .. ")"
    end
end
refresh_status()

G.FUNCS.discord_paste_webhook = function(e)
    local clip = (love.system.getClipboardText() or ""):match("^%s*(.-)%s*$")
    if is_webhook(clip) then
        mod.config.discord_webhook = clip
        SMODS.save_mod_config(mod)
        refresh_status()
    else
        status.text = "Clipboard isn't a Discord webhook URL"
    end
end

G.FUNCS.discord_clear_webhook = function(e)
    mod.config.discord_webhook = ""
    SMODS.save_mod_config(mod)
    refresh_status()
end

SMODS.current_mod.config_tab = function()
    return {n = G.UIT.ROOT, config = { emboss = 0.05, minh = 6, r = 0.1, minw = 6 }, nodes = {
        {
            n = G.UIT.R, config = { align = "cm", padding = 0.05 }, nodes = {
                create_toggle({
                    label = "Streamer Mode",
                    ref_table = mod.config,
                    ref_value = "streamer_mode",
                }),
                create_toggle({
                    label = "Enable Printer",
                    ref_table = mod.config,
                    ref_value = "enable_printer",
                }),
            }
        },
        {
            n = G.UIT.R, config = { align = "cm", padding = 0.1 }, nodes = {
                { n = G.UIT.T, config = { text = "AREDL Username", scale = 0.4, colour = G.C.UI.TEXT_LIGHT } },
            }
        },
        {
            n = G.UIT.R, config = { align = "cm", padding = 0.1 }, nodes = {
                create_text_input({
                    w = 5,
                    max_length = 32,
                    prompt_text = "Enter username",
                    ref_table = mod.config,
                    ref_value = "aredl_username",
                    extended_corpus = true,
                    callback = function()
                        SMODS.save_mod_config(mod)
                        if AREDL_refresh_points then AREDL_refresh_points() end
                    end,
                }),
            }
        },
        {
            n = G.UIT.R, config = { align = "cm", padding = 0.05 }, nodes = {
                { n = G.UIT.T, config = { text = "Press Enter to confirm", scale = 0.3, colour = G.C.UI.TEXT_LIGHT } },
            }
        },
        {
            n = G.UIT.R, config = { align = "cm", padding = 0.1 }, nodes = {
                { n = G.UIT.T, config = { ref_table = status, ref_value = "text", scale = 0.35, colour = G.C.UI.TEXT_LIGHT } },
            }
        },
        {
            n = G.UIT.R, config = { align = "cm", padding = 0.1 }, nodes = {
                UIBox_button({ label = { "Paste from clipboard" }, button = "discord_paste_webhook", minw = 4, scale = 0.4, colour = G.C.BLUE }),
            }
        },
        {
            n = G.UIT.R, config = { align = "cm", padding = 0.1 }, nodes = {
                UIBox_button({ label = { "Clear" }, button = "discord_clear_webhook", minw = 2, scale = 0.4, colour = G.C.RED }),
            }
        },
        {
            n = G.UIT.R, config = { align = "cm", padding = 0.05 }, nodes = {
                { n = G.UIT.T, config = { text = "Copy the URL in Discord, then click Paste", scale = 0.3, colour = G.C.UI.TEXT_LIGHT } },
            }
        },
    }}
end

local has_albums_mod = love.filesystem.getInfo("mods/Albums", "directory") ~= nil

load("mods/Unnamed-Balatro-Mod/Cache/net.lua")
load("mods/Unnamed-Balatro-Mod/fight.lua")
load("mods/Unnamed-Balatro-Mod/Other/decks.lua")
load("mods/Unnamed-Balatro-Mod/Other/booster.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/minesweeper.lua")
if not has_albums_mod then
    load("mods/Unnamed-Balatro-Mod/Consumables/albums.lua")
end
load("mods/Unnamed-Balatro-Mod/Consumables/drugs.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/food.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/cmd.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/tarots.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/roles.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/muscore.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/levels.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/list_levels.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/later_levels.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/common_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/delete.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/uncommon_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/rare_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/legendary_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/player_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/aredl_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/backyardigans_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/bunny_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/cat_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/uh_oh_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/unhinged_jokers.lua")


----------------------------------------------
------------MOD CODE END----------------------