extends Node

@export var constante_g := 1.0

var liste_objets = []

func _ready() -> void:
	liste_objets = get_tree().get_nodes_in_group("objets_gravitationnels")

func _physics_process(delta: float) -> void:
	for objet1 in liste_objets :
		for objet2 in liste_objets :
			if objet1 != objet2 :
				objet1.attractionGravitationnelle(objet2, constante_g)
