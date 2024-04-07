extends Node2D

@export var facteur_velocite : float = 0.5

var velocite
var arret : bool = false

var tourner : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseMotion:
		velocite = event.relative * facteur_velocite
		
		if Input.mouse_mode == 2 && tourner == false:
			position += velocite 
		if tourner :
			if event.position.x > 0 :
				rotation += (velocite.x - velocite.y) * 0.005
			
			if event.position.x < 0 :
				rotation += (velocite.x + velocite.y) * 0.005
	
	
	if Input.is_action_just_pressed("fixer"):
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	if Input.is_action_just_released("fixer"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.is_action_just_pressed("tourner_objectif"):
		tourner = true
	
	if Input.is_action_just_released("tourner_objectif"):
		tourner = false
