extends Node
onready var Unit = preload("res://scenes/Unit.tscn")
onready var UnitAI = preload("res://scripts/unitAI.gd")
var activeUnit : Node
#var allUnits : Array
var enemyUnits : Array
var playerUnits : Array
var turnNumber : int = 1
onready var ui = get_node('/root/MainScene/CanvasLayer/UI')

func initialize():
	generate_player_units()
	generate_enemies(20)
	ui.initialize(activeUnit, turnNumber)
	connect_signals()
	activeUnit.startTurn()
	
func connect_signals():
	for unit in get_children():
		if unit.isPlayer:
			unit.connect('SIG_UNIT_UPDATED', ui, "updateUnit", [unit])
			ui.connect('SIG_END_TURN_BUTTON', unit, "endTurn")
		unit.connect('SIG_END_TURN', self, "nextTurn")
		
func nextTurn():
	print("NEXT TURN")
	#self.activeUnit.endTurn()
	if activeUnit.isPlayer:
		turnNumber += 1		
	var index = activeUnit.get_index()
	index = (index + 1) % get_child_count()
	activeUnit = get_child(index)
	activeUnit.startTurn()
	ui.updateTurn(turnNumber)

func process_unit_actions():
	pass
	#while 1:
	#activeUnit
	
func generate_player_units():
	#var tilemap = nav2D.get_node("TileMap")
	var tilemap = get_node('/root/MainScene/Map/TileMap')
	var ui = get_node('/root/MainScene/UI')
	var unit = Unit.instance()
	var cells = tilemap.get_used_cells()
	randomize()
	var pos
	while 1:
		var target_tile = cells[randi() % cells.size()]
		if tilemap.get_cellv(target_tile):
			pos = target_tile
			break
	unit.init(pos, 'Guilherme', 'PLAYER')
	activeUnit = unit
	playerUnits.append(unit)
	self.add_child(unit)
	unit.z_index = 1
	unit.isActive = true	
	
	
func generate_enemies(numOfEnemies=1):
	var ui = get_node('/root/MainScene/UI')
	var tilemap = get_node('/root/MainScene/Map/TileMap')
	
	var cells = tilemap.get_used_cells()
	cells.invert()
	randomize()

	
	for i in range(numOfEnemies):
		var unit = Unit.instance()
		var pos
		while 1:
			var target_tile = cells[randi() % cells.size()]
			if tilemap.get_cellv(target_tile):
				pos = target_tile
				break
		
		unit.init(pos, 'Ze', 'ENEMY')		
		enemyUnits.append(unit)
		self.add_child(unit)
		unit.z_index = 1
		unit.connect('moved', ui, "updateUnit", [unit])
		var unitAI = UnitAI.new()
		unitAI.unit = unit
		unitAI.otherTeamUnits = playerUnits
		unitAI.sameTeamUnits = enemyUnits
		unit.unitAI = unitAI
	
		
#func end_turn():
#	activeUnit.end_turn()
	
