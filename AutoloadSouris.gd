extends Node

var souris_capturee = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("changerSouris"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED :
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			souris_capturee = false
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE :
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			souris_capturee = true
