extends Area2D
class_name CollisionTruc2

@onready var truc = get_parent()

func _ready() -> void:
	area_entered.connect(collisionDetectee)

func collisionDetectee(area: Area2D) -> void:
	if area is CollisionTruc2 :
		if area.truc.dimension == truc.dimension:
			var force = area.truc.velocite * area.truc.masse
			truc.appliquerForce(force, "Collision avec " + area.truc.name)
		

	if area is Sol:
		truc.velocite.y = -truc.velocite.y * 0.9
		
	if area is Mur :
		truc.velocite.x = -truc.velocite.x * 0.9
		
