extends Camera3D

@export_category("Cible")
@export var target_path : NodePath
#@export var offset = Vector3(0, 1.5, 6)
#@export var lookahead = Vector3(0, 2, -6)
@export var angular_speed := 0.2
#@export var lerp_speed = 3.0

#@export_category("Ajustement dynamique")
#@export var max_distance_factor = 1.3
#@export var speed_for_max_distance = 35.0

@export_category("Effet de Boom")
@export var boom_enabled = true
@export var boom_speed_threshold = 1
@export var boom_intensity = 8.0  # Augmenté de 3.0 à 8.0
@export var boom_duration = 1.2   # Augmenté de 0.6 à 1.2
@export var boom_shake_intensity = 0.8  # Augmenté de 0.15 à 0.8
@export var boom_intensity_multiplier = 3
@export var offset_intensity_multiplier = 2.0

var target : Node3D
var current_offset : Vector3
var boom_active = false
var boom_timer = 0.0
var prev_speed = 0.0

func _ready():
	#current = true
	#current_offset = offset

	print("Camera _ready() - target_path: ", target_path)
	if target_path != NodePath(""):
		target = get_node(target_path) as Node3D
		print("Camera: Target trouvé - ", target.name if target else "ERREUR")
		
		# Connecter au signal boom_effect_triggered du plane
		if target and target.has_signal("boom_effect_triggered"):
			target.boom_effect_triggered.connect(_on_plane_boom_triggered)
	else:
		print("Aucun target_path défini!")

func _on_plane_boom_triggered(intensity: float):
	if boom_intensity <= 0.0 and boom_shake_intensity <= 0.0:
		return
	boom_active = true
	boom_timer = 0.0
	boom_intensity = intensity * boom_intensity_multiplier  # Augmenté de 3.0 à 10.0
	print("Caméra: Boom synchronisé avec intensité %.2f" % intensity)

func _physics_process(delta):
	if not target:
		return

	#var speed := _get_speed()
	
	# Ajuster l'offset basé sur la vitesse avec plafond
	#var speed_factor = clampf(speed / speed_for_max_distance, 0.0, 1.0)
	#var distance_multiplier = lerpf(1.0, max_distance_factor, speed_factor)
	#var target_offset = offset * distance_multiplier

	var boom_offset = Vector3.ZERO
	var boom_rotation = Vector3.ZERO
	
	# Effet de boom BEAUCOUP plus dramatique
	if boom_active:
		boom_timer += delta
		if boom_timer >= boom_duration:
			boom_active = false
		else:
			var t = boom_timer / boom_duration
			
			# Effet élastique de recul/projection AMPLIFIÉ
			var offset_intensity: float
			if t < 0.3:
				# Phase de recul rapide et violent
				offset_intensity = (t / 0.3) * boom_intensity * offset_intensity_multiplier
			elif t < 0.6:
				# Phase de projection explosive
				var proj_progress = (t - 0.3) / 0.3
				offset_intensity = boom_intensity * offset_intensity_multiplier * (1.0 - proj_progress * 1.0)
			else:
				# Phase de retour avec oscillations
				var return_progress = (t - 0.6) / 0.4
				offset_intensity = -boom_intensity  * sin(return_progress * PI * 2.0) * (1.0 - return_progress)
			
			# Mouvement plus dramatique sur Z ET Y
			boom_offset = Vector3(
				sin(t * 30.0) * boom_intensity * 0.1,  # Mouvement latéral
				sin(t * 25.0) * boom_intensity * 0.08,  # Mouvement vertical 
				offset_intensity * 0.3  # Mouvement avant/arrière principal
			)
			
			# Shake BEAUCOUP plus intense
			var shake_freq = 80.0 if t < 0.5 else 40.0
			var shake = sin(t * shake_freq) * (1.0 - t * 0.7) * boom_shake_intensity * boom_intensity
			boom_rotation = Vector3(
				shake * 0.25,  # Augmenté de 0.08 à 0.25
				shake * 0.18,  # Augmenté de 0.05 à 0.18
				shake * 0.12   # Augmenté de 0.03 à 0.12
			)

	#var final_offset = target_offset + boom_offset

	# Augmenter la limite pour permettre plus de mouvement
	#var max_allowed = offset.length() * 4.0  # Augmenté de 2.5 à 4.0
	#if final_offset.length() > max_allowed:
		#final_offset = final_offset.normalized() * max_allowed
	#
	## Lerp plus rapide pour le boom
	#var effective_lerp_speed = lerp_speed * (3.0 if boom_active else 1.0)
	#current_offset = current_offset.lerp(final_offset, effective_lerp_speed * delta)

	# Appliquer position et rotation
	#var desired_position = target.global_transform.origin + target.global_transform.basis * current_offset
	#global_transform.origin = global_transform.origin.lerp(desired_position, effective_lerp_speed * delta)

	#var look_target = target.global_transform.origin + target.global_transform.basis * lookahead
	#look_at(look_target, Vector3.UP)
	
	#if 
	
	if target.transform.basis != transform.basis :
		var rota = Quaternion(transform.basis.orthonormalized())
		var rota_target = Quaternion(target.transform.basis.orthonormalized())

		var new_rota = rota.slerp(rota_target, angular_speed)
		transform.basis = Basis(new_rota)


	# Appliquer l'effet de shake PLUS INTENSE
	if boom_active and boom_rotation != Vector3.ZERO:
		rotate_object_local(Vector3.RIGHT, boom_rotation.x)
		rotate_object_local(Vector3.UP, boom_rotation.y)
		rotate_object_local(Vector3.FORWARD, boom_rotation.z)

#func _get_speed() -> float:
	#if not target:
		#return 0.0
	#if target.has_method("get_current_speed"):
		#return target.get_current_speed()
	#elif "current_speed" in target:
		#return target.current_speed
	#elif "forward_speed" in target:
		#return target.forward_speed
	#return 0.0
