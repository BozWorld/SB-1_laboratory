extends ObjetPhysique

@onready var boite = get_tree().get_first_node_in_group("boite")

func appliquerGravite():
	appliquerForce(Vector3.DOWN * 0.9 * masse)

func _process(delta: float) -> void:
	appliquerGravite()
	
	if position.x >= boite.mesh.size.x * 0.5 - %MeshBallon.mesh.radius :
		velocite.x = -velocite.x * 0.8
		appliquerFriction()
		position.x = boite.mesh.size.x * 0.5 - %MeshBallon.mesh.radius
		
	elif position.x <= -boite.mesh.size.x * 0.5 + %MeshBallon.mesh.radius :
		velocite.x = -velocite.x * 0.8
		appliquerFriction()
		position.x = -boite.mesh.size.x * 0.5 + %MeshBallon.mesh.radius
		
	if position.y >= (boite.mesh.size.y - %MeshBallon.mesh.height) * 0.5 :
		velocite.y = -velocite.y * 0.8
		appliquerFriction()
		position.y = (boite.mesh.size.y - %MeshBallon.mesh.height) * 0.5
		
	elif position.y <= (-boite.mesh.size.y + %MeshBallon.mesh.height) * 0.5 :
		velocite.y = -velocite.y * 0.8
		appliquerFriction()
		position.y = (-boite.mesh.size.y + %MeshBallon.mesh.height) * 0.5
		
	if position.z >= boite.mesh.size.z * 0.5 - %MeshBallon.mesh.radius:
		velocite.z = -velocite.z * 0.8
		appliquerFriction()
		position.z = boite.mesh.size.z * 0.5 - %MeshBallon.mesh.radius
		
	elif position.z <= -boite.mesh.size.z * 0.5 + %MeshBallon.mesh.radius:
		velocite.z = -velocite.z * 0.8
		appliquerFriction()
		position.z = -boite.mesh.size.z * 0.5 + %MeshBallon.mesh.radius
		
	
	print("velocite : " + str(velocite))
	
	appliquerForce(%FrottementFluide.calculFrottement())
	
	logiqueMouvement(delta)
