extends Area3D
class_name Ring

@export var ring_order := 0
var is_active := false
@onready var mesh:= get_child(0)
@export var base_material: Material = preload("res://assets/materials_textures/ring/basse.tres")
@export var next_material: Material = preload("res://assets/materials_textures/ring/next.tres")
@export var active_material: Material = preload("res://assets/materials_textures/ring/active.tres")
@export var passed_material: Material = preload("res://assets/materials_textures/ring/passed.tres")
var ring_material: StandardMaterial3D  # Stocker le matériau dupliqué
var mesh_instance : Node3D

func _ready() -> void:
	# Créer une copie du matériau une seule fois
	mesh_instance = mesh.get_child(0)
	mesh_instance.set_surface_override_material(0, base_material)
	body_entered.connect(_on_body_entered)

func set_active(active: bool, is_next:= false) -> void:
	is_active = active
	
	if is_active:
		mesh_instance.set_surface_override_material(0, base_material)
		print("Ring activated: ", ring_order)
	elif is_next:
		mesh_instance.set_surface_override_material(0, next_material)
	else:
		mesh_instance.set_surface_override_material(0, passed_material)


func _on_body_entered(body: Node) -> void:
	print("Body entered: ", body.name)
	print("is_active: ", is_active, " - Ring order: ", ring_order)
	if is_active and body.is_in_group("player"):
		var ring_manager = get_tree().get_first_node_in_group("ring_manager")
		if ring_manager:
			ring_manager.on_ring_passed(ring_order)
