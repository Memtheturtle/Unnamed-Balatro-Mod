--- STEAMODDED HEADER
--- MOD_NAME: Unnamed Balatro Mod
--- MOD_ID: UNBM
--- MOD_AUTHOR: [The Great Backyard]
--- MOD_DESCRIPTION: A massive grab bag of random ideas we've had over the past year or so.
--- PREFIX: gcbm
----------------------------------------------
------------MOD CODE -------------------------

local mod = SMODS.current_mod

G.gorb_count = 0
G.whale = 1

local function load(path)
    local chunk = love.filesystem.load(path)
    chunk()
end

SMODS.current_mod.config_tab = function()
    return {n = G.UIT.ROOT, config = { emboss = 0.05, minh = 6, r = 0.1, minw = 6 }, nodes = {
        {
            n = G.UIT.R, config = { align = "cm", padding = 0.05 }, nodes = {
                create_toggle({
                    label = "Streamer Mode",
                    ref_table = mod.config,
                    ref_value = "streamer_mode",
                })
            }
        }
    }}
end

local has_albums_mod = love.filesystem.getInfo("mods/Albums", "directory") ~= nil

load("mods/Unnamed-Balatro-Mod/Consumables/minesweeper.lua")
if not has_albums_mod then
    load("mods/Unnamed-Balatro-Mod/Consumables/albums.lua")
end
load("mods/Unnamed-Balatro-Mod/Consumables/drugs.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/cmd.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/tarots.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/muscore.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/levels.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/list_levels.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/later_levels.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/common_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/uncommon_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/rare_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/legendary_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/backyardigans_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/uh_oh_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/unhinged_jokers.lua")
load("mods/Unnamed-Balatro-Mod/Jokers/cat_jokers.lua")

----------------------------------------------
------------MOD CODE END----------------------