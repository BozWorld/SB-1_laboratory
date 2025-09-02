extends TrucIllogique

var pret := true
var tour := false

@export var plan := 0

var cd_restant : int = 0

var atak = false

@onready var visuel = $Cercle

func action(cd : int):
	pret = false
	tour = false
	cd_restant = cd

func logiqueIllogique():
	appliquerGravite()
	bouger()
	resterTube()
	
	cd_restant -= 1
	if cd_restant <= 0 :
		pret = true
		get_child(0).couleur_contour = Color.RED
		if atak :
			atak = false
			%atk.disabled = true
			$Node2D/Cercle.hide()
		
	else :
		get_child(0).couleur_contour = Color.WHITE


func resterTube():
	if position.y < 0 + $CollisionTruc/CollisionShape2D.shape.radius :
		velocite.y = -velocite.y * 0.9
		position.y = $CollisionTruc/CollisionShape2D.shape.radius
	elif position.y >= 647 - $CollisionTruc/CollisionShape2D.shape.radius :
		velocite.y = -velocite.y * 0.9
		position.y = 647 - $CollisionTruc/CollisionShape2D.shape.radius
		
	if position.x < 0 + $CollisionTruc/CollisionShape2D.shape.radius :
		velocite.x = -velocite.x * 0.9
		position.x = $CollisionTruc/CollisionShape2D.shape.radius
	elif position.x >= 1167 - $CollisionTruc/CollisionShape2D.shape.radius :
		velocite.x = -velocite.x * 0.9
		position.x = 1167 - $CollisionTruc/CollisionShape2D.shape.radius
		


func _on_merde_pressed() -> void:
	if tour :
		appliquerForce(Vector2.RIGHT * 131.2)
		action(10)


func _on_gauche_pressed() -> void:
	if tour :
		appliquerForce(Vector2.LEFT *131.2)
		action(10)


func _on_bas_pressed() -> void:
	if tour :
		appliquerForce(Vector2.DOWN * 131.2)
		action(5)


func _on_haut_pressed() -> void:
	if tour :
		appliquerForce(Vector2.UP * 80.0)
		action(15)


func _on_button_pressed() -> void:
	plan += 1
	if plan >= 3 :
		plan = 0
	
	%GestPlans.logiquePlans()
		#modulate = Color(1.0,1.0,1.0,1.0)
	#
	#if plan == 1 :
		#modulate = Color(1.0,1.0,1.0,0.7)
	#
	#elif plan == 2 :
		#modulate = Color(1.0,1.0,1.0,0.4)



func _on_attaque_pressed() -> void:
	if tour :
		atak = true
		%atk.disabled = false
		action(20)
		$Node2D/Cercle.show()
	
