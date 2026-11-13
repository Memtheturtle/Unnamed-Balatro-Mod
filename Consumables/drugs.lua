SMODS.Atlas{
    key = 'Drugs',
    path = 'Drugs.png',
    px = 71,
    py = 95
}

SMODS.ConsumableType{
    key = 'Drugs',
    collection_rows = {4,5},
    primary_colour = G.C.PURPLE,
    secondary_colour = G.C.DARK_EDITION,
    loc_txt = {
        collection = 'Drugs',
        name = 'Drugs',
        undiscovered = {
            name = 'Hidden Drugs',
            text = {'Check under', 'the couch'}
        }
    },
    shop_rate = 1,
}

SMODS.UndiscoveredSprite{
    key = 'Drugs',
    atlas = 'Drugs',
    pos = {x = 10, y = 0}
}

SMODS.Consumable{
    key = 'bor',
    set = 'Drugs',
    atlas = 'Drugs',
    pos = {x = 2, y = 0},
    loc_txt = {
        name = 'Boron',
        text = {
            'Convert {C:attention}4{} cards into {C:attention}Jacks{}',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    config = {
        extra = {
            cards = 4,
        }
    },
    loc_vars = function(self,info_queue, center)
        return {vars = {center.ability.extra.cards}}
    end,
    can_use = function(self,card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.cards then
                return true
            end
        end
        return false
    end,
    use = function(self,card,area,copier)
        for i = 1, #G.hand.highlighted do
            local card = G.hand.highlighted[i]
            local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
            local rank_suffix = card.base.id 
            if rank_suffix ~= 11 then rank_suffix = 'J'
                card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                for i=1, #G.hand.highlighted do
                    local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
                end
            end
        end
    end,
}

SMODS.Consumable{
    key = 'est',
    set = 'Drugs',
    atlas = 'Drugs',
    pos = {x = 1, y = 0},
    loc_txt = {
        name = 'Estrogen',
        text = {
            'Convert {C:attention}4{} cards into {C:attention}Queens{}',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    config = {
        extra = {
            cards = 4,
        }
    },
    loc_vars = function(self,info_queue, center)
        return {vars = {center.ability.extra.cards}}
    end,
    can_use = function(self,card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.cards then
                return true
            end
        end
        return false
    end,
    use = function(self,card,area,copier)
        for i = 1, #G.hand.highlighted do
            local card = G.hand.highlighted[i]
            local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
            local rank_suffix = card.base.id 
            if rank_suffix ~= 12 then rank_suffix = 'Q'
                card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                for i=1, #G.hand.highlighted do
                    local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
                end
            end
        end
    end,
}

SMODS.Consumable{
    key = 'tes',
    set = 'Drugs',
    atlas = 'Drugs',
    pos = {x = 0, y = 0},
    loc_txt = {
        name = 'Testosterone',
        text = {
            'Convert {C:attention}4{} cards into {C:attention}Kings{}',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    config = {
        extra = {
            cards = 4,
        }
    },
    loc_vars = function(self,info_queue, center)
        return {vars = {center.ability.extra.cards}}
    end,
    can_use = function(self,card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.cards then
                return true
            end
        end
        return false
    end,
    use = function(self,card,area,copier)
        for i = 1, #G.hand.highlighted do
            local card = G.hand.highlighted[i]
            local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
            local rank_suffix = card.base.id 
            if rank_suffix ~= 13 then rank_suffix = 'K'
                card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                for i=1, #G.hand.highlighted do
                    local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
                end
            end
        end
    end,
}

SMODS.Consumable{
    key = 'crack',
    set = 'Drugs',
    atlas = 'Drugs',
    pos = {x = 3, y = 0},
    loc_txt = {
        name = 'Crack',
        text = {
            'Remove all cards',
            'of a {C:attention}random suit{}',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    config = {},
    can_use = function(self, card)
        return G and (G.deck and #G.deck.cards > 0) or (G.hand and #G.hand.cards > 0)
    end,
    use = function(self, card, area, copier)
        local suits = {'Spades', 'Hearts', 'Clubs', 'Diamonds'}
        local available_suits = {}

        local deck_suit_counts = {Spades = 0, Hearts = 0, Clubs = 0, Diamonds = 0}
        if G.deck and G.deck.cards then
            for _, deck_card in ipairs(G.deck.cards) do
                if deck_card.base and deck_card.base.suit then
                    deck_suit_counts[deck_card.base.suit] = deck_suit_counts[deck_card.base.suit] + 1
                end
            end
        end

        local hand_suit_counts = {Spades = 0, Hearts = 0, Clubs = 0, Diamonds = 0}
        if G.hand and G.hand.cards then
            for _, hand_card in ipairs(G.hand.cards) do
                if hand_card.base and hand_card.base.suit then
                    hand_suit_counts[hand_card.base.suit] = hand_suit_counts[hand_card.base.suit] + 1
                end
            end
        end

        for _, suit in ipairs(suits) do
            if (deck_suit_counts[suit] + hand_suit_counts[suit]) > 0 then
                table.insert(available_suits, suit)
            end
        end

        if #available_suits == 0 then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = "No cards to remove!",
                        scale = 0.8,
                        hold = 2,
                        align = 'cm',
                        offset = {x = 0, y = -3}
                    })
                    return true
                end
            }))
            return
        end

        local selected_suit = available_suits[math.random(1, #available_suits)]

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                attention_text({
                    text = "Removing all " .. selected_suit,
                    scale = 0.8,
                    hold = 2,
                    align = 'cm',
                    offset = {x = 0, y = -3}
                })
                return true
            end
        }))

        local hand_cards_to_remove = {}
        if G.hand and G.hand.cards then
            for _, hand_card in ipairs(G.hand.cards) do
                if hand_card.base.suit == selected_suit then
                    table.insert(hand_cards_to_remove, hand_card)
                end
            end
        end

        local deck_cards_to_remove = {}
        if G.deck and G.deck.cards then
            for _, deck_card in ipairs(G.deck.cards) do
                if deck_card.base.suit == selected_suit then
                    table.insert(deck_cards_to_remove, deck_card)
                end
            end
        end

        for i, card_to_remove in ipairs(hand_cards_to_remove) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1 * i,
                func = function()
                    if card_to_remove and G.hand and G.hand.cards then
                        G.hand:remove_card(card_to_remove)
                        card_to_remove:start_dissolve()
                        local pitch = math.max(0.5, 1 - (i-1)*0.05)
                        play_sound('card1', pitch)
                    end
                    return true
                end
            }))
        end

        for i, card_to_remove in ipairs(deck_cards_to_remove) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1 * (i + #hand_cards_to_remove),
                func = function()
                    if card_to_remove and G.deck and G.deck.cards then
                        G.deck:remove_card(card_to_remove)
                        card_to_remove:start_dissolve()
                        local pitch = math.max(0.5, 1 - (i-1)*0.05)
                        play_sound('card1', pitch)
                    end
                    return true
                end
            }))
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5 + 0.1 * (#hand_cards_to_remove + #deck_cards_to_remove),
            func = function()
                if G.deck and #G.deck.cards > 0 then
                    G.deck:shuffle()
                end
                return true
            end
        }))
    end
}

