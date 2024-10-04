extends DirectionalLight3D

var doDaylightCycle = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if doDaylightCycle :
		rotation.x += 0.001
