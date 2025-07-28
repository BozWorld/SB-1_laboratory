extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_pressed("coupDeVent") :
		print("okaaaay")
	if Input.is_action_pressed("v_arriere") :
		print("aaaaaaaah")
	if Input.is_action_pressed("avant"):
		print("avant")
	if Input.is_action_pressed("arriere"):
		print("arriere")
	if Input.is_action_pressed("gauche"):
		print("gauche")
	if Input.is_action_pressed("droite"):
		print("droite")
