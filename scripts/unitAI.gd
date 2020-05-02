extends Node

var Action = preload('res://scripts/action.gd')
#var nav2D : Navigation2D
var actions : Array
var unit : Node
var sameTeamUnits : Array
var otherTeamUnits : Array
var targetPosition

func definePlan(nav2D, line_2d):
	get_goal()
	if targetPosition:
		var tilemap = nav2D.get_node("TileMap")
		var path = tilemap.get_path_astart(unit.currentPos, targetPosition)
		var path_in_world : Array
		for p in path:
			path_in_world.append(tilemap.map_to_world(p))
	
	
		#print("distance", unit.currentPos.distance_to(enemy.currentPos))
		var currentPos = unit.currentPos
		actions.clear()
		for turn in range(1,4):
			if path.size() <= turn:
				continue
			print(path)
			var target = path[turn]
			tilemap = nav2D.get_node("TileMap")
			var moveVector = target - currentPos
			moveVector.normalized()
			var choosenDirection
			if moveVector.x == 1 and tilemap.get_cell(unit.currentPos.x + 1, currentPos.y):
				choosenDirection = 'right'
				moveVector  = Vector2(1,0)
			if moveVector.x == -1 and tilemap.get_cell(unit.currentPos.x - 1, currentPos.y):
				choosenDirection = 'left'
				moveVector  = Vector2(-1,0)
			if moveVector.y == -1 and tilemap.get_cell(unit.currentPos.x, currentPos.y - 1):
				choosenDirection = 'up'
				moveVector  = Vector2(0,-1)
			if moveVector.y == 1 and tilemap.get_cell(unit.currentPos.x, currentPos.y + 1):
				choosenDirection = 'down'
				moveVector  = Vector2(0,1)
			
			var action = Action.new()
			action.actionType = 'move'
			action.parameters.append(choosenDirection)
			actions.push_back(action)
			if action.actionType:
				currentPos = currentPos + moveVector
		line_2d.points = path_in_world
		
	var action = Action.new()
	action.actionType = 'endTurn'
	actions.push_back(action)
	print('DEFINING PLAN: ', actions)
	
func get_goal():
	for enemy in otherTeamUnits:
		if enemy.currentPos.distance_to(unit.currentPos) <= 6:
			targetPosition = enemy.currentPos
			break
