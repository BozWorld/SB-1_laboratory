extends Node

@export var nombre_plans := 3

var plan_actuel := 0

var changement_sup := Color(1.0,0.0,0.0,0.3)
var changement_inf := Color(0.0,0.0,1.0,0.3)

func logiquePlans():
	if plan_actuel == 0 :
		for perso in get_tree().get_nodes_in_group("persos") :
			if perso.plan == plan_actuel :
				perso.modulate = Color.WHITE
			elif perso.plan == 1 :
				perso.modulate = Color.WHITE.lerp(changement_sup, 0.8)
			elif perso.plan == 2 :
				perso.modulate = Color.WHITE.lerp(changement_inf, 0.8)
	elif plan_actuel == 1 :
		for perso in get_tree().get_nodes_in_group("persos") :
			if perso.plan == plan_actuel :
				perso.modulate = Color.WHITE
			elif perso.plan == 2 :
				perso.modulate = Color.WHITE.lerp(changement_sup, 0.8)
			elif perso.plan == 0 :
				perso.modulate = Color.WHITE.lerp(changement_inf,0.8)
	elif plan_actuel == 2 :
		for perso in get_tree().get_nodes_in_group("persos") :
			if perso.plan == plan_actuel :
				perso.modulate = Color.WHITE
			elif perso.plan == 0 :
				perso.modulate = Color.WHITE.lerp(changement_sup, 0.8)
			elif perso.plan == 1 :
				perso.modulate = Color.WHITE.lerp(changement_inf, 0.8)
