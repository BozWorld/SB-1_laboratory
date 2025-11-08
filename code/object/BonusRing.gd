@tool
extends Ring
class_name BonusRing

signal bonus_ring_passed()

var passed := false

func _ring_setup() -> void:
	if Engine.is_editor_hint():
		if manager.bonus_rings.find(self) == -1 :
			manager.bonus_rings.append(self)

func done() -> void:
	passed = true
	mesh_instance.set_surface_override_material(0, passed_material)

func ring_passed():
	print("Bonus ring passed !")
	if !passed:
		bonus_ring_passed.emit()
		done()
