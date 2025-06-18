extends Attribut3D

@onready var cam = %Camera3D

var fov_vise = 0.0
@export var vitesse := 50.0

func _physics_process(delta: float) -> void:
	if parent.velocite :
		fov_vise = 75 - parent.velocite.length()
	
	if fov_vise :
		cam.fov += (fov_vise - cam.fov) * delta * vitesse
