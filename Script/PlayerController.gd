extends CharacterBody2D

var acceleration : Vector2 = Vector2.ZERO
var friction_coef: float = 1
var normal: float = -1
var frictionMag: float = 0
var friction: Vector2 = Vector2.ZERO
var force : Vector2 = Vector2.ZERO
var gravity : Vector2 = Vector2(0,10)
var limit: Vector2 = Vector2.ZERO
var maxSpeed : Vector2 = Vector2(0,-180)
var minSpeed : Vector2 = Vector2(0,100)
var mass : float = 1.5

var wheel_base = 70  # Distance from front to rear wheel
var steering_angle = 15  # Amount that front wheel turns, in degrees

var steer_direction
var engine_power = -9700  # Forward acceleration force.

func _ready() -> void:
	
	frictionMag = friction_coef * up_direction.y

func _physics_process(delta):
	friction = ((velocity * -1).normalized()) * frictionMag
#	force = f/mass
#	gravity = g/mass
#	limit = l/mass
	acceleration += force + gravity + limit + friction
	velocity += acceleration * delta
	limit = Vector2(0,0)
	if velocity <= maxSpeed:
		velocity = maxSpeed
	if velocity >= minSpeed:
		velocity = minSpeed
	friction = ((velocity * -1).normalized()) * frictionMag
	get_input()
	move_and_slide()

func get_input():
	var turn = Input.get_axis("rotate_left", "rotate_right")
	steer_direction = turn * deg_to_rad(steering_angle)
#	if Input.is_action_pressed("fly"):
#		f = Vector2(0,-80)
#	if Input.is_action_just_released("fly"):
#		f = Vector2(0,0)


'func calculate_steering(delta):

	var rear_wheel = position - transform.y * wheel_base / 2.0
	var front_wheel = position + transform.y * wheel_base / 2.0

	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta

	var new_heading = rear_wheel.direction_to(front_wheel)

	velocity = new_heading * velocity.length()
	rotation = new_heading.angle()'
