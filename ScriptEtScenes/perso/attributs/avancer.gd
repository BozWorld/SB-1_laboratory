extends Attribut3D

const VITESSE : float = 12.0

var mouvement : Vector2


func get_input():
	var impulse = Vector3(0,0,0)
	if (
		Input.is_action_pressed("bougerAVANT") && 
		parent.machine_etats.get_state() != parent.machine_etats.states.tombe &&
		parent.machine_etats.get_state() != parent.machine_etats.states.saute
		):
		impulse.z = 1.0
	
	else :
		impulse.z = 0.0
	
	
	var orientation_corps = parent.global_rotation.y
		#
	impulse = -impulse.rotated(Vector3.UP, orientation_corps)
	
	return impulse

func _deplacement_process(delta):
	
	mouvement.x = get_input().x
	mouvement.y = get_input().z
	
	mouvement *= delta * VITESSE
	
	if get_input().length() > 0.0 :
		parent.appliquer_force_horizontale(mouvement)
	
	#if Input.is_action_pressed("bougerDROITE") or Input.is_action_pressed("bougerGAUCHE") or Input.is_action_pressed("bougerAVANT") or Input.is_action_pressed("bougerARRIERE") :
		#parent.appliquer_force(Vector3(get_input().x, 0.0, get_input().z))
		
	#else :
		#var arret : Vector2
		#if abs(parent.velocite.x) < 1 :
			#arret.x = 0
			#parent.velocite.x = 0
		#else :
			#arret.x = 1.0/abs(parent.velocite.x)  * -parent.velocite.x * 0.2
		#
		#if abs(parent.velocite.z) < 1 :
			#arret.y = 0
			#parent.velocite.z = 0
		#else :
			#arret.y = 1.0/abs(parent.velocite.z)  * -parent.velocite.z * 0.2
		#
		#parent.appliquer_force(Vector3(arret.x, 0, arret.y))
	
	_debugging()

func _debugging():
	var debug_vitesse = parent.velocite
	debug_vitesse.y = 0
	$HBoxContainer/CompteurVitesse._actualisation_compteur(debug_vitesse.length())
