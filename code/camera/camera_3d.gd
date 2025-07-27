@tool
extends Camera3D

@export var target_path : NodePath
@export var lerp_speed = 3.0
@export var lookahead = Vector3(0, 2, -6)  # où regarder
@export var offset = Vector3(0, 1.5, 6)    # position de la cam
@export var max_speed_threshold = 20.0     # vitesse à partir de laquelle on plafonne
@export var max_distance_factor = 1.4      # facteur maximum de distance (140% de l'offset original)

# Paramètres pour l'effet de boom
@export var boom_enabled = true
@export var boom_speed_threshold = 30.0    # Vitesse à laquelle le boom se déclenche
@export var boom_intensity = 10.0          # Intensité maximale du recul (facteur multiplicateur)
@export var boom_duration = 0.6            # Durée totale de l'effet en secondes
@export var boom_shake_intensity = 0.2     # Intensité de la secousse de caméra (0-1)

# Courbes d'animation
@export var distance_curve: Curve          # Courbe pour la relation vitesse/distance
@export var boom_curve: Curve              # Courbe pour l'effet de boom (progression temporelle)

var target : Node3D
var current_offset : Vector3

# Variables pour l'effet de boom
var boom_active = false
var boom_timer = 0.0
var prev_speed = 0.0

func _ready():
	print("Camera _ready() - target_path: ", target_path)
	if target_path:
		target = get_node(target_path)
		print("Target trouvé: ", target)
		if target:
			print("Target name: ", target.name)
			print("Target a forward_speed: ", "forward_speed" in target)
	else:
		print("Aucun target_path défini!")
	current_offset = offset

func _physics_process(delta):
	if not target:
		return

	# Ajuster l'offset basé sur la vitesse avec plafond
	var target_offset = offset
	var boom_offset = Vector3.ZERO
	var boom_rotation = Vector3.ZERO
	
	if target and "forward_speed" in target:
		var speed = target.forward_speed
		
		# Gestion de l'effet de boom
		if boom_enabled:
			# Détecter le franchissement du seuil
			var just_crossed = (prev_speed < boom_speed_threshold and speed >= boom_speed_threshold)
			
			if just_crossed and not boom_active:
				boom_active = true
				boom_timer = 0.0
				print("BOOM! Vitesse: ", speed)
			
			# Mise à jour de l'effet de boom
			if boom_active:
				boom_timer += delta
				
				if boom_timer >= boom_duration:
					boom_active = false
				else:
					# Calculer l'intensité du boom
					var t = boom_timer / boom_duration
					var intensity_factor = 0.0
					
					# Vérification de sécurité pour le boom_curve
					if boom_curve != null:
						var sample = boom_curve.sample(t)
						# S'assurer que sample n'est pas nul
						if sample != null:
							intensity_factor = sample * boom_intensity
						else:
							intensity_factor = t * boom_intensity # Fallback simple si sample est null
					else:
						# Courbe améliorée par défaut si pas de boom_curve
						if t < 0.15:
							# Phase 1: Explosion rapide (accélération exponentielle)
							intensity_factor = pow(t / 0.15, 0.5) * boom_intensity
						else:
							# Phase 2: Retour progressif (décélération progressive)
							intensity_factor = boom_intensity * pow(1.0 - (t - 0.15) / 0.85, 2.0)
					
					# S'assurer que offset.length() est défini
					var offset_length = offset.length()
					if offset_length > 0:
						# Appliquer l'effet de boom - recul dans la direction opposée au mouvement
						boom_offset = transform.basis.z * (offset_length * intensity_factor)
					
					# Vérifier que boom_shake_intensity est défini avant de l'utiliser
					var shake_intensity = boom_shake_intensity if boom_shake_intensity != null else 0.1
					var shake = sin(t * 45.0) * (1.0 - t) * shake_intensity
					
					# S'assurer que boom_intensity est défini
					var safe_boom_intensity = boom_intensity if boom_intensity != null else 1.0
					boom_rotation = Vector3(
						shake * 0.1 * safe_boom_intensity,  # Augmenter de 0.03 à 0.1
						shake * 0.08 * safe_boom_intensity, # Augmenter de 0.02 à 0.08
						0
					)
		
		# Ajuster max_speed_threshold pour correspondre à la vitesse max de l'avion
		var effective_max_speed = max(max_speed_threshold, 70.0)
		
		# Calculer le facteur de distance avec une courbe si disponible
		var normalized_speed = clamp(speed / effective_max_speed, 0.0, 1.0)
		var distance_factor = 0.0
		
		if distance_curve != null:
			var sample = distance_curve.sample(normalized_speed)
			# Vérifier si sample n'est pas nul
			if sample != null:
				distance_factor = 1.0 + sample
			else:
				# Fallback si sample est nul
				distance_factor = 1.0 + (normalized_speed * 0.4)
		else:
			# Fallback au calcul original
			var actual_max_distance = min(max_distance_factor, 2.0)
			distance_factor = 1.0 + (actual_max_distance - 1.0) * normalized_speed
		
		# Limiter la distance absolue maximum
		target_offset = offset * distance_factor
		
		# Calculer la distance actuelle et limiter si nécessaire
		var current_distance = target_offset.length()
		var max_allowed_distance = offset.length() * 3.0  # Distance maximale absolue
		if current_distance > max_allowed_distance:
			target_offset = target_offset.normalized() * max_allowed_distance
		
		# Sauvegarder la vitesse actuelle pour la prochaine image
		prev_speed = speed
	
	# Interpoler smoothement vers le nouvel offset
	# Ajuster dynamiquement la vitesse d'interpolation en fonction de la vitesse de l'avion
	var adaptive_lerp = lerp_speed
	if target and "forward_speed" in target:
		# Plus rapide à haute vitesse pour mieux suivre
		adaptive_lerp = lerp(lerp_speed, lerp_speed * 3.0, target.forward_speed / 70.0)
	
	# Combiner l'offset normal et l'effet de boom
	var final_offset = target_offset + boom_offset
	current_offset = current_offset.lerp(final_offset, adaptive_lerp * delta * 2.0)
	
	var desired_position = target.global_transform.origin + target.global_transform.basis * current_offset
	global_transform.origin = global_transform.origin.lerp(desired_position, adaptive_lerp * delta)

	var look_target = target.global_transform.origin + target.global_transform.basis * lookahead
	look_at(look_target, Vector3.UP)
	
	# Appliquer la rotation de secousse si l'effet de boom est actif
	if boom_active and boom_rotation != Vector3.ZERO:
		rotate_object_local(Vector3.RIGHT, boom_rotation.x)
		rotate_object_local(Vector3.UP, boom_rotation.y)
