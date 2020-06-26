
**find_nodes_in_area_cache**

a caching layer for `minetest.find_nodes_in_area()`

# Overview

Caches all interactions to `minetest.find_nodes_in_area()` on a per mapblock basis.
Also tracks node place and destroy calls, if the node was registered to be tracked (see "Api").

# Api

```
-- track these nodes and delegate to cached version of find_nodes_in_area
find_nodes_in_area_cache.register("protector:protect")
find_nodes_in_area_cache.register("protector:protect2")
find_nodes_in_area_cache.register("protector:protect_hidden")
```

# Support

Optional support for these mods:

* `protector`
* `priv_protector`
* `xp_redo`
* `jumpdrive`
* `vacuum`

# FAW

* **Q:** This is a big, ugly hack, wtf?
* **A:** Yes it is...

# License

MIT
