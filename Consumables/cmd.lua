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

local tracert_state = { rank = "Ace", suit = "Spades" }
local ranks = {"2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"}
local suits = {"Spades","Hearts","Clubs","Diamonds"}
local suit_colours = {
    Spades   = G.C.WHITE,
    Hearts   = {0.95,0.2,0.2,1},
    Clubs    = G.C.WHITE,
    Diamonds = {0.95,0.2,0.2,1},
}

for _, r in ipairs(ranks) do
    local rank_ref = r
    G.FUNCS["tracert_rank_" .. r] = function(e)
        tracert_state.rank = rank_ref
    end
end

for _, s in ipairs(suits) do
    local suit_ref = s
    G.FUNCS["tracert_suit_" .. s] = function(e)
        tracert_state.suit = suit_ref
    end
end

G.FUNCS.tracert_search = function(e)
    -- Close selection menu
    if G.OVERLAY_MENU then
        G.OVERLAY_MENU:remove()
        G.OVERLAY_MENU = nil
    end

    local deck = G.deck and G.deck.cards
    if not deck then return end

    local found = {}
    for i = #deck, 1, -1 do
        local c = deck[i]
        if c.base.value == tracert_state.rank and c.base.suit == tracert_state.suit then
            table.insert(found, (#deck - i + 1))
        end
    end

    local result_line
    if #found == 0 then
        result_line = tracert_state.rank .. " of " .. tracert_state.suit .. "  --  not in deck"
    else
        local positions = {}
        for _, p in ipairs(found) do
            positions[#positions+1] = "#" .. p
        end
        result_line = tracert_state.rank .. " of " .. tracert_state.suit .. "  --  " .. table.concat(positions, ", ")
    end

    -- Open results popup
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.15,
        func = function()
            G.FUNCS.overlay_menu({
                definition = {
                    n = G.UIT.ROOT,
                    config = {
                        align = "cm",
                        colour = {0.04,0.04,0.04,0.97},
                        r = 0.1,
                        padding = 0.5,
                        minw = 6.0,
                        minh = 2.0
                    },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = { align = "cm", padding = 0.15 },
                            nodes = {{
                                n = G.UIT.T,
                                config = { text = "C:\\_tracert  output:", scale = 0.42, colour = G.C.GREEN }
                            }}
                        },
                        {
                            n = G.UIT.R,
                            config = { align = "cm", padding = 0.15 },
                            nodes = {{
                                n = G.UIT.T,
                                config = { text = result_line, scale = 0.38, colour = G.C.WHITE }
                            }}
                        },
                        {
                            n = G.UIT.R,
                            config = { align = "cm", padding = 0.1 },
                            nodes = {{ n = G.UIT.T, config = { text = "[ ESC ] to close", scale = 0.28, colour = {0.5,0.5,0.5,1} } }}
                        },
                    }
                }
            })
            return true
        end
    }))
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
    pos = {x = 6, y = 0},
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
    key = "tasklist",
    set = "CMD",
    cost = 4,
    atlas = 'CMD',
    pos = {x = 7, y = 0},
    loc_txt = {
        name = "C:\\_tasklist",
        text = {
            'Summons the negative planet cards',
            'associated with your top 3',
            'most played hand types',
        }
    },
    can_use = function(self, card)
        return #G.consumeables.cards < G.consumeables.config.card_limit
    end,
    use = function(self, card, area, copier)
        -- Map hand types to their planet card keys
        local hand_to_planet = {
            ["High Card"]       = "c_pluto",
            ["Pair"]            = "c_mercury",
            ["Two Pair"]        = "c_uranus",
            ["Three of a Kind"] = "c_venus",
            ["Straight"]        = "c_saturn",
            ["Flush"]           = "c_jupiter",
            ["Full House"]      = "c_earth",
            ["Four of a Kind"]  = "c_mars",
            ["Straight Flush"]  = "c_neptune",
            ["Five of a Kind"]  = "c_planet_x",
            ["Flush House"]     = "c_ceres",
            ["Flush Five"]      = "c_eris",
        }

        -- Sort hand types by most played
        local played = {}
        for hand, data in pairs(G.GAME.hands) do
            if data.played and data.played > 0 then
                played[#played + 1] = { hand = hand, count = data.played }
            end
        end
        table.sort(played, function(a, b) return a.count > b.count end)

        -- Take top 3
        local top3 = {}
        for i = 1, math.min(3, #played) do
            top3[#top3 + 1] = played[i].hand
        end

        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot2', 0.76, 0.4)
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        for i, hand in ipairs(top3) do
            local planet_key = hand_to_planet[hand]
            if planet_key then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = i * 0.3,
                    func = function()
                        local planet = create_card('Planet', G.consumeables, nil, nil, nil, nil, planet_key)
                        planet:set_edition({ negative = true }, true)
                        planet:add_to_deck()
                        G.consumeables:emplace(planet)
                        play_sound('card1', 1, 0.8)
                        return true
                    end
                }))
            end
        end
    end,
}

