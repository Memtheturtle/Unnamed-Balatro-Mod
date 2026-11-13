-- Jimball 2 Joker

    GCBM_pointer_dt = 0
    GCBM_jimball2_dt = 0

    local Game_update_ref = Game.update
    ---@diagnostic disable-next-line: duplicate-set-field
    function Game:update(dt)
        Game_update_ref(self, dt)

        GCBM_pointer_dt = GCBM_pointer_dt + dt
        GCBM_jimball2_dt = GCBM_jimball2_dt + dt

        if G.P_CENTERS and G.P_CENTERS.c_gcbm_pointer and GCBM_pointer_dt > 0.5 then
            GCBM_pointer_dt = 0
            local pointerobj = G.P_CENTERS.c_gcbm_pointer
            pointerobj.pos.x = (pointerobj.pos.x == 4) and 5 or 4
        end
        if G.P_CENTERS and G.P_CENTERS.j_gcbm_jimball2 and GCBM_jimball2_dt > 0.1 then
            GCBM_jimball2_dt = 0
            local jimball2obj = G.P_CENTERS.j_gcbm_jimball2
            if jimball2obj.pos.x == 5 and jimball2obj.pos.y == 6 then
                jimball2obj.pos.x = 0
                jimball2obj.pos.y = 0
            elseif jimball2obj.pos.x < 8 then
                jimball2obj.pos.x = jimball2obj.pos.x + 1
            elseif jimball2obj.pos.y < 6 then
                jimball2obj.pos.x = 0
                jimball2obj.pos.y = jimball2obj.pos.y + 1
            end
        end
    end

-- Unregistered Hypercam 2 Joker

    local hypercam_path = "mods/Unnamed-Balatro-Mod/assets/other/hypercam.png"
    local hypercam_img = nil
    local hypercam_checked = false

    local HYPERCAM_SIZE = 0.5

    local old_love_draw = love.draw
    ---@diagnostic disable-next-line: duplicate-set-field
    love.draw = function(...)
        old_love_draw(...)

        if G.GCBM_HYPERCAM then
            if not hypercam_checked then
                hypercam_checked = true
                if love.filesystem.getInfo(hypercam_path) then
                    hypercam_img = love.graphics.newImage(hypercam_path)
                    hypercam_img:setFilter('linear', 'linear')
                end
            end

            if hypercam_img then
                love.graphics.push('all')
                love.graphics.setCanvas()
                love.graphics.setShader()
                love.graphics.origin()
                love.graphics.setColor(1, 1, 1, 1)

                local scale = (love.graphics.getHeight() / 1080) * HYPERCAM_SIZE
                love.graphics.draw(hypercam_img, 0, 0, 0, scale, scale)

                love.graphics.pop()
            end
        end
    end

-- Gaster Joker

    local gaster_path = "mods/Unnamed-Balatro-Mod/assets/other/Gaster.jpg"
    local gaster_img = nil
    local gaster_checked = false
    local JUMPSCARE_DURATION = 1000000.0

    G.GCBM_GASTER_TIME = 0
    ---@diagnostic disable-next-line duplicate-set-field
    function gcbm_trigger_gaster()
        G.GCBM_GASTER_TIME = JUMPSCARE_DURATION
    end

    local old_love_draw_gaster = love.draw
    love.draw = function(...)
        old_love_draw_gaster(...)

        if G.GCBM_GASTER_TIME and G.GCBM_GASTER_TIME > 0 then
            G.GCBM_GASTER_TIME = G.GCBM_GASTER_TIME - love.timer.getDelta()

            if not gaster_checked then
                gaster_checked = true
                if love.filesystem.getInfo(gaster_path) then
                    gaster_img = love.graphics.newImage(gaster_path)
                    gaster_img:setFilter('linear', 'linear')
                end
            end

            if gaster_img then
                love.graphics.push('all')
                love.graphics.setCanvas()
                love.graphics.setShader()
                love.graphics.origin()
                love.graphics.setColor(1, 1, 1, 1)

                local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
                local iw, ih = gaster_img:getWidth(), gaster_img:getHeight()

                local scale = math.max(sw / iw, sh / ih)
                local x = (sw - iw * scale) / 2
                local y = (sh - ih * scale) / 2

                love.graphics.draw(gaster_img, x, y, 0, scale, scale)
                love.graphics.pop()
            end
        end
    end

SMODS.Atlas{
    key = 'Common_jokers',
    path = 'Common_jokers.png',
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = 'Jimball',
    path = 'Jimball.png',
    px = 71,
    py = 95
}

