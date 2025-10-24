extends ActeurPhysique

@onready var moteur_rotatif := %MoteurRotatif
@onready var moteur_deplacements := %MoteurDeplacements

func _physics_process(delta: float) -> void:
	moteur_rotatif.logiqueMoteur(delta)
	moteur_deplacements.logiqueMoteur(delta)

	logiqueMouvement(delta)
