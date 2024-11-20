extends Area2D

var selection : Array[Node2D]


func _on_body_entered(body: Node2D) -> void:
	if body is CorpsEtoile :
		selection.append(body.parent)
		body.parent.brille = true

func _on_body_exited(body: Node2D) -> void:
	if body is CorpsEtoile :
		selection.erase(body.parent)
		body.parent.brille = false

func retour_selection():
	if selection.size() < 1 :
		return
	if selection.size() == 1 :
		return selection[0]
	if selection.size() > 1 :
		var position_plus_proche = Vector2(0,0)
		var etoile_plus_proche
		
		for etoile in selection :
			if global_position - etoile.global_position < global_position - position_plus_proche :
				position_plus_proche = etoile.global_position
				etoile_plus_proche = etoile
		
		if etoile_plus_proche :
			return etoile_plus_proche
