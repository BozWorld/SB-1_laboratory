extends Node2D

@onready var random_ticker = $TimerRandomTick
var scene_toucan = preload("res://Toucans/random_toucan_adaptatif.tscn")
var last_random_tick

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random_ticker.timeout.connect(reception_random_tick)

func reception_random_tick():
	last_random_tick = randi_range(0,100)
	if last_random_tick < 33 :
		gen_toucan()

func gen_toucan():
	var instance_toucan = scene_toucan.instantiate()
	
	add_child(instance_toucan)
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		gen_toucan()
