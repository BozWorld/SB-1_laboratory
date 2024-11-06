extends all_ennemies

func _on_body_entered(body: Node3D) -> void:
	att_damage = 0.5
	collision_attack()
