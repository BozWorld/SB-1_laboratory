extends CharacterBody3D

# Paramètres de vol plus arcade et réactifs
@export var min_flight_speed: float = 8.0
@export var max_flight_speed: float = 35.0
@export var turn_speed: float = 1.2          # Plus réactif
@export var pitch_speed: float = 2.0         # Plus réactif
@export var level_speed: float = 4.0         # Banking plus rapide
@export var throttle_delta: float = 35.0     # Accélération plus rapide
@export var acceleration: float = 8.0        # Transition plus rapide
@export var helice: Node3D
@export var helice_rotation_speed: float = 4.0
@export var forward_speed: float = 0.0
@export var target_speed: float = 0

var grounded: bool = false 
var turn_input: float = 0.0
var pitch_input: float = 0.0
var previous_speed: float = 0.0
var is_accelerating: bool = false
var acceleration_intensity: float = 0.0

@export var data: RichTextLabel
@export var mesh: MeshInstance3D
@export var trail_particles: GPUParticles3D

# Nouveaux paramètres pour le trail
@export var min_trail_speed: float = 8.0  # Vitesse minimale pour voir le trail
@export var trail_fade_speed: float = 3.0  # Vitesse de disparition du trail
@export var max_trail_intensity: float = 1.0
@export var acceleration_trail_bonus: float = 0.5  # Bonus d'intensité quand on accélère

func get_input(delta):
	# Throttle input - Plus réactif
	var throttle_input = 0.0
	if Input.is_action_pressed("throttle_up"):
		target_speed = min(forward_speed + throttle_delta * delta, max_flight_speed)
		throttle_input = 1.0
	if Input.is_action_pressed("throttle_down"):
		var limit = 0 if grounded else min_flight_speed
		target_speed = max(forward_speed - throttle_delta * delta, limit)
		throttle_input = -1.0

	# Détection de l'accélération améliorée
	var speed_change = forward_speed - previous_speed
	is_accelerating = (speed_change > 0.05 and throttle_input > 0) or (throttle_input > 0 and forward_speed < target_speed)
	acceleration_intensity = clamp(abs(speed_change) * 15.0, 0.0, 1.0)
	
	# Turn input - Plus arcade, plus réactif
	turn_input = Input.get_axis("roll_right", "roll_left")
	if forward_speed <= 2.0:  # Seuil plus bas pour pouvoir tourner plus tôt
		turn_input *= 0.3  # Réduction mais pas annulation totale

	# Pitch input - Plus permissif
	pitch_input = Input.get_axis("pitch_down", "pitch_up")
	
	# Réduction du pitch seulement si on est vraiment trop lent
	if forward_speed < 3.0:
		pitch_input *= 0.5

func update_trail_system(delta):
	if not trail_particles:
		return
	
	# Calculer l'intensité basée sur la vitesse
	var speed_ratio = clamp((forward_speed - min_trail_speed) / (max_flight_speed - min_trail_speed), 0.0, 1.0)
	
	# Bonus d'intensité quand on accélère
	var final_intensity = speed_ratio
	if is_accelerating:
		final_intensity = min(final_intensity + acceleration_trail_bonus * acceleration_intensity, max_trail_intensity)
	
	# FORCER l'émission quand on va assez vite
	if forward_speed >= min_trail_speed:
		trail_particles.emitting = true
		
		# Amount directement, pas amount_ratio
		trail_particles.amount = int(lerp(30, 120, final_intensity))
		
		# Ajuster les paramètres des particules
		var material = trail_particles.process_material as ParticleProcessMaterial
		if material:
			# Vitesse des particules
			material.initial_velocity_min = lerp(2.0, 6.0, speed_ratio)
			material.initial_velocity_max = lerp(4.0, 10.0, speed_ratio)
			
			# Spread plus large quand on accélère
			material.spread = lerp(15.0, 35.0, final_intensity)
			
		# Durée de vie des particules
		trail_particles.lifetime = lerp(1.0, 3.0, final_intensity)
		
		# Traînée plus longue quand on accélère
		if is_accelerating:
			trail_particles.trail_lifetime = lerp(1.0, 2.0, acceleration_intensity)
		else:
			trail_particles.trail_lifetime = lerp(0.7, 1.5, speed_ratio)
			
	else:
		# Arrêter l'émission
		trail_particles.emitting = false

func _physics_process(delta):
	previous_speed = forward_speed
	
	get_input(delta)
	transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)
	transform.basis = transform.basis.rotated(Vector3.UP, turn_input * turn_speed * delta)
	
	# Bank when turning
	if grounded:
		mesh.rotation.z = 0
	else:
		mesh.rotation.z = lerpf(mesh.rotation.z, -turn_input, level_speed * delta)
	
	# Accelerate/decelerate
	forward_speed = lerpf(forward_speed, target_speed, acceleration * delta)
	
	# Movement is always forward
	velocity = -transform.basis.z * forward_speed
	
	# Landing
	if is_on_floor():
		if not grounded:
			rotation.x = 0
		grounded = true
	else:
		grounded = false
	
	# Hélice
	if helice:
		var spin = forward_speed * helice_rotation_speed * delta
		helice.rotate_z(spin)
	
	# Système de traînée amélioré
	update_trail_system(delta)
	
	# Debug info
	if data:
		data.text = "Vitesse: %.1f\nAccélération: %s\nIntensité: %.2f\nTrail: %s" % [
			forward_speed, 
			"OUI" if is_accelerating else "NON",
			acceleration_intensity,
			"ACTIF" if trail_particles.emitting else "INACTIF"
		]

	move_and_slide()
