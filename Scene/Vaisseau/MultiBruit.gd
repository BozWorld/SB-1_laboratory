@tool
extends Resource
class_name MultiBruit

@export var liste_bruits : Array[BruitPese]

func prendreBruit2D(x : float, y : float):
	var produit = 0.0
	var total_poids = 0.0
	for bruit in liste_bruits :
		produit += bruit.bruit.get_noise_2d(x, y) * bruit.poids
		total_poids += bruit.poids
	
	return produit / total_poids
