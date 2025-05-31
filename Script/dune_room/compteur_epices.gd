extends RichTextLabel

var valeur := 0.0 :
	set(value):
		valeur = value
		actualiserAffichage()

func actualiserAffichage():
	var mod_r := 0.0
	var mod_v := 0.0
	var mod_b := 0.0
	if valeur < 1.0 :
		mod_v = valeur 
	elif valeur < 2.0 :
		mod_v = 1.0
		mod_b = valeur - 1.0
	elif valeur < 3.0 :
		mod_v = 1.0
		mod_b = 1.0
		mod_r = clampf(valeur - 2.0, 0.0, 1.0)
	else :
		mod_v = 1.0
		mod_b = 1.0
		mod_r = 1.0
	
	var couleur = Color(1.0 - mod_r , 1.0 - mod_v , 1.0 - mod_b)
	
	var puisance_shake = 5.0 * valeur
		
	text = "[color=black]Epices : [/color]" + "[color=" + couleur.to_html() + "]" + "[shake rate=" + str(puisance_shake) + " level=5 connected=1]" + str(snappedf(valeur, 0.01))
