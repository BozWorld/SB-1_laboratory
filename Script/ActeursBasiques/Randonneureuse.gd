class_name Randonneureuse
extends MeshInstance3D

signal changement_bpm

var index_delta = 0.0
var seuil_delta = 0.5
@export_range(0.0,500.0, 1.0, "or_greater") var bpm = 120.0 :
	set(value):
		bpm = value
		seuil_delta = 60.0 / value
		changement_bpm.emit()

@export_range(0.0,100.0,0.1, "or_greater") var puissance_deplacement := 1.0


func _physics_process(delta: float) -> void:
	index_delta += delta
	if index_delta >= seuil_delta :
		index_delta -= seuil_delta
		_pas()

func _pas():
	var choix = randi_range(0, 5)
	
	match choix :
		0:
			position.x += 1.0 * puissance_deplacement
		1:
			position.x -= 1.0 * puissance_deplacement
		2:
			position.y += 1.0 * puissance_deplacement
		3:
			position.y -= 1.0 * puissance_deplacement
		4:
			position.z += 1.0 * puissance_deplacement
		5:
			position.z -= 1.0 * puissance_deplacement
