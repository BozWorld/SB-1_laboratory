extends RefCounted
class_name PlaneAnimation


# === Références ===
var mesh_node: Node3D
var helice_node: Node3D

# === PARAMÈTRES D'ANIMATION ===
var helice_rotation_speed: float = 4.0
var banking_speed: float = 4.0
var stabilization_speed: float = 5.0

# === VARIABLES INTERNES ===
var current_bank_angle: float = 0.0
var target_bank_angle: float = 0.0

# === EFFET DE BOOM ===
var boom_active: bool = false
var boom_timer: float = 0.0
var boom_duration: float = 0.8
var boom_intensity: float = 1.0
var original_scale: Vector3 = Vector3.ONE

# === INITIALISATION ===
func setup(mesh: Node3D, helice: Node3D) -> void:
	mesh_node = mesh
	helice_node = helice

	if mesh_node:
		current_bank_angle = mesh_node.rotation.z
		original_scale = mesh_node.scale

func update_animations(physics_result: PhysicsResult, grounded: bool, delta: float):
	_update_helice_animation(physics_result.speed, delta)
	_update_banking_animation(physics_result.turn_input, grounded, delta)
	_update_stabilization(grounded, delta)
	_update_boom_effect(delta)

func trigger_boom_effect(intensity: float):
	boom_active = true
	boom_timer = 0.0
	boom_intensity = intensity
	print("Animation boom déclenchée avec intensité: %.2f" % intensity)

func _update_boom_effect(delta: float):
	if not boom_active or not mesh_node:
		return
	
	boom_timer += delta
	
	if boom_timer >= boom_duration:
		boom_active = false
		mesh_node.scale = original_scale
		return
	
	# Progression de l'effet (0 à 1)
	var progress = boom_timer / boom_duration
	
	# Effet élastique : compression puis expansion
	var elastic_factor: float
	if progress < 0.3:
		# Phase de compression rapide
		elastic_factor = 1.0 - (progress / 0.3) * 0.4 * boom_intensity
	elif progress < 0.7:
		# Phase d'expansion
		var expansion_progress = (progress - 0.3) / 0.4
		elastic_factor = 0.6 + expansion_progress * (1.6 * boom_intensity)
	else:
		# Phase de retour à la normale
		var return_progress = (progress - 0.7) / 0.3
		var max_scale = 1.0 + 0.6 * boom_intensity
		elastic_factor = max_scale - return_progress * (max_scale - 1.0)
	
	# Appliquer l'effet sur Y et Z, garder X normal
	mesh_node.scale = Vector3(
		original_scale.x,
		original_scale.y * elastic_factor,
		original_scale.z * elastic_factor
	)

# === ANIMATION DE l'HÉLICE ===
func _update_helice_animation(speed: float, delta: float):
	if not helice_node:
		return

	var spin_intensity = speed * helice_rotation_speed * delta
	helice_node.rotate_z(spin_intensity)

# === ANIMATION DE BANKING ( INCLINAISON ) ===
func _update_banking_animation(turn_input: float, grounded: bool, delta: float):
	if not mesh_node:
		print("ERREUR: mesh_node est null!")
		return
	
	print("=== BANKING DEBUG ===")
	print("Turn input: %.3f" % turn_input)
	print("Grounded: %s" % grounded)
	
	if grounded:
		target_bank_angle = 0.0
	else:
		target_bank_angle = turn_input * deg_to_rad(45.0)
	
	print("Target bank: %.2f°" % rad_to_deg(target_bank_angle))
	
	current_bank_angle = lerpf(current_bank_angle, target_bank_angle, banking_speed * delta)
	print("Current bank: %.2f°" % rad_to_deg(current_bank_angle))
	
	# Teste les 3 axes
	mesh_node.rotation.z = current_bank_angle  # Banking normal
	print("Applied rotation.z: %.2f°" % rad_to_deg(mesh_node.rotation.z))
	print("===================")

# === STABILISATION AU SOL ===
func _update_stabilization(grounded: bool, delta: float):
	if not mesh_node:
		return

	if grounded:
		mesh_node.rotation.x = lerpf(mesh_node.rotation.x, 0, stabilization_speed * delta)

# === MËTHODE UTILITAIRES ===
func get_debug_string() -> String:
	var bank_degrees = rad_to_deg(current_bank_angle)
	var boom_status = "BOOM!" if boom_active else "Normal"
	return "Animation - Bank: %.1f°, Boom: %s" % [bank_degrees, boom_status]

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