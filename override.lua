

local old_find_nodes_in_area = minetest.find_nodes_in_area

minetest.find_nodes_in_area = function(pos1, pos2, nodenames)
  return old_find_nodes_in_area(pos1, pos2, nodenames)
end
