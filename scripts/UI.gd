extends Control

signal SIG_END_TURN_BUTTON

func _ready():
	pass
	#connect('moved', self, "updateUnit")

func  initialize(activeUnit, turnNumber):
	var turn = get_node("turn")
	turn.text = 'Turn %d' % turnNumber
	updateUnit(activeUnit)
	

func _on_EndTurnButton_pressed():
	emit_signal('SIG_END_TURN_BUTTON')

	
func updateTurn(turnNumber):
	var turn = get_node("turn")
	turn.text = 'Turn %d' % turnNumber
	
	
func updateUnit(unit):
	var moves = get_node("unit/moves")
	moves.text = "Moves: " + str(unit.actionsCounter) + "/" + str(unit.maxActions)
	var uiName = get_node("unit/name")
	uiName.text = 'Unit ' + unit.unitName
	
