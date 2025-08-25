extends Truc
class_name TrucGravitationnel

@export var distance_min := 50.0

@export var distance_max := 5000.0

@export var velocite_init : Vector2

@export var coef_attracteur := 1.0

func appliquerFrottement():
	appliquerForce(-(velocite + acceleration) * 0.2, "Frottement")

func _ready() -> void:
	add_to_group("objets_gravitationnels")
	if velocite_init :
		velocite = velocite_init

func _processTruc(delta : float):
	#appliquerFrottextends
	bouger(delta)

func attractionGravitationnelle(objet : Truc, constante_grav := 1.0):
	var distance = position - objet.position
	
	if distance.length() < distance_min :
		distance = -distance.normalized() * distance_min
	
	if distance.length() < distance_max :
		var attraction_dir = distance.normalized()
	
		var attraction_mag = constante_grav * masse * objet.masse
		var div_mag = distance.length() ** 2.0
		attraction_mag /= div_mag
	
	
		objet.appliquerForce(attraction_dir * attraction_mag * coef_attracteur, "Attraction Gravitationnelle vers" + objet.name)
