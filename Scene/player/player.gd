extends CharacterBody3D


@export var speed: float = 0
@export var max_speed: float = 0
@export var h_acceleration: float = 0
@export var rot_speed: float = 1
@export var max_rot: float = 0 

const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	var input = Input.get_axis("right","left")
	var forward_dir = transform.basis.z 
	if input != 0:
		rotation.y += deg_to_rad(input * rot_speed)
	#if Input.is_action_pressed("left"):
		#rotation.y += deg_to_rad(3)
	#if Input.is_action_pressed("right"):
		#rotation.y += deg_to_rad(-3)
	if Input.is_action_pressed("push"):
		velocity = speed * forward_dir * delta
	else:
		velocity = lerp(velocity,Vector3.ZERO,0.7)
		print(velocity)


	move_and_slide()
