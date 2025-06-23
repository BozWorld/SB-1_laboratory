extends Node3D

var vitesse := 1.0
var acceleration := Vector3.ZERO
var velocite := Vector3.ZERO

@onready var frottements := $FrottementsFluide

var rotacceleration := Vector3.ZERO
var celerota := Vector3.ZERO
var sensi_souris := Vector2(0.0004, 0.0004)
var sensi_ae := 0.2

func prendInputDeplacement():
	var deplacement := Vector3.ZERO
	
	deplacement.z = Input.get_axis("avant","arriere")
	deplacement.x = Input.get_axis("gauche","droite")
	deplacement.y = Input.get_axis("bas","haut")
	
	return deplacement.rotated(Vector3.UP, rotation.y).rotated(Vector3.RIGHT, rotation.x)


func prendInputRotation():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED :
		var rota := Vector3.ZERO
		var mod_souris = sensi_souris #.rotated(rotation.z)
		
		rota.x = -Input.get_last_mouse_velocity().y * mod_souris.x
		rota.y = -Input.get_last_mouse_velocity().x * mod_souris.y
		rota.z = Input.get_axis("rota_gauche","rota_droite") * sensi_ae
		
		return rota.rotated(Vector3.BACK, rotation.z)

func appliquer_force(force : Vector3):
	acceleration += force

func appliquer_rotation(rota : Vector3):
	rotacceleration += rota

func _physics_process(delta: float) -> void:
	var pivot = prendInputRotation()
	if pivot :
		appliquer_rotation(pivot * delta)
	
	if celerota :
		celerota *= 0.9
	
	#if rotation.z :
		#appliquer_rotation(Vector3(0.0, 0.0, rotation.z) * -0.01)
		#rotation.z *= 0.9
	
	if Input.is_action_pressed("normaliserRota"):
		appliquer_rotation(-celerota * 0.2)
	
	celerota += rotacceleration
	rotacceleration *= 0.0
	rotation += celerota
	
	
	
	
	var impulse = prendInputDeplacement()
	if impulse :
		appliquer_force(impulse * vitesse * delta)
	
	if velocite :
		frottements._frottement_process(delta, velocite)
	
	if Input.is_action_pressed("normaliserVitesse"):
		appliquer_force(-velocite * 0.2)
	
	velocite += acceleration
	acceleration *= 0.0
	position += velocite
