SMODS.Atlas{
    key = 'Minesweepers',
    path = 'Minesweepers.png',
    px = 71,
    py = 95
}

SMODS.ConsumableType{
    key = 'minesweep',
    collection_rows = {5,6},
    primary_colour = G.C.WHITE,
    secondary_colour = G.C.GREY,
    loc_txt = {
        collection = 'Minesweeper',
        name = 'Minesweeper',
        undiscovered = {
            name = 'Hidden Mines',
            text = {'Boom'}
        }
    },
    shop_rate = 0,
}

SMODS.UndiscoveredSprite{
    key = 'minesweep',
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
            'Gives $20, {C:green}#1# in 8{} chance to give a Mine',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
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
            'Gives $40, {C:green}#1# in 8{} chance to give a Mine',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
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
        ease_dollars(40)
        if pseudorandom('twomine') < (2 * G.GAME.probabilities.normal) / 8 then
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
            'Gives $60, {C:green}#1# in 8{} chance to give a Mine',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
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
        ease_dollars(60)
        if pseudorandom('threemine') < (3 * G.GAME.probabilities.normal) / 8 then
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
            'Gives $80, {C:green}#1# in 8{} chance to give a Mine',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
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
        ease_dollars(80)
        if pseudorandom('fourmine') < (4 * G.GAME.probabilities.normal) / 8 then
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
            'Gives $100, {C:green}#1# in 8{} chance to give a Mine',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
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
        ease_dollars(100)
        if pseudorandom('fivemine') < (5 * G.GAME.probabilities.normal) / 8 then
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
            'Gives $120, {C:green}#1# in 8{} chance to give a Mine',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
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
        ease_dollars(120)
        if pseudorandom('sixmine') < (6 * G.GAME.probabilities.normal) / 8 then
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
            'Gives $140, {C:green}#1# in 8{} chance to give a Mine',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
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
        ease_dollars(140)
        if pseudorandom('sevenmine') < (7 * G.GAME.probabilities.normal) / 8 then
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
            'Gives $160, {C:green}#1# in 8{} chance to give a Mine',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
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
        ease_dollars(160)
        if pseudorandom('eightmine') < (8 * G.GAME.probabilities.normal) / 8 then
            SMODS.add_card({ set = "minesweep", key = 'c_gcbm_mine', area = G.consumeables})
        end
    end,
}

SMODS.Consumable{
    key = 'flag',
    set = 'minesweep',
    atlas = 'Minesweepers',
    pos = {x = 3, y = 1},
    loc_txt = {
        name = 'Flag',
        text = {
            'Saves you from 1 Mine',
            'Self-destructs afterwards',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
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
        return false 
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
            'and half of your Consumables',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
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
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local has_flag = false
                local flag_card = nil
                local flag_index = nil

                for i, c in ipairs(G.consumeables.cards) do
                    if c.config.center.key == 'c_gcbm_flag' then
                        has_flag = true
                        flag_card = c
                        flag_index = i
                    break
                    end
                end

                if has_flag and flag_card and flag_index then
                    flag_card:start_dissolve()
                    table.remove(G.consumeables.cards, flag_index)
                    card:start_dissolve()
                else
                    card:use_consumeable()
                    card:start_dissolve()
                end
                return true
            end
        }))
    end,

    use = function(self, card, area, copier)
        local jokers_to_remove = math.floor(#G.jokers.cards / 2)
        for i = 1, jokers_to_remove do
            if G.jokers.cards[1] then
                local destroyed_card = G.jokers.cards[1]
                destroyed_card:start_dissolve()
                table.remove(G.jokers.cards, 1)
            end
        end

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