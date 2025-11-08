@tool
@abstract
extends Area3D
class_name Ring



@onready var manager: RingManager = %RingManager



@onready var mesh:= get_child(0)
@export var base_material: Material
@export var passed_material: Material
var ring_material: StandardMaterial3D  # Stocker le matériau dupliqué
var mesh_instance : Node3D

func _ready() -> void:
	# Créer une copie du matériau une seule fois
	mesh_instance = mesh.get_child(0)
	mesh_instance.set_surface_override_material(0, base_material)
	body_entered.connect(_on_body_entered)
	_ring_ready()

func _ring_ready():
	pass

@abstract
func ring_passed() -> void


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		ring_passed()
