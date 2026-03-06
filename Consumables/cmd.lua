SMODS.Atlas{
    key = 'CMD', --atlas key
    path = 'CMD.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

local use_ref = Card.use_consumeable
function Card:use_consumeable(area, copier)
    local center = self.config and self.config.center
    if center then
        G.GAME.prev_used_consumable = G.GAME.last_used_consumable
        G.GAME.last_used_consumable = center
    end
    return use_ref(self, area, copier)
end


SMODS.ConsumableType{
    key = 'CMD', --consumable type key

    collection_rows = {4,5}, --amount of cards in one page
    primary_colour = G.C.GREY, --first color
    secondary_colour = G.C.BLACK, --second color
    loc_txt = {
        collection = 'CMD', --name displayed in collection
        name = 'CMD', --name displayed in badge
        undiscovered = {
            name = '404', --undiscovered name
            text = {'Consumable is not recognized as an internal or external command, operable program or batch file.'} --undiscovered text
        }
    },
    shop_rate = 1, --rate in shop out of 100
}


SMODS.UndiscoveredSprite{
    key = 'CMD', --must be the same key as the consumabletype
    atlas = 'CMD',
    pos = {x = 10, y = 0}
}

SMODS.Consumable{
    key = 'ip', --key
    set = 'CMD', --the set of the card: corresponds to a consumable type
    atlas = 'CMD', --atlas
    pos = {x = 0, y = 0}, --position in atlas
    loc_txt = {
        name = 'C:\\_ipconfig', --name of card
        text = { --text of card
            'Disables current Boss Blind',
        }
    },

 use = function(self, card, area, copier)
        -- Disable the current Boss Blind (same logic Chicot uses)
        if G.GAME.blind then
            G.GAME.blind.disabled = true
            G.GAME.blind:debuff_hand(G.hand.cards, G.GAME.blind.name)
        end
        -- One-time use: card is consumed after use
    end,
    can_use = function(self, card)
        -- Only usable when a Boss Blind is active
        return G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled
    end,
}

SMODS.Consumable{
    key = 'clip', --key
    set = 'CMD', --the set of the card: corresponds to a consumable type
    atlas = 'CMD', --atlas
    pos = {x = 1, y = 0}, --position in atlas
    loc_txt = {
        name = 'C:\\_clip', --name of card
        text = { --text of card
            'Spawns last used consumable',
        }
    },

    can_use = function(self, card)
        return G.GAME.prev_used_consumable ~= nil
    end,
    use = function(self, card, area, copier)
        local last = G.GAME.prev_used_consumable
        if not last then return end

        local new_card = create_card(last.set, G.hand, nil, nil, nil, nil, last.key)
        new_card:add_to_deck()
        G.consumeables:emplace(new_card)
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { G.GAME.prev_used_consumable and G.GAME.prev_used_consumable.name or "None" }
        }
    end,
}

