----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Legendary_jokers', --atlas key
    path = 'Legendary_jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}




SMODS.Sound({
	key = "music_lefave",
	path = "music_lefave.mp3",
	sync = false,
	pitch = 1,
	volume = 6,
	select_music_track = function()
		return next(find_joker("j_gcbm_djlefave")) 
	end,
})

SMODS.Joker({
    key = 'djlefave',
    loc_txt = {
        name = 'DJ LeFave',
        text = {
            'When {C:attention}added{},',
            'start an {C:legendary}EPIC DANCE PARTY{}',
            '{C:green}+#1# Mult{} per beat drop',
        },
    },

    atlas = 'Backyardigans_jokers',
    rarity = 4,
    cost = 15,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    config = {
        extra = {
            mult = 4,
            party_active = false,
            beat = 0,
        }
    },

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult}}
    end,

    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.party_active = true
        card.ability.extra.beat = 0

        -- DEFINE THE RAINBOW COLORS
        local party_colours = {
            G.C.RED, G.C.BLUE, G.C.GREEN,
            G.C.GOLD, G.C.PURPLE, G.C.ORANGE,
            {0.9, 0.1, 0.8, 1}, -- hot pink
            {0.1, 0.9, 0.9, 1}, -- cyan
            {1.0, 0.5, 0.0, 1}, -- deep orange
        }

        local hype_messages = {
            '🎵 BANGER!!', '🔥 FIRE!!', '🕺 GET DOWN!!',
            '💥 DROP IT!!', '🎧 DJ IN DA HOUSE!!', '⚡ ELECTRIC!!',
            '🌈 RAINBOW!!', '🎉 LETS GOOO!!', '💃 DANCE!!',
            '🚨 ALARM!!', '👑 KING!!', '🎶 MUSIC!!',
            '🥳 PARTY!!', '💫 STARDUST!!', '🔊 LOUD!!',
        }


        -- play the in game sound effects as music (chain them for a "beat")
        local function play_beat_sounds()
            play_sound('card1', 1.0, 0.6)
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.15, blocking = false,
                func = function()
                    play_sound('card1', 1.3, 0.5)
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.3, blocking = false,
                func = function()
                    play_sound('card1', 1.6, 0.4)
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.45, blocking = false,
                func = function()
                    play_sound('tarot1', 1.0, 0.7)
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7, blocking = false,
                func = function()
                    play_sound('tarot1', 0.8, 0.9)
                    return true
                end
            }))
        end

        -- THE RECURSIVE PARTY LOOP
        local function party_loop()
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.8,
                blocking = false,
                func = function()
                    -- check if DJ LeFave is still in the deck
                    if not card.ability.extra.party_active or card.area ~= G.jokers then
                        return true -- stop the loop, party is over
                    end

                    card.ability.extra.beat = card.ability.extra.beat + 1
                    local beat = card.ability.extra.beat

                    -- SHAKE THE WHOLE ROOM EVERY BEAT
                    G.ROOM.jiggle = 2 + math.sin(beat) * 1.5

                    -- JUICE THE DJ CARD ITSELF HARD
                    juice_card(card)
                    card.T.r = math.sin(beat * 0.5) * 0.15 -- wobble rotation

                    -- PICK RANDOM COLOR AND MESSAGE
                    local colour = party_colours[math.random(#party_colours)]
                    local msg = hype_messages[math.random(#hype_messages)]

                    -- SPAM MESSAGES ON ALL JOKERS WITH DIFFERENT COLORS
                    if G.jokers and G.jokers.cards then
                        for i, joker in ipairs(G.jokers.cards) do
                            local jcolour = party_colours[((beat + i) % #party_colours) + 1]
                            card_eval_status_text(joker, 'extra', nil, nil, nil, {
                                message = hype_messages[math.random(#hype_messages)],
                                colour = jcolour,
                            })
                            -- make every joker bounce too
                            juice_card(joker)
                        end
                    end

                    -- BIG MESSAGE ON DJ LEFAVE
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = msg,
                        colour = colour,
                    })

                    -- EVERY 4 BEATS = MEGA DROP
                    if beat % 4 == 0 then
                        G.ROOM.jiggle = 6 -- MASSIVE SHAKE
                        play_sound('tarot1', 0.5, 1.0) -- deep bass drop sound
                        play_sound('card1', 2.0, 0.8)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = '💥 BEAT DROP!! 💥',
                            colour = G.C.GOLD,
                        })
                        -- flash all jokers gold on the drop
                        if G.jokers and G.jokers.cards then
                            for _, joker in ipairs(G.jokers.cards) do
                                card_eval_status_text(joker, 'extra', nil, nil, nil, {
                                    message = '💥 DROP!!',
                                    colour = G.C.GOLD,
                                })
                                juice_card(joker)
                            end
                        end
                    end

                    -- EVERY 8 BEATS = LEGENDARY MOMENT
                    if beat % 8 == 0 then
                        G.ROOM.jiggle = 10 -- INSANE SHAKE
                        play_sound('negative', 1.0, 1.0)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = '👑 LEGENDARY DROP!! 👑',
                            colour = {0.9, 0.1, 0.8, 1}, -- hot pink
                        })
                    end

                    -- beat sounds
                    play_beat_sounds()

                    -- RECURSE: schedule the next beat
                    party_loop()

                    return true
                end
            }))
        end

        -- OPENING CEREMONY
        G.E_MANAGER:add_event(Event({
            func = function()
                G.ROOM.jiggle = 8
                play_sound('negative', 1.2, 1.0) -- dramatic entrance sound
                play_sound('tarot1', 0.7, 0.9)
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = '🎧 DJ LEFAVE IN THE HOUSE!! 🎧',
                    colour = G.C.GOLD,
                })
                if G.jokers and G.jokers.cards then
                    for i, joker in ipairs(G.jokers.cards) do
                        card_eval_status_text(joker, 'extra', nil, nil, nil, {
                            message = '🎉 PARTY TIME!! 🎉',
                            colour = party_colours[i % #party_colours + 1],
                        })
                        juice_card(joker)
                    end
                end
                return true
            end
        }))

        -- KICK OFF THE LOOP
        party_loop()
    end,

    remove_from_deck = function(self, card, from_debuff)
        -- KILL THE PARTY
       
        card.ability.extra.party_active = false
        G.ROOM.jiggle = 0
        card.T.r = 0 -- reset rotation

        play_sound('tarot1', 0.3, 0.5) -- sad slow sound

        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = '😢 Party Over...',
            colour = G.C.RED,
        })

        if G.jokers and G.jokers.cards then
            for _, joker in ipairs(G.jokers.cards) do
                card_eval_status_text(joker, 'extra', nil, nil, nil, {
                    message = '😭 nooo...',
                    colour = G.C.RED,
                })
            end
        end
    end,

    calculate = function(self, card, context)
         
        select_music_track = "music_lefave"
        if context.joker_main then
            local beat = card.ability.extra.beat
            -- mult gets BIGGER the longer the party has been going
            local bonus = card.ability.extra.mult + math.floor(beat / 4)
            return {
                card = card,
                mult_mod = bonus,
                message = '+' .. bonus .. ' 🎵',
                colour = G.C.MULT
            }
        end
    end,
})
