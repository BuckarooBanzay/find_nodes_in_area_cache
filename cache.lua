
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

local function get_mapblock_from_pos(pos)
	return {
		x = math.floor(pos.x / 16),
		y = math.floor(pos.y / 16),
		z = math.floor(pos.z / 16)
	}
end

local function get_blocks_from_mapblock(mapblock)
	local min = {
		x = (mapblock.x) * 16,
		y = (mapblock.y) * 16,
		z = (mapblock.z) * 16
	}
	local max = vector.add(min, 15)

	return min, max
end

local function sort_pos(pos1, pos2)
	pos1 = {x=pos1.x, y=pos1.y, z=pos1.z}
	pos2 = {x=pos2.x, y=pos2.y, z=pos2.z}
	if pos1.x > pos2.x then
		pos2.x, pos1.x = pos1.x, pos2.x
	end
	if pos1.y > pos2.y then
		pos2.y, pos1.y = pos1.y, pos2.y
	end
	if pos1.z > pos2.z then
		pos2.z, pos1.z = pos1.z, pos2.z
	end
	return pos1, pos2
end

local function create_entry(mapblock)
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

  local pos1, pos2 = get_blocks_from_mapblock(mapblock)
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

function find_nodes_in_area_cache.get_entry(mapblock)
  local hash = minetest.hash_node_position(mapblock)
  local entry = cache[hash]
  if not entry then
    entry = create_entry(mapblock)
    cache[hash] = entry
  end
  -- TODO: cache expiration
  return entry
end

function find_nodes_in_area_cache.get(pos1, pos2, nodenames)
  pos1, pos2 = sort_pos(pos1, pos2)

  local mapblock1 = get_mapblock_from_pos(pos1)
  local mapblock2 = get_mapblock_from_pos(pos2)

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

function find_nodes_in_area_cache.add(nodename, pos)
  local mapblock = get_mapblock_from_pos(pos)
  local entry = find_nodes_in_area_cache.get_entry(mapblock)
  table.insert(entry.blocks[nodename], pos)
end

function find_nodes_in_area_cache.remove(nodename, oldpos)
  local mapblock = get_mapblock_from_pos(oldpos)
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
