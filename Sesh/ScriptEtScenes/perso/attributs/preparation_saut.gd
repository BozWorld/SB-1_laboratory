extends Attribut3D

@export var coef_detente := 1.312

@export var detente_max := 7.0

@export var v_pas_de_geant := 13.12

var cliqued := false

var flexion := 0.0
@onready var machine_etats : StateMachine = %Etats


func init_machine_etat():
	machine_etats = parent.machine_etats


func _saut_process():
	var mod_puissance := 1.0
	var mod_delais := 1.0
	var v_force := 0.0
	var retour

	
	if !Input.is_action_pressed("saut"):
		if flexion :
			if parent.is_on_floor() :
				#parent.mesh.scale = Vector3(1,1,1)
				var saut = 10.0
				saut += flexion
				parent.appliquer_force_verticale(saut)
				%DebugVPush._actualisation_compteur(saut)
			
			
			flexion = 0.0
			%DebugFlexion._actualisation_compteur(flexion)
	
	elif parent.is_on_floor() :
		if flexion < detente_max :
			flexion += coef_detente 
			%DebugFlexion._actualisation_compteur(flexion)
		
		if machine_etats.state == machine_etats.states["marche"]:
			mod_delais = 0.44
			retour = {"puissance" : mod_puissance,
			"delais" : mod_delais,
			"v_force" : v_force}
		elif machine_etats.state == machine_etats.states["cours"]:
			mod_puissance = 1.0 - flexion * 0.1
			retour = {"puissance" : mod_puissance,
			"delais" : mod_delais,
			"v_force" : v_force}
		elif machine_etats.state == machine_etats.states["sprint"]:
			mod_delais = 4.4
			mod_puissance = 3.0
			v_force = v_pas_de_geant + flexion * 0.1
			retour = {"puissance" : mod_puissance,
			"delais" : mod_delais,
			"v_force" : v_force}
		
		
	#parent.mesh.scale *= 0.995
	
	if retour :
		return(retour)
