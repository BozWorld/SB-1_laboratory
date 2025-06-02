extends Attribut3D

@export var DICO_PUISSANCES_PAS = {"ZERO" : 0.0, 
"RALENTI" : 0.2,
"MARCHE" : 0.6,
"COURSE" : 1.0,
"SPRINT" : 2.0
}

@export var DICO_DELAIS_PAS = {"RALENTI" : 0.2,
"MARCHE" : 0.2,
"COURSE" : 0.2,
"SPRINT" : 0.2}

# seconde entre chaque pas
var delai_pas : float = 0.2
# Puissance des impulsions
var puissance_pas : float = 0.0

var momentum_boost := 0.0

var clicked := false

var sprint := false
var marche := false

var index_delta := 0.0

@onready var frottement_statique = %FrottementStatique

var sous_cd := false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("bougerAVANT"):
		clicked = true
		if parent.momentum.h_momentum_stored and parent.machine_etats.get_state() != parent.machine_etats.states.cours :
			momentum_boost = parent.momentum._liberer_h_momentum()
			print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
			Momentum horizontal libéré !
			Puissance : " + str(momentum_boost))
	elif Input.is_action_just_released("bougerAVANT"):
		clicked = false

func _deplacement_process(delta):
	puissance_pas = DICO_PUISSANCES_PAS["ZERO"]
	if index_delta < delai_pas :
		index_delta += delta
	if Input.is_action_pressed("bougerAVANT") :
		if index_delta >= delai_pas :
			index_delta -= delai_pas
			
			puissance_pas = DICO_PUISSANCES_PAS["COURSE"]
			delai_pas = DICO_DELAIS_PAS["COURSE"]
			if Input.is_action_pressed("sprint") :
				puissance_pas = DICO_PUISSANCES_PAS["SPRINT"]
				delai_pas = DICO_DELAIS_PAS["SPRINT"]
			elif Input.is_action_pressed("marcher") :
				puissance_pas = DICO_PUISSANCES_PAS["MARCHE"]
				delai_pas = DICO_DELAIS_PAS["MARCHE"]
			elif momentum_boost != 0.0 :
				puissance_pas += momentum_boost
				print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
				Momentum horizontal dépensé !
				Puissance : " + str(momentum_boost))
				momentum_boost = 0.0
			
			pas(orientation_avant(), puissance_pas)
		
	elif parent.velocite.length() > 0.0 :
		if index_delta >= delai_pas :
			index_delta -= delai_pas
			if parent.velocite.length() > 0.6 :
				puissance_pas = DICO_PUISSANCES_PAS["RALENTI"]
				delai_pas = DICO_DELAIS_PAS["RALENTI"]
				pas(orientation_avant(), puissance_pas)
			else :
				parent.velocite = Vector3(0,0,0)
				pas(Vector3.ZERO, 0.0)
		
	_debugging()

func orientation_avant():
	var orientation_corps = parent.rotation.y
	
	var impulse = Vector3(0.0,0.0,1.0)
	
	impulse = -impulse.rotated(Vector3.UP, orientation_corps)
	return impulse


func pas(orientation : Vector3, magnitude : float):
	
	var dico_saut = %PreparationSaut._saut_process()
	
	if dico_saut :
		delai_pas *= dico_saut["delais"]
		puissance_pas *= dico_saut["puissance"]
		if dico_saut["v_force"] :
			parent.appliquer_force_verticale(dico_saut["v_force"])
	
	var frein_recul = %FreinRecul.logiquePas()
	
	if frein_recul == "freine" :
		orientation = -orientation
		magnitude = parent.velocite.length() * 0.6
		delai_pas *= 0.8
	
	sous_cd = true
	var timer = TimerUnique.new()
	add_child(timer)
	timer.wait_time = delai_pas
	timer.timeout.connect(retour_pas)
	timer.start()
	
	frottement_statique._appliquer_frottement()
	
	var mouvement : Vector3 = orientation * magnitude
	
	if mouvement.length() > 0.0 :
		parent.appliquer_force(mouvement)
	
	
	
	

func retour_pas():
	sous_cd = false

func _debugging():
	var debug_vitesse = parent.velocite
	debug_vitesse.y = 0
	%CompteurVitesse._actualisation_compteur(debug_vitesse.length())
