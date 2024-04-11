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
	if player.velocity.length() >= 400.0:
		$PcamTween.set_follow_target_offset(Vector2(0,0))
		$PcamTween.set_follow_damping_value(6.0)

	else:
		$PcamTween.set_follow_target_offset(Vector2(-1 * $Player_scene.dir.x, -1 * $Player_scene.dir.y) * 300.0)
		$PcamTween.set_follow_damping_value(1.0)

