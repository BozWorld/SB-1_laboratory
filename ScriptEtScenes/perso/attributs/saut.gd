extends Attribut3D

var genoux_flechis := false

var flexion := 0.0
@export var max_flexion := 5.0
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
		
		elif Input.is_action_just_released("saut"):
			genoux_flechis = false
		


func _saut_process(delta):
	if !genoux_flechis:
		if flexion :
			parent.mesh.mesh.height = 2
			var saut = Vector3(0,20,0)
			saut.y += flexion
			flexion = 0.0
			parent.appliquer_force(saut)
	
	elif flexion < max_flexion :
		flexion += 2.0 * delta
		parent.mesh.mesh.height *= 0.9
	
	elif !parent.is_on_floor():
		genoux_flechis = false
