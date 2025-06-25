extends Node3D

@export var origine_orbite : Node3D

@export var puissance_attraction := 1.0

var velocite := Vector3.ZERO
var acceleration := Vector3.ZERO

func attractionGravitationnelle():
	var distance := origine_orbite.position - position
	
	if distance.length() > 0.0 :
		var attraction := Vector3.ZERO
		
		attraction = distance.normalized()
		attraction *= clamp(1.0/distance.length(), 0.44, 100.0)
		print(1.0/distance.length())
		return attraction

func _physics_process(delta: float) -> void:
	var force_gravitationnelle = attractionGravitationnelle()
	if force_gravitationnelle :
		acceleration += force_gravitationnelle * delta * puissance_attraction
	
	velocite += acceleration
	position += velocite
	acceleration = Vector3.ZERO
