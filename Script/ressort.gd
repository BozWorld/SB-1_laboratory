extends ObjetPhysique

func _ready() -> void:
	add_to_group("ressorts")

func _physics_process(delta: float) -> void:
	appliquerForce(-position*0.4)
	logiqueMouvement(delta)
