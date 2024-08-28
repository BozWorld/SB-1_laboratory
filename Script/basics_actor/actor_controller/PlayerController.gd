extends CharacterBody2D

var acceleration : Vector2 = Vector2.ZERO
## Why was it set at 60 ? 
var friction_mag: float = 0.002
var friction: Vector2 = Vector2.ZERO
var force : Vector2 = Vector2.ZERO
var gravity : Vector2 = Vector2(0,200)
var max_speed : Vector2 = Vector2(-400,-400)
var min_speed : Vector2 = Vector2(400,700)
var angular_acc : float = 700
var angular_vel: float = 0
var min_v_acc: float = -7.0
var max_h_acc : float = 7.0
var mass : float = 6.0
var time : float = 0
var engine_power = -100  # Forward acceleration force.
var dir = Vector2.ZERO
var velocity_dir = Vector2.ZERO

signal sharp_turn_screen_shake(turn_angle)
var emit_once:bool = false

func _physics_process(delta):
	var turn = Input.get_axis("rotate_left", "rotate_right")
	angular_vel += deg_to_rad(angular_acc* delta)
	if turn == 0:
		angular_vel = 0
	dir = (position - $Node2D.global_position).normalized()
	#print(dir)
	angular_vel = clampf(angular_vel,min_v_acc,max_h_acc)
	rotation +=   turn * angular_vel * delta
	clampf(rotation,min_v_acc,max_h_acc)
	applyDrag()
	#applyFriction()
	applyForcesMass(gravity,1.0)

	if Input.is_action_pressed("fly"):
		var angle: float = abs((-1 * velocity).angle_to(dir))
		var effective_engine_power = clamp(-7000 *(angle / PI) ,-7000,-4000) - clamp(3000 - 3000 * (velocity.length() / 450.0),0,2000)
		if angle >= 2.6 and !emit_once:
			print("ALORS")
			emit_once = true
			sharp_turn_screen_shake.emit(-1 * effective_engine_power)

		if angle < 2.6:
			emit_once = false
		force = Vector2(effective_engine_power,effective_engine_power) *dir
	if !Input.is_action_pressed("fly"):
		force = Vector2(-2000,0) * dir
		#print(dir)
	applyForcesMass(force,mass)
	velocity += acceleration * delta
	checkEdgesBounce()
	limitVelocity(max_speed,min_speed)
	
	acceleration = Vector2.ZERO
	position += velocity * delta
	move_and_slide()
	velocity_dir = (velocity).normalized()


func limitVelocity(v1: Vector2,v2: Vector2):
	velocity = velocity.clamp(v1,v2)

func applyFriction():
	friction = ((velocity * -1).normalized()) * friction_mag
	applyForces(friction)

func applyDrag():
	var speed = velocity.length()
	var frictionDrag = friction_mag * speed * speed
	var dragVector = (velocity*-1).normalized()
	dragVector *= frictionDrag

	applyForcesMass(dragVector,1.0)
	
func applyForces(force: Vector2):
	var f = Vector2(force/mass)
	acceleration += f

func applyForcesMass(force: Vector2, ownmass: float):
	var f = Vector2(force/ownmass)
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
