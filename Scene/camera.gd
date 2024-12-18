extends Camera2D

@export var sensibilite : float = 10.0

var velocite : Vector2

var gclic_tenu = false
var decompte_gclic : int = 0
var frame_threshold_effacer : int = 20

var bloquee = false

var tourne = false

var area_effacer : AreaEffacer 

@onready var viseur = $ViseurCreation

var pointe_constelleur

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GestionnaireDeConstellations.camera = self

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		velocite += event.relative * sensibilite
	
	if Input.is_action_just_pressed("composer"):
		if viseur.retour_viseur() :
			viseur.retour_viseur().faire_sonner()
			GestionnaireDeConstellations.debut_ajout_constellation(viseur.retour_viseur())
			bloquee = true
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			
			if pointe_constelleur :
				pointe_constelleur.queue_free()
				pointe_constelleur = null
			
			pointe_constelleur = PointeConstelleur.new()
			add_child(pointe_constelleur)
	
	if Input.is_action_just_released("composer"):
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
		gclic_tenu = true
	
	if Input.is_action_just_released("sonner"):
		
		if decompte_gclic > frame_threshold_effacer:
			area_effacer.fin()
			area_effacer = null
		
		gclic_tenu = false
		decompte_gclic = 0
	
	if Input.is_action_just_pressed("tourner"):
		tourne = true
	
	if Input.is_action_just_released("tourner"):
		tourne = false

func _physics_process(delta: float) -> void:
	if tourne :
		rotate(velocite.x * delta)
		
	elif !bloquee :
		if (position + velocite).length() > 4000 :
			velocite = velocite * 20*(1/(position.length()-3000))
		position += velocite * delta
		velocite *= 0.8
	
	if gclic_tenu and not area_effacer :
		decompte_gclic += 1
		if decompte_gclic > frame_threshold_effacer:
			
			area_effacer = AreaEffacer.new()
			add_child(area_effacer)
			
			gclic_tenu = false
			
		

func _deplacement_constelleur(nouvelle_origine : Vector2):
	pointe_constelleur.global_position = nouvelle_origine
