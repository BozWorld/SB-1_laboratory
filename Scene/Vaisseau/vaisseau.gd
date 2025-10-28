extends ObjetPhysique

@onready var moteur_rotatif := %MoteurRotatif
@onready var moteur_deplacements := %MoteurDeplacements

var lances_missiles : Array[Node]

func _ready():
	lances_missiles = get_tree().get_nodes_in_group("LancesMissiles")

func _physics_process(delta: float) -> void:
	# print(velocite)
	moteur_rotatif.logiqueMoteur(delta)
	moteur_deplacements.logiqueMoteur(delta)
	for lance_missile in lances_missiles :
		lance_missile.logiqueLanceMissiles(delta)
	logiqueMouvement(delta)
