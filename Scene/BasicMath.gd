extends Node2D

@export var velocity : Vector2
@export var acceleration: Vector2
var accTo: float = 0.6
@export var topspeed: Vector2
@export var trine: Line2D
@export var trine2: Line2D
var dir: Vector2
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	position = Vector2((get_viewport().get_visible_rect().size.x)/2,(get_viewport().get_visible_rect().size.y)/2)
	

func _physics_process(delta: float) -> void:
		limitVelocity(Vector2(-5,-5),Vector2(5,5))
		getDirection()
		setVelocity()
		checkEdges()
#		trine.set_point_position(1,dir.normalized()*50)
#		trine2.set_point_position(1,trine2.position+Vector2(dir.length(),trine.position.y))
#		if ((position.x > get_viewport().get_visible_rect().size.x)||(position.x<0)):
#			velocity.x = velocity.x* -1
#		if ((position.y > get_viewport().get_visible_rect().size.y)||(position.y<0)):
#
#			velocity.y = velocity.y*-1
func getDirection():
	dir = get_global_mouse_position() - position
	dir = dir.normalized()
	
func add(v1:Vector2,v2:Vector2):
	var v3 = Vector2(v1.x + v2.x, v1.y + v2.y)
	return v3

func checkEdges():
	if ((position.x > get_viewport().get_visible_rect().size.x)):
		position.x = 0
	elif position.x < 0:
		position.x = get_viewport().get_visible_rect().size.x
	if position.y > get_viewport().get_visible_rect().size.y:
		position.y = 0
	elif position.y < 0:
		position.y = get_viewport().get_visible_rect().size.y

func setVelocity():
	acceleration = dir * accTo
	velocity += acceleration
	position = position + velocity
	
func limitVelocity(v1: Vector2,v2: Vector2):
	velocity = velocity.clamp(v1,v2)
