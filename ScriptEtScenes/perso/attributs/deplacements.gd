extends Attribut


func get_input():
	var impulse : Vector2
	impulse.x = Input.get_axis("bougerDROITE", "bougerGAUCHE") * 0.1
	impulse.y = Input.get_axis("bougerARRIERE","bougerAVANT") * 0.1
	return impulse
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("bougerDROITE") or Input.is_action_pressed("bougerGAUCHE") or Input.is_action_pressed("bougerAVANT") or Input.is_action_pressed("bougerARRIERE") :
		parent.apply_force(Vector3(get_input().x, 0.0, get_input().y))
		
	else :
		var arret : Vector2
		if abs(parent.velocite.x) < 1 : 
			arret.x = 0
			parent.velocite.x = 0
		else :
			arret.x = 1.0/abs(parent.velocite.x)  * -parent.velocite.x * 0.2
		
		if abs(parent.velocite.z) < 1 :
			arret.y = 0
			parent.velocite.z = 0
		else :
			arret.y = 1.0/abs(parent.velocite.z)  * -parent.velocite.z * 0.2
		
		parent.apply_force(Vector3(arret.x, 0, arret.y))