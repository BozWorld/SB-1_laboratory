extends Node2D

@export var facteur_velocite : float = 0.5

var velocite
var arret : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseMotion && arret == false :
		velocite = Input.get_last_mouse_velocity()
		position += velocite * facteur_velocite
	
	if Input.is_action_just_pressed("Fixer"):
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		arret = true
	
	if Input.is_action_just_released("Fixer"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		arret = false
