extends CharacterBody3D


@export var speed: float = 0
@export var max_speed: float = 0
@export var h_acceleration: float = 0
@export var rot_speed: float = 2
@export var max_rot: float = 0 

func _physics_process(delta: float) -> void:
	var input = Input.get_axis("right","left")
	var input2 = Input.get_vector("up","down","left","right")
	var forward_dir = transform.basis.z 
	if input != 0:
		rotation.y += deg_to_rad(input * rot_speed)
	if Input.is_action_pressed("push"):
		velocity = speed * forward_dir * delta
	else:
		velocity = lerp(velocity,Vector3.ZERO,0.7)
	move_and_slide()
