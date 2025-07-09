extends Node3D
class_name ObjetPhysique

var velocite := Vector3.ZERO
var acceleration := Vector3.ZERO

@export var masse := 1.0

var normal = 1.0
var coef_friction = 0.1 

func appliquerForce(force : Vector3):
	acceleration += force / masse

func logiqueMouvement(delta : float) :
	velocite += acceleration
	acceleration = Vector3.ZERO
	position += velocite * delta

func appliquerFriction():
	var friction = -velocite * coef_friction * normal
	appliquerForce(friction)
