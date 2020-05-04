extends Node

var Action = preload('res://scripts/action.gd')
#var nav2D : Navigation2D
var actions : Array
var unit : Node
var sameTeamUnits : Array
var otherTeamUnits : Array
var targetPosition

func definePlan(nav2D, line_2d):
	var tilemap = nav2D.get_node("TileMap")
	var unitsMap = nav2D.get_node("Units")
	get_goal(tilemap)
	if targetPosition:

		var path = tilemap.get_path_astart(unit.current_position, targetPosition)
		var path_in_world : Array
		for p in path:
			path_in_world.append(tilemap.map_to_world(p))
	
	
		#print("distance", unit.current_position.distance_to(enemy.current_position))
		var current_position = unit.current_position
		actions.clear()
		for turn in range(1,4):
			if path.size() <= turn:
				continue
			
			var target = path[turn]
			var moveVector = target - current_position
			moveVector.normalized()
			var choosenDirection
			var action = Action.new()
			if moveVector.x == 1 and tilemap.get_cell(unit.current_position.x + 1, current_position.y):
				choosenDirection = 'right'
				moveVector  = Vector2(1,0)
				action.actionType = 'move'
				if unitsMap.get_cellv(unit.current_position + moveVector) == 0:
					action.actionType = 'attack'
					
			if moveVector.x == -1 and tilemap.get_cell(unit.current_position.x - 1, current_position.y):
				choosenDirection = 'left'
				moveVector  = Vector2(-1,0)
				action.actionType = 'move'
				if unitsMap.get_cellv(unit.current_position + moveVector) == 0:
					action.actionType = 'attack'
					
			if moveVector.y == -1 and tilemap.get_cell(unit.current_position.x, current_position.y - 1):
				choosenDirection = 'up'
				moveVector  = Vector2(0,-1)
				action.actionType = 'move'
				if unitsMap.get_cellv(unit.current_position + moveVector) == 0:
					action.actionType = 'attack'
					
			if moveVector.y == 1 and tilemap.get_cell(unit.current_position.x, current_position.y + 1):
				choosenDirection = 'down'
				moveVector  = Vector2(0,1)
				action.actionType = 'move'
				if unitsMap.get_cellv(unit.current_position + moveVector) == 0:
					action.actionType = 'attack'
			

			action.parameters.append(choosenDirection)
			actions.push_back(action)
			if action.actionType:
				current_position = current_position + moveVector
		line_2d.points = path_in_world
		
	var action = Action.new()
	action.actionType = 'endTurn'
	actions.push_back(action)
	
func get_goal(tilemap):
	for enemy in otherTeamUnits:
		if enemy.current_position.distance_to(unit.current_position) <= 6:
			targetPosition = enemy.current_position
			print('found player')
			return
	for otherUnit in sameTeamUnits:
		if otherUnit.current_position !=  unit.current_position and otherUnit.current_position.distance_to(unit.current_position) <= 6:
			targetPosition = otherUnit.current_position
			print('found friend')
			return
	
	var cells = tilemap.get_used_cells()

	while not targetPosition or targetPosition == unit.current_position:
		var target_tile = cells[randi() % cells.size()]
		if tilemap.get_cellv(target_tile):
			targetPosition = target_tile
			print('found target')
			return
			
	print('found nothing')
