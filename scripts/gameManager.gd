extends Node2D

var turn : int = 1
onready var map = get_node('Map')
onready var Units = get_node('Units')
onready var camera = get_node('Camera2D')
onready var debug = get_node('Debug')



func _ready():

	#map.generate_map()
	print('generateMap')
	map.generateMap()
	Units.initialize()
	camera.initialize(Units.get_child(0))


	
func end_turn():
	#var map = get_node('map')
	Units.end_turn()
		
func _process(delta):
	if Input.is_action_just_pressed("debug"):
		print('DEBUG')
		debug.get_node('Line2D').visible = !debug.get_node('Line2D').visible
		map.get_node('Fog').visible = !map.get_node('Fog').visible
		#debug.set_process(false)
