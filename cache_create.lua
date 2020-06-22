

function find_nodes_in_area_cache.create_entry(mapblock)
  print("[cache] creating entry for mapblock " .. dump(mapblock))
  local entry = {
    mtime = os.time(),
    blocks = {}
  }

  -- collect node-ids and cache in map
  -- TODO: do this at load-time
  local node_id_map = {}
  for nodename in pairs(find_nodes_in_area_cache.nodenames) do
    local content_id = minetest.get_content_id(nodename)
    node_id_map[content_id] = nodename
    entry.blocks[nodename] = {}
  end

  local pos1, pos2 = find_nodes_in_area_cache.get_blocks_from_mapblock(mapblock)
  local manip = minetest.get_voxel_manip()
  local e1, e2 = manip:read_from_map(pos1, pos2)
  local area = VoxelArea:new({MinEdge=e1, MaxEdge=e2})

  local node_data = manip:get_data()

	-- loop over all blocks and fill cid,param1 and param2
  for x=pos1.x,pos2.x do
  for y=pos1.y,pos2.y do
  for z=pos1.z,pos2.z do
    local i = area:index(x,y,z)

		local node_id = node_data[i]
    local nodename = node_id_map[node_id]
    if nodename then
      table.insert(entry.blocks[nodename], {x=x, y=y, z=z})
    end
  end
  end
  end

  return entry
end
