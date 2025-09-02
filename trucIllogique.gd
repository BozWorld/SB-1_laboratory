extends Node2D
class_name TrucIllogique

@export var debug_forces := false

@export var masse := 20.0 :
	set(value) :
		masse = value
		inv_masse = 1.0/value
		

@onready var inv_masse : float = 1.0/masse

@onready var gravite = %Gravite
var force_g := 0.9

var velocite := Vector2.ZERO
var acceleration := Vector2.ZERO

func _ready():
	if gravite :
		force_g = gravite.constante_g

func appliquerGravite():
	var direction = Vector2.DOWN
	appliquerForce(direction * masse * force_g, "Gravité")

func appliquerForce(force : Vector2, nom := "Force Inconnue"):
	acceleration += force * inv_masse
	if debug_forces :
		print("=============
	" + nom + str(force) )

func bouger():
	velocite += acceleration
	acceleration = Vector2.ZERO
	position += velocite
	if debug_forces :
		print("================
DEPLACEMENT TOTAL : " + str(velocite))
