----------------------------------------------
------------MOD CODE -------------------------
GCBM_pointer_dt = 0
GCBM_jimball2_dt = 0

local Game_update_ref = Game.update
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

local hypercam_path = "mods/Unnamed-Balatro-Mod/assets/hypercam.png"
local hypercam_img = nil
local hypercam_checked = false

local HYPERCAM_SIZE = 0.5 -- 1 = full size of the image, 0.5 = half, etc.

local old_love_draw = love.draw
love.draw = function(...)
    old_love_draw(...)

    if G.GCBM_HYPERCAM then
        -- Load the image once, if it exists
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

SMODS.Atlas{
    key = 'Common_jokers', --atlas key
    path = 'Common_jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas{
    key = 'Jimball', --atlas key
    path = 'Jimball.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
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
	key = "music_jimball",
	path = "music_jimball.mp3",
	sync = false,
	pitch = 1,
	select_music_track = function()
		return next(find_joker("j_gcbm_jimball2")) 
	end,
})


SMODS.Joker{
    key = 'jimball2', --joker key
    loc_txt = { -- local text
        name = 'Jimball 2',
        text = {
          'You already know',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jimball', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 0, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false,  --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 2, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    
   
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
            select_music_track = "music_jimball"
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'ksi', --joker key
    loc_txt = { -- local text
        name = 'KSI',
        text = {
          'Plays Thick of It',
          'Thats all.',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Common_jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 0, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false,  --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 1, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    
   
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context) 
            select_music_track = "music_ksi"
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

SMODS.Joker{
    key = 'sigma', --joker key
    loc_txt = { -- local text
        name = 'Sigmacide',
        text = {
          '{C:attention}Oh No{}', 
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Common_jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 1, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right

   
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then 
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,

    calculate = function(self,card,context) 
        if context.setting_blind then
         card:start_dissolve()
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
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
        -- Remember the player's original cap so we can put it back
        if not G.SLIDESHOW_ORIGINAL_FPS_CAP then
            G.SLIDESHOW_ORIGINAL_FPS_CAP = G.FPS_CAP or 500
        end
        G.FPS_CAP = 10
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GCBM_HYPERCAM = false
    -- Only restore if no other copy of this joker is still owned
        local others = 0
        for _, j in ipairs(SMODS.find_card('j_gcbm_hypercam')) do
         if j ~= card then others = others + 1 end
        end
        if others == 0 then
          G.FPS_CAP = G.SLIDESHOW_ORIGINAL_FPS_CAP or 500
          G.SLIDESHOW_ORIGINAL_FPS_CAP = nil
     end
    end,

    -- Re-apply after loading a save, since add_to_deck may not fire then
    update = function(self, card, dt)
        if card.area == G.jokers and G.FPS_CAP ~= 10 then
            if not G.SLIDESHOW_ORIGINAL_FPS_CAP then
                G.SLIDESHOW_ORIGINAL_FPS_CAP = G.FPS_CAP or 500
            end
            G.FPS_CAP = 10
        end
    end,
}

----------------------------------------------
------------MOD CODE END----------------------
