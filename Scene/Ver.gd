extends Node3D


@export var perlin_h : FastNoiseLite

@export var perlin_v : FastNoiseLite

@export var temps_seconde := 4.0
var temps := 0.0

@export var echelle := 1.0

func _physics_process(delta: float) -> void:
	
	position.x = perlin_h.get_noise_2d(temps, 0.0) * echelle
	position.y = perlin_v.get_noise_1d(temps) * echelle
	position.z = perlin_h.get_noise_2d(0.0, temps) * echelle
	
	temps += delta * temps_seconde
