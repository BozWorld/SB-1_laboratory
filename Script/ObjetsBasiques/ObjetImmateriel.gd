extends Area3D
class_name ObjetImmateriel

var velocite := Vector3.ZERO
var acceleration := Vector3.ZERO

@export var masse := 1.0 :
	set(value):
		masse = value
		inv_masse = 1.0/masse

var inv_masse := 1.0

var normal = 1.0
@export var coef_friction = 0.1 

func appliquerForce(force : Vector3):
	acceleration += force * inv_masse

func logiqueMouvement(delta : float) :
	velocite += acceleration
	acceleration = Vector3.ZERO
	position += velocite * delta

func appliquerFriction():
	var friction = -velocite * coef_friction * normal
	appliquerForce(friction)
