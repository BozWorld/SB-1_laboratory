extends Node

@export var bruit : FastNoiseLite
@export var mod_temps := 1.0
@export var puissance_vent := 1.0

var temps := 0.0

var force := Vector3.ZERO

func _ready() -> void:
	bruit.seed = randi()

func _physics_process(delta: float) -> void:
	force.x = bruit.get_noise_1d(temps)
	force.y = bruit.get_noise_2d(0.0, temps)
	force.z = bruit.get_noise_3d(0.0,0.0, temps)
	force *= puissance_vent * delta
	
	temps += mod_temps * delta
