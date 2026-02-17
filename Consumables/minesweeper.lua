----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Minesweepers', --atlas key
    path = 'Minesweepers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.ConsumableType{
    key = 'minesweep', --consumable type key

    collection_rows = {5,6}, --amount of cards in one page
    primary_colour = G.C.BLUE, --first color
    secondary_colour = G.C.RED, --second color
    loc_txt = {
        collection = 'Minesweeper', --name displayed in collection
        name = 'Minesweeper', --name displayed in badge
        undiscovered = {
            name = 'Hidden Mines', --undiscovered name
            text = {'Boom'} --undiscovered text
        }
    },
    shop_rate = 0, --rate in shop out of 100
}

SMODS.UndiscoveredSprite{
    key = 'minesweep', --must be the same key as the consumabletype
    atlas = 'Minesweepers',
    pos = {x = 0, y = 2}
}

SMODS.Consumable{
    key = 'one',
    set = 'minesweep',
    atlas = 'Minesweepers',
    pos = {x = 0, y = 0},
    loc_txt = {
        name = '1',
        text = {
            'Gives $20, {C:green}#1# in 8{} chance to give a Mine'
        }
    },
      
    config = {
        extra = {
            cards = 4,
        }
    },
    
 loc_vars = function(self,info_queue,center)
        return {vars = {G.GAME.probabilities.normal}} 
    end,
    
   

 can_use = function(self,card)
                return true
    end,
    
 auto_use = function(self, card, area, copier)
        return true
    end,

    use = function(self, card, area, copier)
        ease_dollars(20)
        if pseudorandom('onemine') < G.GAME.probabilities.normal / 8 then
            SMODS.add_card({ set = "minesweep", key = 'c_gcbm_mine', area = G.consumeables})
        end
    end,
}

SMODS.Consumable{
    key = 'two',
    set = 'minesweep',
    atlas = 'Minesweepers',
    pos = {x = 1, y = 0},
    loc_txt = {
        name = '2',
        text = {
            'Gives $40, {C:green}#1# in 8{} chance to give a Mine'
        }
    },
      
    config = {
        extra = {
            cards = 4,
        }
    },
    
 loc_vars = function(self,info_queue,center)
        return {vars = {2 * G.GAME.probabilities.normal}} 
    end,
    
   

 can_use = function(self,card)
                return true
    end,
    
 auto_use = function(self, card, area, copier)
        return true
    end,

    use = function(self, card, area, copier)
        ease_dollars(40)
        if pseudorandom('onemine') < (2 * G.GAME.probabilities.normal) / 8 then
            SMODS.add_card({ set = "minesweep", key = 'c_gcbm_mine', area = G.consumeables})
        end
    end,
}

SMODS.Consumable{
    key = 'three',
    set = 'minesweep',
    atlas = 'Minesweepers',
    pos = {x = 2, y = 0},
    loc_txt = {
        name = '3',
        text = {
            'Gives $60, {C:green}#1# in 8{} chance to give a Mine'
        }
    },
      
    config = {
        extra = {
            cards = 4,
        }
    },
    
 loc_vars = function(self,info_queue,center)
        return {vars = {3 * G.GAME.probabilities.normal}} 
    end,
    
   

 can_use = function(self,card)
                return true
    end,
    
 auto_use = function(self, card, area, copier)
        return true
    end,

    use = function(self, card, area, copier)
        ease_dollars(60)
        if pseudorandom('onemine') < (3 * G.GAME.probabilities.normal) / 8 then
            SMODS.add_card({ set = "minesweep", key = 'c_gcbm_mine', area = G.consumeables})
        end
    end,
}

SMODS.Consumable{
    key = 'four',
    set = 'minesweep',
    atlas = 'Minesweepers',
    pos = {x = 3, y = 0},
    loc_txt = {
        name = '4',
        text = {
            'Gives $80, {C:green}#1# in 8{} chance to give a Mine'
        }
    },
      
    config = {
        extra = {
            cards = 4,
        }
    },
    
 loc_vars = function(self,info_queue,center)
        return {vars = {4 * G.GAME.probabilities.normal}} 
    end,
    
   

 can_use = function(self,card)
                return true
    end,
    
 auto_use = function(self, card, area, copier)
        return true
    end,

    use = function(self, card, area, copier)
        ease_dollars(80)
        if pseudorandom('onemine') < (4 * G.GAME.probabilities.normal) / 8 then
            SMODS.add_card({ set = "minesweep", key = 'c_gcbm_mine', area = G.consumeables})
        end
    end,
}

SMODS.Consumable{
    key = 'five',
    set = 'minesweep',
    atlas = 'Minesweepers',
    pos = {x = 4, y = 0},
    loc_txt = {
        name = '5',
        text = {
            'Gives $100, {C:green}#1# in 8{} chance to give a Mine'
        }
    },
      
    config = {
        extra = {
            cards = 4,
        }
    },
    
 loc_vars = function(self,info_queue,center)
        return {vars = {5 * G.GAME.probabilities.normal}} 
    end,
    
   

 can_use = function(self,card)
                return true
    end,
    
 auto_use = function(self, card, area, copier)
        return true
    end,

    use = function(self, card, area, copier)
        ease_dollars(100)
        if pseudorandom('onemine') < (5 * G.GAME.probabilities.normal) / 8 then
            SMODS.add_card({ set = "minesweep", key = 'c_gcbm_mine', area = G.consumeables})
        end
    end,
}

