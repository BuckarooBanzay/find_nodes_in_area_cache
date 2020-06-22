


function find_nodes_in_area_cache.register(nodename)
  find_nodes_in_area_cache.nodenames[nodename] = true

  local nodedef = minetest.registered_nodes[nodename]

  -- track place/destroy
  local old_after_place_node = nodedef.after_place_node
  local old_after_destruct = nodedef.after_destruct

  minetest.override_item(nodename, {
    after_place_node = function(pos, placer)
      find_nodes_in_area_cache.add(nodename, pos)
      return old_after_place_node(pos, placer)
    end,
    after_destruct = function(pos, oldnode)
      find_nodes_in_area_cache.remove(nodename, pos)
      return old_after_destruct(pos, oldnode)
    end
  })
end
