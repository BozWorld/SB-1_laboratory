extends Node3D

const VITESSE_MIN := 0.1
const VITESSE_MAX := 50.0

@export var pas_vitesse := 0.1
@export var vitesse := 3.0
var acceleration := Vector3.ZERO
var velocite := Vector3.ZERO

var rotation_euler := Vector3.ZERO

var tel := false

@onready var frottements := $FrottementsFluide

var rotacceleration := Vector3.ZERO
var celerota := Vector3.ZERO
var sensi_souris := Vector2(0.0004, 0.0004)
var sensi_ae := 0.2
@export var vitesse_rota := 0.44

var rota_x := 0.0
var rota_y := 0.0
var rota_z := 0.0

func _ready() -> void:
	if OS.get_name() == "Android" :
		tel = true
 
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
	
	if puissance_input.length() == 0 and tel :
		var input_haptique = %JoyGauche.prendreInput()
		puissance_input.x = input_haptique.x
		puissance_input.z = input_haptique.y
		puissance_input.y = -%JoyGauche.prendreInputDeux()
	
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
		
		
	elif tel and %JoyDroite.actif :
		var input_rotation := Vector3.ZERO
		var input_haptique = %JoyDroite.prendreInput()
		input_rotation.x = -input_haptique.y 
		input_rotation.y = -input_haptique.x 
		input_rotation.z = -%JoyDroite.prendreInputDeux()
		
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
		rotation = rotation.lerp(Vector3.ZERO, delta * 4.44)
	
	celerota += rotacceleration
	rotacceleration = Vector3.ZERO
	if celerota :
		rota_y += celerota.y
		rota_x += celerota.x
		rota_z += celerota.z
		
		transform.basis = Basis()
		
		rotate_object_local(Vector3(0,1,0), rota_y)
		rotate_object_local(Vector3(1,0,0), rota_x)
		rotate_object_local(Vector3(0,0,1), rota_z)
				
		
		
		#var quaternion_actuel = transform.basis.get_rotation_quaternion()
		
		#if celerota.y != 0.0 :
			#var quat_y = Quaternion(Vector3.UP, celerota.y)
			#quaternion_actuel *= quat_y
		#if celerota.x != 0.0 :
			#var quat_x = Quaternion(Vector3.RIGHT, celerota.x)
			#quaternion_actuel *= quat_x
		
		#if celerota.z != 0.0 :
			#var avant_local = transform.basis.z
			#var quat_z = Quaternion(avant_local, celerota.z)
			#var quat_z = Quaternion(Vector3.FORWARD, celerota.z)
			#quaternion_actuel *= quat_z
		
		#transform.basis = Basis(quaternion_actuel)
		
		#rotation_euler += celerota
		#rotation = rotationextends
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
