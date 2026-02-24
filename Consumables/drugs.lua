----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Drugs', --atlas key
    path = 'Drugs.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}



SMODS.ConsumableType{
    key = 'Drugs', --consumable type key

    collection_rows = {4,5}, --amount of cards in one page
    primary_colour = G.C.PURPLE, --first color
    secondary_colour = G.C.DARK_EDITION, --second color
    loc_txt = {
        collection = 'Drugs', --name displayed in collection
        name = 'Drugs', --name displayed in badge
        undiscovered = {
            name = 'Hidden Drugs', --undiscovered name
            text = {'Check under', 'the couch'} --undiscovered text
        }
    },
    shop_rate = 1, --rate in shop out of 100
}


SMODS.UndiscoveredSprite{
    key = 'Drugs', --must be the same key as the consumabletype
    atlas = 'Drugs',
    pos = {x = 10, y = 0}
}


SMODS.Consumable{
    key = 'bor', --key
    set = 'Drugs', --the set of the card: corresponds to a consumable type
    atlas = 'Drugs', --atlas
    pos = {x = 2, y = 0}, --position in atlas
    loc_txt = {
        name = 'Boron', --name of card
        text = { --text of card
            'Convert {C:attention}4{} cards into {C:attention}Jacks{}'
        }
    },
    config = {
        extra = {
            cards = 4, --configurable value
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
    use = function(self,card,area,copier)
        for i = 1, #G.hand.highlighted do 
            --for every card in hand highlighted
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
            --set their rank to Jack
        end

    end,
}

SMODS.Consumable{
    key = 'est', --key
    set = 'Drugs', --the set of the card: corresponds to a consumable type
    atlas = 'Drugs', --atlas
    pos = {x = 1, y = 0}, --position in atlas
    loc_txt = {
        name = 'Estrogen', --name of card
        text = { --text of card
            'Convert {C:attention}4{} cards into {C:attention}Queens{}'
        }
    },
    config = {
        extra = {
            cards = 4, --configurable value
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
    use = function(self,card,area,copier)
        for i = 1, #G.hand.highlighted do 
            --for every card in hand highlighted
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
            --set their rank to Queen
        end

    end,
}

SMODS.Consumable{
    key = 'tes', --key
    set = 'Drugs', --the set of the card: corresponds to a consumable type
    atlas = 'Drugs', --atlas
    pos = {x = 0, y = 0}, --position in atlas
    loc_txt = {
        name = 'Testosterone', --name of card
        text = { --text of card
            'Convert {C:attention}4{} cards into {C:attention}Kings{}'
        }
    },
    config = {
        extra = {
            cards = 4, --configurable value
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
    use = function(self,card,area,copier)
        for i = 1, #G.hand.highlighted do 
            --for every card in hand highlighted
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
            --set their rank to Queen
        end

    end,
}

SMODS.Consumable{
    key = 'crack',
    set = 'Drugs',
    atlas = 'Drugs',
    pos = {x = 3, y = 0}, -- Adjust position based on your atlas
    loc_txt = {
        name = 'Crack',
        text = {
            'Remove all cards',
            'of a {C:attention}random suit{}',
        }
    },
    config = {},
    can_use = function(self, card)
        -- Check if there are any cards in the deck or hand
        return G and (G.deck and #G.deck.cards > 0) or (G.hand and #G.hand.cards > 0)
    end,
    use = function(self, card, area, copier)
        -- List of possible suits
        local suits = {'Spades', 'Hearts', 'Clubs', 'Diamonds'}
        -- Track suits that have cards
        local available_suits = {}

        -- Check deck for suits
        local deck_suit_counts = {Spades = 0, Hearts = 0, Clubs = 0, Diamonds = 0}
        if G.deck and G.deck.cards then
            for _, deck_card in ipairs(G.deck.cards) do
                if deck_card.base and deck_card.base.suit then
                    deck_suit_counts[deck_card.base.suit] = deck_suit_counts[deck_card.base.suit] + 1
                end
            end
        end

        -- Check hand for suits
        local hand_suit_counts = {Spades = 0, Hearts = 0, Clubs = 0, Diamonds = 0}
        if G.hand and G.hand.cards then
            for _, hand_card in ipairs(G.hand.cards) do
                if hand_card.base and hand_card.base.suit then
                    hand_suit_counts[hand_card.base.suit] = hand_suit_counts[hand_card.base.suit] + 1
                end
            end
        end

        -- Combine counts to determine available suits
        for _, suit in ipairs(suits) do
            if (deck_suit_counts[suit] + hand_suit_counts[suit]) > 0 then
                table.insert(available_suits, suit)
            end
        end

        -- If no suits are available, show a message and exit
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

        -- Choose a random suit from available suits
        local selected_suit = available_suits[math.random(1, #available_suits)]
        
        -- Announce the selected suit
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
        
        -- Store cards to remove from hand
        local hand_cards_to_remove = {}
        if G.hand and G.hand.cards then
            for _, hand_card in ipairs(G.hand.cards) do
                if hand_card.base.suit == selected_suit then
                    table.insert(hand_cards_to_remove, hand_card)
                end
            end
        end

        -- Store cards to remove from deck
        local deck_cards_to_remove = {}
        if G.deck and G.deck.cards then
            for _, deck_card in ipairs(G.deck.cards) do
                if deck_card.base.suit == selected_suit then
                    table.insert(deck_cards_to_remove, deck_card)
                end
            end
        end
        
        -- Remove cards from hand first with animation
        for i, card_to_remove in ipairs(hand_cards_to_remove) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1 * i,
                func = function()
                    if card_to_remove and G.hand and G.hand.cards then
                        G.hand:remove_card(card_to_remove)
                        card_to_remove:start_dissolve()
                        -- Ensure pitch is always positive and non-zero
                        local pitch = math.max(0.5, 1 - (i-1)*0.05)
                        play_sound('card1', pitch)
                    end
                    return true
                end
            }))
        end

        -- Remove cards from deck after hand with animation
        for i, card_to_remove in ipairs(deck_cards_to_remove) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1 * (i + #hand_cards_to_remove), -- Offset delay to start after hand removal
                func = function()
                    if card_to_remove and G.deck and G.deck.cards then
                        G.deck:remove_card(card_to_remove)
                        card_to_remove:start_dissolve()
                        -- Ensure pitch is always positive and non-zero
                        local pitch = math.max(0.5, 1 - (i-1)*0.05)
                        play_sound('card1', pitch)
                    end
                    return true
                end
            }))
        end
        
        -- Update deck display, only shuffle if there are cards left
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
    pos = {x = 4, y = 0}, -- Adjust position based on your atlas
    loc_txt = {
        name = 'Crack2',
        text = {
           'Remove all cards',
            'of a {C:attention}random rank{}',
        }
    },
    config = {},
    can_use = function(self, card)
        -- Check if there are any cards in the deck or hand
        return G and (G.deck and #G.deck.cards > 0) or (G.hand and #G.hand.cards > 0)
    end,
    use = function(self, card, area, copier)
        -- List of possible ranks (2 through Ace)
        local ranks = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14} -- 11 = Jack, 12 = Queen, 13 = King, 14 = Ace
        local rank_names = {
            [2] = "2s", [3] = "3s", [4] = "4s", [5] = "5s", [6] = "6s", [7] = "7s", [8] = "8s", [9] = "9s", [10] = "10s",
            [11] = "Jacks", [12] = "Queens", [13] = "Kings", [14] = "Aces"
        }
        -- Track ranks that have cards
        local available_ranks = {}

        -- Check deck for ranks
        local deck_rank_counts = {}
        for i = 2, 14 do deck_rank_counts[i] = 0 end
        if G.deck and G.deck.cards then
            for _, deck_card in ipairs(G.deck.cards) do
                if deck_card.base and deck_card.base.id then
                    deck_rank_counts[deck_card.base.id] = deck_rank_counts[deck_card.base.id] + 1
                end
            end
        end

        -- Check hand for ranks
        local hand_rank_counts = {}
        for i = 2, 14 do hand_rank_counts[i] = 0 end
        if G.hand and G.hand.cards then
            for _, hand_card in ipairs(G.hand.cards) do
                if hand_card.base and hand_card.base.id then
                    hand_rank_counts[hand_card.base.id] = hand_rank_counts[hand_card.base.id] + 1
                end
            end
        end

        -- Combine counts to determine available ranks
        for _, rank in ipairs(ranks) do
            if (deck_rank_counts[rank] + hand_rank_counts[rank]) > 0 then
                table.insert(available_ranks, rank)
            end
        end

        -- If no ranks are available, show a message and exit
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

        -- Choose a random rank from available ranks
        local selected_rank = available_ranks[math.random(1, #available_ranks)]
        local rank_name = rank_names[selected_rank] or tostring(selected_rank)
        
        -- Announce the selected rank
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
        
        -- Store cards to remove from hand
        local hand_cards_to_remove = {}
        if G.hand and G.hand.cards then
            for _, hand_card in ipairs(G.hand.cards) do
                if hand_card.base.id == selected_rank then
                    table.insert(hand_cards_to_remove, hand_card)
                end
            end
        end

        -- Store cards to remove from deck
        local deck_cards_to_remove = {}
        if G.deck and G.deck.cards then
            for _, deck_card in ipairs(G.deck.cards) do
                if deck_card.base.id == selected_rank then
                    table.insert(deck_cards_to_remove, deck_card)
                end
            end
        end
        
        -- Remove cards from hand first with animation
        for i, card_to_remove in ipairs(hand_cards_to_remove) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1 * i,
                func = function()
                    if card_to_remove and G.hand and G.hand.cards then
                        G.hand:remove_card(card_to_remove)
                        card_to_remove:start_dissolve()
                        -- Ensure pitch is always positive and non-zero
                        local pitch = math.max(0.5, 1 - (i-1)*0.05)
                        play_sound('card1', pitch)
                    end
                    return true
                end
            }))
        end

        -- Remove cards from deck after hand with animation
        for i, card_to_remove in ipairs(deck_cards_to_remove) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1 * (i + #hand_cards_to_remove), -- Offset delay to start after hand removal
                func = function()
                    if card_to_remove and G.deck and G.deck.cards then
                        G.deck:remove_card(card_to_remove)
                        card_to_remove:start_dissolve()
                        -- Ensure pitch is always positive and non-zero
                        local pitch = math.max(0.5, 1 - (i-1)*0.05)
                        play_sound('card1', pitch)
                    end
                    return true
                end
            }))
        end
        
        -- Update deck display, only shuffle if there are cards left
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
    key = 'meth', --key
    set = 'Drugs', --the set of the card: corresponds to a consumable type
    atlas = 'Drugs', --atlas
    pos = {x = 0, y = 1}, --position in atlas
    loc_txt = {
        name = 'Methamphetamine', --name of card
        text = { --text of card
            'Placeholder'
        }
    },
   config = {
        extra = {
            cards = 4, --configurable value
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
    use = function(self,card,area,copier)
        for i = 1, #G.hand.highlighted do 
            --for every card in hand highlighted
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
            --set their rank to Jack
        end

    end,
}

----------------------------------------------
------------MOD CODE END----------------------
