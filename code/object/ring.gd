@tool
@abstract
extends Area3D
class_name Ring

## S'autodéfinit normalement, référence au ring manager de la scene
@export var manager: RingManager
## Défini dans la scene de l'anneau, référence au mesh instance de l'anneau.
@export var mesh_instance: MeshInstance3D
## Material lorsque l'anneau n'a pas encore été passé
@export var base_material: Material
## Material lorsque l'anneau a été passé.
@export var passed_material: Material

# Fonction appelée par le ring manager, pour setup la base de l'anneau
func _setup(_manager: RingManager):
	mesh_instance.set_surface_override_material(0, base_material)
	body_entered.connect(_on_body_entered)
	manager = _manager
	_ring_setup()

# Continuation du setup initié par le manager pour les cas spécifiques de sous-classe
func _ring_setup():
	pass

# Fonction appelée lors d'une collision entre l'avion et un anneau.
@abstract
func ring_passed(score: float) -> void

# Collision avec l'avion et détermination du score
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		var score : float = 2.0 - (basis.z - body.basis.z).length()
		if body.brake > 0.0:
			score *= 1.0 + body.brake
		ring_passed(score)
