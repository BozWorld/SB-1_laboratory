extends Attribut3D

# seconde entre chaque pas
var delai_pas : float = 0.3
# Puissance des impulsions
var puissance_pas : float = 20.0

var mouvement : Vector2


var clicked := false

@onready var frottement_statique

var sous_cd := false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("bougerAVANT"):
		clicked = true
	if Input.is_action_just_released("bougerAVANT"):
		clicked = false

func deplacement_process():
	if !sous_cd :
		if clicked :
			# A preciser
			pas()
		elif parent.machine_etats.get_state() == parent.machine_etats.states.cours :
			# A preciser
			pas()
		


func pas():
	sous_cd = true
	var timer = TimerUnique.new()
	add_child(timer)
	timer.wait_time = delai_pas
	timer.timeout.connect("retour_pas")
	timer.start()
	
	var orientation_corps = parent.rotation.y
	
	var impulse : Vector3
	
	impulse = -impulse.rotated(Vector3.UP, orientation_corps)
	
	mouvement.x = impulse.x
	mouvement.y = impulse.z
	
	mouvement *= puissance_pas
	
	frottement_statique.appliquer_frottement(parent)

func retour_pas():
	sous_cd = false
