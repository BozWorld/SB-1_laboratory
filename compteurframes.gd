extends RichTextLabel

@onready var truc = get_parent()

func _process(delta: float) -> void:
	if !truc.pret :
		text = "[center][font_size=25]CD : " + str(truc.cd_restant)
	else:
		text = ""