SMODS.Consumable {
    key = "lookup",
    set = "CMD",
    cost = 4,
    atlas = 'CMD',
    pos = {x = 2, y = 0},
    loc_txt = {
        name = "C:\\_nslookup",
        text = {
            'Shows top 5 cards of the deck',
        }
    },
    can_use = function(self, card)
        return G.deck and #G.deck.cards > 0
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot2', 0.76, 0.4)
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                local deck = G.deck.cards
                local count = math.min(5, #deck)

                local suit_symbols = {
                    Spades   = "♠",
                    Hearts   = "♥",
                    Clubs    = "♣",
                    Diamonds = "♦",
                }
                local suit_colours = {
                    Spades   = G.C.WHITE,
                    Hearts   = { 0.95, 0.2, 0.2, 1 },
                    Clubs    = G.C.WHITE,
                    Diamonds = { 0.95, 0.2, 0.2, 1 },
                }

                local text_nodes = {}

                table.insert(text_nodes, {
                    n = G.UIT.R,
                    config = { align = "cm", padding = 0.08 },
                    nodes = {{
                        n = G.UIT.T,
                        config = {
                            text = "-- top of deck --",
                            scale = 0.32,
                            colour = { 0.4, 0.8, 0.4, 1 }
                        }
                    }}
                })

                for i = 0, count - 1 do
                    local c = deck[#deck - i]
                    local rank = c.base.value
                    local suit = c.base.suit
                    local symbol = suit_symbols[suit] or suit
                    local colour = suit_colours[suit] or G.C.WHITE

                    table.insert(text_nodes, {
                        n = G.UIT.R,
                        config = { align = "lm", padding = 0.06 },
                        nodes = {
                            {
                                n = G.UIT.T,
                                config = {
                                    text = (i + 1) .. ".  ",
                                    scale = 0.35,
                                    colour = { 0.5, 0.5, 0.5, 1 }
                                }
                            },
                            {
                                n = G.UIT.T,
                                config = {
                                    text = rank .. " ",
                                    scale = 0.38,
                                    colour = G.C.WHITE
                                }
                            },
                            {
                                n = G.UIT.T,
                                config = {
                                    text = symbol,
                                    scale = 0.38,
                                    colour = colour
                                }
                            },
                            {
                                n = G.UIT.T,
                                config = {
                                    text = "  " .. suit,
                                    scale = 0.32,
                                    colour = { 0.5, 0.5, 0.5, 1 }
                                }
                            }
                        }
                    })
                end

                table.insert(text_nodes, {
                    n = G.UIT.R,
                    config = { align = "cm", padding = 0.08 },
                    nodes = {{
                        n = G.UIT.T,
                        config = {
                            text = "----------------",
                            scale = 0.3,
                            colour = { 0.3, 0.3, 0.3, 1 }
                        }
                    }}
                })

                table.insert(text_nodes, {
                    n = G.UIT.R,
                    config = { align = "cm", padding = 0.08 },
                    nodes = {{
                        n = G.UIT.T,
                        config = {
                            text = "[ ESC ] to close",
                            scale = 0.32,
                            colour = { 0.5, 0.5, 0.5, 1 }
                        }
                    }}
                })

                G.FUNCS.overlay_menu({
                    definition = {
                        n = G.UIT.ROOT,
                        config = {
                            align = "cm",
                            colour = { 0.04, 0.04, 0.04, 0.97 },
                            r = 0.1,
                            padding = 0.5,
                            minw = 4.5,
                            minh = 3.5
                        },
                        nodes = {
                            {
                                n = G.UIT.R,
                                config = { align = "cm", padding = 0.15 },
                                nodes = {{
                                    n = G.UIT.T,
                                    config = {
                                        text = "C:\\_nslookup",
                                        scale = 0.5,
                                        colour = G.C.GREEN
                                    }
                                }}
                            },
                            {
                                n = G.UIT.R,
                                config = { align = "cm" },
                                nodes = {{
                                    n = G.UIT.C,
                                    config = { align = "tl", padding = 0.25 },
                                    nodes = text_nodes
                                }}
                            }
                        }
                    }
                })
                return true
            end
        }))
    end,
}

SMODS.Consumable {
    key = "cls",
    set = "CMD",
    cost = 4,
    atlas = 'CMD', --atlas
    pos = {x = 3, y = 0}, --position in atlas
     loc_txt = {
        name = "C:\\_cls",
        text = { --text of card
            'Refreshes your amount of discards',
        }
    },
       can_use = function(self, card)
        return G.GAME.current_round.discards_used > 0
    end,
    use = function(self, card, area, copier)
        G.GAME.current_round.discards_left = G.GAME.round_resets.discards
        G.GAME.current_round.discards_used = 0
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
}

SMODS.Consumable {
    key = "batterycfg",
    set = "CMD",
    cost = 4,
    atlas = 'CMD',
    pos = {x = 4, y = 0},
    loc_txt = {
        name = "C:\\_batterycfg",
        text = {
            'Check device battery and',
            'give money based on %',
        }
    },
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local battery_percent = nil

        -- Try Linux
        local f = io.open("/sys/class/power_supply/BAT0/capacity", "r")
        if f then
            local val = f:read("*n")
            f:close()
            if val then battery_percent = val end
        end

        -- Try macOS
        if not battery_percent then
            local ok = os.execute("pmset -g batt | grep -o '[0-9]*%' | head -1 | tr -d '%' > /tmp/batt.txt 2>/dev/null")
            if ok then
                local f2 = io.open("/tmp/batt.txt", "r")
                if f2 then
                    local val = f2:read("*n")
                    f2:close()
                    if val then battery_percent = val end
                end
            end
        end

        -- Fallback: give max payout if we can't read the system
        if not battery_percent or battery_percent < 0 or battery_percent > 100 then
            battery_percent = 100
        end

        local money = math.floor(battery_percent / 10)
        if money < 1 then money = 1 end

        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot2', 0.76, 0.4)
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                ease_dollars(money)
                G.GAME.dollar_text = '+$' .. money
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            func = function()
                attention_text({
                    text = '+$' .. money .. ' (' .. battery_percent .. '%)',
                    scale = 1.4,
                    hold = 1.5,
                    align = 'cm',
                    offset = {x = 0, y = -2.7},
                    colour = G.C.MONEY
                })
                return true
            end
        }))
    end,
}

