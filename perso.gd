extends TrucIllogique

var pret := true

@export var dimension := 0

var cd_restant : int = 0

var atak = false

func action(cd : int):
	pret = false
	cd_restant = cd

func logiqueIllogique():
	appliquerGravite()
	bouger()
	
	cd_restant -= 1
	if cd_restant <= 0 :
		pret = true
		get_child(0).couleur_contour = Color.RED
		if atak :
			atak = false
			%atk.disabled = false
		
	else :
		get_child(0).couleur_contour = Color.WHITE


func _on_merde_pressed() -> void:
	appliquerForce(Vector2.RIGHT * 44.0)
	action(80)


func _on_gauche_pressed() -> void:
	appliquerForce(Vector2.LEFT * 44.0)
	action(50)


func _on_bas_pressed() -> void:
	appliquerForce(Vector2.DOWN * 44.0)
	action(20)


func _on_haut_pressed() -> void:
	appliquerForce(Vector2.UP * 80.0)
	action(40)


func _on_button_pressed() -> void:
	dimension += 1
	if dimension == 3 :
		dimension = 0
		modulate = Color(1.0,1.0,1.0,1.0)
	
	if dimension == 1 :
		modulate = Color(1.0,1.0,1.0,0.7)
	
	elif dimension == 2 :
		modulate = Color(1.0,1.0,1.0,0.4)



func _on_attaque_pressed() -> void:
	atak = true
	%atk.disabled = false
	action(20)
	
