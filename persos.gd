extends Node2D

@onready var persos : Array[Node] = get_tree().get_nodes_in_group("persos")

func checkPersos():
	var pause = false
	
	for perso in persos :
		if perso.pret :
			pause= true
	
	return pause

func logiquePersos():
	for perso in persos :
		perso.logiqueIllogique()
