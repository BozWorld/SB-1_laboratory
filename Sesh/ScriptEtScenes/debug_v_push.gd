extends RichTextLabel




var formatage = "[font_size=40][color=green]"

func _actualisation_compteur(v_force : float):
	text = formatage + str(v_force)
	
