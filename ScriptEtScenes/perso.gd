extends Node3D

var masse = 1.0
var poids = masse * 1.0 # Le 1 c'est la gravité

var velocite : Vector3
var acceleration : Vector3

@export var camera : Camera3D

func get_input():
	var impulse : Vector2
	impulse.x = Input.get_axis("bougerDROITE", "bougerGAUCHE") * 0.1
	impulse.y = Input.get_axis("bougerARRIERE","bougerAVANT") * 0.1
	return impulse
	


func apply_force(force : Vector3):
	acceleration += force



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	

		
		
		
		
	
	
	#var gravite = Vector3(0, -poids, 0)
	#apply_force(gravite)
	
	#print("velocite :" + str(velocite))
	#print("position :" + str(position))
	velocite += acceleration
	position += velocite * delta
	acceleration = Vector3(0.0,0.0,0.0)
