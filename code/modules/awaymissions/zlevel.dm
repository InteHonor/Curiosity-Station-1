proc/createRandomZlevel()
	if(awaydestinations.len)	//crude, but it saves another var!
		return

	var/list/potentialRandomZlevels = list()
	log_startup_progress("Searching for away missions...")
	var/list/Lines = file2list("_maps/map_files/RandomZLevels/fileList.txt")

	if(!Lines.len)	return
	for (var/t in Lines)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
	//	var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
		//	value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		potentialRandomZlevels.Add(t)


	if(potentialRandomZlevels.len)
		var/watch = start_watch()
		log_startup_progress("  Loading away mission...")

		var/map = pick(potentialRandomZlevels)
		var/file = file(map)
		if(isfile(file))
			maploader.load_map(file)
			var/turfs = block(locate(1, 1, world.maxz), locate(world.maxx, world.maxy, world.maxz))
			if(air_master)
				air_master.setup_allturfs(turfs)
			for(var/turf/T in turfs)
				if(T.dynamic_lighting)
					T.lighting_build_overlays()
			log_to_dd("Away mission loaded: [map]")

		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name != "awaystart")
				continue
			awaydestinations.Add(L)

		log_startup_progress("  Away mission loaded in [stop_watch(watch)]s.")

	else
		log_startup_progress("  No away missions found.")
		return