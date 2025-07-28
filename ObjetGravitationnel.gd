extends ObjetPhysique
class_name ObjetGravitationnel

@export var distance_min := 0.44

@export var distance_max := 60.0

func _ready() -> void:
	add_to_group("objets_gravitationnels")

func attractionGravitationnelle(objet : ObjetPhysique, constante_grav := 1.0):
	var distance = position - objet.position
	
	if distance.length() < distance_min :
		distance = -distance.normalized() * distance_min
	
	if distance.length() < distance_max :
		var attraction_dir = distance.normalized()
	
		var attraction_mag = constante_grav * masse * objet.masse
		var div_mag = distance.length() ** 2.0
		attraction_mag /= div_mag
	
		objet.appliquerForce(attraction_dir * attraction_mag)