SMODS.Consumable{
    key = 'crack2',
    set = 'Drugs',
    atlas = 'Drugs',
    pos = {x = 4, y = 0},
    loc_txt = {
        name = 'Crack2',
        text = {
           'Remove all cards',
            'of a {C:attention}random rank{}',
            '{s:0.8}{C:inactive}Art by SingularityXVI{}',
        }
    },
    config = {},
    can_use = function(self, card)
        return G and (G.deck and #G.deck.cards > 0) or (G.hand and #G.hand.cards > 0)
    end,
    use = function(self, card, area, copier)
        local ranks = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}
        local rank_names = {
            [2] = "2s", [3] = "3s", [4] = "4s", [5] = "5s", [6] = "6s", [7] = "7s", [8] = "8s", [9] = "9s", [10] = "10s",
            [11] = "Jacks", [12] = "Queens", [13] = "Kings", [14] = "Aces"
        }
        local available_ranks = {}

        local deck_rank_counts = {}
        for i = 2, 14 do deck_rank_counts[i] = 0 end
        if G.deck and G.deck.cards then
            for _, deck_card in ipairs(G.deck.cards) do
                if deck_card.base and deck_card.base.id then
                    deck_rank_counts[deck_card.base.id] = deck_rank_counts[deck_card.base.id] + 1
                end
            end
        end

        local hand_rank_counts = {}
        for i = 2, 14 do hand_rank_counts[i] = 0 end
        if G.hand and G.hand.cards then
            for _, hand_card in ipairs(G.hand.cards) do
                if hand_card.base and hand_card.base.id then
                    hand_rank_counts[hand_card.base.id] = hand_rank_counts[hand_card.base.id] + 1
                end
            end
        end

        for _, rank in ipairs(ranks) do
            if (deck_rank_counts[rank] + hand_rank_counts[rank]) > 0 then
                table.insert(available_ranks, rank)
            end
        end

        if #available_ranks == 0 then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = "No cards to remove!",
                        scale = 0.8,
                        hold = 2,
                        align = 'cm',
                        offset = {x = 0, y = -3}
                    })
                    return true
                end
            }))
            return
        end

        local selected_rank = available_ranks[math.random(1, #available_ranks)]
        local rank_name = rank_names[selected_rank] or tostring(selected_rank)

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                attention_text({
                    text = "Removing all " .. rank_name,
                    scale = 0.8,
                    hold = 2,
                    align = 'cm',
                    offset = {x = 0, y = -3}
                })
                return true
            end
        }))

        local hand_cards_to_remove = {}
        if G.hand and G.hand.cards then
            for _, hand_card in ipairs(G.hand.cards) do
                if hand_card.base.id == selected_rank then
                    table.insert(hand_cards_to_remove, hand_card)
                end
            end
        end

        local deck_cards_to_remove = {}
        if G.deck and G.deck.cards then
            for _, deck_card in ipairs(G.deck.cards) do
                if deck_card.base.id == selected_rank then
                    table.insert(deck_cards_to_remove, deck_card)
                end
            end
        end

        for i, card_to_remove in ipairs(hand_cards_to_remove) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1 * i,
                func = function()
                    if card_to_remove and G.hand and G.hand.cards then
                        G.hand:remove_card(card_to_remove)
                        card_to_remove:start_dissolve()
                        local pitch = math.max(0.5, 1 - (i-1)*0.05)
                        play_sound('card1', pitch)
                    end
                    return true
                end
            }))
        end

        for i, card_to_remove in ipairs(deck_cards_to_remove) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1 * (i + #hand_cards_to_remove),
                func = function()
                    if card_to_remove and G.deck and G.deck.cards then
                        G.deck:remove_card(card_to_remove)
                        card_to_remove:start_dissolve()
                        local pitch = math.max(0.5, 1 - (i-1)*0.05)
                        play_sound('card1', pitch)
                    end
                    return true
                end
            }))
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5 + 0.1 * (#hand_cards_to_remove + #deck_cards_to_remove),
            func = function()
                if G.deck and #G.deck.cards > 0 then
                    G.deck:shuffle()
                end
                return true
            end
        }))
    end
}

SMODS.Consumable{
    key = 'meth',
    set = 'Drugs',
    atlas = 'Drugs',
    pos = {x = 0, y = 1},
    loc_txt = {
        name = 'Methamphetamine',
        text = {
            'Placeholder'
        }
    },
    config = {
        extra = {
            cards = 4,
        }
    },
    can_use = function(self,card)
        return true
    end,
    use = function(self,card,area,copier)
    end,
}

SMODS.Consumable{
    key = 'galaxy',
    set = 'Drugs',
    atlas = 'Drugs',
    pos = {x = 0, y = 1},
    loc_txt = {
        name = 'Galaxy Gas',
        text = {
            'Gives {C:attention}Kanye West{}'
        }
    },
    can_use = function(self,card)
        return true
    end,
    use = function(self,card,area,copier)
        local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_gcbm_kanye')
        new_card:add_to_deck()
        G.jokers:emplace(new_card)
    end,
}