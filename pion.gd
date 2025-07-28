extends Truc

@export var vitesse := 2.0

func appliquerFrottement():
	appliquerForce(-(velocite + acceleration) * 0.1, "Frottement")
	#print(velocite)
	#print(acceleration)
	

func _processTruc(delta: float) -> void:
	if Input.is_action_pressed("arriere") :
		appliquerForce(Vector2.DOWN * vitesse, "Deplacement")
	if Input.is_action_pressed("avant") :
		appliquerForce(Vector2.UP * vitesse, "Deplacement")
	if Input.is_action_pressed("gauche") :
		appliquerForce(Vector2.LEFT * vitesse, "Deplacement")
	if Input.is_action_pressed("droite") :
		appliquerForce(Vector2.RIGHT * vitesse, "Deplacement")
	
	bouger(delta)
	appliquerFrottement()
