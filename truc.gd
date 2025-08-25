extends Node2D
class_name Truc

@export var debug_forces := false

@export var masse := 20.0 :
	set(value) :
		masse = value
		inv_masse = 1.0/value
		

@onready var inv_masse : float = 1.0/masse



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
	if debug_forces :
		print("================
DEPLACEMENT TOTAL : " + str(velocite))

func _processTruc(delta : float):
	pass

func _process(delta: float) -> void:
	if debug_forces :
		print("XXXXXXXXXXXXXXXXX
DEBUG de " + name)
	_processTruc(delta)
