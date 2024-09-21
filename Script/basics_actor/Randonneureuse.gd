class_name Randonneureuse
extends MeshInstance3D

var _rng = RandomNumberGenerator

var _position_enregistree : Vector3


#func _ready():
	#pass # Replace with function body.


#func _process(delta):
	#pass

func _pas():
	var choix = _rng.randi_range(0, 5)
	
	match choix :
		0:
			_position_enregistree.x += 1
		1:
			_position_enregistree.x -= 1
		2:
			_position_enregistree.y += 1
		3:
			_position_enregistree.y -= 1
		4:
			_position_enregistree.z += 1
		5:
			_position_enregistree.z -= 1