SMODS.Consumable {
    key = "assoc",
    set = "CMD",
    cost = 4,
    atlas = 'CMD',
    pos = {x = 5, y = 0},
    loc_txt = {
        name = "C:\\_assoc",
        text = {
            'Preview what the next',
            'shop reroll will contain',
        }
    },
    can_use = function(self, card)
        return G.STATE == G.STATES.SHOP
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot2', 0.76, 0.4)
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                local lines = {}

                -- Peek at shop cards by simulating a reroll using the same
                -- pseudoseed keys the shop uses, without consuming the queue
                local shop_slots = G.shop and G.shop.cards and #G.shop.cards or 2
                local ante = G.GAME.round_resets and G.GAME.round_resets.ante or 1
                local reroll_num = (G.GAME.reroll_cost or 0) + 1

                table.insert(lines, { text = "next reroll  [ante " .. ante .. "]:", header = true })

                -- The shop uses 'shop_joker', 'shop_tarot', 'shop_planet' etc as seed keys
                -- We simulate what pseudorandom_element would pick for each slot
                local shop_pools = {
                    { key = "shop_joker",  pool = G.P_CENTER_POOLS and G.P_CENTER_POOLS["Joker"],  label = "Joker" },
                    { key = "shop_tarot",  pool = G.P_CENTER_POOLS and G.P_CENTER_POOLS["Tarot"],  label = "Tarot" },
                    { key = "shop_planet", pool = G.P_CENTER_POOLS and G.P_CENTER_POOLS["Planet"], label = "Planet" },
                }

                -- Simulate each shop slot
                for slot = 1, shop_slots do
                    -- Pick which pool this slot would use (jokers are most common)
                    local roll = pseudorandom(pseudoseed('shop_type' .. ante .. slot .. reroll_num))
                    local chosen_pool = shop_pools[1] -- joker default
                    if roll > 0.7 then
                        chosen_pool = shop_pools[2]
                    elseif roll > 0.5 then
                        chosen_pool = shop_pools[3]
                    end

                    if chosen_pool.pool and #chosen_pool.pool > 0 then
                        local c = pseudorandom_element(
                            chosen_pool.pool,
                            pseudoseed(chosen_pool.key .. ante .. slot .. reroll_num)
                        )
                        local name = c and (c.name or c.key) or "?"
                        table.insert(lines, { text = "  > [" .. chosen_pool.label .. "]  " .. name, header = false })
                    else
                        table.insert(lines, { text = "  > [unavailable]", header = false })
                    end
                end

                -- Build UI rows
                local text_nodes = {}
                for _, line in ipairs(lines) do
                    table.insert(text_nodes, {
                        n = G.UIT.R,
                        config = { align = "lm", padding = 0.06 },
                        nodes = {{
                            n = G.UIT.T,
                            config = {
                                text = line.text,
                                scale = line.header and 0.4 or 0.33,
                                colour = line.header and G.C.GREEN or G.C.WHITE
                            }
                        }}
                    })
                end

                -- Divider
                table.insert(text_nodes, {
                    n = G.UIT.R,
                    config = { align = "cm", padding = 0.06 },
                    nodes = {{
                        n = G.UIT.T,
                        config = {
                            text = "----------------",
                            scale = 0.28,
                            colour = { 0.3, 0.3, 0.3, 1 }
                        }
                    }}
                })

                -- ESC to close
                table.insert(text_nodes, {
                    n = G.UIT.R,
                    config = { align = "cm", padding = 0.06 },
                    nodes = {{
                        n = G.UIT.T,
                        config = {
                            text = "[ ESC ] to close",
                            scale = 0.3,
                            colour = { 0.5, 0.5, 0.5, 1 }
                        }
                    }}
                })

                G.FUNCS.overlay_menu({
                    definition = {
                        n = G.UIT.ROOT,
                        config = {
                            align = "cm",
                            colour = { 0.04, 0.04, 0.04, 0.97 },
                            r = 0.1,
                            padding = 0.5,
                            minw = 5.5,
                            minh = 4.0
                        },
                        nodes = {
                            {
                                n = G.UIT.R,
                                config = { align = "cm", padding = 0.15 },
                                nodes = {{
                                    n = G.UIT.T,
                                    config = {
                                        text = "C:\\_assoc",
                                        scale = 0.5,
                                        colour = G.C.GREEN
                                    }
                                }}
                            },
                            {
                                n = G.UIT.R,
                                config = { align = "cm" },
                                nodes = {{
                                    n = G.UIT.C,
                                    config = { align = "tl", padding = 0.25 },
                                    nodes = text_nodes
                                }}
                            }
                        }
                    }
                })
                return true
            end
        }))
    end,
}

