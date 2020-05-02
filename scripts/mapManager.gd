extends Navigation2D

var rng = RandomNumberGenerator.new()

func generateMap():
	rng.randomize()
	var X_TILES = 32
	var Y_TILES = 27
	var TILE_SIZE = 32
	var tilemap = get_node("TileMap")
	var fog = get_node("Fog")
	for x in range(X_TILES):
		for y in range(Y_TILES):
			var my_random_number = rng.randi_range(0, 100)
			if my_random_number < 80:
				tilemap.set_cell(x, y, 1)
				fog.set_cell(x,y,2)
			else:
				tilemap.set_cell(x, y, 0)
				fog.set_cell(x,y,2)
	tilemap.initialize()
