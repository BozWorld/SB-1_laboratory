extends Node2D

var main : Node2D
var camera : Camera2D

var min_fps := 30.0

var decompte_constellation := 0

var constellation_en_creation : Constellation

func ajout_etoile(etoile : Etoile):
	#etoile.selectionnee = true
	constellation_en_creation.ajout_etoile(etoile)
	camera._deplacement_constelleur(etoile.global_position)


func debut_ajout_constellation(etoile : Etoile):
	#etoile.selectionnee = true
	
	decompte_constellation += 1
	var nouvelle_constellation = Constellation.new()
	nouvelle_constellation.name = "Constellation n°" + str(decompte_constellation)
	nouvelle_constellation.premiere_etoile = etoile
	nouvelle_constellation.etoiles.append(etoile)
	main.add_child(nouvelle_constellation)
	
	constellation_en_creation = nouvelle_constellation
	constellation_en_creation.global_position = etoile.global_position
	


func fin_ajout_constellation():
	constellation_en_creation = null

func reselection_etoile(etoile : Etoile):
	
	# Si il y a plus d'une étoile dans la constellation en cours ... (pour ne pas désélectionner la première automatiquement)
	if constellation_en_creation.etoiles.size() > 1 :
		
		# ... Et que l'étoile touchée par le curseur est la même que la précédente, elle est alors désélectionnée
		if constellation_en_creation.etoiles[constellation_en_creation.etoiles.size()-1] == etoile :
			etoile.deselection(constellation_en_creation.liaisons[constellation_en_creation.liaisons.size()-1])
			constellation_en_creation.ctrlz()
			camera._deplacement_constelleur(constellation_en_creation.etoiles[constellation_en_creation.etoiles.size()-1].global_position)
			return
	
	# Si il n'y a qu'une étoile dans la constellation et que c'est celle visée, alors il se passe rien
	elif constellation_en_creation.etoiles.size() == 1 and etoile == constellation_en_creation.premiere_etoile :
		return
	#elif constellation_en_creation.liaisons[constellation_en_creation.liaisons.size()-1]
	
	constellation_en_creation.ajout_etoile(etoile)
	camera._deplacement_constelleur(etoile.global_position)
			
		
