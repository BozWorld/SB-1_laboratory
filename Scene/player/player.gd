extends CharacterBody3D


@export var speed: float = 0
@export var max_speed: float = 0
@export var h_acceleration: float = 0
@export var v_acceleration: float = 0
@export var rot_speed: float = 2
@export var max_rot: float = 0 

func _physics_process(delta: float) -> void:
	var input = Input.get_axis("right","left")
	var input2 = Input.get_vector("up","down","left","right")
	var forward_dir = transform.basis.z 
	var right_dir = transform.basis.x
	if input != 0:
		rotation.y += deg_to_rad(input * rot_speed)
	if Input.is_action_pressed("push"):
		velocity = speed * forward_dir * delta
	else:
		velocity = lerp(velocity,Vector3.ZERO,0.7)
	if Input.is_action_pressed("up"):
		velocity.y = speed/15 * delta
	if Input.is_action_pressed("down"):
			velocity.y = -speed/20 * delta
	move_and_slide()
