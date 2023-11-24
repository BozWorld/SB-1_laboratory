extends CharacterBody2D

var wheel_base = 12
var steering_angle = 3

var steer_direction

func _physics_process(delta):
	get_input()
	calculate_steering(delta)
	move_and_slide()

func get_input():
	var turn = Input.get_axis("rotate_left","rotate_right")
	steer_direction = turn * deg_to_rad(steering_angle)
	velocity = Vector2.ZERO
	if Input.is_action_pressed("fly"):
		velocity = transform.y * 300
func calculate_steering(delta):
	var rear_wheel = position - transform.y * wheel_base /2.0
	var front_wheel = position + transform.y * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = rear_wheel.direction_to(front_wheel)
	velocity = new_heading * velocity.length()
	rotation = new_heading.angle()
