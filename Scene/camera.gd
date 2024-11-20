extends Camera2D

@export var sensibilite : float = 10.0

var velocite : Vector2

var bloquee = false

@onready var viseur = $Area2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		velocite += event.relative * sensibilite
	
	if Input.is_action_just_pressed("lock"):
		if viseur.retour_selection() :
			bloquee = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_released("lock"):
		bloquee = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		velocite *= 0

func _physics_process(delta: float) -> void:
	if !bloquee :
		position += velocite * delta
		velocite *= 0.8
