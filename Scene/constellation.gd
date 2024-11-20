extends Node2D
class_name Constellation

var etoiles : Array[Etoile]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var precedente_etoile : Etoile
	for etoile in etoiles :
		if precedente_etoile :
			draw_line(precedente_etoile.global_position, etoile.global_position,precedente_etoile.couleur.blend(etoile.couleur),2)
		precedente_etoile = etoile
