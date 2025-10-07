extends Area3D

var is_landing_available: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	set_landing_available(false)

func set_landing_available(available: bool) -> void:
	is_landing_available = available

	var mesh_instance = get_node("MeshInstance3D")
	if mesh_instance:
		if is_landing_available:
			mesh_instance.modulate = Color.GREEN
		else:
			mesh_instance.modulate = Color.RED

func _on_body_entered(body: Node) -> void:
	if is_landing_available and body.is_in_group("player"):
		print("Landing zone activated for player: ", body.name)
		get_tree().call_group("game_manager", "_complete_game")
