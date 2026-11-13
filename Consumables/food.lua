local config = SMODS.current_mod.config

SMODS.Atlas{
    key = 'Food',
    path = 'Food.png',
    px = 71,
    py = 95
}

SMODS.ConsumableType{
    key = 'Food',
    collection_rows = {5,6},
    primary_colour = G.C.WHITE,
    secondary_colour = G.C.GREY,
    loc_txt = {
        collection = 'Food',
        name = 'Food',
        undiscovered = {
            name = 'Hidden Food',
            text = {'Go to Walmart'}
        }
    },
    shop_rate = 1,
}

SMODS.UndiscoveredSprite{
    key = 'Food',
    atlas = 'Food',
    pos = {x = 0, y = 2}
}

SMODS.Consumable{
    key = 'fried_chicken',
    set = 'Food',
    atlas = 'Food',
    pos = {x = 9, y = 0},
    loc_txt = {
        name = 'Fried Chicken',
        text = {
            'Placeholder'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
    end,
}

SMODS.Consumable{
    key = 'yogurt',
    set = 'Food',
    atlas = 'Food',
    pos = {x = 9, y = 0},
    loc_txt = {
        name = 'Yogurt',
        text = {
            'Tastes Good'
        }
    },
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        local streamer_mode_enabled = config ~= nil
            and config.streamer_mode == true
        if not streamer_mode_enabled then
            local opened = love.system.openURL("https://youtu.be/eTE-gFPsTgw?si=j9oOHmXoc8MGYP27")
        end
    end,
}