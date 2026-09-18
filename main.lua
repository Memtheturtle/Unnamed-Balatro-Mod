--- STEAMODDED HEADER
--- MOD_NAME: Albums
--- MOD_ID: Albums
--- MOD_AUTHOR: [The Great Backyard]
--- MOD_DESCRIPTION: A massive mod adding roughly 200 albums to the game, with a new collection and a new consumable type.
--- PREFIX: albums
----------------------------------------------
------------MOD CODE -------------------------

local mod = SMODS.current_mod

local function load(path)
    local chunk = love.filesystem.load(path)
    chunk()
end

load("mods/Albums/Consumables/albums.lua")

----------------------------------------------
------------MOD CODE END----------------------