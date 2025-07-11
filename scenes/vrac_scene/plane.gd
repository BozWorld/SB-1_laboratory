## Airplane Controller
## 
## A 3D airplane physics controller that handles flight mechanics including throttle control,
## turning, pitching, and ground/air state management.
##
## This script extends CharacterBody3D and provides realistic airplane movement with:
## - Variable speed control with min/max flight speeds
## - Turn and pitch controls with speed-dependent limitations
## - Ground state detection and handling
## - Visual banking effect when turning
## - Real-time flight data display
##
## @export variables:
## - min_flight_speed: Minimum speed required to maintain flight (default: 12.0)
## - max_flight_speed: Maximum achievable speed (default: 40.0)
## - turn_speed: Rate of yaw rotation (default: 0.75)
## - pitch_speed: Rate of pitch rotation (default: 3.0)
## - level_speed: Speed of banking animation when turning (default: 3.0)
## - throttle_delta: Rate of speed change per second (default: 50)
## - acceleration: Smoothing factor for speed transitions (default: 6.0)
## - forward_speed: Current actual speed of the airplane
## - target_speed: Desired speed based on throttle input
## - data: RichTextLabel for displaying flight information
## - mesh: MeshInstance3D for visual banking effects
##
## Input actions required:
## - "throttle_up": Increase speed
## - "throttle_down": Decrease speed  
## - "roll_left"/"roll_right": Turn airplane
## - "pitch_up"/"pitch_down": Control pitch/elevation
extends CharacterBody3D

@export var min_flight_speed: float = 12.0
@export var max_flight_speed: float = 40.0
@export var turn_speed: float = 0.75
@export var pitch_speed: float = 3.0
@export var level_speed: float = 3.0
@export var throttle_delta: float = 50
@export var acceleration = 6.0

@export var forward_speed: float = 0.0
@export var target_speed: float = 0
var grounded: bool = false 
var turn_input: float = 0.0
var pitch_input: float = 0.0

@export var data: RichTextLabel
@export var mesh: MeshInstance3D


func get_input(delta):
	# Throttle input
	if Input.is_action_pressed("throttle_up"):
		target_speed = min(forward_speed + throttle_delta * delta, max_flight_speed)
	if Input.is_action_pressed("throttle_down"):
		var limit = 0 if grounded else min_flight_speed
		target_speed = max(forward_speed - throttle_delta * delta, limit)

	# Turn (roll/yaw) input
	turn_input = Input.get_axis("roll_right", "roll_left")
	if forward_speed <= 0.5:
		turn_input = 0.0  # Prevent turning when not moving forward

	pitch_input = 0.0  # Reset pitch input each frame
	if not grounded:
		pitch_input -= Input.get_action_strength("pitch_down")
	if forward_speed >= min_flight_speed:
		pitch_input += Input.get_action_strength("pitch_up")
	# Pitch (climb/dive) input
	pitch_input =  Input.get_axis("pitch_down", "pitch_up")
	
	
func _physics_process(delta):
	get_input(delta)
	transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)
	transform.basis = transform.basis.rotated(Vector3.UP, turn_input * turn_speed * delta)
	
	# Bank when turning
	if grounded:
		mesh.rotation.z = 0
	else:
		mesh.rotation.z = lerpf(mesh.rotation.z, -turn_input, level_speed * delta)
	
	# Accelerate/decelerate
	forward_speed = lerpf(forward_speed, target_speed, acceleration * delta)
	
	# Movement is always forward
	velocity = -transform.basis.z * forward_speed
	
	# Landing
	if is_on_floor():
		if not grounded:
			rotation.x = 0
#		velocity.y -= 1
		grounded = true
	else:
		grounded = false
	move_and_slide()
	
