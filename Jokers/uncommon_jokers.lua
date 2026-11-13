-- Parental Controls Joker

    local PC = { active = false, a = 0, b = 0, input = "", prompt = "", display = "_" }

    local function new_problem()
        PC.a = math.floor(pseudorandom("pc_a") * 90) + 10   -- 10 to 99
        PC.b = math.floor(pseudorandom("pc_b") * 90) + 10   -- 10 to 99
        PC.input = ""
        PC.prompt = PC.a .. " x " .. PC.b .. " = ?"
        PC.display = "_"
    end

    local function refresh_display()
        PC.display = (PC.input == "") and "_" or PC.input
    end

    local function press_digit(d)
        if #PC.input < 4 then
            PC.input = PC.input .. d
            refresh_display()
            play_sound("button", 1, 0.5)
        end
    end

    local function press_back()
        PC.input = PC.input:sub(1, -2)
        refresh_display()
    end

    local function submit()
        if tonumber(PC.input) == PC.a * PC.b then
            PC.active = false
            play_sound("coin1")
            G.FUNCS.exit_overlay_menu()
        else
            play_sound("cancel")
            G.ROOM.jiggle = G.ROOM.jiggle + 3
            new_problem()
        end
    end

    G.FUNCS.pc_key = function(e) press_digit(e.config.ref_table.key) end
    G.FUNCS.pc_back = function(e) press_back() end
    G.FUNCS.pc_submit = function(e) submit() end

    local old_key_press = Controller.key_press_update
    ---@diagnostic disable-next-line: duplicate-set-field
    function Controller:key_press_update(key, dt)
        if PC.active then
            local d = key:match("^(%d)$") or key:match("^kp(%d)$")
            if d then press_digit(d)
            elseif key == "backspace" then press_back()
            elseif key == "return" or key == "kpenter" then submit() end
            return
        end
        return old_key_press(self, key, dt)
    end

    local function num_button(label)
        return UIBox_button({
            label = { label }, button = "pc_key", ref_table = { key = label },
            minw = 1, minh = 0.8, scale = 0.5, colour = G.C.BLUE,
        })
    end

    local function row(...)
        local nodes = {}
        for _, label in ipairs({ ... }) do
            nodes[#nodes + 1] = { n = G.UIT.C, config = { padding = 0.05 }, nodes = { num_button(label) } }
        end
        return { n = G.UIT.R, config = { align = "cm" }, nodes = nodes }
    end

    local function pc_ui()
        return create_UIBox_generic_options({
            no_back = true,
            contents = {
                { n = G.UIT.R, config = { align = "cm", padding = 0.1 }, nodes = {
                    { n = G.UIT.T, config = { text = "PARENTAL CONTROLS", scale = 0.5, colour = G.C.RED, shadow = true } } } },
                { n = G.UIT.R, config = { align = "cm", padding = 0.1 }, nodes = {
                    { n = G.UIT.O, config = { object = DynaText({
                        string = { { ref_table = PC, ref_value = "prompt" } },
                        colours = { G.C.WHITE }, scale = 0.9, shadow = true }) } } } },
                { n = G.UIT.R, config = { align = "cm", padding = 0.1 }, nodes = {
                    { n = G.UIT.O, config = { object = DynaText({
                        string = { { ref_table = PC, ref_value = "display" } },
                        colours = { G.C.GOLD }, scale = 0.9, shadow = true }) } } } },
                row("1", "2", "3"),
                row("4", "5", "6"),
                row("7", "8", "9"),
                { n = G.UIT.R, config = { align = "cm" }, nodes = {
                    { n = G.UIT.C, config = { padding = 0.05 }, nodes = { UIBox_button({
                        label = { "DEL" }, button = "pc_back", minw = 1, minh = 0.8, scale = 0.45, colour = G.C.RED }) } },
                    { n = G.UIT.C, config = { padding = 0.05 }, nodes = { num_button("0") } },
                    { n = G.UIT.C, config = { padding = 0.05 }, nodes = { UIBox_button({
                        label = { "OK" }, button = "pc_submit", minw = 1, minh = 0.8, scale = 0.45, colour = G.C.GREEN }) } },
                } },
            },
        })
    end

SMODS.Atlas{
    key = 'Uncommon_jokers',
    path = 'Uncommon_jokers.png',
    px = 71,
    py = 95
}

SMODS.Joker {
    key = "parental_controls",
    loc_txt = {
        name = "Parental Controls",
        text = {
            "When {C:attention}Blind{} is selected,",
            "you must solve a",
            "{C:attention}multiplication problem{}",
        },
    },
    atlas = 'Uncommon_jokers',
    rarity = 2,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.5,
                func = function()
                    new_problem()
                    PC.active = true
                    G.FUNCS.overlay_menu({ definition = pc_ui() })
                    return true
                end,
            }))
        end
    end,
}

