extends Attribut3D

var freine := false
var recule := false


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("bougerARRIERE"):
		if parent.velocite.length() > 1.0 :
			freine = true
		else :
			recule = true
	
	if Input.is_action_just_released("bougerARRIERE"):
		if freine :
			freine = false
		if recule :
			recule = false

func logiquePas():
	if freine :
		if parent.velocite.length() == 0:
			return "freine"
