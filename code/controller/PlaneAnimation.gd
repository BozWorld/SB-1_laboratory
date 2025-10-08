extends RefCounted
class_name PlaneAnimation


# === Références ===
var mesh_node: Node3D
var helice_node: Node3D

# === PARAMÈTRES D'ANIAMTION ===
var helice_rotation_speed: float = 4.0
var banking_speed: float = 4.0
var stabilization_speed: float = 5.0

# === VARIABLE INTERNES ===
var current_bank_angle: float = 0.0
var target_bank_angle: float = 0.0

# === INITIALISATION ===
func setup(mesh: Node3D, helice: Node3D) -> void:
    mesh_node = mesh
    helice_node = helice

    if mesh_node:
        current_bank_angle = mesh_node.rotation.z

func update_animations(physics_result: PhysicsResult, grounded: bool, delta: float):
        _update_helice_animation(physics_result.speed, delta)
        _update_banking_animation(physics_result.turn_input, grounded, delta)
        _update_stabilization(grounded, delta)

# === ANIMATION DE l'HÉLICE ===
func _update_helice_animation(speed: float, delta: float):
    if not helice_node:
        return

    var spin_intensity = speed * helice_rotation_speed * delta
    helice_node.rotate_z(spin_intensity)

# === ANIMATION DE BANKING ( INCLINAISON ) ===
func _update_banking_animation(turn_input: float, grounded: bool, delta: float):
    if not mesh_node:
        return

    if grounded:
        target_bank_angle = 0.0
    else:
        target_bank_angle = turn_input * deg_to_rad(45.0)

    current_bank_angle = lerpf(current_bank_angle, target_bank_angle, banking_speed * delta)
    mesh_node.rotation.z = current_bank_angle

# === STABILISATION AU SOL ===
func _update_stabilization(grounded: bool, delta: float):
    if not mesh_node:
        return

    if grounded:
        mesh_node.rotation.x = lerpf(mesh_node.rotation.x, 0, stabilization_speed * delta)

# === MËTHODE UTILITAIRES ===
func get_debug_string() -> String:
    var bank_degrees = rad_to_deg(current_bank_angle)
    var helice_status = "ACTIF" if helice_node else "ABSENT"
    var mesh_status = "ACTIF" if mesh_node else "ABSENT"

    return "Animation - Bank: %.1f° | Hélice: %s, Mesh: %s" % [bank_degrees, helice_status, mesh_status]

# === CONFIGURATION ===
func set_helice_speed(speed: float):
    helice_rotation_speed = speed

func set_banking_speed(speed: float):
    banking_speed = speed

func set_stabilization_speed(speed: float):
    stabilization_speed = speed

# === EFFETS SPËCIAUX (OPTIONNEL) ===
func add_takeoff_effect():
    if mesh_node:
        var tween = mesh_node.create_tween()
        tween.tween_property(mesh_node, "position:y", mesh_node.positon.y + 0.2, 0.5)
        tween.tween_property(mesh_node, "position:y", mesh_node.position.y, 0.5)

func add_landing_effect():
    if mesh_node:
        var tween = mesh_node.create_tween()
        tween.tween_property(mesh_node, "scale", Vector3(1.1, 0.9, 1.1), 0.2)
        tween.tween_property(mesh_node, "scale", Vector3.ONE, 0.3)