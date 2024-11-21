extends Node2D

var main : Node2D
var camera : Camera2D

var decompte_constellation := 0

var constellation_en_creation : Constellation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().root.get_child(0)

func ajout_etoile(etoile : Etoile):
	#etoile.selectionnee = true
	constellation_en_creation.ajout_etoile(etoile)
	camera._deplacement_constelleur(etoile.global_position)


func debut_ajout_constellation(etoile : Etoile):
	#etoile.selectionnee = true
	
	decompte_constellation += 1
	var nouvelle_constellation = Constellation.new()
	nouvelle_constellation.premiere_etoile = etoile
	nouvelle_constellation.etoiles.append(etoile)
	main.add_child(nouvelle_constellation)
	
	constellation_en_creation = nouvelle_constellation
	constellation_en_creation.global_position = etoile.global_position
	


func fin_ajout_constellation():
	constellation_en_creation = null

func reselection_etoile(etoile : Etoile):
	if constellation_en_creation.etoiles.size() > 1 :
		if constellation_en_creation.etoiles[constellation_en_creation.etoiles.size()-1] == etoile :
			etoile.deselection(constellation_en_creation.liaisons[constellation_en_creation.liaisons.size()-1])
			constellation_en_creation.ctrlz()
			camera._deplacement_constelleur(constellation_en_creation.etoiles[constellation_en_creation.etoiles.size()-1].global_position)
			return
			
	#etoile.selectionnee = true
	constellation_en_creation.ajout_etoile(etoile)
	camera._deplacement_constelleur(etoile.global_position)
			
		
