
if minetest.get_modpath("protector") then
  find_nodes_in_area_cache.register("protector:protect")
  find_nodes_in_area_cache.register("protector:protect2")
  find_nodes_in_area_cache.register("protector:protect_hidden")
end

if minetest.get_modpath("priv_protector") then
  find_nodes_in_area_cache.register("priv_protector:protector")
end

if minetest.get_modpath("xp_protector") then
  find_nodes_in_area_cache.register("xp_redo:protector")
end

if minetest.get_modpath("vacuum") then
  find_nodes_in_area_cache.register("vacuum:airpump")
end

if minetest.get_modpath("jumpdrive") then
  local old_jumpdrive_move = jumpdrive.move

  jumpdrive.move = function(source_pos1, source_pos2, target_pos1, target_pos2)
    old_jumpdrive_move(source_pos1, source_pos2, target_pos1, target_pos2)

    find_nodes_in_area_cache.invalidate_area(source_pos1, source_pos2)
    find_nodes_in_area_cache.invalidate_area(target_pos1, target_pos2)
  end
end

if minetest.get_modpath("advtrains") then
  find_nodes_in_area_cache.register_group("advtrains_track")
end
