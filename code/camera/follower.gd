extends Node3D

@export var target : Node3D
@export var camera : Camera3D

@export var lspeed_motion:= 4.4
@export var aspeed_motion:= 2.0

@export var lspeed_brake:= 8.0
@export var aspeed_brake:= 8.0

var linear_speed:= lspeed_motion
var angular_speed:= aspeed_motion

@export_category("Effet de Boom")
@export var boom_enabled = true
@export var boom_speed_threshold = 1
@export var boom_intensity = 8.0  # Augmenté de 3.0 à 8.0
@export var boom_duration = 1.2   # Augmenté de 0.6 à 1.2
@export var boom_shake_intensity = 0.8  # Augmenté de 0.15 à 0.8
@export var boom_intensity_multiplier = 3
@export var offset_intensity_multiplier = 2.0

var latency := 0.0

var boom_active = false
var boom_timer = 0.0

var camera_offset: Vector3
var camera_angle: Vector3

func _ready():
	if camera:
		camera_offset = camera.position
		camera_angle = camera.rotation
	#current = true
	#current_offset = offset

	if target :
		# Connecter au signal boom_effect_triggered du plane
		if target.has_signal("boom_effect_triggered"):
			target.boom_effect_triggered.connect(_on_plane_boom_triggered)
	else:
		print("Aucun target défini!")


func _update_cam(delta: float, brake: bool):
	update_speed(brake)
	if target :
		update_position(delta)
	if camera :
		update_boom(delta)

func update_speed(brake: bool):
	if brake:
		angular_speed = aspeed_brake
		linear_speed = lspeed_brake
	else:
		angular_speed = aspeed_motion
		linear_speed = lspeed_motion

func update_position(delta: float):
	if target.position != position :
		position = position.slerp(target.position, linear_speed * delta)
		latency = (target.position-position).length()
	if target.transform.basis != transform.basis :
		var rota = Quaternion(transform.basis.orthonormalized())
		var rota_target = Quaternion(target.transform.basis.orthonormalized())

		var nouvelle_rota = rota.slerp(rota_target, angular_speed * delta)
		transform.basis = Basis(nouvelle_rota)

func update_boom(delta: float):
	var boom_offset = Vector3.ZERO
	var boom_rotation = Vector3.ZERO
		
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
	camera.position = boom_offset + camera_offset
	camera.rotation = boom_rotation + camera_angle



func _on_plane_boom_triggered(intensity: float):
	if boom_intensity <= 0.0 and boom_shake_intensity <= 0.0:
		return
	boom_active = true
	boom_timer = 0.0
	boom_intensity = intensity * boom_intensity_multiplier  # Augmenté de 3.0 à 10.0
	print("Caméra: Boom synchronisé avec intensité %.2f" % intensity)


#func _physics_process(delta):
	#if target :
		#if target.position != position :
			#position = position.slerp(target.position, linear_speed * delta)
			#latency = (target.position-position).length()
		#if target.transform.basis != transform.basis :
			#var rota = Quaternion(transform.basis.orthonormalized())
			#var rota_target = Quaternion(target.transform.basis.orthonormalized())
#
			#var nouvelle_rota = rota.slerp(rota_target, angular_speed * delta)
			#transform.basis = Basis(nouvelle_rota)
	#
	#if camera :
		#var boom_offset = Vector3.ZERO
		#var boom_rotation = Vector3.ZERO
		#
		#if boom_active:
			#boom_timer += delta
			#if boom_timer >= boom_duration:
				#boom_active = false
			#else:
				#var t = boom_timer / boom_duration
				#
				## Effet élastique de recul/projection AMPLIFIÉ
				#var offset_intensity: float
				#if t < 0.3:
					## Phase de recul rapide et violent
					#offset_intensity = (t / 0.3) * boom_intensity * offset_intensity_multiplier
				#elif t < 0.6:
					## Phase de projection explosive
					#var proj_progress = (t - 0.3) / 0.3
					#offset_intensity = boom_intensity * offset_intensity_multiplier * (1.0 - proj_progress * 1.0)
				#else:
					## Phase de retour avec oscillations
					#var return_progress = (t - 0.6) / 0.4
					#offset_intensity = -boom_intensity  * sin(return_progress * PI * 2.0) * (1.0 - return_progress)
				#
				## Mouvement plus dramatique sur Z ET Y
				#boom_offset = Vector3(
					#sin(t * 30.0) * boom_intensity * 0.1,  # Mouvement latéral
					#sin(t * 25.0) * boom_intensity * 0.08,  # Mouvement vertical 
					#offset_intensity * 0.3  # Mouvement avant/arrière principal
				#)
				#
				## Shake BEAUCOUP plus intense
				#var shake_freq = 80.0 if t < 0.5 else 40.0
				#var shake = sin(t * shake_freq) * (1.0 - t * 0.7) * boom_shake_intensity * boom_intensity
				#boom_rotation = Vector3(
					#shake * 0.25,  # Augmenté de 0.08 à 0.25
					#shake * 0.18,  # Augmenté de 0.05 à 0.18
					#shake * 0.12   # Augmenté de 0.03 à 0.12
				#)
		#
		#camera.position = boom_offset + camera_offset
		#camera.rotation = boom_rotation + camera_angle