SMODS.Consumable{
    key = 'six',
    set = 'minesweep',
    atlas = 'Minesweepers',
    pos = {x = 0, y = 1},
    loc_txt = {
        name = '6',
        text = {
            'Gives $120, {C:green}#1# in 8{} chance to give a Mine'
        }
    },
      
    config = {
        extra = {
            cards = 4,
        }
    },
    
 loc_vars = function(self,info_queue,center)
        return {vars = {6 * G.GAME.probabilities.normal}} 
    end,
    
   

 can_use = function(self,card)
                return true
    end,
    
 auto_use = function(self, card, area, copier)
        return true
    end,

    use = function(self, card, area, copier)
        ease_dollars(120)
        if pseudorandom('onemine') < (6 * G.GAME.probabilities.normal) / 8 then
            SMODS.add_card({ set = "minesweep", key = 'c_gcbm_mine', area = G.consumeables})
        end
    end,
}

SMODS.Consumable{
    key = 'seven',
    set = 'minesweep',
    atlas = 'Minesweepers',
    pos = {x = 1, y = 1},
    loc_txt = {
        name = '7',
        text = {
            'Gives $140, {C:green}#1# in 8{} chance to give a Mine'
        }
    },
      
    config = {
        extra = {
            cards = 4,
        }
    },
    
 loc_vars = function(self,info_queue,center)
        return {vars = {7 * G.GAME.probabilities.normal}} 
    end,
    
   

 can_use = function(self,card)
                return true
    end,
    
 auto_use = function(self, card, area, copier)
        return true
    end,

    use = function(self, card, area, copier)
        ease_dollars(140)
        if pseudorandom('onemine') < (7 * G.GAME.probabilities.normal) / 8 then
            SMODS.add_card({ set = "minesweep", key = 'c_gcbm_mine', area = G.consumeables})
        end
    end,
}

SMODS.Consumable{
    key = 'eight',
    set = 'minesweep',
    atlas = 'Minesweepers',
    pos = {x = 2, y = 1},
    loc_txt = {
        name = '8',
        text = {
            'Gives $160, {C:green}#1# in 8{} chance to give a Mine'
        }
    },
      
    config = {
        extra = {
            cards = 4,
        }
    },
    
 loc_vars = function(self,info_queue,center)
        return {vars = {8 * G.GAME.probabilities.normal}} 
    end,
    
   

 can_use = function(self,card)
                return true
    end,
    
 auto_use = function(self, card, area, copier)
        return true
    end,

    use = function(self, card, area, copier)
        ease_dollars(160)
        if pseudorandom('onemine') < (8 * G.GAME.probabilities.normal) / 8 then
            SMODS.add_card({ set = "minesweep", key = 'c_gcbm_mine', area = G.consumeables})
        end
    end,
}

SMODS.Consumable{
    key = 'flag',
    set = 'minesweep',
    atlas = 'Minesweepers',
    pos = {x = 3, y = 1},  -- Changed position so it's different from mine
    loc_txt = {
        name = 'Flag',
        text = {
            'Saves you from 1 Mine',
            'Self-destructs afterwards'
        }
    },
      
    config = {
        extra = {
            cards = 4,
        }
    },
    
    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.probabilities.normal}} 
    end,
    
    can_use = function(self, card)
        return false  -- Can't manually use flags
    end,

    use = function(self, card, area, copier)
        -- Flag doesn't do anything when used directly
    end,
}

SMODS.Consumable{
    key = 'mine',
    set = 'minesweep',
    atlas = 'Minesweepers',
    pos = {x = 4, y = 1},
    loc_txt = {
        name = 'Mine',
        text = {
            'Removes half of your Jokers',
            'and half of your Consumables'
        }
    },
      
    config = {
        extra = {
            cards = 4,
        }
    },
    
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.cards}}
    end,
    
    can_use = function(self, card)
        return true
    end,

    add_to_deck = function(self, card, from_debuff)
        -- Auto-trigger when added to deck
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                -- Check if player has a flag
                local has_flag = false
                local flag_card = nil
                
                for i, c in ipairs(G.consumeables.cards) do
                    if c.config.center.key == 'c_gcbm_flag' then  -- Full key with prefix
                        has_flag = true
                        flag_card = c
                        break
                    end
                end
                
                if has_flag and flag_card then
                    -- Flag blocks the mine - both dissolve
                    flag_card:start_dissolve()
                    table.remove(G.consumeables.cards, i)
                    card:start_dissolve()
                else
                    -- No flag - mine activates normally
                    card:use_consumeable()
                    card:start_dissolve()
                end
                return true
            end
        }))
    end,

    use = function(self, card, area, copier)
        -- Remove half of jokers
        local jokers_to_remove = math.floor(#G.jokers.cards / 2)
        for i = 1, jokers_to_remove do
            if G.jokers.cards[1] then
                local destroyed_card = G.jokers.cards[1]
                destroyed_card:start_dissolve()
                table.remove(G.jokers.cards, 1)
            end
        end
        
        -- Remove half of consumables
        local consumables_to_remove = math.floor(#G.consumeables.cards / 2)
        for i = 1, consumables_to_remove do
            if G.consumeables.cards[1] then
                local destroyed_card = G.consumeables.cards[1]
                destroyed_card:start_dissolve()
                table.remove(G.consumeables.cards, 1)
            end
        end
    end,
}
----------------------------------------------
------------MOD CODE END----------------------
    
