extends KinematicBody2D


var rng = RandomNumberGenerator.new()
var ENEMY_SPRITE = preload("res://assets/textures/enemy.png")
var PLAYER_SPRITE = preload("res://assets/textures/man.png")

var curHp : int = 10
var maxHp : int = 10
var actionsCounter = 3
var max_actions = 3
var moveSpeed : int = 250
var damage : int = 1
var vel : Vector2 = Vector2()
var current_position : Vector2 = Vector2()
var isActive : bool = false
var unitName : String = ''
onready var unitSprite : Sprite = get_node("unitSprite")
var isPlayer : bool = false
var unitAI : Node
var timer : float = 0.0
var actions : Array
var id : int


signal SIG_UNIT_UPDATED
signal SIG_END_TURN

	
func init(initialPos, newUnitName, type, new_unit_id, new_max_action=3):
	current_position = initialPos
	self.set_position(current_position * 32)
	unitName = newUnitName
	isPlayer = type == 'PLAYER'
	if type == 'ENEMY':
		get_node("unitSprite").set_texture(ENEMY_SPRITE)
	elif type == 'PLAYER':
		get_node("unitSprite").set_texture(PLAYER_SPRITE)
	get_node("Name").text = unitName
	get_node("ProgressBar").value = curHp
	get_node("ProgressBar").max_value = maxHp
	id = new_unit_id
	z_index = 1
	max_actions = new_max_action
		
func damaged():
	print('Unit %s suffering damage' % unitName)
	curHp -= 3
	get_node("ProgressBar").value = curHp
	
func attack(attack_direction):
	var units = get_node('/root/MainScene/Map/Units')
	print(attack_direction)
	var attacking_position = current_position
	#inputs
	if attack_direction == 'up':
		attacking_position.y -=1
	if attack_direction == 'down':
		attacking_position.y += 1
	if attack_direction == 'left':
		attacking_position.x -= 1
	if attack_direction == 'right':
		attacking_position.x += 1
		
	var enemy_unit_id = units.get_cellv(attacking_position)
	
	if enemy_unit_id > -1:
		get_parent().attack(id, enemy_unit_id)
		actionsCounter -= 1
		emit_signal("SIG_UNIT_UPDATED")
	
func endTurn():
	isActive = false
	print('End Turn ', unitName)
	emit_signal("SIG_END_TURN")
	
func startTurn():
	print("Start Turn unit ", unitName)
	
	isActive=true
	actionsCounter = max_actions
	if not isPlayer:
		var nav2D2 = get_node('/root/MainScene/Map')
		var line_2d : Line2D = get_node('/root/MainScene/Debug/Line2D')
		unitAI.definePlan(nav2D2, line_2d)
	else:
		uncoverFog(current_position)
	emit_signal("SIG_UNIT_UPDATED")

	
		
	
func blink(delta):
	if int(timer) % 4 == 0 and self.visible:
		self.visible = !self.visible
	elif int(timer) % 2 == 0 and not self.visible:
		self.visible = !self.visible


func process_action():
	if actionsCounter > 0 and unitAI.actions.size() > 0:
		var action = unitAI.actions.pop_front()
		print(action.actionType)
		if action.actionType == 'move':
			move(action.parameters[0])
		if action.actionType == 'attack':
			attack(action.parameters[0])
		if action.actionType == 'endTurn':
			endTurn()
	else:
		endTurn()
	
		
func _process(delta):
	timer += (delta*10)
	if timer > 100:
		timer = 0.0
	if isActive and isPlayer:
		blink(delta)
	elif not isPlayer and isActive:
		
		if int(timer) % 4 == 0:
			process_action()

func lookUp():
	if actionsCounter >= 3:
		uncoverFog(current_position, 5)
		actionsCounter -= 3
		emit_signal("SIG_UNIT_UPDATED")
	
func uncoverFog(position, max_distance=2):
	var fog = get_node('/root/MainScene/Map/Fog')
	for x in range(-max_distance, max_distance+1):
		for y in range(-max_distance, max_distance+1):
			if abs(x) + abs(y) <= max_distance:
				fog.set_cellv(position + Vector2(x,y), -1)		
	
		
func move(action):
	var map = get_node('/root/MainScene/Map')
	var mapNode = get_node('/root/MainScene/Map/TileMap')
	var unitsMap = get_node('/root/MainScene/Map/Units')

	var newPos = current_position
	#inputs
	if action == 'up':
		newPos.y -=1
	if action == 'down':
		newPos.y += 1
	if action == 'left':
		newPos.x -= 1
	if action == 'right':
		newPos.x += 1
	
	if mapNode.get_cellv(newPos) > 0 and actionsCounter > 0 and unitsMap.get_cellv(newPos) < 0: # and mapNode.all_tiles[newPos].isWalkable 
		if isPlayer:
			uncoverFog(newPos)
		self.set_position(newPos * 32)
		var old_position = current_position
		current_position = newPos
		map.add_unit_to_tile(self, old_position)
		actionsCounter -= 1
		emit_signal("SIG_UNIT_UPDATED")
		if actionsCounter == 0 and isPlayer:
			isActive = false
			visible = true
		
	else:
		pass
	
	
	
func _physics_process(delta):
	var action
	
	if Input.is_action_just_pressed("move_up"):
		action = 'up'
	if Input.is_action_just_pressed("move_down"):
		action = 'down'
	if Input.is_action_just_pressed("move_left"):
		action = 'left'
	if Input.is_action_just_pressed("move_right"):
		action = 'right'
	
		
	if isActive and action and isPlayer:
		move(action)
	elif Input.is_action_just_pressed("interact") and isPlayer:
		endTurn()
	
	
