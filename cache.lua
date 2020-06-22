
--[[
cache = {
  ["mapblock-hash"] = {
    mtime = 123,
    blocks = {
      ["protector:protect"] = {
        {x=1, y=2, z=3},
        {x=1, y=2, z=3}
      },
      ["protector:protect2"] = {
        {x=2, y=4, z=100}
      }
    }
  },
  ["..."] = {}
}
--]]
local cache = {}

function find_nodes_in_area_cache.get_entry(mapblock)
  local hash = minetest.hash_node_position(mapblock)
  local entry = cache[hash]
  if not entry then
    entry = find_nodes_in_area_cache.create_entry(mapblock)
    cache[hash] = entry
  end
  -- TODO: cache expiration
  return entry
end

function find_nodes_in_area_cache.get(pos1, pos2, nodenames)
  pos1, pos2 = find_nodes_in_area_cache.sort_pos(pos1, pos2)

  local mapblock1 = find_nodes_in_area_cache.get_mapblock_from_pos(pos1)
  local mapblock2 = find_nodes_in_area_cache.get_mapblock_from_pos(pos2)

  local pos_result = {}
  local stat_result = {}

  for x=mapblock1.x, mapblock2.x do
  for y=mapblock1.y, mapblock2.y do
  for z=mapblock1.z, mapblock2.z do
    local mapblock = {x=x, y=y, z=z}
    local entry = find_nodes_in_area_cache.get_entry(mapblock)

    -- populate result
    for _, nodename in ipairs(nodenames) do
      for _, pos in ipairs(entry.blocks[nodename] or {}) do
        local x_fits = pos.x <= pos2.x and pos.x >= pos1.x
        local y_fits = pos.y <= pos2.y and pos.y >= pos1.y
        local z_fits = pos.z <= pos2.z and pos.z >= pos1.z
        if x_fits and y_fits and z_fits then
          -- add pos
          table.insert(pos_result, pos)
          -- increment stats
          stat_result[nodename] = (stat_result[nodename] or 0) + 1
        end
      end
    end
  end
  end
  end

  return pos_result, stat_result
end

function find_nodes_in_area_cache.invalidate(blockpos)
  local hash = minetest.hash_node_position(blockpos)
  cache[hash] = nil
end

function find_nodes_in_area_cache.invalidate_area(pos1, pos2)
	pos1, pos2 = find_nodes_in_area_cache.sort_pos(pos1, pos2)

  local mapblock1 = find_nodes_in_area_cache.get_mapblock_from_pos(pos1)
  local mapblock2 = find_nodes_in_area_cache.get_mapblock_from_pos(pos2)

  for x=mapblock1.x, mapblock2.x do
  for y=mapblock1.y, mapblock2.y do
  for z=mapblock1.z, mapblock2.z do
    local blockpos = {x=x, y=y, z=z}
		local hash = minetest.hash_node_position(blockpos)
	  cache[hash] = nil
  end
  end
  end
end

function find_nodes_in_area_cache.add(nodename, pos)
  local mapblock = find_nodes_in_area_cache.get_mapblock_from_pos(pos)
  local entry = find_nodes_in_area_cache.get_entry(mapblock)
  table.insert(entry.blocks[nodename], pos)
end

function find_nodes_in_area_cache.remove(nodename, oldpos)
  local mapblock = find_nodes_in_area_cache.get_mapblock_from_pos(oldpos)
  local entry = find_nodes_in_area_cache.get_entry(mapblock)
  local poslist = {}
  for _, pos in ipairs(entry.blocks[nodename]) do
    -- TODO: maybe use table.remove here
    if not pos.x == oldpos.x and not pos.y == oldpos.y and not pos.z == oldpos.z then
      -- not the oldpos
      table.insert(poslist, pos)
    end
  end

  -- apply new list
  entry.blocks[nodename] = poslist
end
