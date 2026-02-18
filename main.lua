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

load("mods/Unnamed-Balatro-Mod/Consumables/minesweeper.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/albums.lua")
load("mods/Unnamed-Balatro-Mod/Consumables/drugs.lua")
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