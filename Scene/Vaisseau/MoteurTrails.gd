extends Node

@export var origine_trails : Array[Marker3D]

@export var vitesse_min := 250.0


enum etats {INACTIF, JUSTE_BOOST, VITESSE_BOOST}

var etat_actuel = etats.INACTIF

var trails_active : Array[TempTrail] = []

@export var duree := 1.5

@onready var boite_trails := get_tree().get_first_node_in_group("BoiteTrails")


func creerTrails():
	trails_active.clear()
	for point in origine_trails :
		var nouvelle_trail := TempTrail.new()
		nouvelle_trail.trail_width_start = point.largeur_debut
		nouvelle_trail.trail_width_end = point.largeur_fin
		nouvelle_trail.cible = point
		nouvelle_trail.trail_precision = point.trail_precision
		nouvelle_trail.resolution_cylindre = point.resolution_cylindre
		nouvelle_trail.trail_lifetime = duree * point.mod_duree
		nouvelle_trail.material_override = point.mat_trail
		boite_trails.add_child(nouvelle_trail)
		nouvelle_trail.position = Vector3.ZERO
		trails_active.append(nouvelle_trail)
		point.trail = nouvelle_trail
		nouvelle_trail.genere_trail = true

func stopperGen():
	for trail in trails_active :
		trail.genere_trail = false

func allumerBoosts():
	for point in origine_trails :
		point.boost.show()

func eteindreBoosts():
	for point in origine_trails :
		point.boost.hide()

func logiqueTrails(vitesse : float, boost : bool):
	if etat_actuel == etats.INACTIF :
		if boost :
			allumerBoosts()
			etat_actuel = etats.JUSTE_BOOST
	
	elif etat_actuel == etats.JUSTE_BOOST :
		if !boost :
			eteindreBoosts()
			etat_actuel = etats.INACTIF
		elif vitesse >= vitesse_min :
			creerTrails()
			etat_actuel = etats.VITESSE_BOOST
	
	elif etat_actuel == etats.VITESSE_BOOST :
		if vitesse < vitesse_min :
			stopperGen()
			etat_actuel = etats.JUSTE_BOOST
			trails_active.clear()