SMODS.Consumable {
    key = "taskkill",
    set = "CMD",
    cost = 4,
    atlas = 'CMD',
    pos = {x = 8, y = 0},
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
    key = "ping",
    set = "CMD",
    cost = 4,
    atlas = 'CMD',
    pos = {x = 0, y = 1},
    loc_txt = {
        name = "C:\\_ping",
        text = {
            'holder',
            'of place',
        }
    },
    can_use = function(self, card)
        return true
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
    key = "tracert",
    set = "CMD",
    cost = 4,
    atlas = 'CMD',
    pos = {x = 0, y = 1},
    loc_txt = {
        name = "C:\\_tracert",
        text = {
            'Search the deck for a card',
            'by rank and suit',
        }
    },
    can_use = function(self, card)
        return G.deck and #G.deck.cards > 0
    end,
    use = function(self, card, area, copier)
        tracert_state.rank = "Ace"
        tracert_state.suit = "Spades"

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
                local rank_nodes = {}
                for _, r in ipairs(ranks) do
                    table.insert(rank_nodes, {
                        n = G.UIT.C,
                        config = {
                            button = "tracert_rank_" .. r,
                            align = "cm",
                            padding = 0.05,
                            colour = {0.15,0.15,0.15,1},
                            r = 0.05,
                            hover = true,
                            shadow = true,
                        },
                        nodes = {{
                            n = G.UIT.T,
                            config = { text = r, scale = 0.28, colour = G.C.WHITE }
                        }}
                    })
                end

                local suit_nodes = {}
                for _, s in ipairs(suits) do
                    table.insert(suit_nodes, {
                        n = G.UIT.C,
                        config = {
                            button = "tracert_suit_" .. s,
                            align = "cm",
                            padding = 0.12,
                            colour = {0.15,0.15,0.15,1},
                            r = 0.05,
                            hover = true,
                            shadow = true,
                            minw = 1.5,
                        },
                        nodes = {{
                            n = G.UIT.T,
                            config = { text = s, scale = 0.32, colour = suit_colours[s] }
                        }}
                    })
                end

                G.FUNCS.overlay_menu({
                    definition = {
                        n = G.UIT.ROOT,
                        config = {
                            align = "cm",
                            colour = {0.04,0.04,0.04,0.97},
                            r = 0.1,
                            padding = 0.5,
                            minw = 7.0,
                            minh = 3.0
                        },
                        nodes = {
                            {
                                n = G.UIT.R,
                                config = { align = "cm", padding = 0.15 },
                                nodes = {{
                                    n = G.UIT.T,
                                    config = { text = "C:\\_tracert", scale = 0.5, colour = G.C.GREEN }
                                }}
                            },
                            {
                                n = G.UIT.R,
                                config = { align = "cm", padding = 0.06 },
                                nodes = {{ n = G.UIT.T, config = { text = "rank:", scale = 0.32, colour = {0.4,0.8,0.4,1} } }}
                            },
                            { n = G.UIT.R, config = { align = "cm", padding = 0.06 }, nodes = rank_nodes },
                            {
                                n = G.UIT.R,
                                config = { align = "cm", padding = 0.1 },
                                nodes = {{ n = G.UIT.T, config = { text = "suit:", scale = 0.32, colour = {0.4,0.8,0.4,1} } }}
                            },
                            { n = G.UIT.R, config = { align = "cm", padding = 0.08 }, nodes = suit_nodes },
                            {
                                n = G.UIT.R,
                                config = { align = "cm", padding = 0.15 },
                                nodes = {{
                                    n = G.UIT.C,
                                    config = {
                                        button = "tracert_search",
                                        align = "cm",
                                        padding = 0.12,
                                        colour = G.C.GREEN,
                                        r = 0.05,
                                        hover = true,
                                        shadow = true,
                                        minw = 2.0,
                                    },
                                    nodes = {{ n = G.UIT.T, config = { text = "[ SEARCH ]", scale = 0.4, colour = G.C.BLACK } }}
                                }}
                            },
                            {
                                n = G.UIT.R,
                                config = { align = "cm", padding = 0.06 },
                                nodes = {{ n = G.UIT.T, config = { text = "[ ESC ] to close", scale = 0.28, colour = {0.5,0.5,0.5,1} } }}
                            },
                        }
                    }
                })
                return true
            end
        }))
    end,
}

