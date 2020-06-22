
find_nodes_in_area_cache = {
  nodenames = {}
}

local MP = minetest.get_modpath("find_nodes_in_area_cache")

dofile(MP.."/cache.lua")
dofile(MP.."/override.lua")
dofile(MP.."/register.lua")

find_nodes_in_area_cache.register("protector:protect")
find_nodes_in_area_cache.register("protector:protect2")
find_nodes_in_area_cache.register("protector:protect_hidden")

-- TODO: jumpdrive compat
