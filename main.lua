--- STEAMODDED HEADER
--- MOD_NAME: Unnamed Balatro Mod
--- MOD_ID: UNBM
--- MOD_AUTHOR: [Code: Memtheturtle Art: SingularityXVI and Theskycrusher6 Ideas: Mem, Single, Sky, Stayreal, and Whiskers11]
--- MOD_DESCRIPTION: A massive grab bag of random ideas we've had over the past year or so.
--- PREFIX: gcbm
----------------------------------------------
------------MOD CODE -------------------------

G.gorb_count = 0
G.whale = 1

local function load(path)
    local chunk = love.filesystem.load(path)
    chunk()
end

load("mods/Unnamed-Balatro Mod-0.1.0.7/Consumables/minesweeper.lua")
load("mods/Unnamed-Balatro Mod-0.1.0.7/Consumables/albums.lua")
load("mods/Unnamed-Balatro Mod-0.1.0.7/Consumables/drugs.lua")
load("mods/Unnamed-Balatro Mod-0.1.0.7/Consumables/tarots.lua")
load("mods/Unnamed-Balatro Mod-0.1.0.7/Consumables/muscore.lua")
load("mods/Unnamed-Balatro Mod-0.1.0.7/Consumables/levels.lua")
load("mods/Unnamed-Balatro Mod-0.1.0.7/Consumables/list_levels.lua")
load("mods/Unnamed-Balatro Mod-0.1.0.7/Consumables/later_levels.lua")
load("mods/Unnamed-Balatro Mod-0.1.0.7/Jokers/common_jokers.lua")
load("mods/Unnamed-Balatro Mod-0.1.0.7/Jokers/uncommon_jokers.lua")
load("mods/Unnamed-Balatro Mod-0.1.0.7/Jokers/rare_jokers.lua")
load("mods/Unnamed-Balatro Mod-0.1.0.7/Jokers/legendary_jokers.lua")
load("mods/Unnamed-Balatro Mod-0.1.0.7/Jokers/backyardigans_jokers.lua")
load("mods/Unnamed-Balatro Mod-0.1.0.7/Jokers/uh_oh_jokers.lua")
load("mods/Unnamed-Balatro Mod-0.1.0.7/Jokers/unhinged_jokers.lua")
load("mods/Unnamed-Balatro Mod-0.1.0.7/Jokers/cat_jokers.lua")

----------------------------------------------
------------MOD CODE END----------------------