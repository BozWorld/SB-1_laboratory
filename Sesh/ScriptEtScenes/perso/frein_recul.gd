extends Attribut3D

var freine := false
var recule := false


func logiquePas():
	if Input.is_action_pressed("bougerARRIERE"):
		if parent.velocite.length() == 0:
			return
		else:
			return("freine")
