extends Node2D

@export var random_tick_generator : Timer
@export var max_vers : int

var decompte_ver = 0

var scene_ver = preload("res://Scene/dune_room/ver.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random_tick_generator.random_tick.connect(_on_random_tick)
	_spawn_ver()

func _spawn_ver():
	var nouveau_ver = scene_ver.instantiate()
	add_child(nouveau_ver)
	decompte_ver += 1

func _on_random_tick(value):
	if decompte_ver <= max_vers :
		if value > 0.7 :
			_spawn_ver()
