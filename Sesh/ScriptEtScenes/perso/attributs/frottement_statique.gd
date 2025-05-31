extends Attribut3D

var coef : float = 0.5
var normal : float = 1.0
var densite : float = 1.0

func _appliquer_frottement(velocite : Vector3 = parent.velocite + parent.acceleration):
	var frot_direction = -velocite.normalized()
	
	var frot_mag = coef * normal
	
	var frottement = frot_direction * frot_mag
	parent.appliquer_force(frottement)
	#print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	#Frottement Statique : 
	#Direction = " + str(frot_direction) + "
	#Magnitude = " + str(frot_mag))
