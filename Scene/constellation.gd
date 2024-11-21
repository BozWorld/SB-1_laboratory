extends Node2D
class_name Constellation

var etoiles : Array[Etoile]

var premiere_etoile : Etoile
var init = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if init :
		if etoiles.size():
			premiere_etoile = etoiles[1]
			init = false
		
	queue_redraw()

func _draw() -> void:
	var precedente_etoile : Etoile
	for etoile in etoiles :
		if precedente_etoile :
			draw_line(precedente_etoile.position, etoile.position,precedente_etoile.couleur.blend(etoile.couleur),2)
		precedente_etoile = etoile
