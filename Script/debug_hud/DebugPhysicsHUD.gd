extends Node2D

@export var masslabel : Label
@export var frictionlabel : Label
@export var pushforcelabel : Label
@export var velocitylabel : Label
@export var gravitylabel : Label
@export var normallabel : Label

@export var player : CharacterBody2D

@export var mass : float
@export var frictionCoef : float
@export var pushforce : Vector2
@export var velocity : Vector2
@export var gravity : Vector2
@export var acceleration : Vector2
var random_shake: float = 8.0
var shake_decay_rate:float =2.0
var shake_strength: float = 0.0

func _ready():
	$Player_scene.sharp_turn_screen_shake.connect(_screen_shake.bind())

func _physics_process(delta: float) -> void:
	
	mass = player.mass
	velocity = player.velocity
	acceleration = player.acceleration
	
	masslabel.text = "Mass : " + str(mass)
	frictionlabel.text = "friction : " + str(frictionCoef)
	pushforcelabel.text = "push_Force : " +  str(pushforce)
	velocitylabel.text = "Velocity :  " +  str(velocity)
	gravitylabel.text = "gravity : " +  str(gravity)
	normallabel.text = "acceleration : " +  str(acceleration)
	print($Player_scene.velocity_dir, " ",$Player_scene.velocity)
	$PcamTween.set_follow_target_offset( $Player_scene.velocity_dir * 700.0 * ($Player_scene.velocity.length() / 500.0))
	if  !Input.is_action_pressed("fly"):
		#$PcamTween.set_follow_target_offset(Vector2(0,0))
		$PcamTween.set_follow_damping_value(2.0)

	else:
		#$PcamTween.set_follow_target_offset(Vector2(-1 * $Player_scene.dir.x, -1 * $Player_scene.dir.y) * 300.0)
		$PcamTween.set_follow_damping_value(2.0)
		#$PcamTween.set_follow_target_offset( $Player_scene.velocity_dir * 200.0)
		
	shake_strength = lerp(shake_strength,0.0,shake_decay_rate * delta)
	
	$Camera2D.offset = get_random_offset()

func _screen_shake(turn_angle: float):
	shake_strength = random_shake * (turn_angle / 7000)

func get_random_offset():
	return Vector2(randf_range(-shake_strength,shake_strength),randf_range(-shake_strength,shake_strength))
