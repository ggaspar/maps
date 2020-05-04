extends Navigation2D

var rng = RandomNumberGenerator.new()
var attack_mode = false
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
	
func add_unit_to_tile(unit, previous_position=null):
	var units_map = get_node("Units")
	if previous_position:
		units_map.set_cellv(previous_position, -1)
	print('add_unit_to_tile', unit.id, unit.current_position)
	units_map.set_cellv(unit.current_position, unit.id)		

func activateAttackMode():
	
	var unitMan = get_node("/root/MainScene/Units")
	var activeUnit = unitMan.activeUnit
	var highlighter = get_node("Highlighter")
	var tilemap = get_node("TileMap")
	var unitsTiles = get_node("Units")
	
	var cellv = activeUnit.current_position + Vector2(0,1)
	if tilemap.get_cellv(cellv) > 0 and unitsTiles.get_cellv(cellv) > 0:
		highlighter.set_cellv(cellv, 10)
		attack_mode = true
		
	cellv = activeUnit.current_position + Vector2(0,-1)
	if tilemap.get_cellv(cellv) > 0 and unitsTiles.get_cellv(cellv) > 0:
		highlighter.set_cellv(cellv, 10)
		attack_mode = true

	cellv = activeUnit.current_position + Vector2(0,1)
	if tilemap.get_cellv(cellv) > 0 and unitsTiles.get_cellv(cellv) > 0:
		highlighter.set_cellv(cellv, 10)
		attack_mode = true

	cellv = activeUnit.current_position + Vector2(1, 0)
	if tilemap.get_cellv(cellv) > 0 and unitsTiles.get_cellv(cellv) > 0:
		highlighter.set_cellv(cellv, 10)
		attack_mode = true
	
	cellv = activeUnit.current_position + Vector2(-1, 0)
	if tilemap.get_cellv(cellv) > 0 and unitsTiles.get_cellv(cellv) > 0:
		highlighter.set_cellv(cellv, 10)	
		attack_mode = true
		
		
func _input(event):
	if event is InputEventMouseButton and event.pressed and attack_mode:
		var tilemap = get_node("TileMap")
		var highlighter = get_node("Highlighter")
		var units_manager = get_node("/root/MainScene/Units")
		var activeUnit = units_manager.activeUnit
		var unitsTiles = get_node("Units")
				
		var camera = get_node("/root/MainScene/Camera2D")	
		var click_position = get_viewport().get_mouse_position()
		click_position -= (Vector2(528, 496))
		click_position += (camera.get_camera_position())
		click_position /= 32
		click_position = Vector2(stepify(click_position.x, 1), stepify(click_position.y,1))
		if highlighter.get_cellv(click_position) > 0 and unitsTiles.get_cellv(click_position) > 0:
			units_manager.attack(activeUnit.id, unitsTiles.get_cellv(click_position))
			print("BOUAH")
		
		
		
		
