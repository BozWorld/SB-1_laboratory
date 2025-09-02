extends Cercle

@export var couleur_pret := Color.SEA_GREEN
@export var couleur_tour := Color.LAVENDER

func _process(delta: float) -> void:
	if get_parent().tour :
		couleur_contour = couleur_tour
	elif get_parent().pret :
		couleur_contour = couleur_pret
	else :
		couleur_contour = Color(0,0,0,0)
	
	queue_redraw()
