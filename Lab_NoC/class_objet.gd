extends MeshInstance3D
class_name NoCObjet

var acceleration : Vector3
var velocite : Vector3
var masse = 1.0

func appliquer_force(force : Vector3):
	force = force/masse
	acceleration += force

func bouger():
	velocite += acceleration
	position += velocite
	acceleration = acceleration * 0
