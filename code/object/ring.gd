extends Area3D

@export var ring_order := 0
var is_active := false
@export var mesh: Node3D
var ring_material: StandardMaterial3D  # Stocker le matériau dupliqué

func _ready() -> void:
	# Créer une copie du matériau une seule fois
	var mesh_instance = mesh.get_child(0)
	var original_material = mesh_instance.get_surface_override_material(0)
	ring_material = original_material.duplicate() if original_material else StandardMaterial3D.new()
	mesh_instance.set_surface_override_material(0, ring_material)

	if ring_order == 0:
		set_active(true)
	else:
		set_active(false)

	body_entered.connect(_on_body_entered)

func set_active(active: bool) -> void:
	is_active = active
	
	if is_active:
		ring_material.albedo_color = Color.GREEN
		ring_material.emission = Color.YELLOW * 0.9
		print("Ring activated: ", ring_order)
	else:
		ring_material.albedo_color = Color.GRAY
		ring_material.emission = Color.GRAY * 0.3


func _on_body_entered(body: Node) -> void:
	print("Body entered: ", body.name)
	print("is_active: ", is_active, " - Ring order: ", ring_order)
	if is_active and body.is_in_group("player"):
		get_tree().call_group("game_manager", "ring_passed", ring_order)
		set_active(false)
		get_tree().call_group("game_manager", "ring_passed", ring_order)
		set_active(false)
