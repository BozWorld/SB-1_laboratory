extends MeshInstance3D
class_name NoCObjet

var acceleration : Vector3
var velocite : Vector3
@export var masse = 1.0

func appliquerForce(force : Vector3):
	force = force/masse
	acceleration += force

func _bouger():
	velocite += acceleration
	position += velocite
	acceleration = acceleration * 0
