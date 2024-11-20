extends Area2D

var selection : Array[Node2D]

@onready var parent = get_parent()

func _on_body_entered(body: Node2D) -> void:
	if body is CorpsEtoile :
		selection.append(body.parent)
		body.parent.brille = true

func _on_body_exited(body: Node2D) -> void:
	if body is CorpsEtoile :
		selection.erase(body.parent)
		body.parent.brille = false

func _process(delta: float) -> void:
	queue_redraw()

func retour_viseur():
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

func _draw() -> void:
	if !parent.bloquee :
		draw_circle(Vector2(0,0), 30, Color(255,255,255), false, 3)
