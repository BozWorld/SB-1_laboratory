extends Node2D

var main : Node2D

var decompte_constellation := 0

var constellation_en_creation : Constellation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().root.get_child(0)

func ajout_etoile(etoile : Etoile):
	etoile.selectionnee = true
	constellation_en_creation.etoiles.append(etoile)

func debut_ajout_constellation(etoile : Etoile):
	etoile.selectionnee = true
	
	decompte_constellation += 1
	var nouvelle_constellation = Constellation.new()
	main.add_child(nouvelle_constellation)
	
	constellation_en_creation = nouvelle_constellation
	constellation_en_creation.global_position = etoile.global_position
	constellation_en_creation.etoiles.append(etoile)
	
	

func fin_ajout_constellation():
	constellation_en_creation = null
