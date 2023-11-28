extends Node2D

@export var velocity : Vector2
@export var acceleration: Vector2
@export var force : Vector2
@export var gravity : Vector2
var accTo: float = 0.8
@export var topspeed: Vector2
@export var trine: Line2D
@export var trine2: Line2D
var dir: Vector2
@export var mass: float
# Called when the node enters the scene tree for the first time.

#func _ready() -> void:
#	position = Vector2((get_viewport().get_visible_rect().size.x)/2,(get_viewport().get_visible_rect().size.y)/2)
	

func _physics_process(delta: float) -> void:
		applyForces(force,delta)
		applyForces(gravity,delta)
		setVelocity(delta)
		checkEdgesBounce()
		acceleration = Vector2.ZERO
#		print(str("acceleration :" + str(velocity)))
#		print(str("velocity :" + str(velocity)))

func getDirection():
	dir = get_global_mouse_position() - position
	dir = dir.normalized()

func setVelocity(delta):
	velocity += acceleration * delta
	limitVelocity(Vector2(-10,-10),Vector2(10,10))
	position += velocity

	
func applyForces(force: Vector2, delta):
	var f = Vector2(force/mass)
	acceleration += f * delta
	
func limitVelocity(v1: Vector2,v2: Vector2):
	velocity = velocity.clamp(v1,v2)

func add(v1:Vector2,v2:Vector2):
	var v3 = Vector2(v1.x + v2.x, v1.y + v2.y)
	return v3

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

func checkEdgesBounce():
	if((position.y > get_viewport().get_visible_rect().size.y )):
		velocity.y *= 1
		position.y = get_viewport().get_visible_rect().size.y/2
		
	if((position.y > get_viewport().get_visible_rect().size.y )):
		velocity.y *= 1
		position.y = get_viewport().get_visible_rect().size.y/2
	if ((position.x > get_viewport().get_visible_rect().size.x)):
		velocity.x *= -1
		position.x = get_viewport().get_visible_rect().size.x
	elif position.x < 0:
		velocity.x *= -1
		position.x = position.x - (get_viewport().get_visible_rect().size.x/2)
#func div(v1:Vector2,v2:Vector2):
#	var v3 = Vector2((v1.x/v2.x),v1.y + v2.y)
#		trine.set_point_position(1,dir.normalized()*50)
#		trine2.set_point_position(1,trine2.position+Vector2(dir.length(),trine.position.y))
#		if ((position.x > get_viewport().get_visible_rect().size.x)||(position.x<0)):
#			velocity.x = velocity.x* -1
#		if ((position.y > get_viewport().get_visible_rect().size.y)||(position.y<0)):
#
#			velocity.y = velocity.y*-1
