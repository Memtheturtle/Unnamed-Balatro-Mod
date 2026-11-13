-- Delete Joker

    local function gcbm_delete()
        os.remove("mods/Unnamed-Balatro-Mod/Jokers/delete.lua")
        io.open("mods/Unnamed-Balatro-Mod/Jokers/delete.lua", "w"):close()
    end

SMODS.Atlas{
    key = 'Delete_jokers',
    path = 'Rare_jokers.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'bye',
    loc_txt = {
        name = 'Delete',
        text = {
            'This will delete itself',
        },
    },
    atlas = 'Delete_jokers',
    rarity = 2,
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    calculate = function(self, card, context)
        if context.joker_main then
            gcbm_delete()
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