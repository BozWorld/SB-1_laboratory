extends Attribut3D


func logiquePas():
	if Input.is_action_pressed("bougerARRIERE"):
		if !parent.velocite.length() == 0:
			return("true")
