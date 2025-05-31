extends RichTextLabel

var formatage = "[font_size=40][color=purple]"
# Called when the node enters the scene tree for the first time.
func _changement_etat(nom_etat):
	text = formatage + nom_etat
