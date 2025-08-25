extends Area2D
class_name CollisionTruc

@onready var truc = get_parent()

func _ready() -> void:
	area_entered.connect(collisionDetectee)

func collisionDetectee(area: Area2D) -> void:
	if area is CollisionTruc :
		var force = area.truc.velocite * area.truc.masse
		truc.appliquerForce(force, "Collision avec " + area.truc.name)
		
		
		
