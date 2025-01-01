extends Attribut3D

var coef : float = 0.08
var normal : float = 1.0
var densite : float = 1.0

func _frottement_process(delta, velocite : Vector3):
	var frot_direction = -velocite.normalized()
	
	var frot_mag = coef * normal * delta
	
	var frottement = frot_direction * frot_mag
	parent.appliquer_force(frottement)
	print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	Frottement Statique : 
	Direction = " + str(frot_direction) + "
	Magnitude = " + str(frot_mag))
