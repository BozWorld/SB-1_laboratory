extends Randonneureuse

@export var perlin : FastNoiseLite
var temps := 0.0
@export var pas_temps := 0.01


func _pas():
	var choix : Vector3
	
	temps += pas_temps
	
	
	choix.x = perlin.get_noise_2d(0.0, temps)
	choix.y = perlin.get_noise_2d(temps, 0.0)
	choix.z = perlin.get_noise_2d(temps, temps)
	
	
	position += choix * puissance_deplacement
	
	
	var choix_rvb : Vector3
	
	choix_rvb.x = abs(perlin.get_noise_2d(100.0, temps))
	choix_rvb.y = abs(perlin.get_noise_2d(temps, 100.0))
	choix_rvb.z = abs(perlin.get_noise_2d(100 + temps, 100 + temps))
	
	mesh.material.albedo_color.r = choix_rvb.x
	mesh.material.albedo_color.g = choix_rvb.y
	mesh.material.albedo_color.b = choix_rvb.z
