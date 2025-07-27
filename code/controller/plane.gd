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

# Variables de vitesse simplifiées
var forward_speed: float = 0.0
var target_speed: float = 0.0
var previous_speed: float = 0.0

# États
var grounded: bool = false 
var was_grounded: bool = false  # Pour détecter le changement d'état
var turn_input: float = 0.0
var pitch_input: float = 0.0
var is_accelerating: bool = false
var acceleration_intensity: float = 0.0

@export var data: RichTextLabel
@export var mesh: MeshInstance3D

# TRAIL CONTROLS
@export var trail_node: trail3D  # Référence au trail3D
@export var min_trail_speed: float = 8.0

func get_input(delta):
	# Throttle input
	var throttle_input = 0.0
	var throttle_change = 0.0
	
	if Input.is_action_pressed("throttle_up"):
		throttle_change = throttle_delta * delta
		throttle_input = 1.0
	elif Input.is_action_pressed("throttle_down"):
		throttle_change = -throttle_delta * delta
		throttle_input = -1.0
	
	# Appliquer le changement de throttle
	if throttle_change != 0:
		target_speed += throttle_change
		# CORRECTION: Permettre l'accélération au sol pour le décollage
		var speed_limit = 0.0  # Toujours permettre l'arrêt complet
		var max_limit = max_flight_speed
		# Au sol, permettre d'atteindre la vitesse de décollage
		if grounded:
			max_limit = min_flight_speed * 1.5  # 150% de la vitesse min pour décoller
		
		target_speed = clamp(target_speed, speed_limit, max_limit)
	
	# Détection de l'accélération améliorée
	var speed_change = forward_speed - previous_speed
	is_accelerating = (throttle_input > 0 and forward_speed < target_speed) or speed_change > 0.1
	acceleration_intensity = clamp(abs(speed_change) * 10.0, 0.0, 1.0)
	
	# Turn input
	turn_input = Input.get_axis("roll_right", "roll_left")
	if forward_speed <= 2.0:
		turn_input *= 0.3

	# Pitch input
	pitch_input = Input.get_axis("pitch_down", "pitch_up")
	
	# Empêcher le pitch au sol
	if grounded:
		pitch_input = 0.0
	elif forward_speed < 3.0:
		pitch_input *= 0.5

func update_trail_system():
	# Contrôler le trail basé sur la vitesse ET le fait d'être au sol
	if trail_node:
		var should_trail = forward_speed >= min_trail_speed and not grounded
		
		# Si on doit passer de actif à inactif, effacer le trail
		if trail_node._trainee_activee and not should_trail:
			trail_node.set_trail_enabled(false)
		# Si on doit passer de inactif à actif, activer le trail
		elif not trail_node._trainee_activee and should_trail:
			trail_node.set_trail_enabled(true)

func _ready():
	# Récupérer automatiquement le trail3D si pas assigné
	if not trail_node:
		trail_node = get_node_or_null("trail3D")

func _physics_process(delta):
	previous_speed = forward_speed
	was_grounded = grounded
	
	get_input(delta)
	
	# Appliquer les rotations
	if not grounded or abs(pitch_input) > 0:
		transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)
	
	transform.basis = transform.basis.rotated(Vector3.UP, turn_input * turn_speed * delta)
	
	# Bank when turning
	if grounded:
		mesh.rotation.z = 0
	else:
		mesh.rotation.z = lerpf(mesh.rotation.z, turn_input, level_speed * delta)
	
	# Accélération/décélération
	forward_speed = lerpf(forward_speed, target_speed, acceleration * delta)
	
	# Movement is always forward
	velocity = -transform.basis.z * forward_speed
	
	# LOGIQUE D'ATTERRISSAGE ET DÉCOLLAGE CORRIGÉE
	var currently_on_floor = is_on_floor()
	
	if currently_on_floor:
		# Conditions pour être vraiment au sol
		var low_speed = forward_speed < min_flight_speed * 0.9
		var stable_contact = was_grounded
		var gentle_landing = velocity.y > -5.0
		
		# DÉCOLLAGE: Si on va assez vite, forcer le décollage
		if forward_speed >= min_flight_speed * 1.1:
			grounded = false
			# Ajouter une petite poussée vers le haut pour le décollage
			velocity.y += 3.0 * delta * (forward_speed / min_flight_speed)
		elif (low_speed or stable_contact or gentle_landing):
			grounded = true
			# Stabiliser l'avion au sol
			rotation.x = lerpf(rotation.x, 0.0, 5.0 * delta)
			rotation.z = lerpf(rotation.z, 0.0, 5.0 * delta)
			
			# Empêcher de s'enfoncer dans le sol
			if velocity.y < 0:
				velocity.y = 0
		else:
			grounded = false
	else:
		grounded = false
	
	# Hélice
	if helice:
		var spin = forward_speed * helice_rotation_speed * delta
		helice.rotate_z(spin)
	
	# Système de trail
	update_trail_system()
	
	# Debug info
	if data:
		data.text = "Vitesse: %.1f / %.1f\nAccélération: %s (%.1f)\nIntensité: %.2f\nTrail: %s\nAu sol: %s\nSol détecté: %s\nVitesse Y: %.2f" % [
			forward_speed, 
			target_speed,
			"OUI" if is_accelerating else "NON",
			acceleration,
			acceleration_intensity,
			"ACTIF" if trail_node and trail_node._trainee_activee else "INACTIF",
			"OUI" if grounded else "NON",
			"OUI" if currently_on_floor else "NON",
			velocity.y
		]

	move_and_slide()