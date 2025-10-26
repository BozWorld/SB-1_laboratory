extends ObjetPhysique

var vitesse := 10.0

var distance := 0.0

var range_depop := 444.0

func _physics_process(delta: float) -> void:
	appliquerForce(global_basis.y * vitesse)
	logiqueMouvement(delta)
	distance += velocite.length()
	
	if distance >= range_depop :
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector3(0,0,0), 0.5)
		await tween.finished
		print("destruction")
		queue_free()
