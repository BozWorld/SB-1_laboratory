extends Area3D

var is_landing_available: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	set_landing_available(false)

func set_landing_available(available: bool) -> void:
	is_landing_available = available

	var mesh_instance = $terrain_mesh_type_01
	if mesh_instance:
		var material = mesh_instance.get_surface_override_material(0)
		if not material:
			material = mesh_instance.get_active_material(0)
		if material:
			material = material.duplicate()
			mesh_instance.set_surface_override_material(0, material)
			if is_landing_available:
				material.albedo_color = Color.GREEN
			else:
				material.albedo_color = Color.RED

func _on_body_entered(body: Node) -> void:
	if is_landing_available and body.is_in_group("player"):
		print("Landing zone activated for player: ", body.name)
		get_tree().call_group("game_manager", "_complete_game")
