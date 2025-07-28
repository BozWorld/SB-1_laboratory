extends Node2D
class_name Truc

@export var debug_forces := false

@export var masse := 5.0 :
	set(value) :
		masse = value
		inv_masse = 1.0/value
		

var inv_masse : float


var velocite := Vector2.ZERO
var acceleration := Vector2.ZERO

func appliquerForce(force : Vector2, nom := "Force Inconnue"):
	acceleration += force * inv_masse
	if debug_forces :
		print("=============
	" + nom + str(force) )

func bouger(delta : float):
	velocite += acceleration
	acceleration = Vector2.ZERO
	position += velocite

func _processTruc(delta : float):
	pass

func _process(delta: float) -> void:
	_processTruc(delta)
