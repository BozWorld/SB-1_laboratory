extends ObjetPhysique

@onready var boite = get_tree().get_first_node_in_group("boite")

func appliquerGravite():
	appliquerForce(Vector3.DOWN * 0.9 * masse)

func _process(delta: float) -> void:
	appliquerGravite()
	
	if abs(position.x) >= boite.mesh.size.x/2.0 - %MeshBallon.mesh.radius :
		velocite.x = -velocite.x * 0.9
		appliquerFriction()
		position.x = clampf(position.x, -boite.mesh.size.x / 2.0 + %MeshBallon.mesh.radius, boite.mesh.size.x/2.0 - %MeshBallon.mesh.radius)
		
	if abs(position.y) >= (boite.mesh.size.y - %MeshBallon.mesh.height)/2.0 :
		velocite.y = -velocite.y * 0.9
		appliquerFriction()
		position.y = clampf(position.y, -(boite.mesh.size.y - %MeshBallon.mesh.height)/2.0, (boite.mesh.size.y - %MeshBallon.mesh.height)/2.0)
		
	if abs(position.z) >= boite.mesh.size.z / 2.0- %MeshBallon.mesh.radius:
		velocite.z = -velocite.z * 0.9
		appliquerFriction()
		position.z = clampf(position.z, -boite.mesh.size.z/2.0 + %MeshBallon.mesh.radius, boite.mesh.size.z/2.0 - %MeshBallon.mesh.radius)
		
	
	
	logiqueMouvement(delta)
