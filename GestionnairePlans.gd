extends Node

@export var nombre_plans := 3

var plan_actuel := 0

var changement_sup := Color.RED
var changement_inf := Color.BLUE

func logiquePlans():
	if plan_actuel == 0 :
		for perso in get_tree().get_nodes_in_group("persos") :
			if perso.plan == plan_actuel :
				perso.modulate = Color.WHITE
			elif perso.plan == 1 :
				perso.modulate = changement_sup.lerp(Color(1.0,1.0,1.0, 0.1), 0.5)
			elif perso.plan == 2 :
				perso.modulate = changement_inf.lerp(Color(1.0,1.0,1.0, 0.1), 0.5)
	elif plan_actuel == 1 :
		for perso in get_tree().get_nodes_in_group("persos") :
			if perso.plan == plan_actuel :
				perso.modulate = Color.WHITE
			elif perso.plan == 2 :
				perso.modulate = changement_sup.lerp(Color(1.0,1.0,1.0, 0.1), 0.5)
			elif perso.plan == 0 :
				perso.modulate = changement_inf.lerp(Color(1.0,1.0,1.0, 0.1), 0.5)
	elif plan_actuel == 2 :
		for perso in get_tree().get_nodes_in_group("persos") :
			if perso.plan == plan_actuel :
				perso.modulate = Color.WHITE
			elif perso.plan == 0 :
				perso.modulate = changement_sup.lerp(Color(1.0,1.0,1.0, 0.1), 0.5)
			elif perso.plan == 1 :
				perso.modulate = changement_inf.lerp(Color(1.0,1.0,1.0, 0.1), 0.5)
