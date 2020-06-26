


function find_nodes_in_area_cache.register(nodename)
  -- node name
  find_nodes_in_area_cache.nodenames[nodename] = true

  local nodedef = minetest.registered_nodes[nodename]

  if not nodedef then
    minetest.log("warn", "[find_nodes_in_area_cache] node not found: " .. nodename)
    return
  end

  -- node id
  local content_id = minetest.get_content_id(nodename)
  find_nodes_in_area_cache.node_id_map[content_id] = nodename


  -- track place/destroy
  local old_after_place_node = nodedef.after_place_node
  local old_after_destruct = nodedef.after_destruct

  minetest.override_item(nodename, {
    after_place_node = function(pos, placer)
      find_nodes_in_area_cache.add(nodename, pos)
      if type(old_after_place_node) == "function" then
        return old_after_place_node(pos, placer)
      end
    end,
    after_destruct = function(pos, oldnode)
      find_nodes_in_area_cache.remove(nodename, pos)
      if type(old_after_destruct) == "function" then
        return old_after_destruct(pos, oldnode)
      end
    end
  })
end

function find_nodes_in_area_cache.register_group(groupname)
  minetest.register_on_mods_loaded(function()
    find_nodes_in_area_cache.groupnames[groupname] = true
    local nodenames = {}

    for nodename, def in pairs(minetest.registered_nodes) do
      if def.groups[groupname] then
        table.insert(nodenames, nodename)
        find_nodes_in_area_cache.register(nodename)
      end
    end

    -- add found node names
    find_nodes_in_area_cache.group_nodes_map[groupname] = nodenames
  end)
end
