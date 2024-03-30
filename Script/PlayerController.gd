extends CharacterBody2D

var acceleration : Vector2 = Vector2.ZERO
var frictionMag: float = 60
var friction: Vector2 = Vector2.ZERO
var force : Vector2 = Vector2.ZERO
var gravity : Vector2 = Vector2(0,0)
var maxSpeed : Vector2 = Vector2(-80,-80)
var minSpeed : Vector2 = Vector2(80,80)
var AngularAcceleration : float = 50
var AngularVelocity: float = 0
var minVAcceleration: float = -10
var maxHAcceleration : float = 10
var mass : float = 0.4
var time : float = 0
var engine_power = -60  # Forward acceleration force.


func _physics_process(delta):
	var turn = Input.get_axis("rotate_left", "rotate_right")
	AngularVelocity += deg_to_rad(AngularAcceleration* delta)
	var dir = (position - $Node2D.global_position).normalized()
	clampf(AngularVelocity,minVAcceleration,maxHAcceleration)
	rotation +=   turn * AngularVelocity * delta
	get_input()
	applyDrag()
	applyForces(gravity)
	if Input.is_action_pressed("fly"):
		force = Vector2(engine_power,engine_power) *dir
	if Input.is_action_just_released("fly"):
		force = Vector2(0,0)
	applyForces(force)
	velocity += acceleration * delta
	limitVelocity(maxSpeed,minSpeed)

	acceleration = Vector2.ZERO
	position += velocity * delta
	move_and_slide()

func limitVelocity(v1: Vector2,v2: Vector2):
	velocity = velocity.clamp(v1,v2)

func applyFriction():
	friction = ((velocity * -1).normalized()) * frictionMag
	applyForces(friction)

func applyDrag():
	var speed = velocity.length()
	frictionMag  = frictionMag * speed * speed
	var dragVector = (velocity*-1).normalized()
	dragVector *= frictionMag
	
func applyForces(force: Vector2):
	var f = Vector2(force/mass)
	acceleration += f 
func get_input():
	
	var turn = Input.get_axis("rotate_left", "rotate_right")
