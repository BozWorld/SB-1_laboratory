extends ObjetGravitationnel

var velocite_ini := Vector3(randf_range(-4.4,4.4), randf_range(-4.4,4.4), randf_range(-4.4,4.4))

func _physics_process(delta: float) -> void:
	logiqueMouvement(delta)

func _ready() -> void:
	super()
	velocite = velocite_ini
