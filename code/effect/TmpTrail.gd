extends Trail
class_name TempTrail

func setup():
	super()
	genere_trail = true

func _physics_process(delta: float) -> void:
	update_trail(delta)
 
func _update_points_lifetime(delta: float):
	var i = 0
	while i < _points.size():
		_lifetimes[i] += delta
		if _lifetimes[i] >= trail_lifetime:
			_points.remove_at(i)
			_basis.remove_at(i)
			_lifetimes.remove_at(i)
			_directions.remove_at(i)

			if _points.is_empty() :
				queue_free()
		else:
			i += 1
