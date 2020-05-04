extends Node2D

var turn : int = 1
onready var map = get_node('Map')
onready var ui = get_node("CanvasLayer/UI")
onready var Units = get_node('Units')
onready var camera = get_node('Camera2D')
onready var debug = get_node('Debug')

var debugActivated = false

func _ready():

	#map.generate_map()
	print('generateMap')
	map.generateMap()
	Units.initialize()
	camera.initialize(Units.get_child(0))
	ui.connect('SIG_ATTACK_BUTTON', map, "activateAttackMode")


	
func end_turn():
	#var map = get_node('map')
	Units.end_turn()
		
func _process(delta):
	if Input.is_action_just_pressed("debug"):
		print('DEBUG', debugActivated)
		debugActivated = !debugActivated
		debug.get_node('Line2D').visible = debugActivated
		map.get_node('Fog').visible = debugActivated
		#debug.set_process(false)
	if debugActivated:
		var cellLabel = debug.get_node('DebugLayer/cell')
		
		var tilemap = map.get_node('TileMap')
		#var mousePos = tilemap.get_mouse_position()
		#var cellPos = tilemap.map_to_world(tilemap.world_to_map(mousePos))
		var unitPos = Units.activeUnit.current_position
		#var dist = cellPos.distance_to(unitPos)
		cellLabel.text = "cell: %d,%d\n"  % [unitPos.x, unitPos.y]
		#Unit: %d,%d\nDist: %d' % [cellPos.x, cellPos.y, unitPos.x, unitPos.y, dist]
