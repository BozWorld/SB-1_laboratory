extends Attribut3D

var genoux_flechis := false

var flexion := 0.0
var max_flexion := 7.0
var machine_etats

func _ready() -> void:
	call_deferred("init_machine_etat()")

func init_machine_etat():
	machine_etats = parent.machine_etats
	machine_etats.add_state("prepare_saut")

func _unhandled_input(event: InputEvent) -> void:
	if parent.is_on_floor() :
		if Input.is_action_just_pressed("saut"):
			genoux_flechis = true
		
		if Input.is_action_just_released("saut"):
			genoux_flechis = false
		


func _saut_process(delta):
	if !genoux_flechis:
		if flexion :
			parent.mesh.scale = Vector3(1,1,1)
			var saut = 10.0
			saut += flexion
			parent.appliquer_force_verticale(saut)
			flexion = 0.0
			$HBoxContainer/DebugFlexion._actualisation_compteur(flexion)
	
	elif flexion < max_flexion :
		flexion += 10.0 * delta
		$HBoxContainer/DebugFlexion._actualisation_compteur(flexion)
		parent.mesh.scale *= 0.995
	
	elif !parent.is_on_floor():
		genoux_flechis = false
