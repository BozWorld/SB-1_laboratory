extends AttributPhysique

@export var frottements := 0.05
@export var puissance := 1.0

@export var max_boost := 2.0
@export var puissance_boost := 1.0

@export var min_vitesse_trails := 15.0

@export var trails : Array[Trail]

@onready var moteur_trails = %MoteurTrails

var boost_appuyé := false
var index_boost := 0.0

func prendreInput() -> float:
	var prise_input = Input.get_axis("avancer", "freiner")
	return prise_input

func prendreBoost(delta : float):
	if Input.is_action_pressed("boost"):
		if boost_appuyé :
			index_boost += delta
		else :
			boost_appuyé = true

				
	elif boost_appuyé :
		boost_appuyé = false
		index_boost = 0.0
		
	return boost_appuyé

func logiqueMoteur(delta : float):
	var poussee = parent.transform.basis.z * (prendreInput()  * puissance)
	
	var boost = prendreBoost(delta)

	if boost:
		poussee *= clampf(index_boost + index_boost * puissance_boost, 1.0, max_boost)

	if poussee :
		parent.appliquerForce(poussee)

	
	if parent.velocite :
		parent.appliquerFriction()
	
	moteur_trails.logiqueTrails(parent.velocite.length(), boost)
