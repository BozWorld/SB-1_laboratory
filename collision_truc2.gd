extends Area2D
class_name CollisionTruc2

@onready var truc = get_parent()

#1167
#647

func _ready() -> void:
	area_entered.connect(collisionDetectee)

func collisionDetectee(area: Area2D) -> void:
	if area is CollisionTruc2 :
		if area.truc.plan == truc.plan:
			var force = area.truc.velocite * area.truc.masse
			truc.appliquerForce(force, "Collision avec " + area.truc.name)
		

	if area is Sol:
		truc.velocite.y = -truc.velocite.y * 0.9
		if truc.position.y < 0 + $CollisionShape2D.shape.radius :
			truc.position.y = $CollisionShape2D.shape.radius
		elif position.y >= 647 - $CollisionShape2D.shape.radius :
			truc.position.y = 647 - $CollisionShape2D.shape.radius
		
	if area is Mur :
		truc.velocite.x = -truc.velocite.x * 0.9
		if truc.position.x < 0 + $CollisionShape2D.shape.radius :
			truc.position.x = $CollisionShape2D.shape.radius
		elif position.x >= 1167 - $CollisionShape2D.shape.radius :
			truc.position.x = 1167 - $CollisionShape2D.shape.radius
		