SMODS.Consumable {
    key = "chkdsk",
    set = "CMD",
    cost = 4,
    atlas = 'CMD',
    pos = {x = 4, y = 0},
    loc_txt = {
        name = "C:\\_chkdsk",
        text = {
            'Spawns {C:green}CHKDSK [ARMED]{} token.',
            'If you would lose, you are saved.',
            'Token expires end of blind.',
        }
    },
    can_use = function(self, card)
        -- Only during a blind and only if token not already active
        if not (G.STATE == G.STATES.HAND_PLAYED or G.STATE == G.STATES.DRAW_TO_HAND) then
            return false
        end
        if G.consumeables then
            for _, c in ipairs(G.consumeables.cards) do
                if c.config and c.config.center and c.config.center.key == 'c_chkdsk_armed' then
                    return false
                end
            end
        end
        return #G.consumeables.cards < G.consumeables.config.card_limit
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot2', 0.76, 0.4)
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                -- Spawn the armed token into consumables
                local armed = create_card('Default', G.consumeables, nil, nil, nil, nil, 'c_chkdsk_armed')
                armed:add_to_deck()
                G.consumeables:emplace(armed)
                attention_text({
                    text = "CHKDSK: armed",
                    scale = 0.7,
                    hold = 2,
                    align = "cm",
                    offset = {x = 0, y = -2.7},
                    colour = G.C.GREEN
                })
                return true
            end
        }))
    end,
}

SMODS.Consumable {
    key = "taskkill",
    set = "CMD",
    cost = 4,
    atlas = 'CMD',
    pos = {x = 6, y = 0},
    loc_txt = {
        name = "C:\\_taskkill",
        text = {
            'Destroy any selected cards',
            '{C:inactive}No limit{}'
        }
    },
    config = {
        extra = {
            cards = 9999, --configurable value
        }
    },
    loc_vars = function(self,info_queue, center)
        return {vars = {center.ability.extra.cards}} --displays configurable value: the #1# in the description is replaced with the configurable value
    end,
    can_use = function(self,card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.cards then --if cards in hand highlighted are above 0 but below the configurable value then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        local highlighted = {}
        for _, c in ipairs(G.hand.highlighted) do
            highlighted[#highlighted + 1] = c
        end

        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot2', 0.76, 0.4)
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        for _, c in ipairs(highlighted) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand:remove_card(c)
                    c:start_dissolve()
                    return true
                end
            }))
        end
    end,
}

SMODS.Consumable {
    key = "help",
    set = "CMD",
    cost = 4,
    atlas = 'CMD',
    pos = {x = 4, y = 0},
    loc_txt = {
        name = "C:\\_help",
        text = {
            'Gives you half of the',
            'needed chips to win the blind',            
        }
    },
    can_use = function(self, card)
        return G.GAME and G.GAME.blind and G.GAME.blind.chips
    end,
use = function(self, card, area, copier)
    local half = math.floor(G.GAME.blind.chips / 2)

    G.E_MANAGER:add_event(Event({
        func = function()
            play_sound('tarot2', 0.76, 0.4)
            card:juice_up(0.3, 0.5)
            G.GAME.chips = (G.GAME.chips or 0) + half
            if G.hand_text_area and G.hand_text_area.game_chips then
                G.hand_text_area.game_chips:update_text()
            end
            return true
        end
    }))
end,
}

SMODS.Consumable {
    key = "shutdown",
    set = "CMD",
    cost = 4,
    atlas = 'CMD',
    pos = {x = 4, y = 0},
    loc_txt = {
        name = "C:\\_shutdown",
        text = {
            'Immediately wins the blind',          
        }
    },
    can_use = function(self, card)
        return G.GAME and G.GAME.blind and G.GAME.blind.chips
    end,
use = function(self, card, area, copier)
    local half = math.floor(G.GAME.blind.chips)


    G.E_MANAGER:add_event(Event({
        func = function()
            play_sound('tarot2', 0.76, 0.4)
            card:juice_up(0.3, 0.5)
            G.GAME.chips = (G.GAME.chips or 0) + half
            if G.hand_text_area and G.hand_text_area.game_chips then
                G.hand_text_area.game_chips:update_text()
            end
            -- Trigger win check
            if G.GAME.chips >= G.GAME.blind.chips then
                G.FUNCS.win_round()
            end
            return true
        end
    }))
end,
}