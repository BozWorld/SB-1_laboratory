extends Attribut3D

var genoux_flechis := false

var flexion := 0.0
@export var max_flexion := 5.0

func _ready() -> void:
	parent.machine_etats.add_state("prepare_saut")

func _get_input():
	if Input.is_action_pressed("saut"):
		if parent.machine_etats.state 

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("saut"):
		flexion = 0
		genoux_flechis = true
		
	elif Input.is_action_just_released("saut"):
		genoux_flechis = false
		parent.mesh.scale.y = 1.0
		flexion = 0
		var saut = Vector3(0,20,0)
		saut.y += flexion
		parent.appliquer_force(saut)
		#print("saut :" + str(saut.y))
		

func _physics_process(delta: float) -> void:
	if genoux_flechis and flexion < max_flexion :
		flexion += 2.0 * delta
		parent.mesh.scale.y *= 0.99
		#print("flexion : " + str(flexion))
