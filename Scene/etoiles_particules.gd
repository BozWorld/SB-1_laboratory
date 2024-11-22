extends Node2D

var decompte_particules = 0

func _nouvelle_particule(couleur):
	var onde = ParticuleCercle.new()
	decompte_particules = get_children().size()
	onde.name = "ParticuleCercle n°" + str(decompte_particules)
	onde.couleur = couleur
	add_child(onde)
