SMODS.Atlas{
    key = 'Delete_jokers', --atlas key
    path = 'Rare_jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

local function gcbm_delete()
        os.remove("mods/Unnamed-Balatro-Mod/Jokers/delete.lua")
        io.open("mods/Unnamed-Balatro-Mod/Jokers/delete.lua", "w"):close()
end

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
    cost = 10,
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
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}