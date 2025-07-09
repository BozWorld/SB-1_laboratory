extends Node2D
class_name BoutonTel

# Taille (en pixel) du bouton
@export var taille := Vector2(150,150)
# Couleur du bouton
@export var couleur := Color.RED
# Couleur du bouton quand appuyé
@export var couleur_appuyee := Color.GREEN
# Nom de l'input a simuler
@export var input_bouton : StringName = "ui_accept"
# Puissance de l'input
@export var puissance_input := 1.0

# Variable vraie quand le bouton est appuyé
var appuye := false

# Si on est sur tel, le bouton s'affiche
func _process(delta: float) -> void:
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		queue_redraw()

func _draw() -> void:
	if appuye :
		draw_rect(Rect2(Vector2.ZERO + taille* 0.05, taille * 0.9), couleur_appuyee)
	else :
		draw_rect(Rect2(Vector2.ZERO, taille), couleur)


func appuyed():
	Input.action_press(input_bouton, puissance_input)
	appuye = true

func lached():
	Input.action_release(input_bouton)
	appuye = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch :
		if event.position.x > position.x and event.position.x < position.x + taille.x :
			if event.position.y > position.y and event.position.y < taille.y + position.y :
				if event.pressed :
					appuyed()
				else : 
					lached()
