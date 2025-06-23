extends Randonneureuse


func acceptReject():
	var choix1 : Vector3
	var choix2 : Vector3
	
	choix1.x = randf_range(-puissance_deplacement, puissance_deplacement)
	choix1.y = randf_range(-puissance_deplacement, puissance_deplacement)
	choix1.z = randf_range(-puissance_deplacement, puissance_deplacement)
	
	choix2.x = randf_range(-puissance_deplacement, puissance_deplacement)
	choix2.y = randf_range(-puissance_deplacement, puissance_deplacement)
	choix2.z = randf_range(-puissance_deplacement, puissance_deplacement)
	
	if choix2.length() < choix1.length() :
		return choix1
	else :
		return acceptReject()

func _pas():
	
	position += acceptReject()
	
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
