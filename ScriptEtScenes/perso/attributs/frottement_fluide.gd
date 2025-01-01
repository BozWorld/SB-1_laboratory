extends Attribut3D

var coef : float = 0.8
var surface : float = 1.0
var densite : float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _frottement_process(delta, velocite : Vector3):
	var frot_direction = -velocite.normalized()
	
	var frot_mag = velocite.length() * velocite.length() * coef * surface * densite * delta
	
	var frottement = frot_direction * frot_mag
	parent.appliquer_force(frottement)
	print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	Frottements : 
	Direction = " + str(frot_direction) + "
	Magnitude = " + str(frot_mag))
