extends Randonneureuse

@export var deviation_deplacement := 0.2


func _pas():
	var choix_x = randi_range(-1, 1)
	var choix_y = randi_range(-1, 1)
	var choix_z = randi_range(-1, 1)
	
	position.x += choix_x * randfn(puissance_deplacement, deviation_deplacement)
	position.y += choix_y * randfn(puissance_deplacement, deviation_deplacement)
	position.z += choix_z * randfn(puissance_deplacement, deviation_deplacement)
	
	
	
	var choix_r = randf_range(-0.04, 0.04)
	var choix_v = randf_range(-0.04, 0.04)
	var choix_b = randf_range(-0.04, 0.04)
	
	if mesh.material.albedo_color.r + choix_r > 1.0 or mesh.material.albedo_color.r + choix_r < 0.0 :
		mesh.material.albedo_color.r = randf()
	else :
		mesh.material.albedo_color.r += choix_r
	
	if mesh.material.albedo_color.g + choix_v > 1.0 or mesh.material.albedo_color.g + choix_v < 0.0 :
		mesh.material.albedo_color.g = randf()
	else :
		mesh.material.albedo_color.g += choix_v
		
	if mesh.material.albedo_color.b + choix_b > 1.0 or mesh.material.albedo_color.b + choix_b < 0.0 :
		mesh.material.albedo_color.b = randf()
	else :
		mesh.material.albedo_color.b += choix_b
	 #= Color(choix_r, choix_v, choix_b)
