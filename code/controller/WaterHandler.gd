extends RefCounted
class_name WaterHandler

const heauteur:= 1.0
const vaisseauteur:= 1.0

var frottements_survol:= 0.1
var frottements_sous_marin:= 0.1
var archimede:= 3.0
var archimed_angle:= 0.9

var linear_force:= 0.0

func get_water_state(hauteur: float) -> String:
	if hauteur < heauteur - vaisseauteur:
		return "underwater"
	elif hauteur < heauteur + vaisseauteur:
		if linear_force:
			linear_force = 0.0
		return "on_water"
	else:
		if linear_force:
			linear_force = 0.0
		return "none"

func get_linear_force(delta: float) -> float:
	linear_force += archimede * delta
	return linear_force

func get_angular_force(delta: float, forward_vector: Vector3):
	if forward_vector.y < 0.0:
		return delta * archimed_angle
	else :
		return 0.0
