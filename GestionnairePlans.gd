extends Node

@export var nombre_plans := 3
@export var range_visible := 1

var plan_actuel := 0

@onready var label := %UiPlans

var changement_sup := Color(0.5,0.0,0.0,0.1)
var changement_inf := Color(0.0,0.5,0.0,0.1)

func mettrePlan(plan := 0):
	plan_actuel = plan
	logiquePlans()

func logiquePlans():
	
	label.text = "[center][font_size=30]Plan "+ str(plan_actuel)
	
	#for perso in get_tree().get_nodes_in_group("persos") :
		
	
	if plan_actuel == 0 :
		for perso in get_tree().get_nodes_in_group("persos") :
			if perso.plan == plan_actuel :
				perso.visuel.modulate = Color.WHITE
				perso.visuel.scale = Vector2(1.0,1.0)
			elif perso.plan == 1 :
				perso.visuel.modulate = Color.WHITE.lerp(changement_sup, 0.9)
				perso.visuel.scale = Vector2(0.8,0.8)
			elif perso.plan == 2 :
				perso.visuel.modulate = Color.WHITE.lerp(changement_inf, 0.9)
				perso.visuel.scale = Vector2(1.1,1.1)
	elif plan_actuel == 1 :
		for perso in get_tree().get_nodes_in_group("persos") :
			if perso.plan == plan_actuel :
				perso.visuel.modulate = Color.WHITE
				perso.visuel.scale = Vector2(1.0,1.0)
			elif perso.plan == 2 :
				perso.visuel.modulate = Color.WHITE.lerp(changement_sup, 0.9)
				perso.visuel.scale = Vector2(0.8,0.8)
			elif perso.plan == 0 :
				perso.visuel.modulate = Color.WHITE.lerp(changement_inf,0.9)
				perso.visuel.scale = Vector2(1.1,1.1)
	elif plan_actuel == 2 :
		for perso in get_tree().get_nodes_in_group("persos") :
			if perso.plan == plan_actuel :
				perso.visuel.modulate = Color.WHITE
				perso.visuel.scale = Vector2(1.0,1.0)
			elif perso.plan == 0 :
				perso.visuel.modulate = Color.WHITE.lerp(changement_sup, 0.9)
				perso.visuel.scale = Vector2(0.8,0.8)
			elif perso.plan == 1 :
				perso.visuel.modulate = Color.WHITE.lerp(changement_inf, 0.9)
				perso.visuel.scale = Vector2(1.1,1.1)
	elif plan_actuel >= nombre_plans :
		plan_actuel = 0
		logiquePlans()
	elif plan_actuel <= 0 :
		plan_actuel = nombre_plans - 1
		logiquePlans()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("plan_inf"):
		plan_actuel -= 1
		logiquePlans()
		
	if Input.is_action_just_pressed("plan_sup"):
		plan_actuel += 1
		print("prout")
		logiquePlans()
