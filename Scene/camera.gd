extends Camera2D

@export var sensibilite : float = 10.0

var velocite : Vector2

var bloquee = false

@onready var viseur = $Area2D

var pointe_constelleur

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GestionnaireDeConstellations.camera = self

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		velocite += event.relative * sensibilite
	
	if Input.is_action_just_pressed("lock"):
		if viseur.retour_viseur() :
			viseur.retour_viseur().faire_sonner()
			GestionnaireDeConstellations.debut_ajout_constellation(viseur.retour_viseur())
			bloquee = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
			pointe_constelleur = PointeConstelleur.new()
			add_child(pointe_constelleur)
	
	if Input.is_action_just_released("lock"):
		GestionnaireDeConstellations.fin_ajout_constellation()
		bloquee = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		velocite *= 0
		if pointe_constelleur :
			pointe_constelleur.queue_free()
			pointe_constelleur = null
	
	if Input.is_action_just_pressed("sonner"):
		if viseur.retour_viseur() :
			viseur.retour_viseur().clic_sonner()

func _physics_process(delta: float) -> void:
	if !bloquee :
		position += velocite * delta
		velocite *= 0.8

func _deplacement_constelleur(nouvelle_origine : Vector2):
	pointe_constelleur.global_position = nouvelle_origine