SMODS.Joker{
    key = 'maxwell',
    loc_txt = {
        name = 'Maxwell',
        text = {
            'Gains {C:chips}+#1#{} Chip and {C:mult}+#2#{} Mult',
            'for every card played',
            '{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips and {C:mult}+#4#{C:inactive} Mult)',
        },
    },
    atlas = 'Uncommon_jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    config = {
        extra = {
            chip_gain = 1,
            mult_gain = 1,
            chips = 0,
            mult = 0,
        }
    },
    loc_vars = function(self, info_queue, card)
        local e = card.ability.extra
        return { vars = { e.chip_gain, e.mult_gain, e.chips, e.mult } }
    end,
    calculate = function(self, card, context)
        local e = card.ability.extra
        if context.before and not context.blueprint then
            local played = #context.full_hand
            e.chips = e.chips + e.chip_gain * played
            e.mult = e.mult + e.mult_gain * played
            return {
                message = 'Upgraded!',
                colour = G.C.CHIPS,
                card = card,
            }
        end
        if context.joker_main then
            return {
                chips = e.chips,
                mult = e.mult,
            }
        end
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'mike',
    loc_txt = {
        name = 'Mike Ehrmantraut',
        text = {
          'When blind is selected,',
          'create {C:attention}3{} Negative {C:attention}Methamphetamine{}',
        },
    },
    atlas = 'Uncommon_jokers',
    rarity = 2,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    calculate = function(self,card,context) 
        if context.setting_blind then
            for _ = 1, 3 do
                SMODS.add_card({ set = "Drugs", key = 'c_gcbm_meth', area = G.consumeables, edition = 'e_negative' })
            end
        end
    end,
    in_pool = function(self)
        return true
    end,
}

SMODS.Joker{
    key = 'spoil',
    loc_txt = {
        name = 'This Card Will Spoil You',
        text = {
          'When blind is selected,',
          'spoil {C:attention}1{} piece of media',
        },
    },
    atlas = 'Uncommon_jokers',
    rarity = 2,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    calculate = function(self, card, context)
        if context.setting_blind then
            local spoilers = {
                "Walter White cooks meth and dies",
                "Darth Vader is Luke's father",
                "memtheturtle dies of stroke on may 27, 2029",
                "Craig opens your camera",
                "tsuki is dead",
                "Granny dies in Celeste",
                "Robert F Kennedy dies",
                "They tackled the pentagon",
                "Iron Man dies in Avengers",
                "PerfectLKM will return in Avengers Doomsday",
                "Sans is the secret boss",
                "The cake is a lie",
                "CarlJR wins another world cup",
                "Perfect beats Zaphkiel",
                "Misfire 2 is created",
                "William afton gets springlocked",
                "mem comes out as straight",
                "avrg never beats sevvend",
                "doggie verified grief",
                "npesta verified kenos",
                "avrg boyfriend dies",
                "this mod releases in 1.0",
            }
            local msg = pseudorandom_element(spoilers, pseudoseed('gcbm_spoil'))
            local hold_time = 4
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    attention_text({
                        text = msg,
                        scale = 0.9,
                        hold = hold_time,
                        major = card,
                        align = "cm",
                        silent = true,
                    })
                    play_sound('generic1', 1, 0.6)
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = hold_time,
                func = function() return true end
            }))
        end
    end,
}