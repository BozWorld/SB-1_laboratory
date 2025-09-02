extends Area2D

@onready var truc = %Truc


func _on_area_entered(area: Area2D) -> void:
	if area is CollisionTruc2  and truc.plan == area.truc.plan :
		area.truc.appliquerForce((area.truc.position - truc.position)*0.9)
		
