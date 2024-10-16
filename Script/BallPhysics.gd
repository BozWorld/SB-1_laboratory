extends Node3D

var velocity : Vector3
var acceleration : Vector3
var force : Vector3
@export var gravity : Vector3
@export var wall : Vector3
@export var hittingPoint : Vector3
@export var hittingForce : Vector3
@export var helium : Vector3
var mass : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("ma position" + str(position))
	if position.y >= hittingPoint.y : 
		applyForce(hittingForce)
	else :
		applyForce(gravity)
		applyForce(helium)
	print("ma force" + str(acceleration))
	setVelocity(delta)
	acceleration = Vector3.ZERO
	pass

func setVelocity(delta):
	velocity += acceleration * delta
	position += velocity * delta
	
func applyForce(f: Vector3):
	acceleration += f
