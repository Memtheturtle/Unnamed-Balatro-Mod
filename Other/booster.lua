SMODS.Atlas{
    key = 'Booster',
    path = 'Booster.png',
    px = 71,
    py = 95
}

SMODS.Booster {
    key = "album_pack",
    loc_txt = {
        name = "Album Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:tarot}Album{} cards",
            "to add to your consumable slots"
        },
        group_name = "Album Pack"
    },
    atlas = "Booster",
    pos = { x = 0, y = 0 },
    cost = 4,
    weight = 1,
    kind = "Album",
    discovered = true,
    config = {
        extra = 3,
        choose = 1
    },
    select_card = "consumeables",
    create_card = function(self, card, i)
        return {
            set = "Albums",
            area = G.pack_cards,
            skip_materialize = true,
            key_append = "album_pack"
        }
    end
}

SMODS.Booster {
    key = "cmd_pack",
    loc_txt = {
        name = "CMD Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:tarot}CMD{} cards",
            "to add to your consumable slots"
        },
        group_name = "CMD Pack"
    },
    atlas = "Booster",
    pos = { x = 0, y = 0 },
    cost = 4,
    weight = 1,
    kind = "CMD",
    discovered = true,
    config = {
        extra = 3,
        choose = 1
    },
    select_card = "consumeables",
    create_card = function(self, card, i)
        return {
            set = "CMD",
            area = G.pack_cards,
            skip_materialize = true,
            key_append = "cmd_pack"
        }
    end
}

SMODS.Booster {
    key = "drug_pack",
    loc_txt = {
        name = "Drug Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:tarot}Drug{} cards",
            "to add to your consumable slots"
        },
        group_name = "Drug Pack"
    },
    atlas = "Booster",
    pos = { x = 0, y = 0 },
    cost = 4,
    weight = 1,
    kind = "Drug",
    discovered = true,
    config = {
        extra = 3,
        choose = 1
    },
    select_card = "consumeables",
    create_card = function(self, card, i)
        return {
            set = "Drugs",
            area = G.pack_cards,
            skip_materialize = true,
            key_append = "drug_pack"
        }
    end
}

SMODS.Booster {
    key = "food_pack",
    loc_txt = {
        name = "Food Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:tarot}Food{} cards",
            "to add to your consumable slots"
        },
        group_name = "Food Pack"
    },
    atlas = "Booster",
    pos = { x = 0, y = 0 },
    cost = 4,
    weight = 1,
    kind = "Food",
    discovered = true,
    config = {
        extra = 3,
        choose = 1
    },
    select_card = "consumeables",
    create_card = function(self, card, i)
        return {
            set = "Food",
            area = G.pack_cards,
            skip_materialize = true,
            key_append = "food_pack"
        }
    end
}

SMODS.Booster {
    key = "role_pack",
    loc_txt = {
        name = "Role Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:tarot}Role{} cards",
            "to add to your consumable slots"
        },
        group_name = "Role Pack"
    },
    atlas = "Booster",
    pos = { x = 0, y = 0 },
    cost = 4,
    weight = 1,
    kind = "Role",
    discovered = true,
    config = {
        extra = 3,
        choose = 1
    },
    select_card = "consumeables",
    create_card = function(self, card, i)
        return {
            set = "Roles",
            area = G.pack_cards,
            skip_materialize = true,
            key_append = "role_pack"
        }
    end
}