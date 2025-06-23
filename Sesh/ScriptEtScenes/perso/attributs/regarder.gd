extends Attribut3D

@export_range(0,0.01,0.0001) var sensibilite : float = 0.001
var horizontal_input := 0.0
var vertical_input := 0.0
var seuil_arret = 0.00005

var delais_corps : float = 0.0

@onready var horizontal_pivot = $HPivot
@onready var vertical_pivot = $HPivot/VPivot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			horizontal_input = - event.relative.x * sensibilite
			vertical_input = - event.relative.y * sensibilite


func _regarder_process(delta: float) -> void:
	
	horizontal_pivot.rotate_y(horizontal_input)
	vertical_pivot.rotate_x(vertical_input)
	horizontal_input *= 0.3
	vertical_input *= 0.3
	if horizontal_input < seuil_arret :
		horizontal_input = 0
	if vertical_input < seuil_arret :
		vertical_input = 0
	
	_retourner_process()

func _retourner_process():
	if horizontal_pivot.rotation.y != 0.0 :
		match parent.machine_etats.get_state() :
			
			parent.machine_etats.states.attend :
				delais_corps = 1.0
			
			_ :
				delais_corps = 0.2
			
		var mod_rotation_corps = lerp_angle(parent.rotation.y, horizontal_pivot.global_rotation.y, delais_corps) - parent.rotation.y
		parent.rotate_y(mod_rotation_corps)
		horizontal_pivot.rotate_y(-mod_rotation_corps)
