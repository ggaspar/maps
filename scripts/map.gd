extends Node

export var all_tiles : Dictionary
export var all_grass_tiles : Dictionary
export var all_water_tiles : Dictionary
onready var Tile = preload("res://scenes/TileScene.tscn")

var GRASS_TEXTURE = preload("res://assets/textures/grass.png")
var WATER_TEXTURE = preload("res://assets/textures/water.png")
var rng = RandomNumberGenerator.new()


func generate_map():
	rng.randomize()

	var X_TILES = 32
	var Y_TILES = 27
	var TILE_SIZE = 32
	
	for x in range(X_TILES):
		for y in range(Y_TILES):
			var my_random_number = rng.randi_range(0, 100)

			var tile = Tile.instance()
			if my_random_number < 80:
				add_to_group("TilesGrass")
				tile.get_node("texture").set_texture(GRASS_TEXTURE)
				all_grass_tiles[Vector2(x,y)] = tile
			else:
				add_to_group("TilesWater")
				tile.get_node("texture").set_texture(WATER_TEXTURE)
				tile.isWalkable = false
				all_water_tiles[Vector2(x,y)] = tile
			
			add_to_group("Tiles")
				
			var position = Vector2(x * TILE_SIZE, y * TILE_SIZE)
			tile.set_position(position)
			self.add_child(tile)
			all_tiles[Vector2(x,y)] = tile
	
func _ready():
	pass
			
	
	

