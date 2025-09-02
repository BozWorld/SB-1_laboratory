@tool
extends Node2D
class_name Cercle

@export var taille := 20.0
@export var taille_contour := 5.0

@export var couleur := Color.BLACK
@export var couleur_contour := Color.RED

func _draw() -> void:
	draw_circle(Vector2.ZERO, taille, couleur, true)
	draw_circle(Vector2.ZERO, taille, couleur_contour, false, taille_contour)

func _process(delta: float) -> void:
	queue_redraw()
