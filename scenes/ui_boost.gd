extends Control

var valeur:= 0.0
var valeur_active := 0.0

var mod_taille := 2.0

func actualiser_ui_boost(charge:float, boost: float):
	if charge > 1.0:
		charge = 1.0
	if boost > 1.0:
		boost = 1.0
	valeur = charge
	valeur_active = boost

func _physics_process(_delta: float) -> void:
	queue_redraw()

func _draw():
	draw_arc(Vector2.ZERO,50.0 * mod_taille, 0.0, valeur * PI * 2.0, 44, Color.RED, 15.0 * mod_taille)
	draw_arc(Vector2.ZERO, 61.5 * mod_taille, 0.0, valeur_active * PI * 2.0, 44, Color(0.659, 0.59, 0.935, 1.0), 8.0 * mod_taille)
