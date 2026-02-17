----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Tarots', --atlas key
    path = 'Tarots.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}



SMODS.Consumable{
    key = 'women', --key
    set = 'Tarot', --the set of the card: corresponds to a consumable type
    atlas = 'Tarots', --atlas
    pos = {x = 9, y = 0}, --position in atlas
    loc_txt = {
        name = 'Anime Women', --name of card
        text = { --text of card
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
}

----------------------------------------------
------------MOD CODE END----------------------