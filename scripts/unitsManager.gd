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
	generate_player_units(1)
	generate_enemies(10)
	ui.initialize(activeUnit, turnNumber)
	connect_signals()
	activeUnit.startTurn()
	
func connect_signals():
	for unit in get_children():
		if unit.isPlayer:
			unit.connect('SIG_UNIT_UPDATED', ui, "updateUnit", [unit])
			ui.connect('SIG_END_TURN_BUTTON', unit, "endTurn")
			ui.connect('SIG_LOOK_UP_BUTTON', unit, "lookUp")
			
		unit.connect('SIG_END_TURN', self, "nextTurn")
		
func nextTurn():
	print("NEXT TURN")
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
func attack(attacking_unit_id, defending_unit_id):
	var attacking_unit = get_child(attacking_unit_id)
	var defending_unit = get_child(defending_unit_id)
	defending_unit.damaged()
	
func generate_player_units(numOfUnits=1):
	#var tilemap = nav2D.get_node("TileMap")
	var tilemap = get_node('/root/MainScene/Map/TileMap')
	var map = get_node('/root/MainScene/Map')
	var ui = get_node('/root/MainScene/UI')
	var unit
	for i in range(numOfUnits):
		unit = Unit.instance()
		var cells = tilemap.get_used_cells()
		randomize()
		var pos
		while 1:
			var target_tile = cells[randi() % cells.size()]
			#var target_tile = cells[0]
			if tilemap.get_cellv(target_tile):
				pos = target_tile
				break
		unit.init(pos, 'Guilherme', 'PLAYER', i, 5)
		activeUnit = unit
		playerUnits.append(unit)
		self.add_child(unit)
		map.add_unit_to_tile(unit)
		
	unit.isActive = true	
		
	
func generate_enemies(numOfEnemies=1):
	var ui = get_node('/root/MainScene/UI')
	var tilemap = get_node('/root/MainScene/Map/TileMap')
	var map = get_node('/root/MainScene/Map')
	var cells = tilemap.get_used_cells()
	var quantity_units = get_child_count()
	randomize()
	
	for i in range(numOfEnemies):
		var unit = Unit.instance()
		var pos = null
		while not pos:
			var target_tile = cells[randi() % cells.size()]
			if tilemap.get_cellv(target_tile):
				pos = target_tile
		
		unit.init(pos, 'Ze %d' % i, 'ENEMY', quantity_units+i)		
		enemyUnits.append(unit)
		self.add_child(unit)
		var unitAI = UnitAI.new()
		unitAI.unit = unit
		unitAI.otherTeamUnits = playerUnits
		unitAI.sameTeamUnits = enemyUnits
		unit.unitAI = unitAI
		print('ID:', unit.id)
		print('ID2:', quantity_units+i)
		map.add_unit_to_tile(unit)
	
		
#func end_turn():
#	activeUnit.end_turn()
	
