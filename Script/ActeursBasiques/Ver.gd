extends Node3D


@export var perlin_h : FastNoiseLite

@export var perlin_v : FastNoiseLite

@export var perlin_m : FastNoiseLite

@export var temps_seconde := 4.0
var temps := 0.0

var vitesse := Vector3.ZERO
var acceleration := Vector3.ZERO

@export var puissance_dep := 1.0
@export var frequence_dep := 0.1
var index_dep := 0.0

func appliquerForce(force := Vector3.ZERO):
	acceleration += force

func tirageDeplacement(delta):
	var orientation : Vector3
	
	orientation.x = perlin_h.get_noise_2d(temps, 0.0)
	orientation.y = perlin_v.get_noise_1d(temps)
	orientation.z = perlin_h.get_noise_2d(0.0, temps)
	
	var magnitude = perlin_m.get_noise_1d(temps)
	
	appliquerForce(orientation * magnitude * puissance_dep)
	
	temps += delta * temps_seconde


func _physics_process(delta: float) -> void:
	index_dep += delta
	if index_dep >= frequence_dep :
		index_dep -= frequence_dep
		tirageDeplacement(delta)
	
	appliquerForce(-vitesse*0.1)
	
	vitesse += acceleration
	acceleration *= 0.0
	position += vitesse * delta
	
	
	
	
