extends MeshInstance3D


var velocity : Vector3
var acceleration : Vector3 = Vector3.ZERO
var AngularAcceleration : float = 0
var push_force : Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	applyForce(push_force)
	setVelocity(delta)
	acceleration = Vector3.ZERO

	pass

func setVelocity(delta):
	velocity += acceleration * delta
	position += velocity * delta

func applyForce(force: Vector3):
	acceleration += Vector3(1,0,0)