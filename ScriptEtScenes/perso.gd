extends CharacterBody3D
class_name SeshBody

var masse = 1.0
var poids = masse * 1.0 # Le 1 c'est la gravité

var velocite : Vector3
var acceleration : Vector3

@onready var mesh = $Mesh
@onready var machine_etats = $Etats
@onready var deplacements = $Deplacements
@onready var saut = $Saut

@export var camera : Camera3D

func get_input():
	var impulse : Vector2
	impulse.x = Input.get_axis("bougerDROITE", "bougerGAUCHE") * 0.1
	impulse.y = Input.get_axis("bougerARRIERE","bougerAVANT") * 0.1
	return impulse
	

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	saut._saut_process(delta)
	deplacements._deplacement_process()
	_appliquer_gravite()
	
	
	#print("velocite :" + str(velocite))
	#print("position :" + str(position))
	velocite += acceleration
	velocity = velocite
	move_and_slide()
	acceleration = Vector3(0.0,0.0,0.0)
