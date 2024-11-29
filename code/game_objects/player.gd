extends CharacterBody3D


var speed: float = 0
@export var acceleration: float = 0
@export var max_acc: float = 1000
@export var rot_speed: float = 0.5
@export var max_rot: float = 0 
@export var acc_temp: float = 0

func _physics_process(delta: float) -> void:
	speed = acceleration
	var input2 = Input.get_vector("up","down","left","right")
	var forward_dir = transform.basis.z 
	var right_dir = transform.basis.x
	_apply_forces()
	if input2.y != 0:
		rotation.y += deg_to_rad(-input2.y * rot_speed)
	
	if Input.is_action_pressed("push"):
		acc_temp = lerp(acc_temp,max_acc,0.005)
		print(acc_temp)
	else:
		acc_temp = lerp(acc_temp,0.0,0.7)
	
	if input2.x != 0:
		velocity.y = speed * input2.x * delta
		print(velocity.y)
	

	acceleration = 0
	move_and_slide()

func _apply_forces() -> void:
	acceleration += acc_temp
	return

func get_input() -> void:
	return
