local has_monitoring_mod = minetest.get_modpath("monitoring")

local cache_size_metric

if has_monitoring_mod then
  cache_size_metric = monitoring.gauge("find_nodes_in_area_cache_cache_size", "Count of all cached mapblocks")
end

-- cache expiration job
local function job()
  local now = os.time()
  local count = 0
  local expired_hashes = {}
  for hash, entry in pairs(find_nodes_in_area_cache.cache) do
    local age = now - entry.mtime

    -- check expiration
    if age > 10 then
      -- add to expire list
      table.insert(expired_hashes, hash)
    else
      -- increment stats
      count = count + 1
    end
  end

  -- remove expired mapblocks
  for _, hash in ipairs(expired_hashes) do
    find_nodes_in_area_cache.cache[hash] = nil
  end

  -- update metrics
  if has_monitoring_mod then
    cache_size_metric.set(count)
  end

  -- trigger again
  minetest.after(5, job)
end

-- initial trigger
minetest.after(5, job)
