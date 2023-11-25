extends CharacterBody2D

var wheel_base = 10
var steering_angle = 10
var steer_direction

var enginer_power = 900

var acceleration = Vector2.ZERO

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	calculate_steering(delta)
	velocity += acceleration * delta 
	move_and_slide()

func get_input():
	var turn = Input.get_axis("rotate_left","rotate_right")
	steer_direction = turn * deg_to_rad(steering_angle)
	velocity = Vector2.ZERO
	if Input.is_action_pressed("fly"):
		acceleration = transform.y * enginer_power
		
#func calculate_steering(delta):
#	var rear_wheel = position + transform.y * wheel_base /2.0
#	var front_wheel = position - transform.y * wheel_base / 2.0
#	rear_wheel += velocity * delta
#	front_wheel += velocity.rotated(steer_direction) * delta
#	var new_heading = rear_wheel.direction_to(front_wheel)
#	velocity = new_heading * velocity.length()
#	rotation = new_heading.angle()
	
func calculate_steering(delta):
	# 1. Find the wheel positions
	var rear_wheel = position - transform.y * wheel_base / 2.0
	var front_wheel = position + transform.y * wheel_base / 2.0
	# 2. Move the wheels forward
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	# 3. Find the new direction vector
	var new_heading = rear_wheel.direction_to(front_wheel)
	# 4. Set the velocity and rotation to the new direction
	velocity = new_heading * velocity.length()
	rotation = new_heading.angle()
