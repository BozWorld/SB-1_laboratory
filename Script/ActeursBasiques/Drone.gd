extends Node3D

const VITESSE_MIN := 0.1
const VITESSE_MAX := 50.0

@export var pas_vitesse := 0.1
@export var vitesse := 3.0
var acceleration := Vector3.ZERO
var velocite := Vector3.ZERO

var rotation_euler := Vector3.ZERO

@onready var frottements := $FrottementsFluide

var rotacceleration := Vector3.ZERO
var celerota := Vector3.ZERO
var sensi_souris := Vector2(0.0004, 0.0004)
var sensi_ae := 0.2
@export var vitesse_rota := 0.44

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton :
		if event.button_index == 4 :
			vitesse = clampf(vitesse + pas_vitesse, VITESSE_MIN, VITESSE_MAX)
		if event.button_index == 5 :
			vitesse = clampf(vitesse - pas_vitesse, VITESSE_MIN, VITESSE_MAX)
			

func prendInputDeplacement():
	var deplacement : Vector3
	var puissance_input : Vector3
	
	puissance_input.x = Input.get_axis("gauche","droite")
	puissance_input.y = Input.get_axis("bas","haut")
	puissance_input.z = Input.get_axis("avant","arriere")
	
	
	
	deplacement = global_transform.basis.z * puissance_input.z
	deplacement += global_transform.basis.y * puissance_input.y
	deplacement += global_transform.basis.x * puissance_input.x
	
	return deplacement.normalized() * vitesse


func prendInputRotation():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED :
		#var rota : Vector3
		#var puissance_input : Vector3
		#
		#puissance_input.x = -Input.get_last_mouse_velocity().y * sensi_souris.x
		#puissance_input.y = -Input.get_last_mouse_velocity().x * sensi_souris.y
		#puissance_input.z = Input.get_axis("rota_gauche","rota_droite") * sensi_ae
		#
		#
		#rota = global_transform.basis.x * puissance_input.x
		#rota += global_transform.basis.y * puissance_input.y
		#
		#rota.z = 0.0
		#
		#rota += global_transform.basis.z * puissance_input.z
		##print(rotation)
		#print(rota)
		#return rota.normalized() * vitesse_rota
		var input_rotation := Vector3.ZERO
		input_rotation.x = - Input.get_last_mouse_velocity().y * sensi_souris.x
		input_rotation.y = - Input.get_last_mouse_velocity().x * sensi_souris.y
		input_rotation.z = Input.get_axis("rota_gauche","rota_droite") * sensi_ae
		
		return input_rotation * vitesse_rota
		
	else : return Vector3.ZERO

func appliquer_force(force : Vector3):
	acceleration += force

func appliquer_rotation(rota : Vector3):
	rotacceleration += rota

func _physics_process(delta: float) -> void:
	var pivot = prendInputRotation()
	if pivot :
		appliquer_rotation(pivot * delta)
	
	
	
	#if rotation.z :
		#appliquer_rotation(Vector3(0.0, 0.0, rotation.z) * -0.01)
		#rotation.z *= 0.9
	
	if Input.is_action_pressed("normaliserRota"):
		appliquer_rotation(-celerota * 0.2)
	
	celerota += rotacceleration
	rotacceleration = Vector3.ZERO
	if celerota :
		var quaternion_actuel = transform.basis.get_rotation_quaternion()
		
		if celerota.y != 0.0 :
			var quat_y = Quaternion(Vector3.UP, celerota.y)
			quaternion_actuel *= quat_y
		if celerota.x != 0.0 :
			var quat_x = Quaternion(Vector3.RIGHT, celerota.x)
			quaternion_actuel *= quat_x
		
		if celerota.z != 0.0 :
			#var avant_local = transform.basis.z
			#var quat_z = Quaternion(avant_local, celerota.z)
			var quat_z = Quaternion(Vector3.FORWARD, celerota.z)
			quaternion_actuel *= quat_z
		
		transform.basis = Basis(quaternion_actuel)
		
		#rotation_euler += celerota
		#rotation = rotation_euler
		celerota *= 0.9
	
	
	
	var impulse = prendInputDeplacement()
	if impulse :
		appliquer_force(impulse * delta)
	
	if velocite :
		frottements._frottement_process(delta, velocite)
	
	if Input.is_action_pressed("normaliserVitesse"):
		appliquer_force(-velocite * 0.2)
	
	velocite += acceleration
	acceleration *= 0.0
	position += velocite
