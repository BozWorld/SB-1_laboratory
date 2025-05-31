extends MeshInstance3D

@export var hauteur_toit = 0
@export var legerete_helium = 1.0
@export var puissance_vent = 1.0

var velocite : Vector3
var acceleration : Vector3


func appliquerForce(force : Vector3):
	acceleration += force

func _rebond_plafond():
	var force_plafond = Vector3(0.0,-velocite.y*1.5,0.0)
	appliquerForce(force_plafond)

func _helium_process():
	var force_helium = Vector3(0.0, 0.001*legerete_helium, 0.0)
	appliquerForce(force_helium)

func _coup_de_vent():
	var force_vent = Vector3(randf_range(-0.05,0.05),0.0,randf_range(-0.05,0.05))*puissance_vent
	appliquerForce(force_vent)

func _frottement_horizontaux():
	var frottement = Vector3(0,0,0)
	frottement.x = -velocite.x*0.01
	frottement.z = -velocite.z*0.01
	appliquerForce(frottement)

func _process(delta: float) -> void:
	if position.y + mesh.height/2 >= hauteur_toit:
		_rebond_plafond()
	else :
		_helium_process()
	_frottement_horizontaux()
	
	velocite += acceleration
	position += velocite
	acceleration = acceleration * 0

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_coup_de_vent()
