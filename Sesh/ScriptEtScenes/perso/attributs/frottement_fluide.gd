extends Attribut3D

@export_range(0.0, 1.0, 0.01) var coef : float = 0.1
var surface : float = 1.0
var densite : float = 1.0

func _frottement_process(delta, velocite : Vector3):
	var frot_direction = -velocite.normalized()
	
	var frot_mag = velocite.length() * velocite.length() * coef * surface * densite * delta
	
	var frottement = frot_direction * frot_mag
	parent.appliquer_force(frottement)
	#print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	#Frottement Fluide : 
	#Direction = " + str(frot_direction) + "
	#Magnitude = " + str(frot_mag))
