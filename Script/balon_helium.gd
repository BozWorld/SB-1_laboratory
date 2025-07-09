extends ObjetPhysique

@export var vitesse_archimede := 1.0

func _process(delta: float) -> void:
	if abs(position.x) >= (%Boite.mesh.size.x - %MeshBallon.mesh.radius)/2.0 :
		appliquerForce(Vector3(-velocite.x, 0.0, 0.0))
		position.x = clampf(position.x, -(%Boite.mesh.size.x - %MeshBallon.mesh.radius)/2.0, (%Boite.mesh.size.x - %MeshBallon.mesh.radius)/2.0)
		
	if abs(position.y) >= (%Boite.mesh.size.y - %MeshBallon.mesh.height)/2.0 :
		appliquerForce(Vector3(0.0, -velocite.y, 0.0))
		position.y = clampf(position.y, -(%Boite.mesh.size.y - %MeshBallon.mesh.height)/2.0, (%Boite.mesh.size.y - %MeshBallon.mesh.height)/2.0)
		
	if abs(position.z) >= (%Boite.mesh.size.z - %MeshBallon.mesh.radius)/2.0 :
		appliquerForce(Vector3(0.0, 0.0, -velocite.z))
		position.z = clampf(position.z, -(%Boite.mesh.size.z - %MeshBallon.mesh.radius)/2.0, (%Boite.mesh.size.z - %MeshBallon.mesh.radius)/2.0)
		
	
	appliquerForce(Vector3(0.0,vitesse_archimede * delta, 0.0))
	appliquerForce(%Vent.force)
	
	logiqueMouvement(delta)
