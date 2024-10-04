extends Node3D

var masse = 1.0

var velocite : Vector3
var acceleration : Vector3


func apply_force(force : Vector3):
	

func get_input():
	var impulse : Vector2
	impulse.x = Input.get_axis("bougerDROITE", "bougerGAUCHE")
	impulse.y = Input.get_axis("bougerARRIERE","bougerAVANT")
	return impulse

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
