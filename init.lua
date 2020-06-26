
find_nodes_in_area_cache = {

  -- list of nodenames: { "protector:protect" = true }
  nodenames = {},

  -- map of groupnames: { "advtrains_track" = true }
  groupnames = {},

  -- group to nodes association: { "advtrains_track" = {"advtrains:dtrack"} }
  group_nodes_map = {},

  -- node id map: { 255 = "protector:protect" }
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
