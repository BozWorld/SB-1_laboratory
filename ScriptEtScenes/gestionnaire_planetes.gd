extends Node

@export var planetes : Array[Planet]
# Called when the node enters the scene tree for the first time.
func _chopper_gravite(position : Vector3):
	var attraction_totale : Vector3
	
	for planete in planetes :
		var difference := planetes[0].position - position
		var distance = difference.length()
		var force = (planete.poids * 9.8) / (distance * distance)
		
		attraction_totale += difference.limit_length(force)
	
	return attraction_totale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
