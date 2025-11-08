@tool
@abstract
extends Area3D
class_name Ring



var manager: RingManager


@export var mesh_instance: MeshInstance3D
@export var mesh : Node3D
@export var base_material: Material
@export var passed_material: Material
var ring_material: StandardMaterial3D  # Stocker le matériau dupliqué

func _setup(_manager: RingManager):
	# Créer une copie du matériau une seule fois
	mesh_instance.set_surface_override_material(0, base_material)
	body_entered.connect(_on_body_entered)
	manager = _manager
	_ring_setup()



func _ring_setup():
	pass

@abstract
func ring_passed() -> void


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		ring_passed()
