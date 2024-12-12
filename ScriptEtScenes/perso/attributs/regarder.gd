extends Attribut3D

@export_range(0,0.01,0.0001) var sensibilite : float = 0.001
var horizontal_input := 0.0
var vertical_input := 0.0

@onready var horizontal_pivot = $HPivot
@onready var vertical_pivot = $HPivot/VPivot

var camera_bloquee = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			horizontal_input = - event.relative.x * sensibilite
			vertical_input = event.relative.y * sensibilite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	horizontal_pivot.rotate_y(horizontal_input)
	vertical_pivot.rotate_x(vertical_input)
	horizontal_input *= 0.3
	vertical_input *= 0.3
	if horizontal_input < 0.00005 :
		horizontal_input = 0
	if vertical_input < 0.00005 :
		vertical_input = 0
