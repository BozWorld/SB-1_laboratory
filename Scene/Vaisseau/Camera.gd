extends Camera3D

@onready var suiveur = %Suiveur

var base_fov := 75.0

@export var mod_fov := 1.0

func _ready() -> void:
	base_fov = fov

func _physics_process(delta: float) -> void:
	fov = base_fov + mod_fov * suiveur.latence
