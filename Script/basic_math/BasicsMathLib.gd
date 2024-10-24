@tool
extends Node2D

@export var velocity : Vector2
@export var acceleration: Vector2
@export var force : Vector2
@export var gravity : Vector2
var accTo: float = 0.8
var dir: Vector2
@export var mass: float
@export var c: float

# Called when the node enters the scene tree for the first time.

#func _ready() -> void:
#	position = Vector2((get_viewport().get_visible_rect().size.x)/2,(get_viewport().get_visible_rect().size.y)/2)
	

func _physics_process(delta: float) -> void:
		var friction = (-velocity).normalized() *c
		applyForces(friction)
		applyForces(force)
		applyForces(gravity)
		setVelocity(delta)
		acceleration = Vector2.ZERO
		checkEdgesBounce()
		
func getDirection():
	dir = get_global_mouse_position() - position
	dir = dir.normalized()

func setVelocity(delta):
	velocity += acceleration * delta
	limitVelocity(Vector2(-300,-300),Vector2(300,300))
	position += velocity * delta

# permet de récupéré la force relative a l'objet
func applyForces(force: Vector2):
	var f = Vector2(force/mass)
	acceleration += f 
	
func limitVelocity(v1: Vector2,v2: Vector2):
	velocity = velocity.clamp(v1,v2)

func add(v1:Vector2,v2:Vector2):
	var v3 = Vector2(v1.x + v2.x, v1.y + v2.y)
	return v3



func checkEdgesBounce():
	if((position.y > get_viewport().get_visible_rect().size.y )):
		applyForces(Vector2(0,(get_viewport().get_visible_rect().size.y-position.y)))
		velocity.y *= -1
		position.y = get_viewport().get_visible_rect().size.y
	if((position.x > get_viewport().get_visible_rect().size.x )):
		position.x = get_viewport().get_visible_rect().size.x
		velocity.x*= -1
func _on_vel_timer_timeout():
	print ( velocity )

func checkEdges():
	if ((position.x > (get_viewport().get_visible_rect().size.x)/2)):
		position.x = 0
		velocity.x *= -1
	elif position.x < 0:
		position.x = get_viewport().get_visible_rect().size.x
	if position.y > get_viewport().get_visible_rect().size.y:
		position.y = 0
	elif position.y < 0:
		position.y = get_viewport().get_visible_rect().size.y
		
