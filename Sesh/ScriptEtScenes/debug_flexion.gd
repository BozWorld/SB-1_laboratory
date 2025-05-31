extends RichTextLabel


var formatage = "[font_size=40][color=red]"

func _actualisation_compteur(flexion : float):
	text = formatage + str(flexion)
	
