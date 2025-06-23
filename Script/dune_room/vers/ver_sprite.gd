extends Sprite2D

var intouchable := true

var seuil_delta := 0.1312
var index_delta := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation += 0.15
	
	if intouchable :
		index_delta += delta
		if index_delta >= seuil_delta :
			index_delta -= seuil_delta
			visible = !visible
			$Area2D.monitorable = true
	elif !visible :
		show()
