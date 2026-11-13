if GCBM_NET then return end
GCBM_NET = {}

local dir = SMODS.current_mod.path .. "Cache/"
local TTL = 6 * 60 * 60

local function stale(name)
    local f = io.open(dir .. name .. ".stamp", "r")
    if not f then return true end
    local t = tonumber(f:read("*a")); f:close()
    return not t or (os.time() - t) > TTL
end

function GCBM_NET.touch(name)
    local f = io.open(dir .. name .. ".stamp", "w")
    if f then f:write(tostring(os.time())); f:close() end
end

function GCBM_NET.queue(name, fn)
    if stale(name) then
        fn(function() GCBM_NET.touch(name) end)
    end
end