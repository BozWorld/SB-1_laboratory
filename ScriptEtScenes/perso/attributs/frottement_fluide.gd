extends Attribut3D

var coef : float = 0.1
var aerodynamisme : float = 1.0
var densite : float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _frottement_process(delta, velocite : Vector3):
	var frot_direction = -velocite.normalized()
	var frot_mag = velocite.length()**2.0 * coef * aerodynamisme * densite
	var frottement = frot_direction * frot_mag * delta
	parent.appliquer_force(frottement)
