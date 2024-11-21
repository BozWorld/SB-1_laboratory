extends Node2D

var menu_ouvert = false
@onready var camera = $Camera2D

var ancien_mouse_mode

func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("echap"):
		if !menu_ouvert :
			ancien_mouse_mode = Input.mouse_mode
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			menu_ouvert = true
			camera.bloquee = true
		
		elif menu_ouvert :
			Input.mouse_mode = ancien_mouse_mode
			ancien_mouse_mode = null
			menu_ouvert = false
			camera.bloquee = false
