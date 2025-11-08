@tool
extends Ring
class_name OrderedRing

signal ring_passed_ordoredly(_ring_order: int)

@export var ring_order : int:
	set(value):
		if %RingManager:
			if !manager:
				manager = %RingManager
		if manager:
			ring_order = value
			if manager.ordered_rings.find(self) > -1:
				manager.change_ring_order(manager.ordered_rings.find(self), value)
			else :
				manager.ordered_rings.insert(value, self)

var is_active := false

@export var next_material: Material
@export var active_material: Material

var passed:= false

func _ring_ready() -> void:
	if Engine.is_editor_hint():
		if manager.ordered_rings.find(self) == -1 :
			manager.ordered_rings.append(self)

func set_active(active: bool, is_next:= false) -> void:
	is_active = active
	
	if is_active:
		mesh_instance.set_surface_override_material(0, active_material)
		print("Ring activated: ", ring_order)
	elif is_next:
		mesh_instance.set_surface_override_material(0, next_material)
	elif passed:
		mesh_instance.set_surface_override_material(0, passed_material)
	else:
		mesh_instance.set_surface_override_material(0, base_material)

func ring_passed():
	print("is_active: ", is_active, " - Ring order: ", ring_order)
	if is_active:
		passed = true
		ring_passed_ordoredly.emit(ring_order)
