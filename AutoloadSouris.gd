extends Node

var souris_capturee = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("changerSouris"):
		if souris_capturee :
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			souris_capturee = false
		if !souris_capturee :
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			souris_capturee = true
