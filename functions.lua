
function find_nodes_in_area_cache.get_mapblock_from_pos(pos)
	return {
		x = math.floor(pos.x / 16),
		y = math.floor(pos.y / 16),
		z = math.floor(pos.z / 16)
	}
end

function find_nodes_in_area_cache.get_blocks_from_mapblock(mapblock)
	local min = {
		x = (mapblock.x) * 16,
		y = (mapblock.y) * 16,
		z = (mapblock.z) * 16
	}
	local max = vector.add(min, 15)

	return min, max
end

function find_nodes_in_area_cache.sort_pos(pos1, pos2)
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
