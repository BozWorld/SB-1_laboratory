extends Attribut

@export_range(0,0.002,0.0001) var sensibilite : float = 0.001
var horizontal_input := 0.0
var vertical_input := 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func get_input():
	var impulse : Vector2
	impulse.x = Input.get_axis("bougerDROITE", "bougerGAUCHE") * sensibilite
	impulse.y = Input.get_axis("bougerARRIERE","bougerAVANT") * sensibilite
	return impulse

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
