@tool
extends Ring
class_name BonusRing

# Signal émis lorsque l'avion passe pour la première fois dans l'anneau
signal bonus_ring_passed(_score: float)

# Bool qui dit si l'avion est passé par l'anneau ou non.
var passed := false

# Si la scene est ouverte est que l'anneau n'est pas dans l'array d'anneau bonus du manager,
# il s'y rajoute
func _ring_setup() -> void:
	if manager.bonus_rings.find(self) == -1 :
			manager.bonus_rings.append(self)

# Fonction appelée lors du premier passage de l'avion dans l'anneau
func done() -> void:
	passed = true
	mesh_instance.set_surface_override_material(0, passed_material)

# Fonction appelée lors d'une collision avec l'avion
func ring_passed(score: float):
	print("Bonus ring passed !")
	if !passed:
		done()
		print("Score: " + str(score))
		bonus_ring_passed.emit(score)
