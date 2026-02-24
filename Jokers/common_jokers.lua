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
----------------------------------------------
------------MOD CODE END----------------------
