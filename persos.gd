extends Node

@onready var persos : Array[Node] = get_tree().get_nodes_in_group("persos")

func checkPersos():
	var pause = false
	var persos_prets = []
	
	for perso in persos :
		if perso.pret :
			persos_prets.append(perso)
			pause= true
	
	var dico_reponse = {"pause" : pause, "persos" : persos_prets}
	
	return dico_reponse

func logiquePersos():
	for perso in persos :
		perso.logiqueIllogique()
