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
	var test = FastNoiseLite.new()

	#test.set_noise_type(FastNoiseLite.TYPE_PERLIN)
	#test.set_offset(Vector3(delta,delta,delta))
	#print(test.offset)
	pass

func setVelocity(delta):
	velocity += acceleration * delta
	position += velocity * delta
	
func applyForce(force: Vector3):
	acceleration += force