SMODS.Consumable {
    key = "netstat",
    set = "CMD",
    cost = 4,
    atlas = 'CMD',
    pos = {x = 0, y = 1},
    loc_txt = {
        name = "C:\\_netstat",
        text = {
            'holder',
            'of place',
        }
    },
    can_use = function(self, card)
        return true
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

GCBM = GCBM or {}
GCBM.rmdir_state = GCBM.rmdir_state or {
    current_blind_used = {}, -- uids used so far in the in-progress round
    history = {},            -- up to 5 snapshots of completed rounds, newest first
    last_round = nil,
    next_uid = 1,
}

local function rmdir_ensure_uid(c)
    if not c then return nil end
    c.ability = c.ability or {}
    if not c.ability.gcbm_rmdir_uid then
        c.ability.gcbm_rmdir_uid = GCBM.rmdir_state.next_uid
        GCBM.rmdir_state.next_uid = GCBM.rmdir_state.next_uid + 1
    end
    return c.ability.gcbm_rmdir_uid
end

-- Rolls current_blind_used into history whenever G.GAME.round has moved on
local function rmdir_sync_round()
    local round = G.GAME and G.GAME.round
    if round == nil then return end

    if GCBM.rmdir_state.last_round == nil then
        GCBM.rmdir_state.last_round = round
        return
    end

    if round ~= GCBM.rmdir_state.last_round then
        table.insert(GCBM.rmdir_state.history, 1, GCBM.rmdir_state.current_blind_used)
        while #GCBM.rmdir_state.history > 5 do
            table.remove(GCBM.rmdir_state.history)
        end
        GCBM.rmdir_state.current_blind_used = {}
        GCBM.rmdir_state.last_round = round
    end
end

local function rmdir_mark_used(cards)
    rmdir_sync_round()
    if not cards then return end
    for _, c in ipairs(cards) do
        local uid = rmdir_ensure_uid(c)
        if uid then
            GCBM.rmdir_state.current_blind_used[uid] = true
        end
    end
end

local function rmdir_recent_used_lookup()
    rmdir_sync_round()
    local used = {}
    for _, snapshot in ipairs(GCBM.rmdir_state.history) do
        for uid in pairs(snapshot) do
            used[uid] = true
        end
    end
    return used
end

local function rmdir_get_unused_playing_cards()
    local used_lookup = rmdir_recent_used_lookup()
    local unused = {}
    for _, c in ipairs(G.playing_cards or {}) do
        local uid = rmdir_ensure_uid(c)
        if uid and not used_lookup[uid] then
            unused[#unused + 1] = c
        end
    end
    return unused
end

-- Hook the real "play hand" callback so we know which cards were used,
-- without needing a phantom joker sitting in G.jokers.
local rmdir_play_ref = G.FUNCS.play_cards_from_highlighted
G.FUNCS.play_cards_from_highlighted = function(e)
    local played = {}
    for _, c in ipairs(G.hand.highlighted) do
        played[#played + 1] = c
    end
    rmdir_mark_used(played)
    return rmdir_play_ref(e)
end

SMODS.Consumable {
    key = "rmdir",
    set = "CMD",
    cost = 4,
    atlas = "CMD",
    pos = { x = 2, y = 1 },

    loc_txt = {
        name = "C:\\_rmdir",
        text = {
            "Destroys all cards not used",
            "in the past 5 blinds",
        }
    },

    can_use = function(self, card)
        return #rmdir_get_unused_playing_cards() > 0
    end,

    use = function(self, card, area, copier)
        local targets = rmdir_get_unused_playing_cards()
        for _, target in ipairs(targets) do
            if target.start_dissolve then
                target:start_dissolve()
            end
        end

        return {
            message = "Deleted!",
            colour = G.C.RED
        }
    end
}

GCBM = GCBM or {}
GCBM.cd_state = GCBM.cd_state or { history = {} }

-- Every time a blind actually starts, remember it (ante + slot + P_BLINDS key).
-- We keep our own history because Balatro overwrites blind_choices.Boss on
-- each ante-up, so there's no native way to recover a past ante's boss.
local cd_new_round_ref = new_round
function new_round()
    local key = G.GAME.round_resets.blind_choices[G.GAME.blind_on_deck]
    table.insert(GCBM.cd_state.history, {
        ante = G.GAME.round_resets.ante,
        blind_on_deck = G.GAME.blind_on_deck,
        key = key,
    })
    while #GCBM.cd_state.history > 10 do
        table.remove(GCBM.cd_state.history, 1)
    end
    return cd_new_round_ref()
end

SMODS.Consumable {
    key = "cd",
    set = "CMD",
    cost = 4,
    atlas = 'CMD',
    pos = {x = 3, y = 1},
    loc_txt = {
        name = [[C:\_cd]],
        text = {
            'Changes blind to the previous one',
            'without losing any chip value',
        }
    },

    can_use = function(self, card)
        return #GCBM.cd_state.history >= 2
    end,

    use = function(self, card, area, copier)
        local chips = G.GAME.chips

        -- Drop the entry for the blind we're currently on
        table.remove(GCBM.cd_state.history)
        local prev = GCBM.cd_state.history[#GCBM.cd_state.history]
        if not prev then return end

        local prev_blind_data = G.P_BLINDS[prev.key]
        if not prev_blind_data then return end

        G.GAME.round_resets.ante = prev.ante
        G.GAME.blind_on_deck = prev.blind_on_deck
        G.GAME.round_resets.blind_choices[prev.blind_on_deck] = prev.key
        G.GAME.round_resets.blind = prev_blind_data

        G.GAME.round_resets.blind_states.Small = (prev.blind_on_deck == 'Small') and 'Current' or G.GAME.round_resets.blind_states.Small
        G.GAME.round_resets.blind_states.Big = (prev.blind_on_deck == 'Big') and 'Current' or G.GAME.round_resets.blind_states.Big
        G.GAME.round_resets.blind_states.Boss = (prev.blind_on_deck == 'Boss') and 'Current' or G.GAME.round_resets.blind_states.Boss

        -- Fully rebuilds art, colours, name and chip requirement (silent = skip fanfare)
        G.GAME.blind:set_blind(prev_blind_data, nil, true)

        G.GAME.chips = chips
    end,
}

SMODS.Consumable {
    key = "help",
    set = "CMD",
    cost = 4,
    atlas = 'CMD',
    pos = {x = 9, y = 0},
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
    pos = {x = 0, y = 1},
    loc_txt = {
        name = "C:\\_shutdown",
        text = {
            'Gives all required chips to win the blind',          
        }
    },
     can_use = function(self, card)
        return G.GAME and G.GAME.blind and G.GAME.blind.chips
    end,
    use = function(self, card, area, copier)
    local all = math.floor(G.GAME.blind.chips)

    G.E_MANAGER:add_event(Event({
        func = function()
            play_sound('tarot2', 0.76, 0.4)
            card:juice_up(0.3, 0.5)
            G.GAME.chips = (G.GAME.chips or 0) + all
            if G.hand_text_area and G.hand_text_area.game_chips then
                G.hand_text_area.game_chips:update_text()
            end
            return true
        end
    }))
    end,
}
