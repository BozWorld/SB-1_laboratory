@tool
extends Ring
class_name OrderedRing

# Signal émis lorsque l'avion a passé l'anneau dans le bon ordre de la suite
signal ring_passed_ordoredly(_ring_order: int)

## Index de l'anneau dans la suite d'anneaux, qui commence à 0 avec le premier.
@export var ring_order : int:
	set(value):
		ring_order = value
		if manager :
			if manager.ordered_rings.find(self) > -1:
				manager.change_ring_order(manager.ordered_rings.find(self), value)
			else :
				manager.ordered_rings.insert(value, self)

# Bool vrai lorsque c'est l'anneau à passer
var is_active := false

## Material de l'anneau lorsque qu'il est le surprochain dans la suite d'anneaux
@export var next_material: Material
## Material de l'anneau lorsqu'il est le prochain dans la suite d'anneaux
@export var active_material: Material

# Bool vrai lorsqu'il est passé correctement
var passed:= false

# Si la scene est ouverte est que l'anneau n'est pas dans l'array d'anneau bonus du manager,
# il s'y rajoute
func _ring_setup() -> void:
	if manager:
		if manager.ordered_rings.find(self) == -1 :
			manager.ordered_rings.append(self)

# Fonction appelée par le manager à chaque fois qu'un anneau est passé et qui change
# l'état de l'anneau en fonction de l'avancement de l'avion dans la suite d'anneaux.
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

# Fonction appelée lors d'une collision avec l'avion
func ring_passed(score: float):
	print("is_active: ", is_active, " - Ring order: ", ring_order)
	if is_active:
		print("Score: " + str(score))
		passed = true
		ring_passed_ordoredly.emit(ring_order)
