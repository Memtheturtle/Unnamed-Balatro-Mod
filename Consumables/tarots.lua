SMODS.Atlas{
    key = 'Tarots',
    path = 'Tarots.png',
    px = 71,
    py = 95
}

SMODS.Sound({
    key = "me_and_the_birds",
    path = "me_and_the_birds.mp3",
})

SMODS.Consumable{
    key = 'men',
    set = 'Tarot',
    atlas = 'Tarots',
    pos = {x = 9, y = 0},
    loc_txt = {
        name = 'Anime Men',
        text = {
            '{C:green}#1# in 10{} chance to spawn a Positive {C:attention}Soul{} card'
        }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {G.GAME.probabilities.normal}} 
    end,
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        if pseudorandom('men') < G.GAME.probabilities.normal / 10 then
            SMODS.add_card({ set = "Tarot", key = 'c_soul', area = G.consumeables})
        end
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Consumable {
    key = "sisyphus",
    set = 'Tarot',
    atlas = 'Tarots',
    pos = {x = 9, y = 0},
    loc_txt = {
        name = "The Sisyphus",
        text = {
            'Sets your chips to {C:attention}99%{} of',
            'the needed chips to win the blind,',
            'then discards all but {C:attention}1{} card',
        }
    },
    can_use = function(self, card)
        return not not (G.GAME and G.GAME.blind and G.GAME.blind.chips
            and G.hand and G.hand.cards and #G.hand.cards > 0)
    end,
    use = function(self, card, area, copier)
        play_sound('gcbm_me_and_the_birds')
        local target = math.floor(G.GAME.blind.chips * 0.99)

        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot2', 0.76, 0.4)
                card:juice_up(0.3, 0.5)
                G.GAME.chips = target
                if G.hand_text_area and G.hand_text_area.game_chips then
                    G.hand_text_area.game_chips:update_text()
                end
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            func = function()
                if G.hand and #G.hand.cards > 1 then
                    local keep = pseudorandom_element(G.hand.cards, pseudoseed('cmd_help'))
                    local old_limit = G.hand.config.highlighted_limit
                    G.hand.config.highlighted_limit = #G.hand.cards
                    G.hand:unhighlight_all()
                    for _, c in ipairs(G.hand.cards) do
                        if c ~= keep then
                            G.hand:add_to_highlighted(c, true)
                        end
                    end
                    G.FUNCS.discard_cards_from_highlighted(nil, true)
                    G.hand.config.highlighted_limit = old_limit
                end
                return true
            end
        }))
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Consumable{
    key = 'women',
    set = 'Tarot',
    atlas = 'Tarots',
    pos = {x = 9, y = 0},
    loc_txt = {
        name = 'Anime Women',
        text = {
            '{C:green}#1# in 10{} chance to spawn a Negative {C:attention}Soul{} card'
        }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {G.GAME.probabilities.normal}} 
    end,
    can_use = function(self,card)
       return true
    end,
    use = function(self,card,area,copier)
        if pseudorandom('women') < G.GAME.probabilities.normal / 10 then
            SMODS.add_card({ set = "Tarot", key = 'c_soul', area = G.consumeables, edition = 'e_negative'})
        end
    end,
    in_pool = function(self)
        return true
    end,
}