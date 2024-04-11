extends CharacterBody2D

var acceleration : Vector2 = Vector2.ZERO
var frictionMag: float = 60
var friction: Vector2 = Vector2.ZERO
var force : Vector2 = Vector2.ZERO
var gravity : Vector2 = Vector2(0,20)
var maxSpeed : Vector2 = Vector2(-400,-300)
var minSpeed : Vector2 = Vector2(400,300)
var AngularAcceleration : float = 800
var AngularVelocity: float = 0
var minVAcceleration: float = -7.0
var maxHAcceleration : float = 7.0
var mass : float = 0.6
var time : float = 0
var engine_power = -200  # Forward acceleration force.
var dir = Vector2.ZERO

func _physics_process(delta):
	var turn = Input.get_axis("rotate_left", "rotate_right")
	AngularVelocity += deg_to_rad(AngularAcceleration* delta)
	if turn == 0:
		AngularVelocity = 0
	dir = (position - $Node2D.global_position).normalized()
	#print(dir)
	AngularVelocity = clampf(AngularVelocity,minVAcceleration,maxHAcceleration)
	rotation +=   turn * AngularVelocity * delta
	clampf(rotation,minVAcceleration,maxHAcceleration)
	get_input()
	applyDrag()
	applyFriction()
	applyForces(gravity)
	if Input.is_action_pressed("fly"):
		force = Vector2(engine_power,engine_power) *dir
	if Input.is_action_just_released("fly"):
		force = Vector2(0,0)
	applyForces(force)
	velocity += acceleration * delta
	checkEdgesBounce()
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
	
## Permet de limiter les mouvements de l'avion 
func checkEdgesBounce():
	var limit = 2000
	if((position.y > limit )):
		velocity.y *= -2
		position.y = limit
	if((position.y < -limit )):
		velocity.y *= -2
		position.y = -limit
	if((position.x > limit )):
		velocity.x *= -2
		position.x = limit
	if((position.x < -limit )):
		velocity.x *= -2
		position.x = -limit

func get_input():
	
	var turn = Input.get_axis("rotate_left", "rotate_right")
