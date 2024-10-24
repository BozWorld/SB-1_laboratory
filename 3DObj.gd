extends MeshInstance3D

@export var velocity : Vector3
@export var acceleration: Vector3
@export var force : Vector3
@export var gravity : Vector3
@export var coll : CollisionShape3D
var accTo: float = 0.8
var dir: Vector3
@export var mass: float
@export var c: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var friction = (-velocity).normalized() *c
	applyForces(friction)
	applyForces(force)
	applyForces(gravity)
	setVelocity(delta)
	acceleration = Vector3.ZERO
	checkEdgesBounce()
	pass

func getDirection():
	dir = get_viewport().get_global_mouse_position() - Vector2(position.x,position.y)
	dir = dir.normalized()

func setVelocity(delta):
	velocity += acceleration * delta
	limitVelocity(Vector3(-300,-300,-300),Vector3(300,300,300))
	position += velocity * delta

# permet de récupéré la force relative a l'objet
func applyForces(force: Vector3):
	var f = Vector3(force/mass)
	acceleration += f 
	
func limitVelocity(v1: Vector3,v2: Vector3):
	velocity = velocity.clamp(v1,v2)

func add(v1:Vector3,v2:Vector3):
	var v3 = Vector3(v1.x + v2.x, v1.y + v2.y,v1.z + v2.z)
	return v3



func checkEdgesBounce():
	if((position.y > coll.get_shape.size.y/2 - self.height/2 )):
		velocity.y *= -1
		position.y = coll.get_shape.size.x/2 - self.height/2
	if((position.x > coll.get_shape.size.x/2 - self.height/2 )):
		position.x = coll.get_shape.size.x/2 - self.height/2
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
