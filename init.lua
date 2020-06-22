
find_nodes_in_area_cache = {
  nodenames = {},
  node_id_map = {}
}

local MP = minetest.get_modpath("find_nodes_in_area_cache")

dofile(MP.."/functions.lua")
dofile(MP.."/cache.lua")
dofile(MP.."/cache_create.lua")
dofile(MP.."/cache_invalidate.lua")
dofile(MP.."/override.lua")
dofile(MP.."/register.lua")
dofile(MP.."/register_mods.lua")
