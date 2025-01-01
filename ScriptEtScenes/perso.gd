extends CharacterBody3D
class_name SeshBody

var masse = 1.0
var poids = masse * 1.0 # Le 1 c'est la gravité

var velocite : Vector3
var acceleration : Vector3

@onready var mesh = $Mesh
@onready var machine_etats : StateMachine = $Etats
@onready var avancer = $Avancer
@onready var saut = $Saut
@onready var frottement_fluide = $FrottementFluide
@onready var frottement_statique = $FrottementStatique
@onready var regarder = $Regarder
@onready var frein = $Frein

@export var camera : Camera3D


func appliquer_force_verticale(force : float):
	acceleration.y += force

func appliquer_force_horizontale(force : Vector2):
	acceleration.x += force.x
	acceleration.z += force.y

func appliquer_force(force : Vector3):
	acceleration += force

func _appliquer_gravite():
	if not is_on_floor() :
		var gravite = Vector3(0, -poids, 0)
		appliquer_force(gravite)
	else :
		velocite.y = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	_appliquer_gravite()
	regarder._regarder_process(delta)
	saut._saut_process(delta)
	avancer._deplacement_process(delta)
	frein._deplacement_process(delta)
	
	print("++++++++++++++++++++++++++++++++++++++++++
	Acceleration : 
	Direction = " + str(acceleration.normalized()) + "
	Magnitude = " + str(acceleration.length()))
	
	if machine_etats.get_state() != machine_etats.states.attend :
		frottement_fluide._frottement_process(delta, velocite + acceleration)
		if machine_etats.get_state() != machine_etats.states.tombe && machine_etats.get_state() != machine_etats.states.saute :
			frottement_statique._frottement_process(delta, velocite + acceleration)
		
	
	velocite += acceleration
	
	print("=============================================
	Velocite : 
	Direction = " + str(velocite.normalized()) + "
	Magnitude = " + str(velocite.length()))
	
	velocity = velocite
	move_and_slide()
	acceleration = Vector3(0.0,0.0,0.0)
