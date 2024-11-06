extends Node3D


@export var lock : Node3D
@export var player : Node3D
var camera : Camera3D
var locked_on : bool = false
var camera_angle_x : float
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("lock_on"):
		print("coubeh")
		camera = player.get_node("Player/SpringArm3D/Camera3D")
		locked_on = !locked_on
		if locked_on:
			camera_angle_x = -39.1
			print("feur")
		else : 
			camera.rotation.x = deg_to_rad(camera_angle_x)
			camera.rotation.y = 0.0
			print("haha")


func _ready() -> void:
	player.get_node("Player").new_locked_target(lock)
func _process(delta: float) -> void:
	if locked_on:
		camera.look_at(lock.position)
