extends Node3D

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("coupDeVent"):
		for ressort in get_tree().get_nodes_in_group("ressorts") :
			ressort.appliquerForce((ressort.global_position - global_position).normalized() * 1.0/((global_position - ressort.global_position).length()) * 44.0)
