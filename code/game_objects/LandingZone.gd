extends Area3D
class_name LandingZone
var is_landing_available: bool = false
var indicator_mesh: MeshInstance3D
var _materials: Array[StandardMaterial3D] = []

func _ready() -> void:
    add_to_group("landing_zone")
    body_entered.connect(_on_body_entered)
    indicator_mesh = %terrain_mesh_type_01
    _setup_materials()
    set_landing_available(false)

func _setup_materials() -> void:
    if not indicator_mesh or not indicator_mesh.mesh:
        return
    _materials.clear()
    var sc := indicator_mesh.mesh.get_surface_count()
    for i in sc:
        var mat := StandardMaterial3D.new()
        mat.resource_local_to_scene = true
        mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
        mat.emission_enabled = true
        indicator_mesh.set_surface_override_material(i, mat)
        _materials.append(mat)

func set_landing_available(available: bool) -> void:
    is_landing_available = available
    _update_visual_state()

func _update_visual_state() -> void:
    var col := Color(0.2, 1.0, 0.2) if is_landing_available else Color(1.0, 0.2, 0.2)
    for mat in _materials:
        mat.albedo_color = col
        mat.emission = col

func _on_body_entered(body: Node) -> void:
    if not is_landing_available:
        return
    if not body.is_in_group("player"):
        return
    set_landing_available(false)
    get_tree().call_group("game_manager", "_complete_game")
