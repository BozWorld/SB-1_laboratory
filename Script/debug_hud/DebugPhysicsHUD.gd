extends Node2D

@export var friction_label : Label
@export var force_label : Label
@export var velocity_label : Label
@export var angular_vel : Label

@export var player : CharacterBody2D

var random_shake: float = 8.0
var shake_decay_rate:float =2.0
var shake_strength: float = 0.0

func _ready():
	$PlayerScene.sharp_turn_screen_shake.connect(screen_shake.bind())

func _physics_process(delta: float) -> void:
	var friction = player.friction
	friction_label.text = "Friction : " + str(round(friction))
	force_label.text = "Force : " +  str(round(player.force))
	velocity_label.text = "Velocity : " + str(round(player.velocity))
	angular_vel.text = "Angular Velocity : " + str(round(player.angular_vel))
	
	$PhantomCamera2D.set_follow_offset( $PlayerScene.velocity_dir * 700.0 * ($PlayerScene.velocity.length() / 500.0))
	if  !Input.is_action_pressed("fly"):
		#$PhantomCamera2D.set_follow_offset(Vector2(0,0))
		$PhantomCamera2D.set_follow_damping_value(Vector2(2.0,0))

	else:
		#$PhantomCamera2D.set_follow_offset(Vector2(-1 * $Player_scene.dir.x, -1 * $Player_scene.dir.y) * 300.0)
		$PhantomCamera2D.set_follow_offset(Vector2(2.0,0))
		#$Pcam2D.set_follow_target_offset( $Player_scene.velocity_dir * 200.0)
		
	shake_strength = lerp(shake_strength,0.0,shake_decay_rate * delta)
	
	$Camera2D.offset = get_random_offset()

func screen_shake(turn_angle: float):
	shake_strength = random_shake * (turn_angle / 7000)

func get_random_offset():
	return Vector2(randf_range(-shake_strength,shake_strength),randf_range(-shake_strength,shake_strength))
