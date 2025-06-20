extends Attribut3D

@onready var cam = %Camera3D

var fov_vise = 0.0
@export var puissance := 2.1
@export var vitesse := 8.3

func _physics_process(delta: float) -> void:
	if parent.velocite.x or parent.velocite.z :
		fov_vise = 80 - abs(parent.velocite.x)*puissance - abs(parent.velocite.z)*puissance
	else :
		fov_vise = 0.0
	
	if fov_vise :
		cam.fov += (fov_vise - cam.fov) * delta * vitesse
