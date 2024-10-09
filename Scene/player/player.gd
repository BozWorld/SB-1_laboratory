extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:

	if Input.is_action_pressed("push"):
		print("samuel")
		set_velocity(Vector3(0,0,0.5))
	else : 
		set_velocity(Vector3(0,0,0))


	move_and_slide()
