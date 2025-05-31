extends Randonneureuse

func _pas():
	super()
	var choix_r = randf()
	var choix_v = randf()
	var choix_b = randf()
	mesh.material.albedo_color = Color(choix_r, choix_v, choix_b)
