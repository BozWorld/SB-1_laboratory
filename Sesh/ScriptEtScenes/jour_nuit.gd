extends Node3D


@export var vitesse = 4.4
var doDaylightCycle = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if doDaylightCycle :
		$DirectionalLight3D.rotation.x += 0.01 * delta * vitesse
