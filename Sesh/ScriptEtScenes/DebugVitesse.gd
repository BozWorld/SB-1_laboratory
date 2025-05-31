extends RichTextLabel

var formatage = "[font_size=40][color=yellow]"

func _actualisation_compteur(vitesse : float):
	text = formatage + str(vitesse)
	
