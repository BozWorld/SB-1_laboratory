extends Area3D


var is_landing_available: bool = false
var _material: StandardMaterial3D
var indicator_mesh: MeshInstance3D
func _ready() -> void:
	add_to_group("landing_zone")
	body_entered.connect(_on_body_entered)
	indicator_mesh = %terrain_mesh_type_01
	_setup_material()
	set_landing_available(false)

func _setup_material() -> void:
	if not indicator_mesh:
		indicator_mesh = %terrain_mesh_type_01
	if not indicator_mesh:
		return

func set_landing_available(available: bool) -> void:
	is_landing_available = available
	_update_visual_state()

func _update_visual_state() -> void:
	if _material:
		_material.albedo_color = Color.GREEN if is_landing_available else Color.RED
		_material.emission_enabled = true
		_material.emission = (Color.GREEN if is_landing_available else Color.RED) * 0.4
	elif indicator_mesh and indicator_mesh.get_surface_override_material(0):
		var material = indicator_mesh.get_surface_override_material(0) as StandardMaterial3D
		if material:
			material.albedo_color = Color(0.6, 1.0, 0.6, 1.0) if is_landing_available else Color(1.0, 0.6, 0.6, 1.0)


func _on_body_entered(body: Node) -> void:
	if not is_landing_available:
		return
	if body.is_in_group("player"):
		return

	set_landing_available(false)
	get_tree().call_group("game_manager", "_complete_game")