SMODS.Sound({
	key = "music_ksi",
	path = "music_ksi.mp3",
	sync = false,
	pitch = 1,
	select_music_track = function()
		return next(find_joker("j_gcbm_ksi"))
	end,
})

SMODS.Sound({
	key = "music_morty",
	path = "music_morty.mp3",
	sync = false,
	pitch = 1,
	select_music_track = function()
		return next(find_joker("j_gcbm_morty"))
	end,
})

SMODS.Sound({
	key = "music_jimball",
	path = "music_jimball.mp3",
	sync = false,
	pitch = 1,
	select_music_track = function()
		return next(find_joker("j_gcbm_jimball2"))
	end,
})

SMODS.Sound({
	key = "gaster",
	path = "gaster.mp3",
})

SMODS.Joker{
    key = 'gaster',
    loc_txt = {
        name = 'W. D. Gaster',
        text = {
          '{C:attention}DARK, DARKER, YET DARKER{}',
        },
    },
    atlas = 'Common_jokers',
    rarity = 1,
    cost = 1,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    add_to_deck = function(self, card, from_debuff)
        if from_debuff then return end
        if pseudorandom('gaster') < 0.1 then
            G.SETTINGS.SOUND.music_volume = 0
            play_sound('gcbm_gaster')
            gcbm_trigger_gaster()
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.8,
                blocking = true,
                func = function()
                    if G.STAGE ~= G.STAGES.RUN then return true end
                    G.FUNCS.exit_overlay_menu()
                    if remove_save then
                        remove_save()
                    else
                        G.SAVED_GAME = nil
                        love.filesystem.remove(G.SETTINGS.profile .. '/save.jkr')
                    end
                    G:delete_run()
                    G:main_menu()
                    return true
                end
            }))
        end
    end,
}

SMODS.Joker{
    key = 'morty',
    loc_txt = {
        name = 'Gucci Morty',
        text = {
          'Swag',
        },
    },
    atlas = 'Common_jokers',
    rarity = 1,
    cost = 0,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    calculate = function(self,card,context) 
        self.select_music_track = "music_morty"
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'jimball2',
    loc_txt = {
        name = 'Jimball 2',
        text = {
          'You already know',
          '{s:0.8}{C:inactive}Art by Memtheturtle{}',
        },
    },
    atlas = 'Jimball',
    rarity = 1,
    cost = 0,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 0},
    calculate = function(self,card,context) 
        self.select_music_track = "music_jimball"
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'ksi',
    loc_txt = {
        name = 'KSI',
        text = {
          'Plays Thick of It',
          'Thats all.',
          '{s:0.8}{C:inactive}Art by Theskycrusher{}',
        },
    },
    atlas = 'Common_jokers',
    rarity = 1,
    cost = 0,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    calculate = function(self,card,context) 
        self.select_music_track = "music_ksi"
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'sigma',
    loc_txt = {
        name = 'Sigmacide',
        text = {
          '{C:attention}Oh No{}',
          '{s:0.8}{C:inactive}Art by Theskycrusher{}',
        },
    },
    atlas = 'Common_jokers',
    rarity = 1,
    cost = 1,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    calculate = function(self,card,context) 
        if context.setting_blind then
            card:start_dissolve()
        end
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'hypercam',
    loc_txt = {
        name = 'Unregistered Hypercam 2',
        text = {
            '{C:attention}Unregistered Hypercam 2{}',
        },
    },
    atlas = 'Common_jokers',
    rarity = 1,
    cost = 2,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    add_to_deck = function(self, card, from_debuff)
        G.GCBM_HYPERCAM = true
        if not G.SLIDESHOW_ORIGINAL_FPS_CAP then
            G.SLIDESHOW_ORIGINAL_FPS_CAP = G.FPS_CAP or 500
        end
        G.FPS_CAP = 10
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GCBM_HYPERCAM = false
        local others = 0
        for _, j in ipairs(SMODS.find_card('j_gcbm_hypercam')) do
            if j ~= card then others = others + 1 end
        end
        if others == 0 then
            G.FPS_CAP = G.SLIDESHOW_ORIGINAL_FPS_CAP or 500
            G.SLIDESHOW_ORIGINAL_FPS_CAP = nil
        end
    end,
    update = function(self, card, dt)
        if card.area == G.jokers and G.FPS_CAP ~= 10 then
            if not G.SLIDESHOW_ORIGINAL_FPS_CAP then
                G.SLIDESHOW_ORIGINAL_FPS_CAP = G.FPS_CAP or 500
            end
            G.FPS_CAP = 10
        end
    end,
}