extends Camera2D

var target

func initialize(new_target):
	target = new_target
	
func _process(delta):
	position = target.position

