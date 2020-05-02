extends KinematicBody2D


var rng = RandomNumberGenerator.new()
var ENEMY_SPRITE = preload("res://assets/textures/enemy.png")
var PLAYER_SPRITE = preload("res://assets/textures/man.png")

var curHp : int = 10
var maxHp : int = 10
var actionsCounter = 3
var maxActions = 3
var moveSpeed : int = 250
var damage : int = 1
var vel : Vector2 = Vector2()
var currentPos : Vector2 = Vector2()
var isActive : bool = false
var unitName : String = ''
onready var unitSprite : Sprite = get_node("unitSprite")
var isPlayer : bool = false
var unitAI : Node
var timer : float = 0.0
var actions : Array


signal SIG_UNIT_UPDATED
signal SIG_END_TURN

	
func init(initialPos, newUnitName, type):
	currentPos = initialPos
	self.set_position(currentPos * 32)
	unitName = newUnitName
	isPlayer = type == 'PLAYER'
	if type == 'ENEMY':
		get_node("unitSprite").set_texture(ENEMY_SPRITE)
	elif type == 'PLAYER':
		get_node("unitSprite").set_texture(PLAYER_SPRITE)		
		
	
func endTurn():
	isActive = false
	print('End Turn ', unitName)
	emit_signal("SIG_END_TURN")
	
	#actionsCounter = maxActions
	
func startTurn():
	print("Start Turn unit ", unitName)
	
	isActive=true
	actionsCounter = maxActions
	if not isPlayer:
		print('IS NOT PLAYER')
		var nav2D2 = get_node('/root/MainScene/Map')
		var line_2d : Line2D = get_node('/root/MainScene/Debug/Line2D')
		unitAI.definePlan(nav2D2, line_2d)
	else:
		uncoverFog(currentPos)
	emit_signal("SIG_UNIT_UPDATED")

	
		
	
func blink(delta):

	#print(delta)
	if int(timer) % 4 == 0 and self.visible:
		self.visible = !self.visible
	elif int(timer) % 2 == 0 and not self.visible:
		self.visible = !self.visible


func process_action():
	#print("process_action. remaingin actions: ", unitAI.actions.size())
	print("PROCESSING ACTION")
	if actionsCounter > 0 and unitAI.actions.size() > 0:
		var action = unitAI.actions.pop_front()
		if action.actionType == 'move':
			move(action.parameters[0])
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

func uncoverFog(position):
	var max_distance = 2
	var fog = get_node('/root/MainScene/Map/Fog')
	for x in range(-2,3):
		for y in range(-2,3):
			var other_cell = position + Vector2(x,y)
			if position.distance_to(other_cell) <= max_distance :
				fog.set_cellv(other_cell, -1)
	
		
func move(action):
	print('MOVING %s %s' % [unitName, action])
	var mapNode = get_node('/root/MainScene/Map/TileMap')

	
	var newPos = currentPos
	#inputs
	if action == 'up':
		newPos.y -=1
	if action == 'down':
		newPos.y += 1
	if action == 'left':
		newPos.x -= 1
	if action == 'right':
		newPos.x += 1
	
	
	print(mapNode.get_cellv(newPos))
	if mapNode.get_cellv(newPos) > 0 and actionsCounter > 0: # and mapNode.all_tiles[newPos].isWalkable 
		if isPlayer:
			uncoverFog(newPos)
		self.set_position(newPos * 32)
		currentPos = newPos
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
	
	
